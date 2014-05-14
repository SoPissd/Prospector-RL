'tRadio.
'
'defines:
'ep_heatmap=0, shipstatus=1, display_monsters=0, ep_display=22,
', ep_radio=1, space_radio=1
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tRadio -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tRadio -=-=-=-=-=-=-=-

Type _shipfire
    what As Short
    when As Short
    where As _cords
    tile As String*1
    stun As Byte
End Type

declare function shipstatus(heading as short=0) as short
declare function ep_display(osx As Short=555) As Short
declare function ep_radio(ByRef nextlanding As _cords,ByRef ship_landing As Short, shipfire() As _shipfire,lavapoint() As _cords, ByRef sf As Single,nightday() As Byte,localtemp() As Single) As Short
declare function space_radio() As Short

'private function ep_heatmap(lavapoint() As _cords,lastlavapoint As Short) As Short
'private function display_monsters(osx as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tRadio -=-=-=-=-=-=-=-

namespace tRadio
function init() as Integer
	return 0
end function
end namespace'tRadio


#define cut2top


function ep_heatmap(lavapoint() As _cords,lastlavapoint As Short) As Short
    Dim As Short map(60,20),heatmap(60,20)
    Dim As Short x,y,x1,y1,a,sensitivity,dis
    Dim As _cords p1,p2
    For a=0 To lastenemy
        If enemy(a).hp>0 Then map(enemy(a).c.x,enemy(a).c.y)+=enemy(a).hp
    Next
    For a=0 To lastlavapoint
        If lavapoint(a).x>0 And lavapoint(a).y>0 Then map(lavapoint(a).x,lavapoint(a).y)+=50-player.sensors*4
    Next
    For x=0 To 60
        For y=0 To 20
            If map(x,y)>0 Then
                heatmap(x,y)=map(x,y)
                For x1=x-1 To x+1
                    For y1=y-1 To y+1
                        If x1>=0 And y1>=0 And x1<=60 And y1<=20 Then
                            heatmap(x,y)=heatmap(x,y)+map(x1,y1)/2
                        EndIf
                    Next
                Next
            EndIf
        Next
    Next

    For x=0 To 60
        For y=0 To 20
            If heatmap(x,y)>0 Then
                For x1=x-1 To x+1
                    For y1=y-1 To y+1
                        If x1>=0 And y1>=0 And x1<=60 And y1<=20 And (x1<>x Or y1<>y) Then
                            If heatmap(x,y)>=heatmap(x1,y1) Then heatmap(x1,y1)=0
                        EndIf
                    Next
                Next
            EndIf
        Next
    Next
    sensitivity=24-player.sensors*2
    dis=9999
    p2.x=-1
    p2.y=-1
    For x=0 To 60
        For y=0 To 20
            If heatmap(x,y)>sensitivity Then
                p1.x=x
                p1.y=y
                If distance(p1,awayteam.c)<dis Then
                    p2=p1
                    dis=distance(p1,awayteam.c)
                EndIf
            EndIf
        Next
    Next
    If p2.x>0 Or p2.y>0 Then
        rlprint "There is a source of heat at "&p2.x &":"&p2.y &". It might be a lifeform."
    EndIf
    Return 0
End function


function shipstatus(heading as short=0) as short
'    dim as short c1,c2,c3,c4,c5,c6,c7,c8,sick,offset,mjs,filter
'    dim as short a,b,c,lastinv,set,tlen,cx,cy
'    dim as string text,key
'    dim inv(256) as _items
'    dim invn(256) as short
'    dim cargo(12) as string
'    dim cc(12) as short
    dim as short cw,turrets,a,offset
    set__color( 0,0)
    cls
    do
        cw=(tScreen.x-16*_fw2)/3.5
        cw=cw/_fw2
        if heading=0 then textbox("{15}Name: {11}"&player.desig &"{15} Type:{11}" &player.h_desig,1,0,40)

        textbox(shipstatsblock &"||" & weapon_string &"|" & cargo_text ,1,2,cw)

        textbox(crewblock,(2+cw)*_fw2/_fw1,2,16)

        textbox(list_artifacts(artflag()),(2+18+cw)*_fw2/_fw1,2,cw)

        if heading=0 then
            textbox(list_inventory,(2+18+2*cw)*_fw2/_fw1,2,cw,,,,,offset)

            no_key=keyin
            if no_key="+" then offset+=1
            if no_key="-" then offset-=1
        endif
    loop until not(no_key="+" or no_key="-")
    cls
    return 0
end function


function display_monsters(osx as short) as short
    dim as short a
    dim as _cords p
    for a=1 to lastenemy
        if enemy(a).hp<=0 then
            p.x=enemy(a).c.x
            p.y=enemy(a).c.y
            if awayteam.c.x=p.x and awayteam.c.y=p.y and comstr.comdead=0 then
                comstr.t=comstr.t &key_inspect &" Inspect;"
                comstr.comdead=1 'only add it once
            endif
            if  p.y>=0 and p.y<=20 then 'vis_test(awayteam.c,p,planets(slot).depth)=-1 and
                if vismask(p.x,p.y)>0 then
                    set__color( 12,0)
                    if configflag(con_tiles)=0 then
                        if enemy(a).hpmax>0 then put ((enemy(a).c.x-osx)*_tix,enemy(a).c.y*_tiy),gtiles(gt_no(1093)),trans
                    else
                        if enemy(a).hpmax>0 then draw string(p.x*_fw1,P.y*_fh1), "%",,font1,custom,@_col
                    endif
                endif
            endif
        endif
    next

    for a=1 to lastenemy
        if enemy(a).ti_no=-1 then enemy(a).ti_no=rnd_range(0,8)+1500 'Assign sprite range
        if enemy(a).hp>0 then
            DbgPrint(cords(p))
            p=enemy(a).c
            if comstr.comalive=0 and awayteam.c.x>=p.x-1 and awayteam.c.x<=p.x+1 and awayteam.c.y>=p.y-1 and awayteam.c.y<=p.y+1 then
                comstr.t=comstr.t & key_co &" Chat, " & key_of &" Offer;"
                comstr.comalive=1
            endif
            if p.x-osx>=0 and p.x-osx<=_mwx and p.y>=0 and p.y<=20 then
                if (vismask(p.x,p.y)>0) or player.stuff(3)=2 then
                    if enemy(a).cmshow=1 then
                        enemy(a).cmshow=0
                        set__color( enemy(a).col,179)
                    else
                        set__color( enemy(a).col,0)
                    endif
                    if enemy(a).invis=0 or (enemy(a).invis=3 and distance(enemy(a).c,awayteam.c)<2) then
                        if configflag(con_tiles)=0 then
                            put ((p.x-osx)*_tix,p.y*_tiy),gtiles(gt_no(enemy(a).ti_no)),trans
                        else
                            draw string(p.x*_fw1,P.y*_fh1),chr(enemy(a).tile),,font1,custom,@_col
                        endif
                        if enemy(a).sleeping>0 or enemy(a).hpnonlethal>enemy(a).hp then
                            if configflag(con_tiles)=0 then
                                set__color(  203,0)
                                draw string ((p.x-osx)*_tix,P.y*_fh1),"z",,font2,custom,@_tcol
                            else
                                set__color(  203,0)
                                draw string ((p.x-osx)*_fw1,P.y*_fh1),"z",,font2,custom,@_tcol
                            endif
                        endif
#if __FB_DEBUG__
                            Draw String ((p.x-osx)*_fw1,P.y*_fh1),"faction #" & enemy(a).faction & " NE"&enemy(a).denemy & " NF:" & enemy(a).dfriend &" T:"&cords(enemy(a).target) &" Att:"&enemy(a).attacked ,,font2,custom,@_tcol
#endif
                        if show_energy=1 then 
                            set__color(15,0)
                            draw string ((p.x-osx)*_tix,p.y*_tiy),"E:"&enemy(a).e.e,,font2,custom,@_tcol
                        endif
                        if player.stuff(3)<>2 and enemy(a).sleeping=0 and enemy(a).aggr=0 then walking=0
                    endif
                endif
            endif
        endif
    next


    return 0
end function


function ep_display(osx As Short=555) As Short
    Dim As Short a,b,x,y,slot,fg,bg,alp,x2
    Dim As Byte comitem,comdead,comalive,comportal
    Dim As _cords p,p1,p2
    slot=player.map
    If osx=555 Then osx=calcosx(awayteam.c.x,planets(slot).depth)

    If disease(awayteam.disease).bli>0 Then
        x=awayteam.c.x
        y=awayteam.c.y
        vismask(x,y)=1
        dtile(x,y,tmap(x,y),vismask(x,y))
        Return 0
    EndIf
    ' Stuff on ground
    make_vismask(awayteam.c,awayteam.sight,slot)
    
    For a=1 To itemindex.vlast'Cant use index because unseen grenades burn out too
        If item(itemindex.value(a)).ty=7 And item(itemindex.value(a)).v2=1 Then 'flash grenade
            item(itemindex.value(a)).v3-=1
            p2=item(itemindex.value(a)).w

            If item(itemindex.value(a)).v3>0 Then
                If vismask(p2.x,p2.y)>0 Then
                    make_vismask(item(itemindex.value(a)).w,item(itemindex.value(a)).v3/10,slot,1)
                EndIf
            Else
                'Burnt out, destroy
                destroyitem(itemindex.value(a))
                itemindex.remove(itemindex.value(a),item(itemindex.value(a)).w)
            EndIf
        EndIf
        If item(itemindex.value(a)).ty=18 And item(itemindex.value(a)).discovered=1 And item(itemindex.value(a)).w.p=0 And item(itemindex.value(a)).w.s>=0  And item(itemindex.value(a)).v5=0 Then 'Rover
            make_vismask(item(itemindex.value(a)).w,item(itemindex.value(a)).v1+3,slot,1)
        endif
    Next
        
    For x=0 To _mwx
        For y=0 To 20
            p.x=x+osx
            p.y=y
            If p.x>60 Then p.x=p.x-61
            If p.x<0 Then p.x=p.x+61

            'if awayteam.sight>cint(distance(awayteam.c,p)) then
            If vismask(p.x,y)>0 Then
                If planetmap(p.x,y,slot)<0 Then
                    planetmap(p.x,y,slot)=planetmap(p.x,y,slot)*-1
                    reward(0)=reward(0)+1
                    reward(7)=reward(7)+planets(slot).mapmod
                    If tiles(planetmap(p.x,y,slot)).stopwalking>0 And walking<11 Then walking=0
                    If player.questflag(9)=1 And planetmap(p.x,y,slot)=100 Then player.questflag(9)=2
                EndIf
                If rnd_range(1,100)<disease(awayteam.disease).hal Then
                    dtile(x,y,tiles(rnd_range(1,255)),1)
                    planetmap(x,y,slot)=planetmap(x+osx,y,slot)*-1
                Else
                    dtile(x,y,tmap(p.x,y),vismask(p.x,y))
                EndIf
            endif
            
            a=0
            if portalindex.last(p.x,p.y)>0 then 
                display_portal(portalindex.index(p.x,p.y,1),slot,osx)
                If portal(a).from.m=slot And portal(a).oneway<2 and awayteam.c.x=portal(a).from.x And awayteam.c.y=portal(a).from.y And comstr.comportal=0 Then
                    comstr.t=comstr.t &key_portal &" Enter"
                    comstr.comportal=1
                endif
                If portal(a).oneway=0 and portal(a).dest.m=slot and awayteam.c.x=portal(a).dest.x And awayteam.c.y=portal(a).dest.y And comstr.comportal=0 Then
                    comstr.t=comstr.t &key_portal &" Enter"
                    comstr.comportal=1
                EndIf
            endif
        
            if itemindex.last(p.x,p.y)>0 then
                for b=1 to itemindex.last(p.x,p.y)
                    display_item(itemindex.index(p.x,p.y,b),osx,slot)
                next
            endif
        Next
    Next
    
    display_monsters(osx)
    
    Return 0
End function


function ep_radio(ByRef nextlanding As _cords,ByRef ship_landing As Short, shipfire() As _shipfire,lavapoint() As _cords, ByRef sf As Single,nightday() As Byte,localtemp() As Single) As Short
    Dim As _cords p,p1,p2,pc
    Dim As String text,mtext
    Dim As Short a,b,slot,osx,ex,shipweapon,roverlist(128),c
    Dim As _weap del
    slot=player.map
    osx=calcosx(awayteam.c.x,planets(slot).depth)
    tScreen.set(1)
    p2.x=player.landed.x
    p2.y=player.landed.y
    rlprint "Engaging remote control."
    If (pathblock(awayteam.c,p2,slot,1)=-1 Or awayteam.stuff(8)=1 Or distance(awayteam.c,p2)<2) And player.landed.m=slot Then
        rlprint "Your command?"
        text=" "
        pc=locEOL
        text=Ucase(gettext(pc.x,pc.y,46,text))
        If Instr(text,"ROVER")>0 Then
            DbgPrint("Contacting Rover")
            b=0
            mtext="Rovers:/"
            For a=1 To itemindex.vlast 'Looking for Rover
                If item(itemindex.value(a)).ty=18 And item(itemindex.value(a)).w.p=0 And item(itemindex.value(a)).w.s=0 Then 
                    b=itemindex.value(a)
                    p1.x=item(b).w.x
                    p1.y=item(b).w.y
                    If pathblock(p2,p1,slot,1)=-1 Or (awayteam.stuff(8)=1 And player.landed.m=slot) Then
                        c+=1
                        roverlist(c)=b
                        mtext=mtext &item(b).desig &" "&cords(item(b).w) &"/"
                    endif
                endif
            Next
            DbgPrint(b &" Rover found.")
            if c>1 then
                b=textmenu(bg_awayteamtxt,mtext,"",2,2)
                if b>0 then b=roverlist(b)
            endif
            if c=1 then b=roverlist(1)
            If b>0 Then
                If Instr(text,"STOP")>0 Then
                    rlprint "Sending stop command to rover"
                    item(b).v5=1
                EndIf
                If Instr(text,"START")>0 Then
                    rlprint "sending start command to rover."
                    item(b).v5=0
                EndIf
                If Instr(text,"TARGET")>0 Then
                    rlprint "Get target for rover:"
                    text=get_planet_cords(p1,slot)
                    If text=key__enter Then 
                        item(b).v5=0
                        item(b).vt=p1
                    endif
                    text=""
                EndIf
                If Instr(text,"POSITI")>0 Or Instr(text,"WHERE")>0 Then
                    rlprint "Rover is at "& item(b).w.x &":"& item(b).w.y &"."
                EndIf
            Else
                rlprint "No rover to contact"
            EndIf
            text=""
        EndIf
        If Instr(text,"HELP")>0 Then rlprint "How shall we help you? come to you or fire on something or launch?"
        If Instr(text,"SELFDESTRUCT")>0 Then rlprint "We don't have a selfdestruct device. Guess we could make the reactor go critical, but why would we want to?"
        If Instr(text,"SCAN")>0 Or Instr(text,"ORBITAL")>0 Or Instr(text,"SATELLI")>0 Then
            If awayteam.stuff(8)=0 Then
                rlprint "We don't have a satellite in orbit"
            Else
                If Instr(text,"LIFE")>0 Then
                    ep_heatmap(lavapoint(),5)
                Else
                    a=rnd_range(0,itemindex.vlast)
                    If item(itemindex.value(a)).ty=15 And item(itemindex.value(a)).w.p=0 And item(itemindex.value(a)).w.s=0 Then
                        item(itemindex.value(a)).discovered=1
                        rlprint "We have indications that there is an ore deposit at "& cords(item(itemindex.value(a)).w) &"."
                    Else
                        rlprint "No new information from orbital scans."
                    EndIf
                EndIf
            EndIf
        EndIf
        If Instr(text,"POSIT")>0 Or Instr(text,"LOCATI")>0 Or Instr(text,"WHERE")>0 Then
            rlprint "We are at " &player.landed.x &":" &player.landed.y
        EndIf
        If Instr(text,"LAUNC")>0 Or Instr(text,"START")>0 Then
            If (slot=specialplanet(2) And specialflag(2)<2) Or (slot=specialplanet(27) And specialflag(27)=0) Then
                If slot=specialplanet(2) Then rlprint "We can't start untill we disabled the automatic defense system."
                If slot=specialplanet(27) Then rlprint "Can't get her up from this surface. She is stuck."
            Else
                If askyn("Are you certain? you want to launch on remote and leave you behind? (y/n)") Then
                    If planets(slot).depth=0 Then
                        player.dead=4
                    Else
                        rlprint "Good luck then."
                        player.landed.m=0
                    EndIf
                EndIf
            EndIf
        EndIf
        If Instr(text,"HELLO")>0 Then rlprint "Yes?"
        If Instr(text,"STATUS")>0 Or Instr(text,"REPORT")>0 Then
            screenshot(1)
            shipstatus()
            screenshot(2)
            rlprint "The ship is fine, like you left her"
            For a=1 To 5
                If distance(p2,lavapoint(a))<2 And lavapoint(a).x>0 And lavapoint(a).y>0 Then
                    rlprint "Lava is coming a bit close though"
                    Exit For
                EndIf
            Next
        EndIf
        If Instr(text,"GET")>0 Or Instr(text,"COME")>0 Or Instr(text,"LAND")>0 Or Instr(text,"RESCUE")>0 Or Instr(text,"MOVE")>0 Or Instr(text,"FETCH")>0 Then
            If (slot=specialplanet(2) And specialflag(2)<2) Or (slot=specialplanet(27) And specialflag(27)=0) Or planets(slot).depth>0 Then
                If slot=specialplanet(2) Then rlprint "We can't start untill we disabled the automatic defense system."
                If slot=specialplanet(27) Then rlprint "Can't get her up from this surface. She is stuck."
                If planets(slot).depth>0 Then rlprint "I think you are slightly overestimating the size of the airlock, captain!"
            Else
                p.x=player.landed.x
                p.y=player.landed.y
                If Instr(text,"HERE")>0 Then
                    nextlanding.x=awayteam.c.x
                    nextlanding.y=awayteam.c.y
                    player.landed.m=0
                Else
                    rlprint "Roger. Where do you want me to land?"
                    nextlanding=awayteam.c
                    text=get_planet_cords(nextlanding,slot,1)
                    If text=key__enter Then
                        player.landed.m=0
                    Else
                        nextlanding.x=p.x
                        nextlanding.y=p.y
                    EndIf
                EndIf
                If nextlanding.x=player.landed.x And nextlanding.y=player.landed.y Then
                    rlprint "We already are at that position."
                    player.landed.m=slot
                Else
                    ship_landing=20*distance(p,nextlanding,1)/2
                    If ship_landing<1 Then ship_landing=1
                    If crew(2).onship=lc_onship Then
                        rlprint "ETA in "&Int(ship_landing/20) &". See you there."
                    Else
                        rlprint "ETA in "&Int(ship_landing/20) &". Putting her down there by remote control."
                    EndIf
                EndIf
            EndIf
        EndIf
        If Instr(text,"FIR")>0 Or Instr(text,"NUKE")>0 Or Instr(text,"SHOOT")>0 Then
            sf=sf+1
            If sf>15 Then sf=0
            display_ship(0)
            shipweapon=com_getweapon
            If shipweapon>0 Then
                shipfire(sf).where=awayteam.c
                rlprint "Choose target"
                Do
                    text=planet_cursor(shipfire(sf).where,slot,osx,1)
                    ep_display(osx)
                    display_awayteam(,osx)
                    text=Cursor(shipfire(sf).where,slot,osx)
                    If text=key__enter Then ex=-1
                    If text=key_quit Or text=key__esc Then ex=1
                Loop Until ex<>0
                If text=key__enter Then
                    If pathblock(p2,shipfire(sf).where,slot,1)=0 Then
                        rlprint "No line of sight to that target."
                        shipfire(sf).where.x=-1
                        shipfire(sf).where.y=-1
                    Else
                        shipfire(sf).when=(distance(awayteam.c,p2)\10)+1
                        Cls
                        display_ship
                        shipfire(sf).what=shipweapon
                        If shipfire(sf).what<0 Then
                            shipfire(sf).what=6
                            shipfire(sf).when=-1
                        EndIf
                        If player.weapons(shipfire(sf).what).ammomax=0 And distance(shipfire(sf).where,p2,1)>10 Then shipfire(sf).when=-5
    
                        If player.weapons(shipfire(sf).what).desig="" Then shipfire(sf).when=-1
                        If player.weapons(shipfire(sf).what).ammomax>0 Then
                            If player.useammo=0 Then shipfire(sf).when=-2
                        EndIf
                        If player.weapons(shipfire(sf).what).shutdown<>0 Then shipfire(sf).when=-3
                        If player.weapons(shipfire(sf).what).reloading<>0 Then shipfire(sf).when=-4
                        If shipfire(sf).when>0 Then
                            rlprint player.weapons(shipfire(sf).what).desig &" fired"
                            player.weapons(shipfire(sf).what).heat+=player.weapons(shipfire(sf).what).heatadd*25
                            player.weapons(shipfire(sf).what).reloading=player.weapons(shipfire(sf).what).reload
                            If Not(skill_test(player.gunner(0),player.weapons(shipfire(sf).what).heat/25)) Then
    
                                rlprint player.weapons(shipfire(sf).what).desig &" shuts down due to heat."
                                player.weapons(shipfire(sf).what).shutdown=1
                                If Not(skill_test(player.gunner(location),player.weapons(shipfire(sf).what).heat/20,"Gunner: Shutdown")) Then
                                    rlprint player.weapons(shipfire(sf).what).desig &" is irreperably damaged."
                                    player.weapons(shipfire(sf).what)=del
                                EndIf
                            EndIf
                        EndIf
                        If shipfire(sf).when=-1 Then rlprint "Fire order canceled"
                        If shipfire(sf).when=-2 Then rlprint "I am afraid we are out of ammunition"
                        If shipfire(sf).when=-3 Then rlprint "Can't fire that weapon at this time."
                        If shipfire(sf).when=-5 Then rlprint "That target is below the horizon."
                        If shipfire(sf).when=-4 Then
                            If player.weapons(shipfire(sf).what).ammomax=0 Then
                                rlprint "That weapon is currently recharging."
                            Else
                                rlprint "That weapon is currently reloading."
                            EndIf
                        EndIf
                    EndIf
                Else
                    rlprint "Fire order canceled."
                EndIf
            EndIf
        EndIf
        awayteam.e.add_action(25)
    Else
        rlprint "No contact possible"
    EndIf
    Return 0
End function


function space_radio() As Short
    DimDebug(0)
    Dim As Short i,closestfleet,closestdrifter,lc,j,disnum,dis,y
    Dim As _cords p
    Dim dummy As _monster
    Dim du(2) As Short
    Dim c(25) As _cords
    Dim contacts(25) As Short
    Dim As String fname(8),text,dname(2)

    dname(0)=" (Strong signal)"
    dname(1)=""
    dname(2)=" (Weak signal)"

    gen_fname(fname())

    Dim As Single dd
    ''dim as single df,dd
    ''df=9999
    For i=1 To lastfleet
        If fleet(i).ty=1 Or fleet(i).ty=3 Or fleet(i).ty=6 Or fleet(i).ty=7 Then
            If distance(fleet(i).c,player.c)<player.sensors*2 And lc<25 Then
                lc+=1
                c(lc)=fleet(i).c
                contacts(lc)=i
            EndIf
        EndIf
    Next
    dd=9999
    For i=1 To lastdrifting
        p.x=drifting(i).x
        p.y=drifting(i).y
        If i<=3 Or (planets(drifting(i).m).mon_template(0).made=32 And planets(drifting(i).m).flags(0)=0) Then
            If distance(p,player.c)<player.sensors*2 And lc<25 Then
                lc+=1
                c(lc).x=drifting(i).x
                c(lc).y=drifting(i).y
                contacts(lc)=-i 'Drifters are negative
            EndIf
        EndIf
    Next

    If lc>0 Then
        If lc=1 Then
            i=contacts(lc)
        Else
            text="Contact:"

            sort_by_distance(player.c,c(),contacts(),lc)
            For j=1 To lc
                If contacts(j)>0 Then
                    dis=CInt(distance(player.c,fleet(contacts(j)).c))
                    Select Case dis
                    Case 0 To player.sensors*2/3
                        disnum=0
                    Case player.sensors*2/3 To player.sensors*4/3
                        disnum=1
                    Case Else
                        disnum=2
                    End Select

                    text=text &"/"&fname(fleet(contacts(j)).ty) &dname(disnum)
                Else
                    p.x=drifting(Abs(contacts(j))).x
                    p.y=drifting(Abs(contacts(j))).y
                    dis=CInt(distance(player.c,p))
                    Select Case dis
                    Case 0 To player.sensors*2/3
                        disnum=0
                    Case player.sensors*2/3 To player.sensors*4/3
                        disnum=1
                    Case Else
                        disnum=2
                    End Select
                    text=text &"/"&shiptypes(drifting(Abs(contacts(j))).s)&dname(disnum)
#if __FB_DEBUG__
                    If debug=1310 Then text &="("&contacts(j) &")"
#endif
                EndIf
            Next
            text=text &"/Cancel"
            y=(20*_fh1-(lc+1)*_fh2)/_fh1
            If y<0 Then y=0
            i=textmenu(bg_ship,text,"",0,y)
            If i=lc+1 Then Return 0
            i=contacts(i)
        EndIf
    Else
        i=0
        rlprint "No contact."
    End If
    Select Case i
    Case Is>0
        If fleet(i).ty=1 And i>5 Then
            If fleet(i).con(1)=0 Then
                do_dialog(5,dummy,i)
            Else
                do_dialog(11,dummy,i)
            EndIf
        EndIf
        If fleet(i).ty=3 Then do_dialog(3,dummy,i)
        dummy.lang=fleet(i).ty+26
        dummy.aggr=1
        DbgPrint( "dummy.lang: " & dummy.lang)
        If fleet(i).ty=6 Then communicate(dummy,1,1)
        If fleet(i).ty=7 Then communicate(dummy,1,1)

    Case Is<0
        i=Abs(i)
        If i<=3 Then
            do_dialog(10,dummy,-i)
            Return 0
        EndIf
        p.x=drifting(i).x
        p.y=drifting(i).y
        If planets(drifting(i).m).mon_template(0).made=32 And (planets(drifting(i).m).flags(0)=0 And planets(drifting(i).m).atmos>0) Then
            do_dialog(4,dummy,-i)
        Else
            rlprint "They don't answer."
        EndIf

    End Select
    Return 0
End function


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tRadio -=-=-=-=-=-=-=-
	tModule.register("tRadio",@tRadio.init()) ',@tRadio.load(),@tRadio.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tRadio -=-=-=-=-=-=-=-
#endif'test
