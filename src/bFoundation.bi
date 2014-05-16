'bFoundation.bi
'include to build sound, debug and all the utilities. include dependencies.  
'builds in a single pass.

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
	inc("uConsole.bas",				"all the key and keyboard wrappers, idle and application close support")
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
	inc("uCoords.bas",				"compiles for different types of coordinates/variable coordinate records")
	inc("uAstar.bas",				"A* for the defined coordinates")
	inc("uMath.bas",				"_sym_matrix, some rounding, high/low")
	inc("uIndex.bas",				"some 2d/3d fixed-size-array manipulation code from prospector. might be generic enough for here")

	inc("uTime.bas",				"display_time, date_string")	
	inc("uSound.bas",				"define 'makesound' and the sound methods will start to use the dll code. else they do nothing.")
	inc("uPalette.bas",				"parse a text-file into uColor's palette")
	inc("uPrint.bas",				"rlprints to graphics console, screen-info, some input")
	inc("uTextbox.bas",				"Draws a box with text?")
	inc("uViewfile.bas",			"File and List Viewers rendering in text mode")
	inc("uMainLoop.bas",			"Generic Eventloop")
	inc("uMainMenu.bas",			"Generic Mainmenu")

	#undef types
	#undef head
	#undef main
