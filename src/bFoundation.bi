'bFoundation.bi
'include to build sound, debug and all the utilities. include dependencies.  

	#undef inc
	#Macro inc(file,comments)
	'#print -=- file  -=- comments
	#include file
	#EndMacro
'
	inc("uSound.bi",				"first, include the sound drivers")
	inc("fbGfx.bi",					"")
	inc("file.bi",					"")
	inc("zlib.bi",					"")
'
	#undef both
	#undef test
	
	#undef types
	#undef head
	#undef main
	
	#define types
	#define head
	#define main
'
	#undef main
	inc("uDefines.bas",				"head, basic true/false/null")
	#define main
	inc("uModule.bas",				"the module loader. first init, then save/load")
	#undef head
	inc("uDefines.bas",				"main, register the unit")
	#define head
'	
	inc("uDebug.bas",				"debug macros or their null eqivalents. also include loading")
	inc("uScreen.bas",				"wrap screen,screenset,locate,width,color so console code works too")
	inc("uColor.bas",				"maps color codes to screen via palette")
	inc("uConsole.bas",				"all the keyboard wrappers needed to trap for application close always")
	inc("uVersion.bas",				"provides ErrorlogFilename and Errorscreen. same vars too")
'
	inc("uRng.bas",					"rng with retrievable seed")
	inc("uPng.bas",					"png load? save functions")
'
	inc("uFile.bas",				"Openfile++, filetostring, stringtofile, logtofile and more utilities")
	inc("uUtils.bas",				"string helpers mostly. needs tests to be written")
	inc("uError.bas",				"Errorhandler messages for graphics and console. logging too")
	inc("uGraphics.bas",			"background and bmp loading.")
'
	inc("uCoords.bas",				"")
	inc("uAstar.bas",				"")
	inc("uMath.bas",				"")
	inc("uIndex.bas",				"")
	inc("uTime.bas",				"")
	inc("uSound.bas",				"")
	inc("uKbinput.bas",				"keyplus,keyminus,Pressanykey,keyinput and consts for simple keys.")
	inc("uPalette.bas",				"")
	inc("uPrint.bas",				"")
	inc("uTextbox.bas",				"")
	inc("uViewfile.bas",			"")

	#undef types
	#undef head
	#undef main
