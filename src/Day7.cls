/// OAC 2021 Day 7
Class AOC.Day7 Extends AOC.Base
{

Method Part1() As %Integer
{
    Set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
    Set len = $LENGTH(line,",")
    Set min = 999999
    Set max = 0
    For i=1:1:len {
        Set position = $PIECE(line,",",i)
        Set pos(i) = position
        If position > max { Set max = position }
        If min > position { Set min = position }
    }
    Set minFuel = 9999999999
    For t=min:1:max {
        Set fuel = 0
        For i=1:1:len {
            Set fuel = fuel + $ZABS(t-pos(i))
        }
        If fuel < minFuel { Set minFuel = fuel }
    }
    Return minFuel
}

Method Part2() As %Integer
{
    Set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
    Set len = $LENGTH(line,",")
    Set min = 999999
    Set max = 0
    For i=1:1:len {
        Set position = $PIECE(line,",",i)
        Set pos(i) = position
        If position > max { Set max = position }
        If min > position { Set min = position }
    }
    Set minFuel = 9999999999
    For t=min:1:max {
        Set fuel = 0
        For i=1:1:len {
            Set dist = $ZABS(t-pos(i))
            Set cons = 0
            For d=1:1:dist {
                Set fuel = fuel + d
            }
        }
        If fuel < minFuel { Set minFuel = fuel }
    }
    Return minFuel
}

}
