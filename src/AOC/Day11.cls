/// AOC 2021 Day 11
Class AOC.Day11 Extends AOC.Base
{

Method Part1(steps As %Integer) As %Integer
{
    Set result = 0
    Set y = 1
    While '..File.AtEnd {
        Set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        Set len = $LENGTH(line)
        For x=1:1:len {
            Set map(x,y) = $EXTRACT(line,x)
        }
        Set y = y + 1
    }
    For i=1:1:steps {
        Set number = ..step(.map)
        //Write i,*9,number,!
        Set result = result + number
    }
    Return result
}

Method Part2() As %Integer
{
    Set result = 0
    Set y = 1
    While '..File.AtEnd {
        Set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        Set len = $LENGTH(line)
        For x=1:1:len {
            Set map(x,y) = $EXTRACT(line,x)
        }
        Set y = y + 1
    }
    Set steps = 0
    Set cont = 1
    While cont {
        Set steps = steps + 1
        Set number = ..step(.map)
        If number = 100 {
            Set cont = 0
        }
    }
    Return steps
}

Method step(ByRef map) As %Integer
{
    Set flashes = 0
    Set x = $ORDER(map(""))
    While x '= "" {
        Set y = $ORDER(map(x,""),1,val)
        While y '= "" {
            Set val = val + 1
            Set map(x,y) = val
            If val = 10 {
                Set flashed(x,y) = ""
                Do ..flash(.map,.flashed,x,y)
            }
            Set y = $ORDER(map(x,y),1,val)
        }
        Set x = $ORDER(map(x))
    }
    /*
    Set x = $ORDER(map(""))
    While x '= "" {
        Set y = $ORDER(map(x,""),1,val)
        While y '= "" {
            If '$DATA(flashed(x,y)),val > 10 {
                Set flashed(x,y) = ""
                Do ..flash(.map,.flashed,x,y)
            }
            Set y = $ORDER(map(x,y),1,val)
        }
        Set x = $ORDER(map(x))
    }
    */
    Set x = $ORDER(map(""))
    While x '= "" {
        Set y = $ORDER(map(x,""),1,val)
        While y '= "" {
            If map(x,y)>9 { Set map(x,y) = 0,flashes = flashes + 1 }
            Set y = $ORDER(map(x,y),1,val)
        }
        Set x = $ORDER(map(x))
    }

    //Do ..show(.map)
    //ZWrite flashed
    Return flashes
}

Method flash(ByRef map, ByRef flashed, x, y)
{
    For dx=-1:1:1 {
        For dy=-1:1:1 {
            If $DATA(map(dx+x,dy+y)){
                Set newval = map(dx+x,dy+y) + 1
                Set map(dx+x,dy+y) = newval
                If '$DATA(flashed(dx+x,dy+y)), newval = 10 {
                    Set flashed(dx+x,dy+y) = ""
                    Do ..flash(.map,.flashed,dx+x,dy+y)
                }
            }
        }
    }
}

Method show(ByRef map)
{
    Write !
    Kill s
    Set x = $ORDER(map(""))
    While x '= "" {
        Set y = $ORDER(map(x,""),1,val)
        While y '= "" {
            Set s(y)=$GET(s(y))_val
            Set y = $ORDER(map(x,y),1,val)
        }
        Set x = $ORDER(map(x))
    }
    Set y=$ORDER(s(""))
    While y'=""{
        Write s(y),!
        Set y=$ORDER(s(y))
    }
    Write !
}

}
