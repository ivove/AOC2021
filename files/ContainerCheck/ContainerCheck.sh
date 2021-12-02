#!/usr/bin/env bash
#
# ContainerCheck is a tool to simplify gathering data for InterSystems IRIS
# containers.  It should be used by running:
#
# # ContainerCheck.sh your-container-name
#
# Must be run as a user with access to the docker daemon, such as root.
# You must have write permissions on the current directory in order to
# write out the report file.

main() {
    checkUtilities;
    exit_if_error "Mandatory core utilities not found.  Cannot continue."

    setCONTAINER_NAME "$@";
    setTIMESTAMP;
    setREPORT_DIR_HOST;
    setREPORT_LOGFILE_HOST

    setDOCKER_VERSION;
    checkDockerDaemonAccess;
    # Now we know docker is in our path and we can run commands through the daemon
    runDockerInfo;
    runDockerInspect;

    setISC_PACKAGE_INSTANCENAME;
    setISC_PACKAGE_INSTALLDIR;
    setREPORT_DIR_CONTAINER;

    runSystemCheck;

    tarname="$TIMESTAMP.tar"
    tarball "$tarname";
    filename="$REPORT_DIR_HOST/$tarname.gz"

    echo
    echo
    echo "ContainerCheck complete.  FTP the following files to ISC Support:"
    if [ "$have_wc" -a "$have_cut" ]; then
        echo "$filename in binary mode -" $(wc --bytes "$filename" | cut -f1 -d' ') bytes
    else
        echo "$filename in binary mode"
    fi
}

# Check for the existence of various common shell utilities. These are very
# likely to be present in all Linuxes, even busybox/Alpine distributions.
checkUtilities() {
    have_date=0
    date >/dev/null
    if [ $? -eq 0 ]; then have_date=1; fi

    have_pwd=0
    pwd >/dev/null
    if [ $? -eq 0 ]; then have_pwd=1; fi

    # date and pwd and mandatory
    # cut and wc are not required

    have_cut=0
    cut -f1 /dev/null 2>/dev/null
    if [ $? -eq 0 ]; then have_cut=1; fi

    have_wc=0
    wc /dev/null >/dev/null 2>/dev/null
    if [ $? -eq 0 ]; then have_wc=1; fi

    if [[ "$have_date" -gt 0 && "$have_pwd" -gt 0 ]]; then
        return 0;
    else
        return 1;
    fi
}

setCONTAINER_NAME() {
    test -n "$1";
    if [ $? -gt 0 ]; then
        error "No container name specified.";
        cat <<EOT
Usage: ContainerCheck.sh container-name

Try running 'docker ps' or 'docker container ls' to see the names of containers on this host.
EOT
        exit 2
    fi
    export CONTAINER_NAME="$1"
}

setTIMESTAMP() {
    # date is in GNU coreutils
    export TIMESTAMP=$(date --utc +%Y%m%d%H%M%S)
    if [ $? -gt 0 ]; then
        # if it isn't, use this fallback
        export TIMESTAMP="PID-$$"
        error "Could not generate timestamp with GNU 'date' utility, using '$TIMESTAMP' as an identifier instead"
    fi
}

setISC_PACKAGE_INSTANCENAME() {
    export ISC_PACKAGE_INSTANCENAME=$(docker exec "$CONTAINER_NAME" bash -c 'echo $ISC_PACKAGE_INSTANCENAME')
    exit_if_error "Could not check container environment.  Cannot continue."
    test -n "$ISC_PACKAGE_INSTANCENAME"; 
    exit_if_error "ISC_PACKAGE_INSTANCENAME not set in container.  Images without this environment variable set are not supported."
}

setISC_PACKAGE_INSTALLDIR() {
    export ISC_PACKAGE_INSTALLDIR=$(docker exec "$CONTAINER_NAME" bash -c 'echo $ISC_PACKAGE_INSTALLDIR')
    exit_if_error "Could not check container environment.  Cannot continue."
    test -n "$ISC_PACKAGE_INSTALLDIR"; 
    exit_if_error "ISC_PACKAGE_INSTALLDIR not set in container.  Images without this environment variable set are not supported."
}

setDOCKER_VERSION() {
    export DOCKER_VERSION=$(docker -v)
    exit_if_error "No 'docker' binary found in your path.  Cannot continue."
}

setREPORT_DIR_HOST() {
    # pwd is in GNU coreutils
    export REPORT_DIR_HOST="$(pwd)/$TIMESTAMP"
    exit_if_error "Cannot run 'pwd'"
    mkdir "$REPORT_DIR_HOST"
    exit_if_error "Cannot mkdir '$REPORT_DIR_HOST'."
}

setREPORT_LOGFILE_HOST() {
    export REPORT_LOGFILE_HOST="$REPORT_DIR_HOST/ContainerCheck.$TIMESTAMP.log"
}

setREPORT_DIR_CONTAINER() {
    containerHome=$(docker exec "$CONTAINER_NAME" bash -c 'echo $HOME')
    exit_if_error "Could not detect \$HOME in container."
    export REPORT_DIR_CONTAINER="$containerHome/ContainerCheck/$TIMESTAMP"
}

checkDockerDaemonAccess() {
    docker info > /dev/null 2>&1
    if [ $? -gt 0 ]; then
        docker info > /dev/null # Present error message here
        error "This tool must be run as root or another user with access to the Docker daemon."
        exit 1
    fi
}

runDockerInfo() {
    # Now that we know we can run docker commands, put stderr in our file.
    # Sometimes docker emits non-fatal warnings to stderr and we want those.
    filename="$REPORT_DIR_HOST/docker-info.txt"
    docker info > "$filename" 2>&1
    exit_if_error "Cannot run 'docker info'.  This tool must be run as root or another user with access to the Docker daemon."
}

runDockerInspect() {
    filename="$REPORT_DIR_HOST/docker-inspect-$CONTAINER_NAME.txt"
    docker inspect "$CONTAINER_NAME" > "$filename"
    # We know we can "docker info", so a failure here has one likely cause.
    exit_if_error "Cannot run 'docker inspect $CONTAINER_NAME' - please double-check that your container name is correct."
}

runSystemCheck() {
    docker exec "$CONTAINER_NAME" mkdir -p "$REPORT_DIR_CONTAINER"
    exit_if_error "Could not make report directory '$REPORT_DIR_CONTAINER'"

    docker exec --env ISC_CONTAINERCHECK_REPORTDIR="$REPORT_DIR_CONTAINER" "$CONTAINER_NAME" iris session "$ISC_PACKAGE_INSTANCENAME" -U %SYS ContainerCheck^SystemCheck
    # ContainerCheck will exit to shell with code 1 on success, and code 0 on
    # failure.  This is the opposite of normal shell convention, but since
    # irissession returns 0 even in the case of <NOLINE> errors, this is our
    # best chance at an unambiguous exit code.
    test $? -eq 1; exit_if_error "Could not run SystemCheck."
}

tarball() {
    tarname="$1"
    # We invoke tar in the container, but create a file on the host by
    # redirecting stdout rather than using "tar cf" and copying it out.
    docker exec "$CONTAINER_NAME" bash -c 'cd "'"$REPORT_DIR_CONTAINER"'" && tar c *' > "$REPORT_DIR_HOST/$tarname"
    exit_if_error "Could not create '$tarname' - tar failed"
    cd "$REPORT_DIR_HOST" &&
    tar rf "$tarname" ./*.txt &&
    gzip "$tarname"
    cd ..
    exit_if_error "Could not add text files to '$REPORT_DIR_HOST/$tarname' - tar failed"
}

exit_if_error() {
    if [ $(($(echo "${PIPESTATUS[@]}" | tr -s ' ' +))) -ne 0 ]; then
        error "$1"
        exit 1
    fi
}

error() {
    printf "%s Error: $1\n" $(date '+%Y%m%d-%H:%M:%S:%N') 1>&2
}

main "$@";
exit $?
