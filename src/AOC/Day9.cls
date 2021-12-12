/// AOC 2021 day9
Class AOC.Day9 Extends AOC.Base
{

Method Part1() As %Integer
{
    set risk = 0
    set y = 1
    set maxX = 0
    while '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        set len = $LENGTH(line)
        set maxX = len
        for i=1:1:len {
            set map(i,y) = $EXTRACT(line,i)
        }
        set y = y + 1
    }
    set maxY = y - 1
    set x = $ORDER(map(""))
    while x '= "" {
        set y = $ORDER(map(x,""),1,height)
        while y '= "" {
            set isLow = 1
            set upX = x - 1
            set upY = y + 1
            set downX = x + 1
            set downY = y - 1
            if upX>0,map(upX,y)<=height { set isLow = 0 }
            if isLow,downY>0,map(x,downY)<=height { set isLow = 0 }
            if isLow,downX<=maxX,map(downX,y)<=height { set isLow = 0 }
            if isLow,upY<=maxY,map(x,upY)<=height { set isLow = 0 }
            if isLow {
                set lowPoints = $GET(lowPoints) + 1
                set lowPoints(lowPoints) = height
            }
            set y = $ORDER(map(x,y),1,height)
        }
        set x = $ORDER(map(x))
    }
    for i=1:1:lowPoints {
        set risk = risk + (lowPoints(i) + 1)
    }
    return risk
}

Method Part2() As %Integer
{
    set risk = 0
    set y = 1
    set maxX = 0
    while '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        set len = $LENGTH(line)
        set maxX = len
        for i=1:1:len {
            set map(i,y) = $EXTRACT(line,i)
        }
        set y = y + 1
    }
    set maxY = y - 1
    set x = $ORDER(map(""))
    while x '= "" {
        set y = $ORDER(map(x,""),1,height)
        while y '= "" {
            set isLow = 1
            set upX = x - 1
            set upY = y + 1
            set downX = x + 1
            set downY = y - 1
            if upX>0,map(upX,y)<=height { set isLow = 0 }
            if isLow,downY>0,map(x,downY)<=height { set isLow = 0 }
            if isLow,downX<=maxX,map(downX,y)<=height { set isLow = 0 }
            if isLow,upY<=maxY,map(x,upY)<=height { set isLow = 0 }
            if isLow {
                set lowPoints = $GET(lowPoints) + 1
                set lowPoints(lowPoints) = $LISTBUILD(x,y)
            }
            set y = $ORDER(map(x,y),1,height)
        }
        set x = $ORDER(map(x))
    }
    set size = 0
    for i=1:1:lowPoints {
        set coord = lowPoints(i)
        set x = $LIST(coord,1)
        set y = $LIST(coord,2)
        set visited(x,y) = 1
        set size = 1 + ..getSize(x,y,.map,.visited)
        set sizes(size) = $GET(sizes(size)) + 1
    }
    set factor = 1
    set s = ""
    for i=1:1:3 {
        set s = $ORDER(sizes(s),-1,count)
        //w s,!
        set factor = factor * s
        set count = count - 1
        if count > 0 {
            set s = $ORDER(sizes(s),1)
        }
    }
    //zw sizes
    return factor
}

Method getSize(x, y, map, visited)
{
    set size = 0
    if '$GET(visited(x+1,y)),$GET(map(x+1,y),9)<9 {
        set visited(x+1,y) = 1
        set size = size + 1 + ..getSize(x+1,y,.map,.visited)
    }
    if '$GET(visited(x-1,y)),$GET(map(x-1,y),9)<9 {
        set visited(x-1,y) = 1
        set size = size + 1 + ..getSize(x-1,y,.map,.visited)
    }
    if '$GET(visited(x,y+1)),$GET(map(x,y+1),9)<9 {
        set visited(x,y+1) = 1
        set size = size + 1 + ..getSize(x,y+1,.map,.visited)
    }
    if '$GET(visited(x,y-1)),$GET(map(x,y-1),9)<9 {
        set visited(x,y-1) = 1
        set size = size + 1 + ..getSize(x,y-1,.map,.visited)
    }
    return size
}

}
