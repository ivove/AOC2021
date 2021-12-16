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

}
