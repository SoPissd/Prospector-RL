'tVars.

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
function init() as Integer
	return 0
end function
end namespace'tVars


#define cut2top


Dim Shared pixelsize As Integer


Dim Shared bonesflag As Short
Dim Shared farthestexpedition As Integer
Dim Shared lastenemy As Short



Dim Shared As Byte someonemoved


Dim Shared As Byte _NoPB=2
Dim Shared As Short countpatrol,makepat,unattendedtribbles

Dim Shared As Byte _showspacemap=1

Dim Shared As Byte _hpdisplay=1


Dim Shared As Byte _autoinspect=1

Dim Shared As Byte _resolution=2
Dim Shared As Byte _narrowscreen=0
Dim Shared As Byte _showrolls=0
Dim Shared As Byte captainskill=-5
Dim Shared As Byte wage=10

Dim Shared As Short sidebar
dim shared as byte optoxy
Dim Shared As UInteger uid
Dim Shared As Short ranoutoffuel
Dim Shared As Short walking

Dim Shared As String itemcat(11) 
Dim Shared As String shopname(4)

Dim Shared As String goodsname(9)

Dim Shared goods_prices(9,12,12) As Single


Dim Shared bg_parent As Byte
Dim Shared location As Byte

Dim Shared battleslost(8,8) As Integer

Dim Shared adislastenemy As Short, adisdeadcounter As Short,adisloctime As Short,adisloctemp As Single


Dim Shared standardphrase(sp_last-1,2) As String
Dim Shared talent_desc(29) As String

Dim Shared _swidth As Byte=35'Length of line in a shop
Dim Shared lastapwp As Short
Dim Shared currapwp As Short
Dim Shared apdiff As Short

Dim Shared talent_desig(29) As String
'dim shared video as SDL_Surface ptr
Dim Shared ano_money As Short

Dim Shared baseprice(9) As Short
Dim Shared avgprice(9) As Single

Dim Shared spectraltype(10) As Short
Dim Shared spectralname(10) As String
Dim Shared scount(10) As Short
Dim Shared spectralshrt(10) As String




Dim Shared x As Short
Dim Shared y As Short

Dim Shared flag(20) As Short
Dim Shared zeit As Integer
Dim Shared stationroll As Short
Dim Shared companyname(5) As String
Dim Shared companynameshort(5) As String


Dim Shared makew(20,5) As Byte

Dim Shared scr As Any Ptr

Dim Shared rlprintline As Byte
Dim Shared piratebase(_NoPB) As Short 'Mapnumber of piratebase
Dim Shared atmdes(16) As String


Dim Shared patrolmod As Short

Dim Shared shiptypes(20) As String
Dim Shared awayteamcomp(4) As Byte

Dim Shared lastplanet As Short
Dim Shared lastcom As Short
Dim Shared As Byte pf_stp=1
Dim Shared lastwaypoint As Short
Dim Shared firstwaypoint As Short
Dim Shared firststationw As Short
Dim Shared lastfleet As Short
Dim Shared alienattacks As Integer
Dim Shared lastdrifting As Short=16
Dim Shared liplanet As Short 'last input planet
Dim Shared whtravelled As Short
Dim Shared whplanet As Short
Dim Shared vacuum(60,20) As Byte

Dim Shared tacdes(6) As String
Dim Shared shop_order(2) As Short
Dim Shared lastprobe As Short

Dim Shared endstory As String
Dim Shared As String bountyquestreason(6)

Dim Shared As Short just_run


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tVars -=-=-=-=-=-=-=-
	tModule.register("tVars",@tVars.init()) ',@tVars.load(),@tVars.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tVars -=-=-=-=-=-=-=-
#endif'test
