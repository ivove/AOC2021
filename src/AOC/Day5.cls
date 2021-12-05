/// AOC2021 Day5
Class AOC.Day5 Extends AOC.Base
{

Method Part1() As %Integer
{
    While '..File.AtEnd {
        Set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        Set coord1 = $TRANSLATE($PIECE(line,"-",1)," ","")
        Set coord2 = $TRANSLATE($PIECE(line,"-",2)," >","")
        Set x1 = $PIECE(coord1,",",1)
        Set y1 = $PIECE(coord1,",",2)
        Set x2 = $PIECE(coord2,",",1)
        Set y2 = $PIECE(coord2,",",2)
        If (x1 = x2) || (y1 = y2) {
            Set lines = $GET(lines) + 1
            Set lines(lines) = $LISTBUILD(x1,y1,x2,y2)
        }
    }
    //ZWrite lines
    For i=1:1:lines {
        Set currentLine = lines(i)
        Set h = 0
        If $LIST(currentLine,2) = $LIST(currentLine,4) { Set h = 1 }
        If h {
            // horizontal
            Set y = $LIST(currentLine,2)
            Set x = $LIST(currentLine,1)
            Set maxx = $LIST(currentLine,3)
            If $LIST(currentLine,3) < x {
                Set x = $LIST(currentLine,3)
                Set maxx = $LIST(currentLine,1)
            }
            //Write "h",*9,x,*9,y,*9,maxx,!
            For j=x:1:maxx {
                Set grid(j,y) = $GET(grid(j,y)) + 1
            }
        } Else {
            // vertical
            Set x = $LIST(currentLine,1)
            Set y = $LIST(currentLine,2)
            Set maxy = $LIST(currentLine,4)
            If $LIST(currentLine,4) < y {
                Set y = $LIST(currentLine,4)
                Set maxy = $LIST(currentLine,2)
            }
            // Write "v",*9,x,*9,y,*9,maxy,!
            For j=y:1:maxy {
                Set grid(x,j) = $GET(grid(x,j)) + 1
            }
        }
    }
    //ZWrite grid
    Set count = 0
    Set x = $ORDER(grid(""))
    While x '= "" {
        Set y = $ORDER(grid(x,""),1,val)
        While y '= "" {
            If val>1 { Set count = count + 1 }
            Set y = $ORDER(grid(x,y),1,val)
        }
        Set x = $ORDER(grid(x))
    }
    Return count
}

Method Part2() As %Integer
{
    While '..File.AtEnd {
        Set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        Set coord1 = $TRANSLATE($PIECE(line,"-",1)," ","")
        Set coord2 = $TRANSLATE($PIECE(line,"-",2)," >","")
        Set x1 = $PIECE(coord1,",",1)
        Set y1 = $PIECE(coord1,",",2)
        Set x2 = $PIECE(coord2,",",1)
        Set y2 = $PIECE(coord2,",",2)
        Set lines = $GET(lines) + 1
        Set lines(lines) = $LISTBUILD(x1,y1,x2,y2)
    }
    //ZWrite lines
    For i=1:1:lines {
        Set currentLine = lines(i)
        Set h = 0
        Set v = 0
        If $LIST(currentLine,2) = $LIST(currentLine,4) { Set h = 1 }
        ElseIf $LIST(currentLine,1) = $LIST(currentLine,3) { Set v = 1 }
        If h {
            // horizontal
            Set y = $LIST(currentLine,2)
            Set x = $LIST(currentLine,1)
            Set maxx = $LIST(currentLine,3)
            If $LIST(currentLine,3) < x {
                Set x = $LIST(currentLine,3)
                Set maxx = $LIST(currentLine,1)
            }
            //Write "h",*9,x,*9,y,*9,maxx,!
            For j=x:1:maxx {
                Set grid(j,y) = $GET(grid(j,y)) + 1
            }
        } ElseIf v {
            // vertical
            Set x = $LIST(currentLine,1)
            Set y = $LIST(currentLine,2)
            Set maxy = $LIST(currentLine,4)
            If $LIST(currentLine,4) < y {
                Set y = $LIST(currentLine,4)
                Set maxy = $LIST(currentLine,2)
            }
            // Write "v",*9,x,*9,y,*9,maxy,!
            For j=y:1:maxy {
                Set grid(x,j) = $GET(grid(x,j)) + 1
            }
        } Else {
            Set x1 = $LIST(currentLine,1)
            Set x2 = $LIST(currentLine,3)
            Set y1 = $LIST(currentLine,2)
            Set y2 = $LIST(currentLine,4)
            Set xdir = 1
            Set ydir = 1
            If x2 < x1 { Set xdir = -1 }
            If y2 < y1 { Set ydir = -1 }
            //Write "d",*9,x1,*9,y1,*9,x2,*9,y2,*9,xdir,*9,ydir,!
            Set y = y1
            For x=x1:xdir:x2 {
                Set grid(x,y) = $GET(grid(x,y)) + 1
                Set y = y + ydir
            }
        }
    }
    //ZWrite grid
    Set count = 0
    Set x = $ORDER(grid(""))
    While x '= "" {
        Set y = $ORDER(grid(x,""),1,val)
        While y '= "" {
            If val>1 { Set count = count + 1 }
            Set y = $ORDER(grid(x,y),1,val)
        }
        Set x = $ORDER(grid(x))
    }
    Return count
}

}
