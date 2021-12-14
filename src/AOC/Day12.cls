/// AOC 2021 Day 12
Class AOC.Day12 Extends AOC.Base
{

Method Part1() As %Integer
{
    while '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        set from = $PIECE(line,"-",1)
        set to = $PIECE(line,"-",2)
        set map(from,to) = ""
        set map(to,from) = ""
    }
    do ..go("start",",start,",.paths,.map)
    //zw map
    //zw paths
    return paths
}

Method Part2() As %Integer
{
    while '..File.AtEnd {
        set line = $TRANSLATE(..File.ReadLine(),$CHAR(13),"")
        set from = $PIECE(line,"-",1)
        set to = $PIECE(line,"-",2)
        if '..isUpper(from),from'="start",from'="end" { set small(from) = "" }
        if '..isUpper(to),to'="start",to'="end" { set small(to) = "" }
        set map(from,to) = ""
        set map(to,from) = ""
    }
    set s = $ORDER(small(""))
    while s '= "" {
        k nmap
        merge nmap = map
        set f = $ORDER(nmap(""))
        while f '= "" {
            set t = $ORDER(nmap(f,""))
            while t '= "" {
                if t = s { set nmap(f,t_"1") = "" }
                set t = $ORDER(nmap(f,t))
            }
            if f = s { merge nmap(f_"1") = nmap(f) }
            set f = $ORDER(nmap(f))
        }
        do ..go("start",",start,",.paths,.nmap)
        set s = $ORDER(small(s))
    }  
    for i = 1:1:paths {
        set xp($TRANSLATE(paths(i),"1",""))=""
    }  
    //zw xp
    set result = 0
    set p = $ORDER(xp(""))
    while p '= "" {
        set result = result + 1
        set p = $ORDER(xp(p))
    }
    return result
}

Method go(current, visited, paths, map)
{
    set next = $ORDER(map(current,""))
    while next '= "" {
        set newVisited = visited
        if next = "end" {
            set paths = $GET(paths) + 1
            set paths(paths) = visited_next
        } elseif ..isUpper(next) || (newVisited'[(","_next_",")) {
            set newVisited = newVisited_next_","
            //w *9,next,*9,visited,!
            do ..go(next,newVisited,.paths,.map)
        }
        set next = $ORDER(map(current,next))
    }
}

Method isUpper(str As %String) As %Boolean
{
    return ($ZCONVERT(str,"U") = str)
}

}
