'tSound.
#include once "uDefines.bi"
DeclareDependencies()
#define test 
#endif'DeclareDependencies()

namespace uSound

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tSound -=-=-=-=-=-=-=-
'inc("both","uSound.bi","first, include the sound drivers")

declare function set(iVolume as Integer) as short
declare function load() as short
declare function play(iSound As Short,iRepeats As Short=1,iDelay As Short=0) as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tSound -=-=-=-=-=-=-=-

function init(iAction as integer) as integer
	return 0
end function


' sound support

function set(iVolume as Integer) as short
	#ifdef _FMODSOUND
	   Dim iLvl As Short
		iLvl=0
		If iVolume = 1 then iLvl=63
		If iVolume = 2 then iLvl=128
		If iVolume = 3 then iLvl=190
		If iVolume = 4 then iLvl=255
	   FSOUND_SetSFXMasterVolume(iLvl)
		If iVolume = -1 then fSOUND_close
	#endif
	#ifdef _FBSOUND
		If iVolume= -1 then iVolume= 0
		fbs_Set_MasterVolume(iVolume/2.0)
	#endif   	
	return 0
End function


function load() as short
#Ifdef _sound
    Dim i As Short
    Dim nSounds As Short
    nSounds=12
    Dim sounds(nSounds) as string
    sounds(1)="alarm_1"
    sounds(2)="alarm_2"
    sounds(3)="weap_1"
    sounds(4)="weap_1"
    sounds(5)="wormhole"
    sounds(6)=""
    sounds(7)="weap_4"
    sounds(8)="weap_3"
    sounds(9)="weap_5"
    sounds(10)="start"
    sounds(11)="land"
	sounds(12)="pain"

	print "loading sounds";
   
	#ifdef _FMODSOUND
		if fsound_init(48000,11,0)=0 then
			set(0)
		   	For i= 1 To nSounds
				sound(i)= FSOUND_Sample_Load(FSOUND_FREE, "data/" &sounds(i) &".wav", 0, 0, 0)
				print ".";
			Next
	   else	   	
			print "Error " &FSOUND_geterror() &" initializing FMODsound!"
			LogWarning("Error " &FSOUND_geterror() &" initializing FMODsound!")
			sleep 1500
	   EndIf
    #endif
    #ifdef _FBSOUND
		dim ok as FBSBOOLEAN
		'fbs_Init(48000,2,11,2048,0)
		ok=fbs_Init()
		if ok=true then
			set(0)
			For i= 1 To nSounds
			   	? fbs_Load_WAVFile("data/" &sounds(i) &".wav",@sound(1))
				print ".";
			Next
			Print
		else
			print "Error initializing FBsound!"
			'LogWarning("Error initializing FBsound!")
			sleep 1500
		endif
	#EndIf
#Else
#EndIf	
	return 0
end function
   
   
function play(iSound As Short,iRepeats As Short=1,iDelay As Short=0) as short
	#IfNDef _sound
		return 0
	#else
	Dim as short i
	for i=1 to iRepeats
		#IfDef _FMODSOUND
			FSOUND_PlaySound(FSOUND_FREE, Sound(iSound))
		#EndIf
		#IfDef _FBSOUND
			fbs_Play_Wave(Sound(iSound))
		#EndIf
		if iDelay>0 then
			sleep (iDelay)
		endif
	next
	return 1
	#EndIf
End function

' /sound support


type tTheEnd extends object
	declare Destructor()
End Type

Destructor tTheEnd()
	set(-1)						'shutdown means that this destructor turns off the sound
End Destructor

dim TheEnd as tTheEnd			'main instantiates the object that gets destroyed by global cleanup on shutdown

#endif'main
end namespace'uSound

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tSound -=-=-=-=-=-=-=-
	tModule.register("uSound",@uSound.init()) ',@tSound.load(),@tSound.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tSound -=-=-=-=-=-=-=-
#undef test
#define test
#endif'test

#if (defined(test) or defined(registerTests))
#print -=-=-=-=-=-=-=- TEST:  -=-=-=-=-=-=-=-

	namespace uSound

	sub Soundcheck()
		dim m as Integer	
		dim aMenu as tMainmenu
	    Dim nSounds As Short=12
	    Dim sounds(nSounds) as string
	    
	    sounds(1)="alarm_1"
	    sounds(2)="alarm_2"
	    sounds(3)="weap_1"
	    sounds(4)="weap_1"
	    sounds(5)="wormhole"
	    sounds(6)=""
	    sounds(7)="weap_4"
	    sounds(8)="weap_3"
	    sounds(9)="weap_5"
	    sounds(10)="start"
	    sounds(11)="land"
		sounds(12)="pain"
		
		aMenu.Title="Choose sound"
		aMenu.Clearchoices()
		for i as Integer = 1 to nSounds
			if i=6 then
				aMenu.Addchoice(""&i)
			else
				aMenu.Addchoice(""&i &" - Play "& sounds(i), "Plays ./data/"+sounds(i)+".wav")
			EndIf
		Next
		
		aMenu.Addchoice("Volume 4","")
		aMenu.Addchoice("Volume 3","")
		aMenu.Addchoice("Volume 2","")
		aMenu.Addchoice("Volume 1","")
		aMenu.Addchoice("Volume 0","")
		aMenu.Addchoice("Load Sounds","Load Sounds")
		aMenu.Addchoice("Exit","Exit the menu")
	
		if tScreen.isGraphic then
			amenu.x= (tscreen.gtw - amenu.lTe -2) \2
			amenu.y= (tscreen.gth - tModule.lasttest - 10)
		else
			amenu.x= (uconsole.ttw - amenu.lTe -2) \2
			amenu.y= (uconsole.tth - tModule.lasttest -2) \2
		endif
		while not uConsole.Closing
			'clear the menu and get a new choice
			dim aKey as string=aMenu.menu()
			dim m as integer= aMenu.index
			cls
			?m
			if (m<1) or (m=aMenu.nLines) then exit while
			if m=aMenu.nLines-1 then
				? "Loading... "
				? uSound.Load()
			elseif m=aMenu.nLines-2 then	?uSound.set(0)
			elseif m=aMenu.nLines-3 then	?uSound.set(1)
			elseif m=aMenu.nLines-4 then	?uSound.set(2)
			elseif m=aMenu.nLines-5 then	?uSound.set(3)
			elseif m=aMenu.nLines-6 then	?uSound.set(4)
			else
				? "Playing... "
				? uSound.Play(m)
			EndIf
						sleep	
		Wend
	End Sub

	end namespace'uSound
	
	#ifdef test
		uSound.Soundcheck()
		'? "sleep": sleep
	#else
		tModule.registertest("uSound",@uSound.Soundcheck())
	#endif'test
#endif'test