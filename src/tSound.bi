'tSound.bi

' sound support
#IfDef makesound
#undef makesound
#define _FBSOUND
#endif
#IfDef _FBSOUND
	#print (Sound through fbsound)
	#Define _sound
	#define dprint
	Dim Shared Sound(12) As Integer
	#Include "fbsound.bi"
	#undef dprint
#Else
	#IfDef _FMODSOUND
		#print (Sound through fmodsound)
		#Define _sound
		Dim Shared Sound(12) As Integer Ptr
		Dim Shared As Integer fmod_error
		#IncLib "fmod.dll"
		#Include "fmod.bi"
	#Else
		#print (No sound)
	#EndIf
#EndIf
