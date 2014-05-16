'uMainloop.
'
'namespace: uMainloop

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
'     -=-=-=-=-=-=-=- TEST: uMainloop -=-=-=-=-=-=-=-
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
#include "uMainloop.bas"
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
#include "tMainMenu.bas"
#undef head
#include "uMainloop.bas"
#include "tFonts.bas"
#undef main

#undef intest
#define test
#endif'test


#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
type tGetMouse
    dim as integer mx, my, mwheel, mbuttons, mclip	
End Type

dim shared Lastmouse as tGetMouse

'

type tMainloop Extends Object
	declare constructor()
	declare destructor()
	declare function run(iAction as Integer) as Integer
	declare function KeyProc as integer
	declare function MouseProc as integer
	declare Virtual function DoInitProc() as integer
	declare Virtual function DoConfirmClose() as integer
	declare Virtual function DoCmdProc() as integer
	declare Virtual function DoKeyProc() as integer
	declare Virtual function DoMouseProc() as integer
	dim as short NoMouseChecks 
	dim as string aKey
    dim as integer mx 
    dim as integer my
    dim as integer mwheel
    dim as integer mbuttons
    dim as integer mclip 
	dim as integer iCmd
	dim as integer iRet
	dim as short bIdling
End Type

'
#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: uMainloop -=-=-=-=-=-=-=-
#endif'head


namespace uMainloop

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: uMainloop -=-=-=-=-=-=-=-
#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: uMainloop -=-=-=-=-=-=-=-

function init(iAction as integer) as integer
	return 0
End function

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

'define function tProcesskey(aKey as string) as Integer
'define function tProcessmouse(ByRef aMouse as tGetMouse) as Integer

'function uMenu.updateposition(iAction as Integer) as integer
'	if not tScreen.isGraphic then
'		tScreen.pushpos()
'	    tScreen.xy(ofx,3,"" & loca)
'		tScreen.poppos()
'	endif
'	return 0
'end function

#endif'main
End Namespace

#ifdef main

constructor tMainloop()
End Constructor

destructor tMainloop()	
End Destructor

function tMainloop.DoInitProc as integer
	return iCmd '- 0 to accept, -1 to abort
End Function
function tMainloop.DoConfirmClose as integer
	return 0 '- 0 to accept, -1 to ignore the close signal
End Function
function tMainloop.DoCmdProc as integer
	return iCmd ' next no-command
End Function
function tMainloop.DoKeyProc as integer
	return iCmd ' next no-command
End Function
function tMainloop.DoMouseProc as integer
	return iCmd 'nochange
End Function

function tMainloop.MouseProc as integer
    getmouse mx, my, mwheel, mbuttons, mclip
    if Lastmouse.mx<>mx or Lastmouse.my<>my or Lastmouse.mwheel<>mwheel or Lastmouse.mclip<>mclip then
		Lastmouse.mx= mx  
		Lastmouse.my= my 
		Lastmouse.mwheel= mwheel 
		Lastmouse.mclip= mclip
		return DoMouseProc
    EndIf 
	return iCmd 'nochange
End Function

function tMainloop.KeyProc as integer
	aKey=uConsole.aInKey()  			
	if uConsole.Closing<>0 and DoConfirmClose<>0 then uConsole.Closing=0
	return iCmd 'nochange
End Function

function tMainloop.run(iAction as Integer) as Integer
	'this loop distibutes mouse and keyboard events via the Method vars. codes coming back from these handlers 
	'are taken as commands and passed into another callback method.the loop uses the global console idle handler
	' to use, dim an instance, set the methods and run.
	'DoInitProc
	iCmd=iAction
	iCmd=DoInitProc
   	while uConsole.Closing=0 and (iCmd<> -1)
		
		' icmd=0 	- find something to do, idle as needed
		' icmd=-1 	- abort the main loop
		
   		if iCmd=0 then
   			iCmd=KeyProc()	'sets aKey
			if uConsole.Closing=1 then continue while
   		EndIf

   		if iCmd=0 and aKey<>"" then
			iCmd=DoKeyProc
   		EndIf
   		
		if iCmd=0 and NoMouseChecks=0 then
			iCmd= MouseProc()
		EndIf
		
		if iCmd<>0 then
			iCmd= DoCmdProc()
		else
			uConsole.Idle()
		EndIf
		'
   	Wend
   	return uConsole.Closing
End Function


#endif'main

#if (defined(main) or defined(test))
	' -=-=-=-=-=-=-=- INIT: uMainloop -=-=-=-=-=-=-=-
	tModule.register("uMainloop",@uMainloop.init()) ',@uMainloop.load(),@uMainloop.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: uMainloop -=-=-=-=-=-=-=-
'	dim shared as uMainloop.tMainloopParams aParams
	
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
	
	function CmdProc(iAction as Integer) as Integer
		if iAction=3 then
			aParams.KeyProc= @keypress2			
		EndIf
		if iAction=5 then
			aParams.KeyProc= @keypress			
		EndIf
		return 0
	End Function
	
	aParams.KeyProc= @keypress 
	aParams.CmdProc= @CmdProc 
	uMainloop.mainloop(aParams)
#endif'test
