'tFaction.
'
'defines:
'factionadd=58
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
'     -=-=-=-=-=-=-=- TEST: tFaction -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tFaction -=-=-=-=-=-=-=-

declare function factionadd(a as short,b as short, add as short) as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tFaction -=-=-=-=-=-=-=-

namespace tFaction
function init() as Integer
	return 0
end function
end namespace'tFaction


#define cut2top


Type _faction
    war(8) As Short
    alli As Short
End Type

Dim Shared faction(8) As _faction

function factionadd(a as short,b as short, add as short) as short
    dim as short c
    faction(a).war(b)+=add
    faction(b).war(a)+=add
    if faction(a).alli<>0 then 
        c=faction(a).alli
        faction(b).war(c)+=add
        faction(c).war(b)+=add
        if faction(b).war(c)>100 then faction(b).war(c)=100
        if faction(c).war(b)>100 then faction(c).war(b)=100
        if faction(b).war(c)<0 then faction(b).war(c)=0
        if faction(c).war(b)<0 then faction(c).war(b)=0
    endif
    if faction(b).alli<>0 then 
        c=faction(b).alli
        faction(a).war(a)+=add
        faction(c).war(c)+=add
        if faction(a).war(c)>100 then faction(a).war(c)=100
        if faction(c).war(a)>100 then faction(c).war(a)=100
        if faction(a).war(c)<0 then faction(a).war(c)=0
        if faction(c).war(a)<0 then faction(c).war(a)=0
    endif
    if faction(a).war(b)>100 then faction(a).war(b)=100
    if faction(b).war(a)>100 then faction(b).war(a)=100
    if faction(a).war(b)<0 then faction(a).war(b)=0
    if faction(b).war(a)<0 then faction(b).war(a)=0
    return 0
end function        


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tFaction -=-=-=-=-=-=-=-
	tModule.register("tFaction",@tFaction.init()) ',@tFaction.load(),@tFaction.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tFaction -=-=-=-=-=-=-=-
#endif'test
