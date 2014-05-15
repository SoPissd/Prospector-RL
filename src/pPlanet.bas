'tPlanet.
'
'defines:
'deletemonsters=49, isgardenworld=10, isgasgiant=15, isasteroidfield=1,
', system_text=1, make_unflags=3, uniques_html=1, uniques=3,
', nextplan=0, prevplan=0, display_portal=2, display_portals=1,
', dtile=6, display_sysmap=0, display_system=3, getplanet=0
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
'     -=-=-=-=-=-=-=- TEST: tPlanet -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Type _planetsave
    awayteam As _monster
    enemy(256) As _monster
    lastenemy As Short
    lastlocalitem As Short
    ship As _cords
    map As Short
End Type

Type _planet
    p As Short
    map As Short
    orbit As Short
    darkness As UByte
    water As Short
    atmos As Short
    dens As Short
    grav As Single
    temp As Single
    life As Short
    highestlife As Single
    minerals As Short
    weat As Single
    depth As Byte
    death As Short
    genozide As Byte
    teleport As Byte
    plantsfound As Short
    pla_template(16) As Byte
    mon_template(16) As _monster
    mon_noamin(16) As Byte
    mon_noamax(16) As Byte
    mon_killed(16) As UByte
    mon_disected(16) As UByte
    mon_caught(16) As UByte
    mon_seen(16) As UByte
    colony As Byte
    colonystats(14) As Byte
    vault(8) As _rect
    discovered As Short
    visited As Integer
    mapped As Integer
    mapmod As Single
    rot As Single
    flags(32) As Byte
    weapon(5) As _weap
    comment As String*60
    mapstat As Byte
    colflag(16) As Byte
    wallset As Byte
End Type

Const max_maps=2047
Dim Shared planets(max_maps) As _planet
Dim Shared savefrom(16) As _planetsave
Dim Shared planets_flavortext(max_maps) As String

#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tPlanet -=-=-=-=-=-=-=-

declare function deletemonsters(a as short) as short
declare function isgardenworld(m as short) as short
declare function isgasgiant(m as short) as short
declare function isasteroidfield(m as short) as short
declare function system_text(a as short) as string
declare function make_unflags(unflags() as byte) as short
declare function uniques_html(unflags() as byte) as string
declare function uniques(unflags() as byte) as string
declare function display_portal(b as short,slot as short,osx as short) as short
declare function display_portals(slot as short,osx as short) as short
declare function dtile(x as short,y as short, tiles as _tile,visible as byte) as short
declare function display_system(in as short,forcebar as byte=0,hi as byte=0) as short
declare function getplanet(sys as short,forcebar as byte=0) as short

'private function nextplan(p as short,in as short) as short
'private function prevplan(p as short,in as short) as short
'private function display_sysmap(x as short, y as short, in as short, hi as short=0,bl as string,br as string) as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tPlanet -=-=-=-=-=-=-=-

namespace tPlanet
function init() as Integer
    dim i as short
	For i=0 To max_maps
	    planets(i).darkness=5
	Next
	return 0
end function
end namespace'tPlanet



function deletemonsters(a as short) as short
    dim b as short
    dim m as _monster
    if a>0 then
        for b=0 to 16
            planets(a).mon_template(b)=m
            planets(a).mon_noamin(b)=0
            planets(a).mon_noamax(b)=0
        next
    endif
    return 0
end function


function isgardenworld(m as short) as short
    if m<0 then return 0
    if planets(m).grav>1.1 then return 0
    if planets(m).atmos<3 or planets(m).atmos>5 then return 0
    if planets(m).temp<-20 or planets(m).temp>55 then return 0
    if planets(m).weat>1 then return 0
    if planets(m).water<30 then return 0
    if planets(m).rot<0.5 or planets(m).rot>1.5 then return 0
    return -1
end function


function isgasgiant(m as short) as short
    if m<-20000 then return 1
    if m=specialplanet(21) then return 21
    if m=specialplanet(22) then return 22
    if m=specialplanet(23) then return 23
    if m=specialplanet(24) then return 24
    if m=specialplanet(25) then return 25
    if m=specialplanet(43) then return 43
    return 0
end function

function isasteroidfield(m as short) as short
    if m>=-20000 and m<0 then return 1
    if m=specialplanet(31) then return 1 
    if m=specialplanet(32) then return 1 
    if m=specialplanet(33) then return 1
    if m=specialplanet(41) then return 1
    return 0
end function



function system_text(a as short) as string
    dim as short o,pl,af,gg
    dim t as string
    for o=1 to 9
        if map(a).planets(o)<>0 then
            if isgasgiant(map(a).planets(o)) then gg+=1
            if isasteroidfield(map(a).planets(o)) then af+=1
            pl+=1
        endif
    next
    if pl=0 and af=0 and gg=0 then
        t=" No planets."
    else
        pl=pl-gg-af
        if pl=1 then t=t &" "& pl &" planet"
        if pl>1 then t=t &" "& pl &" planets"
        if gg=1 then t=t &" "& gg &" gas giant"
        if gg>1 then t=t &" "& gg &" gas giants"
        if af=1 then t=t &" "& af &" asteroid field"
        if af>1 then t=t &" "& af &" asteroid fields"
    endif
    return t
end function



function make_unflags(unflags() as byte) as short
    DimDebugL(0)'1
    dim as short a,foundspec
    for a=0 to lastspecial
        if specialplanet(a)>0 and specialplanet(a)<=lastplanet then
            if planets(specialplanet(a)).mapstat>0 or (debug=1) then
                unflags(a)=1
                foundspec=1
            endif
        endif
    next
    return foundspec
end function

function uniques_html(unflags() as byte) as string
    dim t as string
    dim as short a,platforms,none


    t= html_color("#ffffff") &"Unique planets discovered:</span><br>"& html_color("#00ffff")

    for a=0 to lastspecial
        if unflags(a)=1 then
                none=1
                select case a
                case is =20
                    if specialflag(20)=1 then
                        t=t &"A colony under the control of an alien lifeform<br>"
                    else
                        t=t & spdescr(a) &"<br>"
                    endif
                case 21 to 25
                    platforms+=1
                case else
                    if spdescr(a)<>"" then t=t & spdescr(a) &"<br>"
                end select
        endif
    next
    if platforms>1 then t=t & platforms &" ancient refueling platforms<br>"
    if platforms=1 then t=t & "An ancient refueling platform<br>"
    if none=0 then t=t & html_color("#ffff00")&"None</span><br>"

    return t
end function

function uniques(unflags() as byte) as string
    dim text as string
    dim as short a,platforms,none


    text= "{15}Unique planets discovered:{11}|"

    for a=0 to lastspecial
        if unflags(a)=1 then
                none=1
                select case a
                case is =20
                    if specialflag(20)=1 then
                        text=text &"A colony under the control of an alien lifeform|"
                    else
                        text=text & spdescr(a) &"|"
                    endif
                case 21 to 25
                    platforms+=1
                case else
                    if spdescr(a)<>"" then text=text & spdescr(a) &"|"
                end select
        endif
    next
    if platforms>1 then text=text & platforms &" ancient refueling platforms"
    if platforms=1 then text=text & "An ancient refueling platform"
    if none=0 then text=text &"      {14} None"
    text=text &"|"
    return text
end function



function nextplan(p as short,in as short) as short
    dim as short oldp
    oldp=p
    do
        p=p+1
        if p>9 then p=1
    loop until map(in).planets(p)<>0 or p=oldp
    return p
end function

function prevplan(p as short,in as short) as short
    dim as short oldp
    oldp=p
    do
        p=p-1
        if p<1 then p=9
    loop until map(in).planets(p)<>0 or p=oldp
    return p
end function

'

function display_portal(b as short,slot as short,osx as short) as short
    dim as short x
    
    x=portal(b).from.x-osx
    if x<0 then x+=61
    if x>60 then x-=61
    if x>=0 and x<=_mwx then
        if portal(b).from.m=slot and portal(b).discovered=1 and portal(b).oneway<2 then
            if configflag(con_tiles)=0 then
                put ((x)*_tix,portal(b).from.y*_tiy),gtiles(gt_no(portal(b).ti_no)),trans
#if __FB_DEBUG__
                draw string(portal(b).from.x*_fw1,portal(b).from.y*_fh1),""&portal(b).ti_no,,Font2,custom,@_col
#endif
            else
                set__color( portal(b).col,0)
                draw string(portal(b).from.x*_fw1,portal(b).from.y*_fh1),chr(portal(b).tile),,Font1,custom,@_col
            endif
        endif
    endif
    x=portal(b).dest.x-osx
    if x<0 then x+=61
    if x>60 then x-=61

    if x>=0 and x<=_mwx then
        if portal(b).oneway=0 and portal(b).dest.m=slot and portal(b).discovered=1 then
            if configflag(con_tiles)=0 then
                put ((x)*_tix,portal(b).dest.y*_tiy),gtiles(gt_no(portal(b).ti_no)),trans
            else
                set__color( portal(b).col,0)
                draw string(portal(b).dest.x*_fw1,portal(b).dest.y*_fh1),chr(portal(b).tile),,Font1,custom,@_col
            endif
        endif
    endif
    return 0
end function

function display_portals(slot as short,osx as short) as short
    dim as short b
    for b=0 to lastportal
        display_portal(b,slot,osx)
    next
    return 0
end function


function dtile(x as short,y as short, tiles as _tile,visible as byte) as short
    dim as short col,bgcol,slot,tino
    slot=player.map
    col=tiles.col
    bgcol=tiles.bgcol
    tino=tiles.ti_no
    if tino>1000 then
        tino=2500+(tino-2500)+planets(slot).wallset*10
    endif
    'if tiles.walktru=5 then bgcol=1
    if tiles.col<0 and tiles.bgcol<0 then
        col=col*-1
        bgcol=bgcol*-1
        col=rnd_range(col,bgcol)
        bgcol=0
    endif
    if configflag(con_tiles)=0 then
        if visible=1 then
            put (x*_tix,y*_tiy),gtiles(gt_no(tino)),pset
        else
            put (x*_tix,y*_tiy),gtiles(gt_no(tino)),alpha,196
        endif
    else
        if configflag(con_showvis)=0 and visible>0 and bgcol=0 then
            bgcol=234
        endif
        set__color( col,bgcol,visible)
        draw string (x*_fw1,y*_fh1),chr(tiles.tile),,Font1,custom,@_col
    endif
    set__color( 11,0)
    return 0
end function



function display_sysmap(x as short, y as short, in as short, hi as short=0,bl as string,br as string) as short
    dim as short a,b,c,bg,yof,ptile,alp,spec
    dim t as string
    set__color( 224,0)
    yof=(_fh1-_fh2)/2
    if configflag(con_sysmaptiles)=0 then
        line (x,y)-(x+19*_tix,y+_tiy+6),RGB(0,0,0),BF
        line (x,y+1)-(x+19*_tix,y+_tiy+6),RGB(0,0,255),B
        'draw string(x,y),bl ,,font1,custom,@_col
        'draw string(x+19*_tix,y),br ,,font1,custom,@_col

    else
        draw string(x,y),bl ,,font1,custom,@_col
        draw string (x+_fw2,y+yof), space(25),,font2,custom,@_col
        draw string(x+25*_fw2,y),br ,,font1,custom,@_col
    endif
    set__color( spectraltype(map(in).spec),0)
    if configflag(con_sysmaptiles)=0 then
        if spectraltype(map(in).spec)>0 then put (x+_fw1,y),gtiles(gt_no(1599+map(in).spec)),trans
    else
        draw string(x+_fw1,y), "*"&space(2),,font1,custom,@_col
    endif
    for a=1 to 9
        bg=0
        spec=0
        if map(in).planets(a)>0 then
            if is_special(map(in).planets(a)) and planets(map(in).planets(a)).mapstat<>0 then
                bg=233
                spec=1
            endif
        endif
        if hi=a then bg=11
        t=" "

        if map(in).planets(a)<>0 then
                ptile=0
                alp=255
                if isgasgiant(map(in).planets(a))<>0 then
                    t="O"
                    if a<6 then
                        set__color( 162,bg)
                        ptile=1612
                    endif
                    if a=1 then
                        set__color( 164,bg)
                        ptile=1613
                    endif
                    if a>5 or map(in).spec=10 then
                        set__color( 63,bg)
                        ptile=1614
                    endif
                endif
                if isasteroidfield(map(in).planets(a))<>0 then
                    t=chr(176)
                    set__color( 7,bg)
                    ptile=1608
                endif
                if isasteroidfield(map(in).planets(a))=0 and isgasgiant(map(in).planets(a))=0 and map(in).planets(a)>0 then
                    t="o"
                    ptile=1609

                    if planets(map(in).planets(a)).atmos=0 then planets(map(in).planets(a)).atmos=1
                    if planets(map(in).planets(a)).mapstat=0 then set__color( 7,bg)
                    if planets(map(in).planets(a)).mapstat=1 then
                        alp=197
                        if planets(map(in).planets(a)).atmos=1 then
                            set__color( 15,bg)
                            ptile=1616
                        endif
                        if planets(map(in).planets(a)).atmos>1 and planets(map(in).planets(a)).atmos<7 then
                            set__color( 101,bg)
                            ptile=1619
                        endif
                        if planets(map(in).planets(a)).atmos>6 and planets(map(in).planets(a)).atmos<12 then
                            set__color( 210,bg)
                            ptile=1622
                        endif
                        if planets(map(in).planets(a)).atmos>11 then
                            set__color( 10,bg)
                            ptile=1625
                        endif
                        if planets(map(in).planets(a)).grav<0.8 then ptile+=1
                        if planets(map(in).planets(a)).grav>1.2 then ptile-=1
                    endif
                    if planets(map(in).planets(a)).mapstat=2 then
                        if planets(map(in).planets(a)).atmos=1 then
                            set__color( 8,bg)
                            ptile=1616
                        endif
                        if planets(map(in).planets(a)).atmos>1 and planets(map(in).planets(a)).atmos<7 then
                            set__color(9,bg)
                            ptile=1619
                        endif
                        if planets(map(in).planets(a)).atmos>6 and planets(map(in).planets(a)).atmos<12 then
                            set__color(198,bg)
                            ptile=1622
                        endif
                        if planets(map(in).planets(a)).atmos>11 then
                            set__color( 54,bg)
                            ptile=1625
                        endif
                        if planets(map(in).planets(a)).grav<0.8 then ptile+=1
                        if planets(map(in).planets(a)).grav>1.2 then ptile-=1
                    endif
                endif
            if configflag(con_sysmaptiles)=0 then
                if ptile>0 then put (x+_tix*(a*1.5+4),y+yof),gtiles(gt_no(ptile)),alpha,alp
                if bg=11 then put (x+_tix*(a*1.5+4),y+yof),gtiles(gt_no(1610)),trans
                if spec=1 then
                    set__color(11,0)
                    draw string(x+_tix*(a*1.5+4),y+yof),"s",,font2,custom,@_tcol
                endif
            else
                draw string(x+_fw2*(a*2+4),y+yof),t,,font2,custom,@_col
                if spec=1  then
                    set__color(11,0)
                    draw string(x+_fw2*(a*2+5),y+yof),"s",,font2,custom,@_tcol
                endif
            endif
        endif
    next
    return 0
end function


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
            if keyplus(key) or key=key_east or key=key_north then p=nextplan(p,sys)
            if keyminus(key) or key=key_west or key=key_south then p=prevplan(p,sys)
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

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tPlanet -=-=-=-=-=-=-=-
	tModule.register("tPlanet",@tPlanet.init()) ',@tPlanet.load(),@tPlanet.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tPlanet -=-=-=-=-=-=-=-
#endif'test
