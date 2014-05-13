'main.

'Cls
On Error Goto errormessage

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: main -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: main -=-=-=-=-=-=-=-



#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: main -=-=-=-=-=-=-=-


#Macro inc(section,file,comments)
'#print #file "---" #comments
#undef head
#undef main
#undef both
#undef test
#undef intest
'#print section -=- file  -=- comments
#define section
#if section="both"
#define head
#define main
#undef both
#endif
#include file
#undef section
#EndMacro

'
inc("both",	"tSound.bi",				"first, include the sound drivers")
inc("both",	"fbGfx.bi",					"")
inc("both",	"file.bi",					"")
inc("both",	"zlib.bi",					"")
'
'#undef main
inc("head",	"tDefines.bas",				"head, basic true/false/null")
inc("both",	"tModule.bas",				"the module loader. first init, then save/load")
inc("main",	"tDefines.bas",				"main, register the unit")
inc("both",	"debug.bas",				"debug macros or their null eqivalents. also include loading")
inc("both",	"tScreen.bas",				"wrap screen,screenset,locate,width,color so console code works too")
inc("both",	"tColor.bas",				"maps color codes to screen via palette")
inc("both",	"version.bas",				"provides ErrorlogFilename and Errorscreen. same vars too")
'
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
#print ready...
inc("both",	"tRng.bas",					"rng with retrievable seed")
#print ready...
inc("both",	"tPng.bas",					"png load? save functions")
'
inc("both",	"kbinput.bas",				"keyplus,keyminus,Pressanykey,keyinput and consts for simple keys.")
inc("both",	"tFile.bas",				"Openfile++, filetostring, stringtofile, logtofile and more utilities")
inc("both",	"tUtils.bas",				"string helpers mostly. needs tests to be written")
inc("both",	"tError.bas",				"Errorhandler messages for graphics and console. logging too")
inc("both",	"tGraphics.bas",			"background and bmp loading. calcosx")
'
inc("both",	"tCoords.bas",				"")
inc("both",	"tAstar.bas",				"")
inc("both",	"tMath.bas",				"")
inc("both",	"tTime.bas",				"")
'
#undef inc
#Macro inc(file,comments)
'#print -=- file  -=- comments
#include file
#EndMacro

#print loading headers
#define head
#print head
#undef main
#include "main.bi"
#print headers loaded
#print loading implementations
#undef head
#define main
#include "main.bi"
#print implementations loaded
#endif'main


'
'main
'
#ifdef main
namespace tMain
function init() as Integer
	Print "Switching"
	Print
	tError.ErrorNr= (Initgame()<> 0) or Prospector()
	return 0
end function
end namespace'tMain
#endif'main


'      -=-=-=-=-=-=-=- MAIN -=-=-=-=-=-=-=-
Letsgo:
	On Error goto Errormessage
	tModule.register("main",@tMain.init()) ',@main.load(),@main.save())
	goto ErrorHandler 
Errormessage:
	On Error goto 0
	tError.ErrorNr= Err
	tError.ErrorLn= Erl
	tError.ErrText= ucase(stripFileExtension(lastword(*ERMN(),"\")))
	tError.ErrText= tError.ErrText &"::" &*ERFN() &"() reporting Error #" &tError.ErrorNr &" at line " &tError.ErrorLn &"!"
ErrorHandler:
	tError.ErrorHandler()
Done:
	set_volume(-1)
	'DbgLogExplorePlanetEnd
	DbgEnd
	End tError.ErrorNr