' error handling

Declare Function savegame(crash as short=0)As Short

Dim Shared gamerunning as byte =0
Dim Shared gamedesig as string 
gamedesig=""
Dim Shared gameturn As UInteger =0



Function log_error(text as string) As Short
	Dim As integer f
	dim as string logfile
	if gamerunning then 
		logfile= "savegames/" & gamedesig & "-" 'gamedesig=player.desig
	else 
		logfile= ""
	EndIf
	
	f=Freefile
	if Open(logfile & "error.log", For Append, As #f)=0 then
		if LOF(f)>32*1024 then
			Close #f	' its getting stupidly large
			f=Freefile	' get a new handle and rewrite it
			if Open(logfile & "error.log", For Output, As #f)<>0 then
				return -1
			EndIf
	 	EndIf
		Print #f, date + " " + time + " " + __VERSION__  + " " + text
		Close #f
		return 0
	Endif
	
	return -1
End Function

#if __FB_DEBUG__
' use LogWarning(text) defined in types.bas to output warnings to the error log.
' this code is in this awkward place here only because i dont want to think about placing the helper functions into better places.
Function log_warning(aFile as string, aFunct as string, iLine as short, text as string) as Short
	aFile= ucase(stripFileExtension(lastword(aFile,"\")))
	return not log_error( "Warning! "+aFile+":"+aFunct +" line " & iLine & ": "+text)
End Function
#endif

'Declare Function log_error(text as string) As Short					' writes to error log
'Declare Function error_message() As String							' builds error message
'Declare Function error_handler(text as string) As Short				' system error handler
'
#if __FB_DEBUG__
'Declare Function log_warning(aFile as string, aFunct as string, iLine as short, text as string) as Short ' use LogWarning(text)
#else
#endif

#Define LogWarning(Text) Assert(log_warning(__FILE__,__FUNCTION__,__LINE__,Text))						' disappears from release

'

Function error_handler(text as string) As Short
	dim as string logfile
	log_error(text)
	'
	Screenset 1,1
	Cls
	Locate 10,10
	set__color( 14,0)
	Print text
	Locate 12,10
	set__color( 12,0)
	If gamerunning=1 Then
		logfile= "savegames/" & gamedesig 'player.desig 
		Print "Please send " & logfile & "-crash.sav and " & logfile & "-error.log to matthias mennel."
	else
		Print "Please send error.log to matthias mennel."
	endif
	Locate 13,10
	Print "The email address is: matthias.mennel@gmail.com"
	set__color( 14,0)
	'
	If gamerunning=1 Then
		Locate 15,0
     	if savegame(1)<0 then
			text= "Failed to save the crashed game."
			log_error(text)
      	Print text
	   EndIf
	EndIf
	'
	return 0
End Function


