'tMonster.

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
'     -=-=-=-=-=-=-=- TEST: tMonster -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Type _monster
    e As _energycounter
    speed As Byte
    movetype As Byte
    atcost As Byte
    Declare function add_move_cost() As Short
    c As _cords
    made As UByte
    slot As Byte
    no As UByte
    hpmax As Single
    hp As Single
    hpnonlethal As Single 'stores nonleathal damage done to critter
    hpreg As Single
    disease As Byte
    attacked As short
    secarmo(128) As Single
    secweap(128) As Single
    guns_to As Single
    secweapc(128) As Single
    blades_to As Single
    secweapran(128) As Single
    secweapthi(128) As Single
    nohp As UByte 'Number of Hover platforms
    nojp As UByte 'Number of jetpacks
    light As UByte 'Lightsource
    dark As UByte
    sight As Single
    union
        leak as single
        biomod As Single
    end union
    stunres As Byte
    union
        diet As Byte
        optoxy as byte
    end union
    tasty As Byte
    pretty As Byte
    intel As Short
    lang As Short
    nocturnal As Byte
    faction As Short
    allied As Short
    enemy As Short
    aggr As Byte
    killedby As short

    desc As String*127
    sdesc As String*64
    ldesc As String*512
    dhurt As String*16
    dkill As String*16
    swhat As String*64
    scol As UByte
    invis As Byte

    tile As Short
    ti_no As UInteger
    sprite As Short
    col As UByte
    dcol As UByte

    'move as single
    Union
        track As Short
        carried As Short
    End Union
    range As Short
    weapon As Short
    armor As Short
    respawns As Byte
    breedson As Byte
    regrate As Byte
    reg As Byte
    nearestenemy As Short
    denemy as single
    nearestfriend As Short
    dfriend as single
    nearestdead As Short
    ddead as single
    pickup as byte
    nearestitem As Short
    ditem as single
    cmshow As Byte
    cmmod As Byte 'Change Mood mod
    pumod As Byte 'Pick up mod
    oxymax As Single
    oxygen As Single
    oxydep As Single
    helmet As Byte
    sleeping As Single
    jpfuel As Single
    jpfuelmax As Single
    jpfueluse As Single
    target As _cords
    hasoxy As Byte
    stuff(16) As Single
    items(8) As Short
    itemch(8) As Short
End Type

Dim Shared enemy(255) As _monster
Dim Shared lastcagedmonster As UByte
Dim Shared cagedmonster(128) As _monster
Dim Shared awayteam As _monster

#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tMonster -=-=-=-=-=-=-=-
declare function caged_monster_text() as string

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tMonster -=-=-=-=-=-=-=-

namespace tMonster
function init(iAction as integer) as integer
	return 0
end function
end namespace'tMonster


function caged_monster_text() as string
    dim i as short
    dim as string t
    t="Captured lifeforms: "&lastcagedmonster &"|"
    for i=1 to lastcagedmonster
        t=t &"|"&cagedmonster(i).sdesc
        if i<lastcagedmonster and cagedmonster(i).c.s<>cagedmonster(i+1).c.s or i=lastcagedmonster then t=t &" in a "&item(cagedmonster(i).c.s).desig &"."
    next
    return t
end function

#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tMonster -=-=-=-=-=-=-=-
	tModule.register("tMonster",@tMonster.init()) ',@tMonster.load(),@tMonster.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tMonster -=-=-=-=-=-=-=-
#endif'test
