'tError.
'
'namespace: tError

'
'
'defines:
'init=16, log_error=0, log_warning=0, Errorhandler=0
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(types) or defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tError -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test

namespace tError

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tError -=-=-=-=-=-=-=-

declare function init(iAction as integer) as integer

'private function log_error(text as string) As integer
'private function log_warning(aFile as string, aFunct as string, iLine as integer, text as string) as integer
'private function Errorhandler() As integer

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tError -=-=-=-=-=-=-=-

Dim as integer ErrorNr=0
Dim as integer ErrorLn=0
Dim as String ErrText

declare function Errorhandler() As integer

function init(iAction as integer) as integer
	tModule.ErrorMethod= @Errorhandler
	ErrorNr=0
	ErrorLn=0
	ErrText=""
	return 0
End function


function log_error(text as string) As integer
	Dim As integer f
	dim as string logfile
	
	if tFile.OpenLogfile(tVersion.ErrorlogFilename(),f,32)>0 then
		Print #f, date + " " + time + " " + __VERSION__  + " " + text
		tFile.Closefile(f)
		'
		? "LOGGED in " +  tVersion.ErrorlogFilename()+":"
		? date + " " + time + " " + __VERSION__  + " " + text
		return 0
	else 
		? "FAILED LOG WRITE to " +  tVersion.ErrorlogFilename()+"!"
		? date + " " + time + " " + __VERSION__  + " " + text
		return -1
	Endif	
End function

function log_warning(aFile as string, aFunct as string, iLine as integer, text as string) as integer
#if __FB_DEBUG__
' use LogWarning(text) defined in types.bas to output warnings to the error log.
' this code is in this awkward place here only because i dont want to think about placing the helper functions into better places.
	aFile= ucase(stripFileExtension(lastword(aFile,"\")))
	return not log_error( "Warning! "+aFile+":"+aFunct +" line " & iLine & ": "+text)
#else
	return 0
#endif
End function

'Declare function log_error(text as string) As Short					' writes to error log
'Declare function error_message() As String							' builds error message
'Declare function error_handler(text as string) As Short				' system error handler
'

function Errorhandler() As integer
	'to file
	if tError.ErrorNr=0 and tError.ErrText="" then
		if tModule.fErrOut>0 then
			print #tModule.fErrOut,"All done."
			close #tModule.fErrOut
		endif
		return 0
	EndIf
	if tModule.fErrOut>0 and tError.ErrText="" then
		print #tModule.fErrOut,ErrText
	endif
	log_error(ErrText)
	'to current screen
	tVersion.Errorscreen(ErrText,ErrorLn=0)
	uConsole.Pressanykey()
	if tScreen.IsGraphic then
		'to console
		tScreen.mode(0)
		tVersion.Errorscreen(tError.ErrText,ErrorLn=0)
		uConsole.Pressanykey()		
	EndIf
	return 0
End function

#endif'main

End Namespace

#if (defined(main) or defined(test))
	' -=-=-=-=-=-=-=- INIT: tError -=-=-=-=-=-=-=-
	'
	#Define LogWarning(Text) Assert(tError.log_warning(__FILE__,__FUNCTION__,__LINE__,Text))						' disappears from release
	tModule.register("tError",@tError.init()) ',@tError.load(),@tError.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tError -=-=-=-=-=-=-=-
	? tError.log_warning("ok.log","fun",10,"txt")
	LogWarning("warning")
#endif'test
