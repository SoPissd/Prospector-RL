'tSpacecombatmap.
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
'     -=-=-=-=-=-=-=- TEST: tSpacecombatmap -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tSpacecombatmap -=-=-=-=-=-=-=-

declare function display_star(a as short,fbg as byte=0) as short
declare function display_stars(bg as short=0) as short

'declare function display_station(a as short) as short
'declare function draw_shield(ship as _ship,osx as short) as short
#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tSpacecombatmap -=-=-=-=-=-=-=-

namespace tSpacecombatmap
function init(iAction as integer) as integer
	pDisplaystars= @display_stars
	return 0
end function
end namespace'tSpacecombatmap

'declare function com_remove(attacker() as _ship, t as short,flag as short=0) as short


function display_station(a as short) as short
    dim as short x,y,t

    basis(a).discovered=1
    x=basis(a).c.x-player.osx
    y=basis(a).c.y-player.osy
    if a<3 then
        t=a+3*(basis(a).company-1)
    else
        t=2+3*(basis(a).company-1)
    endif
    if x<0 or y<0 or x>_mwx or y>20 then return 0
    set__color( 15,0)
    if configflag(con_tiles)=1 then
        draw string (x*_fw1,y*_fh1),"S",,Font1,custom,@_col
    else
        if vismask(basis(a).c.x,basis(a).c.y)=1 then
            put ((x)*_tix+1,(y)*_tiy+1),gtiles(gt_no(1750+t)),trans
        else
            put ((x)*_tix+1,(y)*_tiy+1),gtiles(gt_no(1750+t)),alpha,192
        endif
    endif
    if distance(player.c,basis(a).c)<player.sensors then
        if fleet(a).fighting<>0 then
            set__color( c_red,0,vismask(basis(a).c.x,basis(a).c.y))
            draw string (x*_fw1,y*_fh1),"x",,Font2,custom,@_col
            if tVersion.gameturn mod 10=0 then rlprint "Station "&a+1 &" is sending a distress signal! They are under attack!",c_red
        endif
    endif
    
#if __FB_DEBUG__
    draw string (x*_fw1,y*_fh1),""&count_gas_giants_area(basis(a).c,7) &":"& basis(a).inv(9).v ,,Font2,custom,@_col
#endif

    return 0
end function


function display_star(a as short,fbg as byte=0) as short
    DimDebugL(0)'2
    dim bg as short
    dim n as short
    dim p as short
    dim as short x,y,s

    x=map(a).c.x-player.osx
    y=map(a).c.y-player.osy
    if x<0 or y<0 or x>_mwx or y>20 then return 0
    bg=0
    if spacemap(map(a).c.x,map(a).c.y)>=2 then bg=5
    if spacemap(map(a).c.x,map(a).c.y)=6 then bg=1

    if map(a).discovered=2 then bg=1
    for p=1 to 9
        if map(a).planets(p)>0 then
            for n=0 to lastspecial
                set__color( 11,0)
                if map(a).planets(p)=specialplanet(n) and planets(map(a).planets(p)).mapstat>0 then
                    bg=233
                    s=n
                endif
                if show_specials>0 or (debug=2) then
                    if map(a).planets(p)=specialplanet(n) then
                        set__color( 11,0)
                        draw string((map(a).c.x-player.osx+1)*_fw1,(map(a).c.y-player.osy+1)*_fh1) ,""&n,,font2
                    endif
                endif
            next
            if planets(map(a).planets(p)).colony<>0 then bg=246
        endif
    next
    if map(a).discovered<=0 then
        player.discovered(map(a).spec)=player.discovered(map(a).spec)+1
        map(a).desig=spectralshrt(map(a).spec)&player.discovered(map(a).spec)&"-"&int(disnbase(map(a).c))&"("&map(a).c.x &":"& map(a).c.y &")"
        map(a).discovered=1
        if map(a).spec=9 then ano_money+=250
    endif
    if configflag(con_tiles)=0 then
        if vismask(map(a).c.x,map(a).c.y)=1 then
            put (x*_tix,y*_tiy),gtiles(map(a).ti_no),alpha,255
        else
            put (x*_tix,y*_tiy),gtiles(map(a).ti_no),alpha,192
        endif
        if fbg=1 then put (x*_tix,y*_tiy),gtiles(85),trans
        set__color( 11,0,vismask(map(a).c.x,map(a).c.y))
        if bg=233 then draw string (x*_tix,y*_tiy),"s",,font2,custom,@_tcol
#if __FB_DEBUG__
        if bg=233 then draw string (x*_tix,y*_tiy),"s:"&s,,font2,custom,@_tcol
        draw string ((map(a).c.x-player.osx)*_fw1,(map(a).c.y-player.osy)*_fh1),""&map(a).discovered,,Font1,custom,@_col
        draw string (x*_tix+_tix,y*_tiy),""&map(a).ti_no &":"&map(a).spec,,Font1,custom,@_col
#endif
    else
        set__color( spectraltype(map(a).spec),bg,vismask(map(a).c.x,map(a).c.y))
        if map(a).spec<8 then draw string ((map(a).c.x-player.osx)*_fw1,(map(a).c.y-player.osy)*_fh1),"*",,Font1,custom,@_col
        if map(a).spec=8 then
            set__color( 7,bg)
            draw string ((map(a).c.x-player.osx)*_fw1,(map(a).c.y-player.osy)*_fh1),"o",,Font1,custom,@_col
        endif

        if map(a).spec=9 then
            n=distance(map(a).c,map(map(a).planets(1)).c)/5
            if n<1 then n=1
            if n>6 then n=6
            set__color( 179+n,bg)
            if fbg=1 then set__color( 179+n,c_gre,1)
            draw string ((map(a).c.x-player.osx)*_fw1,(map(a).c.y-player.osy)*_fh1),"o",,Font1,custom,@_col
        endif
        if map(a).spec=10 then
            set__color(63,bg)
            draw string ((map(a).c.x-player.osx)*_fw1,(map(a).c.y-player.osy)*_fh1),"O",,Font1,custom,@_col
        endif
    endif
    return 0
end function


function display_stars(bg as short=0) as short
    DimDebugL(0)'25'4'1024
    dim as uinteger alphav
    dim as short a,b,x,y,navcom,mask,ti_no
    dim as short reveal
    dim as _cords p,p1,p2
    dim range as integer
    dim as single dx,dy,l,x1,y1,vis

    if bg<2 then
        player.osx=player.c.x-_mwx/2
        player.osy=player.c.y-10
        if player.osx<=0 then player.osx=0
        if player.osy<=0 then player.osy=0
        if player.osx>=sm_x-_mwx then player.osx=sm_x-_mwx
        if player.osy>=sm_y-20 then player.osy=sm_y-20
    endif
    make_vismask(player.c,player.sensors+5.5-player.sensors/2,-1)
    navcom=player.equipment(se_navcom)
    for x=player.c.x-1 to player.c.x+1
        for y=player.c.y-1 to player.c.y+1
            if x>=0 and y>=0 and x<=sm_x and y<=sm_y then vismask(x,y)=1
        next
    next

    for x=player.c.x-10 to player.c.x+10
        for y=player.c.y-10 to player.c.y+10
            if x>=0 and y>=0 and x<=sm_x and y<=sm_y then
                if vismask(x,y)=1 then
                    p.x=x
                    p.y=y
                    if distance(p,player.c)>player.sensors then vismask(x,y)=2
                endif
            endif
        next
    next

    if bg>0 then
        for x=0 to _mwx
            for y=0 to 20
                ti_no=spacemap(x+player.osx,y+player.osy)
                set__color( 1,0)
#if __FB_DEBUG__
                draw string (x*_fw1,y*_fh1),""&spacemap(x+player.osx,y+player.osy),,FONT1,custom,@_col
#endif

                if spacemap(x+player.osx,y+player.osy)=1 and navcom>0 then
                    if configflag(con_tiles)=0 then
                        alphav=192
                        if vismask(x+player.osx,y+player.osy)=1 then alphav=255
                        if (x+player.osx+y+player.osy) mod 2=0 then
                            put (x*_fw1+1,y*_fh1+1),gtiles(49),alpha,alphav
                        else
                            put (x*_fw1+1,y*_fh1+1),gtiles(50),alpha,alphav
                        endif
                    else
                        draw string (x*_fw1,y*_fh1),".",,FONT1,custom,@_col
                    endif
                endif
                if spacemap(x+player.osx,y+player.osy)>=2 and  spacemap(x+player.osx,y+player.osy)<=5 then
                    if configflag(con_tiles)=0 then
                        alphav=192
                        if vismask(x+player.osx,y+player.osy)=1 then alphav=255
                        put (x*_fw1+1,y*_fh1+1),gtiles(ti_no+49),alpha,alphav
                    else
                        if spacemap(x+player.osx,y+player.osy)=2 then color(rgb(0,0,50))
                        if spacemap(x+player.osx,y+player.osy)=3 then color(rgb(0,0,100))
                        if spacemap(x+player.osx,y+player.osy)=4 then color(rgb(0,0,150))
                        if spacemap(x+player.osx,y+player.osy)=5 then color(rgb(0,0,250))
                        draw string (x*_fw1,y*_fh1),chr(176),,Font1,custom,@_col
                    endif
                endif
                if spacemap(x+player.osx,y+player.osy)>=2 and  spacemap(x+player.osx,y+player.osy)<=5 then

                endif
                if spacemap(x+player.osx,y+player.osy)>=6 and spacemap(x+player.osx,y+player.osy)<=20 then
                    ti_no=abs(spacemap(x+player.osx,y+player.osy))
                    if ti_no>10 then ti_no-=10
                    if configflag(con_tiles)=0 then
                        alphav=192
                        if vismask(x+player.osx,y+player.osy)=1 then alphav=255
                        put (x*_fw1+1,y*_fh1+1),gtiles(ti_no+49),alpha,alphav
                    else
                        if ti_no=6 then set__color( 2,0)
                        if ti_no=7 then set__color( 10,0)
                        if ti_no=8 then set__color( 4,0)
                        if ti_no=9 then set__color( 12,0)
                        if ti_no=10 then set__color( 3,0)
                        draw string (x*_fw1,y*_fh1),":",,Font1,custom,@_col

                    endif
                endif
            next
        next
    endif
#if __FB_DEBUG__
    if debug=25 then
        for a=firstwaypoint to lastwaypoint
            set__color( 11,0)
            if a>=firststationw then set__color( 15,0)
            if targetlist(a).x-player.osx>=0 and targetlist(a).x-player.osx<=60 and targetlist(a).y-player.osy>=0 and targetlist(a).y-player.osy<=20 then
                draw string((targetlist(a).x-player.osx)*_fw1,(targetlist(a).y-player.osy)*_fh1),";",,Font1,Custom,@_tcol
            endif
        next
    endif
#endif
    set__color( 1,0)
    for x=player.c.x-10 to player.c.x+10
        for y=player.c.y-10 to player.c.y+10
            if x-player.osx>=0 and y-player.osy>=0 and x-player.osx<=60 and y-player.osy<=20 and x>=0 and y>=0 and x<=sm_x and y<=sm_y then
                p.x=x
                p.y=y
                if vismask(x,y)>0 and distance(p,player.c)<player.sensors+0.5 then
                    if spacemap(x,y)<=0 then reveal=1
                    if spacemap(x,y)=0 then spacemap(x,y)=1
                    if spacemap(x,y)=-2 then spacemap(x,y)=2
                    if spacemap(x,y)=-3 then spacemap(x,y)=3
                    if spacemap(x,y)=-4 then spacemap(x,y)=4
                    if spacemap(x,y)=-5 then spacemap(x,y)=5
                endif
                locate y+1-player.osy,x+1-player.osx,0
                set__color( 1,0)
                if abs(spacemap(x,y))=1 and navcom>0 and vismask(x,y)>0 and distance(p,player.c)<player.sensors+0.5  then
                    if configflag(con_tiles)=1 then
                        draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),".",,Font1,custom,@_col
                    else

                        alphav=192
                        if vismask(x,y)=1 then alphav=255
                        put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(50),alpha,alphav
                    endif
                endif
                if abs(spacemap(x,y))>=2 and abs(spacemap(x,y))<=5 and vismask(x,y)>0  and distance(p,player.c)<player.sensors+0.5 then
                    if configflag(con_tiles)=1 then
                        set__color( rnd_range(48,59),1,vismask(x,y))
                        if spacemap(x,y)=2 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(48,59),1,vismask(x,y))
                        if spacemap(x,y)=3 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(96,107),1,vismask(x,y))
                        if spacemap(x,y)=4 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(144,155),1,vismask(x,y))
                        if spacemap(x,y)=5 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(192,203),1,vismask(x,y))
                        draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),chr(177),,Font1,custom,@_col
                    else
                        alphav=192
                        if vismask(x,y)=1 then alphav=255
                        put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(51),alpha,alphav
                        if spacemap(x,y)=2 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(51),alpha,alphav
                        if spacemap(x,y)=3 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(52),alpha,alphav
                        if spacemap(x,y)=4 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(53),alpha,alphav
                        if spacemap(x,y)=5 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(54),alpha,alphav
                    endif
                endif
                if abs(spacemap(x,y))>=6 and abs(spacemap(x,y)<=17) and vismask(x,y)>0 and distance(p,player.c)<player.sensors+0.5 then
                    if (spacemap(x,y)>=6 and spacemap(x,y)<=17) or rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8  then
                        if configflag(con_tiles)=0 then
                            alphav=192
                            if vismask(x,y)=1 then alphav=255
                            put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(49+abs(spacemap(x,y))),alpha,alphav
                        else
                            if abs(spacemap(x,y))>8 then set__color( 3,0,vismask(x,y))
                            if abs(spacemap(x,y))=6 then set__color( 9,0,vismask(x,y))
                            if abs(spacemap(x,y))=7 then set__color( 113,0,vismask(x,y))
                            if abs(spacemap(x,y))=8 then set__color( 53,0,vismask(x,y))
                            draw string (x*_fw1-player.osx*_fw1,y*_fh1-player.osy*_fh1),":",,Font1,custom,@_col
                        endif
                        if spacemap(x,y)<=-6 then ano_money+=5
                        spacemap(x,y)=abs(spacemap(x,y))
                    else
                        set__color( 1,0)
                        if navcom>0 then draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),".",,Font1,custom,@_col
                    endif
                endif
            endif
        next
    next

    if reveal=1 and disnbase(player.c,1)>farthestexpedition then farthestexpedition=disnbase(player.c,1)

    a=player.equipment(se_shipdetection)
#if __FB_DEBUG__
    'if (debug=4 or debug=1024) and _debug=1 then 
    if a<1 then a=1
#endif
    if a>0 then
        for b=6 to lastfleet
            x=fleet(b).c.x
            y=fleet(b).c.y
            if (vismask(x,y)=1 and (distance(player.c,fleet(b).c)<player.sensors or distance(player.c,fleet(b).c)<2)) _
            or ((debug=4 or debug=1024)) then
                set__color( 11,0)
                if a=1 then 'No Friend Foe
                    set__color( 11,0)
                    if configflag(con_tiles)=0 then
                        put ((x-player.osx)*_fw1,(y-player.osy)*_fh1),gtiles(86),trans
                    else
                        draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),"s",,Font1,custom,@_col
                    endif
                    if fleet(b).fighting>0 then
                        set__color( 12,0)
                        draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),"X",,Font2,custom,@_col
                    endif
                else

                    if configflag(con_tiles)=0 then
                        put ((x-player.osx)*_fw1,(y-player.osy)*_fh1),gtiles(86),trans
                        if fleet(b).ty=1 or fleet(b).ty=3 then put ((x-player.osx)*_fw1,(y-player.osy)*_fh1),gtiles(67),trans
                        if fleet(b).ty=2 or fleet(b).ty=4 then put ((x-player.osx)*_fw1,(y-player.osy)*_fh1),gtiles(68),trans
                    else
                        if fleet(b).ty=1 or fleet(b).ty=3 then set__color( 10,0)
                        if fleet(b).ty=2 or fleet(b).ty=4 then set__color( 12,0)
                        if fleet(b).ty=5 then set__color( 5,0)
                        if fleet(b).ty=6 then set__color( 8,0)
                        if fleet(b).ty=7 then set__color( 8,0)
                        draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),"s",,Font1,custom,@_col
                    endif

                    if fleet(b).fighting>0 then
                        set__color( 12,0)
                        draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),"X",,Font2,custom,@_col
                    endif
                endif
            endif
        next
    endif

    for b=3 to lastfleet
        if fleet(b).ty=10 then 'Eris
            if vismask(fleet(b).c.x,fleet(b).c.y)=1 then
                x=fleet(b).c.x
                y=fleet(b).c.y
                if configflag(con_tiles)=0 then
                    put ((x-player.osx)*_fw1,(y-player.osy)*_fh1),gtiles(gt_no(88)),trans
                else
                    set__color( rnd_range(1,15),0)
                    draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),"@",,Font1,custom,@_col
                endif
            endif
        endif
    next
    for x=1 to lastdrifting
        if drifting(x).x<0 then drifting(x).x=0
        if drifting(x).y<0 then drifting(x).y=0
        if drifting(x).x>sm_x then drifting(x).x=sm_x
        if drifting(x).y>sm_y then drifting(x).y=sm_y
        p.x=drifting(x).x
        p.y=drifting(x).y
        if drifting(x).x=player.c.x and drifting(x).y=player.c.y and drifting(x).p=0 then
            drifting(x).p=1
            walking=0
        endif
        if planets(drifting(x).m).flags(0)=0 then
            set__color( 7,0,vismask(p.x,p.y))
            if drifting(x).s=20 then set__color( 15,0,vismask(p.x,p.y))
            if (a>0 and vismask(p.x,p.y)=1 and distance(player.c,p)<player.sensors) or drifting(x).p>0 then
                if p.x+1-player.osx>=0 and p.x+1-player.osx<=_mwx+1 and p.y+1-player.osy>=0 and p.y+1-player.osy<=21 then
                    if configflag(con_tiles)=0 then
                        if drifting(x).g_tile.x=0 or drifting(x).g_tile.x=5 or drifting(x).g_tile.x>9 then drifting(x).g_tile.x=rnd_range(1,4)
                        alphav=192
                        if vismask(p.x,p.y)=1 then alphav=255
                        put ((p.x-player.osx)*_fw1,(p.y-player.osy)*_fh1),stiles(drifting(x).g_tile.x,drifting(x).g_tile.y),alpha,alphav
                    else
                        draw string ((p.x-player.osx)*_fw1,(p.y-player.osy)*_fh1),"s",,Font1,custom,@_col
                    endif
#if __FB_DEBUG__
                    draw string ((p.x-player.osx)*_fw1,(p.y-player.osy)*_fh1),":"&vismask(p.x,p.y),,Font1,custom,@_col
#endif
                    if drifting(x).p=0 then walking=0
                    drifting(x).p=1
                endif
            endif
        endif
    next
    if show_NPCs>0 then
        for a=3 to lastfleet
            x=fleet(a).c.x-player.osx
            y=fleet(a).c.y-player.osy
            if x>=0 and x<=_mwx and y>=0 and y<=20 then
                if fleet(a).ty=1 or fleet(a).ty=3 then set__color( 10,0)
                if fleet(a).ty=2 or fleet(a).ty=4 then set__color( 12,0)
                if fleet(a).ty=5 then set__color( 5,0)
                if fleet(a).ty=6 then set__color( 8,0)
                if fleet(a).ty=7 then set__color( 6,0)
                draw string (x*_fw1,(y)*_fh1),"s",,Font1,custom,@_col
            endif
            x=targetlist(fleet(a).t).x-player.osx
            y=targetlist(fleet(a).t).y-player.osy
            if x>=0 and x<=60 and y>=0 and y<=20 then
                set__color( 15,0)
                draw string (x*_fw1,y*_fh1),"*",,Font1,custom,@_col
            endif
        next
    endif
    if show_civs=1 then
        for a=0 to 1
            x=civ(a).home.x-player.osx
            y=civ(a).home.y-player.osy
            if x>=0 and x<=_mwx and y>=0 and y<=20 then
                set__color( 11,0)
                draw string ((x)*_fw1,(y)*_fh1)," "&a,,Font1,custom,@_col
            endif
        next
    endif
    set__color( 11,0)
    if lastcom>ubound(coms) then lastcom=ubound(coms)
    for a=1 to lastcom
        if coms(a).c.x>player.osx and coms(a).c.x<player.osx+60 and coms(a).c.y>player.osy and coms(a).c.y<player.osy+20 then
            draw string ((coms(a).c.x-player.osx)*_fw1,(coms(a).c.y-player.osy)*_fh1),trim(coms(a).t),,Font2,custom,@_tcol
        endif
    next

    for a=0 to laststar+wormhole
        if map(a).spec<=7 then
            vis=maximum(player.sensors+.5,(map(a).spec)-2)
        else
            vis=0
        endif

        if (vismask(map(a).c.x,map(a).c.y)=1 and distance(map(a).c,player.c)<=vis) or map(a).discovered>0 then
            if map(a).discovered=0 and walking<10 then walking=0
            display_star(a)
        endif
    next


'
    for a=1 to lastprobe
        x=probe(a).x-player.osx
        y=probe(a).y-player.osy
        if x>=0 and y>=0 and x<=_mwx and y<=20 then
            if configflag(con_tiles)=0 then
               put ((x)*_fw1,(y)*_fh1),gtiles(gt_no(2117+probe(a).p)),trans
#if __FB_DEBUG__
               draw string((x)*_fw1,(y)*_fh1),"m:"&probe(a).m &"v5:"&item(probe(a).m).v5 &"z"&probe(a).z
#endif
            else
                set__color( _shipcolor,0)
                draw string (x*_fw1,y*_fh1),"s",,Font1,custom,@_col
            endif
        endif
    next
    for a=0 to 2
        if basis(a).c.x>0 and basis(a).c.y>0 then
            if basis(a).discovered>0 then display_station(a)
        endif
    next
    if walking=10 and reveal=1 then
        p1=apwaypoints(lastapwp)
        lastapwp=ap_astar(player.c,p1,apdiff)
        currapwp=0
    endif
    return 0
end function
#endif'main



#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tSpacecombatmap -=-=-=-=-=-=-=-
	tModule.register("tSpacecombatmap",@tSpacecombatmap.init()) ',@tSpacecombatmap.load(),@tSpacecombatmap.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tSpacecombatmap -=-=-=-=-=-=-=-
#endif'test
