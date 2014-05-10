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



public function Errorscreen(text as string) As integer
	Screenset 1,1
	Cls
	Locate 10,10
	set__color( 14,0)
	Print text
	Locate 12,10
	set__color( 12,0)
	If gamerunning=1 Then
		text= "savegames/" & gamedesig 'player.desig 
		Print "Please send " & text & "-crash.sav and " & text & "-error.log to " +__AUTHOR__ +"."
	else
		Print "Please send error.log to " + __AUTHOR__ + "."
	endif
	Locate 13,10
	Print __EMAIL__
	set__color( 14,0)
	'
	If gamerunning=1 Then
		Locate 15,0
		savegame(1)
	EndIf	
	return 0
End function


public function DisplayError(text as string) as integer
    color rgb(255,255,0)
    print text
    'sleep	
	return 0
End function

'
end namespace

#ifdef main
	tModule.Register("tVersion",@tVersion.Init(),@tVersion.Load(),@tVersion.Save())
#endif		
