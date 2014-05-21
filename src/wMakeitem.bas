'tMakeitem.
'
'defines:
'make_item=133
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
'     -=-=-=-=-=-=-=- TEST: tMakeitem -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tMakeitem -=-=-=-=-=-=-=-
Dim Shared As UInteger uid

declare function make_item(a as short, mod1 as short=0,mod2 as short=0,prefmin as short=0,nomod as byte=0) as _items

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tMakeitem -=-=-=-=-=-=-=-

namespace tMakeitem
function init(iAction as integer) as integer
	return 0
end function
end namespace'tMakeitem


#define cut2top


function make_item(a as short, mod1 as short=0,mod2 as short=0,prefmin as short=0,nomod as byte=0) as _items
    dim i as _items
    dim as short f,roll,target,rate
    
    if uid=4294967295 then 
        rlprint "Can't make any more items!"
        return i
    endif
    uid=uid+1
    i.uid=uid

    rate=5000-disnbase(player.c)*10
    if rate<1000 then rate=1000'Divisor of turn to determine improved items
    i.scanmod=1
    
    if a=1 then
        i.ti_no=2001
        i.id=1
        i.ty=1
        i.desig="hover platform"
        i.desigp="hover platforms"
        i.icon="_"
        i.col=11
        i.bgcol=0
        i.v1=1
        i.v2=5
        i.price=i.v2*100
        i.res=60
        i.ldesc="A platform held aloft by aircushions. It can transport up to "&i.v2 &" persons and cross water. Going up mountains is impossible though"
    endif
    
    if a=2 then
        i.ti_no=2002
        i.id=2
        i.ty=1
        i.desig="jetpack"
        i.desigp="jetpacks"
        i.ldesc="A simple rocketengine straped to a persons back. Almost but not quite flying, a jump up a mountain is as easy as crossing a large body of water with it."
        i.icon="j"
        i.col=14
        i.bgcol=0
        i.v1=2
        i.v2=1
        i.v3=1
        i.price=600
        i.res=80
    endif
    
    if a=3 then
        i.ti_no=2003
        i.id=3
        i.ty=2
        i.desig="gun"
        i.desigp="guns"
        i.ldesc="A small handheld weapon. An explosion propels a projectile."
        i.icon="-"
        i.col=8
        i.bgcol=0
        i.v1=.4
        i.v2=2
        i.v3=1
        i.price=25
        i.res=15
    endif
    
    if a=4 then
        i.ti_no=2004
        i.id=4
        i.ty=2
        i.desig="rifle"
        i.desigp="rifles"
        i.ldesc="a handheld weapon with a 60cm long barrel. An explosion propels a projectile."
        i.icon="/"
        i.col=8
        i.bgcol=0
        i.v1=.6
        i.v2=2
        i.v3=0
        i.price=75
        i.res=20
    endif
    
    if a=5 then
        i.ti_no=2005
        i.id=5
        i.ty=2
        i.desig="gyro jet gun"
        i.desigp="gyro jet guns"
        i.ldesc="A small handheld weapon. Recoilless because the projectiles carry their own rocket"
        i.icon="-"
        i.col=7
        i.bgcol=0
        i.v1=.8
        i.v2=3
        i.v3=1
        i.price=150
        i.res=25
    endif
    
    if a=6 then
        i.ti_no=2006
        i.id=6
        i.ty=2
        i.desig="gyro jet rifle"
        i.desigp="gyro jet rifles"
        i.ldesc="A handheld weapon with several short barrels. Recoilless because the projectiles carry their own rocket."
        i.icon="/"
        i.col=7
        i.bgcol=0
        i.v1=1
        i.v2=3
        i.v3=0
        i.price=250
        i.res=25
    endif
    
    if a=7 then
        i.ti_no=2007
        i.id=7
        i.ty=2
        i.desig="gauss gun"
        i.desigp="gauss guns"
        i.ldesc="A small handheld weapon. It fires needlelike projectiles using magnetic fields to accelerate them. It makes up for what it lacks in punch in  accuracy."
        i.icon="-"
        i.col=7
        i.bgcol=0
        i.v1=1.2
        i.v2=4
        i.v3=1
        i.price=375
        i.res=25
    endif
    
    if a=8 then
        i.ti_no=2008
        i.id=8
        i.ty=2
        i.desig="gauss rifle"
        i.desigp="gauss rifles"
        i.ldesc="A handheld weapon with several short barrels. It fires a volley of needlelike projectiles using magnetic fields to accelerate them. It makes up for what it lacks in punch in accuracy."
        i.icon="/"
        i.col=7
        i.bgcol=0
        i.v1=1.4
        i.v2=4
        i.v3=0
        i.price=525
        i.res=25
    endif
    
    if a=9 then
        i.ti_no=2009
        i.id=9
        i.ty=2
        i.desig="laser gun"
        i.desigp="laser guns"
        i.ldesc="A energy source that can be attached to a girdle is connected to a small pistolgrip. The laserbeam emmitted by it causes a lot of damage."
        i.icon="-"
        i.col=15
        i.bgcol=0
        i.v1=1.6
        i.v2=5
        i.v3=1
        i.price=700
        i.res=30
    endif
    
    if a=10 then
        i.ti_no=2010
        i.id=10
        i.ty=2
        i.desig="laser rifle"
        i.desigp="laser rifles"
        i.ldesc="A backpack houses the energy source, connected to a pistolgrip with 3 short barrels. The laserbeams cause a lot of damage."
        i.icon="/"
        i.col=15
        i.bgcol=0
        i.v1=1.8
        i.v2=5
        i.v3=0
        i.price=900
        i.res=30
    endif
    
    if a=11 then 
        i.ti_no=2011
        i.id=11
        i.ty=2
        i.desig="plasma rifle"
        i.desigp="plasma rifles"
        i.ldesc="A backpack houses the energy source, connected to a rifle. It emits a beam of superheated plasma."
        i.icon="/"
        i.col=12
        i.bgcol=0
        i.v1=2
        i.v2=6
        i.v3=0
        i.price=1125
        i.res=35
    endif
    
    
    if a=320 then
        i.ti_no=2012
        i.id=12
        i.ty=3
        i.desig="spacesuit"
        i.desigp="spacesuits"
        i.ldesc="Your standard spacesuit."
        i.icon="&"
        i.col=15
        i.bgcol=0
        i.v1=1
        i.v3=300
        i.price=20
        i.res=10
    endif
    
    if a=12 then
        i.ti_no=2012
        i.id=13
        i.ty=3
        i.desig="ballistic suit"
        i.desigp="ballistic suits"
        i.ldesc="Your standard spacesuit. Made combatworthy with ballistic cloth around vital areas." 
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=3
        i.v3=250
        i.price=75
        i.res=25
    endif
    
    if a=13 then
        i.ti_no=2013
        i.id=14
        i.ty=3
        i.desig="full ballistic suit"
        i.desigp="full ballistic suits"
        i.ldesc="Your standard spacesuit, but completely covered in ballistic cloth."
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=4
        i.v3=200
        i.price=175
        i.res=25
    endif
    
    if a=14 then
        i.ti_no=2014
        i.id=15
        i.ty=3
        i.desig="protective suit"
        i.desigp="protective suits"
        i.ldesc="Your standard spacesuit. Made combatworthy with hardened shells around vital areas." 
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=5
        i.v3=150
        i.price=300
        i.res=25
    endif
    
    if a=15 then
        i.ti_no=2015
        i.id=16
        i.ty=3
        i.desig="full protective suit"
        i.desigp="full protective suits"
        i.ldesc="Your standard spacesuit, covered with hardened shells." 
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=6
        i.v3=150
        i.price=450
        i.res=25
    endif
    
    if a=16 then
        i.ti_no=2016
        i.id=17
        i.ty=3
        i.desig="fullerene suit"
        i.desigp="fullerene suits"
        i.ldesc="Your standard spacesuit made out of carbon fullerenes." 
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=7
        i.v3=150
        i.price=625
        i.res=25
    endif
    
    if a=17 then
        i.ti_no=2017
        i.id=18
        i.ty=3
        i.desig="combat armor"
        i.desigp="sets of combat armor"
        i.ldesc="A spacesuit covered in ablative plates." 
        i.icon="&"
        i.col=6
        i.bgcol=0
        i.v1=8
        i.v3=100
        i.price=825
        i.res=45
    endif
    
    if a=18 then
        i.ti_no=2018
        i.id=19
        i.ty=3
        i.desig="heavy combat armor"
        i.desigp="sets of heavy combat armor"
        i.ldesc="A spacesuit covered in ablative plates. Built in hydraulics increase the strength and speed of the wearer." 
        i.icon="&"
        i.col=6
        i.bgcol=0
        i.v1=9
        i.v3=100
        i.price=1050
        i.res=45
    endif
    
    if a=19 then   
        i.ti_no=2019              
        i.id=20
        i.ty=3
        i.desig="p. Forcefield"
        i.desigp="p. forcefields"
        i.ldesc="A small forcefield surrounds the wearer." 
        i.icon="&"
        i.col=2
        i.bgcol=0
        i.v1=11
        i.v3=200
        i.price=1300
        i.res=65
    endif    
         
    if a=20 then
        i.ti_no=2020
        i.id=21
        i.ty=3
        i.desig="layered p. forcefield"
        i.desigp="layered p. forcefields"
        i.ldesc="The ultimate in protective equipment. Several layered forcefields surround the wearer." 
        i.icon="&"
        i.col=6
        i.v3=200
        i.bgcol=0
        i.v1=13
        i.price=1575
        i.res=65
    endif
    
    
    if a=21 then
        i.ti_no=2021
        i.id=22
        i.ty=17
        i.desig="improved air filter"
        i.desigp="improved air filters"
        i.ldesc="Normal spacesuits have their own oxygen tank. Improved air filters attempt to supplement that with whatever is found in the surrounding atmosphere."
        i.icon="�"
        i.col=14
        i.v1=.3
        i.bgcol=0
        i.price=20
        i.res=25
        if rnd_range(1,100)<30+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)<50+tVersion.gameturn/rate then
                i.id=i.id+1000
                i.desig="good "&i.desig
                i.desigp="good "&i.desigp
                i.v1=.4
                i.price=30
            else
                i.id=i.id+1010
                i.desig="bad "&i.desig
                i.desigp="bad "&i.desigp
                i.v1=.2
                i.price=15
            endif
        endif
    endif   
    
    if a=22 then
        i.ti_no=2022
        i.id=23
        i.ty=5
        i.desig="mining drill"
        i.desigp="mining drills"
        i.ldesc="Highspeed drills for digging tunnels" 
        i.v1=2
        i.icon="["
        i.col=7
        i.bgcol=0
        i.price=1500
        i.res=35
        if rnd_range(1,100)<20+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)<50+tVersion.gameturn/rate then
                i.id=122
                i.desig="powerful "&i.desig
                i.desigp="powerful "&i.desigp
                i.v1=3
                i.price=2000
            else
                i.id=124
                i.desig="weak "&i.desig
                i.desigp="weak "&i.desigp
                i.v1=1
                i.price=1000
            endif
        endif
    endif
    
    if a=23 then
        i.ti_no=2023
        i.id=24
        i.ty=5
        i.desig="laser drill"
        i.desigp="laser drills"
        i.ldesc="like normal laserweapons, but they trade damage dealt for a bigger area affected. The result: a convenient tunnel instead of a dead enemy." 
        i.v1=5
        i.icon="["
        i.col=8
        i.bgcol=0
        i.price=2500
        i.res=55
        if rnd_range(1,100)<10+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)<50+tVersion.gameturn/rate then
                i.id=123
                i.desig="powerful "&i.desig
                i.desigp="powerful "&i.desigp
                i.v1=6
                i.price=3000
            else
                i.id=125
                i.desig="weak "&i.desig
                i.desigp="weak "&i.desigp
                i.v1=4
                i.price=2000
            endif
        endif
    endif
        
    if a=24 then
        i.ti_no=2024
        i.id=25
        i.ty=7
        i.desig="grenade"
        i.desigp="grenades"
        i.ldesc="small self propelled devices with explosive warheads"
        i.icon="'"
        i.v1=2
        i.col=7
        i.price=50
        i.res=10
    endif 
    
    if a=25 then
        i.ti_no=2025
        i.id=26
        i.ty=7
        i.desig="fusion grenade"
        i.desigp="fusion grenades"
        i.ldesc="small self propelled devices with small matter-antimatter warheads"        
        i.icon="'"
        i.v1=4
        i.col=9
        i.price=160
        i.res=11
    endif
    
    if a=26 then
        i.ti_no=2026
        i.id=27
        i.ty=8
        i.desig="set of binoculars"
        i.desigp="sets of binoculars"
        i.ldesc="a handheld device for magnifiying far away objects."
        i.icon=":"
        i.col=7
        i.v1=2
        i.price=90
        i.res=15
        if rnd_range(1,100)<10+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)<50+tVersion.gameturn/rate then
                i.id=i.id+100
                i.desig="good "&i.desig
                i.desigp="good "&i.desigp
                i.v1=3
                i.price=100
            else
                i.id=i.id+110
                i.desig="cheap "&i.desig
                i.desigp="cheap "&i.desigp
                i.v1=1
                i.price=80
            endif
        endif
    endif
    
    if a=27 then
        i.ti_no=2027
        i.id=28
        i.ty=8
        i.desig="portable sensorset"
        i.desigp="portable sensorsets"
        i.ldesc="Added to a spacesuit this device enhances the sensor input, if you know how to read it." 
        i.icon=":"
        i.col=8
        i.v1=4
        i.price=500
        i.res=25
        if rnd_range(1,100)<10+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)<50+tVersion.gameturn/rate then
                i.id=i.id+100
                i.desig="good "&i.desig
                i.desigp="good "&i.desigp
                i.v1=5
                i.price=600
            else
                i.id=i.id+110
                i.desig="cheap "&i.desig
                i.desigp="cheap "&i.desigp
                i.v1=3
                i.price=400
            endif
        endif
    endif
    
    if a=28 then
        i.ti_no=2028
        i.id=29
        i.ty=9
        i.desig="helmet lamp"
        i.desigp="helmet lamps"
        i.icon=";"
        i.ldesc="A small lamp to lighten up dark places"
        i.col=7
        i.v1=3
        i.price=40
        i.res=35
        if rnd_range(1,100)<30+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)<50+tVersion.gameturn/rate then
                i.id=i.id+1000
                i.desig="strong "&i.desig
                i.desigp="strong "&i.desigp
                i.v1=4
                i.price=50
            else
                i.id=i.id+1100
                i.desig="weak "&i.desig
                i.desigp="weak "&i.desigp
                i.v1=2
                i.price=30
            endif
        endif
            
    endif
    
    if a=29 then
        i.ti_no=2029
        i.id=30
        i.ty=9
        i.desig="flood light"
        i.desigp="flood lights"
        i.ldesc="A set of strong lamps, shoulder mounted" 
        i.icon=";"
        i.col=14
        i.v1=6
        i.price=90
        i.res=55
        if rnd_range(1,100)<30+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)<50+tVersion.gameturn/rate then
                i.id=i.id+1000
                i.desig="strong "&i.desig
                i.desigp="strong "&i.desigp
                i.v1=8
                i.price=100
            else
                i.id=i.id+1100
                i.desig="weak "&i.desig
                i.desigp="weak "&i.desigp
                i.v1=5
                i.price=80
            endif
        endif
    endif
    
    if a=30 then
        i.ti_no=2030
        i.id=31
        i.ty=10
        i.desig="communication satellite"
        i.desigp="communication satellites"
        i.ldesc="This small device deploys during landing. It is used as a relay for ship to awayteam communications. It also continuously scans the surface and emits a signal for position triangulation."
        i.icon="s"
        i.col=15
        i.v1=1
        i.price=900
        i.res=105
    endif
    
    if a=31 then
        i.ti_no=2031
        i.id=32
        i.ty=11
        i.desig="medpack"
        i.desigp="medpacks"
        i.ldesc="the basic necessities to treat wounds."
        i.icon="+"
        i.col=12
        i.bgcol=15
        i.v1=1
        i.price=50
        i.res=65
    endif
        
    
    if a=32 then
        i.ti_no=2032
        i.id=33
        i.ty=11
        i.desig="medpack II"
        i.desigp="medpacks II"
        i.ldesc="sufficent means to treat wounds."
        i.icon="+"
        i.col=12
        i.bgcol=15
        i.v1=3
        i.price=140
        i.res=75
    endif
    
    
    if a=33 then
        i.ti_no=2033
        i.id=34
        i.ty=11
        i.desig="medpack III"
        i.desigp="medpacks III"
        i.ldesc="everything you could need or want to treat wounds, as long as it is portable."
        i.icon="+"
        i.col=12
        i.bgcol=15
        i.v1=9
        i.price=420
        i.res=85
    endif
    
    if a=34 then
        i.ti_no=2034
        i.id=35
        i.ty=12
        i.desig="mechanical lockpicks"
        i.desigp=i.desig
        i.ldesc="A set if tools designed to open primitve mechanical locks"
        i.icon="}"
        i.col=7
        i.v1=1
        i.price=25
        i.res=25
    endif
    
    
    if a=35 then
        i.ti_no=2035
        i.id=36
        i.ty=12
        i.desig="electronic lockpicks"
        i.desigp=i.desig
        i.ldesc="A set if tools designed to find a way to open locks"
        i.icon="}"
        i.col=7
        i.v1=3
        i.price=125
        i.res=55
    endif
    
    if a=36 then
        i.ti_no=2036
        i.id=37
        i.ty=13
        i.desig="anaesthetics"
        i.desigp="anaesthetics"
        i.icon="'"
        i.ldesc="Most creatures fall unconcious if they eat one of these."
        i.col=13
        i.v1=10
        i.price=10
        i.res=5
    endif
    
    if a=37 then
        i.ti_no=2037
        i.id=38
        i.ty=13
        i.desig="strong anaesthetics"
        i.desigp="strong anaesthetics"
        i.ldesc="Most creatures fall unconcious if they eat one of these."
        i.icon="'"
        i.col=13
        i.v1=25
        i.price=50
        i.res=10
    endif
        
    if a=38 then
        i.ti_no=2038
        i.id=39
        i.ty=14
        i.desig="aux. oxygen tank"
        i.desigp="aux. oxygen tanks"
        i.icon="!"
        i.ldesc="A small tank to increase the oxygen supply of spacesuits. Several users can connect to one tank."
        i.col=15
        i.v1=50
        i.price=45
        i.res=65
        if rnd_range(1,100)<30+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)<50+tVersion.gameturn/rate then
                i.id=i.id+100
                i.desig="big "&i.desig
                i.desigp="big "&i.desigp
                i.v1=75
                i.price=50
            else
                i.id=i.id+110
                i.desig="small "&i.desig
                i.desigp="small "&i.desigp
                i.v1=40
                i.price=35
            endif
        endif
    endif
        
    if a=39 then
        i.ti_no=2039
        i.id=40
        i.ty=16
        i.desig="seismograph"
        i.desigp="seismographs"
        i.icon=":"
        i.ldesc="Used to predict and pinpoint the location of earthquakes."
        i.col=7
        i.price=850
        i.res=85
    endif
    
    if a=40 then
        i.ti_no=2040
        i.id=41
        i.ty=4
        i.desig="combat knife"
        i.desigp="combat knifes"
        i.icon="("
        i.col=8
        i.v1=.1
        i.v3=3
        i.price=5
        i.ldesc="A short blade to stick into enemies."
        i.res=10
    endif
    
    if a=41 then
        i.ti_no=2041
        i.id=42
        i.ty=4
        i.desig="combat blade"
        i.desigp="combat blades"
        i.icon="("
        i.col=8
        i.v1=.2
        i.v3=3
        i.price=10
        i.ldesc="A long blade for piercing and slashing."
        i.res=15
    endif
    
    if a=42 then
        i.ti_no=2042
        i.id=43
        i.ty=4
        i.desig="vibro knife"
        i.desigp="vibro knives"
        i.icon="("
        i.col=8
        i.v1=.3
        i.v3=3
        i.price=25
        i.ldesc="A blade for slashing and piercing. Sawing motions increase damage."
        i.res=20
    endif

    if a=43 then
        i.ti_no=2043
        i.id=44
        i.ty=4
        i.desig="vibro blade"
        i.desigp="vibro blades"
        i.icon="("
        i.col=8
        i.v1=.4
        i.v3=4
        i.price=50
        i.ldesc="A wide blade connected to a gauntlet. Sawing motions increase damage."
        i.res=25
    endif
    
    if a=44 then
        i.ti_no=2044
        i.id=45
        i.ty=4
        i.desig="vibro sword"
        i.desigp="vibro swords"
        i.icon="("
        i.col=8
        i.v1=.5
        i.v3=4
        i.price=75
        i.ldesc="A long blade connected to a gauntlet. Sawing motions increase damage."
        i.res=35
    endif
    
    if a=45 then
        i.ti_no=2045
        i.id=46
        i.ty=4
        i.desig="mono blade"
        i.desigp="mono blades"
        i.icon="("
        i.col=8
        i.v1=.6
        i.v3=4
        i.price=100
        i.ldesc="A sturdy gauntlet ending in a blade a single molecule wide."
        i.res=45
    endif
    
     
    if a=46 then
        i.ti_no=2046
        i.id=47
        i.ty=4
        i.desig="mono sword"
        i.desigp="mono swords"
        i.icon="("
        i.col=8
        i.v1=.7
        i.v3=4
        i.price=150
        i.ldesc="A gauntlet with a long blade attached. It is a single molecule wide and heated to increase damage."
        i.res=55
    endif
    
    if a=47 then
        i.ti_no=2047
        i.id=48
        i.ty=4
        i.desig="combat gloves"
        i.desigp="combat gloves"
        i.icon="("
        i.col=8
        i.v1=.9
        i.v3=5
        i.price=225
        i.ldesc="A sturdy gauntlet, connected to plastic sleeves going up to the shoulders. Servos increase the wearers strength. mono blades connected to the fingers hurt opponents."
        i.res=65
    endif
    
    
    if a=48 then
        i.ti_no=2048
        i.id=49
        i.ty=17
        i.desig="grenade launcher"
        i.desigp="grenade launchers"
        i.icon="]"
        i.col=7
        i.v1=2
        i.price=500
        i.ldesc="A device to increase the range and improve the aim of grenades."
        i.res=55
        if rnd_range(1,100)<10+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)<50+tVersion.gameturn/rate then
                i.v1=3
                i.id+=1000
                i.price=800
                i.desig="powerful grenade launcher"
            else
                i.v1=1
                i.id+=1001
                i.price=400
                i.desig="weak grenade launcher"
            endif
        endif
        if rnd_range(1,100)<10+tVersion.gameturn/rate and nomod=0 then
            i.v2=1
            i.id+=1002
            i.price=i.price*2
            i.desig="double "&i.desig
        endif
    endif
    
    if a=49 then
        i.ti_no=2049
        i.id=50
        i.ty=28
        i.v1=25
        i.desig="aux jetpack tanks"
        i.desigp="aux jetpack tanks"
        i.icon="!"
        i.col=14
        i.price=10
        i.ldesc="Small portable tanks to store auxillary jetpack fuel."
        i.res=65
    endif
    
    
    if a=50 then
        i.ti_no=2050
        i.id=51
        i.ty=18
        i.desig="simple rover"
        i.desigp="simple rovers"
        i.ldesc="A small wheeled robot to collect map data autonomously. To use a rover drop it on a planet and collect it later"
        i.icon="X"
        i.col=192
        i.v1=2
        i.v2=1
        i.v4=12'Speed
        i.vt.x=-1
        i.vt.y=-1
        i.price=200
        i.res=65
    endif
    
    if a=51 then
        i.ti_no=2051
        i.id=52
        i.ty=18
        i.desig="rover"
        i.desigp="rovers"
        i.ldesc="A small robot with 4 legs and decent sensors to collect map data autonomously. It can also operate under water. To use a rover drop it on a planet and collect it later"
        i.icon="X"
        i.col=204
        i.v1=3
        i.v2=2
        i.v4=16
        i.vt.x=-1
        i.vt.y=-1
        i.price=400
        i.res=70
    endif
        
    if a=52 then
        i.ti_no=2052
        i.id=53
        i.ty=18
        i.desig="improved rover"
        i.desigp="improved rovers"
        i.ldesc="A small robot with 6 legs, jets for flying short distances, and good sensors. It is used to collect map data autonomously. It can also operate under water and climb mountains. To use a rover drop it on a planet and collect it later"
        i.icon="X"
        i.col=14
        i.v1=4
        i.v2=3
        i.v4=18
        i.vt.x=-1
        i.vt.y=-1
        i.price=600
        i.res=85
    endif
    
    if a=53 then
        i.ti_no=2053
        i.id=54
        i.ty=27
        i.desig="simple mining robot"
        i.desigp="simple mining robot"
        i.ldesc="A small stationary robot, extracting small deposits and traces of ore from its immediate surroundings, autonomously. To use a mining bot drop it on a planet and collect it later"
        i.icon="X"
        i.col=54
        i.v1=0
        i.v2=100
        i.v3=.25
        i.vt.x=-1
        i.vt.y=-1
        i.price=100
        i.res=85
    endif
    
    if a=54 then
        i.ti_no=2054
        i.id=55
        i.ty=27
        i.desig="mining robot"
        i.desigp="mining robot"
        i.ldesc="A small stationary robot, extracting and drilling small deposits and traces of ore from its surroundings, autonomously. To use a mining bot drop it on a planet and collect it later"
        i.icon="X"
        i.col=60
        i.v1=0
        i.v2=250
        i.v3=.5
        i.vt.x=-1
        i.vt.y=-1
        i.price=250
        i.res=90
    endif
        
    if a=55 then
        i.ti_no=2055
        i.id=56
        i.ty=27
        i.desig="improved mining robot"
        i.desigp="improved mining robot"
        i.ldesc="A small stationary robot drilling for ore autonomously, collecting small deposits and traces of ore from the ground and atmosphere. To use a mining bot drop it on a planet and collect it later"
        i.icon="X"
        i.col=66
        i.v1=0
        i.v2=500
        i.v3=1
        i.vt.x=-1
        i.vt.y=-1
        i.price=500
        i.res=95
    endif
    
    if a=56 then
        i.ti_no=2056
        i.id=57
        i.ty=19
        i.desig="disease kit I"
        i.desigp="disease kits I"
        i.ldesc="A basic supply for the treatment of diseases." 
        i.icon="+"
        i.col=1
        i.bgcol=15
        i.v1=2
        i.price=15
    endif
    
    
    if a=57 then
        i.ti_no=2057
        i.id=58
        i.ty=19
        i.desig="disease kit II"
        i.desigp="disease kits II"
        i.ldesc="A supply of drugs and diagnostic tools for the treatment of diseases." 
        i.icon="+"
        i.col=1
        i.bgcol=15
        i.v1=4
        i.price=25
    endif
    
    if a=58 then
        i.ti_no=2058
        i.id=59
        i.ty=19
        i.desig="disease kit III"
        i.desigp="disease kits III"
        i.ldesc="Advanced diagnostic tools and drugs for the treatment of diseases." 
        i.icon="+"
        i.col=1
        i.bgcol=15
        i.v1=6
        i.price=50
    endif
    
    if a=59 then
        i.ti_no=2059
        i.id=60
        i.ty=21
        i.desig="conventional mine"
        i.desigp="conventional mines"
        i.ldesc="A simple, small explosive device, triggered by proximity"
        i.icon="'"
        i.col=10
        i.v1=6
        i.price=25
    endif
        
    if a=60 then
        i.ti_no=2060
        i.id=61
        i.ty=21
        i.desig="improved mine"
        i.desigp="improved mines"
        i.ldesc="A simple, small explosive device, triggered by proximity, blasting into the direction of the target."
        i.icon="'"
        i.col=13
        i.v1=10
        i.price=50
    endif
    
    if a=61 then
        i.ti_no=2061
        i.id=62
        i.ty=22
        i.desig="stun mine"
        i.desigp="stun mines"
        i.ldesc="A simple, small device. Triggered by proximity, a strong electrical field stuns the victim."
        i.icon="'"
        i.col=12
        i.v1=12
        i.price=25
    endif
    
    if a=62 then
        i.ti_no=2062
        i.id=63
        i.ty=26
        i.desig="cage"
        i.desigp="cages"
        i.ldesc="A cage for transporting wild animals."
        i.icon=chr(128)
        i.col=7
        i.v1=0
        i.v2=1
        i.price=25
    endif
    
    if a=63 then
        i.ti_no=2063
        i.id=64
        i.ty=26
        i.desig="stasis field"
        i.desigp="stasis fields"
        i.ldesc="A portable device for storing wild animals. It can hold up to 5 creatures in a compressed form, no matter what size."
        i.icon=chr(128)
        i.col=11
        i.v1=0
        i.v2=5
        i.price=100
    endif
    
    
    if a=64 then
        i.ti_no=2064
        i.id=65
        i.ty=26
        i.desig="improved stasis field"
        i.desigp="improved stasis fields"
        i.ldesc="A portable device for storing wild animals. It can hold up to 10 creatures in a compressed form, no matter what size."
        i.icon=chr(128)
        i.col=11
        i.v1=0
        i.v2=10
        i.price=150
    endif
    
    if a=65 then
        i.ti_no=2065
        i.id=66
        i.ty=20
        i.desig="debris from a destroyed rover"
        i.desigp="debris from destroyed rovers"
        i.ldesc="broken rover"
        i.icon="X"
        i.col=7
        i.res=100
    endif
    
    if a=66 then
        i.ti_no=2066
        i.id=67
        i.ty=20
        i.desig="debris from a destroyed mining robot"
        i.desigp="debris from destroyed mining robots"
        i.ldesc="broken rover"
        i.icon="X"
        i.col=8
        i.res=100
    endif
    
    if a=67 then
        i.ti_no=2067
        i.id=68
        i.ty=21
        i.desig="basic Infirmary"
        i.desigp="basic Infirmary"
        i.ldesc="The basic supplies and devices for your ships infirmary."
        i.icon="X"
        i.col=10
        i.v1=1
        i.price=500
        i.bgcol=15
        i.res=100
    endif
    
    
    if a=68 then
        i.ti_no=2068
        i.id=69
        i.ty=21
        i.desig="infirmary"
        i.desigp="infirmary"
        i.ldesc="The supplies and devices for your ships infirmary."
        i.icon="X"
        i.col=10
        i.v1=3
        i.price=1000
        i.bgcol=15
        i.res=100
    endif
    
    
    if a=69 then
        i.ti_no=2069
        i.id=70
        i.ty=21
        i.desig="advanced Infirmary"
        i.desigp="advanced Infirmary"
        i.ldesc="State of the art supplies and devices for your ships infirmary."
        i.icon="X"
        i.col=10
        i.v1=5
        i.price=1500
        i.bgcol=15
        i.res=100
    endif
    
    if a=70 then
        i.ti_no=2070
        i.id=71
        i.ty=36
        i.desig="emergency beacon"
        i.desigp="emergency beacons"
        i.ldesc="An external transmitter with autonomous energy supply. It transmits a distress signal on a reserved frequency, increases your chances to find help in case of an emergency."
        i.icon="s"
        i.col=15
        i.v1=3
        i.price=500
        i.res=100
    endif
    
    if a=71 then
        i.ti_no=2071
        i.id=72
        i.ty=36
        i.desig="imp. Emergency beacon"
        i.desigp="imp. emergency beacons"
        i.ldesc="An external transmitter with autonomous energy supply. It transmits a distress signal on a reserved frequency and performs a spiral search pattern, to increase your chances to find help in case of an emergency."
        i.icon="s"
        i.col=15
        i.v1=6
        i.price=900
        i.res=100
    endif
    
    if a=72 then
        i.ti_no=2072
        i.id=73
        i.ty=40
        i.desig="anti-ship mine"
        i.desigp="anti-ship mines"
        i.ldesc="a small device that explodes when in immediate vicinity of a ship"
        i.icon="�"
        i.col=7
        i.v1=5
        i.v2=3
        i.v3=75
        i.res=100
        i.price=50
    endif
    
    if a=73 then
        i.ti_no=2073
        i.id=74
        i.ty=40
        i.desig="anti-ship mine MKII"
        i.desigp="anti-ship mines MKII"
        i.ldesc="a small device that explodes when in immediate vicinity of a ship"
        i.icon="�"
        i.col=7
        i.v1=10
        i.v2=4
        i.v3=90
        i.res=100
        i.price=100
    endif
    
    if a=74 then
        i.ti_no=2074
        i.id=75
        i.ty=40
        i.desig="improvised mine"
        i.desigp="improvised mines"
        i.ldesc="a small device that explodes when in immediate vicinity of a ship"
        i.icon="�"
        i.col=7
        i.v1=3
        i.v2=2
        i.v3=90
        i.res=100
        i.price=100
    endif
    
    if a=75 then
        i.ti_no=2075
        i.id=76
        i.ty=41
        i.desig="AT landing gear"
        i.desigp="AT Landing gears"
        i.ldesc="special landing struts designed to make landing in all kinds of terrain easier"
        i.v1=2
        i.icon=chr(208)
        i.col=8
        i.res=100
        i.price=250
    endif
        
    
    if a=76 then
        i.ti_no=2076
        i.id=77
        i.ty=41
        i.desig="Imp. AT landing gear"
        i.desigp="Imp. AT Landing gears"
        i.ldesc="special landing struts designed to make landing in all kinds of terrain easier"
        i.v1=5
        i.icon=chr(208)
        i.col=14
        i.res=100
        i.price=500
    endif
    
    if a=77 then 
        i.ti_no=2077
        i.id=78
        i.ty=42
        i.desig="Ground penetrating radar"
        i.desigp="Ground penetrating radars"
        i.ldesc="A modified portable sensor set. Enables the user to see through walls"
        
        i.v1=2
        if rnd_range(1,100)<10+tVersion.gameturn/rate and nomod=0 then
            
            if rnd_range(1,100)+tVersion.gameturn/rate<60 then
                i.v1=3
                i.id+=222
                i.desig="Good ground penetrating radar"
                i.desigp="Good ground penetrating radars"
            else
                i.id+=223
                i.v1=4
                i.desig="Great ground penetrating radar"
                i.desigp="Great ground penetrating radars"
            endif
        endif
        i.icon=":"
        i.col=7
        i.res=80
        i.price=350+100*i.v1
    endif
    
    if a=78 then 
        i.ti_no=2111
        i.id=79
        i.ty=7
        i.desig="Flash grenade"
        i.desigp="Flash grenades"
        i.ldesc="Produces a bright light that illuminates an area."
        i.v1=0
        i.v2=1
        i.v3=66
        i.icon="."
        i.col=7
        i.res=80
        i.price=5
    endif
    
    if a=79 then 
        i.ti_no=2112
        i.id=80
        i.ty=7
        i.desig="Stun grenade"
        i.desigp="Stun grenades"
        i.ldesc="A non-lethal explosive device used to temporarily disorient an enemy's senses. It is designed to produce a blinding flash of light and loud noise without causing permanent injury."
        i.v1=3
        i.v2=2
        i.icon="."
        i.col=7
        i.res=80
        i.price=20
    endif
    
    
    if a=80 then 
        i.ti_no=2112
        i.id=81
        i.ty=7
        i.desig="Improved stun grenade"
        i.desigp="Improved stun grenades"
        i.ldesc=""
        i.v1=5
        i.v2=2
        i.icon="."
        i.col=7
        i.res=80
        i.price=80
    endif
    
    if a=81 then
        i.ti_no=2113
        i.id=82
        i.ty=47
        i.desig="Id Tag"
        i.desigp="Id Tags"
        i.ldesc="An Id Tag of a spaceship crew member"
        i.v1=rnd_range(1,3)
        i.v2=mod1
        i.col=11
        i.res=89
        i.icon="?"
        i.price=0
    endif
    
    if a=82 then
        i.ti_no=2114
        i.ty=48
        i.id=83
        i.desig="Autopsy kit"
        i.desigp="Autopsy kits"
        i.ldesc="Tools for analyzing alien corpses"
        i.v1=20
        i.col=0
        i.bgcol=15
        i.icon="+"
        i.price=25
        if rnd_range(1,100)<10+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)+tVersion.gameturn/rate<50 then
                i.desig="Small autopsy kit"
                i.desigp="Small autopsy kits"
                i.v1=15
                i.id+=100
                i.price=20
            else
                i.id+=110
                i.desig="Good autopsy kit"
                i.desigp="Good autopsy kits"
                i.v1=25
                i.price=30
            endif
        endif
    endif

    if a=83 then
        i.ti_no=2115
        i.ty=49
        i.id=84
        i.desig="Botany kit"
        i.desigp="Botany kits"
        i.ldesc="A kit containing tools for advanced plant analysis"
        i.v1=20
        i.col=4
        i.bgcol=15
        i.icon="+"
        i.price=25
        if rnd_range(1,100)<10+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)+tVersion.gameturn/rate<50 then
                i.desig="Small botany kit"
                i.desigp="Small botany kits"
                i.v1=15
                i.id+=100
                i.price=20
            else
                i.id+=110
                i.desig="Good botany kit"
                i.desigp="Good botany kits"
                i.v1=25
                i.price=30
            endif
        endif
    endif
    
    
    if a=84 then
        i.ti_no=2116
        i.ty=50
        i.id=85
        i.desig="Ship repair kit"
        i.desigp="Ship repair kits"
        i.ldesc="A kit containing tools for ship repair"
        i.v1=2
        i.col=4
        i.bgcol=15
        i.icon="+"
        i.price=50
        if rnd_range(1,100)<10+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)+tVersion.gameturn/rate<50 then
                i.desig="Small ship repair kit"
                i.desigp="Small ship repair kits"
                i.id+=100
                i.v1=1
                i.price=25
            else
                i.desig="Good ship repair kit"
                i.desigp="Good ship repair kits"
                i.id+=101
                i.v1=3
                i.price=75
            endif
        endif
    endif
    
    if a=104 then
        i.ti_no=2117
        i.ty=56
        i.id=104
        i.v1=1 'Volume
        i.v2=2 'Piloting Bonus
        i.v3=10 'HPs
        i.desig="Gas mining probe MK I"
        i.desigp="Gas mining probes MK I"
        i.ldesc="A system for the automatic retrieval of fuel from gas giants. It can hold up to " &i.v3 &" tons of fuel"
        i.icon="s"
        i.col=12
        i.price=100
    
    endif
    
    if a=105 then
        i.ti_no=2117
        i.ty=56
        i.id=105
        i.desig="Gas mining probe MK II"
        i.desigp="Gas mining probes MK II"
        i.v1=2 'HP
        i.v2=0 'Piloting Bonus
        i.v3=20 'Tanksizes
        i.ldesc="A system for the automatic retrieval of fuel from gas giants. It can hold up to " &i.v3 &" tons of fuel"
        i.icon="s"
        i.col=12
        i.price=200
    endif
    
    if rnd_range(1,100)<10+tVersion.gameturn/rate and a=104 or a=105 then
        if rnd_range(1,100)<50 then
            i.desig="Big "&i.desig
            i.v3=i.v3*1.5
            i.price=i.price*1.2
            i.ldesc="A system for the automatic retrieval of fuel from gas giants. It can hold up to " &i.v3 &" tons of fuel"
            i.id+=110
        else
            i.desig="Sturdy "&i.desig
            i.v1+=1
            i.price=i.price*1.1
            i.id+=120
        endif
    endif
    if a=106 then
        i.ti_no=2024
        i.id=106
        i.ty=7
        i.desig="small grenade"
        i.desigp="small grenades"
        i.ldesc="small self propelled devices with explosive warheads"
        i.icon="'"
        i.v1=1
        i.col=7
        i.price=25
        i.res=10
    endif 
    
    if a=107 then
        i.ti_no=2025
        i.id=107
        i.ty=7
        i.desig="small fusion grenade"
        i.desigp="small fusion grenades"
        i.ldesc="small self propelled devices with small matter-antimatter warheads"        
        i.icon="'"
        i.v1=3
        i.col=9
        i.price=80
        i.res=11
    endif
'   
'Typ 51-54 taken

    if a=100 then
        i.ti_no=2117
        i.ty=55
        i.id=600
        i.desig="Probe MK I"
        i.desigp="Probes MK I"
        i.ldesc="A probe for deep space operation. It has a range of 5 parsecs and 1 HP"
        i.v1=1 'Range
        i.v2=1 'Scanning Range
        i.v3=5 'HPs
        i.v4=0 'HPs
        i.v5=4 'Speed
        i.v6=5
        i.icon="s"
        i.col=11
        i.price=50
        i.res=100
    endif
    if a=101 then
        i.ti_no=2118
        i.ty=55
        i.id=601
        i.desig="Probe MK II"
        i.desigp="Probes MK II"
        i.ldesc="A probe for deep space operation. It has a range of 7 parsecs and 2 HP"
        i.v1=2 'Range
        i.v2=2 'Scanning Range
        i.v3=7 'HPs
        i.v4=1 'HPs
        i.v5=5 'Speed
        i.v6=7
        i.icon="s"
        i.col=11
        i.price=100
        i.res=100
    endif
    if a=102 then
        i.ti_no=2119
        i.ty=55
        i.id=602
        i.desig="Probe MK III"
        i.desigp="Probes MK III"
        i.ldesc="A probe for deep space operation. It has a range of 10 parsecs and 3 HP"
        i.v1=3 'Range
        i.v2=3 'Scanning Range
        i.v3=10 'HPs
        i.v4=2 'HPs
        i.v5=6 'speed
        i.v6=10
        i.icon="s"
        i.col=11
        i.res=100
        i.price=150
    endif
    
    if rnd_range(1,100)<10+tVersion.gameturn/rate and (a=100 or a=101 or a=102) then
        i.desig="Fast "&i.desig
        i.desigp="Fast "&i.desigp
        i.price=i.price*1.1
        i.v5=i.v5+3
        i.id+=50
    endif
    
    if a=103 then
        i.ti_no=2120
        i.desig="ship detection system"
        i.desigp="ship detection systems"
        i.price=1500
        i.id=1001
        i.ty=51
        i.v1=1
    endif
'   
    if a=110 then 'Drone MK1
        i.ti_no=2118
        i.desig="Drone MK I"
        i.desigp="Drones MK I"
        i.ty=67
        i.id=552
        i.v1=2 'HP
        i.v2=1 'Dam
        i.v3=1 'Range
        i.v4=3 'Engine
        i.price=500
        i.res=100
        i.icon="d"
        i.col=c_gre
        i.ldesc="An autonomous drone for space combat. It has " &i.v1 &" Hullpoints and is armed with a " &i.v2 &"0 GJ plasma cannon"
    endif
    
    if a=111 then 'Drone MK1
        i.ti_no=2118
        i.desig="Drone MK II"
        i.desigp="Drones MK II"
        i.ty=67
        i.id=553
        i.v1=3 'HP
        i.v2=2 'Dam
        i.v3=1 'Range
        i.v4=4 'Engine
        i.price=1000
        i.res=100
        i.icon="d"
        i.col=c_gre
        i.ldesc="An autonomous drone for space combat. It has " &i.v1 &" Hullpoints and is armed with a " &i.v2 &"0 GJ plasma cannon"
    endif
    
    
    if a=112 then 'Drone MK1
        i.ti_no=2118
        i.desig="Drone MK III"
        i.desigp="Drones MK III"
        i.ty=67
        i.id=554
        i.v1=4 'HP
        i.v2=3 'Dam
        i.v3=2 'Range
        i.v4=5 'Engine
        i.price=1500
        i.res=100
        i.icon="d"
        i.col=c_gre
        i.ldesc="An autonomous drone for space combat. It has " &i.v1 &" Hullpoints and is armed with a " &i.v2 &"0 GJ plasma cannon"
    endif
    
    if rnd_range(1,100)<10+tVersion.gameturn/rate and (a=110 or a=111 or a=112) then
        select case rnd_range(1,100)
        case 1 to 30
            i.desig="Fast "&i.desig
            i.desigp="Fast "&i.desigp
            i.price=i.price*1.1
            i.v5=i.v5+3
            i.id+=50
        case 31 to 60
            i.desig="Sturdy "&i.desig
            i.desigp="Sturdy "&i.desigp
            i.price=i.price*1.1
            i.v1=i.v1+2
            i.id+=100
        case 61 to 90
            i.desig="Powerful "&i.desig
            i.desigp="Powerful "&i.desigp
            i.price=i.price*1.1
            i.v2=i.v2+1
            i.id+=150
        case else
            select case rnd_range(1,100)
            case 1 to 33
                i.desig="Fast sturdy "&i.desig
                i.desigp="Fast sturdy "&i.desigp
                i.price=i.price*1.3
                i.v1=i.v1+2
                i.v5=i.v5+3
                i.id+=250
            
            case 33 to 66
                i.desig="Powerful sturdy "&i.desig
                i.desigp="Powerful sturdy "&i.desigp
                i.price=i.price*1.4
                i.v1=i.v1+2
                i.v2=i.v2+1
                i.id+=350
            case else
                i.desig="Powerful fast "&i.desig
                i.desigp="Powerful fast "&i.desigp
                i.price=i.price*1.2
                i.v5=i.v5+3
                i.v2=i.v2+1
                i.id+=450
            end select
            
        end select
        i.ldesc="An autonomous drone for space combat. It has " &i.v1 &" Hullpoints, and is armed with a " &i.v2 &"0 GJ plasma cannon"
        
            
    endif
    
    if rnd_range(1,100)<5+tVersion.gameturn/rate and (a=110 or a=111 or a=112) then
        i.desig=i.desig &"-S"
        i.id+=100
        i.v6=1
        i.ldesc="An autonomous drone for space combat. It has " &i.v1 &" Hullpoints, and is armed with a " &i.v2 &"0 GJ plasma cannon. It also has a shield generator."
        i.price=i.price*1.2
    endif
    
    if a=152 then
        i.ti_no=2025
        i.ty=77
        i.id=556
        i.icon="'"
        i.col=14
        i.desig="mining explosives"
        i.desigp="mining explosives"
        i.ldesc="Cheap explosives to blow holes into rubble and mountains. Just drop to use them"
        i.v1=10
        i.price=25
        i.res=90
        if rnd_range(1,100)<10+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)+tVersion.gameturn/rate<66 then
                i.v1=7
                i.price=20
                i.desig="weak "&i.desig
                i.desigp="weak "&i.desigp
            else
                i.v1=12
                i.price=30
                i.desig="strong "&i.desig
                i.desigp="strong "&i.desigp
            endif
        endif
    endif
    
    if a=162 then
        i.ti_no=2062
        i.id=62
        i.ty=29
        i.desig="cage trap"
        i.desigp="cage traps"
        i.ldesc="For trapping wild animals. Just place it on the ground and wait for an animal to wander into it. Contains:"
        i.icon=chr(128)
        i.col=13
        i.v1=0
        i.v2=1
        i.price=125
    endif
    
    
    if a=163 then
        i.ti_no=2062
        i.id=63
        i.ty=29
        i.desig="stasis trap"
        i.desigp="stasis traps"
        i.ldesc="For trapping wild animals. Just place it on the ground and wait for an animal to wander into it. Contains:"
        i.icon=chr(128)
        i.col=13
        i.v1=0
        i.v2=5
        i.price=525
    endif
'
'
'    if a=81 then
'        i.ti_no=2003
'        i.id=81
'        i.ty=2
'        i.desig="Injector gun"
'        i.desigp="Injector guns"
'        i.ldesc="A nonlethal weapon. It fires several small darts, filled with a drug paralyzing most lifeforms. It does negligable damage, but may incapacitate an opponent."
'        i.v5=.1
'        i.v2=2
'        i.v4=30
'    endif
'    
'    if a=82 then
'        i.ti_no=2003
'        i.id=79
'        i.ty=2
'        i.desig="Disruptor"
'        i.desigp="Disruptors"
'        i.ldesc="A nonlethal weapon. A strong magnetic field disrupts nerve signals in the target, leaving only minor damage, but stunning it."
'        i.v5=.1
'        i.v2=4
'        i.v4=30
'        i.icon="-"
'        i.col=7
'        i.res=80
'        i.price=80
'    endif
'    
'    if a=83 then
'        i.ty=4
'        i.desig="Electric baton"
'        i.v1=.1
'        i.v4=15
'    endif
'    
'    if a=84 then
'        i.desig="Sonic Mace"
'        i.v5=.1
'        i.v4=30
'    endif
'        
    if a=86 then
        i.ti_no=2078
        i.id=86
        i.ty=86
        i.v1=1
        i.desig="burrowers eggsack"
        i.desigp="burrowers eggsacks"
        i.ldesc="a skinsack containing about 50 burrowers eggs, carried by the larger female of the species."
        i.icon="o"
        i.col=14
    endif
        
    if a=88 then
        i.ti_no=2079
        i.id=94
        i.ty=23
        i.desigp="pieces of alien art"
        i.col=14
        i.icon="?"
        i.v1=1
        i.v2=rnd_range(1,6)+rnd_range(1,6)
        i.desig="A bag full of alien coins"
        i.price=i.v1*i.v2*20
        i.res=100
    endif
    
    
    if a=89 then
        i.ti_no=2080
        i.id=89
        i.ty=89
        i.desig="crystal shard"
        i.desigp="crystal shards"
        i.v1=1
        i.ldesc="A shard of an intelligent crystal being. It still emits an electrical field similiar to human brain waves."
        i.icon="*"
        i.col=144
        i.res=120
    endif
        
    if a=90 then
        i.ti_no=2081
        i.id=90
        i.ty=24
        i.desig="nanobot factory"
        i.desigp="nanobot factorys"
        i.col=9
        i.v1=1000
        i.icon="*"
        i.price=35*rnd_range(1,3)
        i.res=100
    endif
    
    if a=91 then
        i.ti_no=2082
        i.id=93
        i.ty=23
        i.desig="bow and arrows"
        i.desigp="pieces of alien art"
        i.col=14
        i.icon="-"
        i.price=135*rnd_range(1,3)
        i.res=100
    endif
    
    if a=92 then
        i.ti_no=2083
        i.id=93
        i.ty=23
        i.desig="primitive handgun"
        i.desigp="pieces of alien art"
        i.col=14
        i.icon="-"
        i.price=335*rnd_range(2,6)
        i.res=100
    endif
    
    if a=93 then
        i.ti_no=2084
        i.id=93
        i.ty=23
        i.desigp="pieces of alien art"
        i.col=14
        i.icon="?"
        i.v1=3
        i.v2=rnd_range(1,6)+rnd_range(1,6)
        if i.v2=2 then i.desig="alien painting"
        if i.v2=3 then i.desig="pots of burnt clay"
        if i.v2=4 then i.desig="religious idol"
        if i.v2=5 then i.desig="some well worked primitive tools"
        if i.v2=6 then i.desig="wooden box"
        if i.v2=7 then i.desig="small clay statue"
        if i.v2=8 then i.desig="small stone statue"
        if i.v2=9 then i.desig="pretty painting"
        if i.v2=10 then i.desig="hand written book"
        if i.v2=11 then i.desig="some jewelery"
        if i.v2=12 then i.desig="some very well worked jewelery"        
        i.price=i.v1*i.v2*30
        i.res=100
    endif
        
    if a=94 then
        i.ti_no=2084
        i.id=94
        i.ty=23
        i.desigp="pieces of alien art"
        i.col=14
        i.icon="?"
        i.v1=1
        i.v2=rnd_range(1,6)+rnd_range(1,6)
        if i.v2=2 then i.desig="alien painting"
        if i.v2=3 then i.desig="pots of burnt clay"
        if i.v2=4 then i.desig="religious idol"
        if i.v2=5 then i.desig="metal chains"
        if i.v2=6 then i.desig="wooden box"
        if i.v2=7 then i.desig="small clay statue"
        if i.v2=8 then i.desig="small stone statue"
        if i.v2=9 then i.desig="pretty painting"
        if i.v2=10 then i.desig="hand written book"
        if i.v2=11 then i.desig="jewelery"
        if i.v2=12 then i.desig="very well worked jewelery"
        i.price=i.v1*i.v2*20
        i.res=100
    endif
    
    if a=95 then
        i.ti_no=2085
        i.id=95
        i.ty=12
        i.desig="alien holokeycard"
        i.desigp="alien holokeycards"
        i.icon="}"
        i.col=1
        i.v1=5
        i.res=100
        i.price=2500
    endif
    
    if a=96 then
        i.id=96
        i.ty=15
        
        i.v1=rnd_range(1,4)+mod1
        if rnd_range(1,100)>15 then
            i.v2=rnd_range(1,8+mod2)
        else
            i.v2=prefmin
        endif
        if i.v2>9 then i.v1=i.v1-1
        if i.v2>10 then i.v1=i.v1-1
        if i.v2>11 then i.v1=i.v1-1
        if i.v2>12 then i.v1=i.v1-1
        if i.v2>13 then i.v1=i.v1-1
        if i.v1<1 then i.v1=1
        if i.v2<1 then i.v2=1
        if i.v2>14 then i.v2=14
        
        'used colors 2 3 5 7 10 11 13 14 15 
        'unused 4 6 8 9 12
        if i.v2=1 then i.desig="iron"
        if i.v2=1 then i.col=4
        if i.v2=1 then i.ti_no=2086
        
        if i.v2=2 then i.desig="copper"
        if i.v2=2 then i.col=2
        if i.v2=2 then i.ti_no=2087
        
        if i.v2=3 then i.desig="sulfur"
        if i.v2=3 then i.col=6
        if i.v2=3 then i.ti_no=2088
        
        if i.v2=4 then i.desig="silver"
        if i.v2=4 then i.col=7
        if i.v2=4 then i.ti_no=2089
        
        if i.v2=5 then i.desig="gold"
        if i.v2=5 then i.col=14
        if i.v2=5 then i.ti_no=2090
        
        if i.v2=6 then i.desig="osmodium"
        if i.v2=6 then i.col=8
        if i.v2=6 then i.ti_no=2091
        
        if i.v2=7 then i.desig="palladium"
        if i.v2=7 then i.col=15
        if i.v2=7 then i.ti_no=2092
        
        if i.v2=8 then i.desig="gems"
        if i.v2=8 then i.col=5
        if i.v2=8 then i.ti_no=2093
        
        if i.v2=9 then i.desig="transuranic metals"
        if i.v2=9 then i.col=11
        if i.v2=9 then i.ti_no=2094
        
        if i.v2=10 then i.desig="monocrystals"
        if i.v2=10 then i.col=10
        if i.v2=10 then i.ti_no=2095
        
        if i.v2=11 then i.desig="exotic gems"
        if i.v2=11 then i.col=13
        if i.v2=11 then i.ti_no=2096
        
        if i.v2=12 then i.desig="iridium"
        if i.v2=12 then i.col=9
        if i.v2=12 then i.ti_no=2097
        
        if i.v2=13 then i.desig="lutetium"
        if i.v2=13 then i.col=3
        if i.v2=13 then i.ti_no=2098
        
        if i.v2=14 then i.desig="rhodium"
        if i.v2=14 then i.col=12
        if i.v2=14 then i.ti_no=2099
        
        if i.v1<1 then i.v1=1
        
        i.v5=1+(i.v1+rnd_range(1,player.science(0)+i.v2))*(rnd_range(1,5+player.science(0)))
        if i.v5<1 then i.v5=1
        i.price=i.v5/10   
        i.res=i.v5*10         
        
        i.scanmod=rnd_range(1,i.v1)/10
        i.desigp=i.desig
        i.icon="*"
        i.bgcol=0  
        roll=rnd_range(1,100+tVersion.gameturn/10000+mod1+mod2)
        if roll>125 and mod1>0 and mod2>0 then i=make_item(99,0,0)
        if make_files=1 then
            f=freefile
            open "artrolls.txt" for append as #f
            print #f,mod1;" ";mod2;" ";roll
            close #f
        endif
            
    endif
    
    if a=87 then
        i.res=120
        i.id=87
        i.ty=25
        i.desig="cloaking device"
        i.desigp="cloaking devices"
        i.v1=5
        i.price=100000
        i.ti_no=2100
    endif
    
    if a=123 then
        i.ti_no=2102
        i.id=523
        i.ty=103
        i.desig="Squidsuit"
        i.desigp="Squidsuits"
        i.ldesc="A limegreen suit, made for creatures with no arms and 9 tentacles. Whenever the wearer is hit that area of the cloth changes corresponding to the nature of the attack."
        i.icon="&"
        i.col=11
        i.v1=8
        i.v3=200
        i.res=120
        i.price=250
    endif
    
    if a=97 then
        i.ti_no=2101
        i.id=97
        i.ty=2
        i.desig="disintegrator"
        i.desigp="disintegrators"
        i.ldesc="A tiny handgun, emitting a pale green ray, that turns everything it touches into thin air."
        i.icon="-"
        i.col=13
        i.bgcol=0
        i.v1=3
        i.v2=6
        i.v3=2
        i.res=120
        i.price=22000
        
    endif
    
    if a=98 then   
        i.ti_no=2102              
        i.id=98
        i.ty=3
        i.desig="adaptive bodyarmor"
        i.desigp="sets of adaptive bodyarmor"
        i.ldesc="A thin limegreen suit with a foldable helmet. Whenever the wearer is hit that area of the cloth changes corresponding to the nature of the attack." 
        i.icon="&"
        i.col=10
        i.bgcol=0
        i.v1=15
        i.v3=250
        i.res=120
        i.price=19000
    endif  
    
    
    if a=99 then
        i.ti_no=2103
        i.id=99
        i.ty=99
        i.icon="*"
        i.col=-1
        i.bgcol=-15
        if mod1>0 then 
            i.v5=mod1
        else
            i=rnd_item(RI_Artefact)
        endif
        i.res=100
    endif
    
    if a=201 then 'Alien civ gun
        i=civ(0).item(0)
        i.ti_no=2104
    endif
    
    if a=202 then 'Alien civ ccweapon
        i=civ(0).item(1)
        i.ti_no=2105
    endif
    
    if a=203 then 'Alien civ gun
        i=civ(1).item(0)
        i.ti_no=2106
    endif
    
    if a=204 then 'Alien civ ccweapon
        i=civ(1).item(1)
        i.ti_no=2107
    endif
    
    if a=205 then
        i.ti_no=2108
        i.id=2005
        i.ty=23
        i.desigp="pieces of alien art"
        i.col=14
        i.icon="?"
        i.v1=10
        i.v2=rnd_range(1,6)+rnd_range(1,6)
        i.v3=mod1
        i.desig=add_a_or_an(civ(mod1).n,0) & "artifact"
        i.price=i.v1*i.v2*20
        i.res=100
    endif
    
    if a=250 then
        i.ti_no=2121
        i.id=250
        i.ty=80
        i.desig="tribble"
        i.desigp="tribbles"
        i.ldesc="A most curious creature, its trilling seems to have a tranquilizing effect on the human nervous system." 
        i.v1=1
        i.price=5
        i.res=10
        i.icon="*"
        i.col=7
    endif
        
    
    if a=301 then
        i.ti_no=2109
        i.id=301
        i.ty=45
        i.icon="'"
        i.col=191
        i.desig="ancient alien bomb"
        i.desigp="ancient alien bombs"
        i.v1=rnd_range(0,3)+rnd_range(1,3)+rnd_range(1,3)
        i.price=2000
        i.res=120
    endif
    
    if a=302 then
        i.ti_no=2110
        i.id=302
        i.ty=46
        i.icon="'"
        i.col=11
        i.desig="handheld cloaking device"
        i.desigp="handheld cloaking device"
        i.v1=7
        i.res=120
        i.price=2000
    endif
    
    if a=1002 then
        i.ti_no=2113
        i.id=4002
        i.ty=57
        i.icon="?"
        i.col=15
        i.desig="Autograph of "&questguy(mod1).n
        i.desigp="Autographs"
        i.v1=mod1
    endif
    
    if a=1003 then
        i.ti_no=2113
        i.id=4003
        i.ty=58
        i.icon="?"
        i.col=15
        i.desig="Message for "&questguy(mod2).n
        i.desigp="Messages"
        i.v1=mod1
        i.v2=mod2
    endif
    
    
    if a=1004 then
        i.ti_no=2113
        i.id=4004
        i.ty=59
        i.icon="?"
        i.col=15
        i.desig="Toolkit"
        i.desigp="Tools"
        i.price=mod1*75
        i.v1=mod1
    endif
    
    if a=1005 then
        i.ti_no=2113
        i.id=4005
        i.ty=60
        i.icon="?"
        i.col=15
        i.desig="Sample of drug "&chr(64+mod1)
        i.desigp="Drugsamples"
        i.price=mod1*100
        i.v1=mod1
    endif
    
    if a=1006 then
        i.ti_no=2113
        i.id=4006
        i.ty=61
        i.icon="?"
        i.col=11
        i.desig="Report"
        i.desigp="Reports"
        if mod2=2 then i.desig="Secret "&lcase(i.desig)
        if mod2=3 then i.desig="Top secret "&lcase(i.desig)
        if mod1<1 or mod1>4 then mod1=rnd_range(1,4)
        i.v1=mod1
        i.v2=mod2
        i.desig=i.desig &" ("&companynameshort(mod1)&")"
        i.ldesc=add_a_or_an(lcase(i.desig),1) & " on "&companyname(mod1)
    endif
        
    if a=1007 then
        i.ti_no=2113
        i.id=4007
        i.ty=62
        i.icon="?"
        i.col=11
        i.desig=mod2 &" Cr. for "&questguy(mod1).n
        i.desigp="Receipts"
        i.v1=mod1
        i.v2=mod2
    endif
    
    if a=1008 then
        i.ti_no=2113
        i.id=4008
        i.ty=63
        i.icon="?"
        i.col=15
        if mod1>0 then
            i.desig="Show concept for "&questguy(mod1).n
        else
            i.desig="generic show concept"
        endif
        i.desigp="Show concepts"
        i.v1=mod1
        i.v2=mod2
        i.price=75*mod2
        if mod1=0 then i.price=i.price/2
    endif
    
    if a=1009 then
        i.ti_no=2113
        i.id=4009
        i.ty=64
        i.icon="?"
        i.col=15
        i.desig="PW for station "&mod1+1 &" sensors"
        i.desigp="PWs for station sensors"
        i.v1=mod1
    endif
    
    if a=1010 then
        i.ti_no=2113
        i.id=4010
        i.ty=65
        i.icon="?"
        i.col=15
        i.desig="Research paper by "&questguy(mod1).n
        i.desigp="Research papers"
        i.v1=mod1
        i.price=rnd_range(1,6)*20
    endif
        
        
    if a=1011 then
        i.ti_no=2113
        i.id=4011
        i.ty=66
        i.icon="?"
        i.col=15
        i.desig="Jury rig plans"
        i.desigp="Jury rig plans"
        i.price=rnd_range(1,6)*15
    endif
        
    
    if a=1012 then
        i.ti_no=2113
        i.id=4012
        i.ty=67
        i.icon="?"
        i.col=15
        i.desig="Affidavit for "&questguy(mod1).n
        i.desigp="Affidavits"
        i.v1=mod1
        i.price=0
    endif
    
    i.discovered=show_items
    
    if i.ty=2 then
        i.price=i.v1*250+(i.v1-0.1)*250
        if i.v2>0 then i.price=i.price*(10+(i.v2/2))/10
        if i.v3>0 then i.price=i.price*(10+i.v3)/10
    endif
    if i.ty=4 then
        i.price=i.v1*100+(i.v1-0.1)*100
        if i.v3>0 then i.price=i.price*(i.v3/20)
    endif
    
    'if i.desig="" or i.desigp="" then rlprint "ERROR: Item #" &a &" does not exist.",14,14
    if a=320 then return i 'Never modify standard spacesuits
    i=modify_item(i,nomod)
    return i
    
end function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tMakeitem -=-=-=-=-=-=-=-
	tModule.register("tMakeitem",@tMakeitem.init()) ',@tMakeitem.load(),@tMakeitem.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tMakeitem -=-=-=-=-=-=-=-
#endif'test
