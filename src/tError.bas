' error handling

dim shared as integer iErrConsole

namespace tError
	
Dim as integer ErrorNr=0
Dim as integer ErrorLn=0
Dim as String ErrText

'

function init() As integer
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
		close #iErrConsole
		return 0
	EndIf
	print #iErrConsole,ErrText
	log_error(ErrText)
	'to current screen
	tVersion.Errorscreen(ErrText,ErrorLn=0)
	Pressanykey()
	if tScreen.Enabled then
		'to console
		tScreen.mode(0)
		tVersion.Errorscreen(tError.ErrText,ErrorLn=0)
		Pressanykey()		
	EndIf
	return 0
End function


End Namespace

iErrConsole=freefile
open err for output as iErrConsole
print #iErrConsole,"console err!"
'close #f

#ifdef main
	#Define LogWarning(Text) Assert(tError.log_warning(__FILE__,__FUNCTION__,__LINE__,Text))						' disappears from release
	tModule.Register("tError",@tError.Init())
	
#else	
	? tError.log_warning("ok.log","fun",10,"txt")
	LogWarning("warning")
#endif		
