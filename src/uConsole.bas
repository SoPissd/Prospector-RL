'uConsole.
'
'namespace: uConsole

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(types) or defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: uConsole -=-=-=-=-=-=-=-
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
#include "uConsole.bas"
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
#include "uConsole.bas"
#include "tFonts.bas"
#undef main

#undef intest
#define test
#endif'test


#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: uConsole -=-=-=-=-=-=-=-
#endif'head


namespace uConsole

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: uConsole -=-=-=-=-=-=-=-

dim shared as integer Closing
dim shared as integer bIdling
Dim shared as tActionmethod IdleMethod


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

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: uConsole -=-=-=-=-=-=-=-

function init(iAction as integer) as integer
	Closing=0
	bIdling=0
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
		'ErrOut("received close command")		
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

function Idle(iAction as integer=0) as integer
	if IdleMethod<>null then
		iAction= IdleMethod(bIdling)
		if bIdling=0 then
			bIdling= 1
		endif
	endif
	'?"sleep(1)"
	sleep(1)
	return iAction
End Function	


function iGetKey(iMilliSeconds as integer=0) as integer
	dim as integer i,j,n
	dim as double iUpTo
	dim as string aKey
	ClearKeys()
	if iMilliSeconds>0 then
		iUpTo=iMilliSeconds/1000+Timer()
	EndIf
	bIdling= 0
	do while (Closing=0) and ((iMilliSeconds=0) or (Timer()<iUpTo))
		'print #tKbinput.fErrOut,iUpTo-Timer()
		aKey=aInKey()
		if aKey<>"" then
			'? aKey2i(aKey), akey
			return aKey2i(aKey)
		else
			Idle()
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
	if (Closing=0) then Idle()
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
	ClearKeys
	key=iGetKey()
	?
	return key
End function


function keyinput(allowed as string="") as string
'    DimDebugL(0)'1
    dim as String aKey
	ClearKeys
    do        
		aKey=aGetKey()
    loop until (Closing<>0) or (aKey<>"" and allowed="") or (instr(allowed,aKey)>0) 
    return aKey
end function


#endif'main
End Namespace
#if (defined(main) or defined(test))
	' -=-=-=-=-=-=-=- INIT: uConsole -=-=-=-=-=-=-=-
	tModule.register("uConsole",@uConsole.init()) ',@uConsole.load(),@uConsole.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: uConsole -=-=-=-=-=-=-=-
'redo with uMainloop for testing
''	dim shared as uConsole.tMainloopParams aParams
'	
'	function keypress(aKey as string) as Integer
'		? aKey
'		if aKey="5" then
'			return 3			
'		EndIf
'		return 0
'	End Function
'	
'	function keypress2(aKey as string) as Integer
'		? "@@@ " &aKey &" @@@"
'		if aKey="5" then
'			return 5			
'		EndIf
'		return 0
'	End Function
'	
'	function CmdProc(iAction as Integer) as Integer
'		if iAction=3 then
'			aParams.KeyProc= @keypress2			
'		EndIf
'		if iAction=5 then
'			aParams.KeyProc= @keypress			
'		EndIf
'		return 0
'	End Function
'	
'	aParams.KeyProc= @keypress 
'	aParams.CmdProc= @CmdProc 
'	uConsole.mainloop(aParams)
#endif'test
