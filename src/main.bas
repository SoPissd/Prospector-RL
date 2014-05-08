'main.bas

Dim as Short ErrorNr=0
Dim as Short ErrorLn=0
Dim as String ErrText=""
'

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
inc("main",	"debug.bas",				"")
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
inc("main",	"fbGfx.bi",					"")
inc("main",	"file.bi",					"")
inc("main",	"zlib.bi",					"")
'
'
Cls
Print
Print "Prospector "&__VERSION__
Print "Built "+__DATE__+" "+__TIME__
Print "FB."+__FB_VERSION__
Print
DbgScreeninfo
chdir exepath
'
inc("main",	"tRng.bas",					"")
inc("main",	"tCoords.bas",				"")
inc("main",	"tAstar.bas",				"")
'
inc("main",	"tConsts.bas",				"")
inc("main",	"tTypes.bas",				"")
inc("main",	"tEnums.bas",				"")
inc("main",	"tVars.bas",				"")
'
inc("main",	"tUtils.bas",				"")
inc("main",	"tGraphics.bas",			"")
inc("main",	"kbinput.bas",				"")
inc("main",	"fileIO.bas",				"")
'
On Error Goto errormessage
inc("main",	"tError.bas",				"")
'
inc("main",	"tKeys.bas",				"")
inc("main",	"tPrint.bas",				"")
inc("main",	"tTextbox.bas",				"")
inc("main",	"tConfig.bas",				"")
inc("main",	"tInput.bas",				"")
inc("main",	"tSound.bas",				"")
'
inc("main",	"tMath.bas",				"")
inc("main",	"tTime.bas",				"")
inc("main",	"tTexts.bas",				"")
inc("main",	"tCommandstring.bas",		"")
inc("main",	"tPng.bas",					"")
inc("main",	"tFonts.bas",				"")
inc("main",	"tCards.bas",				"")
inc("main",	"tTiles.bas",				"")
inc("main",	"tTiledata.bas",			"")
'
'
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
inc("head",	"tPlanetmap.bas",			"")
inc("main",	"tMakeplanet.bas",			"")
inc("main",	"tPlanetmap.bas",			"")
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
inc("main",	"cargotrade.bas",			"")
'
inc("main",	"tSlotmachine.bas",			"")
inc("main",	"tPoker.bas",				"")
inc("main",	"tCasino.bas",				"")
'
inc("main",	"tCockpit.bas",				"")
inc("main",	"tAutopilot.bas",			"")
inc("main",	"tLogbook.bas",				"")
inc("main",	"spacecom.bas",				"")
inc("main",	"tSpacecombat.bas",			"")
inc("main",	"quests.bas",				"")
inc("main",	"pirates.bas",				"")
inc("main",	"tCompany.bas",				"")
inc("main",	"tStockmarket.bas",			"")
inc("main",	"tRadio.bas",				"")
inc("main",	"tPlanetmenu.bas",			"")
inc("main",	"tDialog.bas",				"")
inc("main",	"highscore.bas",			"")
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
inc("main",	"tPalette.bas",				"")
inc("main",	"tMenu.bas",				"")
inc("main",	"tSavegame.bas",			"")
inc("main",	"globals.bas",				"")
inc("main",	"tGameInit.bas",			"")
inc("main",	"tGame.bas",				"")
'
#undef main
function main() as Short
	check_filestructure()
	load_config()
	load_fonts()
	If configflag(con_tiles)=0 Or configflag(con_sysmaptiles)=0 Then load_tiles()
	load_keyset()
	load_sounds()
	load_palette()
	DbgScreeninfo
	register()
	'DbgWeapdumpCSV   
    setglobals
    DbgTilesCSV
    return 0   
End Function

if main()=0 then
	ErrorNr= Prospector()
else
	ErrorNr= -1 	
endif
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
