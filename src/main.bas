'main.bas

#Macro inc(section,file,comments)
'#print #file "---" #comments
#undef head
#undef main
'#print section
#define section
#include file
#undef section
#EndMacro

'

#undef main
#define main
inc("main",	"debug.bas",				"")
inc("main",	"tDefines.bas",				"")
inc("main",	"tModule.bas",				"")
inc("main",	"tScreen.bas",				"")
inc("main",	"tColor.bas",				"")
inc("main",	"version.bas",				"")
'
' sound support
#IfDef _FBSOUND
	#print (Sound through fbsound)
	#Define _sound
	#define dprint
	Dim Shared Sound(12) As Integer
	#Include "fbsound.bi"
	#undef dprint
#Else
	#IfDef _FMODSOUND
		#print (Sound through fmodsound)
		#Define _sound
		Dim Shared Sound(12) As Integer Ptr
		Dim Shared As Integer fmod_error
		#IncLib "fmod.dll"
		#Include "fmod.bi"
	#Else
		#print (No sound)
	#EndIf
#EndIf
'
inc("main",	"fbGfx.bi",					"")
inc("main",	"file.bi",					"")
inc("main",	"zlib.bi",					"")
'
'
#if _DbgOptLoadWin = 1			
	#print loading windows headers			
	inc("main",	"windows.bi",			windows header mandatory for debugbreak & console)
#else
#if _DbgOptLoadWin = 2			
	#print loading winbase headers			
	inc("main",	"winbase.bi",			windows header mandatory for debugbreak & console)
#endif							
#endif							
'
#if _DbgOptLoadMLD = 1
	#print loading memory leak detector			
	'#include once "crt.bi"
	'#ifdef __FB_WIN32__
	''# inclib "msvcrt"
	'#endif
	''#include once "crt/string.bi"
	''#include once "crt/math.bi"
	''#include once "crt/time.bi"
	''#include once "crt/wchar.bi"
	''#include once "crt/ctype.bi"
	''#include once "crt/stdlib.bi"
	''#include once "crt/stdio.bi"
	''#include once "crt/fcntl.bi"
	''#include once "crt/errno.bi"
	'#if defined(__FB_WIN32__) or defined(__FB_DOS__)
	''# include once "crt/dir.bi"
	'#endif
	inc("main",	"fbmld.bi",				memory-leak-detector)
#endif							
'
'
On Error Goto errormessage
Cls
Print
Print "Prospector "&__VERSION__
Print "Built "+__DATE__+" "+__TIME__
Print "FB."+__FB_VERSION__
Print
DbgScreeninfo
chdir exepath
'
'core
'
inc("main",	"tRng.bas",					"")
inc("main",	"tPng.bas",					"")
inc("main",	"tGraphics.bas",			"")
'
inc("main",	"kbinput.bas",				"")
inc("main",	"tFile.bas",				"")
inc("main",	"tUtils.bas",				"")
inc("main",	"tError.bas",				"")
'
inc("main",	"tCoords.bas",				"")
inc("main",	"tAstar.bas",				"")
inc("main",	"tMath.bas",				"")
inc("main",	"tTime.bas",				"")
'
inc("main",	"tKeys.bas",				"")
inc("main",	"tPrint.bas",				"")
inc("main",	"tTextbox.bas",				"")
'
inc("main",	"tConfig.bas",				"")
inc("main",	"tInput.bas",				"")
inc("main",	"tSound.bas",				"")
'
inc("main",	"tConsts.bas",				"")
inc("main",	"tTypes.bas",				"")
inc("main",	"tEnums.bas",				"")
inc("main",	"tVars.bas",				"")
'
'
'app
'
'
inc("main",	"tCommandstring.bas",		"")
inc("main",	"tFonts.bas",				"")
inc("main",	"tTiles.bas",				"")
inc("main",	"tTiledata.bas",			"")
'
'game
'
inc("main",	"tTexts.bas",				"")
inc("main",	"tEnergycounter.bas",		"")
inc("main",	"tWeapon.bas",				"")
inc("main",	"tShip.bas",				"")
inc("main",	"tCustomship.bas",			"")
inc("main",	"tMonster.bas",				"")
inc("main",	"tFaction.bas",				"")
inc("main",	"tStars.bas",				"")
inc("main",	"tIndex.bas",				"")
inc("main",	"tItems.bas",				"")
inc("main",	"tItem.bas",				"")
inc("main",	"tArtifacts.bas",			"")
inc("main",	"tCivilisation.bas",		"")
inc("main",	"tPlanet.bas",				"")
inc("main",	"tSpacemap.bas",			"")
inc("main",	"tFleet.bas",				"")
inc("main",	"tPeople.bas",				"")
inc("main",	"tModifyitem.bas",			"")
inc("main",	"tMakeitem.bas",			"")
inc("main",	"tCrew.bas",				"")
inc("main",	"tParty.bas",				"")
inc("main",	"tRumors.bas",				"")
inc("main",	"tWaypoints.bas",			"")
'
inc("head",	"tPlanetmap.bas",			"headers")
inc("main",	"tMakeplanet.bas",			"")
inc("main",	"tPlanetmap.bas",			"body")
'
inc("main",	"retirement.bas",			"")
inc("main",	"tPlayer.bas",				"")
inc("main",	"tQuest.bas",				"")
inc("main",	"tCredits.bas"	,			"")
inc("main",	"tMakemonster.bas",			"")
inc("main",	"crew.bas",					"")
inc("main",	"tCommunicate.bas",			"")
inc("main",	"tAwayteam.bas",			"")
inc("main",	"tCargo.bas",				"")
'
inc("main",	"debug2.bas",				"")
inc("main",	"space.bas",				"")
inc("main",	"tTrading.bas",				"")
inc("main",	"tShops.bas",				"")
inc("main",	"tSpecialPlanet.bas",		"")
inc("main",	"tBones.bas",				"")
inc("main",	"tWorldgen.bas",			"")
inc("main",	"tShipyard.bas",			"")
'
inc("main",	"tCockpit.bas",				"")
inc("main",	"tAutopilot.bas",			"")
inc("main",	"tLogbook.bas",				"")
inc("main",	"spacecom.bas",				"")
inc("head",	"tCompany.bas",				"headers")
inc("main",	"tSpacecombat.bas",			"")
inc("main",	"quests.bas",				"")
inc("main",	"cargotrade.bas",			"")
inc("main",	"pirates.bas",				"")
inc("main",	"tCompany.bas",				"body")
inc("main",	"tStockmarket.bas",			"")
'
inc("main",	"tCards.bas",				"")
inc("main",	"tSlotmachine.bas",			"")
inc("main",	"tPoker.bas",				"")
inc("main",	"tCasino.bas",				"")
'
inc("main",	"tRadio.bas",				"")
inc("main",	"tPlanetmenu.bas",			"")
inc("main",	"tDialog.bas",				"")
'
inc("main",	"tAutoexplore.bas",			"")
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
'game-menu
'
inc("main",	"highscore.bas",			"")
inc("main",	"tPalette.bas",				"")
inc("main",	"tMenu.bas",				"")
inc("main",	"tSavegame.bas",			"")
inc("main",	"tGameinit.bas",			"")
inc("main",	"tViewfile.bas",			"")
inc("main",	"tGamekeys.bas",			"")
inc("main",	"tGame.bas",				"")
'
'main
'
Print "Switching"
Print

LETSGO:
	tError.ErrorNr= (Initgame()<> 0) or Prospector() 	
	goto done
ERRORMESSAGE:
	On Error goto 0
	tError.ErrorNr= Err
	tError.ErrorLn= Erl
	tError.ErrText= ucase(stripFileExtension(lastword(*ERMN(),"\")))
	tError.ErrText= tError.ErrText &":" &*ERFN() &" reporting Error #" &tError.ErrorNr &" at line " &tError.ErrorLn &"!"  
	tError.ErrorHandler
WAITANDEXIT:
	Print
	Print
	Pressanykey(10,10,0) '10-green
DONE:
	set_volume(-1)
	DbgLogExplorePlanetEnd
	DbgEnd
	End tError.ErrorNr
'
'#
'