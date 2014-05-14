'tConsole.
'
'namespace: tConsole

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tConsole -=-=-=-=-=-=-=-
#include "fbGfx.bi"
#include "zlib.bi"
#include "File.bi"

#undef intest
#undef both
#define head
#undef main
#include "tDefines.bas"
#define main
#include "tModule.bas"
#undef head
#include "tDefines.bas"
#define head
#include "tScreen.bas"
#include "tColor.bas"
#include "tPng.bas"
#undef main
#include "tConsole.bas"
#include "tFonts.bas"
#define main
#define head
#include "tFile.bas"
#include "tGraphics.bas"
#include "tRng.bas"
#define head
#include "tCoords.bas"
#include "tMath.bas"
#include "tPrint.bas"
#include "Version.bas"
#include "tUtils.bas"
#include "tError.bas"
#include "tSound.bas"
#include "tStars.bas"
#include "tConfig.bas"
#include "tMenu.bas"
#undef head
#include "tConsole.bas"
#include "tFonts.bas"
#undef main

#undef intest
#define test
#endif'test


#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tConsole -=-=-=-=-=-=-=-
declare function LogOut(aText as string,fileno as integer=0) as integer
declare function ErrOut(aText as String) as Integer
#endif'head


namespace tConsole

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tConsole -=-=-=-=-=-=-=-

dim shared as integer Closing

Const xk= Chr(255)
Const key__close = 	xk & "k"

declare function iInKey() as Integer
declare function iGetKey(iMilliSeconds as integer=0) as integer
declare function iKey2a(iKey as Integer) as String

declare function aInKey() as String
declare function aGetKey(iMilliSeconds as integer=0) as String
declare function aKey2i(aKey as String) as Integer

declare function Pressanykey(aRow as Integer=2,aCol as Integer=0,aFg as Integer=0,aBg as Integer=0) as Integer
declare function ClearKeys() as integer
declare function keyinput(allowed as string="") as string


dim shared as integer fLogOut
dim shared as integer fErrOut

declare function LogWrite(aText as string,fileno as integer=0) as integer
declare function ErrorLog(aText as string) as integer
	

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tConsole -=-=-=-=-=-=-=-

function init() As integer
	Closing=0
	'
	fErrOut=freefile
	open err for output as fErrOut
	fLogOut= fErrOut
	return 0
End function

'

function iKey2a(iKey as Integer) as String
	dim as string aKey
    if iKey=0 then
    	aKey=""
    elseif iKey<256 then
		aKey=chr(iKey)		
    else
		aKey=chr(255) + chr(iKey shr 8)		
    endif
	return aKey	
End Function

function aKey2i(aKey as String) as Integer
    if aKey="" then
    	return 0
    elseif len(aKey)=1 then
		return asc(mid(aKey,1,1))		
	else
		return (asc(mid(aKey,2,1)) shl 8) + asc(mid(aKey,1,1))
    endif
End Function	

'

function aProcessKey(aKey as String) as String
'	?"aProcessKey(" &aKey &",len=" &len(aKey) &")",asc(mid(akey,2,1))
	if akey= key__close then
		Closing=1
		print fErrOut,"received close command"		
	EndIf 
	return aKey	
End Function

function iProcessKey(iKey as Integer) as Integer
	dim as string aKey
    aKey=aProcessKey(iKey2a(iKey))
	return iKey	
End Function

'

function aInKey() as String
	return aProcessKey(Inkey())
End Function

function iInKey() as Integer
    dim as string aKey
    aKey= aInKey()
    return aKey2i(aKey)
End Function	

function iGetKey(iMilliSeconds as integer=0) as integer
	ClearKeys()
	if iMilliSeconds=0 then
		return iProcessKey(GetKey())
	EndIf
	dim as integer i,j,n
	dim as double iUpTo
	iUpTo=iMilliSeconds/1000+Timer()
	dim as string aKey
	do while (Timer()<iUpTo)
		'print #tKbinput.fErrOut,iUpTo-Timer()
		aKey=aInKey()
		if aKey<>"" then
'? aKey2i(aKey), akey
			return aKey2i(aKey)
		sleep(1)
		EndIf
	Loop
	return 0	
End Function

function aGetKey(iMilliSeconds as integer=0) as String
	dim as Integer iKey= iGetKey(iMilliSeconds)
'?ikey
	return iKey2a(iKey)
End Function


function ClearKeys() as integer
	do while iInKey()<>0: loop
	return 0	
End Function


function Pressanykey(aRow as Integer=2,aCol as Integer=0,aFg as Integer=0,aBg as Integer=0) as Integer
	dim key as integer
	if (aFg>0) then
		tColor.set(aFg,aBg)
	EndIf
	while aRow>0
		?
		aRow -=1
	Wend
	tScreen.loc(aRow,aCol)
	Print "Press any key to exit";
	do while aInkey<>"": loop
	key=iGetKey()
	?
	return key
End function


function keyinput(allowed as string="") as string
'    DimDebugL(0)'1
    dim as String aKey
	ClearKeys
    do        
		aKey=tConsole.aGetKey()
    loop until (aKey<>"" and allowed="") or (instr(allowed,aKey)>0) 
    return aKey
end function

'

function LogWrite(aText as string,fileno as integer=0) as integer
	if fileno<=0 then fileno=fLogOut
	if fileno>0 then 
		print #fileno, aText
		return len(aText)
	else
		return 0
	EndIf
End Function

function ErrorLog(aText as string) as integer
	return LogWrite(aText,fErrOut)	
End Function

'


'dim shared as integer iWheel 
'
'function mouseconsole(mx as integer, my as integer, mwheel as integer, mbuttons as integer) as integer
'	LogWrite("mouseconsole: " &mx &", " &my &", " &mwheel-iWheel &", " &mbuttons)
'	iWheel= mwheel	
'	return 0	
'End Function
'
'function mousegraphic(mx as integer, my as integer, mwheel as integer, mbuttons as integer) as integer
'	dim as integer x,y
'	x=pos()
'	y=csrlin()	
'	locate 10,10
'	? x,y,mx, my, mwheel-iWheel, mbuttons
'	iWheel= mwheel	
'	locate x,y
'	return 0	
'End Function
'
'        
'        if mclip=-1 then
'        	mouseconsole(mx, my, mwheel, mbuttons)
'        else
'        	mousegraphic(mx, my, mwheel, mbuttons)
'        EndIf

type tGetMouse
    dim as integer mx, my, mwheel, mbuttons, mclip	
End Type

dim shared Lastmouse as tGetMouse

type tConfirmClose As Function() as Integer
type tProcesskey As Function(aKey as string) as Integer
type tProcessmouse As Function(ByRef aMouse as tGetMouse) as Integer
type tProcessaction As Function(iAction as Integer) as Integer
	
type tMainloopParams
	dim KeyProc as tProcesskey
	dim MouseProc as tProcessmouse
	dim NoMouse as short
	dim ConfirmClose as tConfirmClose
	dim Processaction as tProcessaction
End Type


'define function tProcesskey(aKey as string) as Integer
'define function tProcessmouse(ByRef aMouse as tGetMouse) as Integer

function mainloop(ByRef aParams as tMainloopParams) as Integer
    dim as integer mx, my, mwheel, mbuttons, mclip 
	dim as integer iChanged
	dim as integer iCmd
	dim as string aKey
   	while Closing=0 and (iCmd<> -1)
   		if iCmd=0 then
			aKey=tConsole.aInKey()
			if closing=1 then 
				'close	
				if aParams.ConfirmClose<>null then
					if aParams.ConfirmClose()<>0 then
						closing=0
					EndIf
				endif
				if closing=1 then 
					continue while
				endif
			EndIf
			'
			if aKey<>"" then
				'processkey	
				if aParams.KeyProc<>null then
					iCmd=aParams.KeyProc(aKey)
				endif
			EndIf
   		EndIf
		'
		if iCmd=0 and aParams.NoMouse=0 then
	        getmouse mx, my, mwheel, mbuttons, mclip
	        if Lastmouse.mx<>mx or Lastmouse.my<>my or Lastmouse.mwheel<>mwheel or Lastmouse.mclip<>mclip then
				Lastmouse.mx= mx  
				Lastmouse.my= my 
				Lastmouse.mwheel= mwheel 
				Lastmouse.mclip= mclip
				'mousechanged()        	
				if aParams.MouseProc<>null then
					iCmd=aParams.MouseProc(Lastmouse)
				endif
	        EndIf 
		EndIf
		'
		if iCmd<>0 then
			'processkey	
			if aParams.Processaction<>null then
				iCmd=aParams.Processaction(iCmd)
			else
				iCmd=0
			endif
		EndIf
		'
		sleep(1)
   	Wend
   	return closing
End Function

#endif'main

End Namespace


#if defined(main)

function LogOut(aText as string,fileno as integer=0) as integer
	return tConsole.LogWrite(aText,fileno)
End Function

function ErrOut(aText as String) as Integer
	return tConsole.ErrorLog(aText)
End Function
#endif'main


#if (defined(main) or defined(test))
	' -=-=-=-=-=-=-=- INIT: tConsole -=-=-=-=-=-=-=-
	tModule.register("tConsole",@tConsole.init()) ',@tConsole.load(),@tConsole.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tConsole -=-=-=-=-=-=-=-
	print #tConsole.fErrOut,"#fErrOut: error console open as #" &tConsole.fErrOut &"!"
	dim shared as tConsole.tMainloopParams aParams
	
	function keypress(aKey as string) as Integer
		? aKey
		if aKey="5" then
			return 3			
		EndIf
		return 0
	End Function
	
	function keypress2(aKey as string) as Integer
		? "@@@ " &aKey &" @@@"
		if aKey="5" then
			return 5			
		EndIf
		return 0
	End Function
	
	function Processaction(iAction as Integer) as Integer
		if iAction=3 then
			aParams.KeyProc= @keypress2			
		EndIf
		if iAction=5 then
			aParams.KeyProc= @keypress			
		EndIf
		return 0
	End Function
	
	aParams.KeyProc= @keypress 
	aParams.Processaction= @Processaction 
	tConsole.mainloop(aParams)
#endif'test
