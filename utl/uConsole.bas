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
#undef both
#define types
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: uConsole -=-=-=-=-=-=-=-
#undef intest

#include "fbGfx.bi"
'#include "zlib.bi"
#include "file.bi"

#include "uDefines.bas"
#include "uModule.bas"
#include "uDefines.bas"

#include "uScreen.bas"
#include "uColor.bas"
'#include "uPng.bas"
'
'#include "uConsole.bas"
'#include "uFonts.bas"
'#include "uFile.bas"
'#include "uGraphics.bas"
'#include "uRng.bas"
'#include "uCoords.bas"
'#include "uMath.bas"
'#include "tPrint.bas"
'#include "Version.bas"
'#include "tUtils.bas"
'#include "tError.bas"
'#include "tSound.bas"
'#include "tStars.bas"
'#include "tConfig.bas"
'#include "tMenu.bas"
'#include "uConsole.bas"
'#include "tFonts.bas"

#define test
#endif'test


#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
'some key-constants
'http://www.freebasic.net/wiki/wikka.php?wakka=KeyPgInkey
'http://www.freebasic.net/wiki/wikka.php?wakka=GfxScancodes

Const key__bell=		Chr(7)	'\a
Const key__backspace=	Chr(8)	'\b
Const key__tab=			Chr(9)	'\t
Const key__lfeed=		Chr(10)	'\n
Const key__vtab=		Chr(11)	'\v
Const key__ffeed=		Chr(12)	'\f
Const key__enter=		Chr(13)	'\r
Const key__colbrk=		Chr(14)	'	'Column Break
Const key__shftin=		Chr(15)	'	'Shift In
Const key__esc= 		Chr(27)
Const key__space=		Chr(32)
Const key__dquote=		Chr(34)	'"
Const key__squote=		Chr(39)	''

Const xk= Chr(255)
Const key__close = 	xk & "k"		'Close window / Alt-F4

Const key__ul = 	xk & "G"		'Up Left / Home
Const key__up = 	xk & "H"		'Up
Const key__ur = 	xk & "I"		'Up Right / PgUp

Const key__lt = 	xk & "K"		'Left
Const key__ct = 	xk & "L"		'Center / here
Const key__rt= 		xk & "M"		'Right

Const key__dl = 	xk & "O"		'Down Left / End
Const key__dn = 	xk & "P"		'Down		
Const key__dr = 	xk & "Q"		'Down Right / PgDn

'needs more numpad keys
'list fkeys by name?

Const key__Ins= 	xk & "R"		'Insert		
Const key__Del= 	xk & "S"		'Delete		

'lists of constant keys
Const keyl_yes=			key__enter+",y,Y, "
Const keyl_no=			key__esc+",n,N"	
Const keyl_onwards=		key__esc+","+key__backspace+","+key__enter+", "	

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: uConsole -=-=-=-=-=-=-=-

'these are the configurable directions for getdirection below 
Dim Shared As String*3 key_sw		="1"
Dim Shared As String*3 key_south	="2"
Dim Shared As String*3 key_se		="3"
Dim Shared As String*3 key_west		="4"
Dim Shared As String*3 key_here		="5"
Dim Shared As String*3 key_east		="6"
Dim Shared As String*3 key_nw		="7"
Dim Shared As String*3 key_north	="8"
Dim Shared As String*3 key_ne		="9"

'lists of configurable keys
#define keyl_plus		key__up+","+key__rt+","+key_north+",+"
#define keyl_minus		key__dn+","+key__lt+","+key_south+",-"
#define keyl_menup		"-,"+key__ur
#define keyl_mendn		"+,"+key__dr
#endif'head


namespace uConsole

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: uConsole -=-=-=-=-=-=-=-
dim shared as string		LastKey
dim shared as integer 		Closing
dim shared as integer 		bIdling
Dim shared as integer		Fps			'most recent fps
Dim shared as double		Fpstime		'time of most recent fps

Dim shared as tActionmethod IdleMethod

'

declare function dTimer() as double			'prevent wrap-around errors
'
declare function EventPending() as short	'0 if nothing pending, 1 has buffered

declare function iInKey() as Integer
declare function iGetKey(iMilliSeconds as integer=0) as integer
declare function iKey2a(iKey as Integer) as String

declare function aInKey() as String
declare function aGetKey(iMilliSeconds as integer=0) as String
declare function aKey2i(aKey as String) as Integer

declare function Pressanykey(aRow as Integer=2,aCol as Integer=0,aFg as Integer=0,aBg as Integer=0) as Integer
declare function ClearKeys() as integer

declare function keyaccept overload (ByRef aKey as string,allowed as string="") as short
declare function keyaccept overload (iKey as integer,allowed as string="") as short
declare function keyinput(allowed as string="") as string

declare function isKeyYes(aKey as string="") as short
declare function isKeyNo(aKey as string="") as short
declare function keyplus(aKey as string="") as short
declare function keyminus(aKey as string="") as short
declare function keyonwards(aKey as string="") as short

declare function getdirection(aKey as string="", bJustNumpad as short=0) as short 

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: uConsole -=-=-=-=-=-=-=-

function init(iAction as integer) as integer
	Closing=false		'e.g. run, no reason to exit 
	bIdling=false		'e.g. am not and have not been idling (yet)
	Fpstime=dTimer()	'makes the first fps value 'right'er
	'dLastTime= n/a 	'no need to set/reset this. it tracks overall run-time, not 'a run'. 
	return 0
End function

'
' deal with the wrap-around timer
'

dim dDays as integer=0		'incidentally track the number of days running
dim dLastTime as double=0	'to track a wrap-around, keep the last value here

function dTimer() as double
	dim dTime as double= Timer()					'pin down current time 
	if (dTime<dLastTime) and (dLastTime>0) then dDays +=1	'got a wraparound!
	dLastTime= dTime + dDays*24*60*60						'adjust the timer
	return dLastTime
End function

'
' waiting for key-input we run into the idle-concept.
' the code in this unit works together to let you use the IdleMethod(bIdling) parameter
' to recognize that you're idling for the first time. use that for screen updates.
' nothing needs to happen once bIdling is true but you could update a performance counter. 
'

sub Fpsupdate()
	'?"updatefps"
	dim dtime as double 
	dTime=Fpstime 
	Fpstime=uConsole.dTimer() 
	dTime=Fpstime-dTime
	Fps=1000/(dTime*1000)
	if Fps>=1000 then Fps=999
end sub

function Idle(iAction as integer=0) as integer
	Fpsupdate()
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
' check to see if something is pending at all.
'   screenevent needs to get used by inkey if we want to track get/loose focus in the app

function EventPending() as short		'0 if nothing pending, 1 has buffered
	return Screenevent(0)
End Function

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
	'everything runs through here.
	'and that's it, keep a copy and recognize a single command
	LastKey= aKey
	if akey= key__close then
		Closing=true
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
' wrappers for the built-in key-getters.  make sure to always use them!
'

function aInKey() as String
	'everything runs through here.
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
		iUpTo=iMilliSeconds/1000+uConsole.dTimer()
	EndIf
	bIdling= 0
	do while (not Closing) and ((iMilliSeconds=0) or (uConsole.dTimer()<iUpTo))
		'print #tKbinput.fErrOut,iUpTo-uConsole.dTimer()
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
	return iKey2a(iKey)
End Function

'
' now that we can, lets get some keys. any keys at all :)
'

function ClearKeys() as integer
	do while iInKey()<>0: loop
	if (not Closing) then Idle()
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

'
' lets optionally restrict the input to sets of keys defined as comma-delimited lists of keys 
'

function validateaccept(ByRef allowed as string) as short
	'validates a comma delimited list of keys	
	if len(allowed)<=1 then return 0
	dim as integer i,n
	n=len(allowed)
	i=1
	while i<n
		if mid(allowed,i,1)=xk then i+=1 'whatever it is, the next char is now included.
		i+=1
		if i=n then continue while
		if mid(allowed,i,1)<>"," then
			allowed=mid(allowed,1,i-1)+","+mid(allowed,i,1)
			n+=1			
		EndIf			
		if mid(allowed,i,1)="," then i+=1 'that's just what we wanted
	Wend 
    return 0 
end function

function keyaccept(ByRef aKey as string,allowed as string="") as short
	validateaccept(allowed)'validates against a comma delimited list of keys
    return (aKey<>"" and (allowed="" or allowed="," or (instr(","+allowed,","+aKey)>0))) 
end function

function keyaccept (iKey as integer,allowed as string="") as short
	return keyaccept(iKey2a(iKey),allowed)
End Function

function keyinput(allowed as string="") as string
	'accepts a comma delimited list of keys to accept. or it just takes any.
    dim as String aKey
	ClearKeys
    do        
		aKey=aGetKey()
    loop until Closing or keyaccept(aKey,allowed) 
    return aKey
end function

'
' and lets allow keys to be categorized after the fact.
'

function isKeyYes(aKey as string="") as short
	if aKey="" then aKey=LastKey
	return keyaccept(aKey,keyl_yes)
End Function

function isKeyNo(aKey as string="") as short
	if aKey="" then aKey=LastKey
	return keyaccept(aKey,keyl_no)	
End Function
	
function keyplus(aKey as string="") as short
	if aKey="" then aKey=LastKey
	return keyaccept(aKey,keyl_plus)	
end function

function keyminus(aKey as string="") as short
	if aKey="" then aKey=LastKey
	return keyaccept(aKey,keyl_minus)	
end function

function keyonwards(aKey as string="") as short
	if aKey="" then aKey=LastKey
	return keyaccept(aKey,keyl_onwards)	
end function

function getdirection(aKey as string="", bJustNumpad as short=0) as short
	'bJustNumpad=0 -- test both
	'bJustNumpad=1 -- test just numpad keys for directionality
	'bJustNumpad=2 -- test just custom movement keys for directionality
	
	if aKey="" then aKey=LastKey
	if (bJustNumpad=0) then bJustNumpad= 3
	'
	if (bJustNumpad and 1) then 
	    if keyaccept(aKey,key__ul)		then return 7
	    if keyaccept(aKey,key__up)		then return 8
	    if keyaccept(aKey,key__ur)		then return 9
	
	    if keyaccept(aKey,key__lt) 		then return 4
	    if keyaccept(aKey,key__ct) 		then return 5
	    if keyaccept(aKey,key__rt)		then return 6
	
	    if keyaccept(aKey,key__dl) 		then return 1
	    if keyaccept(aKey,key__dn) 		then return 2
	    if keyaccept(aKey,key__dr) 		then return 3
	endif
	'
	if (bJustNumpad and 2) then 
	    if keyaccept(aKey,key_nw)		then return 7
	    if keyaccept(aKey,key_north)	then return 8
	    if keyaccept(aKey,key_ne)		then return 9
	
	    if keyaccept(aKey,key_west) 	then return 4
	    if keyaccept(aKey,key_here) 	then return 5
	    if keyaccept(aKey,key_east)		then return 6
	
	    if keyaccept(aKey,key_sw) 		then return 1
	    if keyaccept(aKey,key_south) 	then return 2
	    if keyaccept(aKey,key_se) 		then return 3
	endif
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
#undef test

'#include once "uWindows.bas" 'auto-close,expectedconsole

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


sub ascii_table()
	?"showing extended ascii-codes"
	dim i as Integer
	? "    ";
	for i= 0 to 15
		if i<10 then ? " "; i; else ? i;  
	Next
	?
	? "000:";
	for i= 0 to 255
		if i=7 or i=8 or i=9 or i=10 or i=13 then 	
			?"   "; 
		else
			? "  ";chr(i);
		EndIf
		if i<255 and (i+1) mod 16 = 0 then 
			?
			?mid(""&1000+i,2,3);":";
		EndIf
	Next
	?
End Sub

cls
ascii_table()
?"OK"

?
?
?"showing keycodes"
?"close window to end loop"
?

dim a as String
while not uConsole.Closing
	a= uConsole.aGetKey()
	if len(a)>1 then 
		a="x"+mid(a,2,1)
	elseif a<" " then 
		a="#" &asc(a)
	EndIf
	? uConsole.getdirection(a),a, asc(mid(a,2,1))
wend

#endif'test