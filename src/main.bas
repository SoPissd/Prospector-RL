'main.bas
Dim as Short ErrorNr=0
Dim as Short ErrorLn=0
Dim as String ErrText=""
'
#Macro inc(section,file,comments)
'#print #file "---" #comments
#define section
#include file
#undef section
#EndMacro

'
inc("main",	"debug.bas",				"")
inc("main",	"version.bas",				"")
'
inc("main",	"tRng.bas",					"")
inc("main",	"tInit.bas",				"")
'
inc("main",	"fbGfx.bi",					"")
#Macro draw_string(ds_x,ds_y,ds_text,ds_font,ds_col)
	Draw String(ds_x,ds_y),ds_text,,ds_font,custom,@ds_col
#EndMacro
'
inc("main",	"file.bi",					"")
inc("main",	"zlib.bi",					"")
'
inc("main",	"tCoords.bas",				"")
inc("main",	"tAstar.bas",				"")
'
inc("main",	"tConsts.bas",				"")
inc("main",	"tTypes.bas",				"")
inc("main",	"tEnums.bas",				"")
inc("main",	"tVars.bas",				"")
'
inc("main",	"tUtils.bas",				"")
inc("main",	"fileIO.bas",				"")
'
On Error Goto errormessage
inc("main",	"tError.bas",				"")
'
inc("main",	"tMath.bas",				"")
inc("main",	"tTime.bas",				"")
inc("main",	"tTexts.bas",				"")
'
inc("main",	"tGraphics.bas",			"")
inc("main",	"tPalette.bas",				"")
'
inc("main",	"tKeys.bas",				"")
inc("main",	"tPng.bas",					"")
inc("main",	"tConfig.bas",				"")
inc("main",	"tSound.bas",				"")
inc("main",	"tCommandstring.bas",		"")
inc("main",	"kbinput.bas",				"")
'
inc("main",	"tFonts.bas",				"")
inc("main",	"tCards.bas",				"")
inc("main",	"tTiles.bas",				"")
inc("main",	"tTiledata.bas",			"")
inc("main",	"tTextbox.bas",				"")
'
inc("main",	"tEnergycounter.bas",		"")
inc("main",	"tWeapon.bas",				"")
inc("main",	"tShip.bas",				"")
inc("main",	"tCustomship.bas",			"")
'
inc("main",	"tMonster.bas",				"")
inc("main",	"tFaction.bas",				"")
inc("main",	"tStars.bas",				"")
inc("main",	"tIndex.bas",				"")
inc("main",	"tItems.bas",				"")
inc("main",	"tItem.bas",				"")
inc("main",	"tArtifacts.bas",			"")
inc("main",	"tCivilisation.bas",		"")
'
inc("main",	"tSpacemap.bas",			"")
inc("main",	"tPlanet.bas",				"")
inc("main",	"tPlanetmap.bas",			"")
inc("main",	"tFleet.bas",				"")
inc("main",	"tPeople.bas",				"")
inc("main",	"items.bas",				"")

inc("main",	"tCrew.bas",				"")
inc("main",	"tParty.bas",				"")
'
inc("main",	"tRumors.bas",				"")
'
inc("main",	"tMap.bas",					"")
inc("main",	"tWaypoints.bas",			"")
inc("main",	"planet.bas",				"")

inc("main",	"retirement.bas",			"")
inc("main",	"tPlayer.bas",				"")
inc("main",	"tQuest.bas",				"")
inc("main",	"tCredits.bas"	,			"")
'
inc("main",	"tMakemonster.bas",			"")
inc("main",	"crew.bas",					"")
inc("main",	"tCommunicate.bas",			"")
inc("main",	"tAwayteam.bas",			"")
inc("main",	"tCargo.bas",				"")
'
inc("main",	"debug2.bas",				"")
'
inc("main",	"space.bas",				"")
inc("main",	"tTrading.bas",				"")
inc("main",	"tShops.bas",				"")
inc("main",	"tBones.bas",				"")
inc("main",	"tWorldgen.bas",			"")
'
inc("main",	"tStockmarket.bas",			"")
inc("main",	"tShipyard.bas",			"")
inc("main",	"cargotrade.bas",			"")
'
inc("main",	"tSlotmachine.bas",			"")
inc("main",	"tPoker.bas",				"")
inc("main",	"poker.bas",				"")
inc("main",	"tCasino.bas",				"")
'
inc("main",	"tCockpit.bas",				"")
inc("main",	"tAutopilot.bas",			"")
inc("main",	"tLogbook.bas",				"")
inc("main",	"spacecom.bas",				"")
inc("main",	"quests.bas",				"")
inc("main",	"pirates.bas",				"")
inc("main",	"tCompany.bas",				"")
inc("main",	"tDialog.bas",				"")
'
inc("main",	"highscore.bas",			"")
'
inc("main",	"tAutoexplore.bas",			"")
inc("main",	"tRadio.bas",				"")
inc("main",	"tRover.bas",				"")
inc("main",	"tMonstermove.bas",			"")
inc("main",	"tAttack.bas",				"")
inc("main",	"exploreplanet.bas",		"")
inc("main",	"tPlaneteffect.bas",		"")
inc("main",	"tProbes.bas",				"")
inc("main",	"compcolon.bas",			"")
inc("main",	"tExplore.bas",				"")
inc("main",	"tLanding.bas",				"")
inc("main",	"tFuel.bas",				"")
inc("main",	"tExplorespace.bas",		"")
'
inc("main",	"ProsIO.bas",				"")
'
#if _DbgOptLoadMLD = 1			
inc("main",	"fbmld.bi",					memory-leak-detector)
#endif							
'
#if _DbgOptLoadWin = 1			
inc("main",	"windows.bi",				windows header mandatory for debugbreak & console)
'inc("main",	"winbase.bi",				"windows header, mandatory for debugbreak & console")
#endif							
'
inc("main",	"tMenu.bas",				"")
inc("main",	"tSavegame.bas",			"")
inc("main",	"globals.bas",				"")
inc("main",	"tGameInit.bas",			"")
inc("main",	"tGame.bas",				"")
'

function mainmenu() as string
	dim a as integer
	dim key as string
	dim text as string
    Do        
        a=Menu(bg_title,__VERSION__ &"/Start new game/Load game/Highscore/Manual/Configuration/Keybindings/Quit",,40,_lines-10*_fh2/_fh1)
        If a=1 Then
            Key="1"
            If count_savegames()>20 Then
                Key=""
                rlprint "Too many Savegames, choose one to overwrite",14
                text=getfilename()
                If text<>"" Then
                    If askyn("Are you sure you want to delete "&text &"(y/n)") Then
                        Kill("savegames/"&text)
                        Key="1"
                    EndIf
                EndIf
            EndIf
        EndIf
        If a=2 Then Key=from_savegame("2")
        If a=3 Then high_score("")
        If a=4 Then manual
        If a=5 Then configuration
        If a=6 Then keybindings

'		if key="8" then
'			DbgItemsCSV()
'		endif
'		dodialog(1,dummy,0)
'		for b=1 to 1000
'           make_spacemap
'           clear_gamestate
'		next

#if __FB_DEBUG__
        If Key="t" Then
            Screenset 1,1
            BLoad "graphics\spacestations.bmp"
            a=getnumber(0,10000,0)
            Put(30,0),gtiles(gt_no(a)),Pset
            no_key=keyin
            Sleep
        EndIf
        If Key="8" Then
          	DbgMonsterCSV
           	DbgTilesCSV
        End If
        If Key="9" Then
            Cls
            set__color(15,0)
            For a=1 To 10
                reroll_shops
                print a
            Next
        EndIf
        If a=8 Then
			DbgPricesCSV
        EndIf
#endif
    Loop Until Key="1" Or Key="2" Or a=7
    return key
End function


#undef main

function main() as Integer
	Do
	    setglobals
	    DbgTilesCSV   
	    set__color(11,0)
		dim key as string
	    key= mainmenu()
	    Cls
	    If Key="1" Then start_new_game
	    If Key="1" Or Key="2" Or Key="a" Or Key="b" And player.dead=0 Then
	        Key=""
	        gamerunning=1
	        display_stars(1)
	        display_ship(1)
	        explore_space
	    EndIf
	    If Key="7" Or Key="g" Then 
	    	return 0
	    EndIf
	    If player.dead>0 Then death_message()
	    set__color( 15,0)
    	If configflag(con_restart)=0 Then
	        load_game("empty.sav")
	        clear_gamestate
	        gamerunning=0
	    EndIf
	Loop Until configflag(con_restart)=1
	return 0
end function

'
ErrorNr= Main()
goto done
'

ERRORMESSAGE:
	On Error goto 0
	ErrorNr= Err
	ErrorLn= Erl
	ErrText= ucase(stripFileExtension(lastword(*ERMN(),"\")))
	ErrText= ErrText &":" &*ERFN() &" reporting Error #" &ErrorNr &" at line " &ErrorLn &"!"  
	Error_Handler(ErrText)
WAITANDEXIT:
	Print
	Print
	set__color( 12,0)
	Print "Press any key to exit"
	do while inkey<>"": loop
	Sleep
DONE:
	set_volume(-1)
	DbgLogExplorePlanetEnd
	DbgEnd
	End ErrorNr
