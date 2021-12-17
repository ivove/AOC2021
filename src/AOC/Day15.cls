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
    set risk = endx+endy
    while cont {
        do ..go(.map,1,1,endy,endx,"/",.risk,.p)
        if $data(p) { set cont = 0 }
        else { set risk = risk + 1 }
        zw p
        w risk,*9,cont,!
    }

    
    return risk - map(1,1)
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

}
