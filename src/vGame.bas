'tGame.
'
'defines:
'Private start_new_game=0, Private from_savegame=0, Private mainmenu=0,
', Prospector=1
'

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
'     -=-=-=-=-=-=-=- TEST: tGame -=-=-=-=-=-=-=-
#undef intest
#define test
#endif'test


namespace tGame
	
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tGame -=-=-=-=-=-=-=-

Dim as tActionmethod pStart_new_game
Dim as tActionmethod pFrom_savegame
Dim as tActionmethod pPlay_game

'private function Private start_new_game() As Short
'Private function from_savegame(iBg as short,key As String) As String
'private function Private mainmenu() as string

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tGame -=-=-=-=-=-=-=-

dim shared lasttime as double

function updatefps(iAction as Integer) as integer
'?"updatefps"
	dim dtime as double 
	dim itime as integer
	dTime=lasttime 
	lasttime=Timer() 
	dTime=lasttime-dTime
	iTime=dTime*1000
	iTime=1000/iTime
	if not tScreen.isGraphic then
		tScreen.pushpos()
	    tScreen.xy(70,1,"" & iTime)
		tScreen.poppos()
	endif
	return iAction
end function


function init(iAction as integer) as integer
	lasttime= Timer()
	uConsole.IdleMethod= @updatefps
'	tScreen.res
	return 0
end function


Private function mainmenuactions(ByRef iAction as integer, ByRef aText as String) as integer
    If iAction=0 Then  
		aText =__VERSION__+"/"
		aText+="Load game/"
		aText+="Start new game/"
		aText+="Highscore/"
		aText+="Manual/"
		aText+="Configuration/"
		aText+="Keybindings/"
		aText+="Quit"
		return 7 
    endif 

    If iAction=1 Then  
    	if pFrom_savegame<>null then
			LogOut("pFrom_savegame")
    		iAction= pFrom_savegame(iAction)
    	else 
			LogOut("pFrom_savegame=null")
    		'iAction=-1
    	EndIf
    elseif iAction=2 then
		if tScreen.isGraphic then
			tScreen.mode(0)
			if askyn("pStart_new_game") then ?"yes"
		else
load_fonts()
'			tScreen.res
'			tScreen.set
			DbgScreeninfo
			if askyn("pStart_new_game") then ?"yes"
			'uConsole.pressanykey
			debugbreak
			'viewfile("readme.txt",256)
			'uConsole.pressanykey
			'tScreen.mode(0)
		EndIf
		'
    	if pStart_new_game<>null then
			LogOut("pStart_new_game")
    		iAction= pStart_new_game(iAction)
    	else 
			LogOut("pStart_new_game=null")
    		'iAction=-1
    	EndIf
    EndIf
    '
	if (pPlay_game<>null) and (iAction=1 or iAction=2) then
		LogOut("pPlay_game")
    	iAction= pPlay_game(iAction)
	else 
		LogOut("pPlay_game=null")
		'iAction=-1
	EndIf

	'and (configflag(con_restart)=1)
	if (uConsole.Closing<>0) then
	EndIf

	If     iAction=3 Then 'high_score("")
    elseif iAction=4 Then viewfile("readme.txt",256)
    elseif iAction=5 Then configuration()
    elseif iAction=6 Then keybindings
	elseif iAction=7 Then return 1
	elseif iAction=-27 Then iAction=7    ' esc becomes last choice
    EndIf
    return 0 'stay
	
'		if key="8" then
'			DbgItemsCSV()
'		endif
'		dodialog(1,dummy,0)
'		for b=1 to 1000
'           make_spacemap
'           clear_gamestate
'		next

'#if __FB_DEBUG__
'        If Key="t" Then
'            tScreen.set(1)
'            BLoad "graphics/spacestations.bmp"
'            a=getnumber(0,10000,0)
'            Put(30,0),gtiles(gt_no(a)),Pset
'            no_key=uConsole.keyinput
''            no_key=keyin
'            Sleep
'        EndIf
'        If Key="8" Then
'          	DbgMonsterCSV
'           	DbgTilesCSV
'        End If
'        If Key="9" Then
'            Cls
'            set__color(15,0)
'            For a=1 To 10
'                reroll_shops
'                print a
'            Next
'        EndIf
'        If a=8 Then
'			DbgPricesCSV
'        EndIf
'#endif
End Function

Private function mainmenu(a as integer) as integer
	dim key as string
	dim no_key as string
	dim aText as string
	dim iLines as integer
    while (uConsole.Closing=0)
    	if (a=0) and (iLines=0) then
    		iLines=mainmenuactions(a,aText)
    		if iLines<0 then return iLines		'needs choice? 0 means, just show title.
    		iLines += 3							'choices+title+top'n'bottom rows= +3 == 10 total
    	elseif a<0 then							'esc makes last choice the default choice 
			a=iLines-2
			tGraphics.iBg=0
		EndIf
		if tGraphics.iBg=0 then				 	'use a random picture the first time round
			tGraphics.Randombackground()
		EndIf
		if a=0 then a=1							'first choice by default 

		LogOut("_lines,_fh2,_fh1 " &_lines &", " &_fh2 &", " &_fh1 &", " &a)
		if _fh1>0 then
	        a=textmenu(aText,,40,_lines-iLines*_fh2/_fh1,,1,,a)
		else
	        a=textmenu(aText,,40,_lines-iLines,,1,,a)
		endif
		
		if mainmenuactions(a,aText)<>0 then exit while
	wend
    return a
End function


'function updateposition() as integer
'	if not tScreen.isGraphic then
'		tScreen.pushpos()
'	    tScreen.xy(ofx,3,"" & loca)
'		tScreen.poppos()
'	endif
'	return 0
'end function

function run(iAction as Integer) as Integer
	'?"function run(iAction as Integer) as Integer"
    while (uConsole.Closing=0) and (iAction=0)
	    iAction= mainmenu(iAction)
    wend
	'Pressanykey
	return iAction
end function

#endif'main
end namespace'tGame

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tGame -=-=-=-=-=-=-=-
	tModule.register("tGame",@tGame.init()) ',@tGame.load(),@tGame.save())
	tModule.RunMethod= @tGame.run 'here is where the magic happens
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tGame -=-=-=-=-=-=-=-

cls
?"cls"
tScreen.loc( 5,15, "515")
tScreen.loc( 15,15, "1515")
locate  20,5
?"205"
?"test"
sleep
uConsole.Pressanykey
return 0

#endif'test
