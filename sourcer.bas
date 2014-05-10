' sourcer.bas
' sourcer.bi

#include "fbGfx.bi"
#include "file.bi"
#include "zlib.bi"
#include "windows.bi"

'
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
					if instr(d,c)=0 then d=d+c+", "
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

function line(text as string="",iwidth as integer=60,itries as integer=7) as string
	dim aline as String
	aline= add(text) '+ chr(13) + chr(10)
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
function documentsorce(ByRef aSource as tSource) as tSource
	? line(finput) 
	if len(aSource.namespc)>0 then
		 ? line()+line("namespace: " + aSource.namespc)+line() 
	endif
	if len(aSource.defines)>0 then
		 ? line()+line("defines:")+line(aSource.defines,60,15)+line() 
	endif
	if len(aSource.publics)>0 then
		 ? line()+line("publics:")+line(aSource.publics,120)+line() 
	endif
	if len(aSource.definitions)>0 then
		 ? line()+line("definitions:")+line(aSource.definitions,120)+line() 
	endif
	return aSource	
End Function



function go() as Integer
	dim aSource as tSource
	aSource=functiondefinitions(fin)
	aSource=documentsorce(aSource)	
	return 0	
End Function
	


function main() as Integer
'#include "src/tColor.bas"
'#include "src/Version.bas"
'#include "src/kbinput.bas"
'#include "file.bi"
'#include "src/tFile.bas"
'#include "src/tUtils.bas"
'#include "src/tError.bas"
	finput= "tCoords" 'tFile,tSavegame
	
	finput= "src/"+finput+".bas"	
	foutput= left(finput,len(finput)-1)
	'? finput," -> ",foutput

	if (tFile.Openbinary(finput,fin)>0) then
	'and (tFile.Openoutput(foutput,fout)>0)
	
		go()
	else
		write "io error",fin,fout
	EndIf
	return 0
End Function

End Namespace


LETSGO:
	'On Error goto Errormessage
	cls
	tError.ErrorNr= tMain.main() 
	'Pressanykey()
	goto done
ERRORMESSAGE:
?"ERRORMESSAGE"
debugbreak
	On Error goto 0
	tError.ErrorNr= Err
	tError.ErrorLn= Erl
	tError.ErrText= ucase(stripFileExtension(lastword(*ERMN(),"\")))
	tError.ErrText= tError.ErrText &":" &*ERFN() &" reporting Error #" &tError.ErrorNr &" at line " &tError.ErrorLn &"!"  
	tError.ErrorHandler()
WAITANDEXIT:
	Print
	Print
	Pressanykey()
DONE:
	End tError.ErrorNr
