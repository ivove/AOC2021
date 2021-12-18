/// AOC 2021 Day 17
Class AOC.Day17 Extends %RegisteredObject
{

Method Part1(test = 0) As %Integer
{
    //target area: x=206..250, y=-105..-57
    set minX = 206
    set maxX = 250
    set minY = -105
    set maxY = -57
    i test {
        set minX = 20
        set maxX = 30
        set minY = -10
        set maxY = -5
    }
    set result = 0
    for x=0:1:maxX {
        for y=$ZABS(minY):-1:minY {
            set hit = ..TestVelocity(x,y,minX,maxX,minY,maxY,.hx,.hy)
            if hit,hy>result {
                set result = hy
            }
        }
    }
    return result
}

Method Part2(test = 0) As %Integer
{
    //target area: x=206..250, y=-105..-57
    set minX = 206
    set maxX = 250
    set minY = -105
    set maxY = -57
    i test {
        set minX = 20
        set maxX = 30
        set minY = -10
        set maxY = -5
    }
    set result = 0
    for x=0:1:maxX {
        for y=$ZABS(minY):-1:minY {
            set hit = ..TestVelocity(x,y,minX,maxX,minY,maxY,.hx,.hy)
            if hit {
                set coord = x_","_y
                set x(coord)=""
            }
        }
    }
    set c = $ORDER(x(""))
    while c '= "" {
        set result = result + 1
        set c = $ORDER(x(c))
    }
    return result
}

Method TestVelocity(xVelocity As %Integer, yVelocity As %Integer, targetMinX As %Integer, targetMaxX As %Integer, targetMinY As %Integer, targetMaxY As %Integer, ByRef hitX, ByRef hitY) As %Boolean
{
    set cont = 1
    set hit = 0
    set x = 0
    set y = 0
    set dxv = 1
    set hy = 0
    if xVelocity > 0 { set dxv = -1 }
    while cont {
        set dist1 = $ZSQR(((targetMaxX-x)**2)+((targetMinY-y)**2))
        //w x,*9,y,*9,dist1,!
        set x = x + xVelocity
        set y = y + yVelocity
        if y>hy { set hy = y }
        set yVelocity = yVelocity - 1
        if xVelocity '= 0 { set xVelocity = xVelocity + dxv }
        if ..IsHit(x,y,targetMinX,targetMaxX,targetMinY,targetMaxY) {
            set hit = 1
            set cont = 0
            set hitX = x
            set hitY = hy
        }
        set dist2 = $ZSQR(((targetMaxX-x)**2)+((targetMinY-y)**2)) 
        //w x,*9,y,*9,dist2,!,!
        if y<0,dist2>dist1 { set cont = 0 }
    }
    return hit
}

Method IsHit(x As %Integer, y As %Integer, targetMinX As %Integer, targetMaxX As %Integer, targetMinY As %Integer, targetMaxY As %Integer) As %Boolean
{
    set hit = 0
    if x>=targetMinX,x<=targetMaxX {
        if y>=targetMinY,y<=targetMaxY {
            set hit = 1
        }
    }
    return hit
}

}
