'prospector.
'
#define makesound   ' can also use " fbc -d makesound " .. thats better, actually

'Cls
On Error Goto errormessage
scope
#include "src/uVersion.bi"
Print __VERSION__
Print "Built on FB."+__FB_VERSION__+", "+__TIME__+" "+__DATE__
end scope

'build the core pieces  
#include once "src/bFoundation.bas"

'build module 'build' for types, head and main
#if 1
	'#ifdef modulename - leads to interpretations errors. dont use substitution here.
	make("src/bProspector.bi")
	
	#print Building application...
	#define main
#else
	#print Building core...
	#undef main
#endif

'
	
namespace tMain
#ifdef main
	#print full
	function init(iAction as integer) as Integer
		Print tModule.status()
		Print
		chdir exepath
		return tModule.Run(iAction)
	end function
#else
	#print core
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