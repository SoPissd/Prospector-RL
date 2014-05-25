'bFoundation.bi
'include to build sound, debug and all the utilities. include dependencies.  
'builds in a single pass.

'4 external units
'25 foundation units
'29 total units

'
	inc("uDefines.bas",				"head, basic true/false/null")
	inc("uModule.bas",				"the module loader. first init, then save/load")
	
	inc("uDebug.bas",				"debug macros or their null eqivalents. also include loading")
	#if __FB_Debug__
		#ifdef __FB_WIN32__			
			inc("uWindows.bas",		"windows utils used when debugging")
		#endif
	#endif

	inc("uUtils.bas",				"string helpers mostly. needs tests to be written")
	inc("uScreen.bas",				"wrap screen,screenset,locate,width,color so console code works too")	
	inc("uColor.bas",				"maps color codes to screen via palette")
	inc("uConsole.bas",				"all the key and keyboard wrappers, idle and application close support")
	inc("uVersion.bas",				"provides ErrorlogFilename and Errorscreen. same vars too")  '*need test*'
'
		#undef test
	inc("uRng.bas",					"rng with retrievable seed")
	#ifdef makezlib	
		inc("uPng.bas",				"png load? save functions")	'*need test*'
	#endif
'
	inc("uFile.bas",				"Openfile++, filetostring, stringtofile, logtofile and more utilities")
		#undef test
	inc("uError.bas",				"Errorhandler messages for graphics and console. logging too")
	inc("uGraphics.bas",			"background and bmp loading.")	'*need test*'

	inc("uCoords.bas",				"compiles for different types of coordinates/variable coordinate records")
	inc("uAstar.bas",				"A* for the defined coordinates")	'*need test*'
	inc("uMath.bas",				"_sym_matrix, some rounding, high/low")	'*need test*'
	inc("uIndex.bas",				"some 2d/3d fixed-size-array manipulation code from prospector. might be generic enough for here") '*need test*'

	inc("uTime.bas",				"display_time, date_string")	'*need test*'	
	inc("uSound.bas",				"define 'makesound' and the sound methods will start to use the dll code. else they do nothing.")	'*need test*'
	inc("uBorder.bas",				"Draws boxes")
	inc("uPrint.bas",				"rlprints to graphics console, screen-info, some input")
	inc("uScroller.bas",			"Scrolls any-thing, any-area, any-array")
	inc("uTextbox.bas",				"Wrappers for uScroller")
	inc("uViewfile.bas",			"File and List Viewers rendering in text mode")
	inc("uMainLoop.bas",			"Generic Eventloop")
	inc("uMainMenu.bas",			"Generic Mainmenu")
