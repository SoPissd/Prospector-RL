'tAwayteam.
'
'defines:
'hpdisplay=0, display_awayteam=21, gainxp=13, alerts=1, cure_awayteam=2,
', rnd_crewmember=1, diseaserun=1, heal_awayteam=1, infect=6,
', wear_armor=0, equip_awayteam=9, no_spacesuit=0, dam_awayteam=14,
', repair_spacesuits=1, pathblock=9, ep_checkmove=1, giveitem=0,
', ep_communicateoffer=1, crew_menu=0, showteam=6
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
'     -=-=-=-=-=-=-=- TEST: tAwayteam -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tAwayteam -=-=-=-=-=-=-=-

declare function display_awayteam(showshipandteam as byte=1,osx as short=555) as short
declare function gainxp(typ as short,v as short=1) as string
declare function alerts() as short
declare function cure_awayteam(where as short) as short
declare function rnd_crewmember(onship as short=0) as short
declare function diseaserun(onship as short) as short
declare function heal_awayteam(byref a as _monster,heal as short) as short
declare function infect(a as short,dis as short) as short
declare function equip_awayteam(m as short) as short
declare function dam_awayteam(dam as short, ap as short=0,disease as short=0) as string
declare function repair_spacesuits(v as short=-1) as short
declare function pathblock(byval c as _cords,byval b as _cords,mapslot as short,blocktype as short=1,col as short=0, delay as short=25,rollover as byte=0) as short
declare function ep_checkmove(ByRef old As _cords,Key As String) As Short
declare function ep_communicateoffer(Key As String) As Short
declare function showteam(from as short, r as short=0,text as string="") as short

'private function hpdisplay(a as _monster) as short
'private function wear_armor(a as short,b as short) as short
'private function no_spacesuit(who() as short,byref alle as short=0) as short
'private function giveitem(e as _monster,nr as short) as short
'private function crew_menu(crew() as _crewmember, from as short, r as short=0,text as string="") as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tAwayteam -=-=-=-=-=-=-=-

namespace tAwayteam
function init(iAction as integer) as integer
	return 0
end function
end namespace'tAwayteam


#define cut2top


function hpdisplay(a as _monster) as short
    dim as short hp,b,c,x,y,l
    hp=0
    a.hpmax=0
    a.hp=0
    for b=1 to 128
        if crew(b).hpmax>0 and crew(b).onship=0 then a.hpmax+=1
        if crew(b).hp>0 and crew(b).onship=0  then a.hp+=1
        if crew(b).hp>0 and crew(b).onship=0 then hp=hp+1
    next

    set__color( 15,0)
    draw string(sidebar,0*_fh1),"Status ",,font2,custom,@_col
    set__color( 11,0)
    draw string(sidebar+7*_fw2,0*_fh2),"(",,font2,custom,@_col
    draw string(sidebar+10*_fw2,0*_fh2),""&a.hpmax &"/",,font2,custom,@_col
    if a.hp/a.hpmax<.7 then set__color( 14,0)
    if a.hp/a.hpmax<.4 then set__color( 12,0)
    draw string(sidebar+13*_fw2,0*_fh2) ,""&a.hp,,font2,custom,@_col
    set__color( 11,0)
    draw string(sidebar+16*_fw2,0*_fh2), ")",,font2,custom,@_col
    
    y=2
    x=0
    c=1
    do
        if crew(c).hpmax>0 and crew(c).onship=0 then
            x+=1
            l=y
            if crew(c).hp>0  then

                set__color( 14,0)
                if crew(c).hp=crew(c).hpmax then set__color( 10,0)
                if crew(c).disease>0 then set__color( 192,0)
                if _HPdisplay=1 then
                    draw string(sidebar+(x-1)*_fw2,(y-1)*_fh2),crew(c).icon,,font2,custom,@_col
                else
                    draw string(sidebar+(x-1)*_fw2,(y-1)*_fh2),""&crew(c).hp,,font2,custom,@_col
                endif
            else
                set__color( 12,0)
                draw string(sidebar+(x-1)*_fw2,(y-1)*_fh2), "X",,font2,custom,@_col
            endif
        endif
        if x>15 then
            x=0
            y+=1
        endif
        c+=1
    loop until c=128 or crew(c).hpmax=0
        
    return l
end function



function display_awayteam(showshipandteam as byte=1,osx as short=555) as short
        dim a as short
        dim c as short
        dim x as short
        dim y as short
        dim xoffset as short
        dim t as string
        static wg as byte
        static wj as byte
        dim thp as short
        dim as string poi
        dim as byte fw1,fh1,l
        dim debug as byte=0
        dim as short map
        Fh1=22
        dim as _cords ship
        ship=player.landed
        map=player.map
        if osx=555 then osx=calcosx(awayteam.c.x,planets(map).depth)
        xoffset=22
        locate 22,1
        set__color( 15,0)
        if awayteam.stuff(8)=1 and player.landed.m=map and planets(map).depth=0 then
            set__color( 15,0)
            locate 22,3
            draw string(0*_fw1,21*_fh1+(_fh1-_fh2)/2), "Pos:"&awayteam.c.x &":"&awayteam.c.y,,Font2,Custom,@_col
        else
            locate 22,1
            set__color( 14,0)
            draw string(0*_fw1,21*_fh1+(_fh1-_fh2)/2), "no satellite",,Font2,Custom,@_col
        endif
        locate 22,15
        set__color( 15,0)
        if adisloctime=3 then draw string(15*_fw2,21*_fh1+(_fh1-_fh2)/2),"Night",,Font2,Custom,@_col
        if adisloctime=0 then draw string(15*_fw2,21*_fh1+(_fh1-_fh2)/2)," Day ",,Font2,Custom,@_col
        if adisloctime=1 then draw string(15*_fw2,21*_fh1+(_fh1-_fh2)/2),"Dawn ",,Font2,Custom,@_col
        if adisloctime=2 then draw string(15*_fw2,21*_fh1+(_fh1-_fh2)/2),"Dusk ",,Font2,Custom,@_col
        if show_mnr=1 then draw string(15*_fw2,21*_fh1+(_fh1-_fh2)/2),""&map &":"&planets(map).flags(1),,Font2,Custom,@_col
        set__color( 10,0)
        locate 22,xoffset
        if awayteam.invis>0 then
            draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),"Camo",,Font2,Custom,@_col
            xoffset=xoffset+5
        endif
        if _autopickup=0 then
            draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),"P",,Font2,Custom,@_col
            xoffset+=1
        endif
        if _autoinspect=0 then
            draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),"I",,Font2,Custom,@_col
            xoffset+=1
        endif
        if awayteam.helmet=0 then
            draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),"O",,Font2,Custom,@_col
        else
            draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),"C",,Font2,Custom,@_col
        endif
        xoffset+=2
        draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),tacdes(player.tactic+3),,Font2,Custom,@_col
        xoffset=xoffset+len(tacdes(player.tactic+3))

        draw_border(xoffset)
        if showshipandteam=1 then
            set__color( 15,0)
            if player.landed.m=map then
                if planetmap(ship.x,ship.y,map)>0 or player.stuff(3)=2 then
                    if configflag(con_tiles)=0 then
                        x=ship.x-osx
                        if x<0 then x+=61
                        if x>60 then x-=61
                        if x>=0 and x<=_mwx then put (x*_tix,ship.y*_tiy),stiles(5,player.ti_no),trans
                    else
                        set__color( _shipcolor,0)
                        draw string((ship.x)*_fw1,ship.y*_fh1),"@",,Font1,custom,@_col
                    endif
                endif
            endif

            if configflag(con_tiles)=0 then
                x=awayteam.c.x-osx
                if x<0 then x+=61
                if x>60 then x-=61
                if x>=0 and x<=_mwx then
                    if awayteam.movetype=mt_fly or awayteam.movetype=mt_flyandhover then put (x*_tix,awayteam.c.y*_tiy),gtiles(gt_no(2002)),trans
                    put (x*_tix,awayteam.c.y*_tiy),gtiles(captain_sprite),trans
                    if awayteam.movetype=mt_hover or awayteam.movetype=mt_flyandhover then put (x*_tix,awayteam.c.y*_tiy+4),gtiles(gt_no(2001)),trans
                    
                    if show_energy=1 then 
                        set__color(15,0)
                        draw string ((x)*_tix,awayteam.c.y*_tiy),"E:"&awayteam.e.e,,font2,custom,@_tcol
                    endif
                endif
#if __FB_DEBUG__
                draw string(x*_tix,awayteam.c.y*_tiy),"e:"&awayteam.e.e
#endif
            else
                set__color( _teamcolor,0)
                draw string (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,Font1,custom,@_col
            endif
        endif

        l=hpdisplay(awayteam)
        set__color( 11,0)
        l+=1
        draw string(sidebar,l*_fh2), "Visibility: " &awayteam.sight,,Font2,custom,@_col
        l+=1
        if awayteam.movetype=0 then draw string(sidebar,l*_fh2), "Trp.: None",,Font2,custom,@_col
        if awayteam.movetype=1 then draw string(sidebar,l*_fh2), "Trp.: Hoverplt.",,Font2,custom,@_col
        if awayteam.movetype=2 then draw string(sidebar,l*_fh2), "Trp.: Jetpacks",,Font2,custom,@_col
        if awayteam.movetype=3 then draw string(sidebar,l*_fh2), "Trp.: Jetp&Hover",,Font2,custom,@_col
        if artflag(9)=1 then
            l+=1
            draw string(sidebar,l*_fh2), "      Teleport",,Font2,custom,@_col
        endif
        l+=1
        draw string(sidebar,l*_fh2),"Speed: "&awayteam.speed,,Font2,Custom,@_col
        xoffset=xoffset+8

        l+=2
        draw string(sidebar,l*_fh2),"Armor:    "&awayteam.armor,,Font2,custom,@_col
        l+=1
        draw string(sidebar,l*_fh2),"Firearms: "&awayteam.guns_to,,Font2,custom,@_col
        l+=1
        draw string(sidebar,l*_fh2),"Melee:    "&awayteam.blades_to,,Font2,custom,@_col
        if player.stuff(3)=2 then
            l+=1
            draw string(sidebar,l*_fh2),"Alien Scanner",,font2,custom,@_col
            l+=1
            draw string(sidebar,l*_fh2),adislastenemy-adisdeadcounter &" Lifeforms ",,Font2,custom,@_col
        endif
        calc_resrev
        l+=2
        draw string(sidebar,l*_fh2),"Map Data  :"& cint(reward(7)),,Font2,custom,@_col
        l+=1
        draw string(sidebar,l*_fh2), "Bio Data  :"& cint(reward(1)),,Font2,custom,@_col
        l+=1
        draw string(sidebar,l*_fh2), "Resources :"& cint(reward(2)),,Font2,custom,@_col
        
        for a=1 to player.h_maxweaponslot
            if player.weapons(a).heat>0 then
                l+=2
                l=l+textbox(trim("{15}"&weapon_text(player.weapons(a))),sidebar,(l)*_fh2,20,,0,1)+1
            endif
        next
        
        if (awayteam.movetype=2 or awayteam.movetype=3) and awayteam.hp>0 then
            set__color( 11,0)
            l+=1
            draw string(sidebar,l*_fh2), "Jetpackfuel: ",,Font2,custom,@_col
            set__color( 10,0)
            if awayteam.jpfuel<awayteam.jpfuelmax*.5 then set__color( 14,0)
            if awayteam.jpfuel<awayteam.jpfuelmax*.3 then set__color( 12,0)
            if awayteam.jpfuel<0 then awayteam.jpfuel=0
            if awayteam.hp>0 then
                draw string(sidebar+13*_fw2,l*_fh2), ""&int(awayteam.jpfuel/awayteam.hp),,Font2,custom,@_col
            else
                draw string(sidebar+13*_fw2,l*_fh2), ""&awayteam.jpfuel,,Font2,custom,@_col
            endif
        endif

        if tVersion.gameturn mod 15=0 then low_morale_message

        set__color( 11,0)
        l+=1
        draw string(sidebar,l*_fh2),"Oxygen: ",,Font2,custom,@_col
        set__color( 10,0)
        if awayteam.oxygen<50 then set__color( 14,0)
        if awayteam.oxygen<25 then set__color( 12,0)
        if awayteam.hp>0 then
            draw string(sidebar+8*_fw2,l*_fh2),""&int(awayteam.oxygen/awayteam.hp),,Font2,custom,@_col
        else
            draw string(sidebar+8*_fw2,l*_fh2),""&awayteam.oxygen,,Font2,custom,@_col
        endif
        set__color( 11,0)
        l+=2
        draw string(sidebar,l*_fh2),"Temp: " &round_nr(adisloctemp,1) &chr(248)&"C",,Font2,custom,@_col
        l+=1
        draw string(sidebar,l*_fh2),"Gravity: " &planets(map).grav,,Font2,custom,@_col
        if len(trim(tmap(awayteam.c.x,awayteam.c.y).desc))<18 then
            l+=1
            draw string(sidebar,l*_fh2),tmap(awayteam.c.x,awayteam.c.y).desc,,Font2,custom,@_col ';planetmap(awayteam.c.x,awayteam.c.y,map)
        else
            rlprint tmap(awayteam.c.x,awayteam.c.y).desc '&planetmap(awayteam.c.x,awayteam.c.y,map)
        endif
        l+=2
        draw string(sidebar,l*_fh2),"Credits: " &credits(player.money),,Font2,custom,@_col
        l+=1
        draw string(sidebar,l*_fh2),display_time(tVersion.gameturn),,Font2,custom,@_col
#if __FB_DEBUG__
        draw string(sidebar,26*_fh2),"life:" &planets(map).life,,Font2,custom,@_col
#endif

        comstr.display(l+2)


    return 0
end function


function gainxp(typ as short,v as short=1) as string
    dim as short a,lowest,slot
    lowest=100
    if typ<=5 then
        for a=0 to 128
            if crew(a).typ=typ and crew(a).hp>0 then
                if crew(a).xp<lowest then
                    slot=a
                    lowest=crew(a).xp
                endif
            endif
        next
    else
        slot=typ
    endif
    if crew(slot).hp>0 and crew(slot).xp>=0 then
        crew(slot).xp+=v
        return crew_desig(crew(slot).typ) &" " &crew(slot).n &" has gained "&v &" Xp."
    endif
    return ""
end function


function alerts() as short
    dim a as short
    static wg as short
    static wj as short
    if awayteam.oxygen=awayteam.oxymax then wg=0
    if awayteam.jpfuel=awayteam.jpfuelmax and awayteam.movetype=2 then wj=0
    if int(awayteam.oxygen<awayteam.oxymax*.5) and wg=0 and awayteam.helmet=1 then
        rlprint ("Reporting oxygen tanks half empty",14)
		play_sound(1,1,150)
        walking=0
        if configflag(con_sound)=2 then no_key=keyin(" "&key__enter &key__esc)
    endif
    if int(awayteam.oxygen<awayteam.oxymax*.25) and wg=1 and awayteam.helmet=1 then
        rlprint ("Oxygen low.",14)
		play_sound(1,2,250)
        walking=0
        if configflag(con_sound)=2 then no_key=keyin(" "&key__enter &key__esc)
    endif
    if int(awayteam.oxygen<awayteam.oxymax*.125) and wg=2 and awayteam.helmet=1 then
        rlprint ("Switching to oxygen reserve!",12)
		play_sound(1,3,200)
        walking=0
        if configflag(con_sound)=2 then no_key=keyin(" "&key__enter &key__esc)
    endif
    if awayteam.jpfuel<awayteam.jpfuelmax then
        if awayteam.jpfuel/awayteam.jpfuelmax<.5 and wj=0 then
            rlprint ("Jetpack fuel low",14)
			play_sound(1,1,150)
            walking=0
        endif
        if awayteam.jpfuel/awayteam.jpfuelmax<.3 and wj=1 then
            rlprint ("Jetpack fuel very low",14)
			play_sound(1,2,250) 
			if configflag(con_sound)=2 then no_key=keyin(" "&key__enter &key__esc)
            walking=0
        endif

        if awayteam.jpfuel<5 and wj=2 then
            rlprint ("Switching to jetpack fuel reserve",12)
			play_sound(1,3,200)
			if configflag(con_sound)=2 then no_key=keyin(" "&key__enter &key__esc)
            walking=0
        endif
    else
        wj=0
    endif
    return walking
end function




function cure_awayteam(where as short) as short
    dim as short bonus,pack,cured,sick,a,biodata
    dim as string text
    for a=0 to 128
        if crew(a).hp>0 and crew(a).disease>0 then sick+=1
    next
    if sick=0 then return 0
    sick=0
    if where=0 then 'On planet=0 On Ship=1
        if configflag(con_chosebest)=0 then
            pack=findbest(19,-1)
        else
            pack=get_item()
            if item(pack).ty<>19 then
                rlprint "You can't use that",14
                pack=-1
            endif
        endif
        if pack>0 then
            rlprint "Using "&item(pack).desig &".",10
            bonus=item(pack).v1
            destroyitem(pack)
        else
            bonus=-3
        endif
    else
        bonus=findbest(21,-1)+3
    endif

    for a=0 to 128
        if crew(a).hpmax>0 and crew(a).hp>0 and (crew(a).onship=where or where=1) then
            if crew(a).disease>0 then
                if skill_test(bonus+player.doctor(location)+add_talent(5,17,1),st_average+crew(a).disease/2,"Doctor") then
                    biodata+=crew(a).disease*2
                    crew(a).disease=0
                    crew(a).onship=crew(a).oldonship
                    crew(a).oldonship=0
                    cured+=1
                endif
            endif
            if crew(a).disease>0 then sick+=1
        endif
    next
    reward(1)+=biodata 'Cured a disease
    if crew(1).disease=0 then crew(1).onship=0
    if cured>1 then rlprint cured &" members of your crew where cured (gained "& biodata &" biodata).",10
    if cured=1 then rlprint cured &" member of your crew was cured (gained "& biodata &" biodata).",10
    if cured=0 and sick>0 then rlprint "No members of your crew where cured.",14
    if sick>0 then rlprint sick &" are still sick.",14
    if cured>0 then rlprint gainxp(5),c_gre
    return 0
end function



function rnd_crewmember(onship as short=0) as short
    dim pot(128) as short
    dim as short p,a
    for a=0 to 128
        if crew(a).hp>0 and crew(a).onship=onship then
            p+=1
            pot(p)=a
        endif
    next
    return pot(rnd_range(1,p))
end function


function diseaserun(onship as short) as short
    dim as short a,b,dam,total,affected,dis,distotal
    dim text as string
    for a=2 to 128
        if crew(a).hpmax>0 and crew(a).hp>0 and crew(a).disease>0 then
            if crew(a).incubation>0 then
                rlprint a &":"&crew(a).incubation
                crew(a).incubation-=1
                if crew(a).incubation=0 then rlprint crew(a).n &" "& disease(crew(a).disease).desig &".",14
            else
                if crew(a).duration>0 then
                    crew(a).duration-=1
                    if rnd_range(1,100)<disease(crew(a).disease).contagio then
                        b=rnd_crewmember
                        if crew(a).onship=crew(b).onship then
                            crew(b).disease=crew(a).disease
                            crew(b).oldonship=crew(b).onship
                            crew(b).duration=disease(crew(a).disease).duration
                            crew(b).incubation=disease(crew(a).disease).incubation
                        endif
                    endif
                    if crew(a).duration=0 then
                        crew(a).disease=0
                        if rnd_range(1,100)+player.doctor(0)*5<disease(crew(a).disease).fatality then
                            if crew(a).onship=onship then rlprint crew(a).n &" dies from disease.",12
                            crew(a)=crew(0)
                            crew(a).disease=0

                        else
                            if crew(a).onship=onship then rlprint crew(a).n &" recovers.",10
                            crew(a).onship=crew(a).oldonship
                            crew(a).disease=0
                        endif
                    endif
                endif
            endif
        endif
        if crew(a).disease>dis then dis=crew(a).disease
    next
    player.disease=dis
    return 0
end function


function heal_awayteam(byref a as _monster,heal as short) as short
    dim as short b,c,ex,fac,h
    static reg as single
    static doc as single
    for b=1 to a.hpmax
        if crew(b).hp>0 and crew(b).hp<crew(b).hpmax then ex=ex+1
        diseaserun(b)
        if crew(b).hp>0 and crew(b).onship=0 then doc+=crew(b).talents(29)/50 'Paramedics
    next
    fac=findbest(24,-1)

    if fac>0 then
        if item(fac).v1>0 then reg=reg+0.1
    endif
    if player.doctor(1)>0 then
       doc=doc+player.doctor(1)/25+add_talent(5,17,.1)
    endif
    if heal>0 then heal=heal+player.doctor(1)+add_talent(5,19,3)
    if reg>=1 then
        heal=heal+reg
        reg=0
        h=1
    endif
    if doc>=1 then
        if skill_test(player.doctor(1),st_hard) then
            heal=heal+doc
            h=1
        endif
        doc=0
    endif
    do
        ex=0
        for b=1 to 128
            if heal>0 and crew(b).hp<crew(b).hpmax and crew(b).hp>0 then
                heal=heal-1
                if h=1 then h=2
                crew(b).hp=crew(b).hp+1
                ex=ex+1
            endif
        next
    loop until heal=0 or ex=0
    if player.doctor(1)>0 and h=2 then
        rlprint "The doctor fixes some cuts and bruises"
        rlprint gainxp(5),c_gre
    endif
    if fac>0 and h=2 then
        rlprint "the nanobots heal your wounded"
        item(fac).v1=item(fac).v1-1
    endif
    hpdisplay(a)
    return heal
end function

function infect(a as short,dis as short) as short
    dim as short roll
    roll=rnd_range(1,6) +rnd_range(1,6)+player.doctor(location)
    if roll<maximum(3,dis) and crew(a).hp>0 and crew(a).hpmax>0 then
        crew(a).disease=dis
        crew(a).oldonship=crew(a).onship
        crew(a).duration=disease(dis).duration
        crew(a).incubation=disease(dis).incubation
        if dis>player.disease then player.disease=dis
    endif
    return 0
end function


function wear_armor(a as short,b as short) as short
    dim as short invisibility
    awayteam.secarmo(a)=item(b).v1
    if item(b).v2>crew(a).augment(9) then
        invisibility=item(b).v2
    else
        invisibility=crew(a).augment(9)
    endif
    if awayteam.invis<invisibility then awayteam.invis=invisibility
    crew(a).armo=b
    item(b).w.s=-2
    awayteam.armor+=item(b).v1
    awayteam.oxymax+=item(b).v3
    return 0
end function


function equip_awayteam(m as short) as short
    dim as short a,b,c,wavg,aavg,tdev,jpacks,hovers,cmove,infra,robots,crewcount,atcost,squadlcount
    dim as single oxytanks,oxy
    dim as short cantswim,cantfly,invisibility
    dim as byte debug=0
    cmove=awayteam.movetype
    awayteam.jpfueluse=0
    awayteam.stuff(1)=0
    awayteam.armor=0
    awayteam.guns_to=0
    awayteam.blades_to=0
    awayteam.light=0
    awayteam.jpfueluse=0
    awayteam.jpfuelmax=0
    for a=0 to lastitem
        if item(a).w.s=-2 then item(a).w.s=-1
    next
    for a=0 to lastitem
        if item(a).ty=1 and item(a).v1=1 and item(a).w.s=-1 then hovers=hovers+1
        if item(a).ty=1 and item(a).v1=2 and item(a).w.s=-1 then jpacks=jpacks+1
    next
    for a=1 to 128 'determine fuel use
        'if crew(a).hp>0 and crew(a).onship=0 then awayteam.hp+=1
        if crew(a).hp>0 and crew(a).onship=0 then
            crewcount+=1
            if crew(a).typ=13 then robots+=1
            if crew(a).talents(27)>0 then squadlcount+=1
            atcost+=crew(a).atcost
            if jpacks>0 then
                crew(a).jp=1
                awayteam.jpfueluse+=1
                jpacks-=1
            else
                crew(a).jp=0
            endif
        endif
    next
    hovers=0
    jpacks=0

    for a=0 to lastitem
        if item(a).ty=1 and item(a).v1=1 and item(a).w.s=-1 then hovers=hovers+item(a).v2
        if item(a).ty=1 and item(a).v1=2 and item(a).w.s=-1 then jpacks=jpacks+1
    next
    infra=2
    awayteam.invis=6
    awayteam.oxymax=0
    awayteam.oxydep=0
    for a=1 to 128
        crew(a).weap=0
        crew(a).armo=0
        crew(a).blad=0
        if crew(a).hp>0 and crew(a).onship=0 and crew(a).equips<>1 then
            if crew(a).pref_ccweap>0 then
                c=0
                for b=0 to lastitem
                    if item(b).uid=crew(a).pref_ccweap then
                        c=b
                        exit for
                    endif
                next
                if c>0 then
                    awayteam.secweapc(a)=item(c).v1
                    awayteam.blades_to=awayteam.blades_to+item(c).v1
                    crew(a).blad=c
                    item(c).w.s=-2
                    'rlprint crew(a).n &" grabs his "&item(c).desig
                endif
            endif
            if crew(a).pref_lrweap>0 then
                c=0
                for b=0 to lastitem
                    if item(b).uid=crew(a).pref_lrweap then
                        c=b
                        exit for
                    endif
                next
                if c>0 then
                    awayteam.secweap(a)=item(c).v1
                    awayteam.secweapran(a)=item(c).v2
                    awayteam.secweapthi(a)=item(c).v3
                    awayteam.guns_to=awayteam.guns_to+item(c).v1
                    crew(a).weap=c
                    item(c).w.s=-2
                    'rlprint crew(a).n &" grabs his "&item(c).desig
                endif
            endif
            if crew(a).pref_armor>0 then
                c=0
                for b=0 to lastitem
                    if item(b).uid=crew(a).pref_armor then
                        c=b
                        exit for
                    endif
                next
                if c>0 then
                    wear_armor(a,c)
                    'rlprint crew(a).n &" grabs his "&item(c).desig
                endif
            endif
        endif
    next

    for a=1 to 128
        'find best ranged weapon
        'give to redshirt

        if crew(a).hp>0 and crew(a).onship=0 and crew(a).equips<>1 then
            if crew(a).augment(7)=0 then
                cantswim+=1
            else
                hovers+=1
            endif

            if crew(a).augment(8)=0 then
                cantfly+=1
            else
                jpacks+=1
                awayteam.jpfueluse+=1
            endif

            'Find best Jetpack(V3 lowest value)
            'Give to crewmember


            if crew(a).equips<>1 then
                b=-1
                if crew(a).equips<>1 then b=findbest(2,-1)
                if b>-1 and crew(a).weap=0 then
                    'rlprint "Equipping "&item(b).desig & b
                    awayteam.secweap(a)=item(b).v1
                    awayteam.secweapran(a)=item(b).v2
                    awayteam.secweapthi(a)=item(b).v3
                    awayteam.guns_to=awayteam.guns_to+item(b).v1
                    crew(a).weap=b
                    item(b).w.s=-2
                endif
                'find best armor
                b=-1
                if crew(a).equips=0 then b=findbest(3,-1)
                if crew(a).equips=2 then b=findbest(103,-1)'Squidsuit
                'give to redshirt
                if b>-1 and crew(a).armo=0 then
                    wear_armor(a,b)
                else
                    awayteam.invis=0
                endif
                if crew(a).augment(8)=0 then
                    b=findbest_jetpack()
                    awayteam.jpfueluse=0
                    if b>0 then
                        item(b).w.s=-2
                        awayteam.jpfueluse+=item(b).v3
                    endif
                endif
            endif
            oxy=.75
            b=findbest(17,-1)
            if b>-1 then
                item(b).w.s=-2
                oxy=oxy-item(b).v1
            endif
            if crew(a).augment(3)>1 then oxy=oxy-.3
            if oxy<0 then oxy=.1
            if crew(a).typ=13 then oxy=0
            awayteam.oxydep=awayteam.oxydep+oxy
            if crew(a).hpmax>0 and crew(a).onship=0 and crew(a).equips=0 then
                b=findbest(14,-1)
                if b>-1 then
                    item(b).w.s=-2
                    awayteam.oxymax=awayteam.oxymax+item(b).v1
                endif
            endif
            if crew(a).hpmax>0 and crew(a).onship=0 and crew(a).jp=1 or crew(a).augment(8)=1 then
                b=findbest(28,-1)
                if b>-1 then
                    item(b).w.s=-2
                    awayteam.jpfuelmax=awayteam.jpfuelmax+50+item(b).v1
                else
                    awayteam.jpfuelmax=awayteam.jpfuelmax+50
                endif
            endif
        endif
    next

    for a=128 to 1 step -1
        b=findbest(4,-1)
        'give to redshirt
        if crew(a).hp>0 and crew(a).onship=0 and crew(a).equips=0 and crew(a).blad=0 then
            if b>-1 then
                'rlprint "Equipping "&item(b).desig & b
                awayteam.secweapc(a)=item(b).v1
                awayteam.blades_to=awayteam.blades_to+item(b).v1
                crew(a).blad=b
                item(b).w.s=-2
            endif
        endif
    next
    'rlprint ""&awayteam.move
    'count teleportation devices
    awayteam.movetype=0
    if awayteam.movetype<4 and cantswim<=hovers then awayteam.movetype=1
    if awayteam.movetype<4 and cantfly<=jpacks*1.5+robots*2 then awayteam.movetype+=2
    awayteam.carried=cantfly-jpacks-robots*2
    if awayteam.carried<0 then awayteam.carried=0
    if cantfly-jpacks-robots*2>0 then awayteam.jpfueluse=awayteam.jpfueluse+(cantfly-jpacks-robots*2) 'The ones that need to be carried use extra fuel

    awayteam.nohp=hovers
    awayteam.nojp=jpacks*1.5+robots*2
    if findbest(5,-1)>-1 then awayteam.stuff(5)=item(findbest(5,-1)).v1
    if findbest(17,-1)>-1 then awayteam.stuff(4)=.2
    if findbest(46,-1)>-1 then awayteam.invis=7
    awayteam.sight=3
    awayteam.light=0
    if findbest(8,-1)>-1 then awayteam.sight=awayteam.sight+item(findbest(8,-1)).v1
    if findbest(9,-1)>-1 then awayteam.light=item(findbest(9,-1)).v1
    if awayteam.oxygen>awayteam.oxymax then awayteam.oxygen=awayteam.oxymax
    if awayteam.jpfuel>awayteam.jpfuelmax then awayteam.jpfuel=awayteam.jpfuelmax
    awayteam.jpfueluse=awayteam.jpfueluse*planets(m).grav
    awayteam.oxydep=awayteam.oxydep*awayteam.helmet

    awayteam.atcost=atcost/crewcount

    crewcount=crewcount-squadlcount*5
    if crewcount<0 then crewcount=0
    awayteam.speed=10+awayteam.movetype+add_talent(-1,24,0)-crewcount/20

    return 0
end function


function no_spacesuit(who() as short,byref alle as short=0) as short
    dim as short i,last
    alle=1
    for i=1 to 128
        if crew(i).hp>0 then
            if crew(i).onship=0 and crew(i).armo=0 and crew(i).equips=0 then
                last+=1
                who(last)=i
            else
                alle=0 'At least one crewmember has a spacesuit
            endif
        endif
    next
    return last
end function


function dam_awayteam(dam as short, ap as short=0,disease as short=0) as string
    dim text as string
    dim as short ex,b,t,last,last2,armeff,reequip,roll,cc,tacbonus,suitdamage
    dim target(128) as short
    dim stored(128) as short
    dim injured(16) as short
    dim killed(16) as short
    dim desc(16) as string
    desc(1)="Captain"
    desc(2)="Pilot"
    desc(3)="Gunner"
    desc(4)="Science officer"
    desc(5)="Ships doctor"
    desc(6)="Sec. member"
    desc(7)="Sec. member"
    desc(8)="Sec. member"
    desc(9)="Insect warrior"
    desc(10)="Cephalopod"
    desc(11)="Neodog"
    desc(12)="Neoape"
    desc(13)="Robot"
    desc(14)="Squad Leader"
    desc(15)="Sniper"
    desc(16)="Paramedic"
    'ap=1 Ignores Armor
    'ap=2 All on one, carries over
    'ap=3 All on one, no carrying over
    'ap=4 Ignores Armor, Robots immune
    'ap=5 No Spacesuits
    
#if __FB_DEBUG__
#endif
    dim as short local_debug=0
    if local_debug=1 then text=text & "in:"&dam

    if abs(player.tactic)=2 then dam=dam-player.tactic
    if dam<0 then dam=1
    if ap=5 then
        last=no_spacesuit(target(),b) 'Don't need the b
        if last=0 then return ""
        for b=1 to last
            stored(b)=crew(target(b)).hp
        next
    else
        for b=1 to 128
            if (crew(b).hpmax>0 and crew(b).hp>0 and crew(b).onship=0) then
                last+=1
                target(last)=b
                stored(b)=crew(b).hp
            endif
        next
    endif
    
    if last>128 then last=128
    cc=0
    do
        cc+=1
        t=rnd_range(1,last)
        if crew(target(t)).hp>0 then
            if ap=2 then
                dam=dam-crew(target(t)).hp
                crew(target(t)).hp=dam
            endif
            if ap=3 then
                crew(target(t)).hp=crew(target(t)).hp-dam
                dam=0
            endif
            if ap=0 or ap=1 or ap=4 then
                if player.tactic=3 then 'No tactic bonus for using nonlethal
                    tacbonus=0
                else
                    tacbonus=player.tactic
                endif
                roll=rnd_range(1,25)
                if local_debug=1 then text=text &":" &roll &":"&awayteam.secarmo(target(t))+crew(target(t)).augment(5)+player.tactic+add_talent(3,10,1)+add_talent(t,20,1)
                if roll>2+awayteam.secarmo(target(t))+crew(target(t)).augment(5)+tacbonus+add_talent(3,10,1)+add_talent(t,20,1) or ap=4 or ap=1 or roll=25 then
                    if not(crew(target(t)).typ=13 and ap=4) then crew(target(t)).hp=crew(target(t)).hp-1
                    dam=dam-1
                else
                    armeff+=1
                endif
                if crew(target(t)).armo>0 then
                    if item(crew(target(t)).armo).ti_no<2019 then 
                        if item(crew(target(t)).armo).v4=0 then item(crew(target(t)).armo).id+=2000
                        item(crew(target(t)).armo).v4+=1
                        suitdamage+=1
                    endif
                endif
            endif
        endif
        last=0
        for b=1 to 128
            if (crew(b).hpmax>0 and crew(b).hp>0 and crew(b).onship=0) then
                last+=1
                target(last)=b
            endif
        next
    loop until dam<=0 or ex=1 or cc>9999
    dam=0
    for b=1 to 128
        if crew(b).onship=0 and crew(b).hpmax>0 then
            if stored(b)>crew(b).hp then
                if crew(b).hp<=0 then
                    killed(crew(b).typ)+=1
                    reequip=1
                else
                    injured(crew(b).typ)+=1
                endif
            endif
        endif
    next
    if armeff>0 then text=text &" "&armeff &" prevented by armor. "

    for b=1 to 16
        if injured(b)>0 then
            walking=0
            if injured(b)>1 then
                text=text &injured(b) &" "&desc(b)&"s injured. "
            else
                text=text &desc(b)&" injured. "
            endif
        endif
    next
    for b=1 to 16
        player.deadredshirts=player.deadredshirts+killed(b)
        if killed(b)>0 then
            walking=0
            if killed(b)>1 then
                text=text &killed(b) &" "&desc(b)&"s killed. "
            else
                text=text &desc(b)&" killed. "
            endif
            changemoral(-3*killed(b),0)
        endif
    next
    if suitdamage>0 then text=text &suitdamage &" damage to spacesuits."
    awayteam.leak+=suitdamage
    if configflag(con_damscream)=0 then
		play_sound(12)
        sleep 100
    endif
    sleep 25

    if reequip=1 then 
        sort_crew
        equip_awayteam(player.map)
    endif
    if local_debug=1 then text=text & " Out:"&dam
    return trim(text)
end function

function repair_spacesuits(v as short=-1) as short
    dim as short b,i,c
    for b=1 to 128
        if (crew(b).hpmax>0 and crew(b).hp>0 and crew(b).onship=0) then
            if crew(b).armo>0 then
                i=crew(b).armo
                if (v=-1 or v>0) and item(i).v4>0 then 
                    awayteam.leak-=item(i).v4
                    item(i).v4=0
                    item(i).id-=2000
                    if v>0 then v-=1
                    c+=1
                endif
            endif
        endif
    next
    if c=1 then rlprint "Repaired a spacesuit."
    if c>1 then rlprint "Repaired " &c & " spacesuits."
    return 0
end function


function pathblock(byval c as _cords,byval b as _cords,mapslot as short,blocktype as short=1,col as short=0, delay as short=25,rollover as byte=0) as short
    dim as single px,py
    dim deltax as single
    dim deltay as single
    dim numtiles as single
    dim l as single
    dim  as short result
    dim text as string
    dim as short co,i,osx
    Dim As Integer d, dinc1, dinc2
    Dim As Integer x, xinc1, xinc2
    Dim As Integer y, yinc1, yinc2
    
    if abs(c.x-b.x)>30 then
        if c.x>b.x then
            b.x+=61
        else
            c.x+=61
        endif
    endif
    osx=calcosx(awayteam.c.x,rollover)
    deltax = Abs(c.x - b.x)
    deltay = Abs(c.y - b.y)
    If deltax >= deltay Then
        numtiles = deltax 
        d = (2 * deltay) - deltax
        dinc1 = deltay Shl 1
        dinc2 = (deltay - deltax) Shl 1
        xinc1 = 1
        xinc2 = 1
        yinc1 = 0
        yinc2 = 1
    Else
        numtiles = deltay 
        d = (2 * deltax) - deltay
        dinc1 = deltax Shl 1
        dinc2 = (deltax - deltay) Shl 1
        xinc1 = 0
        xinc2 = 1
        yinc1 = 1
        yinc2 = 1
    End If

    If c.x > b.x Then
        xinc1 = - xinc1
        xinc2 = - xinc2
    End If
   
    If c.y > b.y Then
        yinc1 = - yinc1
        yinc2 = - yinc2
    End If

    x = c.x
    y = c.y
    result=-1
    For i = 1 To numtiles
        
        If d < 0 Then
          d = d + dinc1
          x = x + xinc1
          y = y + yinc1
        Else
          d = d + dinc2
          x = x + xinc2
          y = y + yinc2
        End If
        if rollover>0 then 
            if x<0 then x=0
            if x>60 then x=60
        else
            if x>60 then x-=61
            if x<0 then x+=61
        endif
        
        if y<0 then y=0
        if y>20 then y=20
        
        if blocktype=1 or blocktype=3 or blocktype=4 then 'check for firetru
           if tmap(x,y).firetru=1  then 
                if not (x=b.x and y=b.y) then
                    result=0
                    if blocktype=3 or blocktype=4 then
                       b.x=x
                       b.y=y
                       return 0
                    endif
                endif
            endif
            if col>0 then 
                if configflag(con_tiles)=0 then
                    put((x-osx)*_fw1,y*_fh1),gtiles(gt_no(75)),trans
                else
                    set__color( col,0)
                    draw string(x*_fw1,y*_fh1),"*",,font1,custom,@_col
                endif
                sleep delay
            endif
        endif
        if blocktype=2 then
            if combatmap(x,y)=7 or combatmap(x,y)=8 then
                combatmap(x,y)=0
                return 0
            endif
            if col>0 and co<l then 
                draw string(x*_fw1,y*_fh1),"*",,font1,custom,@_col
            endif
        endif
        if blocktype=5 then
            if tmap(x,y).seetru<>0 then return -1
        endif
            
    next
    if blocktype=5 then return 0
    if blocktype=2 then sleep delay
    return result
end function


function ep_checkmove(ByRef old As _cords,Key As String) As Short
    Dim As Short slot,a,b,c,who(128)
    slot=player.map
    If planetmap(awayteam.c.x,awayteam.c.y,slot)=18 Then
        rlprint "you get zapped by a forcefield:"&dam_awayteam(rnd_range(1,6)),12
        If awayteam.armor/awayteam.hp<13 Then awayteam.c=old
        walking=0
    EndIf
    If tmap(awayteam.c.x,awayteam.c.y).locked>0 Then
        b=findbest(12,-1) 'Find best key
        If b>0 Then
            c=item(b).v1
        Else
            c=0
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).no=45 And tmap(old.x,old.y).no<>45 And configflag(con_warnings)=0 Then
        If Not(askyn("do you really want to walk into hot lava?(y/n)")) Then awayteam.c=old
    EndIf

    If vacuum(awayteam.c.x,awayteam.c.y)=1 And vacuum(old.x,old.y)=0 And configflag(con_warnings)=0 Then
        If no_spacesuit(who())>0 Then
            If Not(askyn("do you really want to walk out into the vacuum?(y/n)")) Then awayteam.c=old
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).onopen>0 Then
        planetmap(awayteam.c.x,awayteam.c.y,slot)=tmap(awayteam.c.x,awayteam.c.y).onopen
        tmap(awayteam.c.x,awayteam.c.y)=tiles(tmap(awayteam.c.x,awayteam.c.y).onopen)
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).locked>0 Then
        If Not(skill_test(player.science(1)+c,7+tmap(awayteam.c.x,awayteam.c.y).locked,"Science")) Then' or (tmap(awayteam.c.x,awayteam.c.y).onopen>0 and tmap(awayteam.c.x,awayteam.c.y).locked=0) then
            rlprint "Your science officer can't bypass the doorlocks"
            awayteam.c=old
            walking=0
        EndIf
    Else
        tmap(awayteam.c.x,awayteam.c.y).locked=0
        If tmap(awayteam.c.x,awayteam.c.y).onopen>0 Then tmap(awayteam.c.x,awayteam.c.y)=tiles(tmap(awayteam.c.x,awayteam.c.y).onopen)
        If tmap(awayteam.c.x,awayteam.c.y).no=16 Then planetmap(awayteam.c.x,awayteam.c.y,slot)=144
        If tmap(awayteam.c.x,awayteam.c.y).no=93 Then planetmap(awayteam.c.x,awayteam.c.y,slot)=90
        If tmap(awayteam.c.x,awayteam.c.y).no=94 Then planetmap(awayteam.c.x,awayteam.c.y,slot)=91
        If tmap(awayteam.c.x,awayteam.c.y).no=95 Then planetmap(awayteam.c.x,awayteam.c.y,slot)=92
    EndIf

    If planetmap(awayteam.c.x,awayteam.c.y,slot)=54 Then
        If c>0 Then
            item(b)=item(lastitem)
            lastitem=lastitem-1
        EndIf
        If skill_test(player.science(location)+c,st_average) Then
            If skill_test(player.science(location)+c,st_average,"Science") Then
                rlprint "You managed to open the door"
                planetmap(awayteam.c.x,awayteam.c.y,slot)=55
                tmap(awayteam.c.x,awayteam.c.y)=tiles(55)
            Else
                rlprint "Your science officer cant open the door"
                If rnd_range(1,6)+ rnd_range(1,6)>6 Then
                    rlprint "But he sets off an ancient defense mechanism! "&dam_awayteam(rnd_range(1,6))
                    player.killedby="trapped door"
                EndIf
                walking=0
                awayteam.c=old
            EndIf
        Else
            rlprint "Your fiddling with the ancient lock destroys it. You will never be able to open that door."
            planetmap(awayteam.c.x,awayteam.c.y,slot)=53
            walking=0
            awayteam.c=old
        EndIf
    EndIf


    If awayteam.movetype<tmap(awayteam.c.x,awayteam.c.y).walktru And configflag(con_diagonals)=0 Then
        awayteam.c=movepoint(old,bestaltdir(getdirection(Key),0),3)
        If awayteam.movetype<tmap(awayteam.c.x,awayteam.c.y).walktru Then awayteam.c=movepoint(old,bestaltdir(getdirection(Key),1))
    EndIf
    If tmap(awayteam.c.x,awayteam.c.y).walktru>awayteam.movetype Then '1= can swim 2= can fly 3=can swim and fly 4= can teleport
        awayteam.c=old
    Else
        'Terrain needs flying or swimmint
        If tmap(awayteam.c.x,awayteam.c.y).walktru=1 Then
            If awayteam.movetype=2 Then
                If awayteam.hp<=awayteam.nojp Then
                    If awayteam.jpfuel>=awayteam.jpfueluse Then
                        awayteam.jpfuel=awayteam.jpfuel-awayteam.jpfueluse
                        awayteam.e.add_action(awayteam.carried)
                    Else
                        rlprint "Jetpacks empty",14
                        awayteam.c=old
                    EndIf
                Else
                    awayteam.c=old
                    rlprint "blocked"
                EndIf
            EndIf
        EndIf
        'Terrain needs flying
        If tmap(awayteam.c.x,awayteam.c.y).walktru=2 Then
            If awayteam.movetype<4 Then
                If awayteam.hp<=awayteam.nojp Then
                    If awayteam.jpfuel>=awayteam.jpfueluse Then
                        awayteam.jpfuel=awayteam.jpfuel-awayteam.jpfueluse
                        awayteam.e.add_action(awayteam.carried)
                    Else
                        rlprint "Jetpacks empty",14
                        awayteam.c=old
                    EndIf
                Else
                    awayteam.c=old
                    rlprint "blocked"
                EndIf
            EndIf
        EndIf
        If tmap(awayteam.c.x,awayteam.c.y).walktru=4 Then
            If Not(askyn("Do you really want to step over the edge?(y/n)")) Then awayteam.c=old
        EndIf
    EndIf
    If old.x=awayteam.c.x And old.y=awayteam.c.y Then
        If walking>0 And walking<10 Then walking=0
    Else
        awayteam.add_move_cost
        awayteam.e.add_action(tmap(awayteam.c.x,awayteam.c.y).movecost)
    EndIf
    Return 0
End function


function giveitem(e as _monster,nr as short) as short
    dim as short a
    dim it as _items
    rlprint "What do you want to offer the "&e.sdesc &"?"
    a=get_item()
    if a>0 then
     if (e.lang=6 or e.lang=7) and (item(a).ty=2 or item(a).ty=7 or item(a).ty=4) then
         item(a).w.p=nr
         item(a).w.s=0
         it=make_item(96,-1,-3)
         placeitem(it,0,0,0,0,-1)
         reward(2)=reward(2)+it.v5
         rlprint "The reptile gladly accepts the weapon 'This will help us in eradicating the other side' and hands you some "&it.desig
         return 0
     endif
     if e.allied>0 then
         if item(a).price>100 then
            rlprint "The "&e.sdesc &" accepts the gift."
            factionadd(0,e.allied,-5)
            item(a).w.p=nr
            item(a).w.s=0
            if e.aggr=2 and rnd_range(1,6)+rnd_range(1,6)<e.intel then 
                e.aggr=1
            endif
            return 0
        else
            rlprint "The "&e.desc &" doesn't want the "&item(a).desig &"."
        endif
    endif
         
    if e.lang=4 then
        if item(a).price>1000 then       
            item(a).w.p=nr
            item(a).w.s=0     
            rlprint "Apollo accepts your tribute"
            e.aggr=1
        else
            rlprint "'You can't soothe me with such worthless trinkets!'"
        endif
    endif
     
    if (e.lang=28) and (item(a).ty=2 or item(a).ty=7 or item(a).ty=4) then
        item(a).w.p=nr
        item(a).w.s=0
        rlprint "The worker hides the "&item(a).desig &"quickly saying 'Thank you, now if i only had a way to get off this rock'" 
        if rnd_range(1,6)<3 then e.faction=2
        return 0
    endif
     
     if (e.lang=40) then
        item(a).w.p=nr
        item(a).w.s=0
        rlprint "Thank you so much! I am sure I can find a use for this!"
        return 0
    endif
     rlprint "E:"&e.intel
     select case e.intel
        case is>6
            if rnd_range(1,6)+ rnd_range(1,6)<e.intel+e.lang+e.aggr*2 then
                rlprint "The "&e.sdesc &" accepts the gift."
                e.cmmod=e.cmmod+2
                if rnd_range(1,6)+ rnd_range(1,6)<e.intel+e.lang+e.aggr*2 then e.aggr=1
                item(a).w.p=nr
                item(a).w.s=0
                if e.aggr=1 and rnd_range(1,6) +rnd_range(1,6)<e.intel then
                    rlprint "The "&e.sdesc &" gives you something in return."
                    if rnd_range(1,100)<66 then
                        it=make_item(94)
                    else
                        it=make_item(96,-3,-3)
                        reward(2)=reward(2)+it.v5
                    endif
                    placeitem(it,0,0,0,0,-1)
                endif
            else
               rlprint "The "&e.sdesc &" doesn't want the "& item(a).desig &"."
            endif
        case else
            if item(a).ty=13 and rnd_range(1,6) +rnd_range(1,6)<e.intel+e.lang+e.aggr*2 then
                rlprint "The "&e.sdesc &" eats the "& item(a).desig &"."
                e.sleeping=e.sleeping+item(a).v1
                if e.sleeping>0 then rlprint "And falls asleep!"
                item(a)=item(lastitem)
                lastitem=lastitem-1
            else
                rlprint "The "&e.sdesc &" doesn't want the "& item(a).desig & "."
            endif
        end select
    endif
        
    return 0
end function


function ep_communicateoffer(Key As String) As Short
    Dim As Short a,b,slot,x,y,cm,monster
    Dim As _cords p2
    Dim As String dkey
    slot=player.map
    b=0
    For x=awayteam.c.x-1 To awayteam.c.x+1
        For y=awayteam.c.y-1 To awayteam.c.y+1
            For a=1 To lastenemy
                If enemy(a).c.x=x And enemy(a).c.y=y And enemy(a).hp>0 Then
                    cm+=1
                    monster=a
                EndIf
            Next

        Next
    Next
    If cm=1 Then
        p2.x=enemy(monster).c.x
        p2.y=enemy(monster).c.y
    Else
        rlprint "direction?"
        Do
            dkey=keyin
        Loop Until getdirection(dkey)>0 Or dkey=key__esc
        p2=movepoint(awayteam.c,getdirection(dkey))
    EndIf
    Locate p2.y+1,p2.x+1
    If Key=key_co And planetmap(p2.x,p2.y,slot)=190 Then
        rlprint "You hear a voice in your head: 'SUBJUGATE OF BE ANNIHILATED'"
        b=-1
    EndIf
    If Key=key_co And planetmap(p2.x,p2.y,slot)=191 Then do_dialog(1,enemy(lastenemy+1),0)
    For a=1 To lastenemy
        If p2.x=enemy(a).c.x And p2.y=enemy(a).c.y And enemy(a).hp>0 And enemy(a).sleeping<=0 Then b=a
    Next
    If b=0 Then
        If Key=key_co Then rlprint "Nobody there to communicate"
        If Key=key_of Then rlprint "Nobody there to give something to"
    EndIf
    If b>0 Then awayteam.e.add_action(10)
    If b>0 And Key=key_co Then communicate(enemy(b),slot,b)
    If b>0 And Key=key_of Then giveitem(enemy(b),b)
    Return 0
End function


function crew_menu(crew() as _crewmember, from as short, r as short=0,text as string="") as short
    dim as short b,bg,last,a,sit,cl,y,lines,xw,xhp,carl,dfirst,dlast
    dim dummy as _monster
    static p as short
    static offset as short
    dim n as string
    dim skills as string
    dim augments as string
    dim message as string
    dim onoff(2) as string
    dim debug as byte

    onoff(0)="On "
    onoff(1)=" - "
    onoff(2)="Off"
    last=count_crew(crew())
    if p=0 then p=1
    no_key=""
    equip_awayteam(0)
    lines=fix((tScreen.y)/(_fh2)) ' Stops last crew member for disappearing from screen
    lines-=6
    cls
    do
        set__color( 11,0)
        tScreen.set(0)
        cls
        message=""
        if no_key=key__enter then
            if r=0 then
                if from=0 then
                    if p>1 then
                        if crew(p).disease=0 then
                            select case crew(p).onship
                            case is=0
                                crew(p).onship=1
                            case is=1
                                crew(p).onship=0
                            end select
                        else
                            draw string (10,tScreen.y-_fh2*2), "Is sick and must stay on board.",,font2,custom,@_col
                        endif
                    else
                        if crew(p).onship=lc_onship and crew(p).disease=0 then
                            crew(p).onship=0
                            crew(p).oldonship=0
                        else
                            locate 22,1
                            set__color( 14,0)
                            draw string (10,tScreen.y-_fh2*2), "The captain must stay in the awayteam.",,font2,custom,@_col
                        endif
                    endif
                else
                    locate 22,1
                    set__color( 14,0)
                    draw string (10,tScreen.y-_fh2*2), "You need to be at the ship to reassign.",,font2,custom,@_col
                endif
            endif
            if r=1 then return p

        endif


        if no_key="e" then
            select case crew(p).equips
                case 0
                    crew(p).equips=2
                case 2
                    crew(p).equips=0
            end select
            equip_awayteam(0)
        endif

        if no_key="a" and r=1 then return -1'Install augment in all


        if no_key="s" then
            sit=get_item(0,0,0,1)
            if sit>0 then
'                for cl=1 to 128
'                    if crew(cl).pref_lrweap=item(sit).uid then crew(cl).pref_lrweap=0
'                    if crew(cl).pref_ccweap=item(sit).uid then crew(cl).pref_ccweap=0
'                    if crew(cl).pref_armor=item(sit).uid then crew(cl).pref_armor=0
'                next
                if item(sit).ty=2 then
                    crew(p).pref_lrweap=item(sit).uid
                endif
                if item(sit).ty=4 then
                    crew(p).pref_ccweap=item(sit).uid
                endif
                if item(sit).ty=3 then
                    crew(p).pref_armor=item(sit).uid
                endif
                equip_awayteam(0)
            endif
            cls
        endif

        if no_key="c" then
            crew(p).pref_lrweap=0
            crew(p).pref_ccweap=0
            crew(p).pref_armor=0
            equip_awayteam(0)

        endif

        y=0
        b=1
        'for b=1 to lines
        dfirst=0
        do
            if b=p+offset then
                bg=5
            else
                bg=0
            endif
            if b-offset>0 and b-offset<=128 then
                if dfirst=0 then dfirst=b-offset
                if crew(b-offset).hpmax>0 then
                    skills=""
                    augments=""
                    set__color( 0,bg)
                    draw string (0,y*_fh2), space(80),,font2,custom,@_col
                    draw string (0,(y+1)*_fh2), space(80),,font2,custom,@_col
                    draw string (0,(y+2)*_fh2), space(80),,font2,custom,@_col

                    skills=skill_text(crew(b-offset))
                    augments=augment_text(crew(b-offset))

                    if augments <> "" then draw string (0,(y+3)*_fh2), space(80),,font2,custom,@_col

                    if skills<>"" then skills=skills &" "
                    set__color( 15,bg)
                    if b-offset>9 then
                        draw string (0,y*_fh2), b-offset & " ",,font2,custom,@_col
                    else
                        draw string (0,y*_fh2), " " & b-offset & " ",,font2,custom,@_col
                    endif
                    if crew(b-offset).hp>0 then
                        set__color( 10,bg)
                        draw string (3*_fw2,y*_fh2), crew(b-offset).icon,,font2,custom,@_col
                        set__color( 15,bg)
                            if crew(b-offset).talents(27)>0 then draw string (5*_fw2,y*_fh2), "SquLd",,font2,custom,@_col
                            if crew(b-offset).talents(28)>0 then draw string (5*_fw2,y*_fh2), "Snipr",,font2,custom,@_col
                            if crew(b-offset).talents(29)>0 then draw string (5*_fw2,y*_fh2), "Param",,font2,custom,@_col
                            if crew(b-offset).typ=1 then draw string (3*_fw2,y*_fh2), "Captain",,font2,custom,@_col
                            if crew(b-offset).typ=2 then draw string (3*_fw2,y*_fh2), "Pilot  ",,font2,custom,@_col
                            if crew(b-offset).typ=3 then draw string (3*_fw2,y*_fh2), "Gunner ",,font2,custom,@_col
                            if crew(b-offset).typ=4 then draw string (3*_fw2,y*_fh2), "Science",,font2,custom,@_col
                            if crew(b-offset).typ=5 then draw string (3*_fw2,y*_fh2), "Doctor ",,font2,custom,@_col
                            if crew(b-offset).talents(27)=0 and crew(b-offset).talents(28)=0 and crew(b-offset).talents(29)=0 then
                                if crew(b-offset).typ=6 then draw string (3*_fw2,y*_fh2), "Green  ",,font2,custom,@_col
                                if crew(b-offset).typ=7 then draw string (3*_fw2,y*_fh2), "Veteran",,font2,custom,@_col
                                if crew(b-offset).typ=8 then draw string (3*_fw2,y*_fh2), "Elite  ",,font2,custom,@_col
                                if crew(b-offset).typ>=30 then draw string (3*_fw2,y*_fh2), "Passenger",,font2,custom,@_col

                            endif

                    else
                        set__color( 12,0)
                        draw string (3*_fw2,y*_fh2), "X",,font2,custom,@_col
                    endif

                    set__color( 15,bg)
                    if crew(b-offset).hp=0 then set__color( 12,bg)
                    if crew(b-offset).hp<crew(b-offset).hpmax then set__color( 14,bg)
                    if crew(b-offset).hp=crew(b-offset).hpmax then set__color( 10,bg)
                    draw string (10*_fw2,y*_fh2), " "&crew(b-offset).hpmax,,font2,custom,@_col
                    set__color( 15,bg)
                    xhp=0
                    if crew(b-offset).hpmax>9 then xhp=1
                    draw string ((12+xhp)*_fw2,y*_fh2), "/",,font2,custom,@_col
                    if crew(b-offset).hp=0 then set__color( 12,bg)
                    if crew(b-offset).hp<crew(b-offset).hpmax then set__color( 14,bg)
                    if crew(b-offset).hp=crew(b-offset).hpmax then set__color( 10,bg)
                    draw string ((13+xhp)*_fw2,y*_fh2), ""&crew(b-offset).hp,,font2,custom,@_col
                    set__color( 15,bg)
                    draw string (16*_fw2,y*_fh2), " "&crew(b-offset).n,,font2,custom,@_col
                    if (crew(b-offset).onship=lc_onship or crew(b-offset).onship=4 or crew(b-offset).disease>0) and crew(b-offset).hp>0 then
                        set__color( 14,bg)
                        draw string (34*_fw2,y*_fh2) ," On ship ",,font2,custom,@_col
                    endif
                    if crew(b-offset).onship=0 and crew(b-offset).hp>0 then
                        set__color( 10,bg)
                        draw string (34*_fw2,y*_fh2) ," Awayteam ",,font2,custom,@_col
                    endif
                    if debug=1 then draw string (40*_fw2,y*_fh2),""&crew(b-offset).oldonship,,font2,custom,@_col
                    if crew(b-offset).hp<=0 then
                        set__color( 12,bg)
                        draw string (34*_fw2,y*_fh2) ," Dead ",,font2,custom,@_col
                    endif
                    set__color( 15,bg)
                    if crew(b-offset).xp>=0 then
                        draw string (55*_fw2,y*_fh2)," XP:" &crew(b-offset).xp,,font2,custom,@_col
                    else
                        draw string (55*_fw2,y*_fh2), " XP: -",,font2,custom,@_col
                    endif

                    'Fixes the auto equip messgae so it does not get over writen Also goign to set the highlighting if needed
                    if skills = "" then
                    draw string(45*_fw2,(y+2)*_fh2),"Auto Equip:" & onoff(crew(b-offset).equips),,font2,custom,@_col
                    elseif augments = "" then
                        set__color( 0,bg)
                        draw string (0,(y+3)*_fh2), space(80),,font2,custom,@_col
                        set__color( 15,bg)
                        draw string(45*_fw2,(y+3)*_fh2),"Auto Equip:" & onoff(crew(b-offset).equips),,font2,custom,@_col
                    else
                        set__color( 0,bg)
                        draw string (0,(y+4)*_fh2), space(80),,font2,custom,@_col
                        set__color( 15,bg)
                        draw string(45*_fw2,(y+4)*_fh2),"Auto Equip:" & onoff(crew(b-offset).equips),,font2,custom,@_col
                    endif


                    'print space(70-pos)
                    set__color( 15,bg)

                    y+=1
                    xw=4
                    if crew(b-offset).armo>0 then
                        set__color( 15,bg)
                        if crew(b-offset).pref_armor>0 then
                            draw string (xw*_fw2,y*_fh2) ,"*",,font2,custom,@_col
                        else
                            draw string (xw*_fw2,y*_fh2), " ",,font2,custom,@_col
                        endif
                        xw+=1
                        draw string (xw*_fw2,y*_fh2),trim(item(crew(b-offset).armo).desig)&", ",,font2,custom,@_col
                        xw=xw+len(trim(item(crew(b-offset).armo).desig))+3
                    else
                        set__color( 14,bg)
                        draw string (xw*_fw2,y*_fh2), " None,",,font2,custom,@_col
                        xw=xw+7
                    endif
                    if crew(b-offset).weap>0 then
                        set__color( 15,bg)
                        if crew(b-offset).pref_lrweap>0 then
                            draw string (xw*_fw2,y*_fh2), "*",,font2,custom,@_col
                        else
                            draw string (xw*_fw2,y*_fh2) ," ",,font2,custom,@_col
                        endif
                        xw+=1
                        draw string (xw*_fw2,y*_fh2) , trim(item(crew(b-offset).weap).desig)&", ",,font2,custom,@_col
                        xw=xw+len(trim(item(crew(b-offset).weap).desig))+3
                    else
                        set__color( 14,bg)
                        draw string (xw*_fw2,y*_fh2) ," None,",,font2,custom,@_col
                        xw=xw+7
                    endif
                    if crew(b-offset).blad>0 then
                        set__color( 15,bg)
                        if crew(b-offset).pref_ccweap>0 then
                            draw string (xw*_fw2,y*_fh2), "*",,font2,custom,@_col
                        else
                            draw string (xw*_fw2,y*_fh2), " ",,font2,custom,@_col
                        endif
                        xw+=1
                        draw string (xw*_fw2,y*_fh2), trim(item(crew(b-offset).blad).desig)&" ",,font2,custom,@_col
                        xw=xw+len(trim(item(crew(b-offset).blad).desig))+3
                    else
                        set__color( 14,bg)
                        draw string (xw*_fw2,y*_fh2) ," None",,font2,custom,@_col
                        xw=xw+7
                    endif
                    set__color( 11,bg)
                    if crew(b-offset).jp>0 then draw string (xw*_fw2,y*_fh2) ," Jetpack",,font2,custom,@_col
                    'print space(70-pos)

                    y+=1

                    set__color( 15,bg)
                    draw string (1*_fw2,y*_fh2), skills,,font2,custom,@_col


                    if augments <> "" then 'if we have augments put them below the line for skills as it use to be on the same line
                        y+=1
                        draw string (1*_fw2,y*_fh2), augments,,font2,custom,@_col
                    endif

                    if crew(b-offset).disease>0 then
                        y+=1
                        set__color( 14,bg)
                        draw string (1*_fw2,y*_fh2), "Suffers from "&trim(disease(crew(b-offset).disease).ldesc),,font2,custom,@_col
                    endif
                    'print space(70-pos)

                    'needed to add a space after if the auto equip is moved below skills and augments
                    if skills <> "" then
                        y+=2
                    else
                        y+=1 'adds extra line between crew members was y+=1
                    endif

                    set__color( 11,bg)
                endif
            endif
            b+=1
            y+=1
        loop until y>=lines
        dlast=b-1-offset
        set__color( 11,0)
        locate 25,1
        if r=0 then
            if from=0 then draw string (10,tScreen.y-_fh2),"enter add/remove from awaytem,"&key_rename &" rename a member, s set Item c clear, e toggle autoequip, esc exit",,font2,custom,@_col
            if from<>0 then draw string (10,tScreen.y-_fh2),key_rename &" rename a member, s set Item, c clear, e toggle autoequip, esc exit",,font2,custom,@_col
        endif
        if r=1 then draw string (10,tScreen.y-_fh2),"installing augment "&text &": Enter to choose crewmember, esc to quit, a for all",,font2,custom,@_col
        'tScreen.update()
        textbox(crew_bio(p),_mwx,1,20,15,1)
        tScreen.set(0)
        no_key=keyin(,1)
        if keyplus(no_key) or getdirection(no_key)=2 then p+=1
        if keyminus(no_key) or getdirection(no_key)=8 then p-=1
        if no_key=key_rename then
            tScreen.set(1)
            if p<6 then
                n=gettext(16,(p-1+offset)*3,16,n)
            else
                n=gettext(10,(p-1+offset)*3,16,n)
            endif
            if n<>"" then crew(p).n=n
            n=""
        endif
        if p<1 then p=1
        if p>last then p=last
        if p>dlast then offset-=1
        if p<dfirst then offset+=1
    loop until no_key=key__esc or no_key=" "
    tScreen.set(0)
    cls
    tScreen.update()
    return 0
end function

function showteam(from as short, r as short=0,text as string="") as short
    sort_crew
    return crew_menu(crew(),from,r,text)
end function


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tAwayteam -=-=-=-=-=-=-=-
	tModule.register("tAwayteam",@tAwayteam.init()) ',@tAwayteam.load(),@tAwayteam.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tAwayteam -=-=-=-=-=-=-=-
#endif'test
