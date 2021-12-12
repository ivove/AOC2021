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
            If $LENGTH(digit) = 2 { Set number = number + 1 }
            If $LENGTH(digit) = 7 { Set number = number + 1 }
            If $LENGTH(digit) = 3 { Set number = number + 1 }
            If $LENGTH(digit) = 4 { Set number = number + 1 }
        }
    }
    Return number
}

Method Part2() As %Integer
{
    Set number = 0
    While '..File.AtEnd {
        k match,xmatch
        Set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        Set test = $PIECE(line,"|",1)
        Set output = $PIECE(line,"|",2)
        Set len = $LENGTH(test," ")
        For i=1:1:len-1 {
            Set digit = $PIECE(test," ",i)
            set dl = $LENGTH(digit)
            if dl = 2 { 
                set match(digit,1) = "" 
                set xmatch(1) = digit    
            }
            elseif dl = 3 { 
                set match(digit,7) = "" 
                set xmatch(7) = digit
            }
            elseif dl = 4 { 
                set match(digit,4) = "" 
                set xmatch(4) = digit
            }
            elseif dl = 7 { 
                set match(digit,8) = "" 
                set xmatch(8) = digit
            }
            else {
                set todo(digit) = ""
                for d=0:1:9 { set match(digit,d) = "" }
            }            
        }
        set found = 0
        while found < 3 {
            set digit = $ORDER(todo(""))
            while digit '= "" {
                if ..contains(digit,xmatch(7)) {
                    if $LENGTH($TRANSLATE(digit,xmatch(7),"")) = 2 {                        
                        k match(digit),todo(digit)
                        set match(digit,3)="",found = found+1,xmatch(3)=digit
                    }
                }
                if ..contains(digit,xmatch(4)) {
                    if $LENGTH($TRANSLATE(digit,xmatch(4),"")) = 2 {
                        k match(digit),todo(digit)
                        set match(digit,9)="",found = found+1,xmatch(9)=digit
                    }
                }
                if $LENGTH(digit)=6,$DATA(xmatch(9)),..contains(digit,xmatch(7)),'..is(digit,xmatch(9)) {
                    k match(digit),todo(digit)
                    set match(digit,0)="",found = found+1,xmatch(0)=digit
                }
                set digit = $ORDER(todo(digit))
            }
        }
        set found6 = 0
        set digit = $ORDER(todo(""))
        while digit'="",found6=0 {
            if $LENGTH(digit)=6 {
                k match(digit),todo(digit)
                s match(digit,6)="",xmatch(6)=digit
            }
            set digit = $ORDER(todo(digit))
        }
        set digit = $ORDER(todo(""))
        while digit'="",found6=0 {
            if ..contains(xmatch(6),digit) {
                k match(digit),todo(digit)
                s match(digit,5)="",xmatch(5)=digit                
            } else {
                k match(digit),todo(digit)
                s match(digit,2)="",xmatch(2)=digit
                }
            set digit = $ORDER(todo(digit))
        }
        set num = "",len = $LENGTH(output," ")
        //zw match
        For i=2:1:len {
            Set digit = $PIECE(output," ",i)
            set xnum = ""
            set d = $ORDER(match("")) 
            while d'="",xnum=""{
                //w *9,d,*9,..is(digit,d),!
                if ..is(digit,d) {                    
                    set xnum = $ORDER(match(d,""))
                }
                set d = $ORDER(match(d))
            }
            
            //write digit,*9,xnum,!
            set num = num_xnum
        }
        set number = number + num
        w num,!
    }
    Return number
}

Method contains(digit As %String, test As %String) As %Boolean
{
    set result = 1
    if $LENGTH(test) > $LENGTH(digit) { set result = 0 }
    if result {
        for i=1:1:$LENGTH(test) {
            if digit '[ $EXTRACT(test,i) { set result = 0 }
        }
    }
    return result
}

Method is(digit As %String, test As %String) As %Boolean
{
    set result = 1
    if $LENGTH(test) '= $LENGTH(digit) { set result = 0 }
    if result {
        for i=1:1:$LENGTH(test) {
            if digit '[ $EXTRACT(test,i) { set result = 0 }
        }
    }
    return result
}

}
