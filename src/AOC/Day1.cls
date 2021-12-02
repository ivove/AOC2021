/// AOC 2021 Day1
Class OAC.Day1 Extends %RegisteredObject
{

/// Part1
ClassMethod Part1() As %Integer
{
        set number = 0
        #DIM filename As %String = "/shared/d1.txt"  
        Set stream=##class(%Stream.FileBinary).%New()
        Set sc=stream.LinkToFile(filename)
        set pline = ""
        While 'stream.AtEnd {
            Set line = stream.ReadLine()
            if pline '= "" {
                if line>pline { s number = number + 1 }
            }
            set pline = line
        } 
        return number
}

ClassMethod Part2() As %Integer
{
        set number = 0
        #DIM filename As %String = "/shared/d1.txt"  
        Set stream=##class(%Stream.FileBinary).%New()
        Set sc=stream.LinkToFile(filename)
        set i = 1
        While 'stream.AtEnd {
            Set line = stream.ReadLine()
            set list(i) = line
            set i = i + 1
        }
        set s = 1
        for y = 1 : 1 : i-3 {
            set s(s) = list(y) + list(y+1) + list(y+2)
            set s = s + 1
        }
        for i=2:1:s-1 {
            if s(i) > s(i-1) { set number = number + 1}
        }
        return number
}

}
