'tFile.
#include once "uDefines.bi"
DeclareDependencies()
#include "file.bi"
'#include "windows.bi"
DeclareDependenciesDone()

namespace tFile	

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tFile -=-=-=-=-=-=-=-

Enum tFileOpenMode
	fmInput
	fmOutput
	fmAppend
	fmBinary
	fmRandom
End Enum
	
dim FilenameOpenedLast as String		'updated by Openfile
dim FileError as String					'assembled by Openerror 

declare function Closefile(ByRef fileno as integer) as integer
'declare function Openerror(filename as string, fileno as integer, filemode as tFileOpenMode) as integer
declare function Openfile(filename as string, ByRef fileno as integer, filemode as tFileOpenMode=fmInput) as integer
declare function OpenInput(filename as string,ByRef fileno as integer) as integer
declare function OpenOutput(filename as string,ByRef fileno as integer) as integer
declare function OpenAppend(filename as string,ByRef fileno as integer) as integer
declare function OpenBinary(filename as string,ByRef fileno as integer) as integer
declare function OpenLogfile(filename as string, ByRef fileno as integer, kbsizelimit as integer=0) as integer
declare function filetostring overload (fileno as integer) as String
declare function filetostring overload (filename as string) as String
declare function stringtofile overload (fileno as integer,text as string) as integer
declare function stringtofile overload (filename as string,text as string) as integer
declare function Assertpath(folder as string) as integer
declare function Countlines(filename as string,nonblank as integer=1) as integer

declare function Filesize(filename as string) as integer
declare function FilesizeInMb(filename as string) as string

'declare function = Close(#fileno)
'declare function Openerror(filename as string, fileno as integer, filemode as tFileOpenMode) as integer
'declare function ttest() as Integer

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tFile -=-=-=-=-=-=-=-

public function Init(iAction as integer) as integer
	FilenameOpenedLast=""
	FileError=""
	return 0
End function


public function Closefile(ByRef fileno as integer) as integer
	function = Close(#fileno)
	fileno = 0
End function


private function Openerror(filename as string, fileno as integer, filemode as tFileOpenMode) as integer
	dim text as string
	scope
	select case filemode
		case fmInput:	text="Input"	:goto endscope
		case fmOutput:	text="Output"	:goto endscope
		case fmAppend:	text="Append"	:goto endscope
		case fmBinary:	text="Binary"	:goto endscope
		case fmRandom:	text="Random"	:goto endscope
	end select
	endscope:
	end scope		
	'
	FileError= "Couldn't open "&filename &" for " &text &" as #" &fileno
    return -1
End function

public function Openfile(filename as string, ByRef fileno as integer, filemode as tFileOpenMode=fmInput) as integer
    dim as integer i
    if fileno<=0 then 
		fileno=freefile
    EndIf
    FilenameOpenedLast=filename
    FileError=""
	scope
	select case filemode
		case fmInput:	i= Open(filename, For Input,  As #fileno)	:goto endscope
		case fmOutput:	i= Open(filename, For Output, As #fileno)	:goto endscope
		case fmAppend:	i= Open(filename, For Append, As #fileno)	:goto endscope
		case fmBinary:	i= Open(filename, For Binary, As #fileno)	:goto endscope
		case fmRandom:	i= Open(filename, For Random, As #fileno)	:goto endscope
	end select
	endscope:
	end scope		
	if i=0 then return fileno
    return Openerror(filename,fileno,filemode)
end function


public function OpenInput(filename as string,ByRef fileno as integer) as integer
	return Openfile(filename,fileno,fmInput)	
End function
public function OpenOutput(filename as string,ByRef fileno as integer) as integer
	return Openfile(filename,fileno,fmOutput)	
End function
public function OpenAppend(filename as string,ByRef fileno as integer) as integer
	return Openfile(filename,fileno,fmAppend)	
End function
public function OpenBinary(filename as string,ByRef fileno as integer) as integer
	return Openfile(filename,fileno,fmBinary)	
End function


public function OpenLogfile(filename as string, ByRef fileno as integer, kbsizelimit as integer=0) as integer
	if OpenAppend(filename,fileno)>0 then
		if (kbsizelimit>0) and (LOF(fileno)>kbsizelimit*1024) then
			Closefile(fileno) ' its getting stupidly large
			return OpenOutput(filename,fileno)
		EndIf
	EndIf
	return fileno
End function



public function filetostring overload (fileno as integer) as String
    dim text as string
    if fileno>0 then
	    text = space(LOF(fileno))
	    seek fileno, 1 
	    get #fileno,, text
    EndIf
	return text
End function


public function filetostring overload (filename as string) as String
	dim f as Integer
    dim text as string

    if tFile.Openbinary(filename,f)>0 then
	    text=filetostring(f)
	    tFile.Closefile(f)
    EndIf

    'dim as Integer src_len = len(filedata_string) + 1
    'dest_len = compressBound(src_len)
    'dest = Allocate(dest_len)
    'kill(fname)

    'if tFile.Openbinary(fname,f)>0 then        	    
    '    compress(dest , @dest_len, StrPtr(filedata_string), src_len)
    '    put #f,,names           '36 bytes
    '    put #f,,desig           '36 bytes
    '    put #f,,datestring      '12 bytes + 1 overhead
    '    put #f,,unflags()       'lastspecial + 1 overhead
    '    put #f,,artflag()       'lastartifact + 1 overhead
    '    put #f,, src_len 'we can use this to know the amount of memory needed when we load - should be 4 bytes long
		'    'Putting in the short info the the load game menu
    '	header_len =  36 + 36 + 12 + lastspecial + lastartifact*2 + 4 + 4 + 3 ' bytelengths of names, desig, datestring,
    '    'unflags, artflag, src_len, header_len, and 3 bytes of over head for the 3 arrays datestring, unflags, artflag
    '    put #f,, header_len
    '    put #f,, *dest, dest_len
    '    tFile.Closefile(f)
    'EndIf
    'Deallocate(dest)
	return text
End function


public function stringtofile overload (fileno as integer,text as string) as integer
    if fileno>0 then
    	print #fileno, text;
		return 0
    EndIf
	return -1
End function


public function stringtofile overload (filename as string,text as string) as integer
	dim f as Integer
    if Openoutput(filename,f)>0 then
    	stringtofile(f,text)
	    return tFile.Closefile(f)
    EndIf
	return -1
End function


public function Assertpath(folder as string) as integer
    if chdir(folder)=-1 then
        print "Creating folder " +folder
        return mkdir(folder) '-1 on failure
    else
        return chdir("..")
    endif
end function


public function Filesize(filename as string) as integer
	Dim as Integer f, size
	if OpenBinary(filename,f)>0 then
		size= LOF(f)
        Closefile(f)
		return size
	EndIf
	return -1
end function

function FilesizeInMb(filename as string) as string
	Dim as Integer size
	Dim as string asize
	size= Filesize(filename) \ 1024
	asize="" &size
	size=len(asize)-(3-1)
	asize=mid(asize,1,size)+"."+mid(asize,size,3)
	if size<1 then asize="0"+asize
	return asize
End Function

public function Countlines(filename as string,nonblank as integer=1) as integer
	'counts non-blank lines by default
	Dim as Integer f, n
    dim dummy as string
	if OpenInput(filename,f)>0 then
		do
        	line input #f,dummy
	        if (nonblank=0) or (len(dummy)>0) then n+=1
	    loop until eof(f)
        Closefile(f)
	endif
    return n
end function

#endif'main
End Namespace


#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tFile -=-=-=-=-=-=-=-
	tModule.register("tFile",@tFile.init()) ',@tFile.load(),@tFile.save())
#endif'main


#ifdef test
#print -=-=-=-=-=-=-=- TEST: tFile -=-=-=-=-=-=-=-
#undef test
#print "tFile testing"
'#include "uScreen.bas"
'#include "uColor.bas"
'#include "uUtils.bas"
'#include "uConsole.bas"
'#include "uVersion.bas"
#define test
#endif'test

#if (defined(test) or defined(testload))
#print -=-=-=-=-=-=-=- TEST: tFile -=-=-=-=-=-=-=-

	namespace tFile

	sub Filetest()
		dim as String a1,a2,fn
		a1=Pad(50,"1234",">")
		'
		fn="test.txt"
		? "temp-file "+fn
		? "curdir "+curdir
		? "exepath "+exepath
		? 
		?	
		? "testing string-to-file and file-to-string"
		tFile.stringtofile(fn,a1)
		a2=tFile.filetostring(fn)
		? a1;" len: ";len(a1)
		? a2;" len: ";len(a2)
		? "a1=a2 = "; a1=a2
		?
		? "zapped temp-file "+fn
		kill fn
	End Sub

	end namespace'tFile
	
	#ifdef test
		tFile.Filetest()
		uConsole.Pressanykey()	
		'? "sleep": sleep
	#else
		tModule.registertest("tFile",@tFile.Filetest())
	#endif'test
#endif'test

