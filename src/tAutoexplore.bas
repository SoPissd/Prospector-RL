'tAutoexplore


function ep_needs_spacesuit(slot As Short,c As _cords,ByRef reason As String="") As Short
    Dim dam As Short
    dam=0
    If planets(slot).atmos=1 Or vacuum(c.x,c.y)=1 Then
        reason="vacuum, "
        dam=10
    EndIf
    If planets(slot).atmos=2 Or planets(slot).atmos>=7 Then
        If planets(slot).atmos=2 Then
            reason &= "not enough oxygen, "
        Else
            reason &="no oxygen, "
        EndIf
        dam=5
    EndIf
    If planets(slot).atmos>12 Then dam+=planets(slot).atmos/2
    If planets(slot).temp<-60 Or planets(slot).temp>60 Then
        dam=dam+Abs(planets(slot).temp/60)
        reason=reason &"extreme temperatures, "
    EndIf
    If reason<>"" Then reason=first_uc(Left(reason,Len(reason)-2))
    If dam>50 Then dam=50
    Return dam
End function



function ep_atship() As Short
    Dim As Short slot,a
    slot=player.map
DbgLogExplorePlanet("ep_atship")
    If awayteam.c.y=player.landed.y And awayteam.c.x=player.landed.x And slot=player.landed.m Then
        location=lc_onship
        rlprint "You are at the ship. Press "&key_la &" to launch."
        If awayteam.oxygen<awayteam.oxymax Then rlprint "Refilling oxygen.",10
        awayteam.oxygen=awayteam.oxymax
        If (awayteam.movetype=2 Or awayteam.movetype=3) And awayteam.jpfuel<awayteam.jpfuelmax Then
            rlprint "Refilling Jetpacks",10
            awayteam.jpfuel=awayteam.jpfuelmax
        EndIf
        For a=1 To 128
            If crew(a).hp>0 Then
                If crew(a).disease>0 And crew(a).onship=0 Then
                    crew(a).oldonship=crew(a).onship
                    crew(a).onship=1
                    rlprint crew(a).n &" is sick and stays at the ship."
                EndIf
                If crew(a).disease=0 And crew(a).onship=0 Then
                    crew(a).onship=crew(a).oldonship
                    crew(a).oldonship=0
                EndIf
            EndIf
        Next
        if awayteam.leak>0 then 
            repair_spacesuits()
        endif
        check_tasty_pretty_cargo
        alerts()
        Return 0
    Else
        location=lc_awayteam
        'rlprint ""&ep_Needs_spacesuit(slot,awayteam.c)
        If ep_Needs_spacesuit(slot,awayteam.c)>0 Then
            rlprint dam_awayteam(rnd_range(1,ep_needs_spacesuit(slot,awayteam.c)),5)
        EndIf
        Return 0
    EndIf
End function

function ep_planetroute(route() As _cords,move As Short,start As _cords, target As _cords,rollover As Short) As Short
    Dim As Short x,y,astarmap(60,20)
    For x=0 To 60
        For y=0 To 20
            astarmap(x,y)=tmap(x,y).walktru+tmap(x,y).gives+tmap(x,y).dam
            If move<tmap(x,y).walktru Then astarmap(x,y)=1500
            If tmap(x,y).onopen<>0 Then astarmap(x,y)=0
            If tmap(x,y).no=45 Then astarmap(x,y)=1500
        Next
    Next
    Return a_star(route(),target,start,astarmap(),60,20,0,rollover)
End function

function ep_autoexploreroute(astarpath() As _cords,start As _cords,move As Short, slot As Short, rover As Short=0) As Short
    Dim As Short candidate(60,20)
    Dim As Short x,y,explored,notargets,last,i,rollover
    Dim As Single d2,d
    Dim As _cords target,target2,p,path(1283)
    For x=0 To 60
        For y=0 To 20
            If move<tmap(x,y).walktru Then candidate(x,y)=1
            If tmap(x,y).onopen<>0 Then candidate(x,y)=0
        Next
    Next
    flood_fill(start.x,start.y,candidate(),3)
    If planets(slot).depth>0 Then
        rollover=0
    Else
        rollover=1
    EndIf
#if __FB_DEBUG__
    Screenset 1,1
    For x=0 To 60
        For y=0 To 20
            If candidate(x,y)=255 Then Pset(x,y)
        Next
    Next
#endif
    d2=61*21
    If rover=0 Then
        For i=1 To itemindex.vlast'Can't look up location
            If item(itemindex.value(i)).discovered>0 And candidate(item(itemindex.value(i)).w.x,item(itemindex.value(i)).w.y)=255 Then
                If item(itemindex.value(i)).w.s=0 And item(itemindex.value(i)).w.p=0 Then
                    p.x=item(itemindex.value(i)).w.x
                    p.y=item(itemindex.value(i)).w.y
                    If distance(p,start,rollover)<d2 And distance(p,start)>0 Then
                        d2=distance(p,start)
                        notargets+=1
                        target2.x=item(itemindex.value(i)).w.x
                        target2.y=item(itemindex.value(i)).w.y
                    EndIf
                EndIf
            EndIf
        Next
    EndIf
    
    d=61*21
    For x=0 To 60
        For y=0 To 20
            If x<>start.x Or y<>start.y Then
                 If candidate(x,y)=255 And planetmap(x,y,slot)<0 Then
                    p.x=x
                    p.y=y
                    If distance(p,start,rollover)<d Then
                        target.x=p.x
                        target.y=p.y
                        d=distance(p,start,rollover)
                        notargets+=1
                    EndIf
                EndIf
            EndIf
        Next
    Next
    If notargets=0 Then
        if rover=0 then
            target.x=player.landed.x
            target.y=player.landed.y
        else
            target.x=start.x
            target.y=start.y
            return -1
        endif
    Else
        DbgPrint(d &":"& target.x &":"&target.y &"-"&d2 &":"& target2.x &":"&target2.y)
        If d2<d Then
            target.x=target2.x
            target.y=target2.y
        EndIf
    EndIf
    If target.x=start.x And target.y=start.y Then Return -1
    last=ep_planetroute(path(),move,start,target,rollover)
    If last=-1 Then Return -1
    For i=0 To last
        astarpath(i+1).x=path(i).x
        astarpath(i+1).y=path(i).y
    Next
    last+=1
    Return last
End function

function ep_autoexplore(slot As Short) As Short
    Dim As Short x,y,astarmap(60,20),candidate(60,20),explored,notargets,x1,y1,i

    Dim d As Single
    Dim As _cords p,target,astarpath(1284)
    Dim As Byte debug=0
    For x=0 To 1024
        apwaypoints(x).x=0
        apwaypoints(x).y=0
    Next

    lastapwp=ep_autoexploreroute(astarpath(),awayteam.c,awayteam.movetype,slot)
    If lastapwp>0 Then
        For i=1 To lastapwp
            apwaypoints(i).x=astarpath(i).x
            apwaypoints(i).y=astarpath(i).y
        Next
    EndIf
    Return lastapwp
End function
