'tSpacecombat

function spacecombat(byref atts as _fleet,ter as short) as short
    dim attacker(16) as _ship
    'dim direction(15) as byte
    'dim dontgothere(15) as byte
    'dim speed(15) as short
    'dim tick(15) as single
    'dim tickr(15) as single
    dim as byte manjetson
    'dim movementcost(15) as short
    dim col as short
    dim st as integer
'    dim nexsen as short
'    dim senbat as short
'    dim senbat1 as short
'    dim senbat2 as short

    dim as short a,b,c,d,e,f,l,last,osx
    dim as string ws(15)
    dim as short tic,t,w
    'dim lastenemy as short
    dim target as short
    dim lasttarget as short
    dim x as short
    dim y as short
    dim key as string
    dim rangestr as string
    dim range as short
    dim p as _cords
    dim p1 as _cords
    dim roll as short
    dim victory as short
    dim astring as string
    dim text as string
    dim e_track_p(128) as _cords
    dim e_track_v(128) as short
    dim e_last as short
    dim e_map(60,20) as byte
    dim as short noenemies
    dim mines_p(128) as _cords
    dim mines_v(128) as short
    dim mines_last as short
    dim as uinteger localturn
    dim old as _cords
    dim as _cords exitcords

#if __FB_DEBUG__
    dim as byte debug=11
    dim as string dbugstring
#else
    dim as byte debug=0
#endif
    'debug=10
    if debug=10 then
        for a=0 to 128
            if e_track_v(a)>0 then rlprint ""&e_track_v(a)
        next
    endif
    
    for x=0 to 60
        for y=0 to 20
            combatmap(x,y)=0
            if rnd_range(1,100)<ter/2 then
                combatmap(x,y)=rnd_range(1,5)
                if ter=20 then combatmap(x,y)=6 'Asteroid field
                if ter=21 then combatmap(x,y)=7 'Gas giant
            endif
            if rnd_range(1,100)<13 and (rnd_range(1,100)<3 or ter>=20) then
                combatmap(x,y)=rnd_range(1,7)
            endif
        next
    next
    combatmap(30,10)=0
    victory=0
    col=12
    exitcords.x=player.c.x
    exitcords.y=player.c.y
    player.aggr=1 '1= one of the good guys
    b=0
    for a=1 to 15
        if atts.mem(a).hull>0 then
            for c=0 to 7
                if c<>4 then attacker(b).shieldside(c)=attacker(b).shieldmax
            next
            b+=1
            noenemies+=1
            attacker(b)=atts.mem(a)
            attacker(b).di=rnd_range(1,8)
            if attacker(b).di=5 then attacker(b).di=9
            if attacker(b).shiptype=1 then 'Merchantman exit target
                col=10 'all green now
                attacker(b).target.x=0
                attacker(B).target.y=rnd_range(1,20)
            endif
        endif

    next
    p=player.c
    player.dead=-1
    player.c.x=30
    player.c.y=10
    player.senac=1
    for c=0 to 7
        if c<>4 then player.shieldside(c)=player.shieldmax
    next


    for a=1 to 15
        if attacker(a).shiptype=2 then
            if attacker(a).aggr=0 then 'This is where you start when you attack a spacestation
                player.c.x=0
                player.c=movepoint(player.c,5)
            else
                player.c.y=11
                player.c.x=31
            endif
        endif
    next

    com_NPCMove(player,attacker(),e_track_p(),e_track_v(),e_map(),e_last)
'    senac=1
'    senbat=defender.sensors+2
'    senbat1=defender.sensors+1
'    senbat2=defender.sensors
'    if attacker(1).shiptype=2 then
'        rlprint "Attacking station"
'        attacker(1).c.x=30
'        attacker(1).c.y=10
'        defender.c.x=0
'        defender.c.y=10
'    endif
    screenset 0,1
    cls
    l=display_ship(0)
    last=string_towords(ws(),comstr.t,";")
    for d=1 to last
        set__color(15,0)
        draw string((_mwx+2)*_fw1,(d+l)*_fh2),ws(d),,Font2,custom,@_col
    next
    f=com_display(player, attacker(),0,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
    rlprint ""
    flip
    do

        screenset 0,1
        cls
        display_ship(0)
        f=com_display(player, attacker(),0,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
        rlprint ""
        flip

        key=""
        player.e.tick
        for d=1 to 14
            if attacker(d).hull>0 then attacker(d).e.tick
        next

#if __FB_DEBUG__
        if debug=9 then 
			DbgPrint(dbugstring)
        EndIf
#endif

   '
        if player.hull>0 then 'playermovement
            if player.e.e=0 then

#if __FB_DEBUG__
                if debug=9 then 
					DbgPrint(""&f)
                EndIf
#endif
                if player.c.x=0 or player.c.y=0 or player.c.x=60 or player.c.y=20 then f=-1

                if f<>0 then
                    comstr.t= key_fi &" to fire weapons;"&key_drop &" to drop mines;"&key_sc &" to scan enemy ships;"& key_ra & " to call opponents;" &key_ru & " to run and flee."
                else
                    comstr.t= key_drop &" to drop mines;"& key_ra & " to call opponents;" &key_ru & " to run and flee."
                endif
                'set__color( 11,0
                'draw string(62*_fw1,5*_fh2), "Engine :"&player.engine &" ("&speed(0) &" MP)",,Font2,custom,@_col
                'flip
                key=keyin("1234678"&key_ac &key_ra &key_dropshield &key_sc &key_ru &key__esc &key_drop &key_fi &key_ru &key_togglemanjets &key_cheat)
                'screenset 0,1
                if key=key_ac then
                    select case player.senac
                    case 2
                        player.senac=1
                    case 1
                        player.senac=2
                    end select
                    player.e.add_action(1)
                endif

                if key=key_ra then
                    rlprint "Calling other ships"
                    victory=com_radio(player,attacker(),e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
                endif

                if key=key_cheat then com_cheat=1

                if key=key_togglemanjets then
                    if player.manjets=0 then
                        rlprint "You have no manjets"
                    else
                        player.e.add_action(1)
                        if manjetson=0 then
                            manjetson=1
                            rlprint "You turn on your maneuvering jets"
                        else
                            manjetson=0
                            rlprint "You turn off your maneuvering jets"
                        endif
                    endif
                endif

                if key=key_dropshield and player.shieldmax>0 then
                    if askyn ("Do you really want to shut down your shields? (y/n)") then
                        for a=0 to 7
                            player.shieldside(a)=0
                        next
                        player.shieldshut=1
                        player.e.add_action(1)
                    endif
                endif

                if key=key_ru then
                    victory=com_flee(player,attacker())
                endif

                if key=key_drop then
                    com_dropmine(player,mines_p(),mines_v(),mines_last,attacker())
                    player.e.add_action(1)
                endif

                if f<>0 and player.hull>0 then
                    if key=key_sc then
                        player.e.add_action(1)
                        t=com_gettarget(player,w,attacker(),t,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
                        if t>0 then
                            if attacker(t).c.x>30 then
                                x=attacker(t).c.x-21
                            else
                                x=attacker(t).c.x+1
                            endif
                            if attacker(t).c.y>10 then
                                y=attacker(t).c.y-5
                            else
                                y=attacker(t).c.y+1
                            endif
                            if x<1 then x=1
                            if y<1 then y=1
                            textbox(com_shipbox(attacker(t),distance(player.c,attacker(t).c)),x,y,20,15,1)
                            player.e.add_action(1)
                            no_key=keyin
                        endif
                    endif

                    if key=key_fi then
                        player.e.add_action(1)
                        do
                            w=com_getweapon()
                            if w>0 then 
                                if player.weapons(w).ammomax>0 and player.tribbleinfested>0 then
                                    if rnd_range(1,player.ammo)<player.tribbleinfested then
                                        rlprint "That wasn't a shell that was just a bunch of tribbles in the tube!",c_yel
                                        w=0
                                    endif
                                endif
                            endif
                            if w>0 then
                                if com_testweap(player.weapons(w),player.c,attacker(),mines_p(),mines_last,1) then
                                    t=com_gettarget(player,w,attacker(),t,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
                                    if t>0 and t<100 then
                                        player.e.add_action(1)
                                        if pathblock(player.c,attacker(t).c,0,2,player.weapons(w).col)=-1 then
                                            attacker(t)=com_fire(attacker(t),player,w,player.gunner(0)+add_talent(3,12,1),distance(player.c,attacker(t).c))
                                            player.weapons(w).reloading=player.weapons(w).reload
                                            if attacker(t).hull<=0 then
                                                rlprint "Target destroyed",10
                                                reward(3)=reward(3)+attacker(t).money
                                                piratekills(attacker(t).st)+=1
                                                piratekills(0)+=attacker(t).money
                                                com_remove(attacker(),t)
                                                t=0
                                                'no_key=keyin
                                            endif
                                            'no_key=keyin()
                                        endif
                                    endif
                                    if t>100 then com_detonatemine(t-100,mines_p(), mines_v() ,mines_last, player , attacker())
                                else
                                    t=-1
                                endif
                            endif
                            screenset 0,1
                            cls
                            display_ship(0)
                            f=com_display(player, attacker(),0,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
                            'rlprint ""
                            flip

                            key=""
                        loop until t=-1 or w=0 or f=0

                    endif
                    if key=key_ru then victory=com_flee(player,attacker())
                    if victory=1 then
                        player.c=exitcords
                        return 0
                    endif
                endif


                if getdirection(key)<>0 then
                    player.di=getdirection(key)

                    old=player.c
                    player.c=movepoint(player.c,getdirection(key))
                    e_last=com_add_e_track(player,e_track_p(),e_track_v(),e_map(),e_last)

                    if combatmap(player.c.x,player.c.y)>0 and rnd_Range(1,6)+rnd_range(1,6)+player.pilot(0)<combatmap(player.c.x,player.c.y)*2 then
                        if combatmap(player.c.x,player.c.y)=1 or combatmap(player.c.x,player.c.y)=6 then
                            rlprint "You have hit an asteroid!",14
                        else
                            rlprint "You have hit a glas cloud!",14
                        endif
                        player=com_damship(player,1,c_red)
                    endif
                    if mines_last>0 then
                        for c=1 to mines_last
                            if player.c.x=mines_p(c).x and player.c.y=mines_p(c).y then
                                com_detonatemine(c,mines_p(), mines_v() ,mines_last, player , attacker() )
                            endif
                        next
                    endif

                        '
                        if e_map(player.c.x,player.c.y)>0 then
                            text=""
                            c=e_map(player.c.x,player.c.y)
                            if e_track_v(c)=0 then
                                e_map(player.c.x,player.c.y)=0
                            else
                                text="The "&player.desig &" runs into a plasma stream! "
                                player=com_damship(player,e_track_v(c),c_red)
                                osx=calcosx(player.c.x,1)
                                if configflag(con_tiles)=0 then
                                    if e_track_v(C)>=4 then put ((e_track_p(C).x-osx)*_tix,e_track_p(C).y*_tiy),gtiles(81),trans
                                    if e_track_v(C)=3 then put ((e_track_p(C).x-osx)*_tix,e_track_p(C).y*_tiy),gtiles(82),trans
                                    if e_track_v(C)=2 then put ((e_track_p(C).x-osx)*_tix,e_track_p(C).y*_tiy),gtiles(83),trans
                                    if e_track_v(C)=1 then put ((e_track_p(C).x-osx)*_tix,e_track_p(C).y*_tiy),gtiles(84),trans
                                else
                                endif
                                if player.hull<=0 then
                                    text=text &player.desig &" destroyed!"
                                    if e_track_p(c).m=1 then atts.ty=10

                                endif
                                if text<>"" then rlprint text,c_red
                                if player.hull<=0 then no_key=keyin
                            endif
                        endif
                    if old.x<>player.c.x or old.y<>player.c.y then player.add_move_cost(manjetson)
                endif

'                screenset 0,1
'                cls
'                displayship(0)
'                com_display(player, attacker(),lastenemy,0,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
                endif
            endif

            'Other ships fire
            com_NPCFire(player,attacker())
            com_NPCMove(player,attacker(),e_track_p(),e_track_v(),e_map(),e_last)


            if mines_last>0 then
                for b=1 to 14
                    if attacker(b).hull>0 then
                        for c=1 to mines_last
                            if attacker(b).c.x=mines_p(c).x and attacker(b).c.y=mines_p(c).y then
                                com_detonatemine(c,mines_p(), mines_v() ,mines_last, player , attacker())
                            endif
                        next
                    endif
                next
            endif

        if localturn mod 5=0 then
            for b=e_last to 1 step -1
                e_track_v(b)=cint(e_track_v(b)*.6)-1
                if e_track_v(b)<=0 then
                    e_map(e_track_p(b).x,e_track_p(b).y)=0 'Set current one to 0
                    e_track_v(b)=e_track_v(e_last)'Overwrite with last
                    e_track_p(b)=e_track_p(e_last)
                    if e_last>0 then 
                        e_last-=1
                        e_map(e_track_p(e_last).x,e_track_p(e_last).y)=e_last'Put counter in map
                    endif
                endif
            next
        endif

        if localturn mod 5=0 then
            com_regshields(player)
            com_sinkheat(player,manjetson)
            for a=1 to 14
                if attacker(a).hull>0 then
                    com_regshields(attacker(a))
                    com_sinkheat(attacker(a),0)
                endif
            next
        endif

        localturn+=1
        if key=key_ru and victory<>1 then victory=com_flee(player,attacker())
        if victory=1 then
            player.dead=0
            player.c=exitcords
            return 0
        endif

        if com_victory(attacker())<=0 then victory=2
        if player.hull<=0 then victory=3

        'merchant flee atempt
        for a=1 to 14
            if attacker(a).shiptype=1 then
                if attacker(a).c.x=attacker(a).target.x and attacker(a).c.y=attacker(a).target.y then
                    if skill_test(attacker(a).pilot(0),st_average+player.pilot(0)) then
                        rlprint "The Merchant got away!",10
                        fleet(255).mem(a)=attacker(a)
                        com_remove(attacker(),a,1)
                    else
                        rlprint "The Merchant didn't get away",12
                        attacker(a).c.x=60
                        attacker(a).target.x=0
                        attacker(a).c.y=rnd_range(1,20)
                        attacker(a).target.y=rnd_range(1,20)
                    endif
                endif
            endif
        next

'        screenset 0,1
'        cls
'        display_ship(0)
'        f=com_display(player, attacker(),0,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
'        rlprint ""


        #ifdef FMODSOUND
        FSOUND_Update
        #endif



    loop until victory<>0 or player.dead=6
    if attacker(16).desig="" and col=10 then atts.con(1)=-1
    player.c=p
    if victory=3 then
        if player.dead<>0 then screenshot(3)
        if atts.ty=1 or atts.ty=3 then player.dead=5 'merchants
        if atts.ty=2 or atts.ty=4 then player.dead=13 'Pirates
        if atts.ty=8 then player.dead=20 'Asteroid belt monster '
        if atts.ty=5 then player.dead=21 'ACSC
        if atts.ty=9 then player.dead=23 'GG monster
        if atts.ty=6 then player.dead=31 'Civ 1
        if atts.ty=7 then player.dead=32 'Civ 2
        if atts.ty=10 then player.dead=35 'Own exhaust
    endif
    if victory=2 then
        player.dead=0
        if atts.ty=ft_pirate or atts.ty=ft_pirate2 then combon(8).value+=noenemies
        if atts.ty<8 then battleslost(atts.ty,0)+=1
        rlprint "All enemy ships fled or destroyed.",c_gre
    endif
    if victory=1 and player.towed<>0 then
        rlprint "You leave behind the ship you had in tow.",14
        player.towed=0
    endif
    if victory=2 or victory=1 then
        for a=0 to lastitem
            if (item(a).ty=67 or item(a).ty=55 or item(a).ty=56) and item(a).w.p<0 then
                b=abs(item(a).w.p)
                if attacker(b).hull<=0 or victory=1 then
                    if victory=1 then rlprint "You leave behind "&add_a_or_an(item(a).desig,0) &".",14
                    destroyitem(a)
                else
                    rlprint "You take "&add_a_or_an(item(a).desig,0) &" on board.",c_gre
                    item(a).w.s=-1
                    item(a).w.p=0
                    item(a).v1=attacker(b).hull
                    attacker(b)=attacker(0)
                endif
            endif
        next
    endif
    for a=1 to 15
        atts.mem(a)=attacker(a)
    next
    for a=1 to 5
        player.weapons(a).reloading=0
        player.weapons(a).heat=0
    next
    player.senac=0
    player.shieldshut=0

    screenset 0,1

    cls
    display_stars(1)
    display_ship(1)
    rlprint ""

    flip
    screenset 1,1

    return 0
end function


function playerfightfleet(f as short) as short
    dim as short a,total,f2,e,ter,x,y
    dim text as string
    dim fname(10) as string
    gen_fname(fname()) 
    
    for a=1 to 9
        basis(10).inv(a).v=0
        basis(10).inv(a).p=0
    next
    for x=player.c.x-1 to player.c.x+1
        for y=player.c.y-1 to player.c.y+1
            if x>=0 and y>=0 and x<=sm_x and y<=sm_y then
                if spacemap(x,y)<>0 then ter+=1
            endif
        next
    next
    if fleet(f).ty=ft_ancientaliens then alliance(0)=1 'From now on we can build alliances
    spacecombat(fleet(f),spacemap(player.c.x,player.c.y)+ter)
    if player.dead=0 and fleet(f).flag>0 then player.questflag(fleet(f).flag)=2
    if player.dead>0 and fleet(f).ty=5 then player.dead=21
    for a=1 to 8
        total=total+basis(10).inv(a).v
    next 
    'rlprint ""&total
    if total>0 and player.dead=0 then trading(10)
    if player.dead=-1 then player.dead=0
    if player.dead>0 then
        for a=1 to 128
            if crew(a).hpmax>0 then player.deadredshirts+=1
        next
'        if fleet(f).ty=2 then player.dead=5
'        if fleet(f).ty=4 then player.dead=5
'        if fleet(f).ty=1 then player.dead=13
'        if fleet(f).ty=3 then player.dead=13
'        if fleet(f).ty=5 then player.dead=31
'        if fleet(f).ty=6 then player.dead=32
'        if fleet(f).ty=7 then player.dead=33
        
    endif
    fleet(f).ty=0
    return 0
end function

