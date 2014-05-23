'tMakeship.
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
'     -=-=-=-=-=-=-=- TEST: tMakeship -=-=-=-=-=-=-=-
#undef intest

#include "../utl/uDefines.bas"
#include "../utl/uModule.bas"
#include "../utl/uDefines.bas"
#include "../utl/uRng.bas"
#include "../utl/uCoords.bas"
#include "gEnergycounter.bas"
#include "pMonster.bas"

#define test
#endif'test


#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

Const startingmoney=500

Dim Shared lastwaypoint As Short
Dim Shared firstwaypoint As Short

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tMakeship -=-=-=-=-=-=-=-

declare function make_ship(a as short) as _ship

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tMakeship -=-=-=-=-=-=-=-

namespace tMakeship
function init(iAction as integer) as integer
	return 0
end function
end namespace'tMakeship


function make_ship(a as short) as _ship
dim p as _ship
dim as short c,b
    p.loadout=urn(0,3,12,0)
    if a=1 then
        'players ship    
        'tRetirement.assets(9)=1
        'tRetirement.assets(6)=1
        'tRetirement.assets(11)=1
        'p.questflag(3)=1
        'artflag(5)=1
        'artflag(7)=1
        p.c=targetlist(firstwaypoint)
        p.di=nearest(basis(0).c,p.c)
        p.sensors=1
        p.hull=5
        p.hulltype=10
        p.ti_no=1
        p.fuel=100
        p.fuelmax=100
        p.fueluse=1
        p.money=Startingmoney
        income(mt_startcash)=startingmoney
        p.loadout=0
        p.engine=1
        p.weapons(1)=make_weapon(1)
        p.lastvisit.s=-1
    endif
    
    if a=2 then
        p.st=st_pfighter
        'pirate fighter
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=2
        p.ti_no=18
        p.pipilot=1
        p.pigunner=3
        p.engine=4
        p.desig="Pirate Fighter"
        p.icon="F"
        p.money=200
        p.weapons(1)=make_weapon(7)
        p.col=12
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.turnrate=3
        p.hull=p.hull*(1+urn(0,3,2,0)*.5)
    endif
    if a=3 then
        p.st=st_pcruiser
        'pirate Cruiser
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=10
        p.ti_no=19
        p.pipilot=1
        p.pigunner=4
        p.engine=3
        p.desig="Pirate Cruiser"
        p.icon="C"
        p.money=1000
        p.weapons(3)=make_weapon(7)       
        p.weapons(1)=make_weapon(7)
        p.weapons(2)=make_weapon(2)
        p.col=12
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.turnrate=2
        p.hull=p.hull*(1+urn(0,3,2,0)*.5)
    endif
    
    if a=4 then
        p.st=st_pdestroyer
        'pirate Destroyer
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=4
        p.hull=15
        p.ti_no=20
        p.shieldmax=1
        p.pipilot=2
        p.pigunner=5
        p.engine=4
        p.desig="Pirate Destroyer"
        p.icon="D"
        p.money=3000
        
        p.weapons(1)=make_weapon(8)
        p.weapons(2)=make_weapon(3)
        p.weapons(3)=make_weapon(1)
        p.weapons(4)=make_weapon(8)       
        
        p.col=12
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.cargo(3).x=1
        p.turnrate=2
        p.hull=p.hull*(1+urn(0,3,2,0)*.5)
    endif
    if a=5 then
        p.st=st_pbattleship
        'pirate Battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=25
        p.ti_no=21
        p.shieldmax=2
        p.pipilot=1
        p.pigunner=6
        p.engine=4
        p.desig="Pirate Battleship"
        p.icon="B"
        p.money=5000
        p.equipment(se_ecm)=1
               
        p.weapons(1)=make_weapon(9)
        p.weapons(2)=make_weapon(9)
        p.weapons(3)=make_weapon(4)
        p.weapons(4)=make_weapon(3)
        p.weapons(5)=make_weapon(3)
        p.weapons(6)=make_weapon(9)
        
        p.col=12
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.cargo(3).x=1
        p.cargo(4).x=1
        p.turnrate=1
        p.hull=p.hull*(1+urn(0,3,2,0)*.5)
    endif
    
    if a=6 then
        c=rnd_range(1,10)
        p.turnrate=1
        if c<5 then   
            p.st=st_lighttransport
            p.hull=3
            p.shieldmax=0
            
            p.sensors=20
            p.pipilot=1
            p.pigunner=1
            p.engine=1
            p.cargo(1).x=rarest_good+1
            for b=2 to 3
                p.cargo(b).x=rnd_range(2,6)
            next
            p.desig="light transport"
            p.icon="t"
            p.ti_no=22
        endif
        if c>4 then
            p.st=st_heavytransport
            p.hull=8
            p.shieldmax=0
            
            p.sensors=3
            p.pipilot=1
            p.pigunner=1
            p.engine=1
            for b=1 to 2
                p.cargo(b).x=rarest_good+1
            next
            for b=3 to 4
                p.cargo(b).x=rnd_range(2,6)
            next
            p.desig="heavy transport"
            p.weapons(1)=make_weapon(1)
            p.icon="T"
            p.ti_no=23
        endif
        if c>7 and c<10 then
            p.st=st_merchantman
            p.hull=12
            p.shieldmax=1
            
            p.sensors=3
            p.pipilot=1
            p.pigunner=2
            p.engine=2
            
            for b=1 to 3
                p.cargo(b).x=rarest_good+1
            next
            for b=4 to 5
                p.cargo(b).x=rnd_range(2,6)
            next
            p.weapons(1)=make_weapon(2)
            p.desig="merchantman"
            p.icon="m"
            p.ti_no=24
        endif
        if c=10 then 
            p.st=st_armedmerchant
            p.hull=15
            p.shieldmax=2
            
            p.sensors=4
            p.pipilot=1
            p.pigunner=2
            p.engine=3
            
            for b=1 to 4
                p.cargo(b).x=rarest_good+1
            next
            for b=5 to 6
                p.cargo(b).x=rnd_range(2,6)
            next
            p.weapons(2)=make_weapon(2)
            p.weapons(3)=make_weapon(2)
            p.desig="armed merchantman"
            p.icon="M"
            p.ti_no=25
        endif
        
        p.hull=p.hull*(1+urn(0,2,2,0)*.5)
        'Merchant
        p.c.x=60
        p.c.y=rnd_range(0,20)
        p.weapons(0)=make_weapon(1)
        
        p.money=0
        p.security=20
        p.shiptype=1
        p.col=10
        p.bcol=0
        p.mcol=12
    endif
    
    if a=7 then
        'Escort
        p.st=st_Cescort
        p.c.x=60
        p.c.y=rnd_range(0,20)
        p.sensors=2
        p.hull=2
        p.shieldmax=1
        p.pipilot=4
        p.pigunner=3
        p.engine=3
        p.weapons(3)=make_weapon(7)
        p.weapons(1)=make_weapon(1)
        p.weapons(2)=make_weapon(1)
        p.desig="Escort"
        p.icon="E"
        p.ti_no=26
        p.money=0
        p.security=20
        p.col=10
        p.bcol=0
        p.mcol=12
        p.turnrate=2
        p.hull=p.hull*(1+urn(0,3,2,0)*.5)
    endif

    if a=8 then
        p.st=st_annebonny
        'The dreaded Anne Bonny
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=30
        p.shieldmax=3
        p.pipilot=3
        p.pigunner=5
        p.engine=5
        p.desig="Anne Bonny"
        p.icon="A"
        p.ti_no=27
        p.money=15000
        p.loadout=3
        p.equipment(se_ecm)=2
        p.weapons(6)=make_weapon(9)       
        p.weapons(1)=make_weapon(9)
        p.weapons(2)=make_weapon(10)
        p.weapons(3)=make_weapon(5)
        p.weapons(4)=make_weapon(5)
        p.weapons(5)=make_weapon(5)
        p.col=8
        p.bcol=0
        p.mcol=10
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.cargo(3).x=1
        p.cargo(4).x=1
        p.cargo(5).x=1
        p.cargo(6).x=1
        p.turnrate=2
    endif
    if a=9 then
        p.st=st_cbattleship
        'company battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=25
        p.shieldmax=2
        p.pipilot=1
        p.pigunner=4
        p.engine=5
        p.desig="Company Battleship"
        p.icon="U"
        p.ti_no=28
        p.money=0
        
        p.equipment(se_ecm)=1
        p.weapons(4)=make_weapon(7)       
        p.weapons(1)=make_weapon(7)
        p.weapons(2)=make_weapon(7)
        p.weapons(3)=make_weapon(3)
        p.col=10
        p.bcol=0
        p.mcol=12
        p.turnrate=1
        p.hull=p.hull*(1+urn(0,2,2,0)*.5)
    endif
    
    if a=10 then
        p.st=st_blackcorsair
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=25
        p.shieldmax=3
        p.pipilot=1
        p.pigunner=5
        p.engine=3
        p.desig="Black Corsair"
        p.icon="D"
        p.ti_no=29
        p.money=8000
        
        p.equipment(se_ecm)=1
        
        p.weapons(6)=make_weapon(7)       
        p.weapons(1)=make_weapon(7)
        p.weapons(2)=make_weapon(7)
        p.weapons(3)=make_weapon(3)
        p.weapons(4)=make_weapon(3)
        p.weapons(5)=make_weapon(1)
        p.col=4
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.cargo(3).x=1
        p.cargo(4).x=1
        p.cargo(5).x=1
        p.turnrate=3
    endif
    
    if a=11 then
        p.st=st_alienscoutship
        'Alien scoutship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=6
        p.hull=35
        p.shieldmax=4
        p.pipilot=4
        p.pigunner=3
        p.engine=5
        p.desig="Ancient Alien Ship"
        p.icon="8"
        p.ti_no=30
        
        p.equipment(se_ecm)=3
        p.weapons(1)=make_weapon(66)
        p.weapons(2)=make_weapon(66)
        p.weapons(3)=make_weapon(3)
        p.weapons(4)=make_weapon(3)
        p.loadout=4
        p.col=7
        p.bcol=0
        p.mcol=14
        p.turnrate=3
    endif
    
    if a=12 then
        p.st=st_cfighter
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=2
        p.pipilot=1
        p.pigunner=1
        p.engine=4
        p.desig="Fighter"
        p.icon="F"
        p.ti_no=31
        p.weapons(1)=make_weapon(7)
        p.col=10
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.turnrate=3
    endif
    
    if a=21 then
        p.st=st_spacespider
        p.c.x=rnd_range(25,35)
        p.c.y=11
        p.hull=10
        p.hulltype=-1
        p.engine=3
        p.sensors=3
        p.pigunner=5
        p.icon="S"
        p.ti_no=37
        p.desig="crystal spider"
        p.col=11
        p.mcol=1
        p.weapons(1)=make_weapon(101)
        p.turnrate=3
    endif
    
    if a=22 then
        'Sphere
        p.st=st_livingsphere
        p.c.x=rnd_range(25,35)
        p.c.y=9
        p.hull=12
        p.hulltype=-1
        p.engine=0
        p.sensors=15
        p.pigunner=5
        p.icon="Q"
        p.ti_no=38
        p.desig="living sphere"
        p.col=8
        p.mcol=1
        p.weapons(1)=make_weapon(101)
        p.weapons(2)=make_weapon(102)
        p.weapons(3)=make_weapon(102)
        p.turnrate=3
    endif
    
    if a=23 then
        'cloud
        p.st=st_cloud
        p.c.x=rnd_range(25,35)
        p.c.y=11
        p.hull=15
        p.hulltype=-1
        p.engine=4
        p.sensors=2
        p.pigunner=2
        p.icon=chr(176)
        p.ti_no=39
        p.desig="symbiotic cloud"
        p.col=14
        p.mcol=1
        p.weapons(1)=make_weapon(101)
        p.weapons(2)=make_weapon(101)
        p.turnrate=3
    endif
    
    
    if a=24 then
        'Spacespider
        p.st=st_hydrogenworm
        p.c.x=rnd_range(25,35)
        p.c.y=9
        p.hull=4
        p.hulltype=-1
        p.engine=5
        p.sensors=3
        p.pigunner=3
        p.icon="W"
        p.ti_no=40
        p.desig="hydrogen worm"
        p.col=121
        p.mcol=1
        p.weapons(1)=make_weapon(101)
        p.turnrate=1
    endif
    
    
    if a=25 then
        p.st=st_livingplasma
        p.c.x=rnd_range(25,35)
        p.c.y=12
        p.c=movepoint(p.c,5)
        p.hull=18
        p.hulltype=-1
        p.engine=5
        p.sensors=4
        p.pigunner=4
        p.icon=chr(176)
        p.ti_no=41
        p.desig="living plasma"
        p.col=11
        p.mcol=14
        p.weapons(1)=make_weapon(101)
        p.turnrate=3
    endif
    
    if a=26 then
        p.st=st_starjellyfish
        p.c.x=rnd_range(25,35)
        p.c.y=11
        p.hull=8
        p.hulltype=-1
        p.engine=3
        p.sensors=3
        p.pigunner=2
        p.icon="J"
        p.ti_no=42
        p.desig="starjellyfish"
        p.col=11
        p.mcol=14
        p.weapons(1)=make_weapon(101)
        p.weapons(2)=make_weapon(101)
        p.weapons(3)=make_weapon(101)
        p.turnrate=2
    endif
    
    
    if a=27 then
        p.st=st_cloudshark
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.hull=2
        p.hulltype=-1
        p.engine=5
        p.sensors=3
        p.pigunner=2
        p.icon="S"
        p.desig="cloudshark"
        p.ti_no=43
        p.col=205
        p.mcol=1
        p.weapons(1)=make_weapon(101)
        p.turnrate=3
    endif
    
    if a=28 then
        p.st=st_gasbubble
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.hull=10
        p.hulltype=-1
        p.engine=2
        p.sensors=3
        p.pigunner=2
        p.icon="O"
        p.ti_no=44
        p.desig="Gasbubble"
        p.col=203
        p.mcol=1
        p.weapons(1)=make_weapon(103)
        p.turnrate=3
    endif
    
    
    if a=29 then
        p.st=st_floater
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.hull=10
        p.hulltype=-1
        p.engine=2
        p.sensors=3
        p.pigunner=2
        p.icon="F"
        p.ti_no=45
        p.desig="Floater"
        p.col=138
        p.mcol=1
        p.weapons(1)=make_weapon(104)
        p.weapons(2)=make_weapon(104)
        p.turnrate=1
    endif
    
    if a=30 then
        p.st=st_hussar
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=15
        p.shieldmax=2
        p.pipilot=1
        p.pigunner=5
        p.engine=2
        p.desig="Hussar"
        p.icon="C"
        p.ti_no=34
        p.money=5000
        p.equipment(se_ecm)=1
        p.weapons(2)=make_weapon(7)
        p.weapons(3)=make_weapon(3)
        p.weapons(4)=make_weapon(3)
        p.weapons(5)=make_weapon(1)
        p.col=4
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.cargo(3).x=1
        p.turnrate=3
    endif
    
    if a=31 then
        p.st=st_adder
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=5
        p.shieldmax=1
        p.pipilot=1
        p.pigunner=4
        p.engine=3
        p.desig="Adder"
        p.icon="F"
        p.ti_no=35
        p.money=2500
        
        p.equipment(se_ecm)=1
        p.weapons(1)=make_weapon(7)
        p.weapons(2)=make_weapon(7)
        p.col=4
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.turnrate=2
    endif
    
    if a=32 then
        p.st=st_blackwidow
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=5
        p.shieldmax=2
        p.pipilot=1
        p.pigunner=4
        p.engine=2
        p.desig="Black Widow"
        p.icon="F"
        p.ti_no=36
        p.money=2500
        
        p.equipment(se_ecm)=1
        p.weapons(1)=make_weapon(8)
        p.weapons(2)=make_weapon(13)
        p.col=4
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.turnrate=3
    endif
    
    if a=33 then
        p.st=st_spacestation
        p.c.x=30
        p.c.y=10
        p.shiptype=2
        p.sensors=7
        p.hull=500
        p.shieldmax=8
        p.pigunner=4
        p.engine=0
        
        p.equipment(se_ecm)=0
        p.desig="Spacestation"
        p.icon="S"
        p.ti_no=46
        p.col=15
        p.weapons(1)=make_weapon(7)
        p.weapons(2)=make_weapon(7)
        p.weapons(3)=make_weapon(7)
        p.weapons(4)=make_weapon(3)
        p.weapons(5)=make_weapon(3)
        p.weapons(6)=make_weapon(3)
        p.turnrate=1
        p.loadout=3
    endif
    
    if a=34 then
        p.st=st_cfighter
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.shieldmax=1
        p.hull=8
        p.pipilot=1
        p.pigunner=1
        p.engine=4
        p.desig="LRF Striker"
        p.icon="F"
        p.ti_no=31
        p.weapons(1)=make_weapon(3)
        p.weapons(2)=make_weapon(3)
        p.loadout=2
        p.col=10
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.turnrate=3
    endif
    
    if a=35 then
        p.st=st_cfighter
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.shieldmax=1
        p.hull=8
        p.pipilot=3
        p.pigunner=3
        p.engine=4
        p.desig="LRF Lightning"
        p.icon="F"
        p.ti_no=31
        p.weapons(1)=make_weapon(8)
        p.weapons(2)=make_weapon(8)
        p.col=10
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.turnrate=3
    endif
    
    
    if a=36 then
        'Escort
        p.st=st_Cescort
        p.c.x=60
        p.c.y=rnd_range(0,20)
        p.sensors=2
        p.hull=12
        p.shieldmax=2
        p.pipilot=4
        p.pigunner=5
        p.engine=5
        p.weapons(4)=make_weapon(89)
        p.weapons(3)=make_weapon(8)
        p.weapons(1)=make_weapon(3)
        p.weapons(2)=make_weapon(3)
        p.desig="EC Kursk"
        p.icon="E"
        p.ti_no=26
        p.money=0
        p.security=20
        p.col=10
        p.bcol=0
        p.mcol=12
        p.turnrate=3
    endif
    
    if a=37 then
        p.st=st_cbattleship
        'company battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=25
        p.shieldmax=2
        p.pipilot=1
        p.pigunner=5
        p.engine=4
        p.icon="U"
        p.ti_no=28
        p.money=0
        
        p.equipment(se_ecm)=2
        p.weapons(4)=make_weapon(8)       
        p.weapons(1)=make_weapon(8)
        p.weapons(2)=make_weapon(8)
        p.weapons(3)=make_weapon(5)
        p.col=10
        p.bcol=0
        p.mcol=12
        p.turnrate=2
        p.loadout=2
        p.desig="DS Argus"
    endif
    
    if a=38 then
        p.st=st_cbattleship
        'company battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=4
        p.hull=35
        p.shieldmax=3
        p.pipilot=1
        p.pigunner=4
        p.engine=5
        p.icon="U"
        p.ti_no=28
        p.money=0
        
        p.equipment(se_ecm)=2
        p.weapons(1)=make_weapon(9)       
        p.weapons(2)=make_weapon(9)
        p.weapons(3)=make_weapon(9)
        p.weapons(4)=make_weapon(89)
        p.weapons(5)=make_weapon(89)
        p.col=10
        p.bcol=0
        p.mcol=12
        p.turnrate=2
        p.loadout=3
        p.desig="BS Tyger"
    endif
    
    
    return p
end function

#endif'main

#if not __FB_OUT_LIB__ and (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tMakeship -=-=-=-=-=-=-=-
	tModule.register("tMakeship",@tMakeship.init()) ',@tMakeship.load(),@tMakeship.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tMakeship -=-=-=-=-=-=-=-
#undef test

#endif'test
