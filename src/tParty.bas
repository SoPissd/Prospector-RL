'tParty


function display_ship(show as byte=0) as short
    dim  as short a,mjs,wl',b
    static wg as byte
    dim t as string
    dim as string p,g,s,d,carg
    dim as byte fw1,fh1
    fw1=11
'    #ifdef _windows
'    Fw1=_fw1
'    #endif
    Fh1=22
    
    
    if show=1 then
        if configflag(con_tiles)=0 then
            put ((player.c.x-player.osx)*_tix-(_tiy-_tix)/2,(player.c.y-player.osy)*_tiy),stiles(player.di,player.ti_no),trans
        else
            set__color( _shipcolor,0)
            draw string ((player.c.x-player.osx)*_fw1,(player.c.y-player.osy)*_fh1),"@",,Font1,custom,@_col
        endif
    endif
    
    if player.fuel=player.fuelmax then wg=0

    set__color( 15,0)
    if player.equipment(se_navcom)>0 then
        draw string (0,21*_fh1), "Pos:"&player.c.x &":"&player.c.y,, font2,custom,@_col

    else
        set__color( 14,0)
        draw string (0,21*_fh1), "No navcomp",, font2,custom,@_col
    endif

    draw_border(11)
    set__color( 15,0)
    draw string(sidebar,0*_fh1),(player.h_sdesc &" "& player.desig),,Font2,custom,@_col
    set__color( 11,0)
    draw string(sidebar,1*_fh2),"HP:"&space(4) &" "&"SP:"&player.shieldmax &" ",,Font2,custom,@_col
    if player.hull<(player.h_maxhull+player.addhull)/2 then set__color( 14,0)
    if player.hull<2 then set__color( 12,0)
    draw string(sidebar+3*_fw2,1*_fh2),""&player.hull,,Font2,custom,@_col
    set__color( 11,0)
    p=""&player.pilot(0)
    g=""&player.gunner(0)
    s=""&player.science(0)
    d=""&player.doctor(0)
    if player.pilot(0)<0 then p="{12}-{11}"
    if player.gunner(0)<0 then g="{12}-{11}"
    if player.science(0)<0 then s="{12}-{11}"
    if player.doctor(0)<0 then d="{12}-{11}"
    player.security=0
    for a=2 to 128
       if crew(a).hpmax>=1 and crew(a).typ>=6 then player.security+=1
    next

    textbox("Pi:" & p & " Gu:" &g &" Sc:" &s &" Dr:"&d &"  Security:"&player.security,sidebar,2*_fh2,(_screenx-sidebar)/_fw2,11,0,1 )
    draw string(sidebar,4*_fh2), "Sensors:"&player.sensors,,Font2,custom,@_col

    for a=1 to 5
        if player.weapons(a).made=88 then mjs+=1
        if player.weapons(a).made=89 then mjs+=2
    next
    draw string(sidebar,5*_fh2), "Engine :"&player.engine &" ("&player.movepoints(mjs) &" MP)",,Font2,custom,@_col
    set__color( 15,0)

    wl=display_ship_weapons()
    if wl+4>_lines then
        _lines=wl+4
        save_config(configflag(con_tiles))
        _screeny=_lines*_fh1

        'screenres _screenx,_screeny,8,2,GFX_WINDOWED
    endif
    draw string(sidebar,(wl+4)*_fh2), "Fuel(" &player.fuelmax+player.fuelpod &"):",,Font2,custom,@_col
    set__color( 11,0)
    if player.fuel<(player.fuelmax+player.fuelpod)*0.5 then set__color(c_yel,0)
    if player.fuel<(player.fuelmax+player.fuelpod)*0.2 then set__color(c_red,0)
    draw string(sidebar+11*_fw2,(wl+4)*_fh2) ,space(10-len(round_str(player.fuel,1)))&round_str(player.fuel,1) ,,Font2,custom,@_col

    if player.fuel<(player.fuelmax+player.fuelpod)*0.2 then
        if wg=1 then
            wg=2
            rlprint "Fuel very low",12
			play_sound(2)
            if configflag(con_sound)=2 then no_key=keyin(" "&key__enter &key__esc)
        endif
        set__color( 12,0)
	else        
	    if player.fuel<(player.fuelmax+player.fuelpod)*0.5 then
        	if wg=0 then
	            wg=1
	            rlprint "Fuel low",14
				play_sound(2)
	            if configflag(con_sound)=2 then no_key=keyin(" "&key__enter &key__esc)
	        endif
	        set__color( 14,0)
	    endif
    endif

    if tVersion.gameturn mod 20=0 then low_morale_message

    set__color( 11,0)
    draw string(sidebar,(wl+2)*_fh2),"Credits: "&space(12-len(Credits(player.money)))&Credits(player.money),,Font2,custom,@_col
    draw string(sidebar,(wl+3)*_fh2),display_time(tVersion.gameturn),,Font2,custom,@_col
    set__color( 15,0)
    draw string(sidebar,wl*_fh2), "Cargo",,font2,custom,@_col
    for a=1 to 10
        carg=""
        if player.cargo(a).x=1 then
            set__color( 8,1)
        else
            set__color( 10,8)
        endif
        if player.cargo(a).x=1 then carg= "E"
        if player.cargo(a).x=2 then carg= "F"
        if player.cargo(a).x=3 then carg= "B"
        if player.cargo(a).x=4 then carg= "T"
        if player.cargo(a).x=5 then carg= "L"
        if player.cargo(a).x=6 then carg= "W"
        if player.cargo(a).x=7 then carg= "N"
        if player.cargo(a).x=8 then carg= "H"
        if player.cargo(a).x=9 then carg= "U"
        if player.cargo(a).x=10 then carg= "f"
        if player.cargo(a).x=11 then carg= "C"
        if player.cargo(a).x=12 then carg= "?"
        if player.cargo(a).x=13 then carg= "t"
        draw string(sidebar+(a-1)*_fw2,(wl+1)*_fh2),carg,,font2,custom,@_col
    next
    wl+=6

    comstr.display(wl)
    set__color( 11,0)
    if player.tractor=0 then player.towed=0
    return wl+4
end function


function recalcshipsbays() as short
    dim soll as short
    dim haben as short
    dim as short a,b,c
    dim del as _crewmember
    dim dif as short
    
    for c=0 to 9
        for b=1 to 9
            if player.weapons(b).desig="" then swap player.weapons(b),player.weapons(b+1) 
            'if player.cargo(b).x<player.cargo(b+1).x then swap player.cargo(b),player.cargo(b+1)
        next
    next
    player.fuelpod=0
    player.crewpod=0
    soll=player.h_maxcargo
    for a=1 to 10
        if a>player.h_maxweaponslot then player.weapons(a)=make_weapon(-1)
        if player.weapons(a).desig="Cargo Bay" then soll=soll+1
        if player.weapons(a).desig="Fuel Tank" then player.fuelpod=player.fuelpod+50
        if trim(player.weapons(a).desig)="Crew Quarters" then player.crewpod=player.crewpod+10
    next
    for a=1 to 25
        if player.cargo(a).x>0 then haben=haben+1
    next
    if soll>haben then
        dif=soll-haben
        do
        for a=1 to 25
            if player.cargo(a).x=0 and dif>0 then
                player.cargo(a).x=1
                dif=dif-1
            endif
        next
        loop until dif<=0
    endif
    if haben>soll then
        dif=haben-soll
        for b=1 to 5
            for a=1 to 25
                if player.cargo(a).x=b and dif>0 then
                    player.cargo(a).x=0 
                    dif=dif-1
                endif
            next
        next
    endif
    for c=1 to 9
        for b=1 to 9
          if player.cargo(b).x<player.cargo(b+1).x then swap player.cargo(b),player.cargo(b+1)
      next        
    next
    if player.fuel>player.fuelmax+player.fuelpod then player.fuel=player.fuelmax+player.fuelpod
    for c=6 to player.h_maxcrew+player.crewpod+player.cryo
        if crew(c).hp<>0 then player.security=c
    next
    for c=5+player.cryo+(player.h_maxcrew+player.crewpod-5)*2+1 to 255
        crew(c)=del
    next    
    player.addhull=0
    for a=1 to 5
        if player.weapons(a).made=87 then player.addhull=player.addhull+5
    next
    if player.hull>max_hull(player) then player.hull=max_hull(player)
    return 0
end function

