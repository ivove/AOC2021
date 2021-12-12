/// AOC 2021 Day 10
Class AOC.Day10 Extends AOC.Base
{

Method Part1() As %Integer
{
    Set result = 0
    Set score(")")=3,score("]")=57,score("}")=1197,score(">")=25137
    While '..File.AtEnd {
        Write !
        Set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        Set len = $LENGTH(line)
        Set closing = ""
        Set current = ""
        Set illegal = ""
        //If (len#2) = 0 {
            For i=1:1:len {
                Set char = $EXTRACT(line,i)
                If char = "(" { Set current = ")",closing = closing_")" }
                ElseIf char = "[" { Set current = "]",closing = closing_"]" }
                ElseIf char = "{" { Set current = "}",closing = closing_"}" }
                ElseIf char = "<" { Set current = ">",closing = closing_">" }
                Else {
                    If char = current {
                        //Write 1,*9,closing,*9,current,!
                        Set closing = $EXTRACT(closing,1,*-1)
                        Set current = $EXTRACT(closing,*)
                        //Write 2,*9,closing,*9,current,!
                    } Else {
                        Set illegal = char
                        Set i = len
                    }
                }
            }
            If illegal'="" {
                Write illegal,*9,score(illegal),!
                Set result = result + score(illegal)
            }
        //}
    }
    Return result
}

Method Part2() As %Integer
{
    Set result = ""
    Set score(")")=1,score("]")=2,score("}")=3,score(">")=4
    While '..File.AtEnd {
        Set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        Set len = $LENGTH(line)
        Set closing = ""
        Set current = ""
        Set illegal = ""
        //If (len#2) = 0 {
            For i=1:1:len {
                Set char = $EXTRACT(line,i)
                If char = "(" { Set current = ")",closing = closing_")" }
                ElseIf char = "[" { Set current = "]",closing = closing_"]" }
                ElseIf char = "{" { Set current = "}",closing = closing_"}" }
                ElseIf char = "<" { Set current = ">",closing = closing_">" }
                Else {
                    If char = current {
                        //Write 1,*9,closing,*9,current,!
                        Set closing = $EXTRACT(closing,1,*-1)
                        Set current = $EXTRACT(closing,*)
                        //Write 2,*9,closing,*9,current,!
                    } Else {
                        Set illegal = char
                        Set i = len
                    }
                }
            }
            If illegal="" {
                Set temp = 0
                //Write line,*9,closing,!
                For i=$LENGTH(closing):-1:1 {
                    Set temp = (temp * 5) + score($EXTRACT(closing,i))
                }
                Set scores(temp)=""
                Set scores=$GET(scores) + 1
            }
        //}
    }
    //ZWrite scores
    Set todo = ((scores - 1) / 2) + 1
    For i=1:1:todo {
        Set result = $ORDER(scores(result))
    }
    Return result
}

}
