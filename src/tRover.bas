'tRover

Function ep_roverreveal(i As Integer) As Short
    Dim As Short x,y,slot,j
    Dim As Single d
    Dim As _cords p1
    slot=item(i).w.m
    make_vismask(item(i).w,item(i).v1+3,slot)
    For x=0 To 60
        For y=0 To 20
            If vismask(x,y)>0 And planetmap(x,y,slot)<0 Then
                planetmap(x,y,slot)=planetmap(x,y,slot)*-1
                item(i).v6=item(i).v6+0.5*(item(i).v1/3)*planets(slot).mapmod
                if itemindex.last(x,y)>0 then
                    for j=1 to itemindex.last(x,y)
                        item(itemindex.index(x,y,j)).discovered=1
                    next
                endif
            EndIf
        Next
    Next
    Return 0
End Function


function ep_rovermove(a as short, slot as short) as short
    dim as _cords p1,route(1024)
    dim as short i,cost,last               
    p1.x=item(a).w.x
    p1.y=item(a).w.y
    if item(a).v3<=0 then
        If item(a).vt.x=-1 Then
            last=ep_autoexploreroute(route(),p1,item(a).v2,slot,1)
            DbgPrint("last:"&last)
            if last=-1 then return 0
            item(a).vt=route(last)
        Else
            If item(a).w.x=item(a).vt.x And item(a).w.y=item(a).vt.y Then 
                item(a).vt.x=-1
                return 0
            else
                last=ep_planetroute(route(),item(a).v2,p1,item(a).vt,planets(slot).depth)
            endif
        EndIf
        If last>1 Then
            itemindex.move(a,item(a).w,route(2))
            item(a).w.x=route(2).x
            item(a).w.y=route(2).y
        EndIf
        if last=1 then
            itemindex.move(a,item(a).w,route(1))
            item(a).w.x=route(1).x
            item(a).w.y=route(1).y
        endif
        ep_roverreveal(a)
        
        cost=(20-item(a).v4)*planets(slot).grav
        cost+=tmap(item(a).w.x,item(a).w.y).movecost
        if cost<=0 then cost=1
        item(a).v3+=cost
    else
        item(a).v3-=1
        if item(a).v3<0 then item(a).v3=0
        DbgPrint("V6"&item(a).v3)
    endif
    return 0
end function


function update_tmap(slot as short) as short
    dim as short x,y,x1,y1
    if slot<0 then return 0
    erase tmap
    for x=0 to 60
        for y=0 to 20
            tmap(x,y)=tiles(abs(planetmap(x,y,slot)))
        next
    next
    for x=0 to 60
        for y=0 to 20
            if tmap(x,y).no=200 then
                vacuum(x,y)=1
                for x1=x-1 to x+1
                    for y1=y-1 to y+1
                        if x1>=0 and x1<=60 and y1>=0 and y1<=20 then
                            if tmap(x1,y1).no<>200 then
                                tmap(x,y).walktru=0
                                tmap(x,y).desc="Hullsurface"
                            endif
                        endif
                    next
                next
            else
                vacuum(x,y)=0
            endif
        next
    next
    return 0
end function


Function move_rover(pl As Short)  As Short
    Dim As Integer a,b,c,i,t,ti,x,y
    Dim As Integer carn,herb,mins,oxy,food,energy,curr,last
    Dim As Single minebase
    Dim As _cords p1,p2,route(1281)
    Dim As _cords pp(9)

    update_tmap(pl)
    make_locallist(pl)
    t=(gameturn-planets(pl).visited)
    'If _debug=9 Then Screenset 1,1
    For i=1 To itemindex.vlast
        If item(itemindex.value(i)).ty=18 And item(itemindex.value(i)).w.p=0 And item(itemindex.value(i)).w.s=0 And item(itemindex.value(i)).w.m=pl And item(itemindex.value(i)).discovered>0 And t>0 Then
            ep_rovermove(itemindex.value(i),pl)
            if rnd_range(1,150)<planets(pl).atmos*2 Then item(itemindex.value(i)).discovered=0
            If rnd_range(1,150)<planets(pl).atmos+2 Then
                item(itemindex.value(i))=make_item(65)
            Else
                rlprint "Receiving the homing signal of a rover on this planet from " &cords(item(itemindex.value(i)).w),10
            EndIf
        EndIf
    Next
    i=0
    For a=1 To lastitem
        If item(a).ty=27 And item(a).w.p=0 And item(a).w.s=0 And item(a).w.m=pl Then i=a
        If item(a).ty=15 And item(a).w.p=0 And item(a).w.s=0 And item(a).w.m=pl Then
            minebase+=1.1
            If rnd_range(1,100)<10 Then destroyitem(a)
        EndIf
    Next
    If i>0 And t>0 Then
        p1.x=item(i).w.x
        p1.y=item(i).w.y
        For x=0 To 60
            For y=0 To 20
                p2.x=x
                p2.y=y
                If Abs(planetmap(x,y,pl))=13 Then minebase=minebase+2/distance(p1,p2)
                If Abs(planetmap(x,y,pl))=7 Or Abs(planetmap(x,y,pl))=8 Then minebase=minebase+1/distance(p1,p2)
            Next
        Next
        minebase=minebase+planets(pl).minerals
        minebase=minebase+planets(pl).atmos
        minebase=minebase+planets(pl).grav
        minebase=minebase+planets(pl).depth
        If sysfrommap(pl)>0 Then
            minebase=minebase+Abs(spacemap(map(sysfrommap(pl)).c.x,map(sysfrommap(pl)).c.y))
        Else
            minebase=minebase+planets(pl).depth
        EndIf
        item(i).v1=item(i).v1+0.01*minebase*t*item(i).v3
        If item(i).v1>item(i).v2 Then item(i).v1=item(i).v2
        If rnd_range(1,150)<planets(pl).atmos+2 Then item(i)=make_item(66)
    EndIf
    planets(pl).visited=gameturn
    Return 0
End Function

