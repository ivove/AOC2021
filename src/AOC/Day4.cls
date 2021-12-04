/// AOC2021 Day 4
Class OAC.Day4 Extends AOC.Base
{

Method Part1() As %Integer
{
    Set numbers = ..File.ReadLine()
    Set winner = 0
    Set bingoNr = 0
    Set lnr = 1
    While '..File.AtEnd {
        Set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        If line = "" { 
            Set bingoNr = bingoNr + 1 
            Set lnr = 1
        }
        Else {
            For i=1:1:5 {
                Set bingo(bingoNr,lnr,i) = $LISTBUILD($TRANSLATE($EXTRACT(line,3*(i-1)+1,3*(i-1)+3)," ",""),0)
            }
            Set lnr = lnr + 1
        }
    }
    Set num = 1
    While (winner = 0) && (num <= $LENGTH(numbers,",")) {
        Set current = $PIECE(numbers,",",num)
        Write current,!
        Do ..Mark(.bingo,current)
        Set winner = ..HasWinner(.bingo)
        Set num = num + 1
    }
    Write winner,!
    Return ..Score(.bingo,winner,$PIECE(numbers,",",num-1))
}

Method Mark(ByRef bingo, number As %Integer)
{
    Set bingoNr = $ORDER(bingo(""))
    While bingoNr '= "" {
        For line=1:1:5 {
            For i=1:1:5 {
                If $LIST(bingo(bingoNr,line,i),1) = number {
                    Set $LIST(bingo(bingoNr,line,i),2) = 1
                }
            }
        }
        Set bingoNr = $ORDER(bingo(bingoNr))
    }
}

Method HasWinner(ByRef bingo) As %Integer
{
    Set winner = 0
    Set bingoNr = $ORDER(bingo(""))
    While (bingoNr '= "") && (winner = 0) {
        Kill col
        For line=1:1:5 {
            Set row = 0
            For i=1:1:5 {
                If $LIST(bingo(bingoNr,line,i),2) { 
                    Set row = row + 1
                    Set col(i) = $GET(col(i)) + 1
                }
            }
            If row = 5 { Set winner = bingoNr }
        }
        For i=1:1:5
        {
            If $GET(col(i)) = 5 { Set winner = bingoNr }
        }
        Set bingoNr = $ORDER(bingo(bingoNr))
    }
    Return winner
}

Method HasWinners(ByRef bingo) As %String
{
    Set winner = 0
    Set bingoNr = $ORDER(bingo(""))
    While (bingoNr '= "") {
        Kill col
        For line=1:1:5 {
            Set row = 0
            For i=1:1:5 {
                If $LIST(bingo(bingoNr,line,i),2) { 
                    Set row = row + 1
                    Set col(i) = $GET(col(i)) + 1
                }
            }
            If row = 5 { 
                If '(winner [ (","_bingoNr)) { Set winner = winner_","_bingoNr }
            }
        }
        For i=1:1:5
        {
            If $GET(col(i)) = 5 { 
                If '(winner [ (","_bingoNr)) { Set winner = winner_","_bingoNr }
            }
        }
        Set bingoNr = $ORDER(bingo(bingoNr))
    }
    Return winner
}

Method Score(ByRef bingo, winner As %Integer, final As %Integer) As %Integer
{
    Set score = 0
    For line=1:1:5 {
            For i=1:1:5 {
                If $LIST(bingo(winner,line,i),2) = 0 { 
                    Set score = score + $LIST(bingo(winner,line,i),1)
                }
            }
        }
    Return score * final
}

Method Part2() As %Integer
{
    Set numbers = ..File.ReadLine()
    Set winner = 0
    Set bingoNr = 0
    Set lnr = 1
    While '..File.AtEnd {
        Set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        If line = "" { 
            Set bingoNr = bingoNr + 1 
            Set lnr = 1
        }
        Else {
            For i=1:1:5 {
                Set bingo(bingoNr,lnr,i) = $LISTBUILD($TRANSLATE($EXTRACT(line,3*(i-1)+1,3*(i-1)+3)," ",""),0)
            }
            Set lnr = lnr + 1
        }
    }
    Set boards = $ORDER(bingo(""),-1)
    Set num = 1
    While (boards > 0) && (num <= $LENGTH(numbers,",")) {
        Set current = $PIECE(numbers,",",num)
        Write current,!
        Do ..Mark(.bingo,current)
        Set winner = ..HasWinners(.bingo)
        If winner '= 0 {
            Write winner,*9,boards,!
            Set minus = 0
            If boards > 1 { 
                For i=2:1:$LENGTH(winner,",") {
                    Kill bingo($PIECE(winner,",",i)) 
                    Set minus = minus + 1
                }
            } ElseIf boards = 1 { Set minus = 1 }
            Set boards = boards - minus
        }
        Set num = num + 1
    }
    ZWrite bingo
    Write winner,*9,boards,!
    Return ..Score(.bingo,$PIECE(winner,",",2),$PIECE(numbers,",",num-1))
}

}
