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
#undef both
#define types
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: uMainloop -=-=-=-=-=-=-=-
#undef intest

#include "fbGfx.bi"
#include "zlib.bi"
#include "File.bi"

#include "uDefines.bas"
#include "uModule.bas"
#include "uDefines.bas"
#include "uWindows.bas"
#include "uDebug.bas"
#include "uFile.bas"
#include "uScreen.bas"
#include "uColor.bas"
#include "uConsole.bas"
#include "uPng.bas"
'#include "uMainloop.bas"
'#include "uFonts.bas"
#include "uRng.bas"
#include "uGraphics.bas"
#include "uCoords.bas"
#include "uMath.bas"
#include "uPrint.bas"
#include "uVersion.bas"
#include "uUtils.bas"
#include "uError.bas"
'#include "uSound.bas"
'#include "uStars.bas"
'#include "uConfig.bas"
#include "uTextbox.bas"
#include "uMainMenu.bas"

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
	declare virtual destructor()
	declare function run(iAction as Integer) as Integer
	declare function KeyProc as integer
	declare function MouseProc as integer
	'
	' the non-virtual virtuals:
	declare virtual function DoInitProc() as integer
	declare virtual function DoAbortClose() as integer
	declare virtual function DoCmdProc() as integer
	declare virtual function DoKeyProc() as integer
	declare virtual function DoMouseProc() as integer
	'
	dim as short NoMouseChecks = 1 
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


#ifdef main
'     -=-=-=-=-=-=-=- MAIN: uMainloop -=-=-=-=-=-=-=-
namespace uMainloop
function init(iAction as integer) as integer
	return 0
End function
End Namespace

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



constructor tMainloop()
End Constructor

destructor tMainloop()	
End Destructor

function tMainloop.DoInitProc as integer
	return iCmd '- interprets -1 to abort
End Function
function tMainloop.DoAbortClose as integer
	return false '- 0 to accept, else ignores the close signal
End Function
function tMainloop.DoCmdProc as integer
	return 0' done.   iCmd ' next no-command
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
	if uConsole.Closing and DoAbortClose then uConsole.Closing=false
	return iCmd 'nochange
End Function

function tMainloop.run(iAction as Integer) as Integer
	'this loop distibutes mouse and keyboard events via the Method vars. codes coming back from these handlers 
	'are taken as commands and passed into another callback method.the loop uses the global console idle handler
	' to use, dim an instance, set the methods and run.
	'DoInitProc
	iCmd=iAction
	iCmd=DoInitProc
?"	iCmd=DoInitProc",iCmd

   	while (not uConsole.Closing) and (iCmd<> -1)
		
		' icmd=0 	- find something to do, idle as needed
		' icmd=-1 	- abort the main loop
		
   		if iCmd=0 then
   			iCmd=KeyProc()	'sets aKey
			if uConsole.Closing then continue while
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
   	return iCmd'uConsole.Closing
End Function

#endif'main


#if (defined(main) or defined(test))
	' -=-=-=-=-=-=-=- INIT: uMainloop -=-=-=-=-=-=-=-
	tModule.register("uMainloop",@uMainloop.init()) ',@uMainloop.load(),@uMainloop.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: uMainloop -=-=-=-=-=-=-=-
#undef test
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
