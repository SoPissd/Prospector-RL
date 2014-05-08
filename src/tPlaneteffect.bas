'tPlaneteffect

Function ep_crater(shipfire() As _shipfire, ByRef sf As Single) As Short
    Dim As Short b,r,x,y,c
    Dim As _cords p2,p1
    Dim m(60,20) As Short
    b=rnd_range(1,15)-countgasgiants(sysfrommap(player.landed.m))+countasteroidfields(sysfrommap(player.landed.m))
    b=b-planets(player.landed.m).atmos
    If b>0 Then
        c=0
        rlprint "A meteorite streaks across the sky and slams into the planets surface!",14
        Do
            c+=1
            r=5
            If rnd_range(1,100)<66 Then r=3
            If rnd_range(1,100)<66 Then r=2

            p2.x=player.landed.x
            p2.y=player.landed.y
            p1=rnd_point

            For x=0 To 60
                For y=0 To 20
                    m(x,y)=0
                    If tmap(x,y).walktru>0 Then m(x,y)=1
                    p2.x=x
                    p2.y=y
                    If CInt(distance(p2,p1))=r+1 Then m(x,y)=0
                    If CInt(distance(p2,p1))=r Then m(x,y)=1
                Next
            Next
            flood_fill(player.landed.x,player.landed.y,m(),2)
        Loop Until m(awayteam.c.x,awayteam.c.y)=255 Or c>=25
        If c=25 Then Return 0

        For x=0 To 60
            For y=0 To 20
                p2.x=x
                p2.y=y
                If CInt(distance(p2,p1))=r+1 Then
                    If planetmap(p2.x,p2.y,player.landed.m)<0 Then planetmap(p2.x,p2.y,player.landed.m)=-4
                    If planetmap(p2.x,p2.y,player.landed.m)>0 Then planetmap(p2.x,p2.y,player.landed.m)=4
                    tmap(p2.x,p2.y)=tiles(4)
                EndIf
                If CInt(distance(p2,p1))=r Then
                    If planetmap(p2.x,p2.y,player.landed.m)<0 Then planetmap(p2.x,p2.y,player.landed.m)=-8
                    If planetmap(p2.x,p2.y,player.landed.m)>0 Then planetmap(p2.x,p2.y,player.landed.m)=8
                    tmap(p2.x,p2.y)=tiles(8)
                EndIf
            Next
        Next

        sf=sf+1
        If sf>15 Then sf=0
        shipfire(sf).when=1
        shipfire(sf).what=10+sf
        shipfire(sf).where=p1
        player.weapons(shipfire(sf).what)=make_weapon(6)
        player.weapons(shipfire(sf).what).ammomax=1 'Sets set__color( to redish
        player.weapons(shipfire(sf).what).dam=r 'Sets set__color( to redish
        If rnd_range(1,100)<33+r Then
            placeitem(make_item(96,-3,b\3),p1.x,p1.y,player.landed.m)
            itemindex.add(lastitem,item(lastitem).w)
            If rnd_range(1,100)<=2 Then
                planetmap(p1.x,p1.y,player.landed.m)=-191
                tmap(p1.x,p1.y)=tiles(191)
            EndIf
        EndIf
    Else
        rlprint "A meteor streaks across the sky"
    EndIf
    Return 0
End Function


Function ep_planeteffect(shipfire() As _shipfire, ByRef sf As Single,lavapoint() As _cords,localturn As Short,cloudmap() As Byte) As Short
    Dim As Short slot,a,b,r,x,y
    Dim As String text
    Static lastmet As Short
    Dim As _cords p1,p2
    slot=player.map
    lastmet=lastmet+1
    If planets(slot).death>0 Then 'Exploding planet
        If planets(slot).death=8 Then
            If planets(slot).flags(28)=0 Then
                If player.science(0)>0 And planets(slot).depth=0 Then rlprint "Science officer: I wouldn't recommend staying much longer.",15
            Else
                If player.pilot(0)>0 Then rlprint "Pilot: I am starting to worry. We are getting pretty deep into the gravity well of this planet."
            EndIf
            no_key=keyin
            planets(slot).death=planets(slot).death-1
        EndIf
        If planets(slot).death=4 And crew(4).hp>0 Then
            If planets(slot).flags(28)=0 Then
                If player.science(0)>0 And planets(slot).depth=0 Then rlprint "Science officer: We really should get back to the ship now!",14
            Else
                If player.pilot(0)>0 Then rlprint "Pilot: This thing is falling faster than I thought. Let's get out of here!",c_yel
            EndIf
            no_key=keyin
            planets(slot).death=planets(slot).death-1
        EndIf
        If planets(slot).death=2 And crew(4).hp>0 Then
            If planets(slot).flags(28)=0 Then
                If player.science(0)>0 And planets(slot).depth=0 Then rlprint "Science officer: This planet is about to fall apart! We must leave! NOW!",12
            Else
                If player.pilot(0)>0 Then rlprint "Pilot: We need to get of this icechunk! Now!",c_red
            EndIf
            no_key=keyin
            planets(slot).death=planets(slot).death-1
        EndIf
        If planets(slot).depth=0 And rnd_range(1,100)<33 Then
            sf+=1
            If sf>15 Then sf=0
            shipfire(sf).where=rnd_point
            shipfire(sf).when=1
            shipfire(sf).what=10+sf
            player.weapons(shipfire(sf).what)=make_weapon(rnd_range(1,5))
        EndIf

    EndIf


    If slot=specialplanet(8) And rnd_range(1,100)<33 Then
        set__color( 11,0)
        rlprint "lightning strikes you "& dam_awayteam(1),12
        player.killedby="lightning strike"
    EndIf



    If planets(slot).flags(25)=1 And awayteam.helmet=0 Then
        If skill_test(player.science(location),st_hard) And crew(5).hp>0 Then
            rlprint "Your science officer has figured out that the hallucinations are caused by pollen. You switch to spacesuit air supply."
            awayteam.helmet=1
            planets(slot).flags(25)=2
        Else
            If rnd_range(1,100)<60 Then
                a=rnd_range(1,4)
                If a=1 Then text="Your science officer remarks: "
                If a=2 Then text="Your pilot remarks: "
                If a=3 Then text="Your gunner says: "
                If a=4 Then text="Your doctor finds some "
                For a=0 To rnd_range(10,20)
                    text=text &Chr(rnd_range(33,200))
                Next
                rlprint text
            EndIf
        EndIf
    EndIf

    If slot=specialplanet(1) And rnd_range(1,100)<33 Then
        b=0
        For a=1 To lastenemy
            If enemy(a).made=5 And enemy(a).hp>0 And enemy(a).aggr=0 And pathblock(awayteam.c,enemy(a).c,slot) Then b=a
        Next
        If b>0 Then
            sf+=1
            If sf>15 Then sf=0
            shipfire(sf).when=1
            shipfire(sf).what=10+sf
            player.weapons(shipfire(sf).what)=make_weapon(6)
            player.weapons(shipfire(sf).what).dam=rnd_range(1,4)
            If rnd_range(1,6)+ rnd_range(1,6)+2>8 Then
                rlprint "Apollo calls down lightning and strikes you, infidel!"
                shipfire(sf).where=awayteam.c
            Else
                rlprint "Apollo calls down lightning .... and misses"
                shipfire(sf).where=movepoint(awayteam.c,5)
                shipfire(sf).where=movepoint(shipfire(sf).where,5)
                shipfire(sf).where=movepoint(shipfire(sf).where,5)
            EndIf
            While distance(shipfire(sf).where,enemy(b).c)<=CInt(player.weapons(shipfire(sf).what).dam/2)
                shipfire(sf).where=movepoint(shipfire(sf).where,5)
            Wend
        EndIf
    EndIf

    If isgardenworld(slot) And rnd_range(1,100)<5 Then
        a=rnd_range(1,awayteam.hpmax)
        If crew(a).hp>0 And crew(a).typ<9 Then
            b=rnd_range(1,6)
            If b=1 Then rlprint crew(a).n &" remarks: 'What a beautiful world this is!'"
            If b=2 Then rlprint crew(a).n &" points out a particularly beautiful part of the landscape"
            If b=3 Then rlprint crew(a).n &" says: 'I guess I'll settle down here when i retire!'"
            If b=4 Then rlprint crew(a).n &" asks: 'How about some extended R&R here?"
            If b=5 Then rlprint crew(a).n &" remarks: 'Wondefull'"
            If b=6 Then rlprint crew(a).n &" starts picking flowers."
        EndIf
    EndIf
    If sysfrommap(slot)>=0 Then
        If (planets(slot).dens<4 And planets(slot).depth=0 And rnd_range(1,100)<18-planets(slot).atmos-countgasgiants(sysfrommap(slot))+countasteroidfields(sysfrommap(slot))*2-map(sysfrommap(slot)).spec And rnd_range(1,100)<18-planets(slot).atmos-countgasgiants(sysfrommap(slot))) Or more_mets=1 Then
            If lastmet>1000 And countgasgiants(sysfrommap(slot))=0 And rnd_range(1,100)<countasteroidfields(sysfrommap(slot)) Then
                lastmet=-rnd_range(1,6) 'asteroid shower
                rlprint "Suddenly dozens of meteors illuminate the sky!",14
            EndIf
            If lastmet<0 Or (lastmet>1000 And rnd_range(1,100)<30) Or more_mets=1 Then
                ep_crater(shipfire(),sf)
                If lastmet<0 Then 
                    lastmet+=1
                Else
                    lastmet=0
                EndIf
            Else
                lastmet+=1
            EndIf
            If more_mets=1 Then rlprint ""&lastmet
            
        EndIf
    EndIf
    If cloudmap(awayteam.c.x,awayteam.c.y)>0 And planets(slot).atmos>6 And rnd_range(1,150)<(planets(slot).dens*planets(slot).weat) And slot<>specialplanet(28) Then
        If planets(slot).temp<300 Then
            rlprint "It's raining sulphuric acid! "&dam_awayteam(1),14
        Else
            rlprint "It's raining molten lead! "&dam_awayteam(1),14
        EndIf
        player.killedby=" hostile environment"
    EndIf

    If planets(slot).atmos>11 And rnd_range(1,100)<planets(slot).atmos*2 And frac(localturn/20)=0 Then
        a=getrnditem(-2,0)
        If a>0 Then
            If rnd_range(1,100)>item(a).res Then
                item(a).res=item(a).res-25
                If item(a).res>=0 Then
                    rlprint "Your "&item(a).desig &" starts to corrode.",14
                    if (item(a).ty=3 or item(a).ty=103) and item(a).ti_no<2019 then 
                        item(a).v4+=1
                        awayteam.leak+=1
                    endif
                Else
                    rlprint "Your "&item(a).desig &" corrodes and is no longer usable.",14
                    destroyitem(a)
                    equip_awayteam(slot)
                    'displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
                EndIf
            EndIf
        EndIf
        For a=1 To itemindex.vlast 'Corrosion need to go through all
            If item(itemindex.value(a)).ty<20 Then
                If item(itemindex.value(a)).w.s=0 And rnd_range(1,100)>item(itemindex.value(a)).res Then item(itemindex.value(a)).res-=25
                If item(itemindex.value(a)).res<=0 Then item(itemindex.value(a)).w.p=9999
                If item(itemindex.value(a)).ty=18 And item(itemindex.value(a)).w.p=9999 Then item(itemindex.value(a))=make_item(65) 'Rover debris
            EndIf
        Next
    EndIf

    If specialplanet(5)=slot Or specialplanet(8)=slot Then
        If awayteam.c.x<>player.landed.x Or awayteam.c.y<>player.landed.y Then
            If rnd_range(1,250)-(awayteam.movetype)<((planets(slot).atmos-3)*planets(slot).weat) And planets(slot).depth=0 Then
                'for a=1 to rnd_range(1,3)
                rlprint "High speed winds set you of course!",14
                awayteam.c=movepoint(awayteam.c,5)
                'next
            EndIf
        EndIf
    EndIf

    Return 0
End Function

