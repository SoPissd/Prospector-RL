'tBasis.

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
'     -=-=-=-=-=-=-=- TEST: tBasis -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test


#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Const lastgood=9

Type _goods
    'n as string*16
    p As Single
    v As Single
    'test as single
    'test2 as single
End Type

Type _basis
    c As _cords
    discovered As Short
    inv(lastgood) As _goods
    'different companys for each station
    repname As String*32
    company As Byte
    spy As Byte
    shop(8) As Byte
    pricelevel As Single=1
    mapmod As Single
    biomod As Single
    resmod As Single
    pirmod As Single
    lastsighting As Short
    lastsightingdis As Short
    lastsightingturn As Short
    lastfight As Short
    docked As Short
End Type

Dim Shared basis(12) As _basis

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tBasis -=-=-=-=-=-=-=-
declare function makecorp(a as short) as _basis
declare function rarest_good() as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tBasis -=-=-=-=-=-=-=-

namespace tBasis
function init() as Integer
	return 0
end function
end namespace'tBasis


function makecorp(a as short) as _basis
    dim basis as _basis
    dim as short b
    if a=0 then a=rnd_range(1,4)
    if a<0 then
        b=a
        do 
            a=rnd_range(1,4)
        loop until a<>-b
    endif
    basis.company=a
    if a=1 then
        basis.repname="Eridiani Explorations"
        basis.mapmod=1.8
        basis.biomod=1
        basis.resmod=1.5
        basis.pirmod=1
    endif
    if a=2 then
        basis.repname="Smith Heavy Industries"
        basis.mapmod=1
        basis.biomod=1
        basis.resmod=1.75
        basis.pirmod=0.95
    endif
    if a=3 then 
        basis.repname="Triax Traders Its."
        basis.mapmod=1
        basis.biomod=1
        basis.resmod=1.55
        basis.pirmod=1.1
    endif
    if a=4 then
        basis.repname="Omega Bioengineering"
        basis.mapmod=1
        basis.biomod=1.5
        basis.resmod=1.5
        basis.pirmod=1
    endif
    return basis 
end function


function rarest_good() as short
    dim as short j,i,good(lastgood)
    for j=0 to 3
        for i=1 to lastgood
            good(i)+=basis(j).inv(i).v
        next
    next
    return find_low(good(),lastgood)
end function

#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tBasis -=-=-=-=-=-=-=-
	tModule.register("tBasis",@tBasis.init()) ',@tBasis.load(),@tBasis.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tBasis -=-=-=-=-=-=-=-
#endif'test

