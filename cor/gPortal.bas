'tPortal.
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
'     -=-=-=-=-=-=-=- TEST: tPortal -=-=-=-=-=-=-=-
#undef intest

'#include "../utl/bFoundation.bi"
'#include "file.bi"
'#include "../utl/uDefines.bas"
'#include "../utl/uModule.bas"
'#include "../utl/uDefines.bas"
'#include "../utl/uDebug.bas"
'#include "../utl/uRng.bas"
'#include "../utl/uCoords.bas"
'#include "../utl/uMath.bas"
'#include "../utl/uScreen.bas"
'#include "../utl/uColor.bas"
'#include "../utl/uUtils.bas"
'#include "../utl/uVersion.bas"
'#include "vTiledata.bas"
'#include "vTiles.bas"
'#include "vSettings.bas"
'#include "sStars.bas"
'#include "gEnergycounter.bas"
'#include "gWeapon.bas"
'#include "pMonster.bas"
'#include "file.bi"
'#include "gUtils.bas"


#define test
#endif'test

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-


Type _transfer
    from As _cords
    dest As _cords
    tile As Short
    col As Short
    ti_no As UInteger
    oneway As Short
    discovered As Short
    desig As String*64
    tumod As Short 'the higher the more tunnels
    dimod As Short 'the higher the more digloops
    spmap As Short 'make specialmap if non0
    froti As Short 'from what tile
End Type

Dim Shared portal(1024) As _transfer
dim shared portalindex as _index
Dim Shared lastportal As Short


#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tPortal -=-=-=-=-=-=-=-

declare function display_portal(b as short,slot as short,osx as short) as short
declare function display_portals(slot as short,osx as short) as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tPortal -=-=-=-=-=-=-=-

namespace tPortal
function init(iAction as integer) as integer
	return 0
end function
end namespace'tPortal


function display_portal(b as short,slot as short,osx as short) as short
    dim as short x
    
    x=portal(b).from.x-osx
    if x<0 then x+=61
    if x>60 then x-=61
    if x>=0 and x<=_mwx then
        if portal(b).from.m=slot and portal(b).discovered=1 and portal(b).oneway<2 then
            if configflag(con_tiles)=0 then
                put ((x)*_tix,portal(b).from.y*_tiy),gtiles(gt_no(portal(b).ti_no)),trans
#if __FB_DEBUG__
                draw string(portal(b).from.x*_fw1,portal(b).from.y*_fh1),""&portal(b).ti_no,,Font2,custom,@_col
#endif
            else
                set__color( portal(b).col,0)
                draw string(portal(b).from.x*_fw1,portal(b).from.y*_fh1),chr(portal(b).tile),,Font1,custom,@_col
            endif
        endif
    endif
    x=portal(b).dest.x-osx
    if x<0 then x+=61
    if x>60 then x-=61

    if x>=0 and x<=_mwx then
        if portal(b).oneway=0 and portal(b).dest.m=slot and portal(b).discovered=1 then
            if configflag(con_tiles)=0 then
                put ((x)*_tix,portal(b).dest.y*_tiy),gtiles(gt_no(portal(b).ti_no)),trans
            else
                set__color( portal(b).col,0)
                draw string(portal(b).dest.x*_fw1,portal(b).dest.y*_fh1),chr(portal(b).tile),,Font1,custom,@_col
            endif
        endif
    endif
    return 0
end function

function display_portals(slot as short,osx as short) as short
    dim as short b
    for b=0 to lastportal
        display_portal(b,slot,osx)
    next
    return 0
end function



#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tPortal -=-=-=-=-=-=-=-
	tModule.register("tPortal",@tPortal.init()) ',@tPortal.load(),@tPortal.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tPortal -=-=-=-=-=-=-=-
#endif'test
