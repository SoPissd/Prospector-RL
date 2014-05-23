'tCivilisation.
'
'defines:
'show_standing=1
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
'     -=-=-=-=-=-=-=- TEST: tCivilisation -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test


#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Type _civilisation
    n As String*16
    home As _cords
    ship(1) As _ship
    item(1) As _items
    spec As _monster
    knownstations(2) As Byte
    contact As Byte
    popu As Byte
    aggr As Byte
    inte As Byte
    tech As Byte
    phil As Byte
    wars(2) As Short '0 other civ, 1 pirates, 2 Merchants
    prefweap As Byte
    culture(6) As Byte '0 birth 1 Childhood 2 Adult 3 Death 4 Religion 5 Art 6 story about a unique
End Type

Dim Shared civ(3) As _civilisation

Enum fleettype
    ft_player
    ft_merchant
    ft_pirate
    ft_patrol
    ft_pirate2
    ft_ancientaliens
    ft_civ1
    ft_civ2
    ft_monster
End Enum

Dim Shared battleslost(8,8) As Integer

#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tCivilisation -=-=-=-=-=-=-=-

declare function show_standing() as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tCivilisation -=-=-=-=-=-=-=-

namespace tCivilisation
function init(iAction as integer) as integer
	return 0
end function
end namespace'tCivilisation


function show_standing() as short
    DimDebugL(0)'1
    dim scale(6) as string
    dim as string facname(8),stscore(7)
    dim as short a,l

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


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tCivilisation -=-=-=-=-=-=-=-
	tModule.register("tCivilisation",@tCivilisation.init()) ',@tCivilisation.load(),@tCivilisation.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tCivilisation -=-=-=-=-=-=-=-
#endif'test
