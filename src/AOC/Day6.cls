/// AOC 2021 Day 6
Class AOC.Day6 Extends AOC.Base
{

Method Part2(numdays As %Integer) As %Integer
{
    //set days = 80
    While '..File.AtEnd {
        Set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        Set len = $LENGTH(line,",")
        Set fish = len
        For i=1:1:len{
            Set age = $PIECE(line,",",i)
            Set fish(age)=$GET(fish(age))+1
        }
    }
    ZWrite fish
    For d=1:1:numdays {
        Set a0 = $GET(fish(0))
        Set a1 = $GET(fish(1))
        Set a2 = $GET(fish(2))
        Set a3 = $GET(fish(3))
        Set a4 = $GET(fish(4))
        Set a5 = $GET(fish(5))
        Set a6 = $GET(fish(6))
        Set a7 = $GET(fish(7))
        Set a8 = $GET(fish(8))
        Set fish(8)=a0
        Set fish(7)=a8
        Set fish(6)=a7+a0
        Set fish(5)=a6
        Set fish(4)=a5
        Set fish(3)=a4
        Set fish(2)=a3
        Set fish(1)=a2
        Set fish(0)=a1
        
    }
    ZWrite fish
   Set x=0
   For i=0:1:8 {
       Set x=x+fish(i)
   }
    Return x
}

Method Part1(days As %Integer) As %Integer
{
    //set days = 80
    While '..File.AtEnd {
        Set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        Set len = $LENGTH(line,",")
        Set ^||fish = len
        For i=1:1:len{
            Set ^||fish(i)=$PIECE(line,",",i)
        }
    }
    For d=1:1:days {
        Set new = 0
        For f=1:1:^||fish {
            Set age = ^||fish(f)
            Set age = age - 1
            If age < 0 { 
                Set age = 6
                Set new = new + 1
            }
            Set ^||fish(f) = age
        }
        For i=1:1:new {
            Set ^||fish = ^||fish + 1
            Set ^||fish(^||fish) = 8
        }
    }
    Return fish
}

}
