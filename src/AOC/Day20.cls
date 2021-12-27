/// AOC 2021 Day 20
Class AOC.Day20 Extends AOC.Base
{

Method Part1(times As %Integer = 2) As %Integer
{
    set filter = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
    set len = $LENGTH(filter)
    for i=1:1:len {
        set c = $EXTRACT(filter,i)
        set mask(..Int2Bit(i-1)) = c
    }

    set maxX = 0
    set y = 0
    while '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        set y = y + 1
        set len = $LENGTH(line)
        set maxX = len
        for x=1:1:len {
            set c = $EXTRACT(line,x)
            set image(x,y) = c
        }
    }
    set maxY = y + 2
    set minX = -1
    set minY = -1
    set maxX = maxX + 2

    for i=1:1:times {
        do ..Show(.image)
        do ..Enhance(.image,.mask,.new,minX,minY,maxX,maxY)
        set minY = minY - 2
        set minX = minX - 2
        set maxX = maxX + 2
        set maxY = maxY + 2
        kill image
        merge image = new
    }
    do ..Show(.image)

    set count = 0
    set x = $ORDER(image(""))
    while x '= "" {
        set y = $ORDER(image(x,""),1,val)
        while y '= "" {
            if val = "#" { set count = count + 1 }
            set y = $ORDER(image(x,y),1,val)
        }
        set x = $ORDER(image(x))
    }
    return count
}

Method Show(ByRef image)
{
    set x = $ORDER(image(""))
    while x '= "" {
        set line = ""
        set y = $ORDER(image(x,""),1,val)
        while y '= "" {
            set line(y) = $GET(line(y))_val
            set y = $ORDER(image(x,y),1,val)
        }
        set x = $ORDER(image(x))
    }
    set y = $ORDER(line(""))
    while y '= "" {
        write line(y),!
        set y = $ORDER(line(y))
    }
    write !,!
}

Method Enhance(ByRef image, ByRef mask, ByRef new, minX, minY, maxX, maxY)
{
    kill new
    for x=minX:1:maxX {
        for y=minY:1:maxY {
            set m = ""
            for ny=(y-1):1:(y+1) {
                for nx=(x-1):1:(x+1) {
                    set m = m_$GET(image(nx,ny),".")
                }
            }
            set bm = ""
            for i=1:1:9 {
                if $EXTRACT(m,i)="#" { set bm = bm_1 }
                else { set bm = bm_0 }
            }
            if $DATA(image(x,y)) {
                set new(x,y)=mask(bm)
            } elseif (bm["1") {
                set new(x,y)=mask(bm)
            } else {
                set new(x,y)="."
            }
        }
    }
}

Method Int2Bit(num As %Integer) As %String
{
    set result = ""
    for i=8:-1:0
    {
        set x = num \ (2**i)
        set num = num # (2**i)
        set result = result_x
        
    }
    return result
}

}
