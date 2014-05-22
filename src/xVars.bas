'tVars.

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(types) or defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tVars -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tVars -=-=-=-=-=-=-=-



#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tVars -=-=-=-=-=-=-=-

namespace tVars
function init(iAction as integer) as integer
	return 0
end function
end namespace'tVars


#define cut2top


Dim Shared pixelsize As Integer


Dim Shared bonesflag As Short
Dim Shared farthestexpedition As Integer


Dim Shared As Byte someonemoved


Dim Shared As Byte _showspacemap=1

Dim Shared As Byte _hpdisplay=1


Dim Shared As Byte _autoinspect=1

Dim Shared As Byte _resolution=2
Dim Shared As Byte _narrowscreen=0

dim shared as byte optoxy

Dim Shared As Short ranoutoffuel
Dim Shared As Short walking

Dim Shared As String shopname(4)

Dim Shared bg_parent As Byte

Dim Shared adislastenemy As Short, adisdeadcounter As Short,adisloctime As Short,adisloctemp As Single



Dim Shared currapwp As Short
Dim Shared apdiff As Short

'dim shared video as SDL_Surface ptr

Dim Shared x As Short
Dim Shared y As Short

Dim Shared flag(20) As Short
Dim Shared zeit As Integer
Dim Shared stationroll As Short


Dim Shared scr As Any Ptr

Dim Shared rlprintline As Byte


Dim Shared awayteamcomp(4) As Byte

Dim Shared lastcom As Short
Dim Shared As Byte pf_stp=1

Dim Shared liplanet As Short 'last input planet
Dim Shared whtravelled As Short
Dim Shared vacuum(60,20) As Byte


Dim Shared lastprobe As Short


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tVars -=-=-=-=-=-=-=-
	tModule.register("tVars",@tVars.init()) ',@tVars.load(),@tVars.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tVars -=-=-=-=-=-=-=-
#endif'test
