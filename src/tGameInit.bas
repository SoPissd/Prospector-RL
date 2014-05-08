'tGameInit

function check_filestructure() as short
	if chdir("data")=-1 then
		set__color(c_yel,0)
		print "Can't find folder 'data'. Try reinstalling the game."
		sleep
		end
	else
		chdir("..")
	endif

	if (assertpath("bones")=-1) _
	or (assertpath("savegames")=-1) _
	or (assertpath("summary")=-1) _
	then
		set__color(c_yel,0)
		print "Can not create folder. Try reinstalling the game."
		sleep
		end
	endif

	if fileexists("savegames/empty.sav") _ 
	and (file_size("savegames/empty.sav")>0) then return 0
	' not there or was empty for some reason yet to be eradicated
	player.desig="empty"
	savegame()
	return 0
end function



'DebugBreak

check_filestructure()
load_config()
load_fonts()
If configflag(con_tiles)=0 Or configflag(con_sysmaptiles)=0 Then load_tiles()
load_keyset()
load_sounds()
load_palette()

DbgScreeninfo

'sleep


sub register()
	dim f as integer
	If Not fileexists("register") Then
    	Cls
	    If askyn("This is the first time you start prospector. Do you want to see the keybindings before you start?(Y/N)") Then
    	   keybindings()
	    EndIf
	    Cls
	    f=Freefile
	    Open "register" For Output As f
	    Print #f,"0"
	    Print #f,""
	    If Menu(bg_randompic,"Autonaming:/Standard/Babylon 5 Shipnames")=2 Then
	        Print #f,"b5shipnames.txt"
	    EndIf
	    Close #f
	    set__color(11,0)
	EndIf
end sub

register()

DbgWeapdumpCSV   
