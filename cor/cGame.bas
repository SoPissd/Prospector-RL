'tGame.
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
'     -=-=-=-=-=-=-=- TEST: tGame -=-=-=-=-=-=-=-
#undef intest
#define test
#endif'test


#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
type tGameloop extends tMainloop
	declare constructor()
	declare virtual destructor() 
	'
	' the non-override overrides:
	declare function DoInitProc() as integer '
	declare function DoAbortClose() as integer 
	declare function DoCmdProc() as integer 
	declare function DoKeyProc() as integer 
	declare function DoMouseProc() as integer 
end type

type tGamemenu extends tMenuCore
	declare constructor()
	declare virtual destructor() 
	'
	'the non-override overrides:
	'declare function init() as integer 
	'declare function before() as integer 
	'declare function after() as integer 
	'declare function finish() as integer 
	'
	declare function mainmenu(a as integer=0) as integer
	declare function DoProcess() as integer 
end type
#endif'types

'

namespace tGame
	
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tGame -=-=-=-=-=-=-=-
'these are used in menu processing to start game-functions 
'without knowing anything about the context they exist in. 

Dim as tActionmethod pStart_new_game
Dim as tActionmethod pReset_game
Dim as tActionmethod pFrom_savegame
Dim as tActionmethod pPlay_game


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tGame -=-=-=-=-=-=-=-
dim shared Fpsshow as short =1

function Fpsupdate(iAction as Integer) as integer
	'?"updatefps"
	dim atime as string
	'
	if Fpsshow then		
		aTime=LeadingZero(3,uConsole.Fps)
		if not tScreen.isGraphic then
			tScreen.pushpos()
		    tScreen.xy(70,1,aTime)
			tScreen.poppos()
		endif
	endif
	return iAction
end function

'

function run(iAction as Integer) as Integer
	'this instantiates the main loop and runs it. it takes care of the rest.
	'DbgPrint("function run("& iAction &")")
	dim aLoop as tGameloop
	return aLoop.run(1)
end function


function init(iAction as integer) as integer
	tModule.RunMethod= @tGame.run 	'here is where the magic happens as main runs module runs game.run(0)
	uConsole.IdleMethod= @Fpsupdate	'just because
	return 0
end function

#endif'main
end namespace'tGame


#ifdef main


constructor tGameloop()
end constructor

destructor tGameloop()
end destructor
		
' icmd=0 	- find something to do, idle as needed
' icmd=-1 	- abort the main loop

' init

function check_filestructure() as short
	if chdir("data")=-1 then
		set__color(c_yel,0)
		print "Can't find folder 'data'. Try reinstalling the game."
		sleep
		end
	else
		chdir("..")
	endif

	if (tFile.assertpath("bones")=-1) _
	or (tFile.assertpath("savegames")=-1) _
	or (tFile.assertpath("summary")=-1) _
	then
		set__color(c_yel,0)
		print "Can not create folder. Try reinstalling the game."
		sleep
		end
	endif

	''why?
	'if fileexists("savegames/empty.sav") _ 
	'and (tFile.Filesize("savegames/empty.sav")>0) then return 0
	'' not there or was empty for some reason yet to be eradicated
	'player.desig="empty"
	'tVersion.Gamedesig="empty"
	'savegame()
	
	return 0
end function


sub register()
	dim f as integer
	If Not fileexists("register") Then
    	Cls
	    If askyn("This is the first time you start prospector. Do you want to see the keybindings before you start") Then
    	   keybindings()
	    EndIf
	    Cls
	    f=Freefile
	    Open "register" For Output As f
	    Print #f,"0"
	    Print #f,""
	    If textmenu(bg_randompic,"Autonaming:/Standard/Babylon 5 Shipnames")=2 Then
	        Print #f,"b5shipnames.txt"
	    EndIf
	    Close #f
	    set__color(11,0)
	EndIf
end sub


function tGameloop.DoInitProc() as integer
	'DbgPrint(iCmd)
tScreen.res
	
	load_config()
	tColor.load_palette()
	check_filestructure()
	load_keyset()
	uSound.load()

	'load_fonts()
	'load_tiles()
	'
	DbgScreeninfo
	register()
	'setglobals
	'DbgWeapdumpCSV
    'DbgTilesCSV
	DbgPrint("tGameloop.DoInitProc() "&iCmd)
	
	return iCmd '- interprets -1 to abort
end function

function tGameloop.DoCmdProc() as integer
	DbgPrint("tGameloop.DoCmdProc() "&iCmd)
	'
	select case iCmd
	case 1 ' main menu
		dim aMenu as tGamemenu
		iCmd=aMenu.mainmenu()
		
DbgPrint("aMenu.mainmenu() "& iCmd )		
		return iCmd
	case else
		'DbgPrint(iCmd)
		return 0 'iCmd ' next no-command
	end select
end function

function tGameloop.DoAbortClose() as integer
	return false '- 0 to accept, else ignores the close signal
end function

function tGameloop.DoKeyProc() as integer
	'DbgPrint(iCmd)
	return iCmd ' next no-command
end function

function tGameloop.DoMouseProc() as integer
	'DbgPrint(iCmd)
	return iCmd 'nochange
end function

'

constructor tGamemenu()
end constructor

destructor tGamemenu()
end destructor		

function tGamemenu.DoProcess() as integer
	dim iAction as short
	iAction= this.e
DbgPrint("tGamemenu.DoProcess e="& iAction)
    If iAction=0 Then 
    	ClearChoices()
		AddChoice(__VERSION__)
		AddChoice("Load game")
		AddChoice("Start new game")
		AddChoice("Highscore")
		AddChoice("Manual")
		AddChoice("Configuration")
		AddChoice("Keybindings")
		AddChoice("Quit")
		return iLines 
    endif 
    If iAction=1 Then  
		if askyn("pStart_new_game") then ?"yes"
    	if tGame.pFrom_savegame<>null then
			LogOut("pFrom_savegame")
    		iAction= tGame.pFrom_savegame(iAction)
    	else 
			LogOut("pFrom_savegame=null")
    		'iAction=-1
    	EndIf
    elseif iAction=2 then
		if tScreen.isGraphic then
			tScreen.mode(0)
			if askyn("pStart_new_game") then rlprint("yes")
		else
'		load_fonts()
			tScreen.res
'			tScreen.set
			DbgScreeninfo
			if askyn("pStart_new_game") then rlprint("yes")
			'uConsole.pressanykey
'			debugbreak
			'viewfile("readme.txt",256)
			'uConsole.pressanykey
			'tScreen.mode(0)
		EndIf
		'
    	if tGame.pStart_new_game<>null then
			LogOut("pStart_new_game")
    		iAction= tGame.pStart_new_game(iAction)
    	else 
			LogOut("pStart_new_game=null")
    		'iAction=-1
    	EndIf
    EndIf
    '
	if (tGame.pPlay_game<>null) then
		if (iAction=1 or iAction=2) then
			LogOut("pPlay_game")
	    	iAction= tGame.pPlay_game(iAction)
	    	'
		    If (player.dead>0) and not (configflag(con_restart)=1 or player.dead=99) Then
			  death_message(0)
		    EndIf
			if (tGame.pReset_game<>null) then
				iAction= tGame.pReset_game(iAction)			
			EndIf
		EndIf
	else 
		LogOut("pPlay_game=null")
		'iAction=-1
	EndIf

	'and (configflag(con_restart)=1)
	if uConsole.Closing then
	EndIf

	If iAction=3 Then
		high_score("")
	elseif iAction=4 Then
		viewfile("readme.txt",256)
	elseif iAction=5 Then
		configuration()
	elseif iAction=6 Then
		keybindings
	elseif iAction=7 Then		
    	player.dead=99
		death_message(2600)
		player.dead=0
		if not tScreen.isGraphic then cls
		return -1
	elseif iAction=-27 Then loca=7    ' esc becomes last choice
	EndIf
	
    return 0 'stay
    
	'DbgPrint("return 0")	
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

function tGamemenu.mainmenu(a as integer=0) as integer
	'DbgPrint(a)
	dim key as string
	dim no_key as string
	dim iLines as integer
	dim j as integer

	if (iLines=0) then
		j=a
		a=0
		iLines=DoProcess()
		a=j
		if iLines<0 then return iLines		'needs choice? 0 means, just show title.
		iLines += 3							'choices+title+top'n'bottom rows= +3 == 10 total
	EndIf
	if tGraphics.iBg=0 then				 	'use a random picture the first time round
		tGraphics.Randombackground()
	EndIf
	if a=0 then a=1							'first choice by default 
'	LogOut("_lines,_fh2,_fh1 " &_lines &", " &_fh2 &", " &_fh1 &";" &a)

    x= 40
	y= tScreen.gth-iLines -2
    markesc= 1
    loca= a
	a= menu()
    return -1 'a
End function

#endif'main


#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tGame -=-=-=-=-=-=-=-
	tModule.register("tGame",@tGame.init()) 'this sets the module-run-method to tGame.run() yeah. 
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
'sleep
uConsole.Pressanykey
return 0

#endif'test
