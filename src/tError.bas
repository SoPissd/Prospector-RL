' error handling

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
	
	if tFile.OpenLogfile(tVersion.ErrorlogFilename(),f,32)=0 then
		Print #f, date + " " + time + " " + __VERSION__  + " " + text
		tFile.Closefile(f)
		return 0
	Endif	
	return -1
End function

#if __FB_DEBUG__
' use LogWarning(text) defined in types.bas to output warnings to the error log.
' this code is in this awkward place here only because i dont want to think about placing the helper functions into better places.
function log_warning(aFile as string, aFunct as string, iLine as integer, text as string) as integer
	aFile= ucase(stripFileExtension(lastword(aFile,"\")))
	return not log_error( "Warning! "+aFile+":"+aFunct +" line " & iLine & ": "+text)
End function
#endif

'Declare function log_error(text as string) As Short					' writes to error log
'Declare function error_message() As String							' builds error message
'Declare function error_handler(text as string) As Short				' system error handler
'
#if __FB_DEBUG__
'Declare function log_warning(aFile as string, aFunct as string, iLine as short, text as string) as Short ' use LogWarning(text)
#else
#endif

#Define LogWarning(Text) Assert(log_warning(__FILE__,__FUNCTION__,__LINE__,Text))						' disappears from release

'

function Errorhandler() As integer
	dim as string logfile
	log_error(ErrText)
	tVersion.Errorscreen(ErrText)
	return 0
End function


End Namespace

tError.init()
