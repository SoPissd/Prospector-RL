'version.bas
'
Dim Shared __VERSION__ As String:	__VERSION__	= "R184+\Sliced" 
Dim Shared __AUTHOR__ As String:	__AUTHOR__	= "the author"
Dim Shared __EMAIL__ As String:		__EMAIL__	= "via github"
'
'__EMAIL__ = "The email address is: " + __EMAIL__
__EMAIL__ = "Contact " + __AUTHOR__ + " " +__EMAIL__ +"."
'

Declare function savegame(crash as short=0)As Short

namespace tVersion
	
Dim Shared Gamerunning as byte =0
Dim Shared gameturn As UInteger =0
Dim Shared Gamedesig as string 

public function Init() as integer
	Gamedesig	=""
	Gamerunning	=0
	gameturn	=0
	return 0
End function

public function Load(fileno as Integer) As Integer
	return 0
End Function

public function Save(fileno as Integer) As Integer
	return 0
End Function


public function ErrorlogFilename() as String
	dim a as string
	if gamerunning then 
		a= "savegames/" & gamedesig & "-" 
	else 
		a= ""
	EndIf
	function = a + "error.log"	
End function



public function Errorscreen(text as string,suppress as integer=0) As integer
	dim as integer irow=10
	
	if tScreen.Enabled then
		tScreen.set(1,1)
		Cls
		tScreen.loc(irow,10)
		if suppress=0 then
		    tScreen.rgbcol(255,0,0)
		else
		    tScreen.rgbcol(127,127,127)
		endif
		Print text
		Print 
		irow= CsrLin
		tScreen.loc(irow,10)
	    tScreen.rgbcol(0,255,0)
		'tColor.set(12,0)
	else
		Print 
		Print text
		Print 
	endif
	'
	if suppress=0 then
		If gamerunning=1 Then
			text= "savegames/" & gamedesig 'player.desig 
			Print "Please send " & text & "-crash.sav and " & text & "-error.log to " +__AUTHOR__ +"."
		else
			Print "Please send error.log to " + __AUTHOR__ + "."
		endif
		'
		if __EMAIL__<>"" then
			if tScreen.Enabled then
				irow+=1
				tScreen.loc(irow,10)
			else
			endif
			Print __EMAIL__
		endif
		'
		if tScreen.Enabled then
		    tScreen.rgbcol(255,255,255)
			If gamerunning=1 Then 
				irow+=2
				tScreen.loc(irow,10)
			EndIf
		EndIf
		If gamerunning=1 Then
			savegame(1)
		EndIf
	EndIf
	return 0
End function


public function DisplayError(text as string) as integer
    tScreen.rgbcol(255,255,0)
    print text
    'sleep	
	return 0
End function

'
end namespace

#ifdef main
	tModule.Register("tVersion",@tVersion.Init(),@tVersion.Load(),@tVersion.Save())
#endif		

#ifdef intest
	' patch up expectations during testing.
	Function savegame(crash as short=0) As Short
		return 0
	End Function
#endif		
