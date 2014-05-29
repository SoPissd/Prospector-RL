'tUtils.
#include once "uDefines.bi"
DeclareDependencies()

declare function Namebase(aFile as string) as string 'name nothing else

#include "uDebug.bas"
#include "uiScreen.bas"
#include "file.bi"

#define test 
#endif'DeclareDependencies()

#ifdef types
	const FilenameSlashOk = "/"		'ok on windows and linux
	const FilenameSlashNg = "\"		'not ok on linus

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tUtils -=-=-=-=-=-=-=-

declare function Pad(iLen as integer, aVal as string, aPad as string=" ") as string
declare function PadLeading(iLen as integer, aVal as string, aPad as string=" ") as string
declare function LeadingZero(iLen as integer, iVal as integer, aPad as string="0") as string

declare function FixSlashes(aFile as string) as string
declare function FilePath(aFile as string) as string 'just path/
declare function NoFilePath(aFile as string) as string 'just name.ext
declare function NoFileExt(aFile as string) as string 'just path/name

#ifndef Namebase
declare function Namebase(aFile as string) as string 'name nothing else
#endif

declare function string_towords(word() as string, s as string, break as string, punct as short=0) as short
declare function numfromstr(t as string) as short
declare function lastword(text as string, delim as string, capacity as short=29) As String

declare function first_lc(t as string) as string
declare function first_uc(t as string) as string
declare function roman(i as integer) as string

declare function html_color(c as string, indent as short=0, wid as short=0) as string
declare function ansi2ascii (byval convertstring as string) as string

'declare function Texttofile(text as string) as string
'declare function lev_minimum( a As Integer, b As Integer, c As Integer ) As Integer
'declare function fuzzymatch( s As String, t As String ) As single

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tUtils -=-=-=-=-=-=-=-

namespace tUtils
function init(iAction as integer) as integer
	return 0
end function
end namespace'tUtils


#define cut2top

'
' string creation.  
' pad front/back with arb chars

function Pad(iLen as integer, aVal as string, aPad as string=" ") as string
	if iLen<0 then 
		'pad before
		while len(aVal)<iLen 
			aVal= aPad+aVal
		Wend
	else
		'pad after
		while len(aVal)<iLen 
			aVal += aPad
		Wend
	EndIf
	return aVal
end function

function PadLeading(iLen as integer, aVal as string, aPad as string=" ") as string
	return Pad(-iLen,aVal,aPad)
end function

function LeadingZero(iLen as integer, iVal as integer, aPad as string="0") as string
	return Pad(-iLen,"" & iVal,aPad)
end function

'
' file-name 
'

function FixSlashes(aFile as string) as string
	dim i as Integer=1
	while i>0
		i=Instr(i,aFile,FilenameSlashNg)
		if i>0 then aFile= mid(aFile,1,i-1)+FilenameSlashOk+mid(aFile,i+1)
	Wend
	return aFile
End Function

function FilePath(aFile as string) as string 'just path/
	if Instr(aFile,FilenameSlashNg)>0 then aFile= FixSlashes(aFile)
	return mid(aFile,1,Instrrev(aFile,FilenameSlashOk))
End Function

function NoFilePath(aFile as string) as string 'just name.ext
	if Instr(aFile,FilenameSlashNg)>0 then aFile= FixSlashes(aFile)
	return mid(aFile,Instrrev(aFile,FilenameSlashOk)+1)
End Function

function NoFileExt(aFile as string) as string 'just path/name
	dim i as Integer
	i=Instrrev(aFile,".")-1
	if i<0 then return aFile else return mid(aFile,1,i)
End Function

function Namebase(aFile as string) as string 'name nothing else
	return NoFilePath(NoFileExt(aFile))
End Function

'

function string_towords(word() as string, s as string, break as string, punct as short=0) as short
    dim as short i,a
    'Starts with 0,
    for a=0 to ubound(word)
        word(a)=""
    next
    for a=1 to len(s)
        if i>ubound(word) then
            redim word(i)
        endif
        if mid(s,a,1)=break then
'            DbgPrint(word(i))
            i+=1
        else
            if punct=1 and (mid(s,a,1)="." or mid(s,a,1)=",") then
                i+=1
                word(i)=word(i)&mid(s,a,1)
            else
                word(i)=word(i)&mid(s,a,1)
            endif
        endif
    next
    return i
end function

'

function numfromstr(t as string) as short
    dim as short a
    dim as string t2
    for a=1 to len(t)
        if val(mid(t,a,1))<>0 or (mid(t,a,1))="0" then t2=t2 &mid(t,a,1)
    next
    return val(t2)
end function


function lastword(text as string, delim as string, capacity as short=29) As String
	Dim As String w(capacity)
	return w(string_towords(w(),text,delim))
End function

'

function first_lc(t as string) as string
    return lcase(left(t,1))&right(t,len(t)-1)
end function

function first_uc(t as string) as string
    return Ucase(left(t,1))&right(t,len(t)-1)
end function


function lev_minimum( a As Integer, b As Integer, c As Integer ) As Integer
	var i = a
	If (b<i) Then i = b
	If (c<i) Then i = c
	Return i
End function

function fuzzymatch( s As String, t As String ) As single
	dim as string dic
	Dim As Integer k, i, j, n, m, cost
	dim as single dis
	Dim As Integer Ptr d
	dim as short  f
    f=freefile
    open "data/dictionary.txt" for input as #f
    while not eof(f)
        line input #f,dic
        if ucase(trim(t))=ucase(trim(dic)) then t=""
    wend
    close f
	s=trim(s)
	t=trim(t)
	n = Len(s)
	m = Len(t)
	If (n <> 0) And (m <> 0) Then
	d = allocate( sizeof(Integer) * (m+1) * (n+1) )
    m += 1
    n += 1
    k = 0
    While k < n
    	d[k]=k
        k += 1
    Wend

   k = 0
   While k < m
      d[k*n]=k
      k += 1
   Wend

   i = 1
   While i < n
      j = 1

      While j<m
         If (s[i-1] = t[j-1]) Then
            cost = 0

         Else
            cost = 1

         End If

         d[j*n+i] = lev_minimum(d[(j-1)*n+i]+1, d[j*n+i-1]+1, d[(j-1)*n+i-1]+cost)

         j += 1
      Wend

      i += 1
   Wend

   dis = d[n*m-1]
   deallocate (d)
    if n>m then 
        dis=dis/n
    else
        dis=dis/m
    endif
   Return dis
	Else
   Return -1
End If
End function


function roman(i as integer) as string
    select case i
    case 1
        return "I"
    case 2
        return "II"
    case 3
        return "III"
    case 4
        return "IV"
    case 5
        return "V"
    case 6
        return "VI"
    end select
end function


public function Texttofile(text as string) as string
	
    dim a as short
    dim sHead as short
    dim outtext as string
    outtext="<p>"
    for a=0 to len(text)
        if mid(text,a,1)="|" or mid(text,a,1)="{" then
            if mid(text,a,1)="|" then
                if sHead=1 then
                    outtext=outtext &"</b>"
                    sHead=2
                endif
                if sHead=0 then
                    outtext=outtext &"<b>"
                    sHead=1
                endif
                outtext=outtext &"<br>"'chr(13)& chr(10)
            endif
            if mid(text,a,1)="{" then a=a+3
        else
            outtext=outtext &mid(text,a,1)
        endif
    next
    outtext=outtext &"</p>"
    return outtext
end function


function html_color(c as string, indent as short=0, wid as short=0) as string
    dim t as string
    t= "<span style="&chr(34) &" COLOR:"& c &"; font-family:arial;position:relative"
    if indent>0 then t=t &"; left:"&indent &"px"
    if wid>0 then t=t & ";display:inline-block; width:"&wid &"px"
    t=t & chr(34)& ">"
    return t
end function

'

static shared as ubyte ascansdat(128)={ _
	 63,  63,  39, 159,  34,  46, 197, 206,  94,  37,  83,  60,  79,  63,  63,  63,_
	 90,  39,  39,  34,  34,   7,  45,  45, 126,  84, 115,  62, 111,  63, 122,  89,_
	255, 173, 189, 156, 207, 190, 221, 145, 149, 184, 166, 174, 170, 240, 169, 238,_
	248, 241, 253, 252, 239, 230, 244, 250, 247, 251, 167, 175, 172, 171, 243, 168,_
	183, 181, 182, 199, 142, 143, 146, 128, 212, 144, 210, 211, 222, 214, 215, 216,_
	209, 165, 227, 224, 226, 229, 153, 158, 157, 235, 233, 234, 154, 237, 232, 160,_
	225, 133, 131, 198, 132, 134, 145, 135, 138, 130, 136, 137, 141, 161, 140, 139,_
	208, 164, 149, 162, 147, 228, 148, 246, 155, 151, 163, 150, 129, 236, 231, 152}

function ansi2ascii (byval convertstring as string) as string
	'from http://www.freebasic-portal.de/tutorials/umlaute-richtig-darstellen-25-s2.html
	dim as string outstring=convertstring
	dim as integer i
    for i as integer=0 to len(outstring)-1
    	if outstring[i]>127 then outstring[i]=ascansdat(outstring[i]-128)
    next i
	return outstring
end function

'

#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tUtils -=-=-=-=-=-=-=-
	tModule.register("tUtils",@tUtils.init()) ',@tUtils.load(),@tUtils.save())
#endif'main

#if (defined(test) or defined(registerTests))
#print -=-=-=-=-=-=-=- TEST:  -=-=-=-=-=-=-=-

	namespace tUtils

	sub Utilstest()
		?"TEST: tUtils"
		
		'	const FilenameSlashOk = "/"		'ok on windows and linux
		'	const FilenameSlashNg = "\"		'not ok on linus
		
		
		? command(0)
		? FixSlashes(command(0))
		? NoFilePath(command(0))
		? NoFilePath(FixSlashes(command(0)))
		? FilePath(command(0))
		? NoFilePath(NoFileExt(command(0)))
		? NoFilePath(NoFileExt("test"))
		? __FILE__
		? lastword(command(0),"\")
		? lastword(command(0),"/")
		?
		? tModule.Status
	End Sub

	end namespace'
	
	#ifdef test
		tUtils.Utilstest()
		? "sleep": sleep
	#else
		tModule.registertest("uUtils",@tUtils.Utilstest())
	#endif'test
#endif'test
