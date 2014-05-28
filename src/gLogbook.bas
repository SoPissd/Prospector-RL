'tLogbook.
'
'defines:
'lb_listmake=0, lb_filter=0, dplanet=1, bioreport=3, logbook=1
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
'     -=-=-=-=-=-=-=- TEST: tLogbook -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tLogbook -=-=-=-=-=-=-=-

declare function dplanet(p as _planet,orbit as short,scanned as short,slot as short) as short
declare function bioreport(slot as short) as short
declare function logbook() as short

'declare function lb_listmake(lobk() as string, lobn() as short, lobc() as short,lobp()as _cords) as short
'declare function lb_filter(lobk() as string, lobn() as short, lobc() as short,lobp() as _cords,last as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tLogbook -=-=-=-=-=-=-=-

namespace tLogbook
function init(iAction as integer) as integer
	return 0
end function
end namespace'tLogbook


#define cut2top


function lb_listmake(lobk() as string, lobn() as short, lobc() as short,lobp()as _cords) as short
    DimDebug(0)
    dim last as short
    dim as short i,a,b,f,j
    for a=0 to 255
        lobn(a)=-1
    next
    i=0
    for a=0 to laststar
        if map(a).discovered>0 and map(a).desig<>"" then
            i+=1
            lobk(i)=trim(map(a).desig)
            if map(a).comment<>"" then lobk(i)=lobk(i) &" (c)"
            lobn(i)=a
            lobc(i)=0
            lobp(i)=map(a).c
            for b=1 to 9
                if map(a).planets(b)>0 and map(a).planets(b)<max_maps then
                if is_special(map(a).planets(b)) and planets(map(a).planets(b)).mapstat<>0 then lobc(i)=6
                endif
            next
        endif
    next
    last=i
	
	
    do 'sort_logbook_list
    f=0
        for j=1 to last-1
            if map(lobn(j)).c.x>map(lobn(j+1)).c.x then
                f=1
                swap lobn(j),lobn(j+1)
                swap lobc(j),lobc(j+1)
                swap lobk(j),lobk(j+1)
                swap lobp(j),lobp(j+1)
            endif
        next
    loop until f=0
	
	
    for a=laststar+1 to laststar+wormhole
        if map(a).discovered>0 then
            i+=1
            lobk(i)=trim(map(a).desig)
            lobn(i)=a
            lobp(i)=map(a).c
        endif
    next
    for a=0 to 2
        if basis(a).c.x>0 and basis(a).c.y>0 then
            i+=1
            lobk(i)="Station "&a+1
            lobp(i)=basis(a).c
            lobn(i)=0
        endif
    next
    
    last=i
    return last
end function




function lb_filter(lobk() as string, lobn() as short, lobc() as short,lobp() as _cords,last as short) as short
    dim as short c,i,j,f,cc,c2,last2
    last=lb_listmake(lobk(),lobn(),lobc(),lobp())
    last2=last
    c=textmenu(bg_logbook,"Filter & Sort/Distance from base/Distance from ship/Spectral type/Systems with unexplored planets/Systems with gas giants/Systems with asteroid belts/Exit")
    if c=1 then
	
        do ' sort_logbook_distance_base
            f=0
            cc+=1
            for i=1 to last-1
                if disnbase(map(lobn(i)).c)>disnbase(map(lobn(i+1)).c) then
                    swap lobn(i),lobn(i+1)
                    swap lobc(i),lobc(i+1)
                    swap lobk(i),lobk(i+1)
                    swap lobp(i),lobp(i+1)
                    f=1
                endif
            next
        loop until f=0 or cc>1000
		
    endif
    if c=2 then
	
        do ' sort_logbook_distance_ship
            f=0
            cc+=1
            for i=1 to last-1
                if distance(map(lobn(i)).c,player.c)>distance(map(lobn(i+1)).c,player.c) then
                    swap lobn(i),lobn(i+1)
                    swap lobc(i),lobc(i+1)
                    swap lobk(i),lobk(i+1)
                    swap lobp(i),lobp(i+1)
                    f=1
                endif
            next
        loop until f=0 or cc>1000
		
    endif
    if c=3 then 
        c2=textmenu(bg_logbook,"Spectral type:/"&spectralname(1) &"/"&spectralname(2) &"/"&spectralname(3) &"/"&spectralname(4) &"/"&spectralname(5) &"/"&spectralname(6) &"/"&spectralname(7) &"/"& spectralname(8) & "/Exit",,20,2)
        if c2>0 and c2<=8 then
            for i=1 to last
                if map(lobn(i)).spec<>c2 then
                    lobn(i)=0
                    lobc(i)=0
                    lobk(i)=""
                endif
            next
        endif
    endif
    if c=4 then
        for i=1 to last
            f=0
            for j=1 to 9
                if map(lobn(i)).planets(j)>0 then
                    if planets(map(lobn(i)).planets(j)).visited=0 then f=1
                endif
            next
            if f=0 then
                lobk(i)=""
            endif
        next
    endif
    if c=5 then
        for i=1 to last
            f=0
            for j=1 to 9
                if isgasgiant(map(lobn(i)).planets(j))<>0 then f=1
            next
            if map(lobn(i)).discovered<2 then f=0
            if f=0 then lobk(i)=""
        next
    endif
    if c=6 then
        for i=1 to last
            f=0
            for j=1 to 9
                if isasteroidfield(map(lobn(i)).planets(j))<>0 then f=1
            next
            if map(lobn(i)).discovered<2 then f=0
            if f=0 then lobk(i)=""
        next
    endif
    last2=0
    i=1
    for i=last to 1 step -1
        if lobk(i)="" then
            j=i
            for j=i to 254
                lobn(j)=lobn(j+1)
                lobc(j)=lobc(j+1)
                lobk(j)=lobk(j+1)
                lobp(j)=lobp(j+1)
            next
        endif
    next
    for i=1 to 255
        if lobk(i)<>"" then last2+=1
    next
    return last2
end function


function dplanet(p as _planet,orbit as short,scanned as short,slot as short) as short
    DimDebug(0)'1
    dim a as short
    dim as single plife
    dim text as string
    draw_border(0)

    set__color( 15,0)
    draw string(sidebar,1*_fh2), "Scanning Results:",,font2,custom,@_col

    set__color( 11,0)
    draw string(sidebar,2*_fh2), "Planet in orbit " & orbit,,font2,custom,@_col
    draw string(sidebar,3*_fh2), scanned &" km2 scanned",,font2,custom,@_col
    draw string(sidebar,5*_fh2), p.water &"% Liq. Surface",,font2,custom,@_col
    text=atmdes(p.atmos) &" atmosphere"
    textbox(text,sidebar+_fw2,(7*_fh2),16,11,0,1)
    draw string(sidebar,12*_fh2), "Gravity:"&p.grav &"g",,font2,custom,@_col
    set__color( 10,0)
    if p.grav<1 then draw string(62*_fw1+13*_fw2,12*_fh2), "(Low)",,font2,custom,@_col
    set__color( 14,0)
    if p.grav>1.5 then draw string(62*_fw1+13*_fw2,12*_fh2), "(High)",,font2,custom,@_col
    set__color( 11,0)


    draw string(sidebar,13*_fh2), "Avg. Temperature",,font2,custom,@_col
    draw string(sidebar+_fw2,14*_fh2), p.temp &" "&chr(248)&"C ",,font2,custom,@_col
    draw string(sidebar+_fw2,15*_fh2), c_to_f(p.temp) &" "&chr(248)&"F ",,font2,custom,@_col
    if p.rot>0 then
        draw string(sidebar,17*_fh2),"Rot.:"&round_str(24*(1/p.rot),1) &" h",,font2,custom,@_col
    else
        draw string(sidebar,17*_fh2),"Rot.: Nil",,font2,custom,@_col
    endif
    Draw string(sidebar,19*_fh2),"Vegetation: "&int(vege_per(slot)*100) &"%",,font2,custom,@_col
    select case p.highestlife*100
    case is=0
        set__color(c_gre,0)
        draw string(sidebar,20*_fh2),"No Lifeforms",,font2,custom,@_col
    case 0 to 10
        set__color(11,0)
        draw string(sidebar,20*_fh2),"Lifeforms:",,font2,custom,@_col
        draw string(sidebar,21*_fh2),p.highestlife*100 &" % probability",,font2,custom,@_col
        set__color(c_gre,0)
        draw string(sidebar,22*_fh2),"Very Low",,font2,custom,@_col
    case 11 to 20
        set__color(11,0)
        draw string(sidebar,20*_fh2),"Lifeforms:",,font2,custom,@_col
        draw string(sidebar,21*_fh2),p.highestlife*100 &" % probability",,font2,custom,@_col
        set__color(c_gre,0)
        draw string(sidebar,22*_fh2),"Low",,font2,custom,@_col

    case 50 to 80
        set__color(11,0)
        draw string(sidebar,20*_fh2),"Lifeforms:",,font2,custom,@_col
        set__color(c_yel,0)
        draw string(sidebar,21*_fh2),p.highestlife*100 &" % probability",,font2,custom,@_col

    case 81 to 90
        set__color(11,0)
        draw string(sidebar,20*_fh2),"Lifeforms:",,font2,custom,@_col
        draw string(sidebar,21*_fh2),p.highestlife*100 &" % probability",,font2,custom,@_col
        set__color(c_red,0)
        draw string(sidebar,22*_fh2),"High",,font2,custom,@_col

    case is>90
        set__color(11,0)
        draw string(sidebar,19*_fh2),"Lifeforms:",,font2,custom,@_col
        draw string(sidebar,20*_fh2),p.highestlife*100 &" % probability",,font2,custom,@_col
        set__color(c_red,0)
        draw string(sidebar,21*_fh2),"Very High",,font2,custom,@_col
    case else
        set__color(11,0)
        draw string(sidebar,19*_fh2),"Lifeforms:",,font2,custom,@_col
        draw string(sidebar,20*_fh2),p.highestlife*100 &" % probability",,font2,custom,@_col

    end select
    return 0
end function


function bioreport(slot as short) as short
    dim a as short
    dim as string t,h
    screenshot(1)
    t="Bio Report for /"
    h="/"
    for a=0 to 16
        if planets(slot).mon_seen(a)>0 or planets(slot).mon_killed(a)>0 or planets(slot).mon_caught(a)>0 then
            t=t & planets(slot).mon_template(a).sdesc &"/"
            h=h & " | "&planets(slot).mon_template(a).ldesc &" | | Visual  :"
            if planets(slot).mon_seen(a)>0 then
                h=h &" Yes"
            else
                h=h &" No"
            endif
            h=h & " | Killed  : "&planets(slot).mon_killed(a)
            h=h & " | Disected: "&planets(slot).mon_disected(a)
            h=h & " | Caught  : "&planets(slot).mon_caught(a) &" | /"
        endif
    next
    t=t &"Exit"
    do
    loop until textmenu(bg_awayteam,t,h)
    return 0
end function


function logbook() as short
    DimDebug(0)
    dim lobk(255) as string 'lobk is description
    dim lobn(255) as short 'lobn is n to get map(n)
    dim lobc(255) as short 'lobc is bg set__color(
    dim lobp(255) as _cords 'lobc is bg set__color(
    static as short curs
    dim as short x,y,a,b,p,m,lx,ly,dlx,diff,i,last,ll
    dim as string key,lobk1,lobk2
    
    Cls
    ll=fix(20*_fh1/_fh2)
    last=lb_listmake(lobk(),lobn(),lobc(),lobp())
    for a=1 to last       'tests all lobn for special planets, system comments and planets comments for coloring bg
'        'print "test for special planets and change lobc (bg set__color(): system " &map(lobn(int(a/21), (a mod 21))).desig 'debug
        if lobn(a)>=0 then
            if map(lobn(a)).comment<>"" then lobc(a)=228
            for p=1 to 9 'find number of planet in system's orbits
    '            
                m=map(lobn(a)).planets(p)
                if m>0 then
                    if planets(m).comment<>"" then lobc(a)=241
                    for b=0 to lastspecial
                        if planetmap(0,0,m)<>0 and m=specialplanet(b) then lobc(a)=233
                    next
                endif
            next
        endif
    next
'    
    do
        tScreen.set(0)
        cls
        draw_border(0)
        for x=(_mwx+1)*_fw1 to (_mwx+20)*_fw1 step 8
            set__color( 224,1)
            draw string (x,11*_fh1),chr(196),,Font1,custom,@_col
        next
        draw string((_mwx+1)*_Fw1,11*_fh1),chr(195),,Font1,custom,@_col
        
        for x=(_mwx+1)*_fw1 to (_mwx+20)*_fw1 step 8
            set__color( 224,1)
            draw string (x,12*_fh1+sm_y*2),chr(196),,Font1,custom,@_col
        next
        draw string((_mwx+1)*_Fw1,12*_fh1+sm_y*2),chr(195),,Font1,custom,@_col
        set__color( 15,1)
            
        draw string((_mwx+1)*_Fw1+6*_fw2,12*_fh1+sm_y*2),"Minimap",,Font2,custom,@_col
        
        'displayship(1)
       
        if curs<1 then curs=1
        if curs>last then curs=last
        i=1
        for x=0 to 4
            for y=1 to ll
                if i<=last then
                    if i=curs then
                        set__color( 15,3)
                    else
                        set__color( 11, 0)
                        if lobc(i)<>0 then set__color( 11, lobc(i))
                    endif
                    if lobk(i)<>"" then
                        draw string (x*14*_fw2,y*_fh2),lobk(i),,Font2,custom,@_col
                    else
                        draw string (x*14*_fw2,y*_fh2),space(14),,Font2,custom,@_col
                    endif
                    i+=1
                endif
            next
        next
        
        rlprint "Logbook: Press " &key_sc &" or enter to choose system. ESC to exit.",15
        
        if lobn(curs)>=0 then
#if __FB_DEBUG__
            if debug=1 and key="t" then player.c=lobp(curs)
#endif
            show_minimap(lobp(curs).x,lobp(curs).y)
            show_dotmap(lobp(curs).x,lobp(curs).y)
            if lobn(curs)>laststar then show_wormholemap(lobn(curs))
            if lobn(curs)<=laststar then
                if map(lobn(curs)).discovered>1 then
                    display_system(lobn(curs),1)
                else
                    rlprint trim(map(lobn(curs)).desig)&": only long range data."
                endif
                if map(lobn(curs)).comment<>"" then rlprint map(lobn(curs)).comment
                'fill msg area with planets comments, if there are more then shown, then msg there are more.
                p=0
                b=0
                lobk1=""
                if map(lobn(curs)).comment<>"" then b=1
                do 'print max of 2 planets comments
                    p+=1
                    m=map(lobn(curs)).planets(p)
                    if m>0 then
                        if planets(m).comment<>"" then
                            if b<2 then rlprint "Orbit " &p &":" &planets(m).comment &"." 'print when b=0 or b=1
                            if b=2 then lobk1=str(p) &":" &planets(m).comment &"." 'store third planet comments
                            b+=1
                        endif
                    endif
                loop until p=9 or b=3 'test for 4 planets with comments
                if b>1 and lobk1<>"" then
                    if b=2 then rlprint "Orbit " &lobk1 endif
                    if b=3 then rlprint "Orbit " &lobk1 &" .Enter to see more comments."
                elseif b>1 then
                    if b=2 then rlprint "Orbit " &p endif
                    if b=3 then rlprint "Orbit " &p &" .Enter to see more comments."
                endif
                
                if key=key_comment and lobn(curs)<>0 then
                    tScreen.set(1)
                    rlprint "Enter comment on system"
                    map(lobn(curs)).comment=gettext(LocEOL.x,LocEOL.y,60,map(lobn(curs)).comment)
                    if map(lobn(curs)).comment<>"" then lobc(curs)=228
                endif
                if key=key__enter and map(lobn(curs)).discovered>1 then
                for p=1 to 9
                    if map(lobn(curs)).planets(p)>0 then
                        if planets(map(lobn(curs)).planets(p)).comment<>"" then rlprint "Orbit " &p &":" &planets(map(lobn(curs)).planets(p)).comment
                    endif
                next
                do
                    p=getplanet(lobn(curs),1)
                    if p>0 then
                        m=map(lobn(curs)).planets(p)
                        if m>0 then
                            if planets(m).comment<>"" then rlprint planets(m).comment
                            if planetmap(0,0,m)=0 then
                                cls
                                display_ship(1)
                                set__color( 15,0)
                                draw string (15*_fw1,10*_fh1),"No map data for this planet.",,Font2,custom,@_col
                                no_key=keyin
                            else
                                cls
                                do
                                    dplanet(planets(m),p,planets(m).mapped,m)
                                    display_planetmap(m,0,1)
                                    no_key=keyin(key_comment &key_report &key__esc)
                                    if no_key=key_comment then
                                        tScreen.set(1)
                                        rlprint "Enter comment on planet"
                                        planets(m).comment=gettext(loceol.x,loceol.y,60,planets(m).comment)
                                        if planets(m).comment<>"" and map(lobn(curs)).comment="" then lobc(curs)=241
                                    endif
                                    if no_key=key_report then
                                        bioreport(m)
                                    endif   
                                loop until no_key<>key_comment or no_key<>key_report
                            endif
                        endif
                    endif
                    
                loop until no_key=key__esc or p=-1
                
                key=""
            endif
            
            endif
            if key=key_walk then
                rlprint "Setting autopilot, risk setting? (0 ignore gasclouds, 5 avoid all)"
                diff=getnumber(0,5,0)
                if auto_pilot(player.c,lobp(curs),diff)=1 then return 0
            endif
            
            if key=key_filter then last=lb_filter(lobk(),lobn(),lobc(),lobp(),last)
                
        endif
        tScreen.update()
        key=keyin("123456789 " &key_sc &key__esc &key__enter &key_comment &key_walk &key_filter &"t",walking)
        a=uConsole.getdirection(key)
        if a=5 then key=key__enter 
        
        
        if a=7 then curs-=(ll-1)
        if a=4 then curs-=ll
        if a=1 then curs-=(ll+1)
        if a=9 then curs+=(ll-1)
        if a=6 then curs+=ll
        if a=3 then curs+=(ll+1)
        if a=8 then curs-=1
        if a=2 then curs+=1
        a=0
        set__color( 11,0)
    loop until key=key__esc or player.dead<>0 or walking=10
    return 0
end function
#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tLogbook -=-=-=-=-=-=-=-
	tModule.register("tLogbook",@tLogbook.init()) ',@tLogbook.load(),@tLogbook.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tLogbook -=-=-=-=-=-=-=-
#endif'test
