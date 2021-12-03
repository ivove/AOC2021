/// AOC 2021 Day 3
Class AOC.Day3 Extends %RegisteredObject
{

ClassMethod Part1() As %Integer
{
        #DIM filename As %String = "/shared/Day3.txt"  
        Set stream=##class(%Stream.FileBinary).%New()
        Set sc=stream.LinkToFile(filename)
        While 'stream.AtEnd {
            Set line = stream.ReadLine()
            set line = $TRANSLATE(line,$c(13),"")
            set len = $LENGTH(line)
            for i=len:-1:1 {
                set pos(len-i,$EXTRACT(line,i)) = $GET(pos(len-i,$EXTRACT(line,i))) + 1
            }
        } 
        set epsilon = 0
        set gamma = 0
        set p = $ORDER(pos(""))
        while p '= "" {
            if $GET(pos(p,1)) > $GET(pos(p,0)) {
                set gamma = gamma + (2**p)
            } else {
                set epsilon = epsilon + (2**p)
            }
            set p = $ORDER(pos(p))
        }
        Return gamma * epsilon
}

ClassMethod Part2() As %Integer
{
        #DIM filename As %String = "/shared/Day3.txt"  
        Set stream=##class(%Stream.FileBinary).%New()
        Set sc=stream.LinkToFile(filename)
        set idx = 0
        While 'stream.AtEnd {
            Set line = stream.ReadLine()
            set line = $TRANSLATE(line,$c(13),"")
            set all(idx)=line
            set idx = idx + 1
        } 
        m olist = all
        m clist = all
        set oxygen = 0
        set carbon = 0
        set pos = 1
        while ..len(.olist)>1 {
            set common = ..mostComon(.olist,pos)
            set idx = $ORDER(olist(""),1,val)
            while idx '= "" {
                if $EXTRACT(val,pos)'=common { kill olist(idx) }
                set idx = $ORDER(olist(idx),1,val)
            }
            set pos = pos + 1
        }
        zw olist
        set pos = 1
        while ..len(.clist)>1 {
            set common = ..mostComon(.clist,pos)
            set idx = $ORDER(clist(""),1,val)
            while idx '= "" {
                if $EXTRACT(val,pos)=common { kill clist(idx) }
                set idx = $ORDER(clist(idx),1,val)
            }
            set pos = pos + 1
        }
        set xx = $ORDER(olist(""),1,oval)
        set xx = $ORDER(clist(""),1,cval)
        set len = $LENGTH(oval)
        for i=len:-1:1 {
            set oxygen = oxygen + ($EXTRACT(oval,i)*(2**(len-i)))
        }
        for i=len:-1:1 {
            set carbon = carbon + ($EXTRACT(cval,i)*(2**(len-i)))
        }
        w !,oxygen,*9,carbon,!
        Return oxygen * carbon
}

ClassMethod len(ByRef list) As %Integer
{
    set len = 0
    set idx = $ORDER(list(""))
    while idx '= "" {
        set len = len + 1
        set idx = $ORDER(list(idx))
    }
    return len
}

ClassMethod mostComon(ByRef list, position As %Integer, prefered As %Integer = 1) As %Integer
{
    set result = prefered
    set on = 0
    set off = 0
    set idx = $ORDER(list(""),1,val)
    while idx '= "" {
        if $EXTRACT(val,position) { set on = on + 1 }
        else { set off = off + 1 }
        set idx = $ORDER(list(idx),1,val)
    }
    if on > off { set result = 1 }
    elseif off > on { set result = 0 }
    Return result
}

}
