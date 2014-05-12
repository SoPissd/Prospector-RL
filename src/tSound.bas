'tSound.
'
'defines:
'set_volume=4, load_sounds=1, play_sound=19
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tSound -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tSound -=-=-=-=-=-=-=-

declare function set_volume(volume as Integer) as short
declare function load_sounds() as short
declare function play_sound(iSound As Short,iRepeats As Short=1,iDelay As Short=0) as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tSound -=-=-=-=-=-=-=-

namespace tSound
function init() as Integer
	return 0
end function
end namespace'tSound


#define cut2top


' sound support

function set_volume(volume as Integer) as short
	#ifdef _FMODSOUND
	   Dim iLvl As Short
		iLvl=0
		If volume = 1 then iLvl=63
		If volume = 2 then iLvl=128
		If volume = 3 then iLvl=190
		If volume = 4 then iLvl=255
	   FSOUND_SetSFXMasterVolume(iLvl)
		If volume = -1 then fSOUND_close
	#endif
	#ifdef _FBSOUND
		If volume= -1 then volume= 0
		fbs_Set_MasterVolume(volume/2.0)
	#endif   	
	return 0
End function


function load_sounds() as short
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

	print "Loading sounds:";
   
	#ifdef _FMODSOUND
	   if fsound_init(48000,11,0)=0 then
			set_volume(_Volume)
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
			set_volume(_Volume)
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
   
   
function play_sound(iSound As Short,iRepeats As Short=1,iDelay As Short=0) as short
	#IfNDef _sound
		return 0
	#else
	If (configflag(con_sound)<>0 and configflag(con_sound)<>2) then 
		return 0
	EndIf
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
#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tSound -=-=-=-=-=-=-=-
	tModule.register("tSound",@tSound.init()) ',@tSound.load(),@tSound.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tSound -=-=-=-=-=-=-=-
#endif'test
