/// AOC 2021 Day 16
Class AOC.Day16 Extends AOC.Base
{

Method Part1() As %Integer
{
    set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
    return ..FromHex(line)
}

Method FromHex(hex As %String) As %Integer
{
    set bit = ..Expand(hex)
    w bit,!
    do ..Parse(bit,1,.s)
    zw s
    set l = $ORDER(s(""))
    set result = 0
    while l'="" {
        set sub = $order(s(l,""))
        while sub'="" {
            set result = result + s(l,sub,"version")
            set sub = $order(s(l,sub))
        }
        set l=$ORDER(s(l))
    }
    return result
}

Method Expand(str As %String)
{
    set result = ""
    set m("0") = "0000"
    set m("1") = "0001"
    set m("2") = "0010"
    set m("3") = "0011"
    set m("4") = "0100"
    set m("5") = "0101"
    set m("6") = "0110"
    set m("7") = "0111"
    set m("8") = "1000"
    set m("9") = "1001"
    set m("A") = "1010"
    set m("B") = "1011"
    set m("C") = "1100"
    set m("D") = "1101"
    set m("E") = "1110"
    set m("F") = "1111"
    set len = $LENGTH(str)
    for c=1:1:len {
        set char = $EXTRACT(str,c)
        set result = result_m(char)
    }
    return result
}

Method Bit2Int(bit As %String) As %Integer
{
    set result = 0
    set len = $LENGTH(bit)
    for i=len:-1:1 {
        set b = $EXTRACT(bit,i)
        set result = result + (b*(2**(len-i)))
    }
    return result
}

Method Parse(str As %String, level As %Integer, ByRef struct)
{
    while str'="",'(str?."0") {
        set version = ..Bit2Int($EXTRACT(str,1,3))
        set type = ..Bit2Int($EXTRACT(str,4,6))
        if type = 4 {
            set str = $EXTRACT(str,7,*)
            set str = ..ParseLiteral(str,level,version,.struct)
        }
        else {
            set typeId = $EXTRACT(str,7)
            if typeId {
                set len = ..Bit2Int($EXTRACT(str,8,18))
                set str = $EXTRACT(str,9,*)
                set str = ..ParsePacketOperator(str,level,version,len,.struct)
            } else {    
                set len = ..Bit2Int($EXTRACT(str,8,22))
                set str = $EXTRACT(str,9,*)
                set str = ..ParseFixedLengthOperator(str,level,version,len,.struct)
            }
        }
    }
}

Method ParseLiteral(str As %String, level As %Integer, version As %Integer, ByRef struct) As %String
{
    set val = ""
    set cont = 1
    set start = 1
    while cont {
        set chunk = $EXTRACT(str,start,start+4)
        w chunk,!
        set val = val_$EXTRACT(chunk,2,*)
        set cont = $EXTRACT(chunk,1)
        set start = start + 5
    }
    set struct(level) = $GET(struct(level)) + 1
    set struct(level,struct(level),"value") = ..Bit2Int(val)
    set struct(level,struct(level),"version") = version
    set struct(level,struct(level),"type") = "literal"
    set remaining = $EXTRACT(str,start,*)
    return remaining
}

Method ParseFixedLengthOperator(str As %String, level As %Integer, version As %Integer, length As %Integer, ByRef struct) As %String
{
    set pack = $EXTRACT(str,23,23+length-1)
    w "pack",*9,pack,!
    r xxx
    set struct(level) = $GET(struct(level)) + 1
    set struct(level,struct(level),"version") = version
    set struct(level,struct(level),"packetlen") = length
    set struct(level,struct(level),"type") = "fixedLengthOperator"
    d ..Parse(pack,level+1,.struct)
    set remaining = $EXTRACT(str,23+length,*)
    return remaining
}

Method ParsePacketOperator(str As %String, level As %Integer, version As %Integer, length As %Integer, ByRef struct) As %String
{
    
    set struct(level) = $GET(struct(level)) + 1
    set struct(level,struct(level),"version") = version
    set struct(level,struct(level),"packetlen") = length
    set struct(level,struct(level),"type") = "packetOperator"
    for p=1:1:length {
        set version = ..Bit2Int($EXTRACT(str,1,3))
        set type = ..Bit2Int($EXTRACT(str,4,6))
        if type = 4 {
            set str = $EXTRACT(str,7,*)
            set str = ..ParseLiteral(str,level+1,version,.struct)
        }
        else {
            set typeId = $EXTRACT(str,7)
            if typeId {
                set len = ..Bit2Int($EXTRACT(str,8,18))
                set str = $EXTRACT(str,9,*)
                set str = ..ParsePacketOperator(str,level+1,version,len,.struct)
            } else {    
                set len = ..Bit2Int($EXTRACT(str,8,22))
                set str = $EXTRACT(str,9,*)
                set str = ..ParseFixedLengthOperator(str,level+1,version,len,.struct)
            }
        }
    }
    return str
}

}
