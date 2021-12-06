/// AOC 2021 Day 6
Class AOC.Day6 Extends AOC.Base
{

Method Part2(numdays As %Integer) As %Integer
{
    //set days = 80
    While '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$c(13),"")
        set len = $LENGTH(line,",")
        set fish = len
        for i=1:1:len{
            set fish(i)=$PIECE(line,",",i)
        }
    }
    for f=1:1:fish {
        set age = fish(f)
        set days(1,age)=$GET(days(1,age)) + 1
    }
    set day = 1
    while day'="",day < (numdays+1) {
        w day,!
        set age = $ORDER(days(day,""))
        while  age '= "" {
            set next = age + 3
            set days(day+next,6) = $GET(days(day+next,6)) + days(day,age)
            set xdat = day + next
            while xdat < numdays {
                set fish = fish + days(day,age)
                set days(xdat,6) = $GET(days(xdat+next,6)) + days(day,age)
                set xdat = xdat + 7
            }
            set age = $ORDER(days(day,age))
        }
        set day = $ORDER(days(day))
    }
    zw days
    set x = 0
    set a = $ORDER(days(""))
    while a '= "", a <= numdays {
        set b = $ORDER(days(a,""),1,val)
        while b '= "" {
            set x = x + val
            set b =$ORDER(days(a,b),1,val)
        }
        set a = $ORDER(days(a))
    }
    return x
}

Method Part1(days As %Integer) As %Integer
{
    //set days = 80
    While '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$c(13),"")
        set len = $LENGTH(line,",")
        set ^||fish = len
        for i=1:1:len{
            set ^||fish(i)=$PIECE(line,",",i)
        }
    }
    for d=1:1:days {
        set new = 0
        for f=1:1:^||fish {
            set age = ^||fish(f)
            set age = age - 1
            if age < 0 { 
                set age = 6
                set new = new + 1
            }
            set ^||fish(f) = age
        }
        for i=1:1:new {
            set ^||fish = ^||fish + 1
            set ^||fish(^||fish) = 8
        }
    }
    return fish
}

}
