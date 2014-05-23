'tCoords.
'
'defines:
'cords=33, distance=225, sort_by_distance=3, furthest=0, rndwallpoint=0,
', rndwall=0
'

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
'     -=-=-=-=-=-=-=- TEST: tCoords -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

Dim Shared apwaypoints(1024) As _cords
Dim Shared usedship(8) As _cords
Dim Shared targetlist(4068) As _cords
Dim Shared probe(100) As _cords 'm=Item,

Dim Shared pwa(1024) As _cords 'Points working array

Type _driftingship extends _cords
    g_tile As _cords
    start As _cords
End Type

Dim Shared lastdrifting As Short=16
Dim Shared drifting(128) As _driftingship
#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tCoords -=-=-=-=-=-=-=-

declare function movepoint(byval c as _cords, a as short, eo as short=0, border as short=0) as _cords
declare function explored_percentage_string() as string

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tCoords -=-=-=-=-=-=-=-

namespace nsCoords
function init(iAction as integer) as integer
	return 0
end function
end namespace'tCoords


function movepoint(byval c as _cords, a as short, eo as short=0, border as short=0) as _cords
    dim p as _cords
    dim as short x,y
    dim f as integer
    if border=0 then
        x=60
        y=20
    else
        x=sm_x
        y=sm_y
    endif
        
    if a=5 then
        a=rnd_range(1,8)
        if a=5 then a=9
    endif
    p=c
    if a=1 then
        c.x=c.x-1
        c.y=c.y+1
    endif
    if a=2 then
        c.x=c.x
        c.y=c.y+1
    endif
    if a=3 then
        c.x=c.x+1
        c.y=c.y+1
    endif
    if a=4 then
        c.x=c.x-1
        c.y=c.y
    endif
    if a=6 then
        c.x=c.x+1
        c.y=c.y
    endif
    if a=7 then
        c.x=c.x-1
        c.y=c.y-1
    endif
    if a=8 then
        c.x=c.x
        c.y=c.y-1
    endif
    if a=9 then
        c.x=c.x+1
        c.y=c.y-1
    endif
    if eo=0 then
        if c.x<0 then c.x=0
        if c.x>x then c.x=x
        if c.y<0 then c.y=0
        if c.y>y then c.y=y
    endif
    if eo=1 then
        if c.x<0 then c.x=x
        if c.x>x then c.x=0
        if c.y<0 then c.y=y
        if c.y>y then c.y=0
    endif
    if eo=2 then
        if c.x<0 or c.x>x then c=p
        if c.y<0 or c.y>y then c=p
    endif
    if eo=3 then
        if c.y<0 then c.y=0
        if c.y>y then c.y=y
        if c.x<0 then c.x=x
        if c.x>x then c.x=0
    endif
    if eo=4 then
        if c.y<0 then c.y=0
        if c.y>20 then c.y=20
        if c.x<0 then c.x=x
        if c.x>x then c.x=0
    endif
    return c
end function


function explored_percentage_string() as string
    dim as short x,y,ex
    for x=0 to sm_x
        for y=0 to sm_y
            if spacemap(x,y)>0 then ex+=1
        next
    next
    if ex<(sm_x*sm_y) then
        return "Explored {15}"&ex &"{11} parsec ({15}"& int(ex/(sm_x*sm_y)*100) &" %{11} of the sector)"
    else
        return "Explored the complete sector."
    endif
end function


#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tCoords -=-=-=-=-=-=-=-
	tModule.register("nsCoords",@nsCoords.init()) ',@tCoords.load(),@tCoords.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tCoords -=-=-=-=-=-=-=-
#endif'test
