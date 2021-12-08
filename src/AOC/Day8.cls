/// AOC 2021 Day 8
Class AOC.Day8 Extends AOC.Base
{

Method Part1() As %Integer
{
    Set number = 0
    While '..File.AtEnd {
        Set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        Set output = $PIECE(line,"|",2)
        Set len = $LENGTH(output," ")
        For i=2:1:len {
            Set digit = $PIECE(output," ",i)
            Write digit,!
            If $LENGTH(digit) = 2 { Set number = number + 1 }
            If $LENGTH(digit) = 7 { Set number = number + 1 }
            If $LENGTH(digit) = 3 { Set number = number + 1 }
            If $LENGTH(digit) = 4 { Set number = number + 1 }
        }
    }
    Return number
}

}
