' sourcer.bas
' sourcer.bi

#include "fbGfx.bi"
#include "file.bi"
#include "zlib.bi"
#include "windows.bi"

'
#define intest
#define head
#include "src/tDefines.bas"
#define main
#include "src/tDefines.bas"
#include "src/tModule.bas"
#include "src/tScreen.bas"
#include "src/tColor.bas"
#include "src/Version.bas"
#include "src/kbinput.bas"
#include "src/tFile.bas"
#include "src/tPalette.bas"
'
#include "src/tPng.bas"
#include "src/tGraphics.bas"
'
#include "src/tUtils.bas"
#include "src/tError.bas"
#include "src/tViewfile.bas"
'
'#include "src/tFile.bas"
#undef main
'
'

namespace tMain
	
	dim as string finput, foutput		
	dim as Integer fin, fout

	type tSource
		token as String
		namespc as String
		defines as String		'comma list of function names
		publics as String		'crlf list of implementation first-lines 
		definitions as String	'crlf list of implementation first-lines 
		source as String		'source
		filename as String
	End Type
	

private function Localize(aSource as tSource, funct as string) as string
	dim as Integer i
	i=instr(lcase(funct),"function ")
	if i>0 then i += len("function ")
	if i=0 then i =1
	if aSource.Namespc<>"" then 
		return aSource.Namespc+"."+mid(funct,i)
	else
		return mid(funct,i)
	endif
End Function

private function Privatize(funct as string) as string
	dim as Integer i
'	? "privatize",funct
	i=instr(lcase(funct),"function ")
	if i>0 then funct= mid(funct,1,i-1) + mid(funct,i+len("function "))
	return funct
End Function


function functiondefinitions overload (ByRef aSource as tSource) as tSource
	dim as Integer n=len(aSource.Source)
	dim as Integer i,j,k
	dim as string b=""
	dim as string c=""
	dim as string d=""
	dim as string e=""
	i=1
	
	j=instr(i,aSource.Source,"namespace ")
	if j>0 then
		j=j+len("namespace ")
		k=instr(j,aSource.Source,chr(13))
		aSource.namespc=mid(aSource.Source,j,1+k-j)
		j=instr(aSource.namespc,chr(9))
		k=instr(aSource.namespc," ")
		if (j>0) and ((k=0) or (j<k)) then k=j
		if k>0 then aSource.namespc=mid(aSource.namespc,1,k-1)
	endif
	'
	while (i<n)
		j=instr(i,aSource.Source,"function ")
		if j=0 then 
			exit while			
		EndIf
		k=j
		while (k>1) and (mid(aSource.Source,k-1,1)>=" ") 
			k -= 1			
		Wend
		while (k<n) and (mid(aSource.Source,k,1)=chr(9) or mid(aSource.Source,k,1)=" ") 
			k += 1			
		Wend
		while (j<n) and (mid(aSource.Source,j+1,1)>=" ") 
			j += 1			
		Wend
		'j += 1			
		i =j
		'
		if mid(aSource.Source,k,1)<>"'" then
			c=mid(aSource.Source,k,1+j-k)
'			if ((instr(c,"=")=0) or (instr(c,"=")>=instr(c,"(")))_
'			and 
			if not(instr(lcase(c),"end")=1 or instr(lcase(c),"declare")=1) then
				if instr(lcase(c),"public ")>0 then
					e=e + Localize(aSource,c) &chr(13) &chr(10)
				else
					b=b + Privatize(c) &chr(13) &chr(10)
				EndIf
				'
				j=instr(c,"function ")
				if j>0 then	j+=   len("function ")
				if j=0 then j=1
				k=instr(j,c,"(")
				if k>0 then c=mid(c,j,k-1)
				if instr(c,"=")=0 then
					j=instr(c,"overload")-1
					if j>0 then c=mid(c,1,j-1)
					j=instr(c,"(")
					if j>0 then c=mid(c,1,j-1)
					if instr(d,c+",")=0 then d=d+c+", "
				EndIf
			EndIf
		EndIf
	Wend
	aSource.defines = mid(d,1,len(d)-2)
	aSource.publics = e
	aSource.definitions = b
	return aSource	
End Function

function functiondefinitions overload (source as string) as tSource
	dim aSource as tSource
	aSource.Source= Source
	return functiondefinitions(aSource)
End Function

function functiondefinitions overload (fileno as integer) as tSource
	return functiondefinitions(tFile.filetostring(fileno))
End Function


function add(text as string="") as string
	return "'" + text
End Function

function line(ByVal aText as string="",iwidth as integer=60,itries as integer=7) as string
	dim aline as String
	dim text as String
	aline= add(aText) '+ chr(13) + chr(10)
	text= ""
	while (len(aline) > iwidth) or instr(aline,chr(13)) 
		dim as Integer i,j,k
		i=instr(aline,chr(13))
		if i+1>=len(aline) then
			exit while
		EndIf
		if (i>0) and (i<iwidth) then
			while (i<len(aline)) and (mid(aline,i+1,1)<" ") 
				i +=1
			Wend
			'? mid(aline,1,i-1) 
			text= text + mid(aline,1,i-1) + chr(13) + chr(10) 
			aline= trim(mid(aline,i)," "+chr(13)+chr(10)+chr(9))			
			while (aline<>"") and asc(mid(aline,1,1))<=32
				aline= mid(aline,2)
			Wend 
			if instr(aline,"'")<>1 then	aline= "'"+aline
'			aline= add(aline)
'? "crlf loop: "+aline
			continue while
		EndIf
'? len(text + aline)
		'
		i=iwidth		
		j=len(aline)
		k=itries
		while (i<j) and (k>0)
			if mid(aline,i,1)<>"," then 
				k -= 1
				i += 1
			else 
				exit while
			EndIf
		Wend	
		if mid(aline,i,1)="," then
		else
			k =itries
			i -=itries
			if j<=iwidth+itries then
				exit while
			EndIf
			'
			while (i>1) and (k>0)
				if mid(aline,i,1)<>"," then 
					k -= 1
					i -= 1
				else 
					exit while
				EndIf
			Wend	
			if mid(aline,i,1)="," then
			else
				k =itries
				i +=itries
			EndIf
		EndIf
		text= text + mid(aline,1,i) + chr(13) + chr(10)
		aline= trim(mid(aline,i)," "+chr(13)+chr(10)+chr(9))			
		while (aline<>"") and asc(mid(aline,1,1))<32
			aline= mid(aline,2)
		Wend 
		if instr(aline,"'")<>1 then	aline= "'"+aline
	Wend
	'if mid(aline,1,1)<>"'" then aline= "'"+aline	
	return text + aline + chr(13) + chr(10)
End Function

'
'
'
function documentsorce(ByRef aSource as tSource) as String
	dim as String a
	a=aSource.token
	a=line(a+".")
	'if len(aSource.namespc)>0 then
	'endif
	if len(aSource.namespc)>0 then
		a += line()+line("namespace: " + aSource.namespc)+line() 
	endif
	if len(aSource.defines)>0 then
		 a += line()+line("defines:")+line(aSource.defines,60,15)+line() 
	endif
	'if len(aSource.publics)>0 then
	'	 a += line()+line("publics:")+line(aSource.publics,120)+line() 
	'endif
	'if len(aSource.definitions)>0 then
	'	 a += line()+line("definitions:")+line(aSource.definitions,120)+line() 
	'endif
	return a	
End Function


function prunesource(ByRef aSource as tSource) as tSource
	dim a as String
	dim a0 as String
	dim ch as String
	dim adoc as String
	dim as integer i,il,li,j,n
	a0=aSource.source
	n=len(a0)
	i=1
	li=i
'? asource.token	
	while (i<n)
		il=i
		while i<n
'? i,":"+mid(a0,i,1)+":"
			if mid(a0,i,1)<=" " then
				i+=1
'? i,j,"a"
			elseif mid(a0,i,1)="'" then
				i+=1
'? i,j,"b"

			elseif mid(a0,i-1,1)="'" then
				j=instr(i,a0,chr(10))
'? i,j,"c"
				if j>0 then i = j
				if j>0 then il = i
'? i,il,"c: i,il"
			else
				exit while
			endif
		Wend
		'j= instr(i,aSource.source,chr(13))
		'a= mid(aSource.source,i,j-1)
		'i+=j
		'?i,a
'		j=1
'		while j<len(a) and mid(a,j,1)<" "
'			j+=1
'		Wend
'		a=mid(a,j)
'? ">"+a+"<"		
'		if mid(a,1,1)="'" then a=""
'		if a<>"" then 
		li=il
'		?li,a
		exit while
'		EndIf
'		?il,a
		'i += 1
	Wend	
	aSource.source=mid(aSource.source,li)
'cls
'?li
'?aSource.source
'?">";mid(aSource.source,1,20);"...";:sleep:?
	return aSource
End Function

declare function Declarepublicfunctions(ByRef aSource as tSource) as String	

function newsource(ByRef aSource as tSource) as string
	dim adoc as String
	dim afun as String
	dim aend as String
	dim crlf as String = chr(13)+chr(10)
	afun=""	
	aend=""	
	if len(aSource.namespc)=0 then
		'afun += crlf
		'afun += "'namespace "+aSource.token +crlf
		'afun += crlf
		'
		'aend += "'end namespace'"+aSource.token +crlf
	EndIf
	'
	afun += crlf
	'afun += "'" +crlf
	afun += "'needs [head|main|both] defined," +crlf
	afun += "' builds in test mode otherwise:" +crlf
	afun += "#if not (define(head) or define(main))" +crlf
	afun += "#define intest"+crlf
	afun += "#define both"+crlf
	afun += "#endif'test" +crlf
	afun += "#if define(both)" +crlf
	afun += "#define head"+crlf
	afun += "#define main"+crlf
	afun += "#endif'both" +crlf
	afun += "'" +crlf
	afun += "#ifdef intest" +crlf
	afun += "#undef intest"+crlf
	afun += "#define test"+crlf
	afun += "'     -=-=-=-=-=-=-=- TEST: "+aSource.token+" -=-=-=-=-=-=-=-" +crlf
	afun += crlf

	'afun += crlf
	afun += "#endif'test" +crlf
	afun += "#ifdef head" +crlf
	afun += "'     -=-=-=-=-=-=-=- HEAD: "+aSource.token+" -=-=-=-=-=-=-=-" +crlf
	afun += crlf
	afun += Declarepublicfunctions(aSource)
	
	afun += crlf
	afun += "#endif'head" +crlf
	afun += "#ifdef main" +crlf
	afun += "'     -=-=-=-=-=-=-=- MAIN: "+aSource.token+" -=-=-=-=-=-=-=-" +crlf
	afun += crlf
		afun += "namespace "+aSource.token +crlf
		afun += "public function init()" +crlf
		afun += chr(9) +"return 0" +crlf
		afun += "end function" +crlf
		afun += "end namespace'"+aSource.token +crlf
		afun += crlf
	if 0 then
		afun += "public function load(fileno as Integer) As Integer" +crlf
		afun += chr(9) +"return 0" +crlf
		afun += "end function" +crlf
		afun += crlf
		afun += "public function save(fileno as Integer) As Integer" +crlf
		afun += chr(9) +"return 0" +crlf
		afun += "end function" +crlf
		afun += crlf
		afun += "'code" +crlf
		afun += crlf
	EndIf
	afun += crlf
	afun += "#define cut2top"+crlf
	'
	aend = "#endif'main" +crlf +aend
	aend = "#define cut2bottom"+crlf +aend +crlf
	'
	aend += "#ifdef main" +crlf
	aend += "'      -=-=-=-=-=-=-=- MAIN: "+aSource.token+" -=-=-=-=-=-=-=-" +crlf
	aend += chr(9) +"tModule.register("
	aend += """"+aSource.token+""""
	aend += ",@"+aSource.token+".init()"
	aend += ") '"
	aend += ",@"+aSource.token+".load()"
	aend += ",@"+aSource.token+".save()"
	aend += ")"+crlf
	aend += "#endif'main" +crlf
	aend += "#ifdef test" +crlf
	aend += "#print -=-=-=-=-=-=-=- TEST: "+aSource.token+" -=-=-=-=-=-=-=-" +crlf
	aend += "#endif'test" +crlf
	'
	return documentsorce(aSource) + afun + aSource.source + aend 
End Function


function countdefines(ByRef aSource as tSource) as integer
	dim crlf as String = chr(13)+chr(10)
	dim as string a1,a2
	dim as Integer i,j
	dim as integer n
	a2=aSource.defines+","
	do
		i=instr(a2,",") 'split on comma
		if i=0 then 
			a1=a2
			a2=""
		else
			a1=mid(a2,1,i-1)
			a2=trim(mid(a2,i+1))
		EndIf
		n += 1
	Loop until i=0
	return n
End Function


function listdefines(ByRef aSource as tSource) as string
	dim crlf as String = chr(13)+chr(10)
	dim as string a,a1,a2
	dim as Integer i,j
	a2=aSource.defines+","
'? ":"+a2+":"	
	do
		i=instr(a2,",") 'split on comma
		if i=0 then 
			a1=a2
			a2=""
		else
			a1=mid(a2,1,i-1)
			a2=trim(mid(a2,i+1))
		EndIf
		a=a+a1+crlf
	Loop until i=0
	return a
End Function

dim sources(128) as tSource
dim lastsource as integer


function Declarepublicfunctions(ByRef aSource as tSource) as String	
	'aPublics as string,aDefines as string
	dim as String a0,a1,a2,a3,a
	dim as Integer i,j,n
    n=countdefines(aSource)
	dim defines(n) as String
	dim counts(n) as integer
	'
	dim crlf as String = chr(13)+chr(10)
	a2=aSource.defines+","
	n=0
	do
		i=instr(a2,",") 'split on comma
		if i=0 then 
			a1=a2
			a2=""
		else
			a1=mid(a2,1,i-1)
			a2=trim(mid(a2,i+1))
		EndIf
		'
		if a1="" then continue do
		j=instr(a1,"=")
		if j>0 then a3=mid(a1,j+1) else a3="0"
		if j>0 then a1=mid(a1,1,j-1)
		j=val(a3)
		if j=0 then continue do
		n+=1
		defines(n)=a1
		counts(n)=j
'write a1,j		
	Loop until i=0
	'
	a2=aSource.Publics+aSource.definitions
	while len(a2)>0
		i=instr(a2,chr(13))
		if i=0 then
			a1=a2
			a2=""
		else
			a1=mid(a2,1,i)
			a2=mid(a2,i+1)
			
			while len(a2)>2 and mid(a2,1,1)<" "
				a2=mid(a2,2)
			Wend
			j=instr(a1,"(")
			a3=trim(mid(a1,1,j-1))
			if instr(a3,".")>0 then continue while
			for j = 1 to n
				if defines(j)=a3 then
					exit for
				EndIf
			Next
			if defines(j)<>a3 then continue while
			if a1="" then continue while
			a1="declare public function "+a1' +" '" &counts(j)
			a0=a0+a1+chr(13)+chr(10)
		EndIf
	Wend
	a0+=chr(13)+chr(10)
	'
	a2=aSource.Publics+aSource.definitions
	while len(a2)>0
		i=instr(a2,chr(13))
		if i=0 then
			a1=a2
			a2=""
		else
			a1=mid(a2,1,i)
			a2=mid(a2,i+1)
			
			while len(a2)>2 and mid(a2,1,1)<" "
				a2=mid(a2,2)
			Wend
			if a1="" then continue while
			j=instr(a1,"(")
			a3=trim(mid(a1,1,j-1))
			if instr(a3,".")>0 then continue while
			for j = 1 to n
				if defines(j)=a3 then
					exit for
				EndIf
			Next
			if defines(j)=a3 then continue while
			a1="'private function "+a1
			a0=a0+a1+chr(13)+chr(10)
		EndIf
	Wend
'	a0+=chr(13)+chr(10)
	'
	return a0
End Function


function initsource overload (fileno as Integer) as tSource
	dim aSource as tSource
	aSource=functiondefinitions(fileno)
	aSource=prunesource(aSource)
	sources(lastsource)=aSource

	dim as String a
	dim as integer i
	a= tFile.lastfn
	i= instrRev(a,"/")
	if i>0 then a=mid(a,i+1)   
	i= instrRev(a,"\")
	if i>0 then a=mid(a,i+1)   
	i= instr(a,".")
	if i>0 then a=mid(a,1,i) else a=a+"."   
	a= line(a)	
	a=mid(a,1,len(a)-3)
	a=mid(a,2)
	sources(lastsource).token= a
	
'	cls
'	? documentsorce(sources(lastsource))
'	? listdefines(sources(lastsource))
'	?
	return sources(lastsource)
End Function

function initsource overload (filename as string) as tSource
	dim as integer fin
	if (tFile.Openbinary(filename,fin)>0) then
		return initsource(fin)
	endif
	write "io error",fin
	dim aSource as tSource
	return aSource
End Function

function loadsource overload (fileno as Integer) as Integer
	dim aSource as tSource
	lastsource +=1
	sources(lastsource)= initsource(fileno)
	return 0	
End Function
	
function loadsource overload (filename as string) as Integer
	dim as integer fin
	'write "D:\dev\prospector\base\"+filename
	if (tFile.Openbinary("D:\dev\prospector\base\"+filename,fin)>0) then
		'print "found", "D:\dev\prospector\base\"+filename
'		if instr("src\tInit.bas,",filename+",")=0 _
'			then 
		loadsource(fin)
		sources(lastsource).filename=filename
		tFile.Closefile(fin)
		return 0
	endif
	write "io error",fin
	return -1
End Function
	
function loadline(fileno as Integer) as string
	dim as string aline
	dim ch as byte
	dim as integer i=fileno
	while not eof(i)
		get #i,,ch
		'if ch=10 then continue while
		if ch=10 then exit while
		if ch=13 then exit while
		'if ch<asc(" ") then ? ch;
		aline &= chr(ch)	
	Wend
	'print len(aline),aline
	return aline
End Function

function loadsourcefiles(fileno as Integer) as Integer
	dim as string filename
	dim as integer i
	while not eof(fileno)
		'sleep
		filename=loadline(fileno) 
		i=instr(filename,"[") ' = "[next"
		if i>0 then exit while
		if mid(filename,1,5)="Main=" then continue while		
		i=instr(filename,"=") ' = "1=src\cargotrade.bas"
		if i>0 then filename=mid(filename,i+1)
		'?filename
		if filename<>"" then
			if FileExists(filename) then
				loadsource(filename)
			else
				write "io error ",filename
			EndIf
		EndIf
	Wend	
	return 0
End Function

function loadsources(aProject as String) as Integer
	dim as integer fin,fprj
	dim as string finput
	dim as string a
'?"loadsources("+aProject+")"	
	if (tFile.Openinput(aProject,fprj)>0) then
		a=""		
		while not eof(fprj) 
			a=loadline(fprj) 
			if a= "[File]" then
				loadsourcefiles(fprj)
				exit while
			EndIf
		Wend 
		tFile.Closefile(fprj)		
	else
		write "io error",fprj
	EndIf
	
	return 0	
	
	finput= "tCoords" 'tFile,tSavegame	
	finput= "src/"+finput+".bas"	
	if (tFile.Openbinary(finput,fin)>0) then
		loadsource(fin)
	else
		write "io error",fin
	EndIf
	return 0	
End Function
	
dim as integer ndefs
dim as string lasttoken

function xref(aToken as String,iSource as integer) as Integer
	dim as integer i,j,iStart
	dim aSource as tSource
	dim crlf as String = chr(13)+chr(10)
	dim as string a1,a2
	dim as Integer k,l
	dim as integer n

	for i = 1 to lastsource
'? sources(i).token
		if sources(i).token=aToken then
			iStart=i
			exit for
		endif
	next
	if iStart=0 then 
		? "nomatch", aToken
		return 0
	EndIf

	'count defines and dim
	j=countdefines(sources(iStart))
	dim defines(j) as String
	dim counts(j) as integer
	
'a2=defines(j+1)
	
	'get defines 
	a2=sources(i).defines+","
	do
		k=instr(a2,",") 'split on comma
		if k=0 then 
			a1=a2
			a2=""
		else
			a1=mid(a2,1,k-1)
			a2=trim(mid(a2,k+1))
		EndIf
		if (a1<>"") and (instr(a1,".")=0) then
			n += 1
			defines(n)=a1
		EndIf
	Loop until k=0
	j=n

	'count across all other files
	? 
	for i = 1 to lastsource
		if i=iStart then continue for
		'rebuild defines with count
		'j+= findinstring(sources(i).source,
		'count for each define
		'count for each define
		for l = 1 to n
			if len(defines(l))=0 then continue for
			a2=sources(i).source
			do
				k=instr(a2,defines(l)) 'split on token
				if k=0 then 
					a1=a2
					a2=""
				else
					a1=mid(a2,1,k-1)
					a2=trim(mid(a2,k+len(defines(l))))
					counts(l) += 1
				EndIf
			Loop until k=0
		next
		
	Next
	a1=""
	for l = 1 to n
		if defines(l)<>"" then
			ndefs += 1
			a1 += defines(l) +"=" &counts(l) &", "
		EndIf
	Next
	aSource=sources(iSource)
	aSource.defines=mid(a1,1,len(a1)-2)
	sources(iSource)=aSource
'?	sources(iSource).defines
return 0
End Function


function xrefall() as Integer
	dim as integer iSource
	dim as integer ikey
	ndefs=0
	for iSource = 1 to lastsource
		lasttoken=sources(iSource).token
'cls
		'? 
'		? sources(iSource).defines
		xref(lasttoken,iSource)
		'? sources(iSource).defines
		'cls
		'? documentsorce(sources(iSource))
		'? listdefines(sources(iSource))
'		? newsource(sources(iSource))
		dim aSource as tSource
		aSource=sources(iSource)
		dim source as string
		source=newsource(aSource)
? "Writing " &len(source) &"bytes to " + aSource.filename		
		tFile.stringtofile(aSource.filename,source)
'	    ? Declarepublicfunctions(sources(iSource))
		
		continue for
		ikey=Pressanykey
'		? ikey
'		sleep
		if ikey=27 then
			exit for
		EndIf
		'?
		'sleep
'		?"------------"
	Next	
	for iSource = 1 to lastsource
'		? sources(iSource).defines
'		?"------------"
	next	
	'?ndefs
	'?"------------"
	return ikey
End Function

function main() as Integer
	cls
	chdir exepath	
	'dim f as Integer
	'f=freefile
	'open cons for output as #f
	'print #f,"console cons!"
	'close #f
	'Viewfile("D:/dev/prospector/base/error.log")
'	sleep
	'tError.ErrText ="just because!" '+chr(13)+chr(10)
	'tError.ErrText +=filetostring("D:/dev/prospector/base/error.log")
	'return 1
'	return 0
	
	loadsources("prospector.fbp")
	if xrefall()<>27 then
		Pressanykey()		
	EndIf
	'xref("tSlotmachine")
	return 0
End Function

End Namespace


LETSGO:
	On Error goto Errormessage
	tError.ErrorNr= tMain.main()
	goto ErrorHandler 
ERRORMESSAGE:
	On Error goto 0
	tError.ErrorNr= Err
	tError.ErrorLn= Erl
	tError.ErrText= ucase(stripFileExtension(lastword(*ERMN(),"\")))
	tError.ErrText= tError.ErrText &"::" &*ERFN() &"() reporting Error #" &tError.ErrorNr &" at line " &tError.ErrorLn &"!"
ERRORHANDLER:
	tError.ErrorHandler()
DONE:
	End tError.ErrorNr