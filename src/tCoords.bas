'tCoords.
'
'defines:
'cords=33, distance=225, sort_by_distance=3, furthest=0, rndwallpoint=0,
', rndwall=0
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
'     -=-=-=-=-=-=-=- TEST: tCoords -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tCoords -=-=-=-=-=-=-=-

Type _cords
    s As Short '
    p As Short '
    m As Short
    x As Short
    y As Short
    z As Short
    'function set(x as short=0,y as short=0,z as short=0,m as short=0, p as short=0, s as short=0) as short
End Type


Type _driftingship extends _cords
    g_tile As _cords
    start As _cords
End Type

Type _rect
    x As Short
    y As Short
    h As Short
    w As Short
    wd(16) As Byte
End Type


Dim Shared As UByte sm_x=75
Dim Shared As UByte sm_y=50

Dim Shared vismask(sm_x,sm_y) As Byte
Dim Shared spacemap(sm_x,sm_y) As Short



declare function cords(c As _cords) As String
declare function distance(first as _cords, last as _cords,rollover as byte=0) as single
declare function sort_by_distance(c as _cords,p() as _cords,l() as short,last as short) as short
declare function movepoint(byval c as _cords, a as short, eo as short=0, border as short=0) as _cords
declare function explored_percentage_string() as string

'private function furthest(list() as _cords,last as short, a as _cords,b as _cords) as short
'private function rndwallpoint(r as _rect, w as byte) as _cords
'private function rndwall(r as _rect) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tCoords -=-=-=-=-=-=-=-

namespace tCoords
function init() as Integer
	return 0
end function
end namespace'tCoords


#define cut2top


Dim Shared apwaypoints(1024) As _cords
Dim Shared usedship(8) As _cords
Dim Shared targetlist(4068) As _cords
Dim Shared probe(100) As _cords 'm=Item,

Dim Shared pwa(1024) As _cords 'Points working array

Dim Shared drifting(128) As _driftingship


function cords(c As _cords) As String
    Return "("&c.x &":"& c.y &")"
End function


'function _cords.set(x as short=0,y as short=0,z as short=0,m as short=0, p as short=0, s as short=0) as short
'    if x<>0 then this.x=x
'    if y<>0 then this.y=y
'    if z<>0 then this.z=z
'    if m<>0 then this.s=s
'    if p<>0 then this.p=p
'    if s<>0 then this.m=m
'    return 0
'end function
'


function distance(first as _cords, last as _cords,rollover as byte=0) as single
    dim as single dis,dx,dy,dx2
    dx=first.x-last.x
    dy=first.y-last.y
    if rollover<>0 then
        if first.x<last.x then
            dx2=60-last.x+first.x
        else
            dx2=60-first.x+last.x
        endif
        if abs(dx)>abs(dx2) then dx=dx2
    endif
    dis=sqr(dx*dx+dy*dy)
    return dis
end function

function sort_by_distance(c as _cords,p() as _cords,l() as short,last as short) as short
    dim as short sort,i

    do
        sort=0
        for i=1 to last-1
            if distance(c,p(i))>distance(c,P(i+1)) then
                sort=1
                swap p(i),p(i+1)
                swap l(i),l(i+1)
            endif
        next
    loop until sort=0
    
#if __FB_DEBUG__
    'for i=1 to last
    '    DbgPrint(i &":"&int(distance(c,p(i))))
    'next
#endif    
    return 0
end function

function furthest(list() as _cords,last as short, a as _cords,b as _cords) as short
    dim as single dis
    dim as short i,res
    for i=1 to last
        if distance(list(i),a)+distance(list(i),b)>dis then
            dis=distance(list(i),a)+distance(list(i),b)
            res=i
        endif
    next
    return res
end function

'

function rndwallpoint(r as _rect, w as byte) as _cords
    dim p as _cords
    if w=1 then 'north wall
        p.y=r.y-1
        p.x=rnd_range(r.x+1,r.x+r.w-2)
    endif
    
    if w=2 then 'East wall
        p.x=r.x+r.w+1
        p.y=rnd_range(r.y+1,r.y+r.h-2)
    endif
    
    if w=3 then 'South wall
        p.y=r.y+r.h+1
        p.x=rnd_range(r.x+1,r.x+r.w-2)
    endif
    
    if w=4 then 'west woll
        p.x=r.x-1
        p.y=rnd_range(r.y+1,r.y+r.h-2)
    endif
    return p
    
end function


function rndwall(r as _rect) as short
    dim as short a,b,c
    dim po(4) as byte
    for a=1 to 4
        if r.wd(a)=0 then
            b=b+1
            po(b)=a
        endif
    next
    if b>0 then
        c=po(rnd_range(1,b))
    else
        c=-1
    endif
    return c
end function


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
	tModule.register("tCoords",@tCoords.init()) ',@tCoords.load(),@tCoords.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tCoords -=-=-=-=-=-=-=-
#endif'test
