'tFuel.
'
'defines:
'rg_icechunk=0, gasgiant_fueling=2
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
'     -=-=-=-=-=-=-=- TEST: tFuel -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tFuel -=-=-=-=-=-=-=-

declare function gasgiant_fueling(p As Short, orbit As Short, sys As Short) As Short

'declare function rg_icechunk() As Short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tFuel -=-=-=-=-=-=-=-

namespace tFuel
function init(iAction as integer) as integer
	return 0
end function
end namespace'tFuel


#define cut2top



function rg_icechunk() As Short
    DimDebug(0)
    Dim As Short x,y,b
    Dim gc As _cords
    If rnd_range(1,100)>5+player.sensors Then Return 0
    rlprint "Your sensors seem to pick up something"
    If rnd_range(1,100)>5+player.sensors Then
        rlprint "But it is gone again quickly."
        Return 0
    EndIf
    lastplanet+=1
    makemossworld(lastplanet,4)
    For x=0 To 60
        For y=0 To 20
            If Abs(planetmap(x,y,lastplanet))=1 Then planetmap(x,y,lastplanet)=-4
            If Abs(planetmap(x,y,lastplanet))=2 Then planetmap(x,y,lastplanet)=-158
            If Abs(planetmap(x,y,lastplanet))=102 Then planetmap(x,y,lastplanet)=-4
            If Abs(planetmap(x,y,lastplanet))=103 Then planetmap(x,y,lastplanet)=-7
            If Abs(planetmap(x,y,lastplanet))=104 Then planetmap(x,y,lastplanet)=-193
            If Abs(planetmap(x,y,lastplanet))=105 Then planetmap(x,y,lastplanet)=-145
            If Abs(planetmap(x,y,lastplanet))=106 Then planetmap(x,y,lastplanet)=-145
            If Abs(planetmap(x,y,lastplanet))=146 Then planetmap(x,y,lastplanet)=-145
            If rnd_range(1,6)+player.science(0)>9 Then planetmap(x,y,lastplanet)=Abs(planetmap(x,y,lastplanet))
        Next
    Next
    planets(lastplanet).grav=.3
    planets(lastplanet).temp=-120
    planets(lastplanet).atmos=1
    planets(lastplanet).death=5+rnd_range(3,6)
    planets(lastplanet).flags(27)=2
    planets(lastplanet).flags(29)=1 'Planet Flag for Ice Chunk
    If rnd_range(1,100)<10 Then
        planets(lastplanet).mon_template(0)=makemonster(rnd_range(62,64),0,0)
        planets(lastplanet).mon_noamin(0)=1
        planets(lastplanet).mon_noamax(0)=3

    EndIf
    For b=0 To 10+rnd_range(0,6)+disnbase(player.c)\4
        gc=rnd_point(lastplanet,1)
        placeitem(make_item(96,planets(lastplanet).depth+disnbase(player.c)\5,planets(lastplanet).depth+disnbase(player.c)\6),gc.x,gc.y,lastplanet)
    Next b
    display_planetmap(lastplanet,30,1)
    rlprint "Your sensors pick up a huge chunk of ice in the atmosphere, quickly tumbling down into the denser areas of the gas giant. It is big enough to land on."
    If askyn("Do you want to try to land on it?(y/n)") Then
        landing(lastplanet)
        lastplanet-=1
    Else
        rlprint "You climb back up into free space while the icechunk disintegrates"
    EndIf
    Return 0
End function


function gasgiant_fueling(p As Short, orbit As Short, sys As Short) As Short
    Dim As Short fuel,roll,noa,a,mo,m,probe,probeflag,hydrogenscoop,freebay
    Dim en As _fleet    
    Static restfuel As Byte
    
    Dim As String mon(6)    
    mon(1)="a giant wormlike creature. It's biochemistry is based on liquid hydrogen. The heat of our engines is attracting it."
    mon(2)="an enormous blob of living plasma!"
    mon(3)="a gigantic creature resembling a jellyfish!"
    mon(4)="a flock of large tube shaped creatures with wide maws and sharp teeth!"
    mon(5)="a huge balloon floating in the wind with five, thin, several kilometers long tentacles!"
    mon(6)="a circular flat being floating among the clouds. Three bulges on the top are glowing with static electricity."

    If p=-20003 Then mo=2
    m=isgasgiant(p)
    If isgasgiant(p)>1 Then
        If planetmap(0,0,m)<>0 Then make_special_planet(m)
        If askyn("As you dive into the upper atmosphere of the gas giant your sensor pick up a huge metal structure. It is a platform, big enough to land half a fleet on it, connected to struts that extend out into the atmosphere. Do you want to try to land on it? (y/n)") Then
            landing(map(sys).planets(orbit))
            Return 0
        Else
            p=-20001

        EndIf
    EndIf
    hydrogenscoop=1
    For a=1 To player.h_maxweaponslot
        If player.weapons(a).made=85 Then hydrogenscoop+=1
        If player.weapons(a).made=86 Then hydrogenscoop+=2
    Next
    If askyn("Do you want to refuel in the gas giants atmosphere?(y/n)") Then
        probe=findbest(56,-1)
        If probe>0 Then
            If Not(askyn("Do you want to use your gas mining probe?(y/n)")) Then probe=0
        EndIf
        If probe<=0 Then
            If configflag(con_warnings)=0 And player.hull=1 Then
                If Not(askyn("Pilot: 'If i make a mistake we are doomed. Do you really want to try it? (Y/N)")) Then Return 0
            EndIf
            If not(skill_test(player.pilot(location)+add_talent(2,9,1),st_average+mo,"Pilot")) Then
                rlprint "Your Pilot damaged the ship diving into the dense atmosphere",12
                player.hull=player.hull-rnd_range(1,2)
                If p=-20003 Then player.hull=player.hull-1
                display_ship
            EndIf
            If player.hull>0 Then
                DbgPrint(""& hydrogenscoop)
                fuel=10+rnd_range(2,7)*hydrogenscoop+add_talent(2,9,3)
                hydrogenscoop-=1
                If hydrogenscoop<=0 Then hydrogenscoop=1
                If p=-20001 Then fuel=fuel+rnd_range(3,11)*hydrogenscoop
                hydrogenscoop-=1
                If hydrogenscoop<=0 Then hydrogenscoop=0
                If p=-20003 Then fuel=fuel+rnd_range(5,15)*hydrogenscoop

                display_ship
            Else
                player.dead=22
            EndIf
            If map(sys).spec=10 Then rg_icechunk()

            If rnd_range(1,100)<19-orbit*2 And player.dead=0 Then
                roll=rnd_range(1,6)
                rlprint "While taking up fuel your ship gets attacked by "&mon(roll),14
                no_key=keyin
                noa=1
                If roll=4 Then noa=rnd_range(1,6) +rnd_range(1,6)
                If roll=5 Then noa=rnd_range(1,3)
                If roll=6 Then noa=rnd_range(1,2)
                For a=1 To noa
                    en.ty=9
                    en.mem(a)=make_ship(23+roll)
                Next
                spacecombat(en,21)

                If player.dead>0 Then
                    player.dead=23
                Else
                    If player.dead=0 Then
                        rlprint "We got very interesting sensor data during this encounter.",10
                        reward(1)=reward(1)+(roll*3+rnd_range(10,80))*rnd_range(1,maximum(player.science(0),player.sensors))
                        player.alienkills=player.alienkills+1
                    Else
                        player.dead=0
                    EndIf
                EndIf
            EndIf
        Else
            'using probe
            If Not(skill_test(player.pilot(0)+add_talent(2,9,1)-3+item(probe).v2,st_average+mo,"Pilot")) Then item(probe).v1-=1
            If rnd_range(1,100)<38-orbit*2 Then item(probe).v1-=1
            If item(probe).v1<=0 Then
                rlprint "We lost contact with the probe.",c_yel
                destroyitem(probe)
            Else
                fuel=25+rnd_range(3,9)+add_talent(2,9,3)
                If p=-20001 Then fuel=fuel+rnd_range(3,9)
                If p=-20003 Then fuel=fuel+rnd_range(5,15)
                If fuel>item(probe).v3 Then fuel=item(probe).v3
                'if player.fuel>player.fuelmax+player.fuelpod then player.fuel=player.fuelmax+player.fuelpod
            EndIf
        EndIf

    EndIf
    If fuel>0 Then
        rlprint "you take up "&fuel & " tons of fuel.",10
        player.fuel=player.fuel+fuel
        freebay=getnextfreebay
        If player.fuel>player.fuelmax+player.fuelpod And freebay>0 Then
            If askyn("Do you want to store the excess fuel in a cargobay?(y/n)") Then
                Do
                    player.cargo(freebay).x=10
                    player.cargo(freebay).y=1
                    player.fuel-=30
                    freebay=getnextfreebay
                Loop Until player.fuel<=player.fuelmax+player.fuelpod Or freebay=-1
            EndIf
        EndIf
        If player.fuel>player.fuelmax+player.fuelpod Then player.fuel=player.fuelmax+player.fuelpod
    EndIf


    Return 0
End function





'type _fuel
'    declare function changeprice() as short
'    declare function adddemand(volume as short) as short
'    declare function addsupply(volume as short) as short
'    declare function init(ty as byte) as short
'    tanksize as short
'    content as short
'    demand as short
'    supply as short
'    price as single
'end type
'
'function _fuel.changeprice() as short
'    if demand>supply then price+=.1
'    if demand<supply then price-=.1
'    return 0
'end function
'
'function _fuel.init(ty as byte) as short
'
'    if ty=1 then
'        price=1.5
'        tanksize=500
'    endif
'    if ty=2 then
'        price=1
'        tanksize=2500
'    endif
'    content=tanksize/2
'    return 0
'end function
'
'function _fuel.addsupply(volume as short) as short
'    dim rest as short
'    content+=volume
'    if content>tanksize then
'        rest=content-tanksize
'    else
'        rest=0
'    endif
'    supply+=volume-rest
'    return rest
'end function
'
'function _fuel.adddemand(volume as short) as short
'    dim rest as short
'    content-=volume
'    if content<0 then
'        rest=volume-content
'        content=0
'    endif
'    demand+=volume-rest
'    return rest
'end function
'
'dim shared fuel(48) as _fuel
'dim shared lastfuel as byte
#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tFuel -=-=-=-=-=-=-=-
	tModule.register("tFuel",@tFuel.init()) ',@tFuel.load(),@tFuel.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tFuel -=-=-=-=-=-=-=-
#endif'test
