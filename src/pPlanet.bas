'tPlanet.
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
'     -=-=-=-=-=-=-=- TEST: tPlanet -=-=-=-=-=-=-=-
#undef intest

'#include "../utl/bFoundation.bi"
#include "file.bi"
#include "../utl/uDefines.bas"
#include "../utl/uModule.bas"
#include "../utl/uDefines.bas"
#include "../utl/uDebug.bas"
#include "../utl/uRng.bas"
#include "../utl/uCoords.bas"
#include "../utl/uMath.bas"
#include "../utl/uScreen.bas"
#include "../utl/uColor.bas"
#include "../utl/uUtils.bas"
#include "../utl/uVersion.bas"
#include "vTiledata.bas"
#include "vTiles.bas"
#include "vSettings.bas"
#include "sStars.bas"
#include "gEnergycounter.bas"
#include "gWeapon.bas"
#include "pMonster.bas"
'#include "file.bi"
'#include "gUtils.bas"


#define test
#endif'test

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

Type _planetsave
    awayteam As _monster
    enemy(256) As _monster
    lastenemy As Short
    lastlocalitem As Short
    ship As _cords
    map As Short
End Type

Type _planet
    p As Short
    map As Short
    orbit As Short
    darkness As UByte
    water As Short
    atmos As Short
    dens As Short
    grav As Single
    temp As Single
    life As Short
    highestlife As Single
    minerals As Short
    weat As Single
    depth As Byte
    death As Short
    genozide As Byte
    teleport As Byte
    plantsfound As Short
    pla_template(16) As Byte
    mon_template(16) As _monster
    mon_noamin(16) As Byte
    mon_noamax(16) As Byte
    mon_killed(16) As UByte
    mon_disected(16) As UByte
    mon_caught(16) As UByte
    mon_seen(16) As UByte
    colony As Byte
    colonystats(14) As Byte
    vault(8) As _rect
    discovered As Short
    visited As Integer
    mapped As Integer
    mapmod As Single
    rot As Single
    flags(32) As Byte
    weapon(5) As _weap
    comment As String*60
    mapstat As Byte
    colflag(16) As Byte
    wallset As Byte
End Type


Const max_maps=2047
Dim Shared planets(max_maps) As _planet
Dim Shared savefrom(16) As _planetsave
Dim Shared planets_flavortext(max_maps) As String
Dim Shared lastplanet As Short
Dim Shared whplanet As Short


Dim Shared spectraltype(10) As Short
Dim Shared spectralname(10) As String
Dim Shared spectralshrt(10) As String

Dim Shared atmdes(16) As String
    
Dim Shared As Short walking

type tDigger as function(byval p as _cords,map() as short,d as byte,ti as short=2,stopti as short=0) as short
dim Shared pDigger as tDigger

type tRndPoint as function (m as short=-1,w as short=-1,t as short=-1,vege as short=-1)as _cords
dim shared pRnd_point as tRndPoint


#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tPlanet -=-=-=-=-=-=-=-

declare function deletemonsters(a as short) as short
declare function isgardenworld(m as short) as short
declare function isgasgiant(m as short) as short
declare function isasteroidfield(m as short) as short
declare function system_text(a as short) as string
declare function make_unflags(unflags() as byte) as short
declare function uniques_html(unflags() as byte) as string
declare function uniques(unflags() as byte) as string

'declare function nextplan(p as short,in as short) as short
'declare function prevplan(p as short,in as short) as short
'declare function display_sysmap(x as short, y as short, in as short, hi as short=0,bl as string,br as string) as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tPlanet -=-=-=-=-=-=-=-

namespace tPlanet
function init(iAction as integer) as integer
    dim i as short
	For i=0 To max_maps
	    planets(i).darkness=5
	Next
    
    atmdes(1)="No"
    '
    atmdes(2)="remnants of an"
    atmdes(3)="thin"
    atmdes(4)="earthlike"
    atmdes(5)="dense"
    atmdes(6)="very dense"
    '
    atmdes(7)="remnants of an exotic"
    atmdes(8)="thin, exotic"
    atmdes(9)="exotic"
    atmdes(10)="dense, exotic"
    atmdes(11)="very dense, exotic"
    '
    atmdes(12)="remnants of a corrosive"
    atmdes(13)="thin, corrosive"
    atmdes(14)="corrosive"
    atmdes(15)="dense, corrosive"
    atmdes(16)="very dense, corrosive"
	'
    spectraltype(1)=12
    spectraltype(2)=192
    spectraltype(3)=14
    spectraltype(4)=15
    spectraltype(5)=10
    spectraltype(6)=137
    spectraltype(7)=9
    spectraltype(8)=0
    spectraltype(9)=11
    spectraltype(10)=0
	'
    spectralname(1)="red sun (spectral class M)"
    spectralshrt(1)="M"
    spectralname(2)="orange sun (spectral class K)"
    spectralshrt(2)="K"
    spectralname(3)="yellow sun (spectral class G)"
    spectralshrt(3)="G"
    spectralname(4)="white sun (spectral class F)"
    spectralshrt(4)="F"
    spectralname(5)="green sun (spectral class A)"
    spectralshrt(5)="A"
    spectralname(6)="white giant (spectral class N)"
    spectralshrt(6)="N"
    spectralname(7)="blue giant (spectral class O)"
    spectralshrt(7)="O"
    spectralname(8)="a rogue planet"
    spectralshrt(8)="r"
    spectralname(9)="a wormhole"
    spectralshrt(9)="w"
    spectralname(10)="rogue gasgiant"
    spectralshrt(10)="R"
	'
	return 0
end function
end namespace'tPlanet



function deletemonsters(a as short) as short
    dim b as short
    dim m as _monster
    if a>0 then
        for b=0 to 16
            planets(a).mon_template(b)=m
            planets(a).mon_noamin(b)=0
            planets(a).mon_noamax(b)=0
        next
    endif
    return 0
end function


function isgardenworld(m as short) as short
    if m<0 then return 0
    if planets(m).grav>1.1 then return 0
    if planets(m).atmos<3 or planets(m).atmos>5 then return 0
    if planets(m).temp<-20 or planets(m).temp>55 then return 0
    if planets(m).weat>1 then return 0
    if planets(m).water<30 then return 0
    if planets(m).rot<0.5 or planets(m).rot>1.5 then return 0
    return -1
end function


function isgasgiant(m as short) as short
    if m<-20000 then return 1
    if m=specialplanet(21) then return 21
    if m=specialplanet(22) then return 22
    if m=specialplanet(23) then return 23
    if m=specialplanet(24) then return 24
    if m=specialplanet(25) then return 25
    if m=specialplanet(43) then return 43
    return 0
end function

function isasteroidfield(m as short) as short
    if m>=-20000 and m<0 then return 1
    if m=specialplanet(31) then return 1 
    if m=specialplanet(32) then return 1 
    if m=specialplanet(33) then return 1
    if m=specialplanet(41) then return 1
    return 0
end function



function system_text(a as short) as string
    dim as short o,pl,af,gg
    dim t as string
    for o=1 to 9
        if map(a).planets(o)<>0 then
            if isgasgiant(map(a).planets(o)) then gg+=1
            if isasteroidfield(map(a).planets(o)) then af+=1
            pl+=1
        endif
    next
    if pl=0 and af=0 and gg=0 then
        t=" No planets."
    else
        pl=pl-gg-af
        if pl=1 then t=t &" "& pl &" planet"
        if pl>1 then t=t &" "& pl &" planets"
        if gg=1 then t=t &" "& gg &" gas giant"
        if gg>1 then t=t &" "& gg &" gas giants"
        if af=1 then t=t &" "& af &" asteroid field"
        if af>1 then t=t &" "& af &" asteroid fields"
    endif
    return t
end function



function make_unflags(unflags() as byte) as short
    DimDebugL(0)'1
    dim as short a,foundspec
    for a=0 to lastspecial
        if specialplanet(a)>0 and specialplanet(a)<=lastplanet then
            if planets(specialplanet(a)).mapstat>0 or (debug=1) then
                unflags(a)=1
                foundspec=1
            endif
        endif
    next
    return foundspec
end function

function uniques_html(unflags() as byte) as string
    dim t as string
    dim as short a,platforms,none


    t= html_color("#ffffff") &"Unique planets discovered:</span><br>"& html_color("#00ffff")

    for a=0 to lastspecial
        if unflags(a)=1 then
                none=1
                select case a
                case is =20
                    if specialflag(20)=1 then
                        t=t &"A colony under the control of an alien lifeform<br>"
                    else
                        t=t & spdescr(a) &"<br>"
                    endif
                case 21 to 25
                    platforms+=1
                case else
                    if spdescr(a)<>"" then t=t & spdescr(a) &"<br>"
                end select
        endif
    next
    if platforms>1 then t=t & platforms &" ancient refueling platforms<br>"
    if platforms=1 then t=t & "An ancient refueling platform<br>"
    if none=0 then t=t & html_color("#ffff00")&"None</span><br>"

    return t
end function

function uniques(unflags() as byte) as string
    dim text as string
    dim as short a,platforms,none


    text= "{15}Unique planets discovered:{11}|"

    for a=0 to lastspecial
        if unflags(a)=1 then
                none=1
                select case a
                case is =20
                    if specialflag(20)=1 then
                        text=text &"A colony under the control of an alien lifeform|"
                    else
                        text=text & spdescr(a) &"|"
                    endif
                case 21 to 25
                    platforms+=1
                case else
                    if spdescr(a)<>"" then text=text & spdescr(a) &"|"
                end select
        endif
    next
    if platforms>1 then text=text & platforms &" ancient refueling platforms"
    if platforms=1 then text=text & "An ancient refueling platform"
    if none=0 then text=text &"      {14} None"
    text=text &"|"
    return text
end function



function nextplan(p as short,in as short) as short
    dim as short oldp
    oldp=p
    do
        p=p+1
        if p>9 then p=1
    loop until map(in).planets(p)<>0 or p=oldp
    return p
end function

function prevplan(p as short,in as short) as short
    dim as short oldp
    oldp=p
    do
        p=p-1
        if p<1 then p=9
    loop until map(in).planets(p)<>0 or p=oldp
    return p
end function

'

function display_sysmap(x as short, y as short, in as short, hi as short=0,bl as string,br as string) as short
    dim as short a,b,c,bg,yof,ptile,alp,spec
    dim t as string
    set__color( 224,0)
    yof=(_fh1-_fh2)/2
    if configflag(con_sysmaptiles)=0 then
        line (x,y)-(x+19*_tix,y+_tiy+6),RGB(0,0,0),BF
        line (x,y+1)-(x+19*_tix,y+_tiy+6),RGB(0,0,255),B
        'draw string(x,y),bl ,,font1,custom,@_col
        'draw string(x+19*_tix,y),br ,,font1,custom,@_col

    else
        draw string(x,y),bl ,,font1,custom,@_col
        draw string (x+_fw2,y+yof), space(25),,font2,custom,@_col
        draw string(x+25*_fw2,y),br ,,font1,custom,@_col
    endif
    set__color( spectraltype(map(in).spec),0)
    if configflag(con_sysmaptiles)=0 then
        if spectraltype(map(in).spec)>0 then put (x+_fw1,y),gtiles(gt_no(1599+map(in).spec)),trans
    else
        draw string(x+_fw1,y), "*"&space(2),,font1,custom,@_col
    endif
    for a=1 to 9
        bg=0
        spec=0
        if map(in).planets(a)>0 then
            if is_special(map(in).planets(a)) and planets(map(in).planets(a)).mapstat<>0 then
                bg=233
                spec=1
            endif
        endif
        if hi=a then bg=11
        t=" "

        if map(in).planets(a)<>0 then
                ptile=0
                alp=255
                if isgasgiant(map(in).planets(a))<>0 then
                    t="O"
                    if a<6 then
                        set__color( 162,bg)
                        ptile=1612
                    endif
                    if a=1 then
                        set__color( 164,bg)
                        ptile=1613
                    endif
                    if a>5 or map(in).spec=10 then
                        set__color( 63,bg)
                        ptile=1614
                    endif
                endif
                if isasteroidfield(map(in).planets(a))<>0 then
                    t=chr(176)
                    set__color( 7,bg)
                    ptile=1608
                endif
                if isasteroidfield(map(in).planets(a))=0 and isgasgiant(map(in).planets(a))=0 and map(in).planets(a)>0 then
                    t="o"
                    ptile=1609

                    if planets(map(in).planets(a)).atmos=0 then planets(map(in).planets(a)).atmos=1
                    if planets(map(in).planets(a)).mapstat=0 then set__color( 7,bg)
                    if planets(map(in).planets(a)).mapstat=1 then
                        alp=197
                        if planets(map(in).planets(a)).atmos=1 then
                            set__color( 15,bg)
                            ptile=1616
                        endif
                        if planets(map(in).planets(a)).atmos>1 and planets(map(in).planets(a)).atmos<7 then
                            set__color( 101,bg)
                            ptile=1619
                        endif
                        if planets(map(in).planets(a)).atmos>6 and planets(map(in).planets(a)).atmos<12 then
                            set__color( 210,bg)
                            ptile=1622
                        endif
                        if planets(map(in).planets(a)).atmos>11 then
                            set__color( 10,bg)
                            ptile=1625
                        endif
                        if planets(map(in).planets(a)).grav<0.8 then ptile+=1
                        if planets(map(in).planets(a)).grav>1.2 then ptile-=1
                    endif
                    if planets(map(in).planets(a)).mapstat=2 then
                        if planets(map(in).planets(a)).atmos=1 then
                            set__color( 8,bg)
                            ptile=1616
                        endif
                        if planets(map(in).planets(a)).atmos>1 and planets(map(in).planets(a)).atmos<7 then
                            set__color(9,bg)
                            ptile=1619
                        endif
                        if planets(map(in).planets(a)).atmos>6 and planets(map(in).planets(a)).atmos<12 then
                            set__color(198,bg)
                            ptile=1622
                        endif
                        if planets(map(in).planets(a)).atmos>11 then
                            set__color( 54,bg)
                            ptile=1625
                        endif
                        if planets(map(in).planets(a)).grav<0.8 then ptile+=1
                        if planets(map(in).planets(a)).grav>1.2 then ptile-=1
                    endif
                endif
            if configflag(con_sysmaptiles)=0 then
                if ptile>0 then put (x+_tix*(a*1.5+4),y+yof),gtiles(gt_no(ptile)),alpha,alp
                if bg=11 then put (x+_tix*(a*1.5+4),y+yof),gtiles(gt_no(1610)),trans
                if spec=1 then
                    set__color(11,0)
                    draw string(x+_tix*(a*1.5+4),y+yof),"s",,font2,custom,@_tcol
                endif
            else
                draw string(x+_fw2*(a*2+4),y+yof),t,,font2,custom,@_col
                if spec=1  then
                    set__color(11,0)
                    draw string(x+_fw2*(a*2+5),y+yof),"s",,font2,custom,@_tcol
                endif
            endif
        endif
    next
    return 0
end function


#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tPlanet -=-=-=-=-=-=-=-
	tModule.register("tPlanet",@tPlanet.init()) ',@tPlanet.load(),@tPlanet.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tPlanet -=-=-=-=-=-=-=-
#endif'test
