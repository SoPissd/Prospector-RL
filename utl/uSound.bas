'tSound.
#include once "uDefines.bi"
DeclareDependencies()
DeclareDependenciesDone()

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


#define cut2top


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
			   	fbs_Load_WAVFile("data/" &sounds(i) &".wav",@sound(1))
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

#if (defined(test) or defined(testload))
#print -=-=-=-=-=-=-=- TEST:  -=-=-=-=-=-=-=-

	namespace uSound

	sub Soundtest()
	End Sub

	end namespace'uSound
	
	#ifdef test
		uSound.Soundtest()
		'? "sleep": sleep
	#else
		tModule.registertest("uSound",@uSound.Soundtest())
	#endif'test
#endif'test