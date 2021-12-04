/// Base for AOC
Class AOC.Base Extends %RegisteredObject
{

/// File
Property File As %Stream.FileBinary;

/// TestFile
Property TestFile As %Stream.FileBinary;

Method %OnNew(initvalue As %String) As %Status [ Private, ServerOnly = 1 ]
{
    Set day = ..%ClassName()
    #DIM filename As %String = "/shared/"_day_".txt" 
    #DIM testFilename As %String = "/shared/"_day_"t.txt" 
    If (##class(%File).Exists(filename)) {
        Set ..File=##class(%Stream.FileBinary).%New()
        Set sc=..File.LinkToFile(filename) 
    }
    If (##class(%File).Exists(testFilename)) {
        Set ..TestFile=##class(%Stream.FileBinary).%New()
        Set sc=..TestFile.LinkToFile(testFilename) 
    }
    Return $$$OK
}

}
