/// AOC 2021 Day 16
Class AOC.Day16 Extends AOC.Base
{

Method Part1() As %Integer
{
    set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
    return ..FromHex(line)
}

Method Part2() As %Integer
{
    set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
    return ..SolveFromHex(line)
}

Method SolveFromHex(hex As %String) As %Integer
{
    set bit = ..Expand(hex)
    do ..Parse(bit,1,.s)
    do ..Solve(1,.s)
    return s(1,1,"value")
}

Method Solve(level As %String, ByRef struct)
{
    //w "solve",*9,level,!
    set sub = $ORDER(struct(level,""))
    while sub '= "" {
        if '$DATA(struct(level,sub,"value")) {
            do ..SolveSub(level,sub,.struct)
        }
        set sub = $ORDER(struct(level,sub))
    }
}

Method SolveSub(level As %Integer, sub As %Integer, ByRef struct)
{
    if $DATA(struct(level+1)) {
        do ..Solve(level+1,.struct)
    }
    k val
    set nsub = $ORDER(struct(level+1,""))
    while nsub '= "" {
        if $GET(struct(level+1,nsub,"parent")) = sub {
            set val = $GET(val) + 1
            set val(val) = struct(level+1,nsub,"value")
        }
        set nsub = $ORDER(struct(level+1,nsub))
    }
    set typeId = $GET(struct(level,sub,"typeid"),4)
    if typeId = 0 {
        set nval = 0
        for i=1:1:val { set nval = nval + val(i) }
        set struct(level,sub,"value") = nval
    } elseif typeId = 1 {
        set nval = 1
        for i=1:1:val { set nval = nval * val(i) }
        set struct(level,sub,"value") = nval
    } elseif typeId = 2 {
        //min
        set nval = 999999999
        for i=1:1:val {
            if val(i)<nval { set nval = val(i) }
            set struct(level,sub,"value") = nval
        }
    } elseif typeId = 3 {
        //max
        set nval = 0
        for i=1:1:val {
            if val(i)>nval { set nval = val(i) }
            set struct(level,sub,"value") = nval
        }
    } elseif typeId = 5 { //greater
        if val(1)>val(2) { set struct(level,sub,"value") = 1 }
        else { set struct(level,sub,"value") = 0 }
    
    } elseif typeId = 6 { //less
        if val(1)<val(2) { set struct(level,sub,"value") = 1 }
        else { set struct(level,sub,"value") = 0 }
    
    } elseif typeId = 7 { //equal
        if val(1)=val(2) { set struct(level,sub,"value") = 1 }
        else { set struct(level,sub,"value") = 0 }
    
    }
}

Method FromHex(hex As %String) As %Integer
{
    set bit = ..Expand(hex)
    //w bit,!
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

Method Parse(str As %String, level As %Integer, ByRef struct, parent As %Integer = 0)
{
    while str'="",'(str?."0") {
        set version = ..Bit2Int($EXTRACT(str,1,3))
        set type = ..Bit2Int($EXTRACT(str,4,6))
        if type = 4 {
            set str = $EXTRACT(str,7,*)
            set str = ..ParseLiteral(str,level,version,.struct,parent)
        }
        else {
            set typeId = $EXTRACT(str,7)
            if typeId {
                set len = ..Bit2Int($EXTRACT(str,8,18))
                set str = $EXTRACT(str,19,*)
                set str = ..ParsePacketOperator(str,level,version,len,.struct,parent,type)
            } else {    
                set len = ..Bit2Int($EXTRACT(str,8,22))
                set str = $EXTRACT(str,23,*)
                set str = ..ParseFixedLengthOperator(str,level,version,len,.struct,parent,type)
            }
        }
    }
}

Method ParseLiteral(str As %String, level As %Integer, version As %Integer, ByRef struct, parent As %Integer = 0) As %String
{
    set val = ""
    set cont = 1
    set start = 1
    while cont {
        set chunk = $EXTRACT(str,start,start+4)
        //w chunk,!
        set val = val_$EXTRACT(chunk,2,*)
        set cont = $EXTRACT(chunk,1)
        set start = start + 5
    }
    set struct(level) = $GET(struct(level)) + 1
    set struct(level,struct(level),"value") = ..Bit2Int(val)
    set struct(level,struct(level),"version") = version
    set struct(level,struct(level),"type") = "literal"
    set struct(level,struct(level),"parent") = parent
    set remaining = $EXTRACT(str,start,*)
    return remaining
}

Method ParseFixedLengthOperator(str As %String, level As %Integer, version As %Integer, length As %Integer, ByRef struct, parent As %Integer = 0, type As %Integer) As %String
{
    set pack = $EXTRACT(str,1,length)
    //w "pack",*9,pack,!
    //r xxx
    set id = $GET(struct(level)) + 1
    set struct(level) = id
    set struct(level,struct(level),"version") = version
    set struct(level,struct(level),"packetlen") = length
    set struct(level,struct(level),"type") = "fixedLengthOperator"
    set struct(level,struct(level),"typeid") = type
    set struct(level,struct(level),"parent") = parent
    d ..Parse(pack,level+1,.struct,id)
    set remaining = $EXTRACT(str,length+1,*)
    return remaining
}

Method ParsePacketOperator(str As %String, level As %Integer, version As %Integer, length As %Integer, ByRef struct, parent As %Integer = 0, type As %Integer) As %String
{
    set id = $GET(struct(level)) + 1
    set struct(level) = id
    set struct(level,struct(level),"version") = version
    set struct(level,struct(level),"packetlen") = length
    set struct(level,struct(level),"type") = "packetOperator"
    set struct(level,struct(level),"typeid") = type
    set struct(level,struct(level),"parent") = parent
    for p=1:1:length {
        set version = ..Bit2Int($EXTRACT(str,1,3))
        set type = ..Bit2Int($EXTRACT(str,4,6))
        if type = 4 {
            set str = $EXTRACT(str,7,*)
            set str = ..ParseLiteral(str,level+1,version,.struct,id)
        }
        else {
            set typeId = $EXTRACT(str,7)
            if typeId {
                set len = ..Bit2Int($EXTRACT(str,8,18))
                set str = $EXTRACT(str,19,*)
                set str = ..ParsePacketOperator(str,level+1,version,len,.struct,id,type)
            } else {    
                set len = ..Bit2Int($EXTRACT(str,8,22))
                set str = $EXTRACT(str,23,*)
                set str = ..ParseFixedLengthOperator(str,level+1,version,len,.struct,id,type)
            }
        }
    }
    return str
}

}
