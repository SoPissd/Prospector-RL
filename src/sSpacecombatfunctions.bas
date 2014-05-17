'tSpacecombatfunctions.
'
'defines:
'count_gas_giants_area=4, display_station=0, display_star=24,
', display_stars=22, com_criticalhit=0, com_hit=0, com_side=0,
', com_fire=0, com_NPCfireweapon=0, com_NPCFire=1, com_evaltarget=0,
', com_findtarget=0, com_turn=0, com_add_e_track=0, draw_shield=0,
', com_vismask=0, com_targetlist=0, com_display=1, com_radio=0,
', com_direction=0, com_shipfromtarget=0, com_getweapon=0, com_wstring=0,
', com_gettarget=0, com_dropmine=1, com_regshields=2, com_sinkheat=3,
', com_damship=0, com_detonatemine=3, com_flee=0, com_shipbox=1,
', com_testweap=1, com_mindist=0, com_victory=1, com_NPCMove=2,
', gen_fname=6
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
'     -=-=-=-=-=-=-=- TEST: tSpacecombatfunctions -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tSpacecombatfunctions -=-=-=-=-=-=-=-

Dim Shared combatmap(60,20) As Byte

Dim Shared As Byte com_cheat=0
Const show_enemyships=0

declare function gen_fname(fname() as string) as short
declare function com_NPCFire(defender as _ship,attacker() as _ship) as short
declare function com_display(defender as _ship, attacker() as _ship,  marked as short, e_track_p() as _cords,e_track_v() as short,e_map() as byte,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short) as short
declare function com_dropmine(defender as _ship,mines_p() as _cords,mines_v() as short,byref mines_last as short ,attacker() as _ship) as short
declare function com_regshields(s as _ship) as short
declare function com_sinkheat(s as _ship,manjets as short) as short
declare function com_detonatemine(d as short,mines_p() as _cords, mines_v() as short, byref mines_last as short, defender as _ship, attacker() as _ship) as short
declare function com_shipbox(s as _ship,di as short) as string
declare function com_testweap(w as _weap, p1 as _cords,attacker() as _ship,mines_p() as _cords,mines_last as short,echo as short=0) as short
declare function com_victory(attacker() as _ship) as short
declare function com_NPCMove(defender as _ship,attacker() as _ship,e_track_p() as _cords,e_track_v() as short,e_map() as byte,byref e_last as short) as short

declare function draw_shield(ship as _ship,osx as short) as short
declare function com_criticalhit(t as _ship, roll as short) as _ship
declare function com_hit(target as _ship, w as _weap, dambonus as short, range as short,attn as string,side as short) as _ship
declare function com_side(target as _ship,c as _cords) as short
declare function com_fire(byref target as _ship,byref attacker as _ship,byref w as short, gunner as short, range as short) as _ship
declare function com_NPCfireweapon(byref defender as _ship, byref attacker as _ship,b as short) as short
declare function com_evaltarget(attacker as _ship,defender as _ship) as short
declare function com_findtarget(defender as _ship,attacker() as _ship) as short
declare function com_turn(dircur as byte,dirdest as byte,turnrate as byte) as short
declare function com_add_e_track(ship as _ship,e_track_p() as _cords,e_track_v() as short, e_map() as byte,e_last as short) as short
declare function com_vismask(c as _cords) as short
declare function com_targetlist(list_c() as _cords, list_e() as short, defender as _ship, attacker() as _ship, mines_p() as _cords,mines_v() as short, mines_last as short) as short
declare function com_radio(defender as _ship, attacker() as _ship, e_track_p() as _cords,e_track_v() as short,e_map() as byte,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short)  as short
declare function com_direction(dest as _cords,target as _cords) as short
declare function com_shipfromtarget(target as _cords,defender as _ship,attacker() as _ship) as short
declare function com_getweapon() as short
declare function com_wstring(w as _weap, range as short) as string
declare function com_gettarget(defender as _ship, wn as short, attacker() as _ship,marked as short,e_track_p() as _cords,e_track_v() as short,e_map() as byte,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short) as short
declare function com_damship(byref t as _ship, dam as short, col as short) as _ship
declare function com_flee(defender as _ship,attacker() as _ship) as short
declare function com_mindist(s as _ship) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tSpacecombatfunctions -=-=-=-=-=-=-=-

namespace tSpacecombatfunctions
function init(iAction as integer) as integer
	return 0
end function
end namespace'tSpacecombatfunctions


function gen_fname(fname() as string) as short
    fname(1)="merchant convoy"
    fname(2)="pirate fleet"
    fname(3)="company patrol"
    fname(4)="pirate fleet"
    fname(5)="huge fast ship"
    fname(6)=civ(0).n &" fleet"
    fname(7)=civ(1).n &" fleet"
    fname(8)="space station"
    return 0
end function


function draw_shield(ship as _ship,osx as short) as short
    dim as short i,di,ti,value,x,y
    di=ship.di
    for i=0 to 7
        ti=di-1
        if ti>=5 then ti-=1

        if ship.shieldside(i)>0 then
            value=ship.shieldside(i)-1
            if value>4 then value=4
            if configflag(con_tiles)=0 then
                select case di
                case 1
                    x=(ship.c.x-osx)*_tix-16+4
                    y=ship.c.y*_tiy+16+4
                case 2
                    x=(ship.c.x-osx)*_tix+4
                    y=ship.c.y*_tiy+16+4
                case 3
                    x=(ship.c.x-osx)*_tix+16+4
                    y=ship.c.y*_tiy+16+4
                case 4
                    x=(ship.c.x-osx)*_tix-16+4
                    y=ship.c.y*_tiy+4
                case 6
                    x=(ship.c.x-osx)*_tix+16+4
                    y=ship.c.y*_tiy+4
                case 7
                    x=(ship.c.x-osx)*_tix-16+4
                    y=ship.c.y*_tiy-16+4
                case 8
                    x=(ship.c.x-osx)*_tix+4
                    y=ship.c.y*_tiy-16+4
                case 9
                    x=(ship.c.x-osx)*_tix+16+4
                    y=ship.c.y*_tiy-16+4
                end select
                if x>=0 and y>=0 and x<=_mwx*_tix-16 and y<=20*_tiy then put (x,y),shtiles(ti,value),trans
            else
                _fgcolor_=rgb((ship.shieldside(i)+1)*64,(ship.shieldside(i)+1)*32,0)
                select case di
                case 1
                    draw string ((ship.c.x-osx-1)*_fw1,(ship.c.y+1)*_fh1),"\",,font1,custom,@_tcol
                case 2
                    draw string ((ship.c.x-osx)*_fw1,(ship.c.y+1)*_fh1),"-",,font1,custom,@_tcol
                case 3
                    draw string ((ship.c.x-osx+1)*_fw1,(ship.c.y+1)*_fh1),"/",,font1,custom,@_tcol
                case 4
                    draw string ((ship.c.x-osx-1)*_fw1,(ship.c.y)*_fh1),"|",,font1,custom,@_tcol
                case 6
                    draw string ((ship.c.x-osx+1)*_fw1,(ship.c.y)*_fh1),"|",,font1,custom,@_tcol
                case 7
                    draw string ((ship.c.x-osx-1)*_fw1,(ship.c.y-1)*_fh1),"/",,font1,custom,@_tcol
                case 8
                    draw string ((ship.c.x-osx)*_fw1,(ship.c.y-1)*_fh1),"-",,font1,custom,@_tcol
                case 9
                    draw string ((ship.c.x-osx+1)*_fw1,(ship.c.y-1)*_fh1),"\",,font1,custom,@_tcol
                    '                case 1
'                    draw string ((ship.c.x-osx-1)*_fw1,(ship.c.y+1)*_fh1),""&i,,font1,custom,@_col
'                case 2
'                    draw string ((ship.c.x-osx)*_fw1,(ship.c.y+1)*_fh1),""&i,,font1,custom,@_col
'                case 3
'                    draw string ((ship.c.x-osx+1)*_fw1,(ship.c.y+1)*_fh1),""&i,,font1,custom,@_col
'                case 4
'                    draw string ((ship.c.x-osx-1)*_fw1,(ship.c.y)*_fh1),""&i,,font1,custom,@_col
'                case 6
'                    draw string ((ship.c.x-osx+1)*_fw1,(ship.c.y)*_fh1),""&i,,font1,custom,@_col
'                case 7
'                    draw string ((ship.c.x-osx-1)*_fw1,(ship.c.y-1)*_fh1),""&i,,font1,custom,@_col
'                case 8
'                    draw string ((ship.c.x-osx)*_fw1,(ship.c.y-1)*_fh1),""&i,,font1,custom,@_col
'                case 9
'                    draw string ((ship.c.x-osx+1)*_fw1,(ship.c.y-1)*_fh1),""&i,,font1,custom,@_col
'
                end select
            endif
        endif
        di=bestaltdir(di,1)
    next

    return 0
end function


function com_criticalhit(t as _ship, roll as short) as _ship
    dim as short a,b,l,dam
    dim text as string
    if t.hulltype=-1 then return t
    l=9

        a=rnd_range(1,l)
        if a=1 then
            if t.engine<2 then
                t.engine=1
                a=rnd_range(2,l)
            else
                rlprint "Engine damaged!",12
                t.engine=t.engine-1

            endif
        endif

        if a=2 then
            if t.sensors<2 then
                t.sensors=1
                a=rnd_range(3,l)
            else
                rlprint "Sensors damaged!",12
                t.sensors=t.sensors-1
            endif
        endif

        if a=3 then
            if t.shieldmax>0 then
                rlprint "Shield generator damaged!",12
                t.shieldmax=t.shieldmax-1
            else
                a=rnd_range(3,l)
            endif
        endif

        if a=4 then
            t.h_maxhull-=1
            if t.hull>max_hull(player) then t.hull=max_hull(player)
            rlprint "Critical damage to ship structure!",12
        endif

        if a=5 then
            rlprint "Explosion in cargo bay!",12
            for b=0 to 10
                if t.cargo(b).x>1 then
                    t.cargo(b).x=1
                    exit for
                endif
            next
        endif

        if a=6 then
            b=rnd_range(1,5)
            if t.weapons(b).desig<>"" then
                rlprint t.weapons(b).desig &" hit and destroyed!",12
                if t.desig=player.desig then

                    if t.weapons(b).desig="Fuel tank" then
                        dam=rnd_range(1,6)
                        rlprint "it explodes! "& b &" points of damage!",12
                        player.hull=player.hull-b
                    endif

                    if t.weapons(b).made=84 then
                        dam=rnd_range(1,6)+ rnd_range(1,6)
                        t.hull-=dam
                        rlprint "It explodes! "& b &" points of damage!",12
                    endif

                    if t.weapons(b).desig="Crew Quarters" then
                        b=rnd_range(1,6)
                        t.security=t.security-b
                        if t.security<0 then
                            b=b+t.security
                            t.security=0
                        endif
                        rlprint  b &" casualties!",12
                    endif

                endif
                t.weapons(b)=make_weapon(-1)
                if t.desig=player.desig then recalcshipsbays
            else
                rlprint "weapons turret hit but undamaged!",10
            endif
        endif

        if a=7 then
            if t.desig=player.desig then
                b=rnd_range(1,6)
                t.security=t.security-b
                if t.security<0 then
                    b=b+t.security
                    t.security=0
                endif
                rlprint "Crew quaters hit! "& b &" casualties!",12
                remove_member(b,0)
                player.deadredshirts=player.deadredshirts+b
            else
                rlprint "Crew quaters hit!"
            endif
        endif

        if a=8 then
            rlprint "A direct hit on the bridge!",12

            if t.desig=player.desig then

                if rnd_range(1,6)+ rnd_range(1,6)>7 then
                    b=rnd_range(2,t.h_maxcrew)
                    if crew(b).hp>0 then
                        crew(b).hp=0
                        rlprint "An Explosion! "& crew_desig(crew(b).typ) &" "&crew(b).n &" was killed!",12
                        player.deadredshirts=player.deadredshirts+1
                    endif
                endif
            endif
        endif

        if a=9 then
            rlprint "Fuel system damaged!",c_red
            t.fueluse=t.fueluse*1.1
        endif

    return t
end function


function com_hit(target as _ship, w as _weap, dambonus as short, range as short,attn as string,side as short) as _ship
    dim as string desig, text
    dim as short roll,osx,j,c,sright,sleft,sdam,ad
    if side>4 then
        ad=2
    else
        ad=1
    endif
    sright=bestaltdir(side+ad,1)'Shieldsides are 0-7, bestaltdir=1-4
    sleft=bestaltdir(side+ad,0)
    if sright>4 then
        sright-=2
    else
        sright-=1
    endif
    if sleft>4 then
        sleft-=2
    else
        sleft-=1
    endif
    osx=calcosx(target.c.x,1)
    if target.desig=player.desig then
        desig=player.desig
        c=c_red
    else
        if range>(player.sensors+2)*player.senac then
            desig="?"
            attn="???"
        else
            desig=target.desig
        endif
        rlprint gainxp(3),c_gre
        c=c_gre
    endif
    if target.shieldside(side)>0 then
        select case w.made
        case 6 to 10
            target.shieldside(side)-=fix((w.made-6)/3)
        case 66
            target.shieldside(side)=0
            target.shieldside(sright)=0
            target.shieldside(sleft)=0
        case else
            target.shieldside(side)-=1
            target.shieldside(sright)-=1
            target.shieldside(sleft)-=1
        end select

        if target.shieldside(side)<0 then target.shieldside(side)=0
        if target.shieldside(sright)<0 then target.shieldside(sright)=0
        if target.shieldside(sleft)<0 then target.shieldside(sleft)=0
    endif
    target.shieldside(side)=target.shieldside(side)-w.dam-dambonus
    if target.shieldside(side)<0 then
        if target.shieldmax>0 then
            text=desig &" is hit, shields penetrated! "
        else
            text=desig &" is hit! "
        endif
        target.hull=target.hull+target.shieldside(side)
        text=text &" "& abs(target.shieldside(side)) & " Damage!"
        roll=rnd_range(1,6)+6-target.armortype-target.shieldside(side)
        if roll>8 and target.hull>0 then
            if roll+rnd_range(1,6)>13 then
                text=text & " Critical hit!"
                rlprint text,c
                target=com_criticalhit(target,roll)
            endif
        else
            if w.p>0 then
                if w.ammomax>0 then
                    rlprint attn &" fires "& ammotypename(dambonus) &". " & text,c
                else
                    rlprint attn &" fires "&w.desig &". " & text,c
                endif
            else
                rlprint attn &" "&w.desig &", " & text,c
            endif
        endif
        text=""
        'no_key=keyin
    endif
    if target.shieldside(side)=0 and w.ammomax=0 and w.p>0 then text=w.desig &" fired, "&desig &" is hit, shields are down!"
    if target.shieldside(side)=0 and w.ammomax>0 and w.p>0 then text=ammotypename(dambonus) &" fired, "&desig &" is hit, shields are down!"
    if target.shieldside(side)=0 and w.p<=0 then text=attn &" "&desig &" is hit, shields are down!"
    if target.shieldside(side)>0 and w.ammomax=0 and w.p>0 then text=w.desig &" fired, "&desig &" is hit, but shields hold!"
    if target.shieldside(side)>0 and w.ammomax>0 and w.p>0 then text=ammotypename(dambonus) &" fired, "&desig &" is hit, but shields hold!"
    if target.shieldside(side)>0 and w.p<=0 then text=w.desig &" "&desig &" is hit, but shields hold!"

    if configflag(con_tiles)=0 then
        'tScreen.set(1)
        if target.c.x-osx>=0 and target.c.x-osx<=_mwx then
            if distance(target.c,player.c)<(player.sensors+2)*player.senac then
                for j=1 to 8
                    put ((target.c.x-osx)*_tix,target.c.y*_tix),gtiles(gt_no(76+j)),trans
                    sleep 5
                next
            endif
        endif
    endif
    if text<>"" then rlprint text,c
    'if text<>"" then no_key=keyin
    if target.shieldside(side)<0 then target.shieldside(side)=0
    return target
end function


function com_side(target as _ship,c as _cords) as short
    dim as _cords c2
    dim as short r,di,i
    di=target.di
    while abs(c.x-target.c.x)>1 or abs(c.y-target.c.y)>1
        if c.x>target.c.x then c.x-=1
        if c.y>target.c.y then c.y-=1
        if c.x<target.c.x then c.x+=1
        if c.y<target.c.y then c.y+=1
    wend

    for i=0 to 7
        c2=movepoint(target.c,di)
        if c2.x=c.x and c2.y=c.y then return i
        di=bestaltdir(di,1)
    next
    return 0
end function


function com_fire(byref target as _ship,byref attacker as _ship,byref w as short, gunner as short, range as short) as _ship
    dim del as _weap
    dim wp(255) as _cords
    dim as short roll,a,ROF,dambonus,rangebonus,tohitbonus,i,l,c,osx,j,col,col2,col3,firefree
    'tScreen.set(1)
    if target.desig=player.desig then
        col=c_gre
        col2=c_yel
        col3=c_red
    else
        col=c_yel
        col2=c_gre
        col3=c_gre
    endif


    osx=calcosx(player.c.x,1)
    dim weapon as _weap
    weapon= attacker.weapons(w)
    ROF= weapon.ROF
    
    for a=1 to 25
        if attacker.weapons(a).made=91 then dambonus+=1
        if attacker.weapons(a).made=92 then dambonus+=2
        if attacker.weapons(a).made=93 then tohitbonus+=1
        if attacker.weapons(a).made=94 then tohitbonus+=2
    next
    if distance(target.c,attacker.c)<(attacker.sensors+2)*attacker.senac then
        if weapon.ammomax>0 and ROF>0 Then	play_sound(7) 	'Laser        	
        if weapon.ammomax>0 and ROF=0 then	play_sound(8)	'Missile battery
        if weapon.ammomax=0 then 			play_sound(9)	'Missile
    endif
    do
        firefree=0
        if attacker.weapons(w).ammo=0 then
            firefree=1
        else
            if attacker.useammo then firefree=1
        endif

        if firefree=1 then
            if attacker.weapons(w).ammomax=0 then
                if attacker.weapons(w).made=66 then
                    attacker.e.add_action(attacker.weapons(w).dam/2)
                else
                    attacker.e.add_action(attacker.weapons(w).dam) '
                endif
            endif
            attacker.weapons(w).heat=attacker.weapons(w).heat+attacker.weapons(w).heatadd*10
            attacker.weapons(w).reloading+=attacker.weapons(w).reload
            if skill_test(gunner,attacker.weapons(w).heat/25) then
                rangebonus=0
                if range<=attacker.weapons(w).range*2 then rangebonus+=1
                if range<=attacker.weapons(w).range then rangebonus+=2
                if skill_test(gunner+attacker.senac+tohitbonus+rangebonus-target.pilot(0)/2-(target.equipment(se_ecm)*attacker.weapons(w).ecmmod),st_average,_
                attacker.desig &" fires "&attacker.weapons(w).desig) then
                    if attacker.weapons(w).ammomax=0 then
                        c=185
                    else
                        c=7
                    endif
                    if distance(target.c,player.c)<(player.sensors+2)*player.senac and distance(target.c,player.c)>0 then

                        l=line_in_points(target.c,attacker.c,wp())
                        for i=1 to l-1
                            if combatmap(wp(i).x,wp(i).y)>0 then roll-=1
                            sleep 5
                            set__color( c,0)
                            if configflag(con_tiles)=0 then
                                if attacker.weapons(w).ammomax=0 then
                                    put ((wp(i).x-osx)*_tix,wp(i).y*_tix),gtiles(gt_no(75)),trans
                                else
                                    put ((wp(i).x-osx)*_tix,wp(i).y*_tix),gtiles(gt_no(76)),trans
                                endif
                            else
                                draw string((wp(i).x-osx)*_fw1,wp(i).y*_fh1), "*",,Font1,custom,@_col
                            endif
                        next

                        if l>1 then
                            wp(255)=wp(1)
                        else
                            wp(255)=attacker.c
                        endif
                    endif
                    if attacker.weapons(w).ammomax=0 then
                        target=com_hit(target,attacker.weapons(w),dambonus,range,attacker.desig,com_side(target,wp(255)))
                        c=185
                    else
                        target=com_hit(target,attacker.weapons(w),attacker.loadout,range,attacker.desig,com_side(target,wp(255)))
                        c=7
                    endif

                else
                    if distance(target.c,player.c)<(player.sensors+2)*player.senac then
                        l=line_in_points(movepoint(target.c,5),attacker.c,wp())
                        if attacker.weapons(w).ammomax=0 then
                            c=185
                        else
                            c=7
                        endif
                        for i=1 to l-1
                            sleep 5
                            if configflag(con_tiles)=0 then
                                if attacker.weapons(w).ammomax=0 then
                                    put ((wp(i).x-osx)*_tix,wp(i).y*_tix),gtiles(gt_no(75)),trans
                                else
                                    put ((wp(i).x-osx)*_tix,wp(i).y*_tix),gtiles(gt_no(76)),trans
                                endif
                            else
                                draw string((wp(i).x-osx)*_fw1,wp(i).y*_fh1), "*",,Font1,custom,@_col
                            endif
                        next
                        if attacker.weapons(w).p>0 then
                            if attacker.weapons(w).ammomax>0 then
                                if configflag(con_showrolls)=1 then rlprint attacker.desig &" fires "&ammotypename(attacker.loadout) &", and misses!",col
                            else
                                if configflag(con_showrolls)=1 then rlprint attacker.desig &" fires "&attacker.weapons(w).desig &", and misses!",col
                            endif
                        else
                            if configflag(con_showrolls)=1 then rlprint "It missed.",col
                        endif
                    endif
                endif
            else
                rlprint attacker.weapons(w).desig &" shuts down due to heat.",col
                attacker.weapons(w).shutdown=1
                if not(skill_test(gunner,attacker.weapons(w).heat/20,"Gunner:Shutdown")) then
                    rlprint attacker.weapons(w).desig &" is irreperably damaged."&attacker.weapons(w).heat/20,col3
                    attacker.weapons(w)=del
                endif
            endif
        endif
        ROF-=1
    loop until ROF<=0
    return target
end function

function com_NPCfireweapon(byref defender as _ship, byref attacker as _ship,b as short) as short
    if attacker.weapons(b).reloading<=0 then
    	if distance(attacker.c,defender.c)<attacker.weapons(b).range*3 then
	        if pathblock(attacker.c,defender.c,0,2,attacker.weapons(b).col)=-1 then
	            defender=com_fire(defender,attacker,b,attacker.gunner(0),distance(attacker.c,defender.c))
	            display_ship(0)
	        endif
	    endif
    endif
    return 0
end function


function com_NPCFire(defender as _ship,attacker() as _ship) as short
    dim as short a,b,t,d
	for a=1 to 14
    	if attacker(a).hull>0 then
			for b=0 to 25
				if attacker(a).weapons(b).desig<>"" then
					if attacker(a).weapons(b).heat<5*attacker(a).gunner(0) then
						'waffe forhanden
                        t=attacker(a).target.m
                        if t>=0 then
                            if t=0 then
                                d=distance(defender.c,attacker(a).c)
                            else
                                d=distance(attacker(a).c,attacker(t).c)
                            endif
                        	if d<=attacker(a).sensors then
                                if t=0 then com_NPCFireweapon(defender,attacker(a),b)
                                if t>0 then com_NPCFireweapon(attacker(t),attacker(a),b)
                        	endif
                        endif
					endif
				endif
			next b
    	endif
    next a
    return 0
end function


function com_evaltarget(attacker as _ship,defender as _ship) as short
    dim as short d,h
    if attacker.aggr=defender.aggr then return -1 'Ships are in the same group
    if distance(attacker.c,defender.c)>attacker.sensors*attacker.senac+defender.sensors*(defender.senac-1) then return -1
    return distance(attacker.c,defender.c)*10/defender.hull
end function


function com_findtarget(defender as _ship,attacker() as _ship) as short
    dim targettable(14,14) as short
    dim as short a,b,t,v,dx,dy
    for a=1 to 14
        if attacker(a).hull>0 then
            if attacker(a).shiptype=0 or attacker(a).shiptype=2 then
                attacker(a).target.x=-1
                attacker(a).target.y=-1
                targettable(a,0)=com_evaltarget(attacker(a),defender)
                if targettable(a,0)>0 then
                    t=0
                    v=targettable(a,0)
                else
                    t=-1
                    v=0
                endif
                for b=1 to 14
                    if b<>a then
                        targettable(a,b)=com_evaltarget(attacker(a),attacker(b))
                        if targettable(a,b)>v then
                            t=b
                            v=targettable(a,b)
                        endif
                    endif
                next
                if t>0 then attacker(a).target=attacker(t).c
                if t=0 then attacker(a).target=defender.c
                if t=-1 then
                    attacker(a).target=rnd_point
                    attacker(a).senac=2
                else
                    attacker(a).senac=1
                endif
                dx=(attacker(a).target.x-attacker(a).c.x)
                dy=(attacker(a).target.y-attacker(a).c.y)
                if dx>0 then dx=-1
                if dx<0 then dx=+1
                if dy<0 then dy=-1
                if dy>0 then dy=+1
                attacker(a).target.x+=dx
                attacker(a).target.y+=dy
                if attacker(a).target.x<0 then attacker(a).target.x=0
                if attacker(a).target.x>60 then attacker(a).target.x=60
                if attacker(a).target.y<0 then attacker(a).target.y=0
                if attacker(a).target.y>20 then attacker(a).target.y=20
                attacker(a).target.m=t
            else
                attacker(a).target.x=0
                attacker(a).target.y=rnd_range(1,20)
                attacker(a).target.m=attacker(a).aggr
            endif
        endif
    next
    return 0
end function


function com_turn(dircur as byte,dirdest as byte,turnrate as byte) as short
    'Returns the direction to get from dircur to dirdest
    DimDebug(0)
    dim as short disright,disleft,tdir,rightleft,f

#if __FB_DEBUG__
    if debug=1 then
        f=freefile
        open "turningdata.csv" for output as #f
    endif
#endif



    if turnrate=-1 then return dircur 'Probes can't turn
    if dircur<>dirdest  then

        tdir=dircur
        do
            tdir=bestaltdir(tdir,0)
            disright+=1
#if __FB_DEBUG__
            if debug=1 then print #f,dirdest &";"&tdir
#endif
        loop until tdir=dirdest or disright>9

        tdir=dircur
        do
            tdir=bestaltdir(tdir,1)
            disleft+=1
#if __FB_DEBUG__
            if debug=1 then print #f,dirdest &";"&tdir
#endif
        loop until tdir=dirdest or disleft>9
        '
        if disright=disleft then
            return bestaltdir(dircur,rnd_range(0,1))
        else
            if disright<disleft then rightleft=0'return bestaltdir(dircur,0)
            if disright>disleft then rightleft=1'return bestaltdir(dircur,1)
            do
                dircur=bestaltdir(dircur,rightleft)
                turnrate-=1
            loop until dircur=dirdest or turnrate=0
            return dircur
        endif
    endif
#if __FB_DEBUG__
    if debug=1 then close #f
#endif
    return dirdest
end function


function com_add_e_track(ship as _ship,e_track_p() as _cords,e_track_v() as short, e_map() as byte,e_last as short) as short
    dim p as _cords
    dim i as short
    p=ship.c
    p=movepoint(p,ship.diop())
    if p.x<0 or p.x>60 or p.y<0 or p.y>60 then return e_last
    e_last+=1
    if e_last>128 then
        e_last=1
    endif
    e_track_p(e_last).x=p.x
    e_track_p(e_last).y=p.y
    e_track_p(e_last).m=ship.aggr'Who did it?
    e_track_v(e_last)=ship.engine+2
    e_map(p.x,p.y)=e_last
    return e_last
end function


function com_vismask(c as _cords) as short
    dim as short x,y,d,i,mask
    for x=0 to 60
        for y=0 to 20
            vismask(x,y)=0
        next
    next

    dim as _cords p,pts(128)
        for x=c.x-20 to c.x+20
        for y=c.y-20 to c.y+20
            if x=c.x-20 or x=c.x+20 or y=c.y-20 or y=c.y+20 then
                mask=1
                p.x=x
                p.y=y
                d=line_in_points(p,c,pts())
                for i=1 to d
                    if pts(i).x>=0 and pts(i).x<=60 and pts(i).y>=0 and pts(i).y<=20 then
                        if mask>0 then
                            vismask(pts(i).x,pts(i).y)=1
                        else
                            vismask(pts(i).x,pts(i).y)=0
                        endif
                        if combatmap(pts(i).x,pts(i).y)>0 and distance(c,pts(i))>player.sensors*player.senac then mask=0
                    endif
                next

            endif
        next
    next
    vismask(c.x,c.y)=1
    return 0
end function


function com_targetlist(list_c() as _cords, list_e() as short, defender as _ship, attacker() as _ship, mines_p() as _cords,mines_v() as short, mines_last as short) as short
    dim as short a,last
    for a=1 to 14
        if attacker(a).hull>0 and distance(attacker(a).c,defender.c)<=(defender.sensors+2)*defender.senac and vismask(attacker(a).c.x,attacker(a).c.y)=1 then
            last+=1
            list_c(last)=attacker(a).c
            list_e(last)=a
        endif
    next
    if mines_last>0 then
        for a=1 to mines_last
            if distance(mines_p(a),defender.c)<=(defender.sensors+2)*defender.senac and vismask(mines_p(a).x,mines_p(a).y)=1 then
                last+=1
                list_c(last)=mines_p(a)
                list_e(last)=100+a
            endif
        next
    endif
    if last>1 then sort_by_distance(defender.c,list_c(),list_e(),last)
    return last
end function


function com_display(defender as _ship, attacker() as _ship,  marked as short, e_track_p() as _cords,e_track_v() as short,e_map() as byte,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short) as short
    DimDebug(0)'2
    dim as short x,y,a,b,c,f,osx
    dim as single d
    dim p1 as _cords
    dim as short senbat,senbat1,senbat2
    dim as _cords p,pts(128),list_c(64)
    dim list_e(128) as short
    dim last as short

    osx=calcosx(defender.c.x,1)
    com_vismask(player.c)
    last=com_targetlist(list_c(),list_e(),defender,attacker(),mines_p(),mines_v(),mines_last)
    senbat =(defender.sensors+2)*defender.senac
    senbat1=(defender.sensors+1)*defender.senac
    senbat2= defender.sensors   *defender.senac

    for x=defender.c.x-senbat-1 to defender.c.x+senbat+1
        for y=defender.c.y-senbat-1 to defender.c.y+senbat+1
            if x>=osx and y>=0 and x<=_mwx+osx and x<=60 and x>=0 and y<=20 then
                p1.x=x
                p1.y=y
                if vismask(p1.x,p1.y)=1 then
                    'draw string((x-osx)*_fw1,y*_fh1)," ",,font1,custom,@_col
                    if distance(p1,defender.c)<=senbat or com_cheat=1 then
                        if configflag(con_tiles)=0 then
                            if distance(p1,defender.c)<=senbat and combatmap(x,y)=0 then put ((x-osx)*_tix,y*_tiy),gtiles(78),trans
                            if distance(p1,defender.c)<=senbat1 and combatmap(x,y)=0 then put ((x-osx)*_tix,y*_tiy),gtiles(79),trans
                            if distance(p1,defender.c)<=senbat2 and combatmap(x,y)=0 then put ((x-osx)*_tix,y*_tiy),gtiles(80),trans
                            if combatmap(x,y)=1 or combatmap(x,y)=6 then put ((x-osx)*_tix,y*_tiy),gtiles(76),trans
                            if (combatmap(x,y)>1 and combatmap(x,y)<6) or combatmap(x,y)=7 then put ((x-osx)*_tix,y*_tiy),gtiles(51),trans
                        else
                            if distance(p1,defender.c)<=senbat then set__color( 8,0)
                            if distance(p1,defender.c)<=senbat1 then set__color( 7,0)
                            if distance(p1,defender.c)<=senbat2 then set__color( 15,0)
                            if combatmap(x,y)=0 then draw string(x*_fw1,y*_fh1),".",,font1,custom,@_col
                            if combatmap(x,y)=1 or combatmap(x,y)=6 then draw string(x*_fw1,y*_fh1),chr(167),,font1,custom,@_col
                            if (combatmap(x,y)>1 and combatmap(x,y)<6) or combatmap(x,y)=7 then
                                set__color( rnd_range(48,59),0)
                                if combatmap(x,y)=7 then set__color( rnd_range(186,210),0)
                                draw string(x*_fw1,y*_fh1), chr(176),,font1,custom,@_col
                            endif
                        endif
                    endif
                endif
            endif
        next
    next
    if e_last>0 then
        for b=1 to e_last
            if vismask(e_track_p(b).x,e_track_p(b).y)=1 then
                if distance(e_track_p(b),defender.c)<=senbat+e_track_v(b)*2 and e_track_v(b)>0 then
                    if configflag(con_tiles)=0 then
                        if e_track_v(b)>6 then put ((e_track_p(b).x-osx)*_tix,e_track_p(b).y*_tiy),gtiles(81),trans
                        if e_track_v(b)=5 or e_track_v(b)=6 then put ((e_track_p(b).x-osx)*_tix,e_track_p(b).y*_tiy),gtiles(82),trans
                        if e_track_v(b)=3 or e_track_v(b)=4 then put ((e_track_p(b).x-osx)*_tix,e_track_p(b).y*_tiy),gtiles(83),trans
                        if e_track_v(b)=1 or e_track_v(b)=2 then put ((e_track_p(b).x-osx)*_tix,e_track_p(b).y*_tiy),gtiles(84),trans
#if __FB_DEBUG__
                        if debug=2 then draw string(_tix+(e_track_p(b).x-osx)*_fw1,_tiy+e_track_p(b).y*_fh1),"B"& b &"V:"&e_track_v(b),,font1,custom,@_tcol
#endif
                    else
                        set__color( 0,0)
                        if e_track_v(b)>6 then set__color( 15,0)
                        if e_track_v(b)=5 or e_track_v(b)=6 then set__color( 11,0)
                        if e_track_v(b)=3 or e_track_v(b)=4 then set__color( 9,0)
                        if e_track_v(b)=1 or e_track_v(b)=2 then set__color( 1,0 )
                        draw string(e_track_p(b).x*_fw1,e_track_p(b).y*_fh1),"*",,font1,custom,@_col
                    endif
                endif
            endif
        next
    endif

    for c=1 to last
        if list_e(c)<100 then
            b=list_e(c)
            if vismask(attacker(b).c.x,attacker(b).c.y)=1 then
                if distance(attacker(b).c,defender.c)<=senbat1 then attacker(b).questflag(11)=1
                if configflag(con_tiles)=0 then
#if __FB_DEBUG__
                    if debug=1 then
                        f=freefile
                        open "tileerror" for output as #f
                        print #f,"attacker(b).di " &attacker(b).di &"attacker(b).ti_no:"&attacker(b).ti_no
                        close #f
                    endif
#endif
                    if attacker(b).di=0 then attacker(b).di=rnd_range(1,8)
                    if attacker(b).di=5 then attacker(b).di=9
                    d=distance(attacker(b).c,defender.c)
                    if d>=senbat1 and d<senbat then
                        put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),gtiles(86),trans
                    endif
                    if d<=senbat1 or d<=1.4 or show_enemyships=1 then
                        if attacker(b).aggr=0 then 'Friend/Foe
                            put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),gtiles(gt_no(87)),trans
                        else
                            put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),gtiles(gt_no(88)),trans
                        endif
                        put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),stiles(attacker(b).di,attacker(b).ti_no),trans
                        draw_shield(attacker(b),osx)
                    endif
                    if c=marked then
                        put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),gtiles(85),trans
                    endif
#if __FB_DEBUG__
                    if debug=3 then
                        if attacker(b).target.x<>0 then
                            line ((attacker(b).c.x-osx)*_tix+_tix/2,attacker(b).c.y*_tiy+_tiy/2)-((attacker(b).target.x-osx)*_tix+_tix/2,attacker(b).target.y*_tiy+_tiy/2),rgb(255,0,0)
                        endif
                    endif
#endif

                else
                    if b=marked then
                        set__color( attacker(b).bcol,attacker(b).col)
                    else
                        set__color( attacker(b).col,attacker(b).bcol)
                    endif
                    if distance(attacker(b).c,defender.c)<senbat then
                        draw string(attacker(b).c.x*_fw1,attacker(b).c.y*_fh1),"?",,font1,custom,@_col
                    endif
                    if distance(attacker(b).c,defender.c)<=senbat1 or distance(attacker(b).c,defender.c)<=sqr(2) or show_enemyships=1 then
                        draw string(attacker(b).c.x*_fw1,attacker(b).c.y*_fh1),attacker(b).icon,,font1,custom,@_col
                        draw_shield(attacker(b),osx)
                    endif
                endif
            endif
        else 'Mines
            b=list_e(c)-100
            if vismask(mines_p(b).x,mines_p(b).y)=1 then
                if configflag(con_tiles)=0 then
                    if distance(mines_p(b),defender.c)<=senbat then
                        put ((mines_p(b).x-osx)*_fw1,mines_p(b).y*_fh1),gtiles(gt_no(item(mines_v(b)).ti_no)),trans
                    endif
                    if c=marked then put ((mines_p(b).x-osx)*_fw1,mines_p(b).y*_fh1),gtiles(85),trans
                else
                    if c=marked then
                        set__color( 8,11)
                    else
                        set__color( 8,0)
                    endif
                    if distance(mines_p(b),defender.c)<=senbat then
                        draw string(mines_p(b).x*_fw1,mines_p(b).y*_fh1),"m",,font1,custom,@_col
                    endif
                endif
            endif
        endif
    next
    draw_shield(defender,osx)
    if configflag(con_tiles)=0 then
        put ((defender.c.x-osx)*_tix,defender.c.y*_tiy),stiles(player.di,player.ti_no),trans
#if __FB_DEBUG__
        if debug=2 then draw string((defender.c.x-osx)*_fw1+_fw1,defender.c.y*_fh1),defender.c.x &":"&defender.c.y,,font2,custom,@_col
#endif
    else
        set__color( _shipcolor,0)
        draw string(defender.c.x*_fw1,defender.c.y*_fh1),"@",,font1,custom,@_col
    endif
    'tScreen.update()
    return last
end function


function com_radio(defender as _ship, attacker() as _ship, e_track_p() as _cords,e_track_v() as short,e_map() as byte,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short)  as short
    dim as short victory,hp,a,cargo,od,friendly(14),friendlies,osx
    dim as string text
    dim as string no_key
    dim p as _cords
    for a=0 to 15
        if attacker(a).hull>0 then
            if attacker(a).aggr<>1 then
                hp+=attacker(a).hull
            else
                friendlies+=1
                friendly(friendlies)=a
            endif
        endif
    next
    for a=0 to 10
        if player.cargo(a).x>1 then cargo+=1
    next
    od=player.dead
    player.dead=0
    if friendlies>0 then
        for a=1 to friendlies
            text=text &"Call "&attacker(friendly(a)).desig &"("&attacker(friendly(a)).c.x &":"& attacker(friendly(a)).c.y & ")/"
        next
    endif
    text="Calling other ships/" &text &"Ask oppenents for surrender/Offer surrender to opponents/Never mind"
    a=textmenu(bg_ship,text,"",2,2)
    player.dead=od
    select case a
    case is<=friendlies
        osx=calcosx(p.x,1)
        rlprint "Set target for "&attacker(friendly(a)).desig &"."
        p=attacker(friendly(a)).c
        do
            tScreen.set(0)
            cls
            osx=calcosx(player.c.x,1)
            com_display(player, attacker(),0,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
            tScreen.update()
            no_key=cursor(p,-1,osx)
        loop until no_key=key__esc or no_key=key__enter
        if no_key=key__enter then attacker(friendly(a)).target=p
        rlprint "Target set "&attacker(friendly(a)).target.x &":"& attacker(friendly(a)).target.y & ". Roger."
    case is=1+friendlies
        if hp<player.hull+rnd_range(0,player.hull) then
            rlprint "They agree"
            victory=1
        else
            rlprint "They don't agree"
        endif
    case is=2+friendlies
        if cargo>0 then
            if askyn("Do you agree to give up your cargo?(y/n)") then
                victory=2
                for a=0 to 10
                    if player.cargo(a).x>0 then player.cargo(a).x=1
                    player.cargo(a).y=0
                next
            else
                rlprint "They refuse."
            endif
        else
            rlprint "You have nothing to offer"
        endif
    end select

    return victory
end function


function com_direction(dest as _cords,target as _cords) as short
    DimDebugL(0)
    dim as short dx,dy,direction,osx
    dx=target.x-dest.x
    dy=target.y-dest.y
    if dx<0 and dy>0 then direction=1
    if dx=0 and dy>0 then direction=2
    if dx>0 and dy>0 then direction=3
    if dx<0 and dy=0 then direction=4
    if dx>0 and dy=0 then direction=6
    if dx<0 and dy<0 then direction=7
    if dx=0 and dy<0 then direction=8
    if dx>0 and dy<0 then direction=9
#if __FB_DEBUG__
    if debug=1 then
        set__color(11,0)
        tScreen.set(1)
        osx=calcosx(player.c.x,1)
        draw string((target.x-osx)*_fw1,target.y*_fh1),""&direction,,font1,custom,@_col
    endif
#endif
    return direction
end function


function com_shipfromtarget(target as _cords,defender as _ship,attacker() as _ship) as short
    dim a as short
    if defender.c.x=target.x and defender.c.y=target.y then return -1
    for a=1 to 14
        if attacker(a).hull>0 and attacker(a).c.x=target.x and attacker(a).c.y=target.y then return a
    next
    return 0
end function

function com_getweapon() as short
    dim as short a,c,lastslot,re,r
    dim as string no_key
    static as short m,d
    if m=0 then m=1
    c=0
    if d=0 then d=1
    for a=1 to player.h_maxweaponslot

        if player.weapons(a).dam>0 then
            if (player.weapons(a).ammo>0 or player.weapons(a).ammomax=0) and player.weapons(a).reloading=0 and player.weapons(a).shutdown=0 then
                c+=1 'waffe braucht ammo und hat keine
                lastslot=a
            endif
            if player.weapons(a).reloading>0 then re+=1
        endif
    next
    if c=0 then
        if re=0 then
            rlprint "You do not have any weapons you can fire!",14
        else
            rlprint "All your weapons are reloading or recharging at this time.",14
        endif
        return 0
    endif
'    if c=1 then
'        display_ship_weapons(lastslot)
'        return lastslot
'    endif
    do
        display_ship_weapons(m)
        rlprint ""
        no_key=uConsole.Keyinput(key__esc & key__enter &key__up &key__lt &key__dn &key__rt &"+-123456789")
'        no_key=keyin(key__esc & key__enter &key__up &key__lt &key__dn &key__rt &"+-123456789")
        if uConsole.keyplus(no_key) then m+=1
        if uConsole.keyminus(no_key) then m-=1
        if m<1 then m=lastslot
        if m>lastslot then m=1
    loop until no_key=key__esc or no_key=key__enter
    if no_key=key__enter then
        r=m
        m+=1
        if m<1 then m=lastslot
        if m>lastslot then m=1
        return r
    endif
    return 0
end function


function com_wstring(w as _weap, range as short) as string
    dim text as string
    if range<=w.range*3 then text=" is at long range for "&w.desig
    if range<=w.range*2 then text=" is at medium range for "&w.desig
    if range<=w.range then text=" is at optimum range for "&w.desig
    return text &"."
end function


function com_gettarget(defender as _ship, wn as short, attacker() as _ship,marked as short,e_track_p() as _cords,e_track_v() as short,e_map() as byte,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short) as short



    dim as short a,d,ex,sort
    dim as short senbat,senbat1,senbat2
    dim as string key,text,id
    dim list_c(128) as _cords
    dim list_e(128) as short
    dim last as short
    senbat=(defender.sensors+2)*defender.senac
    senbat1=(defender.sensors+1)*defender.senac
    senbat2=(defender.sensors)*defender.senac
    com_vismask(defender.c)
    last=com_targetlist(list_c(),list_e(),defender,attacker(),mines_p(),mines_v(),mines_last)
    if last=1 then return list_e(1)
    if marked=0 and last>0 then marked=1

    do
        if marked<1 then marked=last
        if marked>last then marked=1

        tScreen.set(0)
        cls
        display_ship(0)
        a=com_display(defender,attacker(),marked,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
        tScreen.update()
        if last>1 then 'More than 1ships to target
            text="+/- to move, enter to select, esc to skip. "&last
            if list_e(marked)<100 then
                if distance(defender.c,attacker(list_e(marked)).c)<senbat then id="?"
                if distance(defender.c,attacker(list_e(marked)).c)<senbat1 then id=attacker(marked).desig
                text=text &ucase(left(id,1))&right(id,len(id)-1) &com_wstring(defender.weapons(wn),distance(attacker(list_e(marked)).c,defender.c))
            endif
            if list_e(marked)>100 then
                text="Mine "&com_wstring(defender.weapons(wn),distance(list_c(marked),defender.c))
            endif
            if text<>"" then rlprint text
            key=uConsole.Keyinput("+-"&key__esc &key__enter) ',1)
'            key=keyin("+-"&key__esc &key__enter,1)
            if uConsole.keyplus(key) then marked+=1
            if uConsole.keyminus(key) then marked-=1
            if key=key__enter then return list_e(marked)
            if key=key__esc or ex>last then return -1

        endif

    loop until a=0 or last=0
    return -1
end function


function com_dropmine(defender as _ship,mines_p() as _cords,mines_v() as short,byref mines_last as short ,attacker() as _ship) as short
    dim p as _cords
    dim del as _ship
    dim as short a,b,c,mine,mtype(15),no(15),storedead,dam,i,impmine
    dim mdesig(15) as _items
    dim as string text,key
    c=get_item_list(mdesig(),no(),67,40,55,56)
    for a=1 to c
        if no(a)<0 then
            for b=a to c
                no(b)=no(b+1)
                mdesig(b)=mdesig(b+1)
            next
            c-=1
        endif
    next
    for a=1 to c
        if no(a)>0 then
            if no(a)>1 then
                text=text &"/"&no(a) &" " &mdesig(a).desigp
            else
                text=text &"/"&mdesig(a).desig
            endif
#if __FB_DEBUG__
            text=text &mdesig(a).w.s
#endif
        endif
    next
#if __FB_DEBUG__
    crew(2).talents(13)=1
#endif
    if add_talent(2,13,1)>0 then
        text=text &"/Improvised mine"
        impmine=c+1
    endif
    if text<>"" then
        text="Choose mine or drone:"&text &"/Exit"
        storedead=player.dead
        player.dead=0
        a=textmenu(bg_ship,text)
        player.dead=storedead
        if a<=0 or a>maximum(c,impmine) then return 0
        if a=impmine and (add_talent(2,13,1)>0) then
            b=5-add_talent(2,13,1)
            if b<1 then b=1
            if player.fuel>=b then
                player.fuel=player.fuel-b
                mine=placeitem(make_item(74),0,0,0,0,-1)
                item(mine).v1+=add_talent(2,13,1)
            else
                rlprint "You don't have enough fuel to improvise a mine."
            endif
        else
            mine=mdesig(a).w.s
        endif
    else
        rlprint "You don't have mines or drones",c_yel
        return 0
    endif
    rlprint "Dropping "&item(mine).desig &" Direction?"
    key=uConsole.Keyinput("12345678")
'    key=keyin("12345678")
    a=uConsole.getdirection(key)
    if a>0 then
        p=movepoint(defender.c,a)
        if item(mine).ty=40 then
            mines_last+=1
            if mines_last<=128 then
                mines_p(mines_last).x=p.x
                mines_p(mines_last).y=p.y
                mines_v(mines_last)=mine
                item(mine).w.s=0
            endif
        else
            'Add drone as ship
            for a=1 to 14
                if attacker(a).hull<=0 then
                    i=a
                    exit for
                endif
            next

            if i<=14 then
                attacker(i)=attacker(0)
                item(mine).w.s=0
                item(mine).w.p=-i 'Store drone position in attacker list
                attacker(i).desig=item(mine).desig
                attacker(i).col=c_gre
                attacker(i).hull=item(mine).v1
                attacker(i).c=p
                attacker(i).aggr=1
                attacker(i).di=a
                attacker(i).icon=item(mine).icon
                if item(mine).ty=55 or item(mine).ty=56 then
                    attacker(i).engine=1
                    attacker(i).turnrate=-1
                    attacker(i).ti_no=50
                else
                    attacker(i).weapons(1).desig="Plasma cannon"
                    attacker(i).weapons(1).dam=item(mine).v2
                    attacker(i).weapons(1).range=item(mine).v3
                    attacker(i).weapons(1).heatadd=3
                    attacker(i).weapons(1).reload=8
                    attacker(i).weapons(1).heatsink=1
                    attacker(i).engine=item(mine).v4
                    attacker(i).ti_no=51
                    attacker(i).turnrate=1
                    attacker(i).sensors=4
                    attacker(i).shieldmax=item(mine).v6
                    attacker(i).senac=1
                    attacker(i).pigunner=3
                    attacker(i).pipilot=player.pilot(15)-1
                endif
                p=movepoint(attacker(i).c,attacker(i).diop)
                if p.x=player.c.x and p.y=player.c.y then
                    attacker(i).di+=1
                    if attacker(i).di>9 or attacker(i).di=5 then attacker(i).di=1
                endif
            endif


        endif
    endif
    return 0
end function

function com_regshields(s as _ship) as short
    dim as short a,i,low,r
    dim shieldreg as short
    if s.shieldmax=0 or s.shieldshut=1 then return 0
    shieldreg=1
    for a=1 to 25
        if s.weapons(a).made=90 then shieldreg+=1
    next
    do
        low=s.shieldmax
        r=-1
        for i=7 to 0 step -1 'Favors front shields
            if s.shieldside(i)<low and (i<>4) then
                low=s.shieldside(i)
                r=i
            endif
        next
        if r>-1 and shieldreg>0 then
            s.shieldside(r)+=1
            shieldreg-=1
            s.e.add_action(1)
        endif
    loop until r=-1 or shieldreg=0
    return 0
end function


function com_sinkheat(s as _ship,manjets as short) as short
    dim as short a,sink,heat,shieldreg
    sink=s.h_maxweaponslot
    for a=1 to 25
        sink=sink+s.weapons(a).heatsink
        if s.weapons(a).made=90 then shieldreg=2
    next
    if sink>0 and manjets>0 then
        sink=sink-s.manjets*(manjets+1)
    endif
    for a=0 to 7
        if sink>0 and s.shieldside(a)<s.shieldmax then
            sink-=1
        endif
    next
    if sink<=0 then sink=1
    sink=sink*3
    do
        heat=0
        for a=1 to 25
            if s.weapons(a).heat>0 then
                if sink>0 then
                    sink-=1
                    s.weapons(a).heat-=1
                endif
            else
                s.weapons(a).shutdown=0
            endif
            'if s.weapons(a).heat>0 then heat=1
        next
    loop until sink<=0 or heat<=0
    for a=1 to 25
        if s.weapons(a).reloading>0 then
            if s.weapons(a).ammomax>0 then
                s.weapons(a).reloading-=(3*s.reloading/10)
            else
                s.weapons(a).reloading-=3
            endif
        endif
        if s.weapons(a).reloading<0 then s.weapons(a).reloading=0
    next
    return 0
end function


function com_damship(byref t as _ship, dam as short, col as short) as _ship
    dim text as string
    dim side as short
    side=rnd_range(0,7)
    if dam<0 then return t

    t.shieldside(side)=t.shieldside(side)-dam
    rlprint t.desig &" is hit! ",col
    if t.shieldside(side)<0 then
        if t.shieldmax>0 then
            text=t.desig &" is hit, shields penetrated! "
        else
            text=t.desig &" is hit! "
        endif
        t.hull=t.hull+t.shieldside(side)
        text=text & -t.shieldside(side) & " Damage!"
    else
        text="shields hold!"
    endif
    if t.shieldside(side)<0 then t.shieldside(side)=0
    if text<>"" then rlprint text,col
    return t
end function

'declare function com_remove(attacker() as _ship, t as short,flag as short=0) as short

function com_detonatemine(d as short,mines_p() as _cords, mines_v() as short, byref mines_last as short, defender as _ship, attacker() as _ship) as short
    dim as short x,y,t,r,dis,a,dam,osx
    dim as _cords p
    osx=calcosx(player.c.x,1)

    if mines_last<=0 then
        mines_last=0
        return 0
    end if
    DbgPrint("detonating mine")
    if rnd_range(1,100)>item(mines_v(d)).v3 then
        rlprint "The mine was a dud"
        destroyitem(mines_v(d))
        mines_p(d)=mines_p(mines_last)
        mines_v(d)=mines_v(mines_last)
        mines_last-=1
        return 0
    endif
    dam=item(mines_v(d)).v1
    r=item(mines_v(d)).v2

    for t=1 to 5
        tScreen.set(0)
        cls
        display_ship

        for x=mines_p(d).x-6 to mines_p(d).x+6
            for y=mines_p(d).y-6 to mines_p(d).y+6
                p.x=x
                p.y=y
                dis=distance(p,mines_p(d))
                if configflag(con_tiles)=0 then
                    if dis<=r and t>dis and p.x>=0 and p.y>=0 and p.x<=_mwx and p.y<=20 then
                        set__color( 242+dis,0)
                        put((p.x-osx)*_fw1,p.y*_fh1),gtiles(76+t),trans
                    endif
                else

                if dis<=r and t>dis and p.x>=0 and p.y>=0 and p.x<=60 and p.y<=20 then
                    set__color( 242+dis,0)
                    draw string((p.x-osx)*_fw1,p.y*_fh1),"*",,font1,custom,@_col
                else
                    if p.x>=0 and p.y>=0 and p.x<=60 and p.y<=20 then
                        set__color( 0,0)
                        draw string((p.x-osx)*_fw1,p.y*_fh1)," ",,font1,custom,@_col
                    endif
                endif
                endif
            next
        next
        tScreen.update()
        sleep 50
    next
    if configflag(con_tiles)=1 then
    for t=5 to 1 step -1
        for x=mines_p(d).x-5 to mines_p(d).x+5
            for y=mines_p(d).y-5 to mines_p(d).y+5
                p.x=x
                p.y=y
                dis=distance(p,mines_p(d))
                if dis<=r and t>dis and p.x>=0 and p.y>=0 and p.x<=60 and p.y<=20 then
                    set__color( 242+dis,0)
                    draw string(p.x*_fw1,p.y*_fh1),"*",,font1,custom,@_col
                else
                    if p.x>=0 and p.y>=0 and p.x<=60 and p.y<=20 then
                        set__color( 0,0)
                        draw string(p.x*_fw1,p.y*_fh1)," ",,font1,custom,@_col
                    endif
                endif
            next
        next
        sleep 50
    next
    endif
    if distance(mines_p(d),defender.c)<r then
        defender=com_damship(defender,dam-2*distance(mines_p(d),defender.c),c_red)
        player=defender
        display_ship(0)
    endif
    for a=1 to 14
        if distance(mines_p(d),attacker(a).c)<r and attacker(a).hull>0 then
            attacker(a)=com_damship(attacker(a),dam-2*distance(mines_p(d),attacker(a).c),c_gre)
            if attacker(a).hull<=0 then
                rlprint attacker(a).desig &" destroyed",10
                reward(3)=reward(3)+attacker(a).money
                piratekills(attacker(a).st)+=1
                piratekills(0)+=attacker(a).money
'fail                com_remove(attacker(),a)
                t=0
            endif
        endif
    next

    p=mines_p(d)
    destroyitem(mines_v(d))
    mines_p(d)=mines_p(mines_last)
    mines_v(d)=mines_v(mines_last)
    mines_last-=1


    for a=1 to mines_last
        if distance(p,mines_p(a))<r then com_detonatemine(a,mines_p(), mines_v() ,mines_last, defender , attacker())
    next


    return 0

end function

function com_flee(defender as _ship,attacker() as _ship) as short
    dim as short cloak,victory,i,hostiles
    for i=1 to 14
        if attacker(i).hull>0 and attacker(i).aggr=0 then hostiles+=1
    next
    if defender.c.x=0 or defender.c.x=60 or defender.c.y=0 or defender.c.y=20 then
        if findbest(25,-1)>0 then cloak=5
        if skill_test(defender.pilot(0)+add_talent(2,7,1)+cloak,6+hostiles,"Pilot") or attacker(1).shiptype=2 then
            rlprint "You manage to get away.",10
            victory=1
        else
            cls
            display_ship(0)
            rlprint "You dont get away.",12
            defender.c.x=30
            defender.c.y=10
        endif
    else
        rlprint "You need to be at a map border.",14
    endif
    return victory
end function

function com_shipbox(s as _ship,di as short) as string
    dim text as string
    dim as short a,heat
    '' Storing in questflag array if things already have been IDed
    if skill_test(player.science(0),di-5) or s.questflag(11)=1 then
        text="|" & s.desig &"||"
        s.questflag(11)=1
    else
        text="| ???? ||"
    endif
    text=text &"MP: "& s.movepoints(s.manjets) &"|"
    if s.shieldmax>player.sensors then
        text=text &"Shield:"&s.shieldmax
    else
        if s.shieldmax>0 then
            text=text &"Shield:"&s.shieldmax
        else
            text=text &"No shield |"
        endif
        if skill_test(player.science(0),di-5) or s.questflag(0)=1 then
            text=text &"Hull: "&s.hull &" | "
            s.questflag(0)=1
        else
            text=text &"Hull: ?? | "
        endif
        for a=1 to 10
            if s.weapons(a).desig<>"" then
                if skill_test(player.science(0),di-5) or s.questflag(a)=1 then
                    text=text & s.weapons(a).desig &" | "
                    heat=heat+s.weapons(a).heat
                    s.questflag(a)=1
                else
                    text=text &" Weapon: ?? |"
                endif
            endif
        next
        if skill_test(player.science(0),di-5) or s.questflag(12)=1 then
            s.questflag(12)=1
            text=text &"Engine: "&s.engine &" |"
        endif
        if skill_test(player.science(0),di-5) then
            text=text &"Heat: "& int(heat/10)
        else
            text=text &"Heat: ??"
        endif
        text=text &" | | "
    endif
    return text
end function

function com_testweap(w as _weap, p1 as _cords,attacker() as _ship,mines_p() as _cords,mines_last as short,echo as short=0) as short
    dim as short r,a,b

    if w.dam>0 then
        r=-1 'kein cargo bay oder empty slot
        if w.ammomax>0 then
            if player.useammo=0 then b=1 'waffe braucht ammo und hat keine
        endif
        if w.shutdown<>0 then b=2
        if w.reloading<>0 then b=3
        
    endif
    if b>0 then r=0
    if r=-1 then
        for a=1 to 14
            if attacker(a).hull>0 then
                if distance(p1,attacker(a).c)<=w.range*3 then b=4
            endif
        next
        for a=1 to mines_last
            if distance(p1,mines_p(a))<=w.range*3 then b=4
            next
        if b=0 then r=0
    endif
    if echo=1 then
        if b=0 then rlprint "No target within range.",c_yel
        if b=1 then rlprint "Out of ammunition.",c_yel
        if b=2 then rlprint "Weapon shut down.",c_yel
        if b=3 then rlprint "Weapon reloading.",c_yel
        if b=3 then rlprint "Weapon reloading.",c_yel
    endif
    return r
end function

function com_mindist(s as _ship) as short
    dim as short d,a
    d=999
    for a=1 to 10
        if s.weapons(a).range>0 and s.weapons(a).range<d then d=s.weapons(a).range
    next
    return d
end function

function com_victory(attacker() as _ship) as short
    DimDebug(0)'2
    dim as short a,enemycount,f

    for a=1 to 14
        if attacker(a).hull>0 and attacker(a).aggr=0 then enemycount+=1
#if __FB_DEBUG__
        if debug=1 and attacker(a).hull>0 then rlprint a &":x:"&attacker(a).c.x &":y:"&attacker(a).c.y
#endif
    next

#if __FB_DEBUG__
    if debug=2 then
        f=freefile
        open "enemycount" for output as #f
        print #f,enemycount
        close #f
    endif
#endif
    DbgPrint("Enemycount"&enemycount)
    if enemycount>0 then return enemycount
    return 0
end function

function com_NPCMove(defender as _ship,attacker() as _ship,e_track_p() as _cords,e_track_v() as short,e_map() as byte,byref e_last as short) as short
    DimDebug(0)'2
    dim as short b,c,i,a
    dim as string text
    dim dontgothere(15) as short
    dim as _cords old
    
    com_findtarget(defender,attacker())
    for b=1 to 14 'enemymovement
        if attacker(b).hull>0 then
            if attacker(b).e.e=0 and attacker(b).engine>0 then
                if attacker(b).target.x<>attacker(b).c.x or attacker(b).target.y<>attacker(b).c.y then
                   attacker(b).di=com_turn(attacker(b).di,com_direction(attacker(b).c,attacker(b).target),attacker(b).turnrate)
                   DbgPrint(""&com_direction(attacker(b).c,attacker(b).target))
                   old=attacker(b).c
                   attacker(b).c=movepoint(attacker(b).c,attacker(b).di)
                   if (e_map(attacker(b).c.x,attacker(b).c.y)>0 or combatmap(attacker(b).c.x,attacker(b).c.y)>0) and rnd_range(1,attacker(b).pilot(0))+rnd_range(1,6)>8 then
                        attacker(b).di=bestaltdir(attacker(b).di,rnd_range(0,1))
                        attacker(b).c=old
                        attacker(b).c=movepoint(attacker(b).c,attacker(b).di)
                        attacker(b).e.add_action(1)
                   endif
                   if old.x<>attacker(b).c.x or old.y<>attacker(b).c.y then
                        attacker(b).add_move_cost(0)
                        e_last=com_add_e_track(attacker(b),e_track_p() ,e_track_v() , e_map() ,e_last)
                   endif
                endif
                if attacker(b).c.x=defender.c.x and attacker(b).c.y=defender.c.y then attacker(b).c=movepoint(attacker(b).c,attacker(b).di)
                if e_map(attacker(b).c.x,attacker(b).c.y)>0 then
                    a=e_map(attacker(b).c.x,attacker(b).c.y)
                    if e_track_v(a)>0 then
                        attacker(b)=com_damship(attacker(b),e_track_v(a),c_gre)
                        text=attacker(b).desig &" runs into plasma stream! "
#if __FB_DEBUG__
                        text=text &"Nr."&a &"C:"&cords(attacker(b).c) &" "&cords(e_track_p(a))
#endif
                        if distance(attacker(b).c,player.c)<=player.sensors*player.senac then
                            if text<>"" then rlprint text,10
                        else
                            if attacker(b).hull<=0 then rlprint "Registering explosion at "&attacker(b).c.x &":"&attacker(b).c.y &"!",c_gre
                        endif
                    else
                        e_map(attacker(b).c.x,attacker(b).c.y)=0
                    endif
                endif
            endif
        endif
    next b
    return 0
end function

#endif'main


#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tSpacecombatfunctions -=-=-=-=-=-=-=-
	tModule.register("tSpacecombatfunctions",@tSpacecombatfunctions.init()) ',@tSpacecombatfunctions.load(),@tSpacecombatfunctions.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tSpacecombatfunctions -=-=-=-=-=-=-=-
#endif'test
