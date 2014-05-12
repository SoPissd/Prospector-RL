'tLanding.
'
'defines:
'landing=32
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
'     -=-=-=-=-=-=-=- TEST: tLanding -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tLanding -=-=-=-=-=-=-=-

declare function landing(mapslot As Short,lx As Short=0,ly As Short=0,Test As Short=0) As Short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tLanding -=-=-=-=-=-=-=-

namespace tLanding
function init() as Integer
	return 0
end function
end namespace'tLanding


#define cut2top


function landing(mapslot As Short,lx As Short=0,ly As Short=0,Test As Short=0) As Short
    DimDebug(0)'510
    Dim As Short l,m,a,b,c,d,dis,alive,dead,roll,target,xx,yy,slot,sys,landingpad,landinggear,who(128),last2,alle
    Dim light As Single
    Dim p As _cords
    Dim As Short  last
    Dim nextmap As _cords
    Dim As _monster delaway
    Dim As String reason

    delaway.optoxy=awayteam.optoxy
    awayteam=delaway

    p.x=lx
    p.y=ly
    If lx=0 And ly=0 Then p=rnd_point(mapslot,0)
    sys=sysfrommap(mapslot)
    If savefrom(0).map=0 Then
        If mapslot=specialplanet(29) And findbest(89,-1)>0 Then mapslot=specialplanet(30)
        If mapslot=specialplanet(30) And findbest(89,-1)=-1 Then mapslot=specialplanet(29)
        If mapslot=specialplanet(29) Then specialflag(30)=1
        If configflag(con_warnings)=0 And player.hull=1 And planets(mapslot).depth=0 Then
            If Not askyn("Pilot: 'Are you sure captain? I can't guarantee I get this bucket up again'(Y/N)",14) Then Return 0
        EndIf
#if __FB_DEBUG__
        If debug=510 Then
            DbgPrint( sys &","&mapslot)
        EndIf
#endif

        If mapslot>0 Then
            set__color(11,0)
            Cls

            If planetmap(0,0,mapslot)=0 Then makeplanetmap(mapslot,slot,map(sys).spec)
            awayteam.hp=0
            For b=1 To 255
                If crew(b).hpmax>0 And crew(b).hp>0 And crew(b).onship=0 And crew(b).disease=0 Then
                    awayteam.hp+=1
                    crew(b).hp=crew(b).hpmax
                EndIf
            Next
            'awayteam.hpmax=awayteam.hp
            If player.dead=0 Then
                While tiles(Abs(planetmap(p.x,p.y,mapslot))).locked<>0 Or _
                    tiles(Abs(planetmap(p.x,p.y,mapslot))).gives<>0 Or _
                    tiles(Abs(planetmap(p.x,p.y,mapslot))).walktru<>0 Or _
                    Abs(planetmap(p.x,p.y,mapslot))=45 Or _
                    Abs(planetmap(p.x,p.y,mapslot))=80
                    If lx=0 And ly=0 Then
                        p=rnd_point(mapslot,0)
                    Else
                        p=movepoint(p,5,,4)'4=Rollover
                    EndIf
                Wend

                'if ((mapslot=pirateplanet(0) or mapslot=pirateplanet(1) or mapslot=pirateplanet(2)) and player.pirate_agr<=0) or isgasgiant(mapslot)<>0 then
                    For x=0 To 60
                        For y=0 To 20
                            If planetmap(x,y,mapslot)=68 And last<128 Then
                                last+=1
                                pwa(last).x=x
                                pwa(last).y=y
                            EndIf
                        Next
                    Next
                    If last>0 Then
                        If askyn("Shall we use the landingpad to land?(y/n)") Then
                            p=pwa(rnd_range(1,last))
                            landingpad=5
                        EndIf
                    EndIf
                'endif
                player.landed.x=p.x
                player.landed.y=p.y
                player.landed.m=mapslot
                nextmap=player.landed
                equip_awayteam(mapslot)
            EndIf

            last2=no_spacesuit(who(),alle)
            If last2>0 And ep_needs_Spacesuit(mapslot,player.landed,reason)<>0 Then
                If alle=0 Then
                    If askyn("You will need spacesuits ("& reason &"). Do you want to leave "&last2 &" crewmembers who have none on the ship? (Y/N)") Then
                        remove_no_spacesuit(who(),last2)
                    EndIf
                Else
                    If askyn("You need spacesuits on this planet  ("& reason &") and don't have any. Shall we abort landing? (y/n)") Then Return 0
                    awayteam.oxygen=0
                    awayteam.oxymax=0
                EndIf
            EndIf
                        
            If findbest(10,-1)>-1 And is_drifter(m)=0 Then
                awayteam.stuff(8)=item(findbest(10,-1)).v1 'Sattelite
                rlprint "You deploy your satellite."
            EndIf
            
            roll=landingpad+player.pilot(0)+add_talent(2,8,1)
            landinggear=findbest(41,-1)
            If landinggear>0 And landingpad=0 Then roll=roll+item(landinggear).v1
            target=planets(mapslot).dens+2*planets(mapslot).grav^2
            If mapslot<>specialplanet(2) And Test=0 Then
                If skill_test(roll,target,"Pilot") Then
                    If landingpad=0 Then
                        rlprint ("Your pilot succesfully landed in the difficult terrain",10)
                    Else
                        rlprint ("You landed on the landinpad",10)
                    EndIf
                    player.fuel=player.fuel-1
                    rlprint gainxp(2),c_gre
                Else
                    If landingpad=0 Then
                        rlprint ("your pilot damaged the ship trying to land in difficult terrain.",12)
                    Else
                        rlprint ("your pilot actually manged to damage the ship while landing on a landing pad!",12)
                    EndIf
                    player.hull=player.hull-1
                    player.fuel=player.fuel-2-Int(planets(mapslot).grav)
                    If player.hull<=0 Then
                        rlprint ("A Crash landing. you will never be able to start with that thing again",12)
                        If skill_test(player.pilot(0),st_veryhard,"Pilot") Then
                            rlprint ("but your pilot wants to try anyway and succeeds!",12)
                            player.hull=1
                        Else
                            player.dead=4
                        EndIf
                        no_key=keyin
                    EndIf
                EndIf
            EndIf
        EndIf
        If isgardenworld(nextmap.m) Then changemoral(3,0)
        awayteam.oxygen=awayteam.oxymax
        awayteam.jpfuel=awayteam.jpfuelmax

        Else
            awayteam=savefrom(0).awayteam
            nextmap=savefrom(0).ship
            nextmap.m=savefrom(0).map
        EndIf
        
        If mapslot>0 Then play_sound(11)
        
        If player.dead=0 And awayteam.hp>0 Then
            
            Do
'                if _debug=2704 then print #freefile,"outerloop1"
                savegame
'                if _debug=2704 then print #freefile,"outerloop2"
                equip_awayteam(slot)
'                if _debug=2704 then print #freefile,"outerloop3"
                nextmap=explore_planet(nextmap,slot)
'                if _debug=2704 then print #freefile,"outerloop4"
                set__color(11,0)
                removeequip
'                if _debug=2704 then print #freefile,"outerloop5"
                c=1
                For b=2 To 255
                    If crew(b).hp<=0 Then
                        crew(b)=crew(0)
                    Else
                        c+=1
                    EndIf
                Next
                If c>127 Then c=127

                For b=2 To c-1
                    If crew(b).hpmax=0 Then
                        Swap crew(b),crew(b+1)
                    EndIf
                Next
                
'                if _debug=2704 then print #freefile,"outerloop6:"&nextmap.m
            Loop Until nextmap.m=-1 Or player.dead<>0

            For c=0 To 127
                For b=6 To 127
                    If crew(b).hp<=0 Then Swap crew(b),crew(b+1)
                Next
            Next
            For b=0 To 127
                If crew(b).onship=4 Then
                    crew(b).onship=crew(b).oldonship
                EndIf
            Next
            removeequip
            'artifacts?
            If reward(5)>0 Then
                If reward(5)=1 Then
                    player.fuelmax=200
                EndIf
                If reward(5)=2 Then
                    player.stuff(1)=3
                EndIf
                If reward(5)=3 Then
                    slot=get_random_system()
                    If slot<0 Then slot=rnd_range(0,laststar)
                    map(slot).discovered=1
                    For b=1 To 9
                        If map(slot).planets(b)>0 Then
                        If planetmap(0,0,map(slot).planets(b))=0 Then makeplanetmap(map(slot).planets(b),b,map(sys).spec)
                        reward(0)=reward(0)+1200
                        reward(7)=reward(7)+600
                        For xx=0 To 60
                            For yy=0 To 20
                                If planetmap(xx,yy,map(slot).planets(b))<0 Then planetmap(xx,yy,map(slot).planets(b))=planetmap(xx,yy,map(slot).planets(b))*-1
                            Next
                        Next
                        EndIf
                    Next
                    rlprint "the data from the computer describes a system with the coordinates "& map(slot).c.x &":" & map(slot).c.y
                EndIf
                If reward(5)=4 Then
                    player.stuff(2)=3
                EndIf
                If reward(5)=5 Then
                    player.stuff(0)=3
                EndIf
                reward(5)=0

            EndIf
        EndIf
        c=6
        dis=0
        If crew(1).hp<=0 And player.dead=0 Then
            crew(1).hp=crew(1).hpmax
            b=rnd_range(1,3)
            If b=1 Then rlprint "Captain "&crew(1).n &" was just unconcious.",10
            If b=2 Then rlprint "Captain "&crew(1).n &" got better.",10
            If b=3 Then rlprint "Captain "&crew(1).n &" miracoulously recovered.",10
        EndIf
        For b=1 To 128
            If crew(b).hp<crew(b).hpmax And crew(b).hp>0 And crew(b).disease=0 Then crew(b).hp=crew(b).hpmax
        Next
        For b=6 To 128
            If crew(b).hp<=0 Then
                crew(b)=crew(0)
            Else
                If crew(b).disease>dis Then dis=crew(b).disease
                c+=1
            EndIf
        Next
        awayteam.disease=dis
        d=0
        Do
            d+=1
            a=0
            For b=6 To c-1
                If crew(b).hpmax=0 And crew(b+1).hpmax>0 Then
                    Swap crew(b),crew(b+1)
                    a=1
                EndIf
            Next
        Loop Until a=0 Or d>=1000
        For b=0 To lastitem
            If item(b).w.s<0 Then
                item(b).w.s=-1
                item(b).w.m=0
                item(b).w.p=0
            EndIf
        Next
        player.landed.m=0
        display_stars(1)
        display_ship
        If awayteam.stuff(8)=1 And player.dead=0 And Test=0 And planets(slot).depth=0 Then
            If skill_test(player.pilot(0)+player.tractor,st_easy,"Pilot:") Then
                rlprint "You rendevouz with your satellite and take it back in",10
            Else
                rlprint "When trying to rendevouz with your satellite your pilot rams and destroys it.",12
                item(findbest(10,-1))=item(lastitem)
                lastitem=lastitem-1
                no_key=keyin
            EndIf
        Else
            rlprint ""
        EndIf
    Return 0
End function


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tLanding -=-=-=-=-=-=-=-
	tModule.register("tLanding",@tLanding.init()) ',@tLanding.load(),@tLanding.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tLanding -=-=-=-=-=-=-=-
#endif'test
