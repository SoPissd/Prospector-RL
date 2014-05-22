'prospector.
'
'clear all flags, for reference.
'dont mess up "fbc -d options"  
#undef build_justfoundation
#undef build_justbasic
#undef build_prospector
#undef useLibFoundation
#undef useLibTileData
#undef useLibProspector
#undef makesound				'active or blank wrappers for sound-dll
#undef makezlib					'active or blank wrappers for zlib and png. the linked library has no debug symbols and delays loading the debugger. 
'
'set build mode
'set build mode
'#define build_justfoundation
#define build_justbasic
'#define build_prospector		'<< that's the one to build_everything. turn the build_others off
'
'annoying experiment(s)
'#define build_justpoker
'
'set options
'set options
'#define useLibFoundation
#define useLibTileData
'#define useLibbProspector	
'#define makesound   
'#define makezlib 
'

'you can build this as a library containing 'phase1' code. then use that library while working on 'phase2'
'the 'phases' set conditionals in bProspector.bi and control what's included where.  

#assert defined(build_justfoundation) or defined(build_justbasic) or defined(build_prospector) or __FB_OUT_LIB__

#ifdef useLibFoundation
	#print using libFoundation
	#define types
	#define head
	#include once "utl/bFoundation.bas"	'build the core pieces  
	#libpath "utl"
	#inclib "bFoundation"
	#undef types
	#undef head
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
		#print using libTileData
		#define types
		#define head
		#include "src/vTiledata.bas"
		#libpath "src"
		#inclib "vTiledata"
		#undef types
		#undef head
	#endif

	#ifdef useLibProspector
	#if __FB_OUT_LIB__	 
		#print using libbProspector
		#define types
		#define head
		#define phase1
		#include "src/bProspector.bi"
		#libpath "src"
		#inclib "bProspector"
	#endif
	#endif

	#ifndef useLibProspector
		#ifdef build_justbasic
			#print build just basic...
			#define phase1
			make("src/bProspector.bi")
			#undef phase1
		#endif'build_justbasic
	#endif
		
#endif'not build_justfoundation

'
	
#if not __FB_OUT_LIB__ 

	#ifdef build_prospector
		#print build everything...
		#define phase1
		#define phase2
		make("src/bProspector.bi")
		#undef phase1
		#undef phase2
	#endif'build_prospector


	namespace tMain
	#ifndef build_justfoundation
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