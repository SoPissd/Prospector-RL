'bProspector.

'#define build "bProspector.bi" 'variable substitution leads to errors, re-include, dont use a module.
'#include "bFoundation.bas"

'build the core pieces  
#include once "bFoundation.bas"

'build module 'build' for types, head and main
#if 1'def build
	#undef inc
	#Macro inc(file,comments)
	'#print -=- file  -=- comments
	#include file
	#EndMacro
	
	#print loading types
	#define types
	#undef head
	#undef main
	'#include build
	#include "bProspector.bi"
	#undef types

	#print loading declarations
	#define head
	#undef main
	'#include build
	#include "bProspector.bi"
	
	#print loading implementations
	#undef head
	#define main
	'#include build
	#include "bProspector.bi"

	#print Building application...
	#define main
#else
	#print Building core...
	#undef main
#endif

'
	
#ifdef main
	#print full
	namespace tMain
	function init(iAction as integer) as integer
		Print tModule.status()
		Print
		chdir exepath
		tError.ErrorNr= Initgame() or Prospector()
		return tError.ErrorNr
	end function
	end namespace'tMain
	
#else
	#print core
	namespace tMain
	function init(iAction as integer) as integer
		Print tModule.status()
		Print
		chdir exepath
		? "nothing"
		uConsole.pressanykey
		return tError.ErrorNr
	end function
	end namespace'tMain
	
#endif'special
#endif

'
'main
'

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
	uSound.set(-1)
	'DbgLogExplorePlanetEnd
	DbgEnd
	End tError.ErrorNr