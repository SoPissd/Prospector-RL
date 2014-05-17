'tExplore.
'
'defines:
'trouble_with_tribbles=0, update_world=2, teleport=6, explore_planet=0
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
'     -=-=-=-=-=-=-=- TEST: tExplore -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tExplore -=-=-=-=-=-=-=-

declare function update_world(location as short) as short
declare function teleport(from As _cords,map As Short) As _cords
declare function explore_planet(from As _cords, orbit As Short) As _cords

'private function trouble_with_tribbles() as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tExplore -=-=-=-=-=-=-=-

namespace tExplore
function init(iAction as integer) as integer
	return 0
end function
end namespace'tExplore




function trouble_with_tribbles() as short
    dim as short i
    if rnd_range(1,100)<unattendedtribbles and rnd_range(1,100)<unattendedtribbles then
    select case rnd_range(1,100)
    case 1 to 33
        for i=1 to 9
            if player.cargo(i).x=2 then
                rlprint "Some unattended tribbles have gotten into the cargo hold and eaten a whole ton of food!",c_yel
                player.cargo(i).x=1
                exit for
            endif
        next
    case 34 to 66
        if player.cursed=0 then player.cursed=1
    case else
        if missing_ammo>0 then
            for i=1 to 10
                if player.weapons(i).ammo<player.weapons(i).ammomax then
                    player.weapons(i).ammo+=1
                    player.tribbleinfested+=1
                    exit for
                endif
            next
        endif
    end select
    endif
    return 0
end function


function update_world(location as short) as short
    dim as short a,b
    diseaserun(1)
    clearfleetlist
    
    if tVersion.gameturn mod 60=0 then
        if artflag(23)>0 and player.hull<player.h_maxhull then player.hull+=1
        move_fleets()
        collide_fleets()
        move_probes()
        cure_awayteam(location)
        
        for a=0 to laststar
            if map(a).planets(1)>0 then
                if planets(map(a).planets(1)).flags(27)=2 then
                    planets(map(a).planets(1)).death-=1
                    if planets(map(a).planets(1)).death<=0 then
                        map(a).planets(1)=0
                    endif
                endif
            endif
        next
        
    endif
    
    if tVersion.gameturn mod (24*60)=0 or location=2 then 'Daily,loc2=forced
        for a=0 to 12
            change_prices(a,10)
        next
        
        for a=0 to 2
            if fleet(a).mem(1).hull<128 and fleet(a).mem(1).hull>0 then fleet(a).mem(1).hull+=3
        next
        if location=1 then trouble_with_tribbles
        clean_station_event
        questroll=rnd_range(1,100)-10*(crew(1).talents(3))
    endif
    
    if tVersion.gameturn mod (24*60*7)=0 then 'Weekly
        set_fleet(make_fleet)
        if rnd_range(1,100)<50 then
            set_fleet(makecivfleet(0))
        else
            set_fleet(makecivfleet(1))
        endif
        if tVersion.gameturn>2*30*24*60 and player.questflag(3)=0 then
            set_fleet(makealienfleet)
        endif
        reroll_shops
        
        for a=0 to 2
            colonize_planet(a)
        next
        grow_colonies
        
        if tVersion.gameturn>2*30*24*60 and rnd_range(1,100)<1+cint(tVersion.gameturn/10000) then robot_invasion
            
        for a=1 to lastquestguy
            if rnd_range(1,100)<25 and questguy(a).job=9 then questguy_newloc(a)
            if rnd_range(1,100)<25 and questguy(a).job<>1 then questguy_newloc(a)
            if questguy(a).want.type=qt_travel then
                questguy(a).location=questguy(a).flag(12)
                questguy(a).want.given=1
            endif
            if questguy(a).want.given=1 then questguy(a).want.type=0
            if questguy(a).has.given=1 then questguy(a).has.type=0
            if (questguy(a).has.type=0 or questguy(a).want.type=0) and rnd_range(1,100)<10 then
                questguy_newquest(a)
            endif
        next
        for b=0 to 2
            a=basis(b).company
            tCompany.companystats(a).profit=tCompany.companystats(a).profit+(rnd_range(1,6)+rnd_range(1,6)-rnd_range(1,6)-rnd_range(1,6))
            if tCompany.companystats(a).profit>0 then 
                tCompany.companystats(a).profit=(tCompany.companystats(a).profit+rnd_range(0,1))*(tCompany.companystats(a).capital/50)
            else
                tCompany.companystats(a).profit=tCompany.companystats(a).profit*(tCompany.companystats(a).capital/50)
            endif
            tCompany.companystats(a).capital=tCompany.companystats(a).capital+tCompany.companystats(a).profit
            tCompany.companystats(a).rate=tCompany.companystats(a).capital/tCompany.companystats(a).shares
            if tCompany.companystats(a).profit>0 then tCompany.companystats(a).rate+=1'rnd_range(1,6)
            if tCompany.companystats(a).profit<=0 then tCompany.companystats(a).rate-=1'rnd_range(1,6)
            tCompany.companystats(a).profit=0
            if tCompany.companystats(a).capital>50000 then tCompany.companystats(a).capital=50000
        next
        
    endif
    
    return 0
end function


function teleport(from As _cords,map As Short) As _cords
    Dim target As _cords
    Dim ex As Short
    Dim Key As String
    Dim osx As Short

    If planets(map).teleport<>0 Then
        rlprint "Something is jamming your teleportation device!",14
        Return from
    EndIf
    If player.teleportload<10 Then
        rlprint "The teleportation device still needs some time to recharge!"
        Return from
    EndIf
    target=awayteam.c
    Do
        Key=planet_cursor(target,map,osx,1)
        display_awayteam(,osx)
        Key=Cursor(target,map,osx,,10)
        If Key=key_te Or Ucase(Key)=" " Or Multikey(FB.SC_ENTER) Then ex=1
        If Key=key_quit Or Multikey(FB.SC_ESCAPE) Then ex=-1
    Loop Until ex<>0
    If ex=1 Then
            from.x=target.x
            from.y=target.y
            player.teleportload=0
    EndIf
    Return from
End function



function explore_planet(from As _cords, orbit As Short) As _cords
    DimDebug(0)
    Dim As Single a,b,c,d,e,f,g,x,y,sf,sf2,vismod
    Dim As Short slot,r,deadcounter,ship_landing,loadmonsters,allroll(8),osx
    Dim As Single dawn,dawn2
    Dim As String Key,dkey,allowed,text,help
    Dim dam As Single
    Dim As _cords p,p1,p2,p3,nextlanding,old,nextmap
    Dim towed As _ship
    Dim As Short skill
    Dim mapmask(60,20) As Byte
    Dim nightday(60) As Byte
    Dim watermap(60,20) As Byte
    Dim localtemp(60,20) As Single
    Dim cloudmap(60,20) As Byte
    Dim spawnmask(1281) As _cords
    Dim lsp As Short
    Dim ti As Short
    
    DbgLogExplorePlanet("Starting ep loop")
    
    bg_parent=bg_awayteamtxt
    
    Dim diesize As Short
    Dim localturn As Short
    Dim tb As Single
    'dim oxydep as single
    Dim lavapoint(5) As _cords
    Dim shipfire(16) As _shipfire
    Dim areaeffect(16) As _ae
    Dim autofire_dir As Short
    Dim autofire_target As _cords
    Dim last_ae As Short
    Dim del_rec As _rect

'oob suchen
    For a=1 To 255
        enemy(a)=enemy(0)
    Next
    lastenemy=0

    tScreen.set(0)
    set__color(11,0)
    Cls
    tScreen.update()
    set__color(11,0)
    Cls
#if __FB_DEBUG__
    For a=0 To 9
        DbgPrint(planets(slot).mon_template(a).sdesc)
    Next
#endif
    slot=from.m
    planets(slot).mapstat=2
    deadcounter=0
    awayteam.c=from
    player.map=slot
    osx=calcosx(awayteam.c.x,slot)
    lsp=0
    location=lc_awayteam

    For a=1 To 20
        If makew(a,1)<>0 Then
            b+=1
            wsinv(b)=make_weapon(makew(a,1))
        EndIf
    Next

    osx=calcosx(awayteam.c.x,planets(slot).depth)

    For x=0 To 60
        For y=0 To 20
#if __FB_DEBUG__
            If debug=11 Then Print #f,planetmap(x,y,slot)
            If debug=312 Then planetmap(x,y,slot)=Abs(planetmap(x,y,slot))
#endif
            If Abs(planetmap(x,y,slot))=1 Then watermap(x,y)=10
            If Abs(planetmap(x,y,slot))=2 Then watermap(x,y)=50
            If planets(slot).depth=0 Then
                localtemp(x,y)=planets(slot).temp-Abs(10-y)*5+10
            Else
                localtemp(x,y)=planets(slot).temp
            EndIf
            If show_all=1 And planetmap(x,y,slot)<0 Then planetmap(x,y,slot)=-planetmap(x,y,slot)
            If Abs(planetmap(x,y,slot))>512 Then
                rlprint "ERROR: Tile #"&planetmap(x,y,slot)&"out ofbounds"
                planetmap(x,y,slot)=512
            EndIf
            tmap(x,y)=tiles(Abs(planetmap(x,y,slot)))
            If tmap(x,y).ti_no=2505 Then 'Ship walls
                If rnd_range(1,100)<33 Then
                    tmap(x,y).ti_no=2504+rnd_range(1,4)
                EndIf
            EndIf
            If Abs(planetmap(x,y,slot))=267 Then
                enemy(0)=makemonster(1,slot)
                tmap(x,y).desc="A cage. Inside is "&first_lc(enemy(0).ldesc)
                enemy(0)=enemy(1) 'Delete monster
            EndIf
            mapmask(x,y)=0
            If tmap(x,y).walktru=0 Then
                lsp=lsp+1
                spawnmask(lsp).x=x
                spawnmask(lsp).y=y
            EndIf
            If tmap(x,y).vege>0 Then
                tmap(x,y).vege=rnd_range(0,tmap(x,y).vege)
                If rnd_range(1,100)<tmap(x,y).vege/2 Then tmap(x,y).disease=rnd_range(0,tmap(x,y).vege/2)
            EndIf
            If rnd_range(1,100)<planets(slot).atmos And planets(slot).atmos>1 And planets(slot).depth=0 Then cloudmap(x,y)=1
            If planetmap(x,y,slot)=0 Then
            	tError.log_error("Tile at "&x &":"&y &":"&slot &"=0")
                planetmap(x,y,slot)=-4
            EndIf
        Next
    Next
    
    'allowed="12346789ULXFSQRWGCHDO"&key_pickup &key__i
    allowed=key_awayteam &key_ju & key_te & key_fi &key_save &key_quit &key_ra &key_walk & key_gr & key_he _
     & key_la & key_pickup & key_inspect & key_ex & key_of & key_co & key_drop & key_gr & key_wait _
     & key_portal &key_oxy &key_close & key_report &key_autofire &key_autoexplore
    comstr.t=key_ex &" examine;" &key_fi &" fire,"&key_autofire &" autofire;" &key_autoexplore &" autoexplore;"_
     & key_gr &" grenade;" &key_oxy &" open/close helmet;" &key_close &" close door;" &key_drop &" Drop;"_
     & key_he &" use medpack;" &key_report &" bioreport;"&key_ra &" radio;"

    If rev_map=1 Then allowed=allowed &"�"
    If awayteam.movetype=2 Or awayteam.movetype=3 Then
        allowed=allowed &key_ju
        comstr.t=comstr.t &key_ju &" Jetpackjump;"
    EndIf
    If artflag(9)=1 Then
        allowed=allowed &key_te
        comstr.t=comstr.t &key_te &" Teleport;"
    EndIf

    If planets(slot).atmos=0 Then planets(slot).atmos=1
    If planets(slot).grav=0 Then planets(slot).grav=.5

    If planets(slot).atmos>=3 And planets(slot).atmos<=6 Then
        awayteam.helmet=0
        awayteam.oxygen=awayteam.oxymax
    Else
        awayteam.helmet=1
    EndIf

    b=0
    For a=1 To 15 'Look for saved status on this planet
        If savefrom(a).map=slot Then
            lastenemy=savefrom(a).lastenemy
            For b=1 To lastenemy
                enemy(b)=savefrom(a).enemy(b)
            Next
            loadmonsters=1
        EndIf
    Next
    DbgLogExplorePlanet("loadmonsters:"&loadmonsters)
    If loadmonsters=0 Then 'No saved status, monsters need to be generated
        c=0
        For a=0 To 16
            If planets(slot).mon_noamin(a)>0 And planets(slot).mon_noamax(a)>0 Then
                If planets(slot).mon_template(a).made=0 Then planets(slot).mon_template(a)=makemonster(1,slot)
                For d=1 To rnd_range(planets(slot).mon_noamin(a),planets(slot).mon_noamax(a))
                    c+=1
                    enemy(c)=setmonster(planets(slot).mon_template(a),slot,spawnmask(),lsp,,,c,1)
                    enemy(c).slot=a
                    enemy(c).no=c
                    If enemy(c).faction=0 Then enemy(c).faction=9+a
                    If enemy(c).faction<9 Then
                        If allroll(enemy(c).faction)=0 Then allroll(enemy(c).faction)=rnd_range(1,100)
                        If faction(0).war(enemy(c).faction)>=allroll(enemy(c).faction) Then
                            enemy(c).aggr=0
                        Else
                            enemy(c).aggr=1
                        EndIf
                    EndIf
                Next
            EndIf
        Next
        lastenemy=c
        
        x=0
        For a=0 To lastspecial
            If specialplanet(a)=slot Then x=1
        Next
        For a=0 To _NoPB
            If piratebase(a)=slot Then x=1
        Next
        For a=1 To lastdrifting
            If drifting(a).m=slot Then x=1
        Next

        If planets(slot).visited=0 And planets(slot).depth=0 And x=0 Then
            tCompany.combon(0).Value+=1
            adaptmap(slot)
            lsp=0
            For x=0 To 60
                For y=0 To 20
                    If Abs(planetmap(x,y,slot))=1 Then watermap(x,y)=10
                    If Abs(planetmap(x,y,slot))=2 Then watermap(x,y)=50
                    localtemp(x,y)=planets(slot).temp-Abs(10-y)*5+10
                    If show_all=1 And planetmap(x,y,slot)<0 Then planetmap(x,y,slot)=-planetmap(x,y,slot)
                    tmap(x,y)=tiles(Abs(planetmap(x,y,slot)))
                    If Abs(planetmap(x,y,slot))=267 Then tmap(x,y).desc="A cage. Inside is "&makemonster(1,slot).ldesc
                    mapmask(x,y)=0
                    If tmap(x,y).walktru=0 Then
                        lsp=lsp+1
                        spawnmask(lsp).x=x
                        spawnmask(lsp).y=y
                    EndIf
                    If tmap(x,y).vege>0 Then
                        tmap(x,y).vege=rnd_range(0,tmap(x,y).vege)
                        If rnd_range(1,100)<tmap(x,y).vege/2 Then tmap(x,y).disease=rnd_range(0,tmap(x,y).vege/2)
                    EndIf
                Next
            Next

            If rnd_range(1,100)<5 And rnd_range(1,100)<disnbase(player.c) And lastenemy>10 And planets(slot).atmos>1 Then
                lastenemy=lastenemy+1
                enemy(lastenemy)=makemonster(46,slot)
                enemy(lastenemy)=setmonster(enemy(lastenemy),slot,spawnmask(),lsp,,,lastenemy,1)
                enemy(lastenemy).slot=16
                enemy(lastenemy).no=lastenemy
                If rnd_range(1,100)<disnbase(player.c)*2 Then placeitem(make_item(81),enemy(lastenemy).c.x,enemy(lastenemy).c.y,slot)
            EndIf
            If rnd_range(1,100)<26-disnbase(player.c) Then 'deadawayteam
                lastenemy=lastenemy+1
                enemy(lastenemy)=makemonster(15,slot)
                enemy(lastenemy)=setmonster(enemy(lastenemy),slot,spawnmask(),lsp,,,lastenemy,1)
                enemy(lastenemy).hp=-1
                enemy(lastenemy).hpmax=55
                enemy(lastenemy).slot=16
                If show_all=1 Then rlprint "corpse at "&enemy(lastenemy).c.x & enemy(lastenemy).c.y
            EndIf
            If rnd_range(1,100)<26-distance(player.c,civ(0).home) Then
                lastenemy+=1
                enemy(lastenemy)=setmonster(civ(0).spec,slot,spawnmask(),lsp,,,lastenemy,1)
                enemy(lastenemy).hp=-1
                enemy(lastenemy).slot=16
            EndIf
            If rnd_range(1,100)<26-distance(player.c,civ(1).home) Then
                lastenemy+=1
                enemy(lastenemy)=setmonster(civ(1).spec,slot,spawnmask(),lsp,,,lastenemy,1)
                enemy(lastenemy).hp=-1
                enemy(lastenemy).slot=16
            EndIf
        EndIf
        If slot=piratebase(0) Then
            For x=0 To 60
                For y=0 To 20
                    If Abs(planetmap(p.x,p.y,slot))=246 Then
                        changetile(p.x,p.y,slot,68)
                        tmap(p.x,p.y)=tiles(68)
                    EndIf
                Next
            Next
            If rnd_range(1,100)<25 Then
                Do
                    p=rnd_point(slot,,68)
                Loop Until tmap(p.x,p.y).gives=0
                planetmap(p.x,p.y,slot)=-246
                tmap(p.x,p.y)=tiles(246)
            EndIf
        EndIf

        For c=0 To 8
        b=(planets(slot).vault(c).h-2)*((planets(slot).vault(c).w-2))
        If b>4 Or planets(slot).vault(c).wd(5)=4 Then
            DbgPrint("Making vault at "&planets(slot).vault(c).x &":"& planets(slot).vault(c).y &":"& planets(slot).vault(c).w &":"& planets(slot).vault(c).h)
            If planets(slot).vault(c).wd(16)=99 Then specialflag(15)=1
            If planets(slot).vault(c).wd(5)=1 Then
                If b>9 Then
                    lastenemy=lastenemy-rnd_range(1,6)
                    If lastenemy<1 Then lastenemy=1
                    a=lastenemy+1
                    For x=planets(slot).vault(c).x+1 To planets(slot).vault(c).x+planets(slot).vault(c).w-1
                        For y=planets(slot).vault(c).y+1 To planets(slot).vault(c).y+planets(slot).vault(c).h-1
                            If a>255 Then a=255
                            enemy(a)=makemonster(9,slot)
                            enemy(a)=setmonster(enemy(a),slot,spawnmask(),lsp,x,y,a,1)
                            a=a+1
                        Next
                    Next
                    lastenemy=a
                    If lastenemy>255 Then lastenemy=255
                EndIf
            EndIf

            If planets(slot).vault(c).wd(5)=2 And planets(slot).vault(c).wd(6)<>0 Then
                b=rnd_range(1,4)+rnd_range(1,4)+planets(slot).depth
                d=lastenemy
                DbgPrint("lastenemy"&lastenemy)
                lastenemy=lastenemy+b
                For e=d To lastenemy
                    text=text &d
                    Do
                        x=rnd_range(planets(slot).vault(c).x,planets(slot).vault(c).x+planets(slot).vault(c).w)
                        y=rnd_range(planets(slot).vault(c).y,planets(slot).vault(c).y+planets(slot).vault(c).h)
                    Loop Until tmap(x,y).walktru=0
                    DbgPrint("Set monster at "&x &":"&y)
                    If planets(slot).vault(c).wd(6)>0 Then
                        enemy(e)=makemonster(planets(slot).vault(c).wd(6),slot)
                        enemy(e)=setmonster(enemy(d),slot,spawnmask(),lsp,x,y,d)
                    Else
                        enemy(e)=setmonster(planets(slot).mon_template(-planets(slot).vault(c).wd(6)),slot,spawnmask(),lsp,x,y,e)
                        DbgPrint("Enemy "&e &" is at "&enemy(e).c.x &":"&enemy(e).c.y)
                    EndIf
                Next
                DbgPrint("lastenemy"&lastenemy)
            EndIf

            If planets(slot).vault(c).wd(5)=3 Then
                DbgPrint("lastenemy"&lastenemy)
                b=rnd_range(1,4)+rnd_range(1,4)+planets(slot).depth
                d=lastenemy
                lastenemy=lastenemy+b
                For e=d To lastenemy
                    Do
                        x=rnd_range(planets(slot).vault(c).x,planets(slot).vault(c).x+planets(slot).vault(c).w)
                        y=rnd_range(planets(slot).vault(c).y,planets(slot).vault(c).y+planets(slot).vault(c).h)
                    Loop Until tmap(x,y).walktru=0
                    DbgPrint("Set monster at "&x &":"&y)
                    enemy(e)=makemonster(59,slot)
                    enemy(e)=setmonster(enemy(d),slot,spawnmask(),lsp,x,y,e,1)
                Next
                DbgPrint("lastenemy"&lastenemy)
            EndIf
            If planets(slot).vault(c).wd(5)=4 Then
                For x=planets(slot).vault(c).x To planets(slot).vault(c).x+planets(slot).vault(c).w
                    For y=planets(slot).vault(c).y To planets(slot).vault(c).y+planets(slot).vault(c).h
                        If tmap(x,y).walktru=0 Then
                            lastenemy+=1
                            enemy(lastenemy)=setmonster(planets(slot).mon_template(Abs(planets(slot).vault(c).wd(6))),slot,spawnmask(),lsp,x,y,lastenemy)
                        EndIf
                    Next
                Next

            EndIf
            planets(slot).vault(c)=del_rec
        EndIf
        Next
    For a=0 To _NoPB
        If slot=piratebase(a) Then
            c=5+rnd_range(1,6)
            For b=lastenemy To lastenemy+c
                enemy(b)=makemonster(3,slot)
                enemy(b)=setmonster(enemy(b),slot,spawnmask(),lsp,,,b,1)
            Next
            lastenemy=lastenemy+c
        EndIf
    Next

EndIf
    
    For a=0 To 16
        planets(slot).mon_template(a).slot=a
    Next
    
    DbgLogExplorePlanet("Move rovers")
    move_rover(slot)
    'if planets(slot).colony<>0 then growcolony(slot)

    If planets(slot).visited>0 And planets(slot).visited<tVersion.gameturn Then
        b=planets(slot).visited-tVersion.gameturn
        For e=1 To lastenemy
            If enemy(e).made=101 And enemy(e).hp>0 Then
                For a=1 To b
                    p=rnd_point(slot,,,1)
                    If p.x>=0 Then
                        changetile(p.x,p.y,slot,4)
                        tmap(p.x,p.y)=tiles(4)
                    EndIf
                Next

            EndIf
        Next

    EndIf

    planets(slot).discovered=3
    planets(slot).visited=tVersion.gameturn
    If planets(slot).flags(27)=1 Then planets(slot).flags(27)=2

    If slot=specialplanet(0) And player.towed=4 Then
        rlprint "The alien generation ship lands next to yours and the insects start exploring and setting up their colony immediately."
        p=movepoint(player.landed,5)
        'questflag(0)=1
        player.towed=0
        planetmap(p.x,p.y,slot)=269
        tmap(p.x,p.y)=tiles(269)
        drifting(4).x=-1 'Move drifting off the map (Can't delete it, since then another ship could get generated there and would trigger the event
        planets(slot).mon_template(1)=makemonster(80,slot)
        planets(slot).mon_noamin(1)=10
        planets(slot).mon_noamax(1)=14
        planets(slot).mon_template(2)=makemonster(25,slot)
        planets(slot).mon_noamin(2)=10
        planets(slot).mon_noamax(2)=14
    EndIf


    If slot=specialplanet(1) And specialflag(1)=0 Then 'apollos planet
        lastenemy+=1
        enemy(lastenemy)=makemonster(5,slot)
        enemy(lastenemy)=setmonster(enemy(lastenemy),slot,spawnmask(),lsp,,,b,1)
        player.landed=rnd_point
        player.landed.m=slot
        do_dialog(2,enemy(lastenemy),0)
        If enemy(b).aggr=0 Then
            rlprint enemy(lastenemy).sdesc &" doesn't seem pleased with your response."
        Else
            rlprint enemy(lastenemy).sdesc &" does seem pleased with your response."
        EndIf
    EndIf
    
    If slot=specialplanet(2) Then
        If specialflag(2)=0 Then

            specialflag(2)=1
            rlprint "As you enter the lower atmosphere a powerful energy beam strikes your ship from the surface below! A planetery defense system has detected you!"
            a=textmenu(bg_parent,"Flee into:/Space/Below horizon")
            If a=1 Then
                If skill_test(player.pilot(location),st_veryhard,"Pilot") Then
                    If skill_test(player.pilot(location),st_veryhard,"Pilot") Then
                        If skill_test(player.pilot(location),st_veryhard,"Pilot") Then
                            nextmap.m=-1
                            Return nextmap
                        EndIf
                    EndIf
                EndIf
            EndIf
            rlprint "You are already too low to escape into orbit, so the only way to avoid total destruction is an emergency landing! Your vessel slams into the surface!",15
            If Not(skill_test(player.pilot(location),st_veryhard,"Pilot")) Then player.hull=player.hull-rnd_range(1,6)
            If player.hull<=0 Then
                planetmap(player.landed.x,player.landed.y,slot)=127+player.h_no
                tmap(player.landed.x,player.landed.y)=tiles(127+player.h_no)
                player.landed.m=0
            EndIf
            For a=0 To rnd_range(1,6) +rnd_range(1,6)
                lastenemy=lastenemy+1
                enemy(lastenemy)=makemonster(15,slot)
                enemy(lastenemy).hp=-1
            Next
        EndIf
        If specialflag(2)=2 Then
            For x=0 To 60
                For y=0 To 20
                    If planetmap(x,y,slot)=-168 Then planetmap(x,y,slot)=-169
                    If planetmap(x,y,slot)=168 Then planetmap(x,y,slot)=169
                    If Abs(planetmap(x,y,slot))=169 Then tmap(x,y)=tiles(169)
                Next
            Next
        EndIf
    EndIf

    If specialplanet(8)=slot Then 'stormy,less critters
        lastenemy=lastenemy-rnd_range(1,5)
        If lastenemy<0 Then lastenemy=0
    EndIf

    If specialplanet(11)=slot Then lastenemy=0 'No critters on dying world

    If planets(slot).flags(25)<>0 Or specialplanet(40)=slot Then
        For x=0 To 60
            For y=0 To 20
                tmap(x,y).disease=13
            Next
        Next
        If planets(slot).flags(25)=2 Then
            awayteam.helmet=1
        Else
           planets(slot).mapmod=0
        EndIf
    EndIf
    '
    '   loaded game in savefrom
    '
    '    This only if savegame
    '
    If savefrom(0).map>0 Then
        awayteam=savefrom(0).awayteam
        player.landed=savefrom(0).ship
        slot=savefrom(0).map
        lastenemy=savefrom(0).lastenemy
        For b=1 To lastenemy
            enemy(b)=savefrom(0).enemy(b)
        Next
        equip_awayteam(slot)
    EndIf
    
    DbgLogExplorePlanet("equip")
    equip_awayteam(slot)

    c=0
    For a=0 To lastitem
        If item(a).ty=47 And item(a).w.m=slot And item(a).w.s=0 Then
            lastenemy=lastenemy+1
            enemy(lastenemy)=makemonster(15,slot)
            enemy(lastenemy)=setmonster(enemy(lastenemy),slot,spawnmask(),lsp,,,lastenemy,1)
            enemy(lastenemy).hp=-1
            enemy(lastenemy).hpmax=55
            enemy(lastenemy).slot=16
        EndIf
    Next
    
    DbgLogExplorePlanet("locallists")
    make_locallist(slot)

    lsp=0
    For x=0 To 60
        For y=0 To 20
            mapmask(x,y)=0
            If tmap(x,y).walktru=0 Then
                lsp=lsp+1
                spawnmask(lsp).x=x
                spawnmask(lsp).y=y
            EndIf
        Next
    Next

    If slot=specialplanet(16) Then
        If findbest(24,-1)>0 Then
            For a=1 To lastenemy
                enemy(a).aggr=0
            Next
        Else
            For a=1 To lastenemy
                enemy(a).aggr=1
            Next
        EndIf
    EndIf

    If slot=specialplanet(37) Then
        p.x=25
        p.y=5
        invisiblelabyrinth(tmap(),p.x,p.y)
    EndIf

    If alien_scanner=1 Then player.stuff(3)=2

    'outpost trading
    For a=11 To 13
        planets(slot).flags(a)=planets(slot).flags(a)+rnd_range(1,6) +rnd_range(1,6)-rnd_range(1,6)-rnd_range(1,6)
        If planets(slot).flags(a)<0 Then planets(slot).flags(a)+=1
        If planets(slot).flags(a)>0 Then planets(slot).flags(a)-=1
        If planets(slot).flags(a)<-3 Then planets(slot).flags(a)=-3
        If planets(slot).flags(a)>3 Then planets(slot).flags(a)=3
        If planets(slot).flags(a)>0 Then planets(slot).flags(a)-=1
        If planets(slot).flags(a)<0 Then planets(slot).flags(a)+=1
    Next

    If rnd_range(1,100)<33 Then flag(14)=rnd_range(8,20)
    If rnd_range(1,100)<33 Then planets(slot).flags(15)=1
    If rnd_range(1,100)<33 Then planets(slot).flags(16)=2
    If rnd_range(1,100)<33 Then planets(slot).flags(17)=3
    If rnd_range(1,100)<33 Then planets(slot).flags(18)=4
    If rnd_range(1,100)<33 Then planets(slot).flags(19)=5
    If rnd_range(1,100)<33 Then planets(slot).flags(20)=11


    If awayteam.c.x<0 Then awayteam.c.x=0
    If awayteam.c.y<0 Then awayteam.c.y=0
    If awayteam.c.x>60 Then awayteam.c.x=60
    If awayteam.c.y>20 Then awayteam.c.y=20

    '
    ' EXPLORE PLANET
    '

    dawn=rnd_range(1,60)
    
    DbgLogExplorePlanet("Tile effects")
    For a=0 To 5
       ep_tileeffects(areaeffect(),last_ae,lavapoint(),nightday(),localtemp(),cloudmap())
    Next
    
    DbgPrint("moving enemies")
    Do
        b=0
        For a=1 To lastenemy
            If enemy(a).c.x=awayteam.c.x And enemy(a).c.y=enemy(a).c.y Then
                enemy(a).c=movepoint(enemy(a).c,5)
                b=1
            EndIf
        Next
    Loop Until b=0

    DbgPrint("Death in:" &planets(slot).death &"(in)")    
    rlprint planets_flavortext(slot),15        
    If no_enemys=1 Then lastenemy=0
    DbgPrint("Setting screen")

    If savefrom(0).map=0 Then
        nextmap=ep_planetmenu(awayteam.c,slot,shipfire(),spawnmask(),lsp,localtemp(awayteam.c.x,awayteam.c.y))
        If nextmap.m=-1 Then Return nextmap
    EndIf
	savefrom(0)=savefrom(16)
    
    osx=calcosx(awayteam.c.x,planets(slot).depth)
    
    DbgLogExplorePlanet("Displaystuff")
    tScreen.set(0)
    set__color(11,0)
    Cls
    display_planetmap(slot,osx,0)
    ep_display ()
    display_awayteam()
    tScreen.update()
    set__color(11,0)
    Cls
    display_planetmap(slot,osx,0)
    ep_display ()
    display_awayteam()
    tScreen.update()
    
    
    If planets_flavortext(slot)<>"" Then
        no_key=keyin
    EndIf
    
    '***********************
    '
    'Planet Exploration Loop
    '
    '***********************
    Do
        DbgLogExplorePlanet("1")
        If show_all=1 Then
            set__color( 15,0)
            Locate 21,1
            Print awayteam.disease;":";player.disease;":";planets(slot).visited;":";slot;"Temp:";localtemp(awayteam.c.x,awayteam.c.y)
        EndIf
        'rlprint "Death"&planets(slot).death
        awayteam.dark=planets(slot).darkness+nightday(awayteam.c.x)
        If artflag(9)=1 And  player.teleportload<15 Then player.teleportload+=1
        If awayteam.disease>player.disease Then player.disease=awayteam.disease
        If planets(slot).atmos<=1 Or planets(slot).atmos>=7 Then awayteam.helmet=1
        If (tmap(awayteam.c.x,awayteam.c.y).no=1 Or tmap(awayteam.c.x,awayteam.c.y).no=26 Or tmap(awayteam.c.x,awayteam.c.y).no=20) And awayteam.hp<=awayteam.nohp*5 Then awayteam.oxygen=awayteam.oxygen+tmap(awayteam.c.x,awayteam.c.y).oxyuse
        If tmap(awayteam.c.x,awayteam.c.y).oxyuse<0 Then awayteam.oxygen=awayteam.oxygen-tmap(awayteam.c.x,awayteam.c.y).oxyuse
        If awayteam.oxygen>awayteam.oxymax Then awayteam.oxygen=awayteam.oxymax

        adislastenemy=lastenemy
        adisloctemp=localtemp(awayteam.c.x,awayteam.c.y)
        adisloctime=nightday(awayteam.c.x)

        If configflag(con_warnings)=0 And nightday(awayteam.c.x)=1 And nightday(old.x)<>1 Then rlprint "The sun rises"
        If configflag(con_warnings)=0 And nightday(awayteam.c.x)=2 And nightday(old.x)<>2 Then rlprint "The sun sets"
        DbgLogExplorePlanet("Update masks")
        lsp=ep_updatemasks(spawnmask(),mapmask(),nightday(),dawn,dawn2)
        mapmask(awayteam.c.x,awayteam.c.y)=-9
        
        com_sinkheat(player,0)
            
        localturn=localturn+1

        If localturn Mod 10=0 Then
            If planets(slot).depth=0 Then
                tVersion.gameturn+=2
            Else
                tVersion.gameturn+=1
            EndIf
            
            DbgLogExplorePlanet("2")
            ep_tileeffects(areaeffect(),last_ae,lavapoint(),nightday(),localtemp(),cloudmap())
            ep_lava(lavapoint())
            lastenemy=ep_spawning(spawnmask(),lsp,diesize,nightday())
            ep_shipfire(shipfire())
            ep_items(localturn)
            tScreen.set(0)
            set__color(11,0)
            Cls
            display_planetmap(slot,osx,0)
            ep_display ()
            display_awayteam()
            ep_display_clouds(cloudmap())
            walking=alerts()
            rlprint("")
            tScreen.update()
        EndIf
        
        
        DbgLogExplorePlanet("3 ae" & awayteam.e.e)
        deadcounter=ep_monstermove(spawnmask(),lsp,mapmask(),nightday())

        If player.dead>0 Or awayteam.hp<=0 Then allowed=""

        If ship_landing>0 And nextmap.m<>0 Then ship_landing=1 'Lands immediately if you changed maps
        If ship_landing>0 Then ep_landship(ship_landing, nextlanding, nextmap)

        
        DbgLogExplorePlanet("4 ae" & awayteam.e.e)
        
        If  tmap(awayteam.c.x,awayteam.c.y).resources>0 Or planetmap(awayteam.c.x,awayteam.c.y,slot)=17 Or  (tmap(awayteam.c.x,awayteam.c.y).no>2 And tmap(awayteam.c.x,awayteam.c.y).gives>0 And player.dead=0 And (awayteam.c.x<>old.x Or awayteam.c.y<>old.y))  Then
            old=awayteam.c
            osx=calcosx(awayteam.c.x,planets(slot).depth)
            tScreen.set(0)
            set__color(11,0)
            Cls
            display_planetmap(slot,osx,0)
            ep_display ()
            ep_display_clouds(cloudmap())
            display_awayteam()
            rlprint ("")
            ep_gives(awayteam,nextmap,shipfire(),spawnmask(),lsp,Key,localtemp(awayteam.c.x,awayteam.c.y))
            equip_awayteam(slot)
            If awayteam.movetype=2 Or awayteam.movetype=3 Then allowed=allowed &key_ju
            If awayteam.movetype=4 Then allowed=allowed &key_te
            tScreen.update()
            set__color(11,0)
            Cls
            display_planetmap(slot,osx,0)
            ep_display ()
            display_awayteam()
            ep_display_clouds(cloudmap())

            rlprint("")
            walking=0
        EndIf

        DbgLogExplorePlanet("5  ae" & awayteam.e.e & nextmap.m)
        If (player.dead=0 And awayteam.e.tick=-1) Then
            
            tScreen.set(0)
            set__color(11,0)
            Cls
            display_planetmap(slot,osx,0)
            ep_display ()
            display_awayteam()
            ep_display_clouds(cloudmap())
            rlprint("")
            tScreen.update()
            
            tScreen.set(0)
            set__color(11,0)
            Cls
            display_planetmap(slot,osx,0)
            ep_display ()
            display_awayteam()
            ep_display_clouds(cloudmap())
            rlprint("")
            tScreen.update()
            
            If nextmap.m=0 Then Key=(keyin(allowed,walking))
            DbgLogExplorePlanet("&" & key)
            If Key="" Then
                tScreen.set(0)
                Cls
                display_planetmap(slot,osx,0)
                ep_display ()
                display_awayteam()
                ep_display_clouds(cloudmap())
                rlprint("")
                tScreen.update()
            EndIf
            awayteam.oxygen=awayteam.oxygen-maximum(awayteam.oxydep*awayteam.helmet,tmap(awayteam.c.x,awayteam.c.y).oxyuse)-awayteam.leak*awayteam.helmet
            If awayteam.oxygen<=0 and (awayteam.helmet=1 or tmap(awayteam.c.x,awayteam.c.y).oxyuse>0) Then 
                rlprint "Asphyixaction:"&dam_awayteam(rnd_range(1,awayteam.hp),1),12
                awayteam.oxygen=0
                if awayteam.hp<0 then player.dead=14
            endif
            
            DbgLogExplorePlanet("&heal")
            
            heal_awayteam(awayteam,0)

            old=awayteam.c
            If walking<>0 Then
                If walking<0 Then
                    tmap(awayteam.c.x,awayteam.c.y).hp-=1
                    awayteam.add_move_cost
                    For a=1 To _lines
                        If displaytext(a)="" Then 
                            displaytext(a-1)&="."
                            Exit For
                        EndIf
                    Next
                    If tmap(awayteam.c.x,awayteam.c.y).hp=1 Then
                        walking=0
                        rlprint "Complete."
                        Key=key_inspect
                    EndIf
                    rlprint ""
                Else
                    If walking<10 Then
                        awayteam.c=movepoint(awayteam.c,walking)
                    EndIf
                    If walking=12 Then
                        If currapwp=lastapwp Then
                            'awayteam.c=movepoint(awayteam.c,nearest(apwaypoints(currapwp),awayteam.c))
                            lastapwp=ep_autoexplore(slot)
                            currapwp=0
                        EndIf
                        If lastapwp>0 Then
                            currapwp+=1
                            'awayteam.c=movepoint(awayteam.c,nearest(apwaypoints(currapwp),awayteam.c))
                            If awayteam.movetype>=tmap(apwaypoints(currapwp).x,apwaypoints(currapwp).y).walktru Or tmap(apwaypoints(currapwp).x,apwaypoints(currapwp).y).onopen<>0 Then
                                awayteam.c=apwaypoints(currapwp)
                                awayteam.c.m=old.m
                            Else
                                walking=0
                            EndIf
                        Else
                            walking=0
                        EndIf

                    EndIf
                EndIf
            Else
                If rnd_range(1,100)<110+countdeadofficers(awayteam.hpmax) Then
                    awayteam.c=movepoint(awayteam.c,uConsole.getdirection(Key),3)
                    If uConsole.getdirection(Key)<>0 Then
                        Key=""
                    EndIf
                Else
                    rlprint "Your security personel want to return to the ship.",14
                    If rnd_range(1,100)<66 Then
                        awayteam.c=movepoint(awayteam.c,nearest(player.landed,awayteam.c))

                    Else
                        awayteam.c=movepoint(awayteam.c,5)
                    EndIf
                EndIf
            EndIf
            
            DbgLogExplorePlanet("hitmonster")
            ep_playerhitmonster(old,mapmask())
            DbgLogExplorePlanet("checkmove")
            ep_checkmove(old,Key)
            If old.x<>awayteam.c.x Or old.y<>awayteam.c.y Or Key=key_portal Or Key=key_inspect Then nextmap=ep_Portal()
            DbgLogExplorePlanet("nextmap"&nextmap.m)
            
            ep_planeteffect(shipfire(),sf,lavapoint(),localturn,cloudmap())
            DbgLogExplorePlanet("PE")
            ep_areaeffects(areaeffect(),last_ae,lavapoint(),cloudmap())
            DbgLogExplorePlanet("AE")
            If old.x<>awayteam.c.x Or old.y<>awayteam.c.y Or Key=key_pickup Then ep_pickupitem(Key)
            DbgLogExplorePlanet("PU")
            If Key=key_inspect Or _autoinspect=0 And (old.x<>awayteam.c.x Or old.y<>awayteam.c.y) Then ep_inspect(localturn)
            DbgLogExplorePlanet("in")
            If vacuum(awayteam.c.x,awayteam.c.y)=1 And awayteam.helmet=0 Then ep_helmet()
            If vacuum(awayteam.c.x,awayteam.c.y)=0 And vacuum(old.x,old.y)=1 And awayteam.helmet=1 Then ep_helmet
        'Display all stuff
            tScreen.set(0)
            set__color(11,0)
            Cls

            osx=calcosx(awayteam.c.x,planets(slot).depth)
            display_planetmap(slot,osx,0)
            ep_display ()
            ep_display_clouds(cloudmap())
            display_awayteam()
            
            ep_atship()

            comstr.t=key_ex &" examine;" &key_fi &" fire,"&key_autofire &" autofire;" &key_autoexplore &" autoexplore;"
            comstr.t=comstr.t & key_gr &" grenade;" &key_oxy &" open/close helmet;" &key_close &" close door;" &key_drop &" Drop;"
            comstr.t=comstr.t & key_he &" use medpack;" &key_report &" bioreport;"&key_ra &" radio;"
            If awayteam.movetype=2 Or awayteam.movetype=3 Then comstr.t=comstr.t &key_ju &" Jetpackjump;"
            If artflag(9)=1 Then comstr.t=comstr.t &key_te &" Teleport;"

            set__color( 11,0)
            For x=0 To 60
                If x-osx>=0 And x-osx<=_mwx And nightday(x)=1 Then draw_string((x-osx)*_fw1,21*_fh1+(_fh1-_fh2)/2-_fh2/2,Chr(193),Font2,_tcol)
                If x-osx>=0 And x-osx<=_mwx And nightday(x)=2 Then draw_string((x-osx)*_fw1,21*_fh1+(_fh1-_fh2)/2-_fh1/2,Chr(193),Font2,_tcol)
            Next
            rlprint ""
            tScreen.update()
            DbgLogExplorePlanet("drew everything again and flipped")
            'tScreen.set(1)

            If rnd_range(1,100)<disease(awayteam.disease).nac Then
                Key=""
                rlprint "ZZZZZZZZZZZzzzzzzzz",14
                awayteam.e.add_action(50)
            EndIf
            
            If Key<>"" And walking>0 Then walking=0
            
            If rnd_range(1,100)<tmap(awayteam.c.x,awayteam.c.y).disease*2-awayteam.helmet*3 Then infect(rnd_range(1,awayteam.hpmax),tmap(awayteam.c.x,awayteam.c.y).disease)

            If Key=key_ex  Then ep_examine()

            If Key=key_save Then
                If askyn("Do you really want to save the game (y/n?)") Then
                   savefrom(0).map=slot
                   savefrom(0).ship=player.landed
                   savefrom(0).awayteam=awayteam
                   savefrom(0).lastenemy=lastenemy
                   For a=1 To lastenemy
                       savefrom(0).enemy(a)=enemy(a)
                   Next
                   player.dead=savegame()
                   'ship.x=-1
                EndIf
            EndIf

            If Key=key_wait Then awayteam.add_move_cost

            If Key=key_drop Then ep_dropitem()
            
            If Key=key_awayteam Then
                If awayteam.c.x=player.landed.x And awayteam.c.y=player.landed.y And slot=player.landed.m Then
                    showteam(0)
                Else
                    showteam(1)
                EndIf
            EndIf

            If Key=key_report Then bioreport(slot)

            If Key=key_close Then ep_closedoor()

            If Key=key_gr Then ep_grenade(shipfire(),sf)

            If Key=key_fi Or Key=key_autofire Or walking=10 Then ep_fire(mapmask(),Key,autofire_target)

            If Key=key_ra Then ep_radio(nextlanding,ship_landing,shipfire(),lavapoint(),sf,nightday(),localtemp())

            If Key=key_oxy Then ep_helmet()

            If Key=key_ju And awayteam.movetype>=2 Then ep_jumppackjump()

            If Key=key_la Then ep_launch(nextmap)

            If Key=key_he Then
                If awayteam.disease>0 Then
                    cure_awayteam(0)
                Else
                    If configflag(con_chosebest)=0 Then
                        c=findbest(11,-1)
                    Else
                        c=get_item(11)
                    EndIf
                    If c>0 Then
                        If item(c).ty<>11 Then
                            rlprint "you can't use that."
                        Else
                            If askyn("Do you want to use the "&item(c).desig &"(y/n)?") Then
                                item(c).v1=heal_awayteam(awayteam,item(c).v1)
                                If item(c).v1<=0 Then destroyitem(c)
                            EndIf
                        EndIf
                    Else
                        rlprint "you dont have any medpacks"
                    EndIf
                EndIf
            EndIf

            If Key=key_walk Or Key=key_autoexplore Then
                If Key<>key_autoexplore Then
                    rlprint "Direction? (0 for autoexplore)"
                    no_key=keyin
                    walking=uConsole.getdirection(no_key)
                Else
                    no_key="0"
                EndIf
                If no_key="0" Then
                    lastapwp=ep_autoexplore(slot)
                    currapwp=0
                    If lastapwp>-1 Then
                        walking=12
                    Else
                        rlprint "All explored here."
                    EndIf
                EndIf
            EndIf

            If Key=key_co Or Key=key_of Then ep_communicateoffer(Key)

            If Key=key_te And artflag(9)=1 Then awayteam.c=teleport(awayteam.c,slot)

        Else
            If player.dead<>0 Then allowed=""
        EndIf

        If lastenemy>255 Then lastenemy=255

        'clean up item list
        For a=1 To itemindex.vlast
            If item(itemindex.value(a)).w.s<0 Then
                itemindex.remove(itemindex.value(a),item(itemindex.value(a)).w)
            Else
                If tmap(item(itemindex.value(a)).w.x,item(itemindex.value(a)).w.y).no>=175 And tmap(item(itemindex.value(a)).w.x,item(itemindex.value(a)).w.y).no<=177 Then
                    destroyitem(itemindex.value(a))
                    itemindex.remove(itemindex.value(a),item(itemindex.value(a)).w)
                EndIf
            EndIf
        Next
        DbgPrint("Death in:"&planets(slot).death)
        ' and the world moves on
        update_world(0)
                
        DbgLogExplorePlanet("end loop" & nextmap.m)
    Loop Until awayteam.hp<=0 Or nextmap.m<>0 Or player.dead<>0
    
    DbgLogExplorePlanet("1" & nextmap.m)
    '
    ' END exploring

    location=lc_onship
    For a=1 To itemindex.vlast
        If item(itemindex.value(a)).ty=45 And item(itemindex.value(a)).w.p<9999 And item(itemindex.value(a)).w.s=0 Then 'Alien bomb
            If item(itemindex.value(a)).v2=1 Then
                p1.x=item(itemindex.value(a)).w.x
                p1.y=item(itemindex.value(a)).w.y
                item(itemindex.value(a)).w.p=9999
                alienbomb(itemindex.value(a),slot)

            EndIf
        EndIf
    Next

    For a=0 To lastitem
        If item(a).w.p=9999 Then
            item(a)=item(lastitem)
            lastitem=lastitem-1
        EndIf
    Next

    b=0
    For a=1 To lastenemy
        If enemy(a).hp>0 Then b=b+1
    Next
    If b=0 Then planets(slot).genozide=1

    If awayteam.hp<=0 Then
        reward(2)=0
        reward(1)=0
        If player.dead=0 Then player.dead=3

        For a=1 To lastdrifting
            If slot=drifting(a).m Then player.dead=25
        Next
        player.landed.s=planets(slot).depth
        If player.dead=25 Then player.landed.s=slot
        display_awayteam()
        rlprint "The awayteam has been destroyed.",12
        If slot=specialplanet(0) Then player.dead=8
        If slot=specialplanet(1) Then player.dead=9
        If slot=specialplanet(3) Or slot=specialplanet(4) Then player.dead=10
        If slot=specialplanet(5) Then player.dead=11
        no_key=keyin
    EndIf

    If player.dead<>0 Then
        old=player.c
        player.c=awayteam.c
        save_bones(1)
        player.c=old'On planet
    EndIf

    If player.dead=0 And planets(slot).atmos>0 And planets(slot).depth=0 And planets(slot).atmos=player.questflag(10) Then
        a=0
        For x=0 To 60
            For y=0 To 20
                a=a+tmap(x,y).vege
                If planetmap(x,y,slot)>0 Then b+=1
            Next
        Next
        If a=0 Then
            rlprint "This planet would suit Omega Bioengineerings Requirements."
            player.questflag(10)=-slot
        EndIf
    EndIf

    If planets(slot).depth=0 And planets(slot).flags(21)=0 Then
        a=0
        For x=0 To 60
            For y=0 To 20
                If planetmap(x,y,slot)>0 Then a+=1
            Next
        Next
        If a>=1199 Then
            planets(slot).flags(21)=1
            rlprint "You have completely mapped this planet.",10
        EndIf
    EndIf

    If specialplanet(10)=slot Then
        For x=0 To 60
            For y=0 To 20
                If planetmap(x,y,slot)=-60 Then planetmap(x,y,slot)=-4
                If planetmap(x,y,slot)=60 Then planetmap(x,y,slot)=4
            Next
        Next
    EndIf

    If specialplanet(17)=slot Then
        a=1
        For x=0 To 60
            For y=0 To 20
                If Abs(planetmap(x,y,slot))=107 Then a=0
            Next
        Next
        specialflag(17)=a
    EndIf

    If slot=piratebase(0) And planets(slot).genozide=1 Then
        rlprint "Congratulations! You have destroyed the pirates base!",10
        reward(6)=50000
        piratebase(0)=-1
        no_key=keyin
    EndIf
    If slot=piratebase(0) And awayteam.hp<=0 Then player.dead=7
    c=0
    For a=1 To _NoPB 'Did main base earlier
        If slot=piratebase(a) Then
            For b=1 To lastenemy
                If enemy(b).hp>0 Then
                    If enemy(b).made=7 Or enemy(b).made=3 Then c=c+1
                EndIf
            Next
            If c=0 And awayteam.hp>0 Then
                reward(8)=reward(8)+10000
                piratebase(a)=-1
            EndIf
        EndIf
    Next

    b=0
    For a=1 To 15
        If slot=savefrom(a).map Then b=a
    Next
    If b=0 Then
        For a=15 To 1 Step -1
            If savefrom(a).map=0 Then b=a
        Next
    EndIf
    If b=0 Then
        For a=1 To 14
            savefrom(a)=savefrom(a+1)
        Next
        savefrom(15)=savefrom(16) '16 bleibt immer leer
        b=15
    EndIf
    a=b
    If lastenemy>129 Then lastenemy=129
    savefrom(a).lastenemy=lastenemy
    savefrom(a).map=slot
    For b=1 To lastenemy
        savefrom(a).enemy(b)=enemy(b)
    Next
    For x=0 To 60
        For y=0 To 20
            tmap(x,y)=tiles(0)
        Next
    Next

    'if slot=specialplanet(12) and player.dead<>0 then player.dead=17
    If player.dead<>0 Then screenshot(3)
    
    DbgLogExplorePlanet("exit" & nextmap.m)
    Return nextmap
End function


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tExplore -=-=-=-=-=-=-=-
	tModule.register("tExplore",@tExplore.init()) ',@tExplore.load(),@tExplore.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tExplore -=-=-=-=-=-=-=-
#endif'test
