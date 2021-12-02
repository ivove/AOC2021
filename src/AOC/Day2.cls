/// AOC2021 Day2
Class AOC.Day2 Extends %RegisteredObject
{

ClassMethod Part1() As %Integer
{
        Set depth = 0
        Set position = 0
        #DIM filename As %String = "/shared/d2.txt"  
        Set stream=##class(%Stream.FileBinary).%New()
        Set sc=stream.LinkToFile(filename)
        While 'stream.AtEnd {
            Set line = stream.ReadLine()
            Set dir = $PIECE(line," ",1)
            Set dist = $PIECE(line," ",2)
            If dir = "forward" { Set position = position + dist }
            ElseIf dir = "down" { Set depth = depth + dist }
            ElseIf dir = "up" { Set depth = depth - dist }
        } 
        Return depth * position
}

ClassMethod Part2() As %Integer
{
        Set depth = 0
        Set position = 0
        Set aim = 0
        #DIM filename As %String = "/shared/d2.txt"  
        Set stream=##class(%Stream.FileBinary).%New()
        Set sc=stream.LinkToFile(filename)
        While 'stream.AtEnd {
            Set line = stream.ReadLine()
            Set dir = $PIECE(line," ",1)
            Set dist = $PIECE(line," ",2)
            If dir = "forward" { 
                Set position = position + dist
                Set depth = depth + (aim * dist) 
            }
            ElseIf dir = "down" { Set aim = aim + dist }
            ElseIf dir = "up" { Set aim = aim - dist }
        } 
        Return depth * position
}

}
