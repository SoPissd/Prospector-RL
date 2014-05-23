'tShip.
'
'defines:
'gethullspecs=0, makehullbox=12, max_hull=4, shipstatsblock=3,
', display_ship_weapons=2, getnextfreebay=4
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(types) or defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#undef both
#define types
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tShip -=-=-=-=-=-=-=-
#undef intest

#include "file.bi"
#include "../utl/uDefines.bas"
#include "../utl/uModule.bas"
#include "../utl/uDefines.bas"
#include "../utl/uDebug.bas"
#include "../utl/uRng.bas"
#include "../utl/uCoords.bas"
#include "../utl/uIndex.bas"
#include "../utl/uMath.bas"
#include "../utl/uScreen.bas"
#include "../utl/uColor.bas"
#include "../utl/uUtils.bas"
#include "../utl/uVersion.bas"
#include "gUtils.bas"
#include "vTiledata.bas"
#include "vTiles.bas"
#include "vSettings.bas"
#include "sStars.bas"
#include "gEnergycounter.bas"
#include "gWeapon.bas"
#include "pMonster.bas"
#include "sCoords.bas"
'#include "dParty.bas"

#define test
#endif'test


#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Enum ShipType
    ST_first
    ST_PFighter
    ST_PCruiser
    ST_PDestroyer
    ST_PBattleship
    ST_lighttransport
    ST_heavytransport
    ST_merchantman
    ST_armedmerchant
    ST_CFighter
    ST_CEscort
    ST_Cbattleship
    ST_AnneBonny
    ST_BlackCorsair
    st_hussar
    st_blackwidow
    st_adder
    ST_civ1
    ST_civ2
    ST_AlienScoutShip
    ST_spacespider
    ST_livingsphere
    ST_symbioticcloud
    ST_hydrogenworm
    ST_livingplasma
    ST_starjellyfish
    ST_cloudshark
    ST_Gasbubble
    ST_cloud
    ST_Floater
    st_spacestation
    st_last
End Enum

Dim Shared shiptypes(20) As String

Dim Shared piratenames(st_last) As String
Dim Shared piratekills(st_last) As Integer


Enum shipequipment
    se_navcom
    se_ECM
    se_CargoShielding
    se_shipdetection
    se_fuelsystem
End Enum

Type _visit
    s As Short
    t As Integer
End Type

Type _ship
    c As _cords
    e As _energycounter
    map As Short
    osx As Short
    osy As Short
    lastpirate As _cords
    landed As _cords
    turn As UInteger
    money As Integer
    aggr As Short
    desig As String *32
    ICON As String *1
    ti_no As UInteger
    di As Byte
    turnrate As Byte
    senac As Byte
    shieldshut As Byte
    cursed As Byte
    Declare function diop() As Byte
    sensors As Short
    engine As Short
    Declare function add_move_cost(mjs As Short) As Short
    Declare function movepoints(mjs As Short) As Short
    Declare function pilot(onship As Short) As Short
    Declare function gunner(onship As Short) As Short
    Declare function science(onship As Short) As Short
    Declare function doctor(onship As Short) As Short
    declare function ammo() as short
	declare function bestcrew(s1 As Short,s2 As Short) As Short

    pipilot As Short
    pigunner As Short
    piscience As Short
    pidoctor As Short
    security As Short
    disease As Byte

    manjets As Short
    weapons(25) As _weap
    Declare function useammo() As Short
    hull As Short
    hulltype As Short

    armortype As Byte=1
    loadout As Byte=1
    reloading As Byte=10
    bunking As Byte=1
    tribbleinfested as ubyte
    
    fuelmax As Single
    fuel As Single
    fueluse As Single
    shieldmax As Integer
    shieldside(7) As Byte
    tactic As Integer
    h_no As Short
    h_desig As String*24
    h_price As UShort
    h_maxhull As Short
    h_maxengine As Short
    h_maxshield As Short
    h_maxsensors As Short
    h_maxcargo As Short
    h_maxcrew As Short
    h_maxweaponslot As Short
    h_maxfuel As Single
    h_sdesc As String*5
    h_desc As String*255
    fuelpod As Short
    crewpod As Short
    addhull As Short

    dead As Short
    killedby As String*64
    shiptype As Short
    target As _cords
    equipment(4) As Short
    stuff(5) As Single
    cargo(25) As _cords
    st As Byte
    bounty As Byte
    'tradingmoney as integer
    lastvisit As _visit
    cryo As Short
    alienkills As UInteger
    deadredshirts As UInteger
    score As UInteger
    questflag(31) As Short
    discovered(10) As Byte
    towed As Byte
    Declare function tractor() As Byte
    teleportload As Byte
    col As Short
    bcol As Short
    mcol As Short
End Type

Dim Shared foundsomething As Integer
Dim Shared alliance(7) As Byte

Dim Shared player As _ship
Dim Shared empty_ship As _ship
#endif'types



#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

type tHaggle as function(way as string) as single
dim Shared pHaggle as tHaggle	

type tMerchant as function() as single
dim Shared pMerchant as tMerchant	

type tDisplay_ship as function (show as byte=0) as short
dim Shared pDisplayShip as tDisplay_ship 	
       
type tRecalcshipsbays as function() as short
dim Shared pRecalcshipsbays as tRecalcshipsbays

type tBuyShip as function(st as short,ds as string,pr as short) as short
dim Shared pBuyShip as tBuyShip

type tUpgradehull as function(t as short,byref s as _ship,forced as short=0) as short
dim Shared pUpgradehull as tUpgradehull

type tDisplayawayteam as function(showshipandteam as byte=1,osx as short=555) as short
dim Shared pDisplayawayteam as tDisplayawayteam

type tGainxp as function(typ as short,v as short=1) as string
dim shared pGainxp as tGainxp

type tPlayerfightfleet as function(f as short) as short
dim shared pPlayerfightfleet as tPlayerfightfleet

type tDisplaystars as function(bg as short=0) as short
dim Shared pDisplaystars as tDisplaystars

type tUnAugmentRandomCrewmember as function() as string
dim shared pUnAugmentRandomCrewmember as tUnAugmentRandomCrewmember

type tCrewblock as function() as string
dim shared pCrewblock as tCrewblock


#endif'types



#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tShip -=-=-=-=-=-=-=-
declare function makehullbox(t as short,file as string) as string
declare function max_hull(s as _ship) as short
declare function shipstatsblock() as string
declare function getnextfreebay() as short

declare function gethullspecs(t as short,file as string) as _ship

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tShip -=-=-=-=-=-=-=-

namespace tShip
function init(iAction as integer) as integer
	return 0
end function
end namespace'tShip


'declare function best_crew(skill as short, no as short) as short


function _ship.tractor() As Byte
    Dim As Byte i,t
    For i=0 To 25
        If weapons(i).rof<0 And weapons(i).rof<t Then t=weapons(i).rof
    Next
    Return Abs(t)
End function

function _ship.useammo() As Short
    Dim As Short i,most,where
    For i=0 To 25
        If weapons(i).ammo>most Then
            most=weapons(i).ammo
            where=i
        EndIf
    Next
    If weapons(where).ammo>0 Then
        weapons(where).ammo-=1
        Return -1
    Else
        Return 0
    EndIf
End function

function _ship.ammo() as short
    dim as short i,a
    for i=0 to 25
        a+=weapons(i).ammo
    next
    return a
end function

function _ship.diop() As Byte
    If this.di>=1 and this.di<=9 then 
		return 10-this.di
	else
	    return 0
    EndIf
End function

function _ship.bestcrew(s1 As Short,s2 As Short) As Short
#if defined(best_crew)
    Return best_crew(s1,s2)
#else
	#print *** gShip.bas compiled without access to best_crew() ***
    Return 0
#endif
End function

function _ship.pilot(onship As Short) As Short
    If pipilot<>0 Then Return pipilot
    Return bestcrew(0,1)
End function

function _ship.gunner(onship As Short) As Short
    If pigunner<>0 Then Return pigunner
    Return bestcrew(1,h_maxweaponslot)
End function

function _ship.science(onship As Short) As Short
    If piscience<>0 Then Return piscience
    Return bestcrew(2,h_maxsensors)
End function

function _ship.doctor(onship As Short) As Short
    If pidoctor<>0 Then Return pidoctor
    Return bestcrew(3,12)
End function

function _ship.movepoints(mjs As Short) As Short
    Dim mps As Short
    mps=CInt(this.engine*2-this.hull*0.15)
    If engine>0 Then mps=mps+1+mjs*3
    If mps<=0 Then mps=1
    If mps>9 Then mps=9
    Return mps
End function

function _ship.add_move_cost(mjs As Short) As Short
    e.add_action(10-movepoints(mjs))
    Return 0
End function


function gethullspecs(t as short,file as string) as _ship
    dim as short f,a,b
    dim as string word(12)
    dim as string l
    dim as _ship n
    f=freefile
    open file for input as #f
    line input #f,l
    for a=1 to t
        line input #f,l
    next
    close #f

    string_towords(word(),l,";")

    n.h_no=t
    n.h_desig=word(0)
    n.h_price=val(word(1))
    n.h_maxhull=val(word(2))
    n.h_maxshield=val(word(3))
    n.h_maxengine=val(word(4))
    n.h_maxsensors=val(word(5))
    n.h_maxcargo=val(word(6))
    n.h_maxcrew=val(word(7))
    n.h_maxweaponslot=val(word(8))
    n.h_maxfuel=val(word(9))
    n.h_sdesc=word(10)
    n.reloading=val(word(11))
    n.h_desc=word(12)
    return n
end function


function makehullbox(t as short,file as string) as string
    dim as _ship s
    dim as string box
    s=gethullspecs(t,file)
    box=s.h_desig & "||"
    if len(s.h_desc)>1 then box=box &s.h_desc
    box=box &" | | Hull Max.:"&s.h_maxhull &" | Shield Max.:"&s.h_maxshield &" | Engine Max.:"&s.h_maxengine &" | Sensors Max.:"&s.h_maxsensors
    box=box &" | Crew:"&s.h_maxcrew &" | Cargobays:"&s.h_maxcargo &" | Weapon turrets:" &s.h_maxweaponslot &" | Fuelcapacity:"&s.h_maxfuel &" |"
    return box
end function

function max_hull(s as _ship) as short
    dim as short a,r
    for a=1 to 5
        if s.weapons(a).made=87 then r+=5
    next
    r+=s.h_maxhull
    r=r*(1+((s.armortype-1)/5))
    return r
end function

function shipstatsblock() as string
    dim t as string
    dim as short c,a,mjs
    c=10
    if player.hull<(player.h_maxhull+player.addhull)/2 then c= 14
    if player.hull<2 then c=12
    t= "{15}Hullpoints"
    if player.armortype=1 then t=t &"(Standard)"
    if player.armortype=2 then t=t &"(Laminate)"
    if player.armortype=3 then t=t &"(Nanocomposite)"
    if player.armortype=4 then t=t &"(Diamanoid)"
    if player.armortype=5 then t=t &"(Neutronium)"
    t=t &"|(max :{11}"&max_hull(player)&"{15}):{"&c &"}" & player.hull
    if player.shieldmax>0 then
        t=t &"|{15}Shieldgenerator:{11}"&player.shieldmax & "{15}"
    else
        t=t &"|{15}Shieldgenerator:{11} None{15}"
    endif
    t=t &"|{15}Engine:{11}"& player.engine
    for a=1 to 5
        if player.weapons(a).made=88 then mjs+=1
        if player.weapons(a).made=89 then mjs+=2
    next
    t = t &"{15}({11}"&player.engine+2-player.h_maxhull\15+mjs &"{15} MP) Sensors:{11}"& player.sensors
    return t
end function




function getnextfreebay() as short
    dim re as short
    dim a as short
    dim b as short
    for a=1 to 10
        if player.cargo(a).x=1 then return a
    next
    return -1
end function


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tShip -=-=-=-=-=-=-=-
	tModule.register("tShip",@tShip.init()) ',@tShip.load(),@tShip.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tShip -=-=-=-=-=-=-=-
#endif'test
