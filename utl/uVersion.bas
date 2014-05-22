'version.
'
'namespace: tVersion

'
'
'defines:
'Init=6, Load=3, Save=4, ErrorlogFilename=0, Errorscreen=0, DisplayError=0
'

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
'     -=-=-=-=-=-=-=- TEST: version -=-=-=-=-=-=-=-
#undef intest

#include "uDefines.bas"
#include "uModule.bas"
#include "uDefines.bas"
#include "uScreen.bas"

#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: version -=-=-=-=-=-=-=-


'declare function tVersion
'declare function tVersion
'declare function tVersion
'declare function tVersion
'declare function tVersion
'declare function tVersion

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: version -=-=-=-=-=-=-=-
'
#include "uVersion.bi"

type tAction As Function as Integer


namespace tVersion
	
Dim Shared Gamerunning as byte =0
Dim Shared Gamescore As UInteger =0
Dim Shared Gameturn As UInteger =0
Dim Shared Gamedesig as string 
dim Shared SavegameMethod as tAction
Dim Shared logerror as byte =1


public function Init(iAction as integer) as integer
	Gamedesig	=""
	Gamerunning	=0
	gameturn	=0
	logerror	=1
	return 0
End function

public function Load(fileno as Integer) As Integer
	return 0
End Function

public function Save(fileno as Integer) As Integer
	return 0
End Function


public function ErrorlogFilename() as String
	dim a as string
	if gamerunning then 
		a= "savegames/" & gamedesig & "-" 
	else 
		a= ""
	EndIf
	function = a + "error.log"	
End function


public function Errorscreen(text as string,suppress as integer=0) As integer
	dim as integer irow=10
	
	if tScreen.IsGraphic then
		tScreen.set(1,1)
		Cls
		tScreen.loc(irow,10)
		if suppress=0 then
		    tScreen.rbgcolor(255,255,255)
		else
		    tScreen.rbgcolor(127,127,127)
		endif
   'tScreen.rbgcolor(255,255,0)
		Print text
		Print 
		irow= CsrLin
		tScreen.loc(irow,10)
	    tScreen.rbgcolor(0,255,0)
		'tColor.set(12,0)
	else
		Print 
		Print text
		Print 
	endif
	'
	if not suppress then
		If gamerunning Then
			text= "savegames/" & gamedesig 'player.desig 
			Print "Please send " & text & "-crash.sav and " & text & "-error.log to " +__AUTHOR__ +"."
		else
			Print "Please send error.log to " + __AUTHOR__ + "."
		endif
		'
		if __EMAIL__<>"" then
			if tScreen.IsGraphic then
				irow+=1
				tScreen.loc(irow,10)
			else
			endif
			Print __EMAIL__
		endif
		'
		if tScreen.IsGraphic then
		    tScreen.rbgcolor(255,255,255)
			If gamerunning Then 
				irow+=2
				tScreen.loc(irow,10)
			EndIf
		EndIf
		if (logerror>0) and (gamerunning) Then
			if Savegamemethod<>null then
				logerror= Savegamemethod()
			endif
			logerror=0
		EndIf
	EndIf
	return 0
End function


'public function DisplayError(text as string) as integer
'    tScreen.rbgcolor(255,255,0)
'    print text
'    'sleep	
'	return 0
'End function


#endif'main
end namespace


#ifdef testing
	' patch up expectations during testing.
	Function savegame(crash as short=0) As Short
		return 0
	End Function
#endif		

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: version -=-=-=-=-=-=-=-
	tModule.Register("tVersion",@tVersion.Init(),@tVersion.Load(),@tVersion.Save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: version -=-=-=-=-=-=-=-
#undef test
#endif'test
