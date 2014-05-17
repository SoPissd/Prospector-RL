'prospector.
'
#define makesound   ' can also use " fbc -d makesound " .. thats better, actually
# define justcore

'
 
#include once "src/bFoundation.bas"	'build the core pieces  

'build module 'build' for types, head and main
#ifndef buildjustcore
	'#ifdef modulename - leads to interpretations errors. dont use substitution here.
	#define phase1
'	#define phase2
		make("src/bProspector.bi")
	#undef phase1
'		make("src/bProspector.bi")
	#undef phase2
#endif

'
	
namespace tMain
#ifndef buildjustcore
	#print Building application...
	function init(iAction as integer) as Integer
		Print tModule.status()
		Print
		chdir exepath
		return tModule.Run(iAction)
	end function
#else
	#print Building core...
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
	DbgEnd
	End tError.ErrorNr