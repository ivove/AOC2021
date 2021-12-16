/// AOC 2021 Day14
Class AOC.Day14 Extends AOC.Base
{

Method Part1(steps As %Integer) As %Integer
{
    set result = 0
    set template = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
    do ..File.ReadLine()
    while '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$CHAR(13)_" -","")
        set from = $PIECE(line,">",1)
        set to = $PIECE(line,">",2)
        set sub(from)=to
    }
    for i=1:1:steps {
        set newstr = $EXTRACT(template,1)
        set len = $LENGTH(template)
        for c=1:1:len-1 {
            set part = $EXTRACT(template,c,c+1)
            set add = $GET(sub(part),"")
            set newstr = newstr_add_$EXTRACT(part,2)
        }
        set template = newstr
    }
    set len = $LENGTH(template)
    for c=1:1:len {
        set char = $EXTRACT(template,c)
        set count(char) = $GET(count(char)) + 1
    }
    set max = 0
    set min = 999999999
    set char = $ORDER(count(""),1,val)
    while char '= "" {
        if val < min { set min = val }
        if val > max { set max = val }
        set char = $ORDER(count(char),1,val)
    }
    //w template,!
    //zw count
    return max-min
}

Method Part1v2(steps As %Integer) As %Integer
{
    set result = 0
    set template = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
    do ..File.ReadLine()
    while '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$CHAR(13)_" -","")
        set from = $PIECE(line,">",1)
        set to = $PIECE(line,">",2)
        set sub(from)=to
    }
    set len = $LENGTH(template)
    for i=1:1:len-1
    {
        set pair = $EXTRACT(template,i,i+1)
        do ..go(1,pair,steps,.sub,.count)
    }
    set max = 0
    set min = 999999999
    set char = $ORDER(count(""),1,val)
    while char '= "" {
        if val < min { set min = val }
        if val > max { set max = val }
        set char = $ORDER(count(char),1,val)
    }
    //w template,!
    //zw count
    return max-min
}

Method count(str, table)
{
    set len = $LENGTH(str)
    for i=1:1:len
    {
        set char = $EXTRACT(str,i)
        set table(char) = $GET(table(char)) + 1
    }
}

Method go(step, template, steps, sub, count)
{
    if step<=steps {
        set np1 = $EXTRACT(template,1)_sub(template)
        set np2 = sub(template)_$EXTRACT(template,2)
        do ..go(step+1,np1,steps,.sub,.count)
        do ..go(step+1,np2,steps,.sub,.count)
    } else {
        set count($EXTRACT(template,1)) = $GET(count($EXTRACT(template,1))) + 1
    }
}

Method Part2(steps As %Integer) As %Integer
{
    set result = 0
    set template = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
    set len = $LENGTH(template)
    for i=1:1:len {
        set val = $LISTBUILD($EXTRACT(template,i))
        if i<len {
            set $li(val,2) = i+1
        }
        set ^||list(i)=val
    }
    set ^||list = len
    do ..File.ReadLine()
    while '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$CHAR(13)_" -","")
        set from = $PIECE(line,">",1)
        set to = $PIECE(line,">",2)
        set sub(from)=to
    }
    for i=1:1:steps {
        set next = 1
        while next {
            set v1 = ^||list(next)
            if $ll(v1) = 2 {
                set v2 = ^||list($li(v1,2))
                set pair = $list(v1,1)_$list(v2,1)
                set insert = $GET(sub(pair),"")
                if insert '= "" {
                    set nv = $LISTBUILD(insert,$li(v1,2))
                    set ^||list = ^||list + 1
                    set ^||list(^||list)=nv
                }
                set $li(^||list(next),2) = ^||list
                set next = $li(v1,2)

            } else {
                set next = ""
            }
        }
    }
    set x = $ORDER(^||list(""))
    while x '= "" {
        set char = $Li(^||list(x),1)
        set count(char) = $GET(count(char)) + 1
        set x = $ORDER(^||list(x))
    }
    set max = 0
    set min = 999999999
    set char = $ORDER(count(""),1,val)
    while char '= "" {
        if val < min { set min = val }
        if val > max { set max = val }
        set char = $ORDER(count(char),1,val)
    }
    //w template,!
    //zw count
    return max-min
}

}
