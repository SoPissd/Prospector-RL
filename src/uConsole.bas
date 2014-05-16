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

dim shared as integer 		Closing
dim shared as integer 		bIdling
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

declare function keyaccept(ByRef aKey as string,const allowed as string="") as short
declare function keyinput(const allowed as string="") as string

'declare function keyinput(allowed as string="") as string


Const key__esc = 	Chr(27)
Const key__enter =	Chr(13)
Const key__space =	Chr(32)

Const xk= Chr(255)
Const key__up = 	xk & "H"
Const key__dn = 	xk & "P"
Const key__rt= 		xk & "M"
Const key__lt = 	xk & "K"

Dim Shared As String*3 key_nw="7"
Dim Shared As String*3 key_north="8"
Dim Shared As String*3 key_ne="9"
Dim Shared As String*3 key_west="4"
Dim Shared As String*3 key_east="6"
Dim Shared As String*3 key_sw="1"
Dim Shared As String*3 key_south="2"
Dim Shared As String*3 key_se="3"


declare function isKeyYes(aKey as string) as short
declare function isKeyNo(aKey as string) as short
declare function keyplus(key as string) as short
declare function keyminus(key as string) as short

declare function getdirection(key as string) as short




#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: uConsole -=-=-=-=-=-=-=-

function init(iAction as integer) as integer
	Closing=0
	bIdling=0
	return 0
End function

'
'freely convert between one of each form of key-expression
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
' scan the key-input stream character by character looking for special keys
'

function aProcessKey(aKey as String) as String
	'and that's is, recognize a single command
	if akey= key__close then
		Closing=1
		'ErrOut("received close command")		
	EndIf 
	'?"aProcessKey(" &aKey &",len=" &len(aKey) &")",asc(mid(akey,2,1))
	return aKey	
End Function

function iProcessKey(iKey as Integer) as Integer
	'for the int version, convert and process
	dim as string aKey
    aKey=aProcessKey(iKey2a(iKey))
	return iKey	
End Function

'
' waiting for key-input we run into the idle-concept.
' the code in this unit works together to let you use the IdleMethod(bIdling) parameter
' to recognize that you're idling for the first time. use that for screen updates.
' nothing needs to happen once bIdling is true but you could update a performance counter. 
'

function Idle(iAction as integer=0) as integer
	if IdleMethod<>null then
		iAction= IdleMethod(bIdling)
		if bIdling=0 then
			bIdling= 1
		endif
	endif
	sleep(1)		'lets the operating system have all the time it needs/wants to show 0% cpu use.
	return iAction	'interpreted as a key
End Function


'
' wrappers for the built-in key-getters.  make sure to always use them!
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

'
'
'

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


function keyaccept(ByRef aKey as string,const allowed as string="") as short
	'validates against a comma delimited list of keys
    return (aKey<>"" and (allowed="" or allowed="," or (instr(","+allowed,","+aKey)>0))) 
end function

function keyinput(const allowed as string="") as string
	'accepts a comma delimited list of keys to accept. or it just takes any.
    dim as String aKey
	ClearKeys
    do        
		aKey=aGetKey()
    loop until (Closing<>0) or keyaccept(aKey,allowed) 
    return aKey
end function

'
'
'

function isKeyYes(aKey as string) as short
	return keyaccept(aKey,key__enter+",y,Y, ")	
End Function

function isKeyNo(aKey as string) as short
	return keyaccept(aKey,key__esc+",n,N")	
End Function

function keyplus(key as string) as short
	return keyaccept(aKey,key__up+","+key__lt+","+key_south+",+")	
end function

function keyminus(key as string) as short
	return keyaccept(aKey,key__dn+","+key__rt+","+key_north+",-")	
end function

function getdirection(key as string) as short
    dim d as short
    if key=key_sw then return 1
    if key=key_south then return 2
    if key=key_se then return 3
    if key=key_west then return 4
    
    if key=key_east then return 6
    if key=key_nw then return 7
    if key=key_north then return 8
    if key=key_ne then return 9
    '
    if key=key__dn then return 2
    if key=key__lt then return 4
    if key=key__rt then return 6
    if key=key__up then return 8
    return 0
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
