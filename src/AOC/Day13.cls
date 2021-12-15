/// AOC 2021 Day 13
Class AOC.Day13 Extends AOC.Base
{

Method Part1() As %Integer
{
    set instructions = 0
    while '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        if line = "" { set instructions = 1 }
        if instructions,line'="" {
            set instruction = $GET(instruction) + 1
            set instruction(instruction) = line
        } elseif line'="" {
            set x = $PIECE(line,",",1)
            set y = $PIECE(line,",",2)
            set map(x,y) = "#"
        }
    }
    set result = 0
    set inst = $PIECE(instruction(1)," ",3)
    //zw instruction
    //w inst
    do ..fold(.map,$PIECE(inst,"="),$PIECE(inst,"=",2))
    set x = $ORDER(map(""))
    while x '= "" {
        set y = $ORDER(map(x,""))
        while y '= "" {
            if map(x,y) = "#" { set result = result + 1 }
            set y = $ORDER(map(x,y))
        }
        set x = $ORDER(map(x))
    }
    //zw map
    return result
}

Method Part2() As %Integer
{
    set instructions = 0
    while '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        if line = "" { set instructions = 1 }
        if instructions,line'="" {
            set instruction = $GET(instruction) + 1
            set instruction(instruction) = line
        } elseif line'="" {
            set x = $PIECE(line,",",1)
            set y = $PIECE(line,",",2)
            set map(x,y) = "#"
        }
    }
    set result = 0
    for i=1:1:instruction {
        set inst = $PIECE(instruction(i)," ",3)
        do ..fold(.map,$PIECE(inst,"="),$PIECE(inst,"=",2))
    }
    zw map
    d ..show(.map)
    return result
}

Method fold(map, by, linenr)
{
    if (by = "x") {
        set x = $ORDER(map(linenr))
        while x '= "" {
            set newx = linenr-(x-linenr)
            set y = $ORDER(map(x,""))
            while y'="" {
                if '$DATA(map(newx,y)) { set map(newx,y) = map(x,y) }
                kill map(x,y)
                set y =$ORDER(map(x,y))
            }
            set x = $ORDER(map(x))
        }
    } else {
        set x = $ORDER(map(""))
        while x '= "" {
            set y = $ORDER(map(x,linenr))
            while y'="" {
            set newy = linenr-(y-linenr)
                if '$DATA(map(x,newy)) { set map(x,newy) = map(x,y) }
                kill map(x,y)
                set y =$ORDER(map(x,y))
            }
            set x = $ORDER(map(x))
        }
    }
}

Method show(map)
{
    for y = 1:1:5{
        for x = 1:1:80 {
            set s(y)=$GET(s(y))_$get(map(x,y)," ")
        }
    }
    for y=1:1:5{
        w s(y),!
    }
}

}
