'tFaction.
'
'defines:
'factionadd=58
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
'     -=-=-=-=-=-=-=- TEST: tFaction -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

Enum fleettype
    ft_player				'a 0- player			'self
    ft_merchant				'a 1- merchants
    ft_pirate				'a 2- pirates
    ft_patrol				'a 3- patrols
    ft_pirate2				'a 4- pirate2
    ft_ancientaliens		'a 5- ancient aliens
    ft_civ1					'a 6- civ 1				'no war
    ft_civ2					'a 7- civ 2				'no war
    ft_monster				'  8- monsters			'no war
End Enum

const nFactions= ft_monster'8

Dim Shared battleslost(nFactions,nFactions) As Integer

Type _faction
    war(nFactions) As Short
    alli As Short
End Type

Dim Shared faction(nFactions) As _faction
Dim Shared as string facname(nFactions)
Dim Shared as string scale(6)				'relation between factions
Dim Shared alliance(7) As Byte				'player with alliance() rating 


#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tFaction -=-=-=-=-=-=-=-

declare function factionadd(a as short,b as short, add as short) as short
declare function show_standing() as short
declare function initialize_faction_standing(bPirate as integer) as integer

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tFaction -=-=-=-=-=-=-=-

namespace tFaction
function init(iAction as integer) as integer
    facname(ft_merchant)="Merchants"
    facname(ft_pirate)="Pirates"
    facname(ft_patrol)="Company patrols"
    facname(ft_pirate2)="Famous pirates"
    facname(ft_ancientaliens)="ASCS"
    facname(ft_civ1)=civ(0).n
    facname(ft_civ2)=civ(1).n
    facname(ft_monster)="Monster"

    scale(0)=" {10}Excellent{11}"
    scale(1)=" {10}Friendly{11}"
    scale(2)=" {14}Neutral{11}"
    scale(3)=" {12}Hostile{11}"
    scale(4)=" {12}Very hostile{11}"
    scale(5)=" {12}War{11}"
	return 0
end function
end namespace'tFaction


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


function show_standing() as short
    DimDebugL(0)'1
    dim as short a,l
    dim as string stscore(7)

    for a=1 to 7
        stscore(a)=scale(faction(0).war(a)/20)
        if alliance(a)>0 then stscore(a)=stscore(a) &" (Alliance member)"
#if __FB_DEBUG__
        if debug=1 then stscore(a)=stscore(a) '& faction(0).war(a)/20 &"-"&faction(0).war(a)
#endif
    next
    l=len(stscore(1))+len("Companies:")
    scale(6)="{15}Faction standing:{11} | Companies:"&space(35-l)&stscore(1)
    l=len(stscore(2))+len("Pirates:")
    scale(6)=scale(6) &" | Pirates:"&space(35-l)&stscore(2)
    l=len(civ(0).n)+len( stscore(6))
    if civ(0).contact>0 then scale(6)=scale(6) &" | "&civ(0).n &space(35-l)&stscore(6)
    l=len(civ(1).n)+len( stscore(7))
    if civ(1).contact>0 then scale(6)=scale(6) &" | "&civ(1).n &space(35-l)&stscore(7)
    scale(6)=scale(6)&"||{15}Battles:|{11}"
    for a=1 to 8
        if battleslost(a,0)>0 then
            l=len(facname(a)& battleslost(a,0))
            scale(6)=scale(6)&" "&facname(a) & ":"&space(26-l)& battleslost(a,0)&"|"
        endif
    next
    textbox(scale(6),2,2,32,1,1)
    
    no_key= uConsole.keyinput()
    return 0
end function


function initialize_faction_standing(bPirate as integer) as integer
	'
	with faction(ft_player)
		if bPirate then
	        .war(ft_merchant)=100
	        .war(ft_pirate)=0
	        .war(ft_patrol)=100
	        .war(ft_pirate2)=0
		else
	        .war(ft_merchant)=0
	        .war(ft_pirate)=100
	        .war(ft_patrol)=0
	        .war(ft_pirate2)=100
		endif
        .war(ft_ancientaliens)=100
	end with
    '
    faction(ft_merchant).war(ft_pirate)=100
    faction(ft_merchant).war(ft_pirate2)=100
    '
    faction(ft_pirate).war(ft_merchant)=100
    faction(ft_pirate).war(ft_patrol)=100
    '
    faction(ft_patrol).war(ft_pirate)=100
    faction(ft_patrol).war(ft_pirate2)=100
    '
    faction(ft_pirate2).war(ft_merchant)=100
    faction(ft_pirate2).war(ft_patrol)=100
    '
    return 0
end function


#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tFaction -=-=-=-=-=-=-=-
	tModule.register("tFaction",@tFaction.init()) ',@tFaction.load(),@tFaction.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tFaction -=-=-=-=-=-=-=-
#endif'test
