'tParty.
'
'defines:
'display_ship=85, recalcshipsbays=11
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
'     -=-=-=-=-=-=-=- TEST: tParty -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tParty -=-=-=-=-=-=-=-

declare function display_ship_weapons(m as short=0) as short
declare function display_ship(show as byte=0) as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tParty -=-=-=-=-=-=-=-

namespace tParty
function init(iAction as integer) as integer
	pDisplayShip = @display_ship
	return 0
end function
end namespace'tParty


#define cut2top


function display_ship_weapons(m as short=0) as short
    dim as short a,b,bg,wl,ammo,ammomax,c,empty
    dim as string text
    set__color( 15,0)
    draw string ((_mwx+1)*_fw1+_fw2,7*_fh2), "Weapons:",,font2,custom,@_col
    set__color( 11,0)
    wl=9
    for a=1 to player.h_maxweaponslot
        if m<>0 and a=m then
            bg=1
        else
            bg=0
        endif
        if player.weapons(a).ammomax>0 then 
            ammo+=player.weapons(a).ammo
            ammomax+=player.weapons(a).ammomax
        endif
        text=weapon_text(player.weapons(a))
        if text<>"" then
            c += textbox(trim("{15}"&text), sidebar, (8+c)*_fh2, 20,,bg,1)+1
        else
            empty += 1
        endif
    next

    if empty>0 then
        set__color(15,0)
        if empty=1 then draw string(sidebar,(8+c)*_fh2), "Empty turret",,Font2,custom,@_col
        if empty>1 then draw string(sidebar,(8+c)*_fh2), empty &" empty turrets",,Font2,custom,@_col
        c+=1
    endif
    c+=1
    if ammo>0 then
        set__color(15,0)
        draw string(sidebar,(8+c)*_fh2), "Loadout ("& ammomax &"/"&ammo &"):",,Font2,custom,@_col
        set__color(11,0)
        draw string(sidebar,(9+c)*_fh2), ammotypename(player.loadout),,Font2,custom,@_col
        draw string(sidebar,(10+c)*_fh2), "Damage: "&player.loadout+1,,Font2,custom,@_col
        wl+=3
    endif
    set__color( 11,0)


    wl=wl+c
    return wl
end function


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

    textbox("Pi:" & p & " Gu:" &g &" Sc:" &s &" Dr:"&d &"  Security:"&player.security,sidebar,2*_fh2,(tScreen.x-sidebar)/_fw2,11,0,1 )
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
        tScreen.y=_lines*_fh1

        'screenres tScreen.x,tScreen.y,8,2,GFX_WINDOWED
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


#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tParty -=-=-=-=-=-=-=-
	tModule.register("tParty",@tParty.init()) ',@tParty.load(),@tParty.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tParty -=-=-=-=-=-=-=-
#endif'test
