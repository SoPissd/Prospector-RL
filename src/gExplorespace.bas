'tExplorespace.
'
'defines:
'wormhole_navigation=0, wormhole_ani=0, wormhole_travel=0, move_ship=0,
', target_landing=0, asteroid_mining=0, scanning=1, spacestation=11,
', dock_drifting_ship=0, rescue=0, explore_space=1
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
'     -=-=-=-=-=-=-=- TEST: tExplorespace -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tExplorespace -=-=-=-=-=-=-=-

declare function scanning() As Short
declare function spacestation(st As Short) As _ship
declare function explore_space() As Short

declare function display_system(in as short,forcebar as byte=0,hi as byte=0) as short
declare function getplanet(sys as short,forcebar as byte=0) as short

'declare function wormhole_navigation() As Short
'declare function wormhole_ani(target As _cords) As Short
'declare function wormhole_travel() As Short
'declare function move_ship(Key As String) As _ship
'declare function target_landing(mapslot As Short,Test As Short=0) As Short
'declare function asteroid_mining(slot As Short) As Short
'declare function dock_drifting_ship(a As Short)  As Short
'declare function rescue() As Short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tExplorespace -=-=-=-=-=-=-=-

namespace tExplorespace
function init(iAction as integer) as integer
	return 0
end function
end namespace'tExplorespace


#define cut2top


function wormhole_navigation() As Short
    Dim As Short c,d,pl,b,i,wi(wormhole)
    Dim As _cords wp(wormhole)
    Dim As String Key
    For c=laststar+1 To laststar+wormhole
        map(c).discovered=1
        i+=1
        wp(i)=map(c).c
        wi(i)=c
    Next
    pl=1
    sort_by_distance(player.c,wp(),wi(),wormhole)
    Do
        player.osx=map(wi(pl)).c.x-_mwx/2
        player.osy=map(wi(pl)).c.y-10
        If player.osx<=0 Then player.osx=0
        If player.osy<=0 Then player.osy=0
        If player.osx>=sm_x-_mwx Then player.osx=sm_x-_mwx
        If player.osy>=sm_y-20 Then player.osy=sm_y-20
        display_stars(2)
        display_star(wi(pl),1)
        display_ship


        set__color( 0,11)

        If player.c.x-player.osx>=0 And player.c.x-player.osx<=_mwx And player.c.y-player.osy>=0 And .y-player.osy<=20 Then
            If configflag(con_tiles)=0 Then
                Put ((player.c.x-player.osx)*_fw1,( player.c.y-player.osy)*_fh1),stiles(player.di,player.ti_no),trans
            Else
                set__color( _shipcolor,0)
                draw_string((player.c.x-player.osx)*_fw1,( player.c.y-player.osy)*_fh1,"@",font1,_col)
            EndIf
        EndIf
        d=Int(distance(player.c,map(wi(pl)).c))
        rlprint "Wormhole at "&map(wi(pl)).c.x &":"& map(wi(pl)).c.y &". Distance "&d &" Parsec."
        Key=keyin
        If uConsole.keyplus(Key) Then pl=pl+1
        If uConsole.keyminus(Key) Then pl=pl-1
        If pl<1 Then pl=wormhole
        If pl>wormhole Then pl=1
        set__color( 11,0)
        Cls
    Loop Until Key=key__enter Or Key=key_la Or Key=key__esc

    If Key=key__esc Then
        b=-1
    Else
        b=wi(pl)
    EndIf
    Return b
End function


function wormhole_ani(target As _cords) As Short
    Dim p(sm_x*sm_y) As _cords
    Dim As Short last,a,c
    last=Line_in_points(target,player.c,p())
    For a=1 To last-1
        player.osx=p(a).x-_mwx/2
        player.osy=p(a).y-10
        If player.osx<=0 Then player.osx=0
        If player.osy<=0 Then player.osy=0
        If player.osx>=sm_x-_mwx Then player.osx=sm_x-_mwx
        If player.osy>=sm_y-20 Then player.osy=sm_y-20
        tScreen.set(0)
        Cls
        player.di+=1
        If player.di=5 Then player.di=6
        If player.di>9 Then player.di=1
        display_stars(2)
        display_ship
        rlprint ""
        If configflag(con_tiles)=0 Then
            Put ((p(a).x-player.osx)*_fw1,( p(a).y-player.osy)*_fh1),stiles(player.di,player.ti_no),trans
        Else
            set__color( _shipcolor,0)
            draw_string((p(a).x-player.osx)*_fw1,( p(a).y-player.osy)*_fh1,"@",font1,_col)
        EndIf
        tScreen.update()
        Sleep 50
'        set__color( rnd_range(180,214),rnd_range(170,204))
'        if p(a).x-player.osx>=0 and p(a).x-player.osx<=_mwx and p(a).y-player.osy>=0 and p(a).y-player.osy<=20 then
'            if configflag(con_tiles)=0 then
'                put ((p(a).x-player.osx)*_fw1,(p(a).y-player.osy)*_fh1),stiles(player.di,player.ti_no),trans
'            else
'                draw_string((p(a).x-player.osx)*_fw1,(p(a).y-player.osy)*_fh1,"@",font1,_col)
'            endif
'            player.di+=1
'            if player.di=5 then player.di=6
'            if player.di>9 then player.di=1
'            sleep 50
'            for c=0 to laststar+wormhole
'                if map(c).discovered>0 then display_star(c,0)
'            next
'        else
'            cls
'            display_ship(1)
'            show_stars(1)
'            rlprint ""
'        endif
    Next
    player.c=target
    Return 0
End function


function wormhole_travel() As Short
    Dim As Short pl,a,near,b,natural
    Dim As Single d
    d=9999
    natural=1
    For a=laststar+1 To laststar+wormhole
        If player.c.x=map(a).c.x And player.c.y=map(a).c.y Then
            pl=a
        Else
            If distance(map(map(a).planets(1)).c,player.c)<d Then
                near=a
                d=distance(map(map(a).planets(1)).c,player.c)
            EndIf
        EndIf
    Next

    If pl=0 And artflag(25)>0 Then
        pl=near
        natural=0 'No anodata for self made WHs
    EndIf

    If pl>1 And configflag(con_warnings)=0 Then
        If askyn("Travelling through wormholes can be dangerous. Do you really want to?(y/n)")=0 Then pl=0
    EndIf
    If pl>1 And rnd_range(1,100)<whtravelled Then
        rlprint "There is a planet orbiting the wormhole!"
        If askyn("Shall we try to land on it? (y/n)") Then
            If whplanet=0 Then makewhplanet
            pl=0
            landing(whplanet)
        EndIf
        whtravelled=101
    EndIf
    If pl>1 Then
        player.towed=0
        If map(pl).planets(2)=0 And whtravelled<101 Then whtravelled+=3
        map(pl).planets(2)=1
        If artflag(16)=0 Then
            b=map(pl).planets(1)
        Else
            rlprint "Wormhole navigation system engaged!(+/- to choose wormhole, "&key_la &" to select)",10
            b=wormhole_navigation
        EndIf
        If b>0 Then
        If map(b).planets(2)=0 Then
            ano_money+=CInt(distance(map(b).c,player.c)*5)*natural
        EndIf
            map(b).planets(2)=1
            rlprint "you travel through the wormhole.",10
			play_sound(5)
            If rnd_range(1,100)<distance(map(b).c,player.c)+maximum(Abs(spacemap(player.c.x,player.c.y)),5) Then
                add_ano(map(b).c,player.c)
            EndIf
            player.osx=player.c.x-_mwx/2
            player.osy=player.c.y-10
            If player.osx<=0 Then player.osx=0
            If player.osy<=0 Then player.osy=0
            If player.osx>=sm_x-_mwx Then player.osx=sm_x-_mwx
            If player.osy>=sm_y-20 Then player.osy=sm_y-20
            d=0
            If Not(skill_test(player.pilot(0),st_easy+Int(distance(player.c,map(b).c)/8),"Pilot")) And artflag(13)=0 Then d=rnd_range(1,distance(player.c,map(b).c)/5+1)
            player.hull=player.hull-d
            If d>0 Then rlprint "Your ship is damaged ("&d &").",12
            wormhole_ani(map(b).c)
            display_ship(1)
            display_stars(1)
            rlprint ""
            If player.hull<=0 Then player.dead=24
        EndIf
    EndIf
    Return 0
End function


function move_ship(Key As String) As _ship
    Dim As Short a,dam,hydrogenscoop
    Dim scoop As Single
    Static fuelcollect As Byte
    Dim As _cords old,p
    Dim As _weap delweap
    hydrogenscoop=0
    For a=1 To player.h_maxweaponslot
        If player.weapons(a).made=85 Then hydrogenscoop+=1
        If player.weapons(a).made=86 Then hydrogenscoop+=2
    Next
    If walking=0 Then
        a=uConsole.getdirection(Key)
    Else
        If walking<10 Then a=walking
    EndIf
    If walking=10 Then
        currapwp+=1
        a=nearest(apwaypoints(currapwp),player.c)
        If currapwp=lastapwp Then
            rlprint "Target reached"
            walking=0
        EndIf

    EndIf
    If a<>0 Then player.di=a
    old=player.c
    player.c=movepoint(player.c,a,,1)
    If player.c.x<0 Then player.c.x=0
    If player.c.y<0 Then player.c.y=0
    If player.c.x>sm_x Then player.c.x=sm_x
    If player.c.y>sm_y Then player.c.y=sm_y
    If player.c.x<>old.x Or player.c.y<>old.y Then
        If player.towed<>0 Then
            player.fuel-=1
            If Not(skill_test(player.pilot(0),st_average,"Pilot")) Then player.fuel-=1
        EndIf
        If spacemap(player.c.x,player.c.y)=-2 Then spacemap(player.c.x,player.c.y)=2
        If spacemap(player.c.x,player.c.y)=-3 Then spacemap(player.c.x,player.c.y)=3
        If spacemap(player.c.x,player.c.y)=-4 Then spacemap(player.c.x,player.c.y)=4
        If spacemap(player.c.x,player.c.y)=-5 Then spacemap(player.c.x,player.c.y)=5
        If spacemap(player.c.x,player.c.y)=-6 Then spacemap(player.c.x,player.c.y)=6
        If spacemap(player.c.x,player.c.y)=-7 Then spacemap(player.c.x,player.c.y)=7
        If spacemap(player.c.x,player.c.y)=-8 Then spacemap(player.c.x,player.c.y)=8
        If (spacemap(old.x,old.y)<2 Or spacemap(old.x,old.y)>5) And spacemap(player.c.x,player.c.y)>=2 And spacemap(player.c.x,player.c.y)<=5 And configflag(con_warnings)=0 Then
            If Not(askyn("Do you really want to enter the gascloud?(y/n)")) Then player.c=old
        EndIf
        If spacemap(player.c.x,player.c.y)>=2 And spacemap(player.c.x,player.c.y)<=5 Then
            player.towed=0
            If skill_test(player.pilot(0),st_easy+spacemap(player.c.x,player.c.y),"Pilot:") Then
                rlprint "You succesfully navigate the gascloud",10
                rlprint gainxp(2),c_gre
                If hydrogenscoop=0 Then player.fuel=player.fuel-rnd_range(1,3)
                fuelcollect+=spacemap(player.c.x,player.c.y)*hydrogenscoop
                If fuelcollect>5 Then
                    player.fuel+=fuelcollect/5
                    If player.fuel>player.fuelmax Then player.fuel=player.fuelmax
                    fuelcollect=0
                EndIf
            Else
                dam=rnd_range(1,spacemap(player.c.x,player.c.y))
                If dam>player.shieldside(rnd_range(0,7)) Then
                    dam=dam-player.shieldside(rnd_range(0,7))
                    rlprint "Your Ship is damaged ("&dam &").",12
                    player.hull=player.hull-dam
                    player.fuel=player.fuel-rnd_range(1,5)
                    If player.hull<=0 Then player.dead=12
                EndIf
            EndIf
        EndIf
        If spacemap(player.c.x,player.c.y)>=6 And spacemap(player.c.x,player.c.y)<=20 Then
            Select Case spacemap(player.c.x,player.c.y)
            Case Is=16
                rlprint "This anomaly shortens space."
            Case Is=17
                rlprint "This anomaly lengthens space."
            Case Is=18
                rlprint "This anomaly shortnes space, and can damage a ship."
            Case Is=19
                rlprint "This anomaly lengthens space, and can damage a ship."
            Case Is=20
                rlprint "This anomaly can damage a ship and is highly unpredictable."
            End Select
            If (spacemap(player.c.x,player.c.y)>=8 And spacemap(player.c.x,player.c.y)<=10) Or (spacemap(player.c.x,player.c.y)>=18 And spacemap(player.c.x,player.c.y)<=20) Then
                If rnd_range(1,100)<15 Then
                    dam=rnd_range(0,3)
                    If dam>player.shieldside(rnd_range(0,7)) Then
                        dam=1
                        rlprint "Your Ship is damaged ("&dam &").",12
                        player.hull=player.hull-dam
                        player.fuel=player.fuel-rnd_range(1,5)
                        If player.hull<=0 Then player.dead=30
                    Else
                        If player.shieldmax>0 Then rlprint "Your shields are hit, but hold",10
                    EndIf
                EndIf
            EndIf
            If spacemap(player.c.x,player.c.y)=8 Or spacemap(player.c.x,player.c.y)=6 Or spacemap(player.c.x,player.c.y)=18 Or spacemap(player.c.x,player.c.y)=16 Then
                player.e.tick
                player.fuel+=.5
            EndIf
            If spacemap(player.c.x,player.c.y)=9 Or spacemap(player.c.x,player.c.y)=7 Or spacemap(player.c.x,player.c.y)=19 Or spacemap(player.c.x,player.c.y)=17 Then
                player.e.add_action(10)
                player.fuel-=.5
            EndIf
            If spacemap(player.c.x,player.c.y)=10 Or spacemap(player.c.x,player.c.y)=20 Or (spacemap(player.c.x,player.c.y)>=6 And rnd_range(1,100)<5) Then
                If rnd_range(1,100)<66 Then
                    Select Case rnd_range(0,100)
                    Case Is=1
                        rlprint "Something strange is happening with your fuel tank reading"
                        player.fuel+=rnd_range(1,6)
                    Case Is=2
                        rlprint "You get swept away in a gravitational current"
                        player.c=old
                    Case Is=3
                        rlprint "You get swept away in a gravitational current"
                        player.c=movepoint(player.c,player.di,,1)
                    Case Is=4
                        rlprint "You get swept away in a gravitational current"
                        player.c=movepoint(player.c,5,,1)
                    Case Is=5
                        rlprint "Something strange is happening with the ships chronometer"
                        tVersion.gameturn=tVersion.gameturn+rnd_range(1,6)-rnd_range(1,8)
                    Case Is=6
                        rlprint "Your sensors are damaged."
                        player.sensors-=1
                    Case Is=7
                        If player.shieldmax>0 Then
                            rlprint "Your shieldgenerator is damaged."
                            player.shieldmax-=1
                        EndIf
                    Case Is=8
                        rlprint "Time itself seems to speed up"
                        player.e.add_action(player.engine+20-player.engine*2)
                    Case Is=9
                        rlprint "You have trouble keeping your position"
                        player.di=rnd_range(1,8)
                        If player.di=5 Then player.di=9
                    Case Is=10
                        rlprint "Something catapults you out of the anomaly!"
                        p=player.c
                        For a=0 To rnd_range(1,6)
                            p=movepoint(p,player.di,,1)
                        Next
                        wormhole_ani(p)
                    Case Is=11
                        If rnd_range(1,100)<10+spacemap(player.c.x,player.c.y) Then
                            player.c=map(rnd_range(laststar+1,laststar+wormhole)).c
                            dam=rnd_range(1,6)
                            If dam>player.shieldmax Then
                                dam=1
                                rlprint "your Ship is damaged ("&dam &").",12
                                player.hull=player.hull-dam
                                player.fuel=player.fuel-rnd_range(1,5)
                                If player.hull<=0 Then player.dead=30
                            EndIf
                        Else
                            rlprint "A wormhole forms straight ahead, but you manage to avoid it. It disappears again instantly."
                        EndIf
                    Case Is=12
                        rlprint "There should be a *lot* less fuel in your fueltank"
                        player.fuel+=rnd_range(50,100)
                    Case Is=13
                        rlprint "This strange area of space alters your ships structure"
                        player.h_maxhull-=1
                    Case Is=14
                        rlprint "This strange area of space alters your ships structure"
                        player.h_maxhull+=1
                    Case Is=15
                        rlprint "Your cargo hold is damaged!"
                        player.cargo(rnd_range(1,player.h_maxcargo)).x=1
                    Case Is =16
                        rlprint "Your fuel tank is damaged!"
                        player.h_maxfuel-=1
                        If rnd_range(1,100)<10 Then
                            rlprint "The damage results in an explosion!"
                            player.hull-=rnd_Range(1,3)
                        EndIf
                    End Select

                EndIf
            EndIf
        EndIf
        If player.towed>0 Then
            drifting(player.towed).x=player.c.x
            drifting(player.towed).y=player.c.y
        EndIf
    EndIf
    If (player.c.x<>old.x Or player.c.y<>old.y) Then' and (player.c.x+player.osx<>30 or player.c.y+player.osy<>10) then
        player.add_move_cost(0)
        
        If spacemap(player.c.x,player.c.y)<=5 Then player.fuel=player.fuel-player.fueluse
        If player.tractor>0 And player.towed>0 Then
            If skill_test(player.pilot(0),st_veryeasy-player.tractor+Fix(drifting(player.towed).s/4))=0 Then
                If skill_test(player.pilot(0),st_veryeasy-player.tractor+Fix(drifting(player.towed).s/4)) Then
                    rlprint "You loose connection to your towed ship."
                    player.towed=0
                Else
                rlprint "Your tractor beam breaks down.",14
                    For a=0 To 25
                        If player.weapons(a).rof<0 Then 
                            player.weapons(a)=delweap
                            Exit For
                        EndIf
                    Next
                    player.towed=0
                EndIf
            EndIf
        EndIf
        For a=0 To 12
            If patrolquest(a).status=1 Then patrolquest(a).check
        Next
        If player.cursed>0 And rnd_range(1,100)<3+player.cursed+spacemap(player.c.x,player.c.y) And tVersion.gameturn Mod(50-player.cursed)=0 Then player=com_criticalhit(player,rnd_range(1,6)+6-player.armortype)
    Else
        walking=0
    EndIf
    Return player
End function


function target_landing(mapslot As Short,Test As Short=0) As Short
    Dim As _cords p
    Dim As String Key
    Dim As Short c,osx
    set__color(11,0)
    Cls
    tScreen.set(1)

    rlprint "Choose landing site"
    p.x=30
    p.y=10
    Key=get_planet_cords(p,mapslot)
    If Key=key__enter Then
        Do
            p=movepoint(p,5)
            c+=1
            player.fuel-=1
        Loop Until c>5 Or (tiles(Abs(planetmap(p.x,p.y,mapslot))).gives=0 And tiles(Abs(planetmap(p.x,p.y,mapslot))).walktru=0 And skill_test(player.pilot(0),st_easy+c+planets(mapslot).grav+planets(mapslot).dens,"Pilot:"))
        If c<=5 Then
            landing(mapslot,p.x,p.y,c)
        Else
            rlprint "Couldn't land there, landing aborted",14
        EndIf
    EndIf
    Return 0
End function


function asteroid_mining(slot As Short) As Short
    Dim it As _items
    Dim en As _fleet
    Dim As Short f,q,m,roll
    Dim mon(6) As String
    mon(1)="a huge crystaline lifeform, vaguely resembling a spider. It jumps from asteroid to asteroid, it's diet obviously being metal ores. Looks like it has just put our ship on the menu! It is  coming this  way!"
    mon(2)="a huge lifeform made entirely of metal! It is spherical and drifts among the astroids. There are no detectable means of locomotion, except for 3 openenings at the equator. It is radiating high amounts of heat, especially at those openings. Looks like it is a living, moving fission reactor!"
    mon(3)="a dense cloud of living creatures, from microscopic to about 10cm long. They seem to be living insome kind of symbiosis, with different specimen performing different tasks."
    mon(4)="a giant wormlike creature. It's biochemistry is based on liquid hydrogen. The heat of our engines is attracting it."
    mon(5)="an enormous blob of living plasma!"
    mon(6)="a gigantic creature resembling a jellyfish!"
    en.ty=2
    m=rnd_range(1,6)
    If show_all Then rlprint ""&slot
    roll=rnd_range(1,100)
    slot=slot-rnd_range(1,10)
    player.fuel=player.fuel-1
    If not(skill_test(player.pilot(0),st_hard,"Pilot")) Then player.fuel=player.fuel-rnd_range(1,3)
    If (slot<-11 And slot>-13) Or (slot<-51 And slot>-54)  Then
        rlprint "you have discovered a dwarf planet among the asteroids!",10
        no_key=keyin
        lastplanet=lastplanet+1
        slot=lastplanet
    Else
        If skill_test(player.tractor*2+minimum(player.science(0)+1,player.sensors+1)+3*add_talent(2,9,2)+slot,st_average) Then

            Do
                it=make_item(96,f+slot+165,-2)
            Loop Until it.ty=15
            it.v5=it.v5+100
            it.v2=it.v2+100
            it.desig &=" asteroid"
            If askyn("Science officer: 'There is an asteroid containing a high ammount of "&it.desig &". shall we try to take it aboard?'(y/n)") Then
                display_ship()
                q=-1
                Do
                    If configflag(con_warnings)=0 And player.hull=1 Then
                        q=askyn("Pilot: 'If i make a mistake it could be fatal. Shall I really try?'(y/n)")
                    EndIf
                    If q=-1 Then
                        If skill_test(player.pilot(0)+player.tractor*2,st_average,"Pilot") Then
                            q=0
                            placeitem((it),0,0,0,0,-1)
                            reward(2)=reward(2)+it.v5
                            rlprint "We got it!",10
                        Else
                            player.hull=player.hull-1
                            display_ship()
                            rlprint "Your pilot hit the asteroid, damaging the ship, and changing the asteroids trajectory.",14
                            If player.hull>0 Then
                                q=askyn("try again? (y/n)")
                                If q=-1 Then
                                    rlprint "Pilot: 'starting another attempt.'"
                                    Sleep 300
                                EndIf
                            Else
                                q=0
                                player.dead=19
                                Exit function
                            EndIf
                        EndIf
                    EndIf
                    player.fuel=player.fuel-rnd_range(1,3)
                    roll=roll-1
                    If roll<7 Then q=0
                    If player.fuel<10 Then player.fuel=10
                Loop Until q=0
            Else
                slot=slot+rnd_range(1,2)
                If slot>=0 Then slot =-1
            EndIf
        Else
            rlprint "Nothing remarkable."
        EndIf
    EndIf
    If roll<4 Then
        If rnd_range(1,100)<85 Then
            rlprint "A ship has been hiding among the asteroids.",14
            If faction(0).war(1)<0 Then
                rlprint "It hails us.",10
            Else
                rlprint "It attacks!",12
                no_key=keyin
                If rnd_range(1,6)<5 Then
                    en.ty=ft_pirate
                    en.mem(1)=make_ship(3)
                Else
                    en.ty=1
                    en.mem(1)=make_ship(4)
                EndIf
                no_key=keyin
                spacecombat(en,10)
                If player.dead<0 Then player.dead=0
            EndIf
        Else
            rlprint "A ship has been hiding among the asteroids.",14
            no_key=keyin
            rlprint "Wait. that is no ship. It is  "&mon(m) &"!",14
            no_key=keyin
            en.ty=8
            en.mem(1)=make_ship(20+m)
            spacecombat(en,20)

            If player.dead>0 Then
                player.dead=20
            Else
                If player.dead=0 Then
                    rlprint "We got very interesting sensor data from that being.",10
                    reward(1)=reward(1)+rnd_range(10,180)*rnd_range(1,maximum(player.science(0),player.sensors))
                    player.alienkills=player.alienkills+1
                Else
                    player.dead=0
                EndIf
            EndIf
        EndIf
        set__color(11,0)
        Cls
        display_ship()
        display_stars(1)
    EndIf
    Return slot
End function


function scanning() As Short
    Dim mapslot As Short
    Dim As Short slot
    Dim sys As Short
    Dim scanned As Short
    Dim itemfound As Short
    Dim a As Short
    Dim b As Short
    Dim x As Short
    Dim y As Short
    Dim Key As String
    Dim As Short osx
    Dim As Single roll,target
    Dim As Short plife,mining
    
    'if getsystem(player)>0 then
    a=getplanet(get_system())
    slot=a
    update_tmap(slot)
    If a>0 Then
        sys=get_system()
        mapslot=map(sys).planets(a)
        If mapslot=specialplanet(29) And findbest(89,-1)>0 Then mapslot=specialplanet(30)
        If mapslot=specialplanet(30) And findbest(89,-1)=-1 Then mapslot=specialplanet(29)
        If mapslot=specialplanet(29) Then specialflag(30)=1
        If mapslot<0 And mapslot>-20000 Then map(sys).planets(a)=asteroid_mining(mapslot)
        If mapslot=-20001 Then rlprint "A helium-hydrogen gas giant"
        If mapslot=-20002 Then rlprint "A methane-ammonia gas giant"
        If mapslot=-20003 Then rlprint "A hot jupiter"
        If mapslot<-20000 Or isgasgiant(mapslot)>0 Then gasgiant_fueling(mapslot,a,sys)
        If mapslot>0 And isgasgiant(mapslot)=0 Then
        If planetmap(0,0,mapslot)=0 Then
            makeplanetmap(mapslot,a,map(sys).spec)
            'makefinalmap(mapslot)
        EndIf
        If planets(mapslot).mapstat=0 Then planets(mapslot).mapstat=1
        make_locallist(mapslot)
        move_rover(mapslot)

        For x=60 To 0 Step -1
            For y=0 To 20
                target=st_average+(planets(mapslot).mapped/100*player.sensors)+planets(mapslot).dens
                If Abs(planetmap(x,y,mapslot))=8 Then target=target-1
                If Abs(planetmap(x,y,mapslot))=7 Then target=target-2
                If Abs(planetmap(x,y,mapslot))=99 Then mining=1
                If skill_test(minimum(player.science(0)+1,player.sensors),target) And planetmap(x,y,mapslot)<0 Then
                    planetmap(x,y,mapslot)=planetmap(x,y,mapslot)*-1
                    tmap(x,y)=tiles(planetmap(x,y,mapslot))
                    reward(0)=reward(0)+.4+player.sensors/10
                    reward(7)=reward(7)+planets(mapslot).mapmod
                    scanned=scanned+1
                    
                EndIf
            Next
        Next
        For b=0 To lastitem
            If item(b).w.m=mapslot And item(b).w.p=0 And item(b).w.s=0 Then
                target=st_hard+planets(mapslot).dens*item(a).scanmod
                If skill_test(add_talent(4,15,1)+minimum(player.science(0),player.sensors)*item(b).scanmod,target) Then
                    item(b).discovered=1
                    itemfound+=1
                EndIf
            EndIf
        Next
        planets(mapslot).mapped=planets(mapslot).mapped+scanned
        If scanned>50 Then rlprint gainxp(4),c_gre
        set__color(11,0)
        Cls
        If mapslot=player.questflag(7) Then rlprint "This is the planet Eridiani Explorations wants us to map completely"
        If mapslot=piratebase(0) Then
            rlprint "Science Officer: 'There is a starport on this planet.'",15
        EndIf
        For a=0 To lastspecial
            If mapslot=specialplanet(a) Then
                If specialflag(a)<=1 Then
                    If specialplanettext(a,specialflag(a))<>"" Then
                        rlprint specialplanettext(a,specialflag(a)) &" Key to continue",15
                        no_key=keyin
                    EndIf
                EndIf
            EndIf
        Next
        rlprint "Scanned "&scanned &" km2"
        If itemfound>1 Then rlprint "Detected "&itemfound &" objects."
        If itemfound=1 Then rlprint "Detected an object."
        If itemfound<1 Then rlprint "Detected no objects."
        If mining=1 Then
            If planets(mapslot).flags(22)=-1 Then rlprint "A mining station on this planet sends a distress signal. They need medical help.",15
            If planets(mapslot).flags(22)>=0 Then rlprint "There is a mining station on this planet. They send greetings.",15
        EndIf
        If planets(mapslot).flags(23)>0 Then rlprint "Science Officer: 'I can detect several ships on this planet.",15
        If planets(mapslot).flags(24)>0 Then rlprint "Science Officer: 'This planet is completely covered in rain forest. What on first glance appears to be its surface is actually the top layer of a root system.",15
        If planets(mapslot).flags(25)>0 Then rlprint "Science Officer: 'The biosphere readings for this planet are off the charts. We sure will find some interesting plants here!",15
        If planets(mapslot).flags(26)>0 Then rlprint "Science Officer: A very deep ocean covers this planet. Sensor readings seem to indicate large cave structures at the bottom.",15
        If planets(mapslot).flags(27)>0 Then
            rlprint "Science Officer: 'This is a sight you get to see once in a lifetime. The orbit of this planet is unstable and it is about to plunge into its sun! Gravity is ripping open its surface, solar wind blasts its material into space. In a few hours it will be gone.'",15
            planets(mapslot).flags(27)=2
        EndIf
        If isgardenworld(mapslot) Then rlprint "This planet is earthlike."
        If planets(mapslot).colflag(0)>0 Then rlprint "There is "& add_a_or_an(companyname(planets(mapslot).colflag(0)),0) &" colony on this planet. They are sending greetings."
        DbgPrint("Map number "&slot &":"& mapslot)
        osx=30-_mwx/2

        For a=0 To planets(mapslot).life
            If skill_test(player.science(location),st_hard) Then plife=plife+((planets(mapslot).life+1)*3)/100
        Next
        If plife>1 Then plife=1
        If plife>planets(mapslot).highestlife Then
            planets(mapslot).highestlife=plife
            rlprint "Revising earlier lifeform estimate",c_yel
        EndIf
        If planets(mapslot).discovered<2 Then planets(mapslot).discovered=2
        Do
            tScreen.set(0)
            Cls
            display_planetmap(mapslot,osx,1)
            dplanet(planets(mapslot),slot,scanned,mapslot)
            rlprint ""
            tScreen.update()
            no_key=keyin(key_la & key_tala &" abcdefghijklmnopqrstuvwxyz" &key_east &key_west)
            If no_key=key_east Then osx+=1
            If no_key=key_west Then osx-=1
            If osx<0 Then osx=0
            If osx>60-_mwx Then osx=60-_mwx
            set__color(11,0)
            Cls

        Loop Until no_key<>key_east And no_key<>key_west
        If no_key=key_la Then Key=key_la
        If no_key=key_tala Then Key=key_tala
        If Not(skill_test(player.pilot(location),st_veryeasy,"Pilot:")) And player.fuel>30 Then
            rlprint "your pilot had to correct the orbit.",14
            x=rnd_range(1,4)-player.pilot(0)
            If x<1 Then x=1
            player.fuel=player.fuel-x

        EndIf
        EndIf
        If Key=key_la Then landing(map(sys).planets(slot))
        If Key=key_tala Then target_landing(map(sys).planets(slot))
    EndIf
    'show_stars(1,0)
    'displayship
    Return 0
End function


function spacestation(st As Short) As _ship
    Dim As Integer a,b,c,d,e,wchance,inspectionchance
    Static As Short hiringpool,last,muddsshop,botsshop,usedshop
    Static inv(lstcomit) As _items
    Dim quarantine As Short
    Dim i As _items
    Dim As String Key,text,mtext,sn
    Dim dum As _basis
    set__color(11,0)
    Cls
    basis(st).docked+=1
    comstr.Reset
    display_ship
    'If _debug=1111 Then questroll=14
    If tVersion.gameturn>0 Then
        If basis(st).company=3 Then
            inspectionchance=5+faction(0).war(1)+foundsomething
        Else
            inspectionchance=33+faction(0).war(1)+foundsomething
        EndIf
        If rnd_range(1,100)<inspectionchance Then
            rlprint "The station commander decides to do a routine check on your cargo hold before allowing you to disembark.",14
            no_key=keyin
            d=0
            For b=1 To 10
                c=0
                If player.cargo(b).x=9 And (basis(st).company<>1 Or basis(st).company=3) Then c=1 'Embargo
                If player.cargo(b).x=8 And (basis(st).company<>2 Or basis(st).company=3) Then c=1 'Embargo
                If player.cargo(b).x=7 And (basis(st).company<>4 Or basis(st).company=3) Then c=1 'embargo
                If player.cargo(b).x>1 And player.cargo(b).x<9 And player.cargo(b).y=0 Then c=1 'Stolen
                If c=1 And rnd_range(1,100)<30-player.equipment(se_CargoShielding)+player.cargo(b).x Then
                    d=1
                    If player.cargo(b).y>0 Then
                        rlprint "You are informed that there is an import embargo on "& LCase(goodsname(player.cargo(b).x-1)) &" and that the cargo will be confiscated.",12
                    Else
                        rlprint "Your cargo of "& LCase(goodsname(player.cargo(b).x-1)) &" gets confiscated because you lack proper documentation.",12
                    EndIf
                    player.cargo(b).x=1
                    player.cargo(b).y=0
                    faction(0).war(1)+=1
                EndIf
            Next
            If d=0 Then
                rlprint "Everything seems to be ok.",10
                foundsomething-=1
            Else
                foundsomething+=5
            EndIf
        EndIf
        check_passenger(st)
        For b=2 To 255
            If Crew(b).paymod>0 And crew(b).hpmax>0 And crew(b).hp>0 Then
                a=a+Wage*(Crew(b).paymod/10)
                crew(b).morale=crew(b).morale+(Wage-9-bunk_multi*2)+add_talent(1,4,5)

            EndIf
        Next
        rlprint "You pay your crew "&a &" Cr. in wages"
        player.money=player.money-a
        player=levelup(player,0)
        If shop_order(st)<>0 And rnd_range(1,100)<33 Then
            rlprint  "Your ordered "&make_item(shop_order(st)).desig &" has arrived.",12
            b=rnd_range(1,20)
            shopitem(b,st)=make_item(shop_order(st))
            shopitem(b,st).price=shopitem(b,st).price*2
            shop_order(st)=0
        EndIf
    EndIf
    
    ss_sighting(st)
    
    If basis(st).spy=1 Or basis(st).spy=2 Then
        If askyn("Do you pay 100 cr. for your informant? (y/n)") Then
            player.money=player.money-100
            If player.money<0 Then
                player.money=0
                rlprint "He doesn't seem very happy about you being unable to pay."
            Else
                faction(0).war(1)-=5
            EndIf
        Else
            basis(st).spy=3
            faction(0).war(1)+=15
        EndIf
    EndIf

    For a=0 To lastfleet
        If distance(fleet(a).c,basis(st).c)<2 And fleet(a).con(1)=1 And st=fleet(a).con(3) Then
            Select Case fleet(a).con(2)
            Case Is>0
                rlprint "The captain of the merchant convoy thanks you and pays you "& fleet(a).con(2) & " Cr. as promised.",c_gre
                addmoney(fleet(a).con(2),mt_escorting)
                If fleet(a).con(4)<0 Then fleet(a).con(4)=0
                fleet(a).con(4)+=1

            Case Is<0
                If askyn("with your fuel costs you actually owe the captain "&Abs(fleet(a).con(2)) &"Cr. Do you pay?(y/n)") Then
                    addmoney(fleet(a).con(2),mt_escorting)
                Else
                    rlprint "The captain isn't very pleased."
                    factionadd(0,fleet(a).ty,1)
                    fleet(a).con(4)-=1
                EndIf
            Case Is=0
                rlprint "The captain informs you that your fuelcosts have eaten up your escorting wage."
            End Select
            fleet(a).con(1)=0
            fleet(a).con(2)=0
            fleet(a).con(3)=0

        EndIf
    Next
    
    If st<>player.lastvisit.s Or tVersion.gameturn-player.lastvisit.t>600 Then
        b=count_and_make_weapons(st)

        If b<5 And rnd_range(1,100)<15 Then
            reroll_shops
            b=count_and_make_weapons(st)
        EndIf
    EndIf
    
    If st<>player.lastvisit.s Or tVersion.gameturn-player.lastvisit.t>100 Then
        rlprint gainxp(1),c_gre
        check_questcargo(st)
        
        If tCompany.companystats(basis(st).company).capital<3000 Then rlprint "The spacestation is abuzz with rumors that "&companyname(basis(st).company) &" is in financial difficulties."
        If tCompany.companystats(basis(st).company).capital<1000 Then
            rlprint companyname(basis(st).company) &" has closed their office in this station."
            dum=makecorp(-basis(st).company)
            basis(st).company=dum.company
            basis(st).repname=dum.repname
            basis(st).mapmod=dum.mapmod
            basis(st).biomod=dum.biomod
            basis(st).resmod=dum.resmod
            basis(st).pirmod=dum.pirmod
            rlprint companyname(basis(st).company) &" has taken their place."
        EndIf
        tCompany.dividend()
    EndIf
    
    girlfriends(st)
    hiringpool=rnd_range(1,4)+rnd_range(1,4)+3
    Do
        quarantine=player.disease
        mtext="Station "& st+1 &"/ "
        mtext=mtext & basis(st).repname &" Office "
        If quarantine>6 Then mtext=mtext &"(Quar.)"
        mtext=mtext &"/ Equipment "
        If quarantine>6 Then mtext=mtext &"(Quar.)"
        mtext=mtext &"/ Sickbay / Fuel(" & round_str((basis(st).inv(9).p/30)*(player.fuelmax+player.fuelpod-Fix(player.fuel)),2) & " Cr, " & (player.fuelmax+player.fuelpod-Fix(player.fuel)) & " tons ) & Ammuniton("& missing_ammo*((player.loadout+1)^2) & "Cr.) / "
        mtext=mtext &"Repair(" &credits(Int(max_hull(player)-player.hull)*(basis(st).pricelevel*100*(0.5+0.5*player.armortype))) & "Cr.) / Hire Crew / Trading "
        If quarantine>5 Then mtext=mtext &"(Quar.)"
        mtext=mtext &"/ Casino "
        If quarantine>4 Then mtext=mtext &"(Quar.)"
        mtext=mtext &"/ Retirement"
        mtext=mtext &"/Leave station"
        display_ship()
        bg_parent=bg_shiptxt
        a=textMenu(bg_shiptxt,mtext,,,,,1)
        If a=1 Then
            If quarantine<8 Then
                tCompany.company(st)
            Else
                rlprint "You are under quarantine and not allowed to enter there"
            EndIf
        EndIf
        If a=2 Then'refit
            If quarantine<9 Then
                Do
                    set__color(11,0)
                    Cls
                    sn=shopname(basis(st).shop(sh_equipment))
                    usedshop=99
                    muddsshop=99
                    botsshop=99
                    display_ship()
                    mtext="Refit/"&shipyardname(basis(st).shop(sh_shipyard))
                    mtext=mtext &"/"& moduleshopname(basis(st).shop(sh_modules)) &"/" &sn
                    If basis(st).shop(sh_used)=1 Then
                        mtext=mtext & "/Used Ships"
                        usedshop=4
                    EndIf
                    If basis(st).shop(sh_mudds)=1 Then
                        mtext=mtext & "/Mudds Incredible Bargains"
                        muddsshop=4+basis(st).shop(sh_used)
                    EndIf
                    If basis(st).shop(sh_bots)=1 Then
                        mtext=mtext & "/The Bot-bin"
                        botsshop=4+basis(st).shop(sh_mudds)+basis(st).shop(sh_used)
                    EndIf
                    mtext &= "/Exit"

                    b=textMenu(bg_shiptxt,mtext)
                    If b=1 Then shipyard(basis(st).shop(sh_shipyard))
                    If b=2 Then shipupgrades(st)
                    'if b= then towingmodules
                    If b=3 Then 'awayteam equipment
                        Do
                            c=shop(st,basis(st).pricelevel,sn)
                            display_ship
                        Loop Until c=-1
                        set__color(11,0)
                        Cls
                    EndIf
                    If basis(st).shop(sh_used)=1 And b=usedshop Then used_ships
                    If basis(st).shop(sh_mudds)=1 And b=muddsshop Then mudds_shop
                    If basis(st).shop(sh_bots)=1 And b=botsshop Then botsanddrones_shop
                Loop Until b=4+basis(st).shop(sh_mudds)+basis(st).shop(sh_bots)+basis(st).shop(sh_used) Or b=-1
            Else
                rlprint "you are under quarantine and not allowed to enter there"
            EndIf
        EndIf
        If a=3 Then
            player.disease=sick_bay(,basis(st).company)
            mtext="Station "& st+1 &"/ "
            mtext=mtext & basis(st).repname &" Office "
            If quarantine>6 Then mtext=mtext &"(Quar.)"
            mtext=mtext &"/ Equipment "
            If quarantine>6 Then mtext=mtext &"(Quar.)"
            mtext=mtext &"/ Sickbay / Fuel & Ammuniton / Repair / Hire Crew / Trading "
            If quarantine>5 Then mtext=mtext &"(Quar.)"
            mtext=mtext &"/ Casino "
            If quarantine>4 Then mtext=mtext &"(Quar.)"
            mtext=mtext &"/Exit"
        EndIf
        If a=4 Then refuel(st,round_nr(basis(st).inv(9).p/30,2))
        If a=5 Then repair_hull(basis(st).pricelevel)
        If a=6 Then hiring(st,hiringpool,4)
        If a=7 Then
            If quarantine<7 Then
                tCompany.trading(st)
            Else
                rlprint "you are under quarantine and not allowed to enter there"
            EndIf
        EndIf
        If a=8 Then
            If quarantine<5 Then
                b=casino(0,st)
            Else
                rlprint "you are under quarantine and not allowed to enter there"
            EndIf
        EndIf
        If a=9 Then tRetirement.retirement()
        If a=10 Or a=-1 Then
            text=""
            If player.pilot(0)<0 Then text=text &"You dont have a pilot. "
            If player.gunner(0)<0 Then text=text &"You dont have a gunner. "
            If player.science(0)<0 Then text=text &"You dont have a science officer. "
            If player.doctor(0)<0 Then text=text &"You dont have a ships doctor. "
            If player.fuel<player.fuelmax*0.5 Then text=text &"You only have " &player.fuel & " fuel. "
            If player.money<0 Then text=text &"You still have debts of "& player.money &" credits to pay. "
            If (text<>"" And player.dead=0) Then
                If askyn(text &"Do you want to leave anyway?(y/n)",14) Then
                    a=10
                Else
                    a=0
                EndIf
            EndIf
            If text="" And a=-1 Then
                If askyn("Do you really want to leave?(y/n)",14) Then
                    a=10
                Else
                    a=0
                EndIf
            EndIf
        EndIf
    Loop Until a=10
    set__color(11,0)
    Cls
    player.lastvisit.s=st
    player.lastvisit.t=tVersion.gameturn
    Return player
End function


function dock_drifting_ship(a As Short)  As Short
    Dim As Short m,b,c,x,y
    Dim p(1024) As _cords
    Dim land As _cords
    Dim As Short Test=0

    m=drifting(a).m
    If a<=3 And rnd_range(1,100)<10+Test And tVersion.gameturn>5 Then
        station_event(m)
    EndIf
    For x=0 To 60
        For y=0 To 20
            If Abs(planetmap(x,y,m))=203 Then
                b+=1
                p(b).x=x
                p(b).y=y
            EndIf
        Next
    Next
    c=rnd_range(1,b)
    land.x=p(c).x
    land.y=p(c).y
    land.m=m
    DbgPrint("Got through dock_drifting_ship")
    landing(m,p(c).x,p(c).y,1)
    Return 0
End function


function rescue() As Short
    Dim As Short a,c,dis,beacon,cargo,closest_fleet,dis2
    Dim As Single b,d
    Dim fname(10) As String

    gen_fname(fname())
    d=256
    If getinvbytype(9)>0 Then
        rlprint ("You ran out of fuel. You use the fuel from the cargo bay.")
        removeinvbytype(9,1)
        player.fuel+=30
        Return 0
    EndIf
    ranoutoffuel+=1
    dis2=9999
    For a=0 To lastfleet
        If fleet(a).con(1)<>0 Then
            If askyn("This is merchant fleet "&a &". Do you need fuel?(y/n)",,1) Then
                rlprint "2 Cr. per ton. We'll deduct it from the agreed upon payment."
                b=getnumber(0,player.fuelmax,0)
                player.fuel+=b
                fleet(a).con(2)-=b*2
                Return 0
            EndIf
        Else
            If fleet(a).ty<=7 Then
                If distance(fleet(a).c,player.c)<dis2 And faction(0).war(fleet(a).ty)<100 Then
                    closest_fleet=a
                    dis2=distance(fleet(a).c,player.c)
                EndIf
            EndIf
        EndIf
    Next

    For a=0 To 2
        b=distance(player.c,basis(a).c)
        If b<d Then
            d=b
            c=a
        EndIf
    Next
    beacon=findbest(36,-1)
    If beacon>0 Then
        dis=item(beacon).v1
        If rnd_range(1,100)<66 Then destroyitem(beacon)
    Else
        dis=0
    EndIf
    If d>0 And d<256 Then
        rlprint "Fuel tanks empty, sending distress signal!",14
        no_key=keyin
        If d<5+dis*2 Then
            If faction(0).war(1)<100 Then
                rlprint "Station " &c+1 &" answered and sent a retrieval team. You are charged "& Int(d*(100-dis*10)) & " Cr.",10
                player.money=player.money-Int(d*(100-dis*10))'needs to go below 0
                player.fuel=10
                player.c.x=basis(c).c.x
                player.c.y=basis(c).c.y
            Else
                rlprint "One of the stations answers, explaining that they will not help a known pirate like you.",12
                player.dead=1
            EndIf
        Else
            rlprint "You are too far out in space....",12

            If rnd_range(1,100)-(10+dis-dis2)<5+dis*2 Then
                rlprint "Your distress signal is answered!",10
                b=rnd_range(1,33)+rnd_range(1,33)+rnd_range(1,33)
                If closest_fleet>0 Then
                    rlprint add_a_or_an(fname(fleet(closest_fleet).ty),1)&" offers to sell you fuel to get back to the nearest base for "& b &" Cr. per ton. ("& Int(disnbase(player.c)*b) &" credits for " &Int(disnbase(player.c)) &" tons)."
                Else
                    rlprint add_a_or_an(shiptypes(rnd_Range(0,16)),1) &" offers to sell you fuel to get to the nearest station for "& b &" Cr. per ton. ("& Int(disnbase(player.c)*b) &" credits for " &Int(disnbase(player.c)) &" tons)."
                EndIf
                If askyn("Do you accept the offer?(y/n)") Then
                    If player.money>=Int(disnbase(player.c)*b) Then
                        player.money=player.money-disnbase(player.c)*b
                    Else
                        rlprint "You convince them to lower their price. They only take all your money.",10
                        player.money=0
                    EndIf
                    player.fuel=disnbase(player.c)+2
                    Locate 1,1
                    no_key=keyin
                Else
                    If Not(askyn("Are you certain? (y/n)")) Then
                        If player.money>=Int(disnbase(player.c)*b) Then
                            player.money=player.money-disnbase(player.c)*b
                        Else
                            rlprint "You convince them to lower their price. They only take all your money.",10
                            player.money=0
                        EndIf
                        player.fuel=disnbase(player.c)+2
                        Locate 1,1
                        no_key=keyin
                    Else
                        rlprint "they leave again."
                        Locate 1,1
                        no_key=keyin
                        player.dead=1
                    EndIf
                EndIf
            Else
                player.dead=1
            EndIf
        EndIf
        no_key=keyin
        Cls
    EndIf
    Return 0
End function



function display_system(in as short,forcebar as byte=0,hi as byte=0) as short
    dim as short a,b,bg,x,y,fw1
    dim as string bl,br

    if _fw1<_tix then
        fw1=_fw1
    else
        fw1=_tix
    endif
    
    if configflag(con_onbar)=0 or forcebar=1 then
        y=21
        x=_mwx/2-2
        bl=chr(180)
        br=chr(195)
    else
        x=((map(in).c.x-player.osx)*fw1-12*_fw2)/_fw1
        y=map(in).c.y+1-player.osy
        if x<0 then x=0
        if configflag(con_sysmaptiles)=0 then
            if x*fw1+18*_tix>_mwx*fw1 then x=(_mwx*fw1-18*_tix)/fw1
        else
            if x*fw1+24*_fw2>_mwx*fw1 then x=(_mwx*fw1-24*_fw2)/fw1
        endif
        'if x*fw1+(25*_fw2)/fw1>_mwx*fw1 then x=_mwx*fw1-(25*_fw2)/fw1
        bl="["
        br="]"
    endif
    display_sysmap(x*fw1,y*_fh1,in,hi,bl,br)
    set__color( 11,0)
#if __FB_DEBUG__
    bl=""
    for a=1 to 9
        bl=bl &map(in).planets(a)&" "
        if map(in).planets(a)>0 then
            bl=bl &"ms:"&map(in).planets(a)
        endif
    next
    rlprint bl &":"& hi  &" - "&x
#endif
    return 0
end function


function getplanet(sys as short,forcebar as byte=0) as short
    dim as short r,p,a,b
    dim as string text,key
    dim as _cords p1
    if sys<0 or sys>laststar then
        rlprint ("ERROR:System#:"&sys,14)
        return -1
    endif
    map(sys).discovered=2
    p=liplanet
    if p<1 then p=1
    if p>9 then p=9
    if map(sys).planets(p)=0 then p=nextplan(p,sys)
    for a=1 to 9
        if map(sys).planets(a)<>0 then b=1
    next
    if b>0 then
        rlprint "Enter to select, arrows to move,ESC to quit"
        if show_mapnr=1 then rlprint map(sys).planets(p)&":"&isgasgiant(map(sys).planets(p))
        do
            display_system(sys,,p)
            key=""
            key=keyin
            if uConsole.keyplus(key) or key=key_east or key=key_north then p=nextplan(p,sys)
            if uConsole.keyminus(key) or key=key_west or key=key_south then p=prevplan(p,sys)
            if key=key_comment then
                if map(sys).planets(p)>0 then
                    rlprint "Enter comment on planet: "
                    p1=locEOL
                    planets(map(sys).planets(p)).comment=gettext(p1.x,p1.y,60,planets(map(sys).planets(p)).comment)
                endif
            endif
            if key="q" or key="Q" or key=key__esc then r=-1
            if (key=key__enter or key=key_sc or key=key_la) and map(sys).planets(p)<>0 then r=p
        loop until r<>0
        liplanet=r

    else
        r=-1
    endif
    return r
end function


'function getplanet(sys as short,forcebar as byte=0) as short
'    dim as short a,r,p,x,xo,yo
'    dim text as string
'    dim key as string
'    dim firstplanet as short
'    dim lastplanet as short
'    dim p1 as _cords
'    if sys<0 or sys>laststar then
'        rlprint ("ERROR:System#:"&sys,14)
'        return -1
'    endif
'    for a=1 to 9
'        if map(sys).planets(a)<>0 then
'            lastplanet=a
'            x=x+1
'        endif
'    next
'    for a=9 to 1 step-1
'        if map(sys).planets(a)<>0 then firstplanet=a
'    next
'    p=liplanet
'    if p<1 then p=1
'    if p>9 then p=9
'    if map(sys).planets(p)=0 then
'        do
'            p=p+1
'            if p>9 then p=1
'        loop until map(sys).planets(p)<>0 or lastplanet=0
'    endif
'    if p>9 then p=firstplanet
'    if lastplanet>0 then
'        if _onbar=0 or forcebar=1 then
'            xo=31
'            yo=22
'        else
'            xo=map(sys).c.x-9-player.osx
'            yo=map(sys).c.y+2-player.osy
'            if xo<=4 then xo=4
'            if xo+18>58 then xo=42
'        endif
'        rlprint "Enter to select, arrows to move,ESC to quit"
'        if show_mapnr=1 then rlprint map(sys).planets(p)&":"&isgasgiant(map(sys).planets(p))
'        do
'            displaysystem(sys)
'            if keyplus(key) or a=6 then
'                do
'                    p=p+1
'                    if p>9 then p=1
'                loop until map(sys).planets(p)<>0
'            endif
'            if keyminus(key) or a=4 then
'                do
'                    p=p-1
'                    if p<1 then p=9
'                loop until map(sys).planets(p)<>0
'            endif
'            if p<1 then p=lastplanet
'            if p>9 then p=firstplanet
'            x=xo+(p*2)
'            if left(displaytext(25),14)<>"Asteroid field" or left(displaytext(25),15)<>"Planet at orbit" then rlprint "System " &map(sys).desig &"."
'            if map(sys).planets(p)>0 then
'                if planets(map(sys).planets(p)).comment="" then
'                    if isasteroidfield(map(sys).planets(p))=1 then
'                        displaytext(25)= "Asteroid field at orbit " &p &"."
'                    else
'                        if planets(map(sys).planets(p)).mapstat<>0 then
'                            if isgasgiant(map(sys).planets(p))<>0 then
'                                if p>1 and p<7 then displaytext(25)= "Planet at orbit " &p &". A helium-hydrogen gas giant."
'                                if p>6 then displaytext(25)= "Planet at orbit " &p &". A methane-ammonia gas giant."
'                                if p=1 then displaytext(25)= "Planet at orbit " &p &". A hot jupiter."
'                            else
'                                if isgasgiant(map(sys).planets(p))=0 and isasteroidfield(map(sys).planets(p))=0 then displaytext(25)="Planet at orbit " &p &". " &atmdes(planets(map(sys).planets(p)).atmos) &" atm., " &planets(map(sys).planets(p)).grav &"g grav."
'                            endif
'                        else
'                            displaytext(25)= "Planet at orbit " &p &"."
'                        endif
'                    endif
'                endif
'                if planets(map(sys).planets(p)).comment<>"" then
'                    if isasteroidfield(map(sys).planets(p))=1 then
'                        displaytext(25)= "Asteroid field at orbit " &p &": " &planets(map(sys).planets(p)).comment &"."
'                    else
'                        displaytext(25)= "Planet at orbit " &p &": " &planets(map(sys).planets(p)).comment &"."
'                    endif
'                endif
'                rlprint ""
'                locate yo,x
'                set__color( 15,3
'                if isgasgiant(map(sys).planets(p))=0 and isasteroidfield(map(sys).planets(p))=0 then print "o"
'                if isgasgiant(map(sys).planets(p))>0 then print "O"
'                if isasteroidfield(map(sys).planets(p))=1 then print chr(176)
'                set__color( 11,0
'            endif
'
'            if map(sys).planets(p)<0 then
'                if map(sys).planets(p)<0 then
'                    if isgasgiant(map(sys).planets(p))=0 then
'                        displaytext(25)= "Asteroid field at orbit " &p &"."
'                    else
'                        if map(sys).planets(p)=-20001 then displaytext(25)= "Planet at orbit " &p &". A helium-hydrogen gas giant."
'                        if map(sys).planets(p)=-20002 then displaytext(25)= "Planet at orbit " &p &". A methane-ammonia gas giant."
'                        if map(sys).planets(p)=-20003 then displaytext(25)= "Planet at orbit " &p &". A hot jupiter."
'                    endif
'                    rlprint ""
'                endif
'                locate yo,x
'                set__color( 15,3
'                if isgasgiant(map(sys).planets(p))=0 then
'                    print chr(176)
'                else
'                    print "O"
'                endif
'                set__color( 11,0
'            endif
'            key=keyin
'            if key=key_comment then
'                rlprint "Enter comment on planet: "
'                p1=locEOL
'                planets(map(sys).planets(p)).comment=gettext(p1.x,p1.y,60,planets(map(sys).planets(p)).comment)
'            endif
'            a=Getdirection(key)
'
'
'            if key="q" or key="Q" or key=key__esc then r=-1
'            if (key=key__enter or key=key_sc or key=key_la) and map(sys).planets(p)<>0 then r=p
'        loop until r<>0
'        liplanet=r
'    else
'        r=-1
'    endif
'    return r
'end function
'

function explore_space() As Short
    DimDebug(0)'11
    Dim As Short a,b,d,c,f,fl,pl,x1,y1,x2,y2,lturn,osx,osy
    Dim As String Key,text,allowed
    Dim As _cords p1,p2
    Dim As Short planetcom,driftercom,fleetcom,wormcom

    lturn=0
    DbgPrint(basis(0).shop(sh_equipment) &":"& basis(1).shop(sh_equipment) &":"& basis(2).shop(sh_equipment))
    For a=0 To lastitem
        For b=0 To lastitem
            If b<>a Then
                If item(a).id=item(b).id And item(a).ty<>item(b).ty Then 
                    rlprint item(a).desig &";" &item(b).desig &item(a).id
                    'item(a).id+=1
                EndIf
            EndIf
        Next
    Next
    For a=1 To 25
        If player.weapons(a).heat>0 Then player.weapons(a).heat=0
    Next
#if __FB_DEBUG__
    If debug=11 Then
        For a=1 To lastdrifting
            drifting(a).p=1
        Next
    EndIf
#endif
    tScreen.set(0)
    Cls
    bg_parent=bg_shipstarstxt
    location=lc_onship
    display_stars(1)
    display_ship
    tScreen.update()
    tScreen.set(0)
    Cls
    bg_parent=bg_shipstarstxt
    display_stars(1)
    display_ship
    tScreen.update()
    tScreen.set(0)
#if __FB_DEBUG__
    If debug=10 Then
		DbgPrint(spdescr(7))
    EndIf
#endif
    tVersion.gameturn=fix(tVersion.gameturn/10)*10 'Needs to be multiple of 10 for events to trigger
    Do
        DbgPrint("Lastfleet:"&lastfleet)
        tVersion.gameturn+=10
        If show_specials<>0 Then rlprint "Planet is at " &map(sysfrommap(specialplanet(show_specials))).c.x &":"&map(sysfrommap(specialplanet(show_specials))).c.y
        If player.e.tick=-1 And player.dead=0 Then
            fl=0
            allowed=key_awayteam & key_ra & key_drop &key_la &key_tala &key_dock &key_sc & key_rename & key_comment & key_save &key_quit &key_tow &key_walk &key_wait
            allowed= allowed & key_nw & key_north & key_ne & key_east & key_west & key_se & key_south & key_sw &key_optequip
            If artflag(25)>0 Then allowed=allowed &key_te
#if __FB_DEBUG__
            If debug=11 Then allowed=allowed &"�"
#endif
            For a=0 To 2
                If player.c.x=basis(a).c.x And player.c.y=basis(a).c.y Then
                    rlprint "You are at Spacestation-"& a+1 &". Press "&key_dock &" to dock."
                    allowed=allowed & key_fi
                    If walking<10 Then walking=0
                    driftercom=1
                EndIf
            Next

            For a=0 To lastfleet
                If distance(player.c,fleet(a).c)<1.5 Then
                    fl=meet_fleet(a)
                    fleetcom=1
                    Exit For
                EndIf
            Next
            For a=0 To laststar
                If player.c.x=map(a).c.x And player.c.y=map(a).c.y Then
                    planetcom=a+1
                    rlprint add_a_or_an(spectralname(map(a).spec),1)&"." & system_text(a) & ". Press "&key_sc &" to scan, "&key_la &" to land, " &key_tala &" to land at a specific spot, "&key_optequip &" to change armor priorities."
                    If a=piratebase(0) Then rlprint "Lots of traffic in this system"
                    map(a).discovered=2
                    display_system(a)
                    If walking<10 Then walking=0
                EndIf
            Next
            For a=laststar+1 To laststar+wormhole
                If player.c.x=map(a).c.x And player.c.y=map(a).c.y Then
                    rlprint "A wormhole. Press "&key_la &" to enter it."
                    wormcom=1
                    If walking<10 Then walking=0
                EndIf
            Next
            For a=1 To lastdrifting
                If player.c.x=drifting(a).x And player.c.y=drifting(a).y And planets(drifting(a).m).flags(0)=0 And player.towed<>a Then
                    If player.tractor>0 And a>3 Then
                        rlprint add_a_or_an(shiptypes(drifting(a).s),1)&" is drifting in space here. "&key_dock &" to dock, "&key_tow &" to tow."
                    EndIf
                    If player.tractor=0 Then
                        rlprint add_a_or_an(shiptypes(drifting(a).s),1)&" is drifting in space here. "&key_dock &" to dock."
                    EndIf
                    drifting(a).p=1
                    driftercom=1
                    If walking<10 Then walking=0
                EndIf
            Next
            If fl>0 Or _testspacecombat=1 Then
                If fleet(fl).ty=1 And fl>5 Then
                    If tVersion.gameturn Mod 10=0 Then
                        If fleet(fl).con(1)=0 Then
                            rlprint "There is a merchant convoy in sensor range, hailing us. press "&key_fi &" to attack," &key_ra & " to call by radio."
                        Else
                            rlprint "This is merchant convoy "&fl &". reporting no incidents."
                        EndIf
                    EndIf
                EndIf
                If fleet(fl).ty=2 Then rlprint "There is a pirate fleet in sensor range, hailing us. press "&key_fi &" to attack, " &key_ra & " to call by radio."
                If fleet(fl).ty=3 Then rlprint "There is a company anti pirate patrol in sensor range, hailing us. press "&key_fi &" to attack, " &key_ra & " to call by radio."
                If fleet(fl).ty=4 Then rlprint "There is a pirate fleet in sensor range, hailing us. press "&key_fi &" to attack, " &key_ra & " to call by radio."
                If fleet(fl).ty=6 Then
                    If civ(0).contact=0 Then
                        rlprint civfleetdescription(fleet(fl)) &" hailing us. Press "& key_fi &"to attack, " &key_ra & " to call by radio."
                    Else
                        rlprint add_a_or_an(civ(0).n,1) &" fleet, hailing us. Press "& key_fi &"to attack, " &key_ra & " to call by radio."
                    EndIf
                EndIf
                allowed=allowed+key_fi
                fleetcom=1
            EndIf

            comstr.t=key_ra &" call by radio;"&key_drop &" launch probe;"&key_comment &" comment;"
            If planetcom>0 Then comstr.t=comstr.t & key_sc &" scan;"& key_la &" land;"& key_tala &" target land;"
            If fleetcom=1 Then comstr.t=comstr.t &key_fi &" attack;"
            If driftercom=1 Then comstr.t=comstr.t &key_dock &" dock;"
            If wormcom=1 Then comstr.t=comstr.t &key_la &" enter wormhole;"
            If artflag(25)>0 Then comstr.t=comstr.t &key_te &" wormhole generator"
            
            tScreen.set(0)
            Cls
            bg_parent=bg_shipstarstxt
            location=lc_onship
            display_stars(1)
            display_ship(1)
            If planetcom>0 Then display_system(planetcom-1)
            rlprint ""
            tScreen.update()
        
            'tScreen.set(1)
            Key=keyin(allowed,walking)
            
            player=move_ship(Key)

            planetcom=0
            fleetcom=0
            driftercom=0
            wormcom=0
            comstr.t=key_ra &" call by radio;"&key_drop &" launch probe;"&key_comment &" comment;"

#if __FB_DEBUG__
            If debug=11 And Key="�" Then
                rlprint fleet(1).mem(1).hull &":"&fleet(2).mem(1).hull &":"&fleet(3).mem(1).hull
                lastfleet=8
                fleet(6)=makealienfleet
                fleet(6).c=basis(0).c
                fleet(7)=makealienfleet
                fleet(7).c=basis(1).c
                fleet(8)=makealienfleet
                fleet(8).c=basis(2).c
            EndIf
#endif

            If Key=key_fi Then
                For a=0 To 2
                    If player.c.x=basis(a).c.x And player.c.y=basis(a).c.y Then
                        If askyn( "Do you really want to attack Spacestation-"& a+1 &")(y/n)") Then
                            fl=0
                            factionadd(0,fleet(a+1).ty,20)
                            playerfightfleet(a+1)
                            If player.dead=0 Then
                                If fleet(a+1).mem(1).hull<=0 Then
                                    rlprint "Station "&a+1 &" has been destroyed"
                                    basis(a).c.x=-1
                                    fleet(a).c.x=-1
                                EndIf
                            EndIf
                        Else
                            fl=0
                        EndIf
                    EndIf
                Next
                If _testspacecombat=1 Then fl=rnd_range(4,lastfleet)
                If fl>0 Then
                    factionadd(0,fleet(fl).ty,20)

                    playerfightfleet(fl)
                EndIf
            EndIf

            If Key=key_walk Then
                Key=keyin
                walking=uConsole.getdirection(Key)
            EndIf
            
            if key=key_optequip then
                a=textmenu(bg_shiptxt,"When choosing armor/optimize protection/balanced/optimize oxygen")
                if a=1 then 
                    awayteam.optoxy=0
                    rlprint "Now optimizing protection"
                endif
                if a=2 then
                    awayteam.optoxy=1
                    rlprint "Balanced"
                endif
                if a=3 then 
                    awayteam.optoxy=2
                    rlprint "Now optimizing oxygen"
                endif
            endif
            
            if key=key_wait then
                player.add_move_cost(0)
            endif
            
            If Key=key_ra Then space_radio

            If Key=key_drop Then launch_probe

            If Key=key_la Or Key=key_tala Or Key=key_sc Then
                pl=-1
                For a=0 To laststar
                    If player.c.x=map(a).c.x And player.c.y=map(a).c.y Then pl=a
                Next

                If pl>-1 Then
                    If Key=key_la Or Key=key_tala Then
                        a=getplanet(pl)
                        If a>0 Then
                            b=map(pl).planets(a)
                            If isgasgiant(b)=0 And b>0 Then
                                If Key=key_la Then landing(map(pl).planets(a))
                                If Key=key_tala Then target_landing(map(pl).planets(a))
                            Else
                                If isgasgiant(b)=0 Then
                                    rlprint"You don't find anything big enough to land on"
                                Else
                                    gasgiant_fueling(b,a,pl)
                                EndIf
                            EndIf
                        EndIf
                    EndIf
                    If Key=key_sc Then scanning()
                    Key=""
                EndIf
                pl=-1

                If Key=key_sc And Abs(spacemap(player.c.x,player.c.y))>=6 And Abs(spacemap(player.c.x,player.c.y))<=10 Then
                    If askyn("Do you want to scan the anomaly?(y/n)") Then
                        If rnd_range(1,100)=1 Then player.cursed+=1
                        If skill_test(player.science(0),st_easy+Abs(spacemap(player.c.x,player.c.y)),"Science officer") Then
                            rlprint "You succesfully identified the anomaly!",c_gre
                            rlprint gainxp(4),c_gre
                            ano_money+=Abs(spacemap(player.c.y,player.c.y))/2
                            spacemap(player.c.x,player.c.y)=Abs(spacemap(player.c.x,player.c.y))+10
                            Select Case spacemap(player.c.x,player.c.y)
                            Case Is=16
                                rlprint "This anomaly shortens space, slightly reducing fuel consumption when travelling through it."
                            Case Is=17
                                rlprint "This anomaly lengthens space, slightly increasing fuel consumption when travelling through it."
                            Case Is=18
                                rlprint "This anomaly shortens space, slightly reducing fuel consumption while travelling through it. It also is highly charged and can damage a ship."
                            Case Is=19
                                rlprint "This anomaly lengthens space, slightly increasing fuel consumption while travelling through it. It also is highly charged and can damage a ship."
                            Case Is=20
                                rlprint "This anomaly can damage a ship and is highly unpredictable."
                            End Select
                        Else
                            rlprint "You are unable to identify the anomaly.",c_yel
                        EndIf
                    EndIf
                EndIf

                If Key=key_la Then wormhole_travel()
            EndIf

            If Key=key_dock Then
                For a=0 To 3
                    If player.c.x=basis(a).c.x And player.c.y=basis(a).c.y Then
                        If stationroll=0 Or player.lastvisit.s<>a Then stationroll=rnd_range(1,20)
                        If faction(0).war(1)+stationroll<100 Then
                            b=rnd_range(1,4)
                            If faction(0).war(1)>80 Then
                                rlprint "You have to beg to get a docking permission, exagerating the sorry state of your ship quite a bit in the process!",14
                                b=15
                            EndIf
                            If faction(0).war(1)>33 Then
                                If b=1 Then rlprint "After an unusually long waiting period you get your permission to dock.",14
                                If b=2 Then rlprint "The Station commander questions you extensively about your activities before allowing you to dock.",14
                            EndIf
                            If faction(0).war(1)>66 Then
                                If b=1 Then rlprint "After you dock you overhear a dock worker remark 'I didn't know we were allowing known pirates on the base.' He looks at you fully aware that you heard him.",14
                                If b=2 Then rlprint "A patrol boat captain bumps into you snarling 'Pirate scum. Wait till i meet you in space!'",14
                            EndIf
                            player=spacestation(a)
                            Key=""
                            If configflag(con_autosave)=0 And player.dead=0 Then
                                tScreen.set(1)
                                rlprint "Saving game",15
                                savegame()
                            EndIf
                            set__color( 11,0)
                            c=0
                            d=0
                            For b=0 To 10
                                If player.cargo(b).x>1 And player.cargo(b).x<7 Then
                                    c=c+basis(a).inv(player.cargo(b).x-1).p
                                EndIf
                            Next
                            c=c\15
                            'rlprint "pirate chance:" &c
                            If c>66 Then c=66
                            ' Pirate agression test
                            For b=0 To 10
                                If player.cargo(b).x=7 Then
                                    c=101
                                    d=1
                                EndIf
                            Next
                            If basis(a).spy=1 Then c=0
                            For b=3 To lastfleet
                                If fleet(b).ty=2 And rnd_range(1,100)<c Then
                                    fleet(b).t=8
                                    d=1
                                Else
                                    fleet(b).t=9
                                EndIf
                            Next
                            'see if pirates notice
                            If d=1 Then
                                rlprint "As you load your Cargo you notice a worker taking notes. When you want to question him he is gone.",c_yel
                            EndIf
                            If player.money<0 And player.dead=0 Then
                                If skill_test(player.pilot(0),st_hard) Then
                                    rlprint "As you leave the docking bay you get a message from the station commander to return to 'solve some financial issues' first. Your pilot grins and heads for the docking bay doors, exceeding savety limits. The doors slam close right behind your ship. As you speed into space you get a radio message from the commander. He calmly explains that there *will* be a fee for that next time you dock.",c_yel
                                    player.money=player.money-100
                                    faction(0).war(2)-=1
                                    faction(0).war(1)+=1
                                Else
                                    player.dead=2
                                EndIf
                            EndIf
                        Else
                            rlprint "The station commander closes the bay doors and fires upon you!",12
                            d=rnd_range(1,6)
                            rlprint "You take "&d &" points of damage!",c_red
                            player.hull=player.hull-d
                            If player.hull<=0 Then player.dead=18
                            no_key=keyin
                        EndIf
                    EndIf
                Next
                tScreen.set(1)
                display_stars(1)
            EndIf

            If Key=key_dock Then
                For a=1 To lastdrifting
                    If player.c.x=drifting(a).x And player.c.y=drifting(a).y And planets(drifting(a).m).flags(0)=0 Then dock_drifting_ship(a)
                Next
            EndIf

            If Key=key_tow Then
                If player.towed=0 Then
                    For a=4 To lastdrifting
                        If player.c.x=drifting(a).x And player.c.y=drifting(a).y And planets(drifting(a).m).flags(0)=0 Then
                            If player.tractor>0 Then
                                player.towed=a
                                rlprint "You tow the other ship."
                            Else
                                rlprint "You have no tractor beam.",14
                            EndIf
                        EndIf
                    Next
                Else
                    player.towed=0
                    rlprint "You release the other ship."
                EndIf
                Key=""
            EndIf
            
            
            If artflag(25)>0 And Key=key_te Then
                wormhole_travel
            EndIf
            
            If Key=key_awayteam Then showteam(0)


            tScreen.set(0)
            set__color(11,0)
            Cls

            display_stars(1)
            display_ship(1)
            rlprint ""



        EndIf

        update_world(1)

        If player.hull<=0 And player.dead=0 Then player.dead=18
        If player.fuel<=0 And player.dead=0 Then rescue()

        If Key=key_save Then
            If askyn("Do you really want to save the game? (y/n)") Then player.dead=savegame()
        EndIf

        If Key=key_rename Then
            If askyn("Do you want to rename your ship? (y/n)") Then
                tScreen.set(1)
                set__color( 15,0)
                draw_string(sidebar+(1+Len(Trim(player.h_sdesc)))*_fw2 ,0, Space(25),font2,_col)
                Key=gettext(sidebar+(1+Len(Trim(player.h_sdesc)))*_fw2,1,32,"",1)
                If Key<>"" Then player.desig=Key
                set__color( 11,0)
                tVersion.gameturn=tVersion.gameturn-1
                tVersion.gamedesig=player.desig
            EndIf
        EndIf

        If Key=key_comment Then 'Name or comment on map
            p2.x=player.c.x'-player.osx
            p2.y=player.c.y'-player.osy

            osx=player.osx
            osy=player.osy
            Do

                player.osx=p2.x-_mwx/2
                player.osy=p2.y-10
                If player.osx<=0 Then player.osx=0
                If player.osy<=0 Then player.osy=0
                If player.osx>=sm_x-_mwx Then player.osx=sm_x-_mwx
                If player.osy>=sm_y-20 Then player.osy=sm_y-20
                osx=player.osx
                osy=player.osy
                tScreen.set(0)
                Cls
                display_stars(2)
                display_ship(1)
                rlprint ""
                tScreen.update()
                Key=Cursor(p2,0,osx,osy)


            Loop Until Key=key__esc Or Key=key__enter Or (Asc(Ucase(Key))>64 And Asc(Key)<132)
            set__color( 11,0)

            b=0
            If Key<>key__esc Then
                For a=1 To lastcom
                    If p2.y=coms(a).c.y Then
                        If p2.x>=coms(a).c.x And p2.x<=coms(a).c.x+coms(a).l Then
                                Key=Trim(coms(a).t)
                                b=a
                                p2.x=coms(a).c.x
                                p2.y=coms(a).c.y
                        EndIf
                     EndIf
                Next
                tScreen.set(0)
                Cls
                display_stars(2)
                display_ship(1)
                rlprint ""
                tScreen.update()
                tScreen.set(1)
                If Asc(Key)<65 Or Asc(Key)>122 Then Key=""
                text=gettext((p2.x-osx)*_fw1,(p2.y-osy)*_fh1,16,Key,1)
                text=Trim(text)
                set__color(11,0)
                Cls
                display_stars(1)
                display_ship(1)
                If b=0 Then
                    lastcom=lastcom+1
                    b=lastcom
                EndIf
                If p2.x*_tix+Len(text)*_fw2>sm_x*_tix Then p2.x=CInt((sm_x*_tix-Len(text)*_fw2)/_tix)
                coms(b).c.x=p2.x
                coms(b).c.y=p2.y
                coms(b).t=text
                coms(b).l=Len(text)
            EndIf
            b=0
            For a=1 To lastcom
                If coms(a).t="" Then
                    coms(a)=coms(a+1)
                Else
                    b=b+1
                EndIf
            Next
            set__color(11,0)
            Cls
            lastcom=b
            display_stars(1)
            display_ship(1)
        EndIf
        
        For a=0 To 7
            For b=0 To 7
                If faction(a).war(b)>100 Then faction(a).war(b)=100
                If faction(a).war(b)<0 Then faction(a).war(b)=0
            Next
        Next

        For a=0 To 7
            If faction(a).alli<>0 Then
                For b=0 To 7
                    faction(a).war(b)=(faction(a).war(b)+faction(faction(a).alli).war(b))/2
                Next

            EndIf
        Next

        driftercom=0
        planetcom=0
        fleetcom=0
        wormcom=0


    Loop Until player.dead>0

    Return 0
End function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tExplorespace -=-=-=-=-=-=-=-
	tModule.register("tExplorespace",@tExplorespace.init()) ',@tExplorespace.load(),@tExplorespace.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tExplorespace -=-=-=-=-=-=-=-
#endif'test
