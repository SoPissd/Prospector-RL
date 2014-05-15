'tExploreplanet.
'
'defines:
'earthquake=2, ep_areaeffects=1, ep_display_clouds=7, ep_dropitem=1,
', ep_inspect=1, alienbomb=1, ep_items=1, ep_landship=1, ep_launch=1,
', ep_pickupitem=1, ep_portal=0, ep_tileeffects=2, ep_lava=1,
', ep_updatemasks=0, getmonster=0, ep_spawning=0, ep_shipfire=1,
', ep_helmet=3, grenade=20, ep_grenade=1, ep_playerhitmonster=1,
', ep_fire=2, ep_closedoor=1, mondis=0, ep_examine=1, ep_jumppackjump=1
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
'     -=-=-=-=-=-=-=- TEST: tExploreplanet -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
'Flag 28=techgoods delivered to star creatures
Type _ae
    c As _cords
    rad As Byte
    dam As Byte
    dur As Byte
    typ As Byte
End Type
#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tExploreplanet -=-=-=-=-=-=-=-

declare function earthquake(t as _tile,dam as short)as _tile
declare function ep_areaeffects(areaeffect() As _ae,ByRef last_ae As Short,lavapoint() As _cords,cloudmap() As Byte) As Short
declare function ep_display_clouds(cloudmap() As Byte) As Short
declare function ep_dropitem() As Short
declare function ep_inspect(ByRef localturn As Short) As Short
declare function alienbomb(c As Short,slot As Short) As Short
declare function ep_items(localturn As Short) As Short
declare function ep_landship(ByRef ship_landing As Short,nextlanding As _cords,nextmap As _cords) As Short
declare function ep_launch(ByRef nextmap As _cords) As Short
declare function ep_pickupitem(Key As String) As Short
declare function ep_tileeffects(areaeffect() As _ae, ByRef last_ae As Short,lavapoint() As _cords, nightday() As Byte, localtemp() As Single,cloudmap() As Byte) As Short
declare function ep_lava(lavapoint() As _cords) As Short
declare function ep_shipfire(shipfire() As _shipfire) As Short
declare function ep_helmet() As Short
declare function grenade(from As _cords,map As Short) As _cords
declare function ep_grenade(shipfire() As _shipfire, ByRef sf As Single) As Short
declare function ep_playerhitmonster(old As _cords, mapmask() As Byte) As Short
declare function ep_fire(mapmask() As Byte,Key As String,ByRef autofire_target As _cords) As Short
declare function ep_closedoor() As Short
declare function ep_examine() As Short
declare function ep_jumppackjump() As Short

'private function ep_portal() As _cords
'private function ep_updatemasks(spawnmask() As _cords,mapmask() As Byte,nightday() As Byte, ByRef dawn As Single, ByRef dawn2 As Single) As Short
'private function getmonster() as short
'private function ep_spawning(spawnmask() As _cords,lsp As Short, diesize As Short,nightday() As Byte) As Short
'private function mondis(enemy as _monster) as string

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tExploreplanet -=-=-=-=-=-=-=-

namespace tExploreplanet
function init(iAction as integer) as integer
	return 0
end function
end namespace'tExploreplanet


function earthquake(t as _tile,dam as short)as _tile
    dim roll as short
    if t.shootable=1 then
        t.hp=t.hp-dam
        if t.hp<=0 then t=tiles(t.turnsinto)
    endif
    if t.no<41 and t.no<>1 and t.no<>2 and t.no<>26 and t.no<>20 and t.no<>21 then
        if t.no=6 or t.no=5 then t=tiles(3)
        if t.no=7 or t.no=8 and rnd_range(1,100)<33+dam then t=tiles(4)
        if t.no=20 and rnd_range(1,100)<33+dam then t=tiles(rnd_range(1,2))
        if rnd_range(1,100)<15 and t.no<>18 then t=tiles(47)
    endif
    return t
end function


function ep_areaeffects(areaeffect() As _ae,ByRef last_ae As Short,lavapoint() As _cords,cloudmap() As Byte) As Short
    Dim As Short a,b,c,x,y,slot
    Dim As _cords p1
    slot=player.map
    If rnd_range(1,100)<planets(slot).grav+planets(slot).depth+planets(slot).temp\100 And planets(slot).grav>1 Then
        'Earthquake
        last_ae=last_ae+1
        If last_ae>16 Then last_ae=0
        areaeffect(last_ae).c=rnd_point
        areaeffect(last_ae).rad=rnd_range(1,planets(slot).grav*3)*rnd_range(1,planets(slot).grav)
        areaeffect(last_ae).dam=areaeffect(last_ae).rad
        If areaeffect(last_ae).rad>5 Then areaeffect(last_ae).rad=5
        areaeffect(last_ae).dur=rnd_range(1,4)+rnd_range(1,4)-planets(slot).grav
        areaeffect(last_ae).typ=1
    EndIf

    If rnd_range(1,100)<planets(slot).atmos/5+(planets(slot).water/10)+planets(slot).weat And planets(slot).atmos>3 And planets(slot).temp<0 And planets(slot).depth=0 Then
        'snow
        last_ae=last_ae+1
        If last_ae>16 Then last_ae=0
        areaeffect(last_ae).c=rnd_point
        areaeffect(last_ae).rad=rnd_range(1,4)*rnd_range(1,planets(slot).atmos)
        areaeffect(last_ae).dam=0
        areaeffect(last_ae).dur=rnd_range(1,4)+rnd_range(1,4)
        If areaeffect(last_ae).rad>5 Then
           areaeffect(last_ae).dur=areaeffect(last_ae).dur+areaeffect(last_ae).rad-5
           areaeffect(last_ae).rad=5
        EndIf
        areaeffect(last_ae).typ=2
    EndIf


    For a=0 To last_ae
        If areaeffect(a).typ=1 And areaeffect(a).dur>0 Then
            areaeffect(a).dur=areaeffect(a).dur-1
            If areaeffect(a).dur=0 Then rlprint "The ground rumbles",14'eartquake
            If areaeffect(a).dur=0 And findbest(16,-1)>0 And skill_test(player.science(1),st_average) Then rlprint "Originating at "&cords(areaeffect(a).c) &".",14
            For x=areaeffect(a).c.x-areaeffect(a).rad To areaeffect(a).c.x+areaeffect(a).rad
                For y=areaeffect(a).c.y-areaeffect(a).rad To areaeffect(a).c.y+areaeffect(a).rad
                    If x>=0 And y>=0 And x<=60 And y<=20 Then
                    p1.x=x
                    p1.y=y
                        If distance(p1,areaeffect(a).c)<areaeffect(a).rad Then
                            If show_eq=1 Then
                                Locate p1.y+1,p1.x+1
                                Print "."
                            EndIf
                            'Inside radius, inside map
                            If areaeffect(a).typ=1 Then 'eartquake
                                If areaeffect(a).dur>0 Then
                                    If x=awayteam.c.x And y=awayteam.c.y And skill_test(player.science(1),9) Then
                                        rlprint "A tremor",14
                                        If findbest(16,-1)>0 And skill_test(player.science(1),st_average) Then rlprint "Originating at "&areaeffect(a).c.x &":"&areaeffect(a).c.y,14
                                    EndIf
                                Else
                                    areaeffect(a).dam=areaeffect(a).dam-distance(p1,areaeffect(a).c)
                                    If areaeffect(a).dam=0 Then areaeffect(a).dam=0
                                    tmap(x,y)=earthquake(tmap(x,y),areaeffect(a).dam-distance(p1,areaeffect(a).c))
                                    If planetmap(x,y,slot)>0 Then planetmap(x,y,slot)=tmap(x,y).no
                                    If planetmap(x,y,slot)<0 Then planetmap(x,y,slot)=-tmap(x,y).no
                                    If rnd_range(1,100)<15-distance(p1,areaeffect(a).c) Then lavapoint(rnd_range(1,5))=p1
                                    If rnd_range(1,100)<3 Then
                                        b=placeitem(make_item(96,-3,-3),x,y,slot)
                                        itemindex.add(b,item(b).w)
                                    EndIf

                                    For b=1 To lastenemy
                                        If enemy(b).c.x=x And enemy(b).c.y=y Then enemy(b).hp=enemy(b).hp-areaeffect(a).dam+distance(p1,areaeffect(a).c)
                                    Next
                                    If x=awayteam.c.x And y=awayteam.c.y And areaeffect(a).dam>distance(p1,areaeffect(a).c) Then
                                        rlprint "An Earthquake! "& dam_awayteam(rnd_range(1,areaeffect(a).dam-distance(p1,areaeffect(a).c))),12
                                        player.killedby="Earthquake"
                                    EndIf
                                    areaeffect(a).dam=areaeffect(a).rad
                                EndIf

                            EndIf
                        EndIf
                    EndIf
                Next
            Next
        EndIf
        If areaeffect(a).typ=2 And areaeffect(a).dur>0 Then
            areaeffect(a).dur=areaeffect(a).dur-1
            For x=areaeffect(a).c.x-areaeffect(a).rad To areaeffect(a).c.x+areaeffect(a).rad
               For y=areaeffect(a).c.y-areaeffect(a).rad To areaeffect(a).c.y+areaeffect(a).rad
                   If x>=0 And y>=0 And x<=60 And y<=20 Then
                        p1.x=x
                        p1.y=y
                        If distance(p1,areaeffect(a).c)<= areaeffect(a).rad Then
                            If show_eq=1 Then
                                Locate p1.y+1,p1.x+1
                                set__color( 15,0)
                                Print "."
                            EndIf
                            If tmap(x,y).no=1 Or tmap(x,y).no=2 Then tmap(x,y).hp=tmap(x,y).hp+10
                            If tmap(x,y).no<>7 And tmap(x,y).no<>8 And tmap(x,y).no>2 And tmap(x,y).no<15 And rnd_range(1,100)<8+planets(slot).atmos Then
                                tmap(x,y)=tiles(145)
                                changetile(x,y,slot,145)
                            EndIf
                            If awayteam.c.x=x And awayteam.c.y=y Then rlprint "It is snowing."
                        EndIf
                   EndIf
               Next
            Next
        EndIf
        If areaeffect(a).typ=3 Or areaeffect(a).typ=4 Or areaeffect(a).typ=5 Then
            areaeffect(a).dur=areaeffect(a).dur-1
            For x=areaeffect(a).c.x-areaeffect(a).rad To areaeffect(a).c.x+areaeffect(a).rad
               For y=areaeffect(a).c.y-areaeffect(a).rad To areaeffect(a).c.y+areaeffect(a).rad
                   If x>=0 And y>=0 And x<=60 And y<=20 Then
                        p1.x=x
                        p1.y=y
                        If distance(p1,areaeffect(a).c)<= areaeffect(a).rad Then
                            If areaeffect(a).dur=0 Then
                                tmap(x,y)=tiles(0)
                                tmap(x,y)=tiles(Abs(planetmap(x,y,slot)))
                            Else
                                tmap(x,y).ti_no=385
                                tmap(x,y).tile=Asc("~")
                                tmap(x,y).seetru=1
                                tmap(x,y).desc="steam"
                                If planets(slot).atmos>1 Then cloudmap(x,y)+=1
                                If areaeffect(a).typ=3 Then tmap(x,y).col=15
                                If areaeffect(a).typ=4 Then
                                    tmap(x,y).col=104
                                    tmap(x,y).tohit=34
                                    tmap(x,y).dam=1
                                    tmap(x,y).hitt="Acidic steam!"
                                EndIf
                                If areaeffect(a).typ=4 Then
                                    tmap(x,y).col=179
                                    tmap(x,y).tohit=27
                                    tmap(x,y).dam=1
                                    tmap(x,y).hitt="Ammonium steam!"
                                EndIf
                                If areaeffect(a).typ=5 Then
                                    tmap(x,y).col=219
                                    tmap(x,y).desc="smoke"
                                EndIf
                            EndIf
                        EndIf
                    EndIf
                Next
            Next
        EndIf
    Next
    Return 0
End function



function ep_display_clouds(cloudmap() As Byte) As Short
    DimDebug(0)
    Dim As Short x,y,slot,osx,i
    Dim p As _cords
    slot=player.map
    osx=calcosx(awayteam.c.x,planets(slot).depth)

    For x=0 To _mwx
        For y=0 To 20
#if __FB_DEBUG__
            If debug=1 Then
                Color cloudmap(x,y)
                Pset (x,y)
            EndIf
#endif
            p.x=x+osx
            p.y=y
            If p.x>60 Then p.x=p.x-61
            If p.x<0 Then p.x=p.x+61
            If vismask(p.x,p.y)>0 And cloudmap(p.x,p.y)>0 Then
                If configflag(con_tiles)=0 Then
                    For i=1 To cloudmap(p.x,p.y)/2
                        Put ((x*_tix)+rnd_range(1,_tix/2)-rnd_range(1,_tix/2),(y*_tiy)+rnd_range(1,_tiy/2)-rnd_range(1,_tiy/2)),gtiles(gt_no(403)),trans
                    Next
                Else
                    set__color( 15,0)
                    Draw String(x*_fw1,y*_fh1),"~",,Font1,custom,@_col
                EndIf
            EndIf
        Next
    Next
    Return 0
End function






function ep_dropitem() As Short
    Dim As Short c,d,slot,i,num,j
    Dim As String text
    Dim As _cords ship
    awayteam.e.add_action(10)
    slot=player.map
    d=1
    If player.towed<-100 Then
        text="Do you want to build the "
        If player.towed=-101 Then text=text & "base module here?(y/n)"
        If player.towed=-102 Then text=text & "mining station here?(y/n)"
        If player.towed=-103 Then text=text & "defense tower here?(y/n)"
        If player.towed=-104 Then text=text & "raffinery here?(y/n)"
        If player.towed=-105 Then text=text & "factory here?(y/n)"
        If player.towed=-106 Then text=text & "power plant here?(y/n)"
        If player.towed=-107 Then text=text & "life support here?(y/n)"
        If player.towed=-108 Then text=text & "storage facilities here?(y/n)"
        If player.towed=-109 Then text=text & "hydroponic garden?(y/n)"
        If player.towed=-110 Then text=text & "office building here?(y/n)"
        If askyn(text) Then
            planetmap(awayteam.c.x,awayteam.c.y,slot)=-300+player.towed
            tmap(awayteam.c.x,awayteam.c.y)=tiles(-(player.towed-300))
            planets(slot).colony=1
            If player.towed=-101 Then planets(slot).colonystats(0)=10
            If player.towed=-102 Then planets(slot).colonystats(1)+=1
            If player.towed=-103 Then planets(slot).colonystats(2)+=1
            If player.towed=-104 Then planets(slot).colonystats(3)+=1
            If player.towed=-105 Then planets(slot).colonystats(4)+=1
            If player.towed=-106 Then planets(slot).colonystats(5)+=1
            If player.towed=-107 Then planets(slot).colonystats(6)+=1
            If player.towed=-108 Then planets(slot).colonystats(7)+=1
            If player.towed=-109 Then planets(slot).colonystats(8)+=1
            If player.towed=-110 Then planets(slot).colonystats(9)+=1
            player.towed=0
            d=0
        Else
            If askyn("Do you want to drop an item?(y/n)") Then
                d=1
            Else
                d=0
            EndIf
        EndIf
    EndIf
    If d=1 Then
        c=get_item(,,num)
        ep_display()
        display_awayteam(0)
        rlprint ""
        If c>=0 Then
            Select Case item(c).ty
            Case Is=45
                If askyn("Do you really want to drop the alien bomb?(y/n)") Then
                    item(c).w.x=awayteam.c.x
                    item(c).w.y=awayteam.c.y
                    item(c).w.m=slot
                    item(c).w.s=0
                    item(c).w.p=0
                    itemindex.add(c,awayteam.c)
                    item(c).v2=1
                    rlprint "What time do you want to set it to?"
                    item(c).v3=getnumber(1,99,1)
                EndIf
            Case Is=77
                display_awayteam()
                rlprint "Where do you want to drop the "&item(c).desig &"?"
                d=getdirection(keyin)
                If d<>-1 Or 5 Then
                    item(c).w=movepoint(awayteam.c,d)
                    If tmap(item(c).w.x,item(c).w.y).shootable<>0 Then
                        tmap(item(c).w.x,item(c).w.y).hp-=item(c).v1
                        rlprint tmap(item(c).w.x,item(c).w.y).desc &" takes "&item(c).v1 &" points of damage."
                        destroyitem(c)
                        If tmap(item(c).w.x,item(c).w.y).hp<=0 And tmap(item(c).w.x,item(c).w.y).turnsinto<>0 Then
                            planetmap(item(c).w.x,item(c).w.y,slot)=tmap(item(c).w.x,item(c).w.y).turnsinto
                            tmap(item(c).w.x,item(c).w.y)=tiles(tmap(item(c).w.x,item(c).w.y).turnsinto)
                        EndIf
                    Else
                        rlprint "Can't blow that up."
                    EndIf
                EndIf
            Case Else
                rlprint "Dropping " &item(c).desig &"."
                If num>1 Then
                    rlprint "How many?"
                    num=getnumber(1,num,0)
                EndIf
                If num>0 Then
                    For j=1 To num
                        If c>=0 Then
                            For i=0 To 128
                                If crew(i).pref_lrweap=item(c).uid Then crew(i).pref_lrweap=0
                                If crew(i).pref_ccweap=item(c).uid Then crew(i).pref_ccweap=0
                                If crew(i).pref_armor=item(c).uid Then crew(i).pref_armor=0
                            Next
                            If item(c).ty=18 Then item(c).v5=0
                            item(c).w.x=awayteam.c.x
                            item(c).w.y=awayteam.c.y
                            item(c).w.m=slot
                            item(c).w.s=0
                            item(c).w.p=0
                            If item(c).ty=15 Then
                                reward(2)=reward(2)-item(c).v5
                                tCompany.combon(2).Value-=item(c).v5
                            EndIf
                            If item(c).ty=24 And tmap(item(c).w.x,item(c).w.y).no=162 Then
                                rlprint("you reconnect the machine to the pipes. you notice the humming sound.")
                                no_key=keyin
                                item(c).v1=100
                            EndIf

                            If item(c).ty=26 Or item(c).ty=29 Then
                                reward(1)-=item(c).v3
                            EndIf

                            If item(c).ty=80 Then 'Dropping a tribble
                                lastenemy+=1
                                enemy(lastenemy)=makemonster(101,slot)
                                enemy(lastenemy).slot=16
                                planets(slot).mon_template(enemy(lastenemy).slot)=enemy(lastenemy)
                                enemy(lastenemy).c=item(c).w
                                destroyitem(c)
                            EndIf
                            itemindex.add(c,awayteam.c)
                            c=next_item(c)
                        EndIf
                    Next
                EndIf
            End Select
            equip_awayteam(slot)
        EndIf
    EndIf
    Return 0
End function


function ep_inspect(ByRef localturn As Short) As Short
    Dim As Short a,b,c,slot,skill,js,kit,rep,freebay
    Dim As _cords p
    Dim As _driftingship addship
    slot=player.map
    awayteam.e.add_action(10)
    freebay=getnextfreebay
    b=0
    If _autoinspect=1 And walking=0 And Not((tmap(awayteam.c.x,awayteam.c.y).no>=128 And tmap(awayteam.c.x,awayteam.c.y).no<=143) Or tmap(awayteam.c.x,awayteam.c.y).no=241) Then rlprint "You search the area: "&tmap(awayteam.c.x,awayteam.c.y).desc
    If awayteam.c.x=player.landed.x And awayteam.c.y=player.landed.y And awayteam.c.m=player.landed.m Then
        a=findbest(50,1)
        If a>0 And player.hull<player.h_maxhull Then
            If askyn("Do you want to use your ship repair kit to repair your ship?(y/n)") Then
                rep=minimum(player.h_maxhull-player.hull,item(a).v1)
                item(a).v1-=rep
                player.hull+=rep
                If item(a).v1<=0 Then destroyitem(a)
            EndIf
        EndIf
    EndIf
    If (tmap(awayteam.c.x,awayteam.c.y).no>=128 And tmap(awayteam.c.x,awayteam.c.y).no<=143) Or tmap(awayteam.c.x,awayteam.c.y).no=241 Then
        'Jump ship
        If tmap(awayteam.c.x,awayteam.c.y).hp>1 Then
            If askyn("it will take " &display_time(tmap(awayteam.c.x,awayteam.c.y).hp) & " hours to repair this ship. Do you want to start now? (y/n)") Then
                walking=-tmap(awayteam.c.x,awayteam.c.y).hp+1
                rlprint "Starting repair"
            EndIf
        EndIf

        If tmap(awayteam.c.x,awayteam.c.y).hp=0 Then
            If tmap(awayteam.c.x,awayteam.c.y).no=241 Then
                b=18
            Else
                b=tmap(awayteam.c.x,awayteam.c.y).no-127
            EndIf
            tmap(awayteam.c.x,awayteam.c.y).hp=15+rnd_range(1,6)+rnd_range(0,tmap(awayteam.c.x,awayteam.c.y).no-128)
            If skill_test(maximum(player.pilot(1)-1,player.science(1)),st_hard+b/4,"Repair ship")=-1 Then
                If askyn("it will take " &tmap(awayteam.c.x,awayteam.c.y).hp & " hours to repair this ship. Do you want to start now? (y/n)") Then
                    walking=-tmap(awayteam.c.x,awayteam.c.y).hp+1
                    rlprint "Starting repair"
                EndIf
            Else
                rlprint "This ship is beyond repair"
                
                changetile(awayteam.c.x,awayteam.c.y,slot,62)
                tmap(awayteam.c.x,awayteam.c.y)=tiles(62)
                addship.x=awayteam.c.x
                addship.y=awayteam.c.y
                addship.m=slot
                addship.s=b
                make_drifter(addship,dominant_terrain(awayteam.c.x,awayteam.c.y,slot),1)
                make_locallist(slot)'To add the portal to the list

            EndIf
        EndIf
        If tmap(awayteam.c.x,awayteam.c.y).hp=1 Then
            a=findbest(50,-1)
            If a>0 Then
                kit=item(a).v1
                destroyitem(a)
            Else
                kit=0
            EndIf

            If skill_test(maximum(player.pilot(1)-1,player.science(1))+kit,st_hard,"Repair ship") Then
                rlprint "The repair was succesfull!",c_gre
                set__color( 15,0)
                b=tmap(awayteam.c.x,awayteam.c.y).no-127
                If tmap(awayteam.c.x,awayteam.c.y).no=241 Then b=18
                textbox(shiptypes(b) &"||"&makehullbox(b,"data/ships.csv"),2,5,25,15,1)
                If askyn("Do you want to abandon your ship and use this one?") Then
                    a=player.h_no
                    If upgradehull(b,player) Then
                        player.hull=Int(player.hull*0.8)
                        tmap(player.landed.x,player.landed.y)=tiles(127+a)
                        changetile(player.landed.x,player.landed.y,slot,127+a)
                        player.landed.x=awayteam.c.x
                        player.landed.y=awayteam.c.y
                        player.landed.m=slot
                        tmap(player.landed.x,player.landed.y)=tiles(4)
                        planetmap(player.landed.x,player.landed.y,slot)=4
                        If player.hull<1 Then player.hull=1
                        js=1
                    EndIf
                EndIf
                If js=0 Then
                    changetile(awayteam.c.x,awayteam.c.y,slot,4)
                    tmap(awayteam.c.x,awayteam.c.y)=tiles(4)

                    addship.x=awayteam.c.x
                    addship.y=awayteam.c.y
                    addship.m=slot
                    addship.s=b
                    make_drifter(addship,dominant_terrain(awayteam.c.x,awayteam.c.y,slot))
                    'planets(lastplanet)=planets(slot)
                    planets(lastplanet).depth=1
                    planets(lastplanet).atmos=planets(slot).atmos
                    planets(lastplanet).grav=planets(slot).grav
                    planets(lastplanet).temp=30
                    For a=1 To 16
                        planets(lastplanet).mon_template(a)=planets(slot).mon_template(a)
                        planets(lastplanet).mon_noamin(a)=planets(slot).mon_noamin(a)/3-1
                        planets(lastplanet).mon_noamax(a)=planets(slot).mon_noamax(a)/3-1
                    Next

                EndIf
            Else
                rlprint "You couldn't repair the ship."
                make_drifter(addship,dominant_terrain(awayteam.c.x,awayteam.c.y,slot),1)
                planets(lastplanet).depth=1
                planets(lastplanet).atmos=planets(slot).atmos
                planets(lastplanet).grav=planets(slot).grav
                planets(lastplanet).temp=30
                For a=1 To 16
                    planets(lastplanet).mon_template(a)=planets(slot).mon_template(a)
                    planets(lastplanet).mon_noamin(a)=planets(slot).mon_noamin(a)/3-1
                    planets(lastplanet).mon_noamax(a)=planets(slot).mon_noamax(a)/3-1
                Next

                changetile(awayteam.c.x,awayteam.c.y,slot,4)
                tmap(awayteam.c.x,awayteam.c.y)=tiles(4)
            EndIf
        EndIf
        b=1
    EndIf

    For a=1 To lastenemy
        If b=0 And awayteam.c.x=enemy(a).c.x And awayteam.c.y=enemy(a).c.y Then
            If enemy(a).hpmax>0 And enemy(a).hp<=0 And enemy(a).biomod>0 Then
                awayteam.e.add_action(25)
                skill=maximum(player.science(1),player.doctor(1)/2)
                If rnd_range(1,100)<enemy(a).disease*2-awayteam.helmet*3 Then infect(rnd_range(1,awayteam.hpmax),enemy(a).disease)
                If enemy(a).disease>0 And skill_test(maximum(player.doctor(1),player.science(1)/2),enemy(a).disease/2+7) Then rlprint "The creature seems to be a host to dangerous "&disease(enemy(a).disease).cause &"."
                If enemy(a).disease>0 And Not(skill_test(maximum(player.doctor(1),player.science(1)/2)+awayteam.helmet*3,enemy(a).disease)) Then
                    infect(rnd_crewmember,enemy(a).disease)
                    rlprint "This creature is infected with "&disease(enemy(a).disease).desig,14
                EndIf
                If (player.science(1)>0) Or (player.doctor(1)>0) Then
                    tCompany.combon(1).Value+=1
                    kit=findbest(48,-1)
                    If kit>0 Then
                        kit=item(kit).v1
                    Else
                        kit=0
                    EndIf

                    rlprint "Recording biodata: "&enemy(a).ldesc
                    If enemy(a).slot>=0 Then
                        If planets(slot).mon_disected(enemy(a).slot)<255  Then planets(slot).mon_disected(enemy(a).slot)+=1
                    EndIf
                    If enemy(a).lang=8 Then rlprint "While this beings biochemistry is no doubt remarkable it does not explain it's extraordinarily long lifespan"
                    If enemy(a).hpmax<0 Then enemy(a).hpmax=0
                    If enemy(a).slot>=0 Then reward(1)=reward(1)+(10+kit+skill+add_talent(4,14,1)+get_biodata(enemy(a)))/(planets(slot).mon_disected(enemy(a).slot)/2)
                    If enemy(a).disease=0 Then
                        
                        If enemy(a).hpmax*enemy(a).pretty/10>0 Then rlprint "Some parts of this creature would make fine luxury items! You store them seperately."
                        If enemy(a).hpmax*enemy(a).tasty/10>0 Then rlprint "Some parts of this creature would make fine food items! You store them seperately."
                        reward(rwrd_pretty)+=enemy(a).hpmax*enemy(a).pretty/10
                        reward(rwrd_tasty)+=enemy(a).hpmax*enemy(a).tasty/10
                        check_tasty_pretty_cargo
                    EndIf
                    enemy(a).hpmax=0
                    b=1
                    If kit>0 And Not(skill_test(maximum(player.doctor(1)/2,player.science(location)),st_average)) Then
                        kit=findbest(48,-1)
                        rlprint "The autopsy kit is empty",c_yel
                        destroyitem(kit)
                    EndIf
                Else
                    rlprint "No science officer or doctor in the team.",c_yel
                EndIf
            Else
                If (player.science(1)>0) Or (player.doctor(1)>0) Then
                    If enemy(a).hp>0 Then rlprint "The " &enemy(a).sdesc &" doesn't want to be dissected alive."
                    If enemy(a).biomod>0 Then rlprint "Nothing left to learn here."
                    If enemy(a).biomod=0 Then rlprint "Dissecting "&add_a_or_an(enemy(a).sdesc,0) &" doesn't yield any biodata."
                Else
                    rlprint "No science officer or doctor in the team.",c_yel
                EndIf
            EndIf
        EndIf
    Next
    If b=0 And tmap(awayteam.c.x,awayteam.c.y).vege>0 And planets(slot).flags(32)<=planets(slot).life+1+add_talent(4,15,3) Then
        If (player.science(1)>0) Or (player.doctor(1)>0) Then
            skill=maximum(player.science(1),player.doctor(1)/2)
            'rlprint ""&tmap(awayteam.c.x,awayteam.c.y).vege

            kit=findbest(49,-1)
            If kit>0 Then
                kit=item(kit).v1
            Else
                kit=0
            EndIf

            If skill_test(skill+tmap(awayteam.c.x,awayteam.c.y).vege+add_talent(4,15,1)+kit,st_average+planets(a).plantsfound) Then
                awayteam.e.add_action(25)
                planets(slot).flags(32)=planets(slot).flags(32)+1
                b=1
                If tmap(awayteam.c.x,awayteam.c.y).no<>179 Then
                    rlprint "you have found "&plant_name(tmap(awayteam.c.x,awayteam.c.y))
                    If rnd_range(1,80)-player.science(1)-add_talent(4,14,1)<tmap(awayteam.c.x,awayteam.c.y).vege Then
                        rlprint "The plants in this area have developed a biochemistry you have never seen before. Scientists everywhere will find this very interesting."
                        reward(1)=reward(1)+(10+skill+add_talent(4,14,1)+tmap(awayteam.c.x,awayteam.c.y).vege)/planets(slot).flags(32)
                    EndIf
                    If rnd_range(1,100)<tmap(awayteam.c.x,awayteam.c.y).disease*2-awayteam.helmet*3 Then
                        If Not(skill_test(maximum(player.science(1)/2,player.doctor(1)),st_average)) Then infect(rnd_range(1,awayteam.hpmax),tmap(awayteam.c.x,awayteam.c.y).disease)
                        rlprint "This area is contaminated with "&disease(tmap(awayteam.c.x,awayteam.c.y).disease).ldesc
                    EndIf
                    If tmap(awayteam.c.x,awayteam.c.y).disease>0 And skill_test(maximum(player.doctor(1),player.science(1)/2),st_easy+tmap(awayteam.c.x,awayteam.c.y).disease/2) Then rlprint "The plants here seem to be a host to dangerous "&disease(tmap(awayteam.c.x,awayteam.c.y).disease).cause &"."
                Else
                    rlprint "You collect some spice sand."
                    reward(1)+=rnd_range(1,10)
                EndIf
                reward(1)=reward(1)+(10+kit+skill+add_talent(4,14,1)+tmap(awayteam.c.x,awayteam.c.y).vege)/planets(slot).flags(32)
                planets(slot).plantsfound=planets(slot).plantsfound+1
                If kit>0 And Not(skill_test(maximum(player.doctor(1)/2,player.science(1)),st_average)) Then
                    kit=findbest(49,-1)
                    rlprint "The botany kit is empty",c_yel
                    destroyitem(kit)
                EndIf
            EndIf
            tmap(awayteam.c.x,awayteam.c.y).vege=0
        Else
            rlprint "No science officer or doctor on the team.",c_yel
        EndIf
    EndIf
    If b=0 Then
        For c=1 To 9
            If c<>5 Then
                p=movepoint(awayteam.c,c)
            Else
                p=awayteam.c
            EndIf
            If tmap(p.x,p.y).turnsoninspect<>0  And skill_test(player.science(1),st_average+tmap(p.x,p.y).turnroll) Then
                awayteam.e.add_action(25)
                b=1
                If tmap(p.x,p.y).turntext<>"" Then rlprint tmap(p.x,p.y).turntext
                planetmap(p.x,p.y,slot)=tmap(p.x,p.y).turnsoninspect
                tmap(p.x,p.y)=tiles(tmap(p.x,p.y).turnsoninspect)
            EndIf
        Next
    EndIf
    If b=0 Then
        If planetmap(awayteam.c.x,awayteam.c.y,slot)=107 Then
            b=1
            If askyn("You could propably enhance some of the processes in this factory, to dimnish pollution. (y/n)") Then
                awayteam.e.add_action(200)
                If skill_test(player.science(location),st_hard) Then
                    planets(slot).flags(28)+=1
                    If planets(slot).flags(28)>=5 Then
                        rlprint "You manage to reduce the emissions of this factory to sustainable levels.",10
                        planets(slot).flags(28)-=5
                        tmap(awayteam.c.x,awayteam.c.y)=tiles(297)
                        planetmap(awayteam.c.x,awayteam.c.y,slot)=297
                    EndIf
                Else
                    rlprint "You do not succeed",14
                EndIf
            EndIf
        EndIf
    EndIf
    If b=0 And _autoinspect=1 Then
        rlprint "Nothing of interest here."
    EndIf
    Return 0
End function


function alienbomb(c As Short,slot As Short) As Short
    Dim As Short a,b,d,e,f,osx,x2
    Dim As _cords p,p1
    p1.x=item(c).w.x
    p1.y=item(c).w.y
    osx=calcosx(awayteam.c.x,planets(slot).depth)

    For e=0 To item(c).v1*6
        tScreen.set(0)
        display_planetmap(slot,osx,0)
        For x=0 To 60
            For y=0 To 20
                p.x=x
                p.y=y
                f=Int(distance(p,p1,1))
                set__color( 0,0)
                If f=e  Then set__color( 0,1)
                If f=e+7 Then set__color( 236,15)
                If f=e+6 Then set__color( 236,237)
                If f=e+5 Then set__color( 237,238)
                If f=e+4 Then set__color( 238,239)
                If f=e+3 Then set__color( 239,240)
                If f=e+2 Then set__color( 240,241)
                If f=e+1 Then set__color( 241,1)
                If f=e-1 Then set__color( 0,0)
                If f=e-2 Then set__color( 0,0)
                If f>=e-2 And f<=e+7 Then
                    x2=x-osx
                    If x2<0 Then x2+=61
                    If x2>60 Then x2-=61
                    If configflag(con_tiles)=0 Then
                        If x2>=0 And x2<=_mwx Then Put ((x2)*_tix,y*_tiy),gtiles(gt_no(76+f-e)),trans
                    Else
                        Draw String(x2*_fw1,y*_fh1), Chr(176),,font1,custom,@_col
                    EndIf
                EndIf
                If f<e Then
                    If tmap(x,y).shootable>0 Then
                        d=rnd_range(1,item(c).v1*12)
                        If tmap(p.x,p.y).dr<d Then
                            tmap(p.x,p.y).hp=tmap(p.x,p.y).hp-d
                        Else
                            tmap(p.x,p.y).dr=tmap(p.x,p.y).dr-d
                        EndIf
                        If tmap(x,y).hp<=0 Then
                            If planetmap(x,y,slot)>0 Then planetmap(x,y,slot)=tmap(x,y).turnsinto
                            If planetmap(x,y,slot)<0 Then planetmap(x,y,slot)=-tmap(x,y).turnsinto
                            tmap(x,y)=tiles(tmap(x,y).turnsinto)
                        EndIf
                    EndIf
                EndIf
            Next
        Next
        tScreen.update()
        Sleep 50
    Next

    For e=242 To 249
        For x=0 To 60
            For y=0 To 20
                set__color( e,e)
                If configflag(con_tiles)=0 Then
                    'if x-osx>=0 and x-osx<=_mwx then put ((x-osx)*_tix,y*_tiy),gtiles(gt_no(rnd_range(63,66))),pset
                Else
                    draw_string(x*_fw1,y*_fh1, Chr(176),font1,_col)
                EndIf
            Next
        Next
        Sleep 50
    Next

    For e=0 To lastenemy
        If distance(enemy(e).c,p1,1)<item(c).v1*5 Then enemy(e).hp=enemy(e).hp-item(c).v1*3
    Next
    For e=0 To item(c).v1
        If planets(slot).atmos>1 And item(c).v1>1 Then
            planets(slot).atmos-=1
            item(c).v1-=2
            If planets(slot).atmos=6 Or planets(slot).atmos=12 Then planets(slot).atmos=1
        EndIf
    Next
    For a=1 To itemindex.vlast
        p.x=item(itemindex.value(a)).w.x
        p.y=item(itemindex.value(a)).w.y
        If a=c Or (rnd_range(1,100)+item(c).v1>item(itemindex.value(a)).res And distance(p,p1,1)<item(c).v1*5) Then
            destroyitem(itemindex.value(a))
            itemindex.remove(a,p)
        EndIf
    Next

    display_planetmap(slot,osx,0)


    Return 0
End function


function ep_items(localturn As Short) As Short
    DimDebug(0)
    Dim As Short a,slot,i,x,y,curr,last
    Dim As _cords p1,p2,route(1284)
    Dim As Single dam

    slot=player.map
    For a=1 To itemindex.vlast 'Drop items of dead monsters
            If item(itemindex.value(a)).w.p>0 And item(itemindex.value(a)).w.p<9999 Then
            
                If enemy(item(itemindex.value(a)).w.p).hp<=0 Then
                    item(itemindex.value(a)).w.x=enemy(item(itemindex.value(a)).w.p).c.x
                    item(itemindex.value(a)).w.y=enemy(item(itemindex.value(a)).w.p).c.y
                    item(itemindex.value(a)).w.p=0
                    item(itemindex.value(a)).w.m=slot
                    item(itemindex.value(a)).w.s=0
                    itemindex.add(itemindex.value(a),item(itemindex.value(a)).w)
                EndIf
            EndIf

            If item(itemindex.value(a)).ty=45 And item(itemindex.value(a)).w.p<9999 And item(itemindex.value(a)).w.s=0 Then 'Alien bomb
                If item(itemindex.value(a)).v2=1 Then
                    item(itemindex.value(a)).v3-=1
                    If item(itemindex.value(a)).v3<10 Or frac(item(itemindex.value(a)).v3/10)=0 Then rlprint item(itemindex.value(a)).v3 &""
                    If item(itemindex.value(a)).v3<=0 Then
                        p1.x=item(itemindex.value(a)).w.x
                        p1.y=item(itemindex.value(a)).w.y
                        dam=10/(1+distance(awayteam.c,p1))*item(itemindex.value(a)).v1*10
                        alienbomb(itemindex.value(a),slot)
                        If dam>0 Then rlprint dam_awayteam(dam)
                        If awayteam.hp<=0 Then player.dead=29
                        itemindex.remove(a,p1)
                    EndIf
                EndIf
            EndIf

            If item(itemindex.value(a)).ty=18 And item(itemindex.value(a)).discovered=1 And item(itemindex.value(a)).w.p=0 And item(itemindex.value(a)).w.s>=0  And item(itemindex.value(a)).v5=0 Then 'Rover
                for i=1 to 10
                    ep_rovermove(itemindex.value(a),slot)
                next
            EndIf



        Next
        Return 0
End function

function ep_landship(ByRef ship_landing As Short,nextlanding As _cords,nextmap As _cords) As Short
    Dim As Short r,slot,a,d
    slot=player.map
    ship_landing=ship_landing-1
    If ship_landing<=0 Then
        If vismask(nextlanding.x,nextlanding.y)>0 And nextmap.m=0 Then rlprint "She is coming in"
        If skill_test(player.pilot(location),st_easy+planets(slot).dens+planets(slot).grav,"Pilot") Then
            rlprint gainxp(2),c_gre
        Else
            If vismask(nextlanding.x,nextlanding.y)>0 And nextmap.m=0 Then rlprint "Hard touchdown!",14
            player.hull=player.hull-1
            player.fuel=player.fuel-2-Int(planets(slot).grav)
            d=rnd_range(1,8)
            If d=5 Then d=9
            If r<-2 Then r=-2
            For a=1 To r*-1
                nextlanding=movepoint(nextlanding,d)
            Next
            If player.hull=0 Then
                rlprint ("A Crash landing. you will never be able to start with that thing again",12)
                If skill_test(player.pilot(1),st_veryhard) Then
                    rlprint ("but your pilot wants to try anyway and succeeds!",12)
                    player.hull=1
                    rlprint gainxp(2),c_gre
                Else
                    player.dead=4
                EndIf
                no_key=keyin
            EndIf
        EndIf
        player.landed.m=slot
        player.landed.x=nextlanding.x
        player.landed.y=nextlanding.y
        For a=1 To lastenemy
            If distance(enemy(a).c,nextlanding)<2 Then
                enemy(a).hp=enemy(a).hp-(player.h_no+planets(slot).grav)/(1+distance(enemy(a).c,nextlanding))
                If vismask(enemy(a).c.x,enemy(a).c.y)>0 Then rlprint "The "&enemy(a).sdesc &" gets caught in the blast of the landing ship."
                If rnd_range(1,6)+ rnd_range(1,6)>enemy(a).intel Then
                    enemy(a).aggr=2
                    enemy(a).target=nextlanding
                EndIf
            EndIf
        Next
    EndIf
    Return 0
End function

function ep_launch(ByRef nextmap As _cords) As Short
    Dim slot As Short
    slot=player.map
    If awayteam.c.y=player.landed.y And awayteam.c.x=player.landed.x And slot=player.landed.m Then
        If slot=specialplanet(2) Or slot=specialplanet(27)  Then
            If slot=specialplanet(27) Then
                If specialflag(27)=0 Then
                    rlprint "As you attempt to start you realize that your landing struts have sunk into the surface of the planet. You try to dig free, but the surface closes around them faster than you can dig. You are stuck!"
                Else
                    rlprint "You successfully break free of the living planet."
                    nextmap.m=-1
					play_sound(10)
                EndIf
            EndIf
            If slot=specialplanet(2) Then
                If specialflag(2)<>2 Then
                    rlprint "As soon as you attempt to start the planetary defense system fires. You won't be able to start until you disable it."
                Else
                    rlprint "You start without incident"
                    nextmap.m=-1
					play_sound(10)
                EndIf
            EndIf
        Else
            nextmap.m=-1
			play_sound(10)
        EndIf
    EndIf
    Return 0
End function


function ep_pickupitem(Key As String) As Short
    Dim a As Short
    Dim text As String
    For a=1 to itemindex.last(awayteam.c.x,awayteam.c.y) 
        If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).w.p=0 Then
            If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).ty<>99 Then
                If _autopickup=1 Then text=text &item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).desig &". "
                If _autopickup=0 Or Key=key_pickup Then
                    
                    If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).ty=15 Then
                        If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1<5 Then text=text &" You pick up the small amount of "&item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).desig &". "
                        If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1>=5 And item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1<=10 Then text=text &" You pick up the "&item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).desig &". "
                        If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1>10 Then text=text &" You pick up the large amount of "&item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).desig &". "
                    Else
                        text=text &" You pick up the "&item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).desig &". "
                    EndIf
                    reward(2)=reward(2)+item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v5
                    tCompany.combon(2).Value+=item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v5
                    item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).w.s=-1
                    item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).w.m=-0
                    item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).w.p=-0
                EndIf
                If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).ty=18 Then
                    item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v5=0
                    text=text &" You transfer the map data from the rover robot ("&Fix(item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v6) &"). "
                    reward(0)=reward(0)+item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v6
                    reward(7)=reward(7)+item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v6
                    item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v6=0
                EndIf
                If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).ty=27 Then
                    text=text &" You gather the resources from the mining robot ("&Fix(item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1) &"). "
                    reward(2)=reward(2)+item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1
                    tCompany.combon(2).Value+=item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1

                    item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1=0
                EndIf
                If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).ty=26 Then
                    If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1>0 Then
                        text=text &" There is something in it."
                        text=text & item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).ldesc
                        reward(1)+=item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v3
                    EndIf
                EndIf
            Else
                rlprint "An alien artifact!",10
                If _autopickup=0 Or Key=key_pickup Then

                    findartifact(item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v5)
                    item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).w.p=9999
                EndIf
            EndIf
            itemindex.remove(itemindex.index(awayteam.c.x,awayteam.c.y,a),awayteam.c)
        EndIf
    Next
    If Key=key_pickup Then
        For a=1 To lastenemy
            If enemy(a).c.x=awayteam.c.x And enemy(a).c.y=awayteam.c.y And enemy(a).made=101 And enemy(a).hp>0 Then
                text=text &" You pick up the tribble."
                enemy(a)=enemy(lastenemy)
                lastenemy-=1
                placeitem(make_item(250),0,0,0,0,-1)
                Exit For
            EndIf
        Next
    EndIf
    If text<>"" Then
        rlprint Trim(text),15
    EndIf
    Return 0
End function

function ep_portal() As _cords
    Dim As Short a,ti,slot
    Dim As _cords nextmap
    Dim As _cords p
    slot=player.map
    if portalindex.last(awayteam.c.x,awayteam.c.y)>0 then a=portalindex.index(awayteam.c.x,awayteam.c.y,1)
        
        If portal(a).oneway=2 And portal(a).from.m=slot Then
            If awayteam.c.x=0 Or awayteam.c.x=60 Or awayteam.c.y=0 Or awayteam.c.y=20 Then
                If askyn("Do you want to leave the area?(y/n)") Then nextmap=portal(a).dest
                return nextmap
            EndIf
        EndIf
        
        If portal(a).from.m=slot and portal(a).oneway<2 Then
                If askyn(portal(a).desig &" Enter?(y/n)") Then
                    rlprint "going through."
                    'walking=-1
                    If planetmap(0,0,portal(a).dest.m)=0 Then
                        'rlprint "Making new map at "&portal(a).dest.m &"("&lastplanet &")"
                        ti=planetmap(awayteam.c.x,awayteam.c.y,slot)
                        planets(portal(a).dest.m)=planets(slot)
                        planets(portal(a).dest.m).weat=0
                        planets(portal(a).dest.m).depth=planets(portal(a).dest.m).depth+1
                        planets(portal(a).dest.m).life=planets(portal(a).dest.m).life+rnd_range(1,3)
                        If rnd_range(1,100)>planets(portal(a).from.m).depth*12 Then
                            makecavemap(portal(a).dest,portal(a).tumod,portal(a).dimod,portal(a).spmap,ti,0)
                        Else
                            If rnd_range(1,100)<71 Then
                                makecomplex(portal(a).dest,0)
                                planets(portal(a).dest.m).temp=25
                                planets(portal(a).dest.m).atmos=3
                                planets_flavortext(portal(a).dest.m)="You enter an ancient underground complex. It is dark, lighting sources have failed long ago. The air is cool and breathable. A thin layer of dust dulls the once shining metal surfaces. Aside all that it looks as if the owners of this facility could return every minute"
                            Else
                                makecanyons(portal(a).dest.m,9)
                                p=rnd_point(portal(a).dest.m,0)
                                portal(a).dest.x=p.x
                                portal(a).dest.y=p.y
                                planets_flavortext(portal(a).dest.m)="You enter a huge cave. Deep canyons at the bottom are filled with exotic plants. You hear the cries of unknown beasts."
                            EndIf
                        EndIf
                        If planets(portal(a).dest.m).depth>7 Then
                            makefinalmap(portal(a).dest.m)
                            portal(a).dest.x=30
                            portal(a).dest.y=2
                        EndIf
                    EndIf
                    nextmap=portal(a).dest
                    If planets(portal(a).from.m).death>0 Then
                        deleteportal(portal(a).from.m,portal(a).dest.m)
                        planetmap(nextmap.x,nextmap.y,nextmap.m)=-4
                    EndIf
                    'rlprint " "&portal(a).dest.m
                EndIf
            
        EndIf
        If portal(a).oneway=0 And portal(a).dest.m=slot Then
            If awayteam.c.x=portal(a).dest.x And awayteam.c.y=portal(a).dest.y Then
                If askyn(portal(a).desig &" Enter?(y/n)") Then
                    rlprint "going through."
                    'walking=-1
                    If planetmap(0,0,portal(a).from.m)=0 Then
                        'rlprint "Making new map at "&portal(a).dest.m &"("&lastplanet &")"
                        ti=planetmap(awayteam.c.x,awayteam.c.y,slot)
                        planets(portal(a).from.m)=planets(slot)
                        planets(portal(a).from.m).depth=planets(portal(a).dest.m).depth+1
                        planets(portal(a).from.m).life=planets(portal(a).dest.m).life+rnd_range(1,3)
                        If rnd_range(1,100)>planets(portal(a).dest.m).depth*12 Then
                            makecavemap(portal(a).from,portal(a).tumod,portal(a).dimod,portal(a).spmap,ti,0)
                        Else
                            If rnd_range(1,100)<71 Then
                                makecomplex(portal(a).dest,0)
                                planets(portal(a).from.m).temp=25
                                planets(portal(a).from.m).atmos=3
                                planets_flavortext(portal(a).from.m)="You enter an ancient underground complex. It is dark, lighting sources have failed long ago. The air is cool and breathable. A thin layer of dust dulls the once shining metal surfaces. Aside all that it looks as if the owners of this facility could return every minute"
                            Else
                                makecanyons(portal(a).from.m,9)
                                p=rnd_point(portal(a).from.m,0)
                                portal(a).from.x=p.x
                                portal(a).from.y=p.y
                                planets_flavortext(portal(a).dest.m)="You enter a huge cave. Deep canyons at the bottom are filled with exotic plants. You hear the cries of unknown beasts."
                            EndIf
                        EndIf
                        If planets(portal(a).from.m).depth>7 Then
                            makefinalmap(portal(a).from.m)
                            portal(a).from.x=30
                            portal(a).from.y=2
                        EndIf
                    EndIf
                    nextmap=portal(a).from
                    If planets(portal(a).dest.m).death>0 Then
                        deleteportal(portal(a).from.m,portal(a).dest.m)
                        planetmap(nextmap.x,nextmap.y,nextmap.m)=-4
                    EndIf
                EndIf
            EndIf
        EndIf
    
    Return nextmap
End function

function ep_tileeffects(areaeffect() As _ae, ByRef last_ae As Short,lavapoint() As _cords, nightday() As Byte, localtemp() As Single,cloudmap() As Byte) As Short
    Dim As Short a,x,y,dam,slot,orbit
    Dim As _cords p,p2
    Dim As Single tempchange
    slot=player.map
    orbit=orbitfrommap(slot)
    If orbit=-1 Then
        tempchange=0
    Else
        tempchange=11-planets(slot).dens*2/orbit
    EndIf
    For x=0 To 60
        For y=0 To 20
            If nightday(x)=3 Then localtemp(x,y)=localtemp(x,y)+tempchange'Day
            If nightday(x)=0 Then localtemp(x,y)=localtemp(x,y)-tempchange'Night

            If x>0 And x<60 And y>0 And y<20 Then
                If tmap(x,y).no=204 Or tmap(x,y).no=202 Then
                    If vacuum(x-1,y)=1 Or vacuum(x+1,y)=1 Or vacuum(x,y-1)=1 Or vacuum(x,y+1)=1 Then vacuum(x,y)=1
                    If vacuum(x-1,y-1)=1 Or vacuum(x-1,y+1)=1 Or vacuum(x+1,y-1)=1 Or vacuum(x+1,y+1)=1 Then vacuum(x,y)=1
                EndIf
            EndIf
            If tmap(x,y).dam<>0 Then
                p2.x=x
                p2.y=y
                player.killedby=tmap(x,y).deadt
                If player.killedby="" Then player.killedby=tmap(x,y).desc
                If distance(awayteam.c,p2)<=tmap(x,y).range Then
                    If tmap(x,y).dam<0 Then
                        dam=rnd_range(1,Abs(tmap(x,y).dam))
                    Else
                        dam=tmap(x,y).dam
                    EndIf
                    If rnd_range(1,100)<tmap(x,y).tohit Then
                        rlprint tmap(x,y).hitt &" "&  dam_awayteam(dam),12
                    Else
                        rlprint tmap(x,y).misst,14
                    EndIf
                EndIf
            EndIf

            a=rnd_range(1,100)
            If a<tmap(x,y).causeaeon Then
                last_ae=last_ae+1
                If last_ae>16 Then last_ae=0
                areaeffect(last_ae).c.x=x
                areaeffect(last_ae).c.y=y
                areaeffect(last_ae).rad=rnd_range(1,2)
                areaeffect(last_ae).dam=0
                areaeffect(last_ae).dur=rnd_range(1,4)+rnd_range(1,4)
                areaeffect(last_ae).typ=tmap(x,y).aetype
            EndIf
                If localtemp(x,y)<-10 And tmap(x,y).no=1 Or tmap(x,y).no=2 Then
                    tmap(x,y).gives=tmap(x,y).gives+(localtemp(x,y)/25)
                    If rnd_range(0,100)<Abs(tmap(x,y).gives) And tmap(x,y).gives<-50 Then
                        If vismask(x,y)>0 Then rlprint "The water freezes again."
                        If tmap(x,y).no=2 Then
                            tmap(x,y)=tiles(27)
                            changetile(x ,y ,slot ,27)
                        Else
                            tmap(x,y)=tiles(260)
                            changetile(x ,y ,slot ,260)
                        EndIf
                    EndIf
                EndIf

                If localtemp(x)>10 And tmap(x,y).no=27 Or tmap(x,y).no=260 Then
                    tmap(x,y).hp-=localtemp(x,y)/25
                    If tmap(x,y).hp<0 Then
                        tmap(x,y)=tiles(2)
                        changetile(x ,y ,slot ,2)
                        If vismask(x,y)>0 Then rlprint "The ice melts."
                    EndIf
                EndIf

                If localtemp(x)>30 And planets(slot).atmos>1 Then
                    If tmap(x,y).walktru=1 Then
                        If rnd_range(1,100)<localtemp(x,y)+planets(slot).weat Then cloudmap(x,y)+=1

                    EndIf
                EndIf
                If x>0 And y>0 And x<60 And y<20 Then
                    If cloudmap(x,y)>0 Then
                        If tmap(x,y).walktru=2 Or tmap(x-1,y).walktru=2 Or tmap(x+1,y).walktru=2 Or tmap(x,y-1).walktru=2 Or tmap(x,y+1).walktru=2 Then
                            cloudmap(x,y)-=1
                        EndIf
                        If planets(slot).dens<3 Then cloudmap(x,y)-=2
                    EndIf
                EndIf
                If cloudmap(x,y)>0 Then
                    p.x=x
                    p.y=y
                    If rnd_range(1,100)<(1+planets(slot).weat)*5 Then
                        cloudmap(x,y)-=1
                        p=movepoint(p,5,1)
                        cloudmap(p.x,p.y)+=1
                    EndIf
                EndIf


                If tmap(x,y).no=245 And rnd_range(1,100)<9+planets(slot).grav Then
                    p.x=x
                    p.y=y
                    p=movepoint(p,5)
                    lavapoint(rnd_range(1,5))=p
                EndIf
        Next
    Next

    If planetmap(awayteam.c.x,awayteam.c.y,slot)=45 Then
        rlprint "Smoldering lava:" &dam_awayteam(rnd_range(1,6-awayteam.movetype)),12
        If awayteam.hp<=0 Then player.dead=16
        player.killedby="lava"
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).no=175 Or tmap(awayteam.c.x,awayteam.c.y).no=176 Or tmap(awayteam.c.x,awayteam.c.y).no=177 Then
        rlprint "Aaaaaaaaaaaaaaaahhhhhhhhhhhhhhh",12
        player.dead=27
    EndIf

    If (tmap(awayteam.c.x,awayteam.c.y).no=260 Or tmap(awayteam.c.x,awayteam.c.y).no=27) And player.dead=0 Then
        tmap(awayteam.c.x,awayteam.c.y).gives=tmap(awayteam.c.x,awayteam.c.y).gives-rnd_range(0,awayteam.hp\5)
        if awayteam.movetype=mt_walk then
            If tmap(awayteam.c.x,awayteam.c.y).hp<=awayteam.hp/3 Then rlprint "The ice creaks",14
            If tmap(awayteam.c.x,awayteam.c.y).hp<=0 Then
                rlprint "...and breaks! "&dam_awayteam(rnd_range(1,3)),12
                tmap(awayteam.c.x,awayteam.c.y)=tiles(2)
                planetmap(awayteam.c.x,awayteam.c.y,slot)=2
            EndIf
        endif
    EndIf

    Return 0
End function

function ep_lava(lavapoint() As _cords) As Short
    Dim As Short a,slot
    slot=player.map
    If planets(slot).temp+rnd_range(0,10)>350 Then 'lava
        a=rnd_range(1,5)
        If lavapoint(a).x=0 And lavapoint(a).y=0 Then
            lavapoint(a).x=rnd_range(1,60)
            lavapoint(a).y=rnd_range(1,20)
        EndIf
        If rnd_range(1,100)<75 Then
            If lavapoint(a).x<>player.landed.x And lavapoint(a).y<>player.landed.y Then
                If planets(slot).depth=0 Then
                    If rnd_range(1,100)<50 Then
                        planetmap(lavapoint(a).x,lavapoint(a).y,slot)=-47
                        tmap(lavapoint(a).x,lavapoint(a).y)=tiles(47)
                    Else
                        planetmap(lavapoint(a).x,lavapoint(a).y,slot)=-8
                        tmap(lavapoint(a).x,lavapoint(a).y)=tiles(8)
                    EndIf
                Else
                    planetmap(lavapoint(a).x,lavapoint(a).y,slot)=-47
                    tmap(lavapoint(a).x,lavapoint(a).y)=tiles(47)
                EndIf
            EndIf
        EndIf
        lavapoint(a)=movepoint(lavapoint(a),5)
        planetmap(lavapoint(a).x,lavapoint(a).y,slot)=-45
        tmap(lavapoint(a).x,lavapoint(a).y)=tiles(45)
        If vismask(lavapoint(a).x,lavapoint(a).y)>0 Then
            If walking<11 Then walking=0
            planetmap(lavapoint(a).x,lavapoint(a).y,slot)=45
            rlprint "The ground breaks open, releasing fountains of lava"
        EndIf
        If lavapoint(a).x=player.landed.x And lavapoint(a).y=player.landed.y Then
            player.hull=player.hull-1
            If distance(lavapoint(a),awayteam.c)<awayteam.sight Then rlprint "Your ship was damaged!"
            If player.hull<=0 Then player.dead=15
        EndIf
    EndIf
    Return 0
End function


function ep_updatemasks(spawnmask() As _cords,mapmask() As Byte,nightday() As Byte, ByRef dawn As Single, ByRef dawn2 As Single) As Short
    Dim As Short lsp,x,y,slot,sys,hasnosun
    slot=player.map
    sys=sysfrommap(slot)
    hasnosun=0
    If sys<0 Then
        hasnosun=1
    Else
        If map(sys).spec=9 or map(sys).spec=8 Or map(sys).spec=10 Then hasnosun=1
    EndIf
    If planets(slot).depth>0 Then hasnosun=1
    If hasnosun=0 Then
        dawn=dawn+planets(slot).rot/5
        If dawn>60 Then dawn=dawn-60
        dawn2=dawn+30
        If dawn2>60 Then dawn2=dawn2-60
        For x=60 To 0 Step -1
            nightday(x)=0
            If (dawn<dawn2 And (x>dawn And x<dawn2))  Then nightday(x)=3
            If (dawn>dawn2 And (x>dawn Or x<dawn2)) Then nightday(x)=3
            If x=Int(dawn) Then nightday(x)=1
            If x=Int(dawn2) Then nightday(x)=2
        Next
    Else
        For x=0 To 60
            nightday(x)=4
        Next
    EndIf

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
    Return lsp
End function



function getmonster() as short
    dim as short d,e,c
    d=0
    for c=1 to lastenemy 'find dead that doesnt respawn
        if enemy(c).respawns=0 and enemy(c).hp<=0 then return d
    next
    if d=0 then
        lastenemy=lastenemy+1
        d=lastenemy
        if d>255 then
            lastenemy=255
            d=255
        endif
    endif
    return d
end function


function ep_spawning(spawnmask() As _cords,lsp As Short, diesize As Short,nightday() As Byte) As Short
    Dim As Short a,b,c,x,y,d,slot
    If _spawnoff=1 Then Return 0
    slot=player.map
    For x=0 To 60
        For y=0 To 20
            a=rnd_range(1,100)
            If a<tmap(x,y).spawnson And tmap(x,y).spawnblock>=0 Then
                If tmap(x,y).spawnblock>0 Then tmap(x,y).spawnblock=tmap(x,y).spawnblock-3
                b=0
                For c=1 To lastenemy
                    If enemy(c).made=tmap(x,y).spawnswhat And enemy(c).hp>0 Then b=b+1
                Next
                If b<tmap(x,y).spawnsmax Then
                    d=getmonster()
                    enemy(d)=setmonster(makemonster(tmap(x,y).spawnswhat,slot),slot,spawnmask(),lsp,x,y,d)
                    If vismask(x,y)>0 Then rlprint tmap(x,y).spawntext,14
                EndIf
            EndIf
            If tmap(x,y).no=304 And nightday(x)=0 Then
                changetile(x,y,slot,4)
                d=getmonster()
                enemy(d)=setmonster(makemonster(102,slot),slot,spawnmask(),lsp,x,y,d)
                If vismask(x,y)>0 Then rlprint "The iceblock suddenly starts to move."
            EndIf
        Next
    Next
    For a=1 To lastenemy
        If enemy(a).hp<=0 And planets(slot).atmos>12 And rnd_range(1,100)>planets(slot).atmos Then enemy(a).hpmax=enemy(a).hpmax-1
        If enemy(a).hp<=0 Then enemy(a).hp=enemy(a).hp-1
        If enemy(a).hp<-45-diesize And enemy(a).respawns=1 And rnd_range(1,100)<(1+planets(slot).life)*5 Then
            enemy(a)=setmonster(planets(slot).mon_template(enemy(a).slot),slot,spawnmask(),lsp,,,a)
            planets(slot).life-=1
            If planets(slot).life<0 Then planets(slot).life=0
        EndIf
    Next
    Return lastenemy
End function

function ep_shipfire(shipfire() As _shipfire) As Short
    DimDebug(0)
    Dim As Short sf2,a,b,c,x,y,dam,slot,osx,ani,f,icechunkhole,dambonus
    Dim As Short dammap(60,20)
    Dim As String txt
    Dim As Single r,ed
    Dim p2 As _cords

    If rnd_range(1,100)<10 And planets(slot).flags(29)>0  Then icechunkhole=1
#if __FB_DEBUG__
    If debug=2 Then icechunkhole=1
    If debug=1 Then
        f=Freefile
        Open "sflog.txt" For Append As #f
            For a=0 To 16
                Print #f,shipfire(a).when;":";shipfire(a).where.x;":";shipfire(a).where.y;":"
            Next
        Close #f
    EndIf
#endif
    slot=player.map
    osx=calcosx(awayteam.c.x,planets(slot).depth)
    display_planetmap(slot,osx,0)
    For sf2=0 To 16
        If shipfire(sf2).when>0 Then
            shipfire(sf2).when-=1
            If shipfire(sf2).tile<>"" And vismask(shipfire(sf2).where.x,shipfire(sf2).where.y)>0 Then
                set__color( 7,0)
                Draw String (shipfire(sf2).where.x*_fw1,shipfire(sf2).where.y*_fh1),shipfire(sf2).tile,,Font1,custom,@_col
            EndIf
            If shipfire(sf2).when=0 Then
                tScreen.set(1)
                shipfire(sf2).tile=""
                b=rnd_range(1,6)+rnd_range(1,6)+maximum(player.sensors,player.gunner(0))
                If b>13 Then rlprint gainxp(2),c_gre
                b=b-8
                If b<0 Then
                    b=b*-1
                    c=rnd_range(1,8)
                    If c=5 Then c=9
                    For a=1 To b
                        If shipfire(sf2).what>10 Then shipfire(sf2).where=movepoint(shipfire(sf2).where,c)
                    Next
                EndIf
                r=CInt(player.weapons(shipfire(sf2).what).dam/2)
                dam=1
                If r<1 Then r=1
                If player.weapons(shipfire(sf2).what).ammomax>0 Then dambonus=player.loadout
                For a=1 To player.weapons(shipfire(sf2).what).dam+dambonus
                    dam=dam+rnd_range(1,3)
                Next
                Do
                    ani+=1
                    For x=shipfire(sf2).where.x-5 To shipfire(sf2).where.x+5
                        For y=shipfire(sf2).where.y-5 To shipfire(sf2).where.y+5
                            p2.x=x
                            p2.y=y
                            If x>=0 And y>=0 And x<=60 And y<=20 Then
                                If distance(shipfire(sf2).where,p2)<=r Then
                                    dammap(x,y)=dam/(1+distance(shipfire(sf2).where,p2))
                                    If dammap(x,y)<1 Then dammap(x,y)=1
                                    If configflag(con_tiles)=0 Then
                                        ed=2*distance(p2,shipfire(sf2).where)
                                        If ani-ed<1 Then ed=ani-1
                                        Put((x-osx)*_tix,y*_tiy),gtiles(gt_no(77+ani-ed)),trans
                                        Sleep 5
                                    Else
                                        If player.weapons(shipfire(sf2).what).ammomax>0 Then
                                            If x=shipfire(sf2).where.x And y=shipfire(sf2).where.y Then set__color( 15,15)
                                            If distance(shipfire(sf2).where,p2)>0 Then set__color( 12,14)
                                            If distance(shipfire(sf2).where,p2)>1 Then set__color( 12,0)
                                        Else
                                            If x=shipfire(sf2).where.x And y=shipfire(sf2).where.y Then set__color( 15,15)
                                            If distance(shipfire(sf2).where,p2)>0 Then set__color( 11,9)
                                            If distance(shipfire(sf2).where,p2)>1 Then set__color( 9,1)
                                        EndIf
                                        If shipfire(sf2).stun=1 Then
                                            If distance(shipfire(sf2).where,p2)>0 Then set__color( 242,244)
                                            If distance(shipfire(sf2).where,p2)>1 Then set__color( 246,248)
                                        EndIf
                                        
                                        Draw String ((x-osx)*_fw1,y*_fh1), Chr(178),,Font1,custom,@_col
                                    EndIf
                                EndIf
                            EndIf
                        Next
                    Next
                    
                    
                Loop Until ani>=8 Or configflag(con_tiles)=1
                                'Deal damage
                For a=1 To lastenemy
                    If dammap(enemy(a).c.x,enemy(a).c.y)>0 Then
                        If shipfire(sf2).stun=0 Then
                            enemy(a).hp=enemy(a).hp-dammap(enemy(a).c.x,enemy(a).c.y)
                            If vismask(enemy(a).c.x,enemy(a).c.y)>0 Then txt &= enemy(a).sdesc &" takes " &dammap(enemy(a).c.x,enemy(a).c.y)&" points of damage. "
                        Else
                            enemy(a).hpnonlethal=enemy(a).hpnonlethal+(dam*((10-enemy(a).stunres)/10))
                        EndIf
                        If enemy(a).hp<=0 Then
                            player.alienkills=player.alienkills+1
                        EndIf
                    EndIf
                Next
                            
                For x=shipfire(sf2).where.x-5 To shipfire(sf2).where.x+5
                    For y=shipfire(sf2).where.y-5 To shipfire(sf2).where.y+5
                        p2.x=x
                        p2.y=y
                        If x>=0 And y>=0 And x<=60 And y<=20 Then
                
                            If tmap(x,y).shootable>0 And shipfire(sf2).stun=0 And dammap(x,y)>0 Then
                                tmap(x,y).hp=tmap(x,y).hp-dammap(x,y)
                                If tmap(x,y).succt<>"" And vismask(x,y)>0 Then txt =txt & "The "&tmap(x,y).desc &" is damaged. " 
                                If tmap(x,y).hp<=0 Then
                                    If planetmap(x,y,slot)>0 Then planetmap(x,y,slot)=tmap(x,y).turnsinto
                                    If planetmap(x,y,slot)<0 Then planetmap(x,y,slot)=-tmap(x,y).turnsinto
                                    tmap(x,y)=tiles(tmap(x,y).turnsinto)
                                EndIf
                                If icechunkhole=1 Then
                                    If planetmap(x,y,slot)>0 Then planetmap(x,y,slot)=200
                                    If planetmap(x,y,slot)<0 Then planetmap(x,y,slot)=-200
                                    tmap(x,y)=tiles(200)
                                EndIf
                            EndIf
                        EndIf
                    
                    Next
                Next
                
                If dammap(awayteam.c.x,awayteam.c.y)>0 Then
                    txt=txt &"you got caught in the blast! "
                    If shipfire(sf2).stun=0 Then txt = txt & dam_awayteam(dammap(awayteam.c.x,awayteam.c.y),1) &" "
                    If shipfire(sf2).stun=1 Then awayteam.e.add_action(150)
                EndIf
                
                rlprint txt
                'sleep 100+distance(awayteam.c,shipfire(sf2).where)*6
				if (planets(slot).atmos>1) Then play_sound(4)
            EndIf
            If shipfire(sf2).what>10 Then
                player.weapons(shipfire(sf2).what)=make_weapon(0)
                player.killedby="short thrown grenade"
            Else
                player.killedby="explosion"
            EndIf
        EndIf
    Next
    Return 0
End function



function ep_helmet() As Short
    Dim As Short slot
    slot=player.map
    If awayteam.helmet=0 Then
        rlprint "Switching to suit oxygen supply.",c_yel
        awayteam.helmet=1
        'oxydep
    Else
        'Opening Helmets
        If planets(slot).atmos>=3 And planets(slot).atmos<=6 And vacuum(awayteam.c.x,awayteam.c.y)=0 Then
            awayteam.helmet=0
            awayteam.oxygen=awayteam.oxymax
            rlprint "Opening helmets",c_gre
        Else
            rlprint "We can't open our helmets here",c_yel
        EndIf
    EndIf
    equip_awayteam(slot)
    Return 0
End function


function grenade(from As _cords,map As Short) As _cords
    DimDebug(0)
    Dim As _cords target,ntarget
    Dim As Single dx,dy,x,y,launcher
    Dim As Short a,ex,r,t,osx
    Dim As String Key
    Dim As _cords p,pts(60*20)

    target.x=from.x
    target.y=from.y
    ntarget.x=from.x
    ntarget.y=from.y
    x=from.x
    y=from.y
    p=from
    launcher=findbest(17,-2)
    DbgPrint(""&launcher)
    If launcher>0 Then
        rlprint "Choose target"
        Do
            Key=planet_cursor(target,map,osx,1)
            ep_display(osx)
            display_awayteam(,osx)
            Key=Cursor(target,map,osx,,5+item(launcher).v1-planets(map).grav)
            If Key=key_te Or Ucase(Key)=" " Or Multikey(FB.SC_ENTER) Then ex=-1
            If Key=key_quit Or Multikey(FB.SC_ESCAPE) Then ex=1
        Loop Until ex<>0
    Else
        rlprint "Choose direction"
        Key=keyin("12346789"&" "&key__esc)
        If getdirection(Key)=0 Then
            ex=1
        Else
            r=3-planets(map).grav
            If getdirection(Key)=1 Then
                dx=-.7
                dy=.7
            EndIf
            If getdirection(Key)=2 Then
                dx=0
                dy=1
            EndIf
            If getdirection(Key)=3 Then
                dx=.7
                dy=.7
            EndIf
            If getdirection(Key)=4 Then
                dx=-1
                dy=0
            EndIf
            If getdirection(Key)=6 Then
                dx=1
                dy=0
            EndIf
            If getdirection(Key)=7 Then
                dx=-.7
                dy=-.7
            EndIf
            If getdirection(Key)=8 Then
                dx=0
                dy=-1
            EndIf
            If getdirection(Key)=9 Then
                dx=.7
                dy=-.7
            EndIf
        EndIf
    EndIf
    If ex=1 Then
        target.x=-1
        target.y=-1
    Else
        If launcher>0 Then
            r=line_in_points(target,from,pts())
            For a=1 To r
                If tmap(pts(a).x,pts(a).y).firetru=1 Then
                    Return pts(a)
                EndIf
            Next
            Return target
        Else

        For a=1 To r
            x=x+dx
            y=y+dy
            t=Abs(planetmap(x,y,map))
            If tiles(t).firetru=1 Then Exit For
        Next
        If planets(map).depth=0 Then
            If x<0 Then x=60
            If x>60 Then x=0
        Else
            If x<0 Then x=0
            If x>60 Then x=60
        EndIf
        If y<0 Then y=0
        If y>20 Then y=20
        target.x=x
        target.y=y
        EndIf
    EndIf
    DbgPrint(""&target.x &":"& target.y)
    Return target
End function


function ep_grenade(shipfire() As _shipfire, ByRef sf As Single) As Short
    Dim As Short c,slot,i,launcher,rof
    slot=player.map
    Dim As _cords p
    If configflag(con_chosebest)=0 Then
        c=findbest(7,-1)
    Else
        c=get_item(-1,7)
    EndIf
    launcher=findbest(17,-1)
    If c>0 Then

        If item(c).ty=7 Then
            p=grenade(awayteam.c,slot)
            If p.x>=0 Then

                Select Case item(c).v2
                Case 0,2
                    If launcher>0 Then rof=item(launcher).v2
                    For i=1 To 1+rof
                        If c>0 Then
                            sf=sf+1
                            If sf>15 Then sf=0

                            shipfire(sf).where=p
                            rlprint "Delay for the grenade?"
                            shipfire(sf).when=getnumber(1,5,1)
                            shipfire(sf).what=11+sf
                            If item(c).v2=2 Then shipfire(sf).stun=1
                            shipfire(sf).tile=item(c).ICON
                            player.weapons(shipfire(sf).what)=make_weapon(item(c).v1)
                            player.weapons(shipfire(sf).what).ammomax=1 'Sets set__color( to redish
                            item(c)=item(lastitem)
                            lastitem=lastitem-1
                            c=findbest(7,-1)
                        EndIf
                    Next
                Case 1
                    item(c).w.m=slot
                    item(c).w.s=0
                    item(c).w.p=0
                    item(c).w.x=p.x
                    item(c).w.y=p.y
                    itemindex.add(c,item(c).w)
                End Select
            Else
                rlprint "canceled"
            EndIf
        Else
            rlprint "That's not a grenade."
        EndIf
        awayteam.e.add_action(25)
    Else
        rlprint"You dont have any grenades"
    EndIf
    Return 0
End function

function ep_playerhitmonster(old As _cords, mapmask() As Byte) As Short
    Dim As Short a,b,slot,hitflag
    slot=player.map
    For a=1 To lastenemy
        If vismask(enemy(a).c.x,enemy(a).c.y)>0 And enemy(a).slot>=0 Then planets(slot).mon_seen(enemy(a).slot)=1
        If enemy(a).hp>0 Then
            If awayteam.c.x=enemy(a).c.x And awayteam.c.y=enemy(a).c.y Then
                If enemy(a).made<>101 Then
                    awayteam.e.add_action(10)
                    awayteam.c=old
                        If enemy(a).sleeping>0 Or enemy(a).hpnonlethal>enemy(a).hp Then
                            b=findworst(26,-1)
                            If b=-1 Then b=findworst(29,-1) 'Using traps
                            If b>0 Then
                                If askyn("The "&enemy(a).sdesc &" is unconcious. Do you want to capture it alive?(y/n)") Then
                                    If item(b).v1<item(b).v2 Then
                                        item(b).v1+=1
                                        lastcagedmonster+=1
                                        cagedmonster(lastcagedmonster)=enemy(a)
                                        cagedmonster(lastcagedmonster).c.s=b
                                        '
                                        reward(1)=reward(1)+get_biodata(enemy(a))
                                        item(b).v3+=get_biodata(enemy(a))
                                        enemy(a).hp=0
                                        enemy(a).hpmax=0
                                        If enemy(a).slot>=0 Then planets(slot).mon_caught(enemy(a).slot)+=1
                                        awayteam.e.add_action(25)
                                    Else
                                        rlprint "You don't have any unused cages."
                                    EndIf
                                EndIf
                            Else
                                rlprint "The "&enemy(a).sdesc &" is asleep."
                            EndIf
                        Else
                            If enemy(a).aggr=1 Then
                                If (askyn("Do you really want to attack the "&enemy(a).sdesc &"?(y/n)")) Then
                                    enemy(a)=hitmonster(enemy(a),awayteam,mapmask())
                                    hitflag=1
                                    If rnd_range(1,6)+rnd_range(1,6)<enemy(a).intel Then enemy(a).aggr=0
                                    For b=1 To lastenemy
                                        If a<>b Then
                                            If enemy(a).faction=enemy(b).faction And vismask(enemy(b).c.x,enemy(b).c.y)>0 Then
                                                enemy(b).aggr=0
                                                rlprint "The "&enemy(b).sdesc &" tries to help his friend!",14
                                            EndIf
                                        EndIf
                                    Next
                                Else
                                    rlprint "You squeeze past the "&enemy(a).sdesc &"."
                                    Swap awayteam.c,enemy(a).c
                                    enemy(a).add_move_cost
                                    awayteam.e.add_action(2)
                                    
                                EndIf
                            Else
                                awayteam.attacked=a
                                awayteam.e.add_action(awayteam.atcost)
                                enemy(a)=hitmonster(enemy(a),awayteam,mapmask())
                                hitflag=1
                            EndIf
                        EndIf
                    EndIf
                EndIf
            EndIf
    Next
    if hitflag=0 then awayteam.attacked=0
    Return 0
End function

function ep_fire(mapmask() As Byte,Key As String,ByRef autofire_target As _cords) As Short
    Static autofire_dir As Short
    Dim enlist(128) As Short
    Dim shortlist As Short
    Dim wp(80) As _cords
    Dim dam As Short
    Dim As Short first,last,lp,osx
    Dim As Short a,b,c,d,e,f,slot,x
    Dim As Short scol
    Dim As Single range
    Dim fired(60,20) As Byte
    Dim As _cords p,p1,p2
    Dim text As String
    slot=player.map
    osx=calcosx(awayteam.c.x,planets(slot).depth)
    make_locallist(slot)

    If configflag(con_tiles)=0 Then
        x=awayteam.c.x-osx
        If awayteam.movetype=mt_fly Or awayteam.movetype=mt_flyandhover Then Put (x*_tix,awayteam.c.y*_tiy),gtiles(gt_no(2002)),trans
        Put (x*_tix,awayteam.c.y*_tiy),gtiles(captain_sprite),trans
        If awayteam.movetype=mt_hover Or awayteam.movetype=mt_flyandhover Then Put (x*_tix,awayteam.c.y*_tiy+4),gtiles(gt_no(2001)),trans
    Else
        set__color( _teamcolor,0)
        Draw String (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col
    EndIf
    range=1.5
    If walking=0 Then
        If Key=key_fi Then rlprint "Fire direction ("& key_wait &" to chose target. "&key_layfire &" to divide fire)?"
        If Key=key_autofire Then rlprint "Fire direction?"
        no_key=keyin
        autofire_dir=getdirection(no_key)
    EndIf
    For a=1 To 128'awayteam.hp
        If crew(a).hp>0 And crew(a).onship=0 Then
            If awayteam.secweapran(a)>range Then range=awayteam.secweapran(a)
        EndIf
    Next

    scol= 7
    If range>=3 Then scol=11
    If range>=4 Then scol=12
    If range>=5 Then scol=10

    tScreen.set(1)

    If autofire_dir>0 And autofire_dir<>5 Then
        awayteam.e.add_action(awayteam.atcost)

        e=0
        p2.x=awayteam.c.x
        p2.y=awayteam.c.y
        Do
            If configflag(con_tiles)=0 Then
                If awayteam.movetype=mt_fly Or awayteam.movetype=mt_flyandhover Then Put ((awayteam.c.x-osx)*_tix,awayteam.c.y*_tiy),gtiles(gt_no(2002)),trans
                Put ((awayteam.c.x-osx)*_tix,awayteam.c.y*_tiy),gtiles(captain_sprite),trans
                If awayteam.movetype=mt_hover Or awayteam.movetype=mt_flyandhover Then Put ((awayteam.c.x-osx)*_tix,awayteam.c.y*_tiy+4),gtiles(gt_no(2001)),trans
            Else
                set__color( _teamcolor,0)
                Draw String (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col
            EndIf
            p2=movepoint(p2,autofire_dir,4)
            set__color( scol,0)
            If vismask(p2.x,p2.y)>0 Then
                If configflag(con_tiles)=0 Then
                    If range<4 Then
                        Put((p2.x-osx)*_tix,p2.y*_tiy),gtiles(gt_no(75)),trans
                    Else
                        Put((p2.x-osx)*_tix,p2.y*_tiy),gtiles(gt_no(76)),trans
                    EndIf
                Else
                    Draw String((p2.x-osx)*_fw1,p2.y*_fh1), "3",,Font1,custom,@_col
                EndIf
            EndIf
            c=c+1
            c=ep_fireeffect(p2,slot,c,range,mapmask())
        Loop Until c>=range
        If e=0 Then Sleep 100
        c=0
        p2.x=awayteam.c.x
        p2.y=awayteam.c.y
        If Key=key_autofire Then walking=10
    Else
        autofire_dir=-1
    EndIf

    If no_key=key_wait Then
        awayteam.e.add_action(awayteam.atcost)

        rlprint "Choose target" &range
        p=awayteam.c
        a=0
        Do
            If configflag(con_tiles)=0 Then
                If awayteam.movetype=mt_fly Or awayteam.movetype=mt_flyandhover Then Put ((awayteam.c.x-osx)*_tix,awayteam.c.y*_tiy),gtiles(gt_no(2002)),trans
                Put ((awayteam.c.x-osx)*_tix,awayteam.c.y*_tiy),gtiles(captain_sprite),trans
                If awayteam.movetype=mt_hover Or awayteam.movetype=mt_flyandhover Then Put ((awayteam.c.x-osx)*_tix,awayteam.c.y*_tiy+4),gtiles(gt_no(2001)),trans
            Else
                set__color( _teamcolor,0)
                Draw String (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col
            EndIf
            p1=p
            ep_display(osx)
            no_key=Cursor(p,slot,osx)
            If distance(p,awayteam.c)>range Then p=p1
            If no_key=key_te Or Ucase(no_key)=" " Or Multikey(FB.SC_ENTER) Then a=1
            If no_key=key_quit Or Multikey(FB.SC_ESCAPE) Then a=-1
        Loop Until a<>0
        autofire_target=p

        If a>0 Then
            If distance(awayteam.c,autofire_target)<=range Then

                lp=line_in_points(autofire_target,awayteam.c,wp())
                For b=1 To lp
                    set__color( scol,0)
                    If configflag(con_tiles)=0 Then
                        If range<4 Then
                            Put((wp(b).x-osx)*_tix,wp(b).y*_tiy),gtiles(gt_no(75)),trans
                        Else
                            Put((wp(b).x-osx)*_tix,wp(b).y*_tiy),gtiles(gt_no(76)),trans
                        EndIf
                    Else
                        Draw String((wp(b).x-osx)*_fw1,wp(b).y*_fh1), "*",,Font1,custom,@_col
                    EndIf
                    b=ep_fireeffect(wp(b),slot,b,lp,mapmask())
                    Sleep 15
                Next
            Else
                rlprint "Target out of range.",14
            EndIf
            Sleep 100
        EndIf
        If Key=key_autofire Then walking=11
    EndIf

    If no_key=key_layfire Then
        awayteam.e.add_action(awayteam.atcost)
        For a=1 To lastenemy
            If vismask(enemy(a).c.x,enemy(a).c.y)>0 And enemy(a).hp>0 And enemy(a).aggr=0 And distance(awayteam.c,enemy(a).c)<=range Then
                If pathblock(awayteam.c,enemy(a).c,slot,1) Then
                    shortlist+=1
                    enlist(shortlist)=a
                EndIf
            EndIf
        Next
        If shortlist>0 Then
            first=1
            last=Fix(awayteam.hpmax/shortlist)
            If last<1 Then last=1
            For a=1 To shortlist
                lp=line_in_points(enemy(enlist(a)).c,awayteam.c,wp())
                If lp>=1 Then
                    For b=1 To lp
                        If wp(b).x>=0 And wp(b).x<=60 And wp(b).y>=0 And wp(b).y<=20 Then
                            set__color( scol,0)
                            If configflag(con_tiles)=0 Then
                                If range<4 Then
                                    Put((wp(b).x-osx)*_tix,wp(b).y*_tiy),gtiles(gt_no(75)),trans
                                Else
                                    Put((wp(b).x-osx)*_tix,wp(b).y*_tiy),gtiles(gt_no(76)),trans
                                EndIf
                            Else
                                Draw String((wp(b).x-osx)*_fw1,wp(b).y*_fh1), "*",,Font1,custom,@_col
                            EndIf
                            fired(wp(b).x,wp(b).y)=1
                            b=ep_fireeffect(wp(b),slot,b,lp-1,mapmask(),first,last)
                        EndIf
                    Next
                EndIf
                first=first+last+1
            Next
            Sleep 100
        Else
            rlprint "No hostile targets in sight."
        EndIf
        autofire_dir=0

    EndIf
    Return 0
End function

function ep_closedoor() As Short
    Dim As Short a,slot
    Dim p1 As _cords
    slot=player.map
    awayteam.e.add_action(5)
    For a=1 To 9
        If a<>5 Then
            p1=movepoint(awayteam.c,a)
            If tmap(p1.x,p1.y).onclose<>0 Then
                rlprint "You close the "&tmap(p1.x,p1.y).desc &"."
                planetmap(p1.x,p1.y,slot)=tmap(p1.x,p1.y).onclose
                tmap(p1.x,p1.y)=tiles(Abs(planetmap(p1.x,p1.y,slot)))
                tmap(p1.x,p1.y).locked=0
            EndIf
        EndIf
    Next
    Return 0
End function


function mondis(enemy as _monster) as string
    dim text as string
    if enemy.hp<=0 then text=text &"A dead "
    text=text &enemy.ldesc
    if enemy.hpnonlethal>enemy.hp and enemy.hp>0 then
        text =text &". immobilized."
    else
        if enemy.hpmax=enemy.hp then
            text=text &". unhurt."
        else
            if enemy.hp>0 then
                if enemy.hp<2 then
                    text=text &". badly hurt."
                else
                    text=text &". hurt."
                endif
            endif
        endif
    endif
    if enemy.stuff(9)=0 then
    if rnd_range(1,6)+rnd_range(1,6)+player.science(1)>9 then enemy.stuff(10)=1
    if rnd_range(1,6)+rnd_range(1,6)+player.science(1)>10 then enemy.stuff(11)=1
    if rnd_range(1,6)+rnd_range(1,6)+player.science(1)>11 then enemy.stuff(12)=1
    enemy.stuff(9)=enemy.stuff(10)+enemy.stuff(11)+enemy.stuff(12)
    endif
    if enemy.stuff(10)=1 then text=text &" (" &enemy.hpmax &"/" &enemy.hp &")"
    if enemy.stuff(11)=1 then text=text &" W:" &enemy.weapon
    if enemy.stuff(12)=1 then text=text &" A:" &enemy.armor
    if enemy.hp>0 and enemy.aggr=0 then text=text &" it is attacking!"
    return text
end function


function ep_examine() As Short
    DimDebug(0)
    Dim As _cords p2,p3
    Dim As String Key,text
    Dim As Short a,deadcounter,slot,osx,x
    Dim As _cords ship

    ship=player.landed
    slot=player.map
    p2.x=awayteam.c.x
    p2.y=awayteam.c.y
    Do
        Cls
        p3=p2
        osx=calcosx(p3.x,planets(slot).depth)
        make_vismask(awayteam.c,awayteam.sight,slot)
        display_planetmap(slot,osx,0)
        ep_display(osx)
        display_awayteam(,osx)
        rlprint ""
        Key=Cursor(p2,slot,osx)
        If p3.x<>p2.x Or p3.y<>p2.y Then
            If p2.x<0 Then
                If planets(slot).depth=0 Then
                    p2.x=0
                Else
                    p2.x=60
                EndIf
            EndIf
            If p2.x>60 Then
                If planets(slot).depth=0 Then
                    p2.x=60
                Else
                    p2.x=0
                EndIf
            EndIf
            If p2.y<0 Then p2.y=0
            If p2.y>20 Then p2.y=20
            If distance(p2,awayteam.c)<=awayteam.sight And vismask(p2.x,p2.y)>0 Then
                text=add_a_or_an(tmap(p2.x,p2.y).desc,1)&". "
                For a=0 To lastportal
                    If p2.x=portal(a).from.x And p2.y=portal(a).from.y And slot=portal(a).from.m Then text=text & portal(a).desig &". "
                    If p2.x=portal(a).dest.x And p2.y=portal(a).dest.y And slot=portal(a).dest.m And portal(a).oneway=0 Then text= text &portal(a).desig &". "
#if __FB_DEBUG__
                    If debug=9 And p2.x=portal(a).from.x And p2.y=portal(a).from.y And slot=portal(a).from.m Then text=text &a &":"&portal(a).from.m &"dest:"& portal(a).dest.m &":"& portal(a).dest.x &":"& portal(a).dest.y &"oneway:"&portal(a).oneway
#endif
                Next
                
                if itemindex.last(p2.x,p2.y)>0 then
                    For a=1 To itemindex.last(p2.x,p2.y)
                        If item(itemindex.value(a)).w.p=0 And item(itemindex.value(a)).w.s=0 Then
                            text=text & item(itemindex.value(a)).desig & ". "
                            'if show_all=1 then text=text &"("&item(li(a)).w.x &" "&item(li(a)).w.y &" "&item(li(a)).w.p &" "&localitem(a).w.s &" "&localitem(a).w.m &")"
                        EndIf
                    Next
                endif
                
                For a=1 To lastenemy
                    If enemy(a).c.x=p2.x And enemy(a).c.y=p2.y And enemy(a).hpmax>0 Then
                        If enemy(a).hp>0 Then
                            If enemy(a).c.x=p2.x And enemy(a).c.y=p2.y Then
                                set__color( enemy(a).col,9)
                                text=text &" "& mondis(enemy(a)) '&"faction"&enemy(a).faction &"aggr" &enemy(a).aggr
                            Else
                                set__color( enemy(a).col,0)
                            EndIf
                            If configflag(con_tiles)=0 Then
                                Put ((enemy(a).c.x-osx)*_tix,enemy(a).c.y*_tiy),gtiles(gt_no(enemy(a).ti_no)),trans
                            Else
                                Draw String (enemy(a).c.x*_fw1,enemy(a).c.y*_fh1), Chr(enemy(a).tile),,Font1,custom,@_col
                            EndIf
                        Else
                            set__color( 12,0)
                            If configflag(con_tiles)=0 Then
                                 Put ((enemy(a).c.x-osx)*_tix,enemy(a).c.y*_tix),gtiles(261),trans
                            Else
                                Draw String (enemy(a).c.x*_fw1,enemy(a).c.y*_fh1), "%",,Font1,custom,@_col
                            EndIf
                            text=text & mondis(enemy(a))
#if __FB_DEBUG__
                            text=text &"("&a &" of "&lastenemy &")"
#endif
                        EndIf
                        Exit For 'there won't be more than one monster on one tile
                    EndIf
                Next
            EndIf
            If text<>"" Then rlprint text
            text=""
        EndIf
    Loop Until Key=key__enter Or Key=key__esc Or Ucase(Key)="Q"
    Return 0
End function

function ep_jumppackjump() As Short
    Dim As Short a,b,d,slot
    slot=player.map
    awayteam.e.add_action(10)
    If awayteam.jpfuel>2 Then
        awayteam.jpfuel=awayteam.jpfuel-3
        If planets(slot).depth=0 Or slot=specialplanet(9) Or slot=specialplanet(4) Or slot=specialplanet(3) Then
            b=rnd_range(1,4)+rnd_range(1,4)-planets(slot).grav
            rlprint "Direction?"
            d=getdirection(keyin())
            If d=4 Then d=d+1
            If b<2 Then b=2
            For a=1 To b
                If rnd_range(1,6)+rnd_range(1,6)>7 Then d=bestaltdir(d,rnd_range(0,1))
                dtile(awayteam.c.x,awayteam.c.y,tmap(awayteam.c.x,awayteam.c.y),1)

                awayteam.c=movepoint(awayteam.c,d)
                set__color( _teamcolor,0)
                Draw String (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col
                Sleep 50
            Next
            awayteam.oxygen=awayteam.oxygen-5
            If rnd_range(1,6)+rnd_range(1,6)+planets(slot).grav>7 Then
                rlprint "Crash Landing! " &dam_awayteam(rnd_range(1,1+planets(slot).grav))
            Else
                rlprint "You land savely"
            EndIf
        Else
            rlprint "you hit the ceiling pretty fast! "&dam_awayteam(rnd_range(1,1+planets(slot).grav))
        EndIf
    Else
        rlprint "Not enough jetpack fuel"
    EndIf
    Return 0
End function


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tExploreplanet -=-=-=-=-=-=-=-
	tModule.register("tExploreplanet",@tExploreplanet.init()) ',@tExploreplanet.load(),@tExploreplanet.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tExploreplanet -=-=-=-=-=-=-=-
#endif'test
