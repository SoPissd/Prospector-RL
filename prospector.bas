'prospector.
'
'clear all flags, for reference.
'dont mess up "fbc -d options"  
#undef build_justfoundation
#undef build_justgamecore
#undef build_prospector
#undef useLibFoundation
#undef useLibTileData
#undef useLibProspector
#undef makesound				'active or blank wrappers for _FBSOUND(default) or _FMODSOUND sound-dll
#undef makezlib					'the linked library has no debug symbols and can be excluded so the debugger is quiet. 
'
'set build mode
'set build mode
'#define build_justfoundation
#define build_justgamecore
'#define build_prospector		'<< that's the one to build_everything. turn the build_others off
'
'annoying experiment(s)
'#define build_justpoker
'
'set options
'set options
'#define useLibFoundation			'use utl/libbFoundation.a utility code
'#define useLibTileData
'#define useLibbProspector			'refers to the cor/GameCore code-library	
#define makesound					'are we even going to bind in any sound-library code 
#define makezlib 					'turn this on when you need png and compressed saves. 
'

'you can build this as a library containing the core game and use that library while working on the rest  

'
'assert that something is to be done (only one of these should be true!)
#assert defined(build_justfoundation) or defined(build_justgamecore) or defined(build_prospector) or __FB_OUT_LIB__
'

'
#ifdef useLibFoundation
	#include "utl/libFoundation.bi"		'use core utilities from utl/libFoundation.a
#else
	#include once "utl/bFoundation.bas"	'build the core pieces  
	'build module 'build' for types, head and main
	#ifdef build_justfoundation
		#print built foundation.
	#endif'build_justfoundation
#endif'useLibFoundation

#ifndef build_justfoundation
	'#ifdef modulename - leads to interpretations errors. dont use substitution here.
	#ifdef build_justpoker
		#print build just poker etc...
		make("src/bProspector.bi")
	#endif

	#ifdef useLibTileData
		#print using libTileData. reading tile headers...
		#define types
		#define head
		#include "cor/gTiledata.bas"
		#libpath "cor"
		#inclib "gTiledata"
		#undef types
		#undef head
	#endif

	#ifdef useLibProspector
	#if __FB_OUT_LIB__	 
		#print using libbProspector. reading game-core headers...
		#define types
		#define head
		#include "cor/bGameCore.bi"
		#inclib "bProspector"
	#endif
	#endif

	#ifndef useLibProspector
		#ifdef build_justgamecore
			#print build just the game-core...
			make("cor/bGameCore.bi")			' turns into libProspector because of the name of this file
		#endif'build_gamecore
	#endif
		
#endif'not build_justfoundation

'
	
#if not __FB_OUT_LIB__ 

	#ifdef build_prospector
		#ifndef useLibProspector
			#print building game-core...
			make("cor/bGameCore.bi")			' turns into libProspector because of the name of this file
		#endif
		#print build the game...
		make("src/bProspector.bi")				' and everything planet/space map/exploration/combat related
	#endif'build_prospector
	

	namespace tMain
	#ifndef build_justfoundation
		#print Make-application
		function init(iAction as integer) as Integer
			Print tModule.status()
			Print
			chdir exepath
			? "hello"
			uConsole.pressanykey
			return tModule.Run(iAction)
		end function
	#else
		#print Make-core
		function init(iAction as integer) as Integer
			Print tModule.status()
			Print
			chdir exepath
			? "nothing"
			uConsole.pressanykey
			return tError.ErrorNr
		end function
	#endif'buildjustcore
	end namespace'tMain

	'
	'main
	'
	#if __FB_Debug__
	#ifdef __FB_WIN32__
		ReplaceConsole()
	#endif
	#endif	

	'      -=-=-=-=-=-=-=- MAIN -=-=-=-=-=-=-=-
	Letsgo:
		On Error goto ErrorHandler
		tModule.register("main",@tMain.init()) ',@main.load(),@main.save())
	ErrorHandler:
		On Error goto 0
		tError.ErrorHandler(ErrorLoc)
	Done:
		DbgEnd
		End tError.ErrorNr

#endif'not __FB_OUT_LIB__	