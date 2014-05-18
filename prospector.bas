'prospector.
'
'clear all flags, for reference.
'dont mess up "fbc -d options"  
#undef buildjustcore
#undef buildjustbasic
#undef makesound				'active or blank wrappers for sound-dll
#undef makezlib					'active or blank wrappers for zlib and png. the linked library has no debug symbols and delays loading the debugger. 
'
'set needed flags
'#define buildjustcore
#define buildjustbasic
'
'SET OPTIONS
'#define makesound   
'#define makezlib 
'
 
#include once "src/bFoundation.bas"	'build the core pieces  

'build module 'build' for types, head and main
#ifdef buildjustcore
	#print built just core.
#else
	'#ifdef modulename - leads to interpretations errors. dont use substitution here.
	#ifdef buildjustbasic
		#print build just basic...
		#define phase1
		make("src/bProspector.bi")
		#undef phase1
	#else
		#print build everything...
		#define phase1
		#define phase2
		make("src/bProspector.bi")
		#undef phase1
		#undef phase2
	#endif'justbasic
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

'      -=-=-=-=-=-=-=- MAIN -=-=-=-=-=-=-=-
Letsgo:
	On Error goto ErrorHandler
	tModule.register("main",@tMain.init()) ',@main.load(),@main.save())
ErrorHandler:
	On Error goto 0
	tError.ErrorHandler(ErrorLoc)
Done:
	uSound.set(-1)
	DbgEnd
	End tError.ErrorNr