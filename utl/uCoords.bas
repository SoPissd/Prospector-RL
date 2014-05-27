'tCoords.
#include once "uDefines.bi"
DeclareDependencies()
#include "uDebug.bas"
#include "uRng.bas"
#define test 
#endif'DeclareDependencies()
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

'compiles for different types of coordinates

Type tPoint
	x as UInteger
	y as UInteger	
End Type


Type _cords
    s As Short '
    p As Short '
    m As Short
    x As Short
    y As Short
    z As Short
    'function set(x as short=0,y as short=0,z as short=0,m as short=0, p as short=0, s as short=0) as short
End Type


Type _rect
    x As Short
    y As Short
    h As Short
    w As Short
    wd(16) As Byte
End Type

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tCoords -=-=-=-=-=-=-=-


declare function cords(c As _cords) As String
declare function distance(first as _cords, last as _cords,rollover as byte=0) as single
declare function sort_by_distance(c as _cords,p() as _cords,l() as short,last as short) as short

declare function nearest(byref c as _cords, byref b as _cords,rollover as byte=0) as integer
declare function farthest(byref c as _cords, byref b as _cords) as integer
declare function furthest(list() as _cords,last as short, a as _cords,b as _cords) as short

declare function rndwallpoint(r as _rect, w as byte) as _cords
declare function rndwall(r as _rect) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tCoords -=-=-=-=-=-=-=-

namespace tCoords
function init(iAction as integer) as integer
	return 0
end function
end namespace'tCoords


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

function nearest(byref c as _cords, byref b as _cords,rollover as byte=0) as integer
    ' Moves B towards C, or C away from B
    if (rollover=1) andalso (abs(c.x-b.x)>30) then 
		swap c,b 'nearest. else farthest
    EndIf    
    return farthest(c,b)
end function


function farthest(byref c as _cords, byref b as _cords) as integer
    if c.x>b.x then
		if c.y>b.y then return 3
	    if c.y<b.y then	return 9
		return 6 'if c.y=b.y then
    elseif c.x<b.x then
		if c.y>b.y then return 1
		if c.y<b.y then	return 7
		return 4 'if c.y=b.y then
    else 'if c.x=b.x then
		if c.y>b.y then return 2
		if c.y<b.y then return 8
		return 5 'if c.y=b.y then		'same spot might signal an error
    EndIf
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




#endif'main

#if (defined(main) or defined(test))
	tModule.register("tCoords",@tCoords.init()) ',@tCoords.load(),@tCoords.save())
#endif'main
#if (defined(test) or defined(registerTests))
#print -=-=-=-=-=-=-=- TEST: tCoords -=-=-=-=-=-=-=-

	namespace tCoords

	function pt(p as tPoint=(0,0)) as Integer			
		return 0
	End Function

	sub Coordstest()
		dim p as tPoint=(150,90)
		'p=(150,90)
		pt(p)'(150,90))
		p.x=150
		p.y=90
	    Screen 13,8,2,0 ' Sets the graphic mode
	    Do
		    Circle (p.x,p.y), 10, 15
'		    Circle (150, 90), 10, 15
	    Loop Until Inkey$ <>""
	End Sub
	end namespace'tCoords
	
	#ifdef test
		tCoords.Coordstest()
		'? "sleep": sleep
	#else
		tModule.registertest("uCoords",@tCoords.Coordstest())
	#endif'test
#endif'test
