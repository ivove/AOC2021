/// AOC 2021 DAy 18
Class AOC.Day18 Extends AOC.Base
{

Method Part1() As %Integer
{
    set sum = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
    while '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        set sum = ..Add(sum,line)
        set sum = ..Reduce(sum)
    }
    return ..Magnitude(sum)
}

Method Part2() As %Integer
{
    set max = 0
    set i = 0
    while '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        set i = i + 1
        set numbers(i) = line
    }

    for a=1:1:i {
        for b=1:1:i {
            if a '= b {
                set sum = ..Add(numbers(a),numbers(b))
                set sum = ..Reduce(sum)
                set mag = ..Magnitude(sum)
                if mag > max { set max = mag }
            }
        }
    }

    return max
}

Method Reduce(str As %String) As %String
{
    set cont = 1
    while cont {
        set num = 0
        set str = ..Explode(str,.num)
        //w "exp",*9,str,!
        set str = ..Split(str,.num)
        //w "spl",*9,str,!
        if num = 0 { set cont = 0 }
    }
    return str
}

Method Explode(str As %String, ByRef number As %String) As %String
{
    set cnt = 0
    set pos = 1
    while pos < $LENGTH(str) {
        set c = $EXTRACT(str,pos)
        if c = "[" { set cnt = cnt + 1 }
        elseif c = "]" { set cnt = cnt - 1 }
        if cnt = 5 {
            // explode
            set number = number + 1
            set sub = $EXTRACT(..GetSub(str,pos),2,*-1)
            set a = $PIECE(sub,",",1)
            set b = $PIECE(sub,",",2)
            set first = $EXTRACT(str,1,pos-1)
            set xpos = pos-1
            set fnd = 0
            while xpos>0,fnd=0 {
                set t = $EXTRACT(first,xpos)
                if t?1N {
                    if $EXTRACT(first,xpos-1)?1N { set t = $EXTRACT(first,xpos-1)_t }
                    set nt = t + a
                    set first = $EXTRACT(first,1,xpos-$LENGTH(t))_nt_$EXTRACT(first,xpos+1,*)
                    set fnd = 1
                }
                set xpos = xpos - 1
            }
            set second = $EXTRACT(str,pos+$LENGTH(sub)+2,*)
            set xpos = 1
            set fnd = 0
            while xpos < $LENGTH(second),fnd=0 {
                set t = $EXTRACT(second,xpos)
                if t?1N {
                    if $EXTRACT(second,xpos+1)?1N { set t = t_$EXTRACT(second,xpos+1) }
                    set nt = t + b
                    set second = $EXTRACT(second,1,xpos-1)_nt_$EXTRACT(second,xpos+$LENGTH(t),*)
                    set fnd = 1
                }
                set xpos = xpos + 1
            }
            set str = first_"0"_second
            //w sub,"|",*9,a,"|",*9,b,"|",!,str,!
            set pos = 0
            set cnt = 0
        }
        set pos = pos + 1
    }
    return str
}

Method Split(str As %String, ByRef number As %String) As %String
{
    set pos = 1
    set fnd = 0
    while pos < $LENGTH(str),fnd = 0 {
        set c = $EXTRACT(str,pos)
        if c?1N {
            if $EXTRACT(str,pos+1)?1N {
                set fnd = 1
                set c = $EXTRACT(str,pos,pos+1)
                set a = c\2
                set b = (c+1)\2
                set new = "["_a_","_b_"]"
                set str = $EXTRACT(str,1,pos-1)_new_$EXTRACT(str,pos+2,*)
                set number = number + 1
            }
        }
        set pos = pos + 1
    }
    return str
}

Method Add(str1 As %String, str2 As %String) As %String
{
    return "["_str1_","_str2_"]"
}

Method Magnitude(str As %String) As %Integer
{
    set result = 0
    set str = $EXTRACT(str,2,*-1)
    if $EXTRACT(str,1) = "[" {
        set sub = ..GetSub(str,1)
        set result = 3 * ..Magnitude(sub)
        set str = $EXTRACT(str,$LENGTH(sub)+2,*)
    } else {
        set result = 3 * $EXTRACT(str,1)
        set str = $EXTRACT(str,3,*)
    }

    if $EXTRACT(str,1) = "[" {
        set sub = ..GetSub(str,1)
        set result = result + (2 * ..Magnitude(sub))
    } else {
        set result = result + (2 * $EXTRACT(str,1))
    }
    return result
}

Method GetSub(str As %String, start As %Integer) As %String
{
    set cnt = 1
    set pos = 1
    while cnt > 0 {
        set c = $EXTRACT(str,start + pos)
        if c = "[" { set cnt = cnt + 1 }
        elseif c = "]" { set cnt = cnt - 1 }
        set pos = pos + 1
    }
    return $EXTRACT(str,start,start + pos - 1)
}

}
