'prospector.
'
'clear all flags, for reference.
'dont mess up "fbc -d options"  
#undef buildjustcore
#undef buildjustbasic
#define useLibTileData
#undef makesound				'active or blank wrappers for sound-dll
#undef makezlib					'active or blank wrappers for zlib and png. the linked library has no debug symbols and delays loading the debugger. 
'
'set needed flags
'#define build_justfoundation
#define build_justbasic
'#define build_prospector		'<< that's the one to build_everything. turn the build_others off
'
'annoying experiment(s)
'#define build_justpoker
'
'SET OPTIONS
#define useLibTileData
'#define makesound   
'#define makezlib 
'

 
#include once "utl/bFoundation.bas"	'build the core pieces  

'build module 'build' for types, head and main
#ifdef build_justfoundation
	#print built foundation.
#else
	'#ifdef modulename - leads to interpretations errors. dont use substitution here.
	#ifdef build_justpoker
		#print build just poker etc...
		make("src/bProspector.bi")
	#endif

	#ifdef useLibTileData
		#print using libTileData
		#define types
		#define head
		#include "src/vTiledata.bas"
		'#undef types
		#libpath "src"
		#inclib "vTiledata"
	#endif

	#ifdef build_justbasic
		#print build just basic...
		#define phase1
		make("src/bProspector.bi")
		#undef phase1
	#endif'justbasic
	
	#ifdef build_prospector
		#print build everything...
		#define phase1
		#define phase2
		make("src/bProspector.bi")
		#undef phase1
		#undef phase2
	#endif'buildprospector
		
#endif'buildjustcore

'
	
namespace tMain
#ifndef buildjustcore
	#print Make-application
	function init(iAction as integer) as Integer
		Print tModule.status()
		Print
		chdir exepath
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
	
#endif'special
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