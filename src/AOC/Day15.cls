/// AOC 2021 day 15
Class AOC.Day15 Extends AOC.Base
{

Method Part1() As %Integer
{
    set y = 1
    while '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        set len = $LENGTH(line)
        set endx = len
        for x=1:1:len {
            set map(x,y) = $EXTRACT(line,x)
        }
        set y = y + 1
    }
    set endy = y-1
    set risk = 0
    set y = 1
    for x=1:1:endx{
        set risk = risk + map(x,y)
        set y = y+1
        if y<11 { set risk = risk + map(x,y) }
    }
    //w risk,!,!
    set cont = 1
    set risk = (endx+endy)*9
    //while cont {
        do ..go(.map,1,1,endy,endx,"/",.risk,.p)
        //if $data(p) { set cont = 0 }
        //else { set risk = risk + 1 }
        //zw p
        //w risk,*9,cont,!
    //}

    
    return risk - map(1,1)
}

Method Part1v2() As %Integer
{
    set y = 1
    while '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        set len = $LENGTH(line)
        set endx = len
        for x=1:1:len {
            set map(x,y) = $LISTBUILD($EXTRACT(line,x),-1)
        }
        set y = y + 1
    }
    set endy = y-1
    set que(1) = $LISTBUILD(1,1)
    set $LI(map(1,1),2) = +$LI(map(1,1),1)
    while $DATA(que) {
        set c = $ORDER(que(""),-1)
        set coord = que(c)
        //zw coord
        kill que(c)
        set x = $LI(coord,1),y=$LI(coord,2)
        if $DATA(map(x+1,y)) {
            if $LIST(map(x+1,y),2) = -1 {
                set c = c + 1
                set que(c) = $LISTBUILD(x+1,y)
                set $LIST(map(x+1,y),2) = $LIST(map(x,y),2) + $LIST(map(x+1,y),1) 
            } elseif ($LIST(map(x,y),2) + $LIST(map(x+1,y),1)) < $LIST(map(x+1,y),2) {
                set c = c + 1
                set que(c) = $LISTBUILD(x+1,y)
                set $LIST(map(x+1,y),2) = $LIST(map(x,y),2) + $LIST(map(x+1,y),1) 
            }
        }
        if $DATA(map(x-1,y)) {
            if $LIST(map(x-1,y),2) = -1 {
                set c = c + 1
                set que(c) = $LISTBUILD(x-1,y)
                set $LIST(map(x-1,y),2) = $LIST(map(x,y),2) + $LIST(map(x-1,y),1) 
            } elseif ($LIST(map(x,y),2) + $LIST(map(x-1,y),1)) < $LIST(map(x-1,y),2) {
                set c = c + 1
                set que(c) = $LISTBUILD(x-1,y)
                set $LIST(map(x-1,y),2) = $LIST(map(x,y),2) + $LIST(map(x-1,y),1) 
            }
        }
        if $DATA(map(x,y+1)) {
            if $LIST(map(x,y+1),2) = -1 {
                set c = c + 1
                set que(c) = $LISTBUILD(x,y+1)
                set $LIST(map(x,y+1),2) = $LIST(map(x,y),2) + $LIST(map(x,y+1),1) 
            } elseif ($LIST(map(x,y),2) + $LIST(map(x,y+1),1)) < $LIST(map(x,y+1),2) {
                if x=1,(y+1)=3
                {
                    w $LIST(map(x,y+1),2),!,($LIST(map(x,y),2) + $LIST(map(x,y+1),1)),!
                    r xx
                }
                set c = c + 1
                set que(c) = $LISTBUILD(x,y+1)
                set $LIST(map(x,y+1),2) = $LIST(map(x,y),2) + $LIST(map(x,y+1),1) 
            }
        }
        if $DATA(map(x,y-1)) {
            if $LIST(map(x,y-1),2) = -1 {
                set c = c + 1
                set que(c) = $LISTBUILD(x,y-1)
                set $LIST(map(x,y-1),2) = $LIST(map(x,y),2) + $LIST(map(x,y-1),1) 
            } elseif ($LIST(map(x,y),2) + $LIST(map(x,y-1),1)) < $LIST(map(x,y-1),2) {
                set c = c + 1
                set que(c) = $LISTBUILD(x,y-1)
                set $LIST(map(x,y-1),2) = $LIST(map(x,y),2) + $LIST(map(x,y-1),1) 
            }
        }
        //zw que
    }
    zw map
    return ($LIST(map(endx,endy),2) - $LIST(map(1,1),1))
}

Method Part1v3() As %Integer
{
    set y = 1
    while '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        set len = $LENGTH(line)
        set endx = len
        for x=1:1:len {
            set map(x,y) = $LISTBUILD($EXTRACT(line,x),-1,0)
        }
        set y = y + 1
    }
    set endy = y-1

    set x = $ORDER(map(""))
    while x '= "" {
        set y = $ORDER(map(x,""))
        while y '= "" {
            set guess = (endx - x) + (endy - y)
            set $LIST(map(x,y),3) = guess
            set y = $ORDER(map(x,y))
        }
        set x = $ORDER(map(x))
    }

    set que(1,1) = $LISTBUILD(1,1)
    set $LI(map(1,1),2) = +$LI(map(1,1),1)
    set gc = 1
    while $DATA(que) {
        set g = $ORDER(que(""))
        set c = $ORDER(que(g,""))
        set coord = que(g,c)
        //zw coord
        kill que(g,c)
        set x = $LI(coord,1),y=$LI(coord,2)
        do ..Eval(x,y,x+1,y,.map,.gc,.que,endx,endy)
        do ..Eval(x,y,x-1,y,.map,.gc,.que,endx,endy)
        do ..Eval(x,y,x,y+1,.map,.gc,.que,endx,endy)
        do ..Eval(x,y,x,y-1,.map,.gc,.que,endx,endy)
        //zw que
    }
    zw map
    return ($LIST(map(endx,endy),2) - $LIST(map(1,1),1))
}

Method Eval(x, y, nx, ny, map, gc, que, endx, endy)
{
    if $DATA(map(nx,ny)) {
        if $LIST(map(nx,ny),2) = -1 {
            set gc = gc + 1
            set que($LIST(map(nx,ny),3)+$LIST(map(x,y),2),gc) = $LISTBUILD(nx,ny)
            set $LIST(map(nx,ny),2) = $LIST(map(x,y),2) + $LIST(map(nx,ny),1) 
        } elseif ($LIST(map(x,y),2) + $LIST(map(nx,ny),1)) < $LIST(map(nx,ny),2) {
            set gc = gc + 1
            set que($LIST(map(nx,ny),3)+$LIST(map(x,y),2),gc) = $LISTBUILD(nx,ny)
            set $LIST(map(nx,ny),2) = $LIST(map(x,y),2) + $LIST(map(nx,ny),1) 
        }
    }
    //if nx=endx,ny=endy { kill que }
}

Method go(map, x, y, endy, endx, currentPath, risk, paths)
{
    set coord = x_"."_y
    if currentPath '[ ("/"_coord_"/") {        
        set currentPath = currentPath_coord_"/"
        if coord = (endx_"."_endy) {
            set currentPath = currentPath_coord
            set r = ..getRisk(currentPath,.map)
            //w !,r,!,currentPath,!
            if r < risk { 
                set risk = r 
                write risk,!
                set paths(currentPath) = r
            }
        } else {
            if (..getRisk(currentPath,.map)<risk) {
                if x+1<=endx {
                    do ..go(.map,x+1,y,endy,endx,currentPath,.risk)
                }
                if x>1 {
                    do ..go(.map,x-1,y,endy,endx,currentPath,.risk)
                }
                if y+1<=endy {
                    do ..go(.map,x,y+1,endy,endx,currentPath,.risk)
                }
                if y>1 {
                    do ..go(.map,x,y-1,endy,endx,currentPath,.risk)
                }
            }
        }
    }
}

Method getRisk(path, map)
{
    set r = 0
    set len = $LENGTH(path,"/")
    for s =2:1:len-1 {
        set coord = $PIECE(path,"/",s)
        set x = $PIECE(coord,".",1)
        set y = $PIECE(coord,".",2)
        set r = r + map(x,y)
    }
    return r
}

Method Part2() As %Integer
{
     set y = 1
    while '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        set len = $LENGTH(line)
        set endx = len
        for x=1:1:len {
            set map(x,y) = $LISTBUILD($EXTRACT(line,x),-1,0)
        }
        set y = y + 1
    }
    set endy = y-1
    do ..ExpandMap(.map,endx,endy)
    set endx = endx * 5
    set endy = endy * 5
    set x = $ORDER(map(""))
    while x '= "" {
        set y = $ORDER(map(x,""))
        while y '= "" {
            set guess = (endx - x) + (endy - y)
            set $LIST(map(x,y),3) = guess
            set y = $ORDER(map(x,y))
        }
        set x = $ORDER(map(x))
    }

    set que(1,1) = $LISTBUILD(1,1)
    set $LI(map(1,1),2) = +$LI(map(1,1),1)
    set gc = 1
    while $DATA(que) {
        set g = $ORDER(que(""))
        set c = $ORDER(que(g,""))
        set coord = que(g,c)
        //zw coord
        kill que(g,c)
        set x = $LI(coord,1),y=$LI(coord,2)
        do ..Eval(x,y,x+1,y,.map,.gc,.que,endx,endy)
        do ..Eval(x,y,x-1,y,.map,.gc,.que,endx,endy)
        do ..Eval(x,y,x,y+1,.map,.gc,.que,endx,endy)
        do ..Eval(x,y,x,y-1,.map,.gc,.que,endx,endy)
        //zw que
    }
    //zw map
    return ($LIST(map(endx,endy),2) - $LIST(map(1,1),1))
}

Method ExpandMap(map, endx, endy)
{
    for i=0:1:4 {
        for j=0:1:4 {
            for x=1:1:endx {
                for y=1:1:endy {
                    if '((i=0)&&(j=0)) {
                        set nx = x+(i*endx)
                        set ny = y+(j*endy)
                        set nval = $LIST(map(x,y),1) + j + i
                        if nval >= 10 { set nval = nval-9 }
                        set map(nx,ny) = $LISTBUILD(nval,-1,0)
                    }
                }
            }
        }
    }
}

}
