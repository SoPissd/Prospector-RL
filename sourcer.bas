' sourcer.bas
' sourcer.bi

#include "fbGfx.bi"
#include "file.bi"
#include "zlib.bi"
#include "windows.bi"

'
#include "src/tModule.bas"
#include "src/tPng.bas"
#include "src/tGraphics.bas"

#include "src/tColor.bas"
#include "src/Version.bas"
#include "src/kbinput.bas"
#include "src/tFile.bas"
#include "src/tUtils.bas"
#include "src/tError.bas"

'
' patch up expectations for version.bas
Function savegame(crash as short=0) As Short
	return 0
End Function

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
			if instr(lcase(c),"declare ")=0 then
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
					if instr(d,c+",")=0 then d=d+c+", "
				EndIf
			EndIf
		EndIf
	Wend
	aSource.defines = mid(d,1,len(d)-2)
	aSource.publics = e '+chr(13)+chr(10)
	aSource.definitions = b '+chr(13)+chr(10)
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
	dim as integer i, j
	a= finput
	i= instr(a,"/")
	if i>0 then a=mid(a,i+1)   
	i= instr(a,".")
	if i>0 then a=mid(a,1,i) else a=a+"."   
	a= line(a)	
	a=mid(a,1,len(a)-3)
	a=mid(a,2)
	aSource.token= a
	a=line(a+".")
	'if len(aSource.namespc)>0 then
	'endif
	if len(aSource.namespc)>0 then
		a += line()+line("namespace: " + aSource.namespc)+line() 
	endif
	if len(aSource.defines)>0 then
		 a += line()+line("defines:")+line(aSource.defines,60,15)+line() 
	endif
	if len(aSource.publics)>0 then
		 a += line()+line("publics:")+line(aSource.publics,120)+line() 
	endif
	if len(aSource.definitions)>0 then
		 a += line()+line("definitions:")+line(aSource.definitions,120)+line() 
	endif
	return a	
End Function


function prunesource(ByRef aSource as tSource) as Integer
	dim a as String
	dim ch as String
	dim adoc as String
	dim as integer i,li,j,n
	n=len(aSource.source)
	i=1
	li=i
	while (i<n)
		li=i
		j= instr(i,aSource.source,chr(13))
		a= mid(aSource.source,i,j-1)
		i+=j
		while i<n and mid(aSource.source,i,1)<" "
			i+=1
		Wend
'		j=1
'		while j<len(a) and mid(a,j,1)<" "
'			j+=1
'		Wend
'		a=mid(a,j)
'? ">"+a+"<"		
		if mid(a,1,1)="'" then a=""
		if a<>"" then exit while
		'i += 1
	Wend
	aSource.source=mid(aSource.source,li)
	return 0
End Function

function newsource(ByRef aSource as tSource) as string
	dim adoc as String
	dim afun as String
	dim aend as String
	dim crlf as String = chr(13)+chr(10)
	afun=""	
	aend=""	
	if len(aSource.namespc)=0 then
		afun += crlf
		afun += "namespace "+aSource.token +crlf
		afun += crlf
		'
		aend += "end namespace'"+aSource.token +crlf
	EndIf
	'
	afun += "#ifdef head" +crlf
	afun += "#print -=-=-=-=-=-=-=-HEAD" +crlf
	afun += crlf
	afun += crlf
	afun += "#endif'head" +crlf
	afun += "#ifdef main" +crlf
	afun += "#print -=-=-=-=-=-=-=-MAIN" +crlf
	afun += crlf
	afun += "public function init()" +crlf
	afun += chr(9) +"return 0" +crlf
	afun += "end function" +crlf
	afun += crlf
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
	'
	aend = "#endif'main" +crlf + aend
	aend += crlf
	aend += "#ifdef main" +crlf
	aend += chr(9) +"tModule.register("
	aend += """"+aSource.token+""""+","
	aend += "@"+aSource.token+".init(),"
	aend += "@"+aSource.token+".load(),"
	aend += "@"+aSource.token+".save())"
	aend += crlf
	aend += "#endif'main" +crlf
	'		
	return documentsorce(aSource) + afun + aSource.source + aend 
End Function


function listdefines(ByRef aSource as tSource) as string
	dim crlf as String = chr(13)+chr(10)
	dim as string a,a1,a2
	dim as Integer i,j
	a2=aSource.defines+","
'? ":"+a2+":"	
	do
		i=instr(a2,",")
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

function initsource overload (fileno as Integer) as tSource
	dim aSource as tSource
	aSource=functiondefinitions(fileno)
	prunesource(aSource)
'	cls
	? documentsorce(sources(lastsource))
	? listdefines(sources(lastsource))
	?
	return aSource
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
	sources(lastsource)=initsource(fileno)
	return 0	
End Function
	
function loadsource overload (filename as string) as Integer
	dim as integer fin
	if (tFile.Openbinary("D:\dev\prospector\base\"+filename,fin)>0) then
		return loadsource(fin)
	endif
	return -1	
End Function
	
function loadline(fileno as Integer) as string
	dim as string aline
	dim ch as byte
	dim as integer i=fileno
	while not eof(fileno)
		get #i,,ch
		'if ch=10 then continue while
		if ch=10 then exit while
		if ch=13 then exit while
		aline &= chr(ch)	
	Wend
	print len(aline)
	return aline
End Function

function loadsourcefiles(fileno as Integer) as Integer
	dim as string filename
	dim as integer i
	while not eof(fileno)
		'sleep
		filename=loadline(fileno) 
		i=instr(filename,"=") ' = "1=src\cargotrade.bas"
		if i>0 then filename=mid(filename,i+1)
?filename
		loadsource(filename)
	Wend	
	return 0
End Function

function loadsources(aProject as String) as Integer
	dim as integer fin,fprj
	dim as string finput
	dim as string a
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
	

function main() as Integer
	chdir exepath
	loadsources("prospector.fbp")
	return 0
End Function

End Namespace


LETSGO:
	'On Error goto Errormessage
	tError.ErrorNr= tMain.main() 
	'Pressanykey()
	goto done
ERRORMESSAGE:
	On Error goto 0
	tError.ErrorNr= Err
	tError.ErrorLn= Erl
?"ERRORMESSAGE"
debugbreak
	tError.ErrText= ucase(stripFileExtension(lastword(*ERMN(),"\")))
	tError.ErrText= tError.ErrText &":" &*ERFN() &" reporting Error #" &tError.ErrorNr &" at line " &tError.ErrorLn &"!"  
	tError.ErrorHandler()
WAITANDEXIT:
	Print
	Print
	Pressanykey()
DONE:
	End tError.ErrorNr
