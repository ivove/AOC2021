/// AOC 2021 Day 21
Class AOC.Day21 Extends %RegisteredObject
{

Method Part1(p1 As %Integer, p2 As %Integer) As %Integer
{
    Set s(1) = 0
    Set s(2) = 0
    Set p(1) = p1
    Set p(2) = p2
    Set result = 0
    Set rolls = 0
    Set player = 1
    Set die = 1
    While s(1) < 1000,s(2) < 1000 {
        For i=1:1:3 {
            Set p(player) = p(player) + (die#10)
            If p(player)>10 { Set p(player)=p(player)-10 }
            Set die = die + 1
            If die > 100 { Set die = 1 }
            Set rolls = rolls + 1
        }
        Set s(player) = s(player) + p(player)
        If player = 1 { Set player = 2 }
        Else { Set player = 1}
    }
    If s(1)>=1000 { Set result = s(2)*rolls }
    Else { Set result = s(1)*rolls }
    Return result
}

Method Part2(p1 As %Integer, p2 As %Integer) As %Integer
{
    Do ..roll(p1,p2,0,0,1,.wins)
    Set result = wins(1)
    If wins(2)>result { Set result = wins(2) }
    ZWrite wins
    Return result
}

Method roll(p1, p2, s1, s2, player, wins)
{
    If s1>=21 { Set wins(1) = $GET(wins(1)) + 1 }
    ElseIf s2>=21 { Set wins(2) = $GET(wins(2)) + 1 }
    Else {
        If player = 1 {
            For i=1:1:3 {
                Set p1 = p1 + 1
                If p1>10 { Set p1 = p1 - 10 }
                Set s1 = s1 + p1
                Do ..roll(p1,p2,s1,s2,2,.wins)
            }
        } Else {
            For i=1:1:3 {
                Set p2 = p2 + 1
                If p2>10 { Set p2 = p2 - 10 }
                Set s2 = s2 + p2
                Do ..roll(p1,p2,s1,s2,1,.wins)
            }
        }
    }
}

}
