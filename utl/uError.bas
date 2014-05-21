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
#undef both
#define types
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tError -=-=-=-=-=-=-=-
#undef intest

#include "uDefines.bas"
#include "uModule.bas"
#include "uDefines.bas"
#include "file.bi"
#include "uFile.bas"
#include "uScreen.bas"
#include "uColor.bas"
#include "uUtils.bas"
#include "uConsole.bas"
#include "uVersion.bas"

#define test
#endif'test

namespace tError

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tError -=-=-=-=-=-=-=-

Dim as integer ErrorNr=0
Dim as integer ErrorLn=0
Dim as String ErrText

declare function Errorhandler(ErrWhere as String="") As integer   'global error-handler. pass in ErrorLoc
#define ErrorLoc ucase(Namebase(*ERMN())) + "::" + *ERFN() +"()"  'usually used to call errorhandler

#define LogWarning(Text) Assert(tError.log_warning(__FILE__,__FUNCTION__,__LINE__,Text))
declare function log_warning(aFile as string, aFunct as string, iLine as integer, text as string) as integer

declare function log(text as string="") As integer 'simply write a note to the error log

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tError -=-=-=-=-=-=-=-

function init(iAction as integer) as integer
	tModule.ErrorMethod= @tError.Errorhandler
	ErrorNr=0
	ErrorLn=0
	ErrText=""
	return 0
End function


function log(text as string="") As integer
	Dim As integer f
	dim as string logfile
	
	if tFile.OpenLogfile(tVersion.ErrorlogFilename(),f,32)>0 then
		Print #f, date + " " + time + " " + __VERSION__  + " " + text
		tFile.Closefile(f)
		'
		'? "LOGGED in " +  tVersion.ErrorlogFilename()+":"
		'? date + " " + time + " " + __VERSION__  + " " + text
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
	return log( "Warning! "+ucase(Namebase(aFile))+":"+aFunct +" line " & iLine & ": "+text)
#else
	return 0
#endif
End function

'
'
'

function Errorhandler(ErrWhere as string) As integer
	
	if Err<>0 then
		ErrorNr= Err
		ErrorLn= Erl
		ErrText= ErrWhere  + " reporting Error #" &tError.ErrorNr 
		if ErrorLn<>0 then
			ErrText &= " at line " &tError.ErrorLn
		endif 
		ErrText &= "!"
	endif
	
	'to file
	if ErrorNr=0 and ErrText="" then
		if tModule.fErrOut>0 then
			'print #tModule.fErrOut,"All done."
			close #tModule.fErrOut
		endif
		return 0
	EndIf
	
	if tModule.fErrOut>0 and ErrText="" then
		print #tModule.fErrOut,ErrText
	endif
	
	log(ErrText)
	
	'to current screen
	if tScreen.IsGraphic then
		tVersion.Errorscreen(ErrText,ErrorLn=0)
		uConsole.Pressanykey()
		tScreen.mode(0)
	EndIf
	
	'and lastly to console
	tVersion.Errorscreen(tError.ErrText,ErrorLn=0)
	
	return 0
End function

#endif'main

End Namespace

#if (defined(main) or defined(test))
	' -=-=-=-=-=-=-=- INIT: tError -=-=-=-=-=-=-=-
	tModule.register("tError",@tError.init()) ',@tError.load(),@tError.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tError -=-=-=-=-=-=-=-
#undef test
#include "uWindows.bas"
#include "uDebug.bas"
#include "uTextbox.bas"
#include "uViewfile.bas"

Letsgo:
	tScreen.res
	tVersion.Errorscreen("HELLO from TEST: tError",true)
	sleep
		
	On Error goto ErrorHandler
	
	dim as Integer a, i(10)
	a=11
	i(a)=4

ErrorHandler:
	On Error goto 0
	tError.ErrorHandler(ErrorLoc)
Done:
	Viewfile(tVersion.ErrorlogFilename())
	?	
	? "--------------------------------------------onwards..."	
	tError.log_warning("ok.log","fun",10,"txt")
	LogWarning("warning")
	? "--------------------------------------------onwards..."
	Viewfile(tVersion.ErrorlogFilename())	
	tVersion.Errorscreen("THATS ALL",true)
#endif'test
