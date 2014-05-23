'tStars.
'
'defines:
'is_special=11, UpdateMapSize=2, sysfrommap=68, orbitfrommap=2
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
'     -=-=-=-=-=-=-=- TEST: tStars -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Type _stars
    c As _cords
    spec As Byte
    ti_no As UInteger
    discovered As Byte
    planets(1 To 9) As Short
    desig As String*12
    comment As String*60
End Type


Dim Shared map(laststar+wormhole+1) As _stars

Const lastspecial=46

Dim Shared specialplanet(lastspecial) As Short
Dim Shared specialplanettext(lastspecial,1) As String
Dim Shared spdescr(lastspecial) As String
Dim Shared specialflag(lastspecial) As Byte

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tStars -=-=-=-=-=-=-=-

declare function is_special(m as short) as short
declare function isgasgiant(m as short) as short

declare function UpdateMapSize(size as short) as Short
declare function sysfrommap(a as short)as short
declare function orbitfrommap(a as short) as short
declare function count_gas_giants_area(c as _cords,r as short) as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tStars -=-=-=-=-=-=-=-

namespace tStars
function init(iAction as integer) as integer
	return 0
end function
end namespace'tStars


function is_special(m as short) as short
    dim a as short
    for a=0 to lastspecial
        if m=specialplanet(a) then return -1
    next
    return 0
end function    


function UpdateMapSize(size as short) as Short
    redim map(laststar+wormhole+1)
    return 0
End function    


function sysfrommap(a as short)as short
    ' returns the systems number of a planet
    dim as short b,c,d
    for b=0 to laststar
        for c=1 to 9
            if map(b).planets(c)=a then return b
        next
    next
    return -1
end function


function orbitfrommap(a as short) as short
    dim as short orbit,sys,b
    sys=sysfrommap(a)
    if sys>=0 then
        for b=1 to 9
            if map(sys).planets(b)=a then return b
        next
    endif
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

function count_gas_giants_area(c as _cords,r as short) as short
    dim as short cc,i,j
    for i=0 to laststar
        if distance(c,map(i).c)<r then
            for j=1 to 9
                if isgasgiant(map(i).planets(j)) then cc+=1
                if map(i).planets(j)=specialplanet(21) then cc+=5
                if map(i).planets(j)=specialplanet(22) then cc+=5
                if map(i).planets(j)=specialplanet(23) then cc+=5
                if map(i).planets(j)=specialplanet(24) then cc+=5
                if map(i).planets(j)=specialplanet(25) then cc+=5
            next
        endif
    next    
    return cc
end function






#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tStars -=-=-=-=-=-=-=-
	tModule.register("tStars",@tStars.init()) ',@tStars.load(),@tStars.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tStars -=-=-=-=-=-=-=-
#endif'test
