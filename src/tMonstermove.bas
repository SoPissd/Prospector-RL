' tMonstermove


Function monsterhit(attacker As _monster, defender As _monster,vis As Byte) As _monster
    DimDebug(0)
    Dim mname As String
    Dim text As String
    Dim a As Short
    Dim b As Short
    Dim noa As Short
    Dim col As Short
    if attacker.hp<=0 or defender.hp<=0 then return defender
    DbgPrint(attacker.sdesc &":"&defender.sdesc)
    If vis>0 Then
        If attacker.stuff(1)=1 And attacker.stuff(2)=1 Then mname="flying "
        mname=mname & attacker.sdesc
        text="The "
    Else
        mname="Something"
    EndIf
    If distance(attacker.c,defender.c)<1.5 Then
        text=text &mname &" attacks: "
    Else
        text=text &mname &" "&attacker.swhat &": "
        col=14
    EndIf
    noa=attacker.hp\7
    If noa<1 Then noa=1
    For a=1 To noa
        If skill_test(-defender.armor\(6*(defender.hp+1))+attacker.weapon,13+defender.movetype*5) Then b=b+1+attacker.weapon
    Next
    If b>attacker.weapon+5+noa/2 Then b=attacker.weapon+5+noa/2 'max damage
    If defender.made=0 Then
        If b>0 Then
            text=text & dam_awayteam(b,,attacker.disease)
            col=12
        Else
            text=text & " no casualties."
            col=10
        EndIf
        If defender.hp<=0 Then 
            player.killedby=attacker.sdesc
            player.dead=3
        endif
        rlprint text,col
    Else
        defender.hp=defender.hp-b 'Monster attacks monster
        If defender.hp<=0 Then defender.killedby=attacker.made
    EndIf
    attacker.e.add_action(attacker.atcost)
    DbgPrint("dam:"& b)
    Return defender
End Function


Function ep_changemood(i As Short,message() As Byte) As Short
    Dim As Short b,cmoodto
    If distance(awayteam.c,enemy(i).c)<enemy(i).sight Then 
        If enemy(i).aggr=1 And enemy(i).made<>101 Then
            If rnd_range(1,100)>(20+enemy(i).diet)*distance(enemy(i).c,awayteam.c) Then
                If rnd_range(1,6)+rnd_range(1,6)>8+enemy(i).diet+awayteam.invis+enemy(i).cmmod And enemy(i).sleeping<1 Then
                    Select Case enemy(i).diet
                    Case Is=1
                        cmoodto=1
                    Case Is=2
                        If rnd_range(1,100)<50-enemy(i).hp Then
                            cmoodto=2
                        Else
                            cmoodto=1
                        EndIf
                    Case Is=3
                        If rnd_range(1,100)<75-enemy(i).hp Then
                            cmoodto=2
                        Else
                            cmoodto=1
                        EndIf
                    Case Else
                        cmoodto=1
                    End Select
                    enemy(i).aggr=cmoodto
                    If vismask(enemy(i).c.x,enemy(i).c.y)>0 And message(0)=0 Then
                        enemy(i).cmshow=1
                        message(0)=1
                        If cmoodto=1 Then rlprint "The "&enemy(i).sdesc &" suddenly seems agressive",14
                        If cmoodto=2 Then rlprint "The "&enemy(i).sdesc &" suddenly seems afraid",14
                    EndIf                         
                    b=enemy(i).nearestfriend
                    If b>0 Then
                        message(1)=1
                        enemy(b).aggr=cmoodto
                        enemy(b).cmshow=1
                        rlprint "The "&enemy(b).sdesc &" tries to help its friend!",14
                    EndIf
                EndIf
            EndIf
            
        EndIf
    EndIf
    Return 0
End Function


Function move_monster(i As short, target As _cords,flee as byte,rollover as byte,mapmask() As Byte) As short
    dim as short x,y,x1,y1,ti,j,addp,k,t
    dim as _cords p(8)
    dim as single pd(8)
    for x=enemy(i).c.x-1 to enemy(i).c.x+1
        for y=enemy(i).c.y-1 to enemy(i).c.y+1
            if x<>enemy(i).c.x or y<>enemy(i).c.y then
                x1=x
                y1=y
                addp=0
                if y1>=0 and y<=20 then
                    if x1>=0 and x1<=60 or rollover>0 then
                        if x1<0 then x1+=61
                        if x1>60 then x1-=61
                        ti=tmap(x1,y1).walktru
                        If mapmask(x1,y1)<>0 Then addp=1
                        if enemy(i).hasoxy=0 and vacuum(x1,y1)=1 and vacuum(enemy(i).c.x,enemy(i).c.y)=0 then addp=1
                        If ti>0 Then
                            Select Case enemy(i).movetype
                            Case mt_climb
                                If ti=1 Or ti=5 Then addp=1
                            Case mt_dig
                                If ti=1 Then addp=1
                            Case mt_fly2
                                If ti>4 Then addp=1
                            Case mt_ethereal
                                'Can move through anything
                            Case Else
                                If ti>enemy(i).movetype Then addp=1
                            End Select
                        EndIf
                        if addp=0 then
                            j+=1
                            p(j).x=x1
                            p(j).y=y1
                            pd(j)=distance(p(j),target,rollover)
                        endif
                    endif
                endif
            endif
        next
    next
    
    if flee=1 then 'move away
        for k=1 to j
            if pd(k)>pd(0) then
                t=k
                pd(0)=pd(k)
            endif
        next
    else
        pd(0)=9999
        for k=1 to j
            if pd(k)<pd(0) then
                t=k
                pd(0)=pd(k)
            endif
        next
    endif
        
    if t>0 then
        mapmask(enemy(i).c.x,enemy(i).c.y)=0
        enemy(i).c=p(t)
        mapmask(enemy(i).c.x,enemy(i).c.y)=i
        enemy(i).add_move_cost
        enemy(i).attacked=0
    endif
        
'    
    Return 0
End Function


Function ep_monsterupdate(i As Short, spawnmask() as _cords,lsp as short,mapmask() As Byte,nightday() As Byte,message() As Byte) As Short
    Dim As Short slot,b,j
    slot=awayteam.slot
    mapmask(enemy(i).c.x,enemy(i).c.y)=i
    
    If enemy(i).made=102 And nightday(enemy(i).c.x)=3 Then
        If vismask(enemy(i).c.x,enemy(i).c.y)>0 And message(2)=0 Then
            rlprint "The icetroll slowly stops moving."
            message(2)=1
        EndIf
        changetile(enemy(i).c.x,enemy(i).c.y,slot,304)
        enemy(i).hp=0
        enemy(i).hpmax=0
    EndIf
    

    If rnd_range(1,100)<enemy(i).breedson And enemy(i).breedson>0 And lastenemy<255 Then
        If enemy(i).made<>101 Or tmap(enemy(i).c.x,enemy(i).c.y).vege>0 Then
            If enemy(i).made=101 Then
                tmap(enemy(i).c.x,enemy(i).c.y).vege-=1 'Tribbles only multiply when they have something to eat
                If tmap(enemy(i).c.x,enemy(i).c.y).vege<=0 Then changetile(enemy(i).c.x,enemy(i).c.y,slot,4)
                lastenemy+=1
                enemy(lastenemy).c=movepoint(enemy(i).c,5)
                enemy(lastenemy)=setmonster(makemonster(101,slot),slot,spawnmask(),lsp,enemy(lastenemy).c.x,enemy(lastenemy).c.y)
            Else
                lastenemy=lastenemy+1
                enemy(lastenemy)=enemy(0)
                enemy(lastenemy).c=movepoint(enemy(i).c,5)
                If tmap(enemy(lastenemy).c.x,enemy(lastenemy).c.y).walktru=0 Or enemy(i).movetype>=tmap(enemy(lastenemy).c.x,enemy(lastenemy).c.y).walktru Then
                    enemy(lastenemy)=setmonster(planets(slot).mon_template(enemy(i).slot),slot,spawnmask(),lsp,enemy(lastenemy).c.x,enemy(lastenemy).c.y,enemy(i).slot)
                    If vismask(enemy(i).c.x,enemy(i).c.y)>0 Or vismask(enemy(lastenemy).c.x,enemy(lastenemy).c.y)>0 Then rlprint "the "&enemy(i).sdesc &" multiplies!"
                Else
                    lastenemy-=1
                EndIf
            EndIf
        EndIf
    EndIf
    
    If enemy(i).hp<enemy(i).hpmax Then
        enemy(i).hp=enemy(i).hp+enemy(i).hpreg
        If enemy(i).hp>enemy(i).hpmax Then
            enemy(i).hp=enemy(i).hpmax
            If enemy(i).aggr>0 And rnd_range(1,distance(enemy(i).c,awayteam.c))>enemy(i).intel Then enemy(i).aggr=enemy(i).aggr-1
        EndIf
    EndIf    
    
    If enemy(i).hasoxy=0 And (planets(slot).atmos=1 Or vacuum(enemy(i).c.x,enemy(i).c.y)=1) Then
        enemy(i).hp=enemy(i).hp-1
        If vismask(enemy(i).c.x,enemy(i).c.y)>0 Then rlprint "The "&enemy(i).sdesc &" is struggling for air!"
    EndIf
    
    If enemy(i).sleeping>0 Then enemy(i).sleeping-=(1+enemy(i).reg)
    
    If enemy(i).nocturnal=1 Then
        If nightday(enemy(i).c.x)=3 Then
            If enemy(i).sleeping<=0 And rnd_range(1,6)+rnd_range(1,6)<enemy(i).intel Then enemy(i).invis=3
            enemy(i).sleeping=2
        Else
            enemy(i).sleeping-=1
            If enemy(i).sleeping<=0 And enemy(i).invis=3 Then enemy(i).invis=0
        EndIf
    EndIf
    If enemy(i).nocturnal=2 Then
        If nightday(enemy(i).c.x)=0 Then
            If enemy(i).sleeping<=0 And rnd_range(1,6)+rnd_range(1,6)<enemy(i).intel Then enemy(i).invis=3
            enemy(i).sleeping=2
        Else
            enemy(i).sleeping-=1
            If enemy(i).sleeping<=0 And enemy(i).invis=3 Then enemy(i).invis=0
        EndIf
    EndIf
    if itemindex.last(enemy(i).c.x,enemy(i).c.y)>0 then
        for j=1 to itemindex.last(enemy(i).c.x,enemy(i).c.y)
            b=itemindex.index(enemy(i).c.x,enemy(i).c.y,j)
        'if debug=120 then rlprint b &";"& item(li(b)).w.s
            If item(b).w.x=enemy(i).c.x And item(b).w.y=enemy(i).c.y And enemy(i).hp>0 And item(b).w.s=0 And item(b).w.p<>9999 Then
                Select Case item(b).ty
                Case 21 Or 22
                    item(b).w.p=9999
                    If item(b).ty=21 Then enemy(i).hp=enemy(i).hp-rnd_range(1,item(b).v1)
                    If item(b).ty=22 Then enemy(i).sleeping=enemy(i).sleeping+rnd_range(1,item(b).v1)
                    If vismask(enemy(i).c.x,enemy(i).c.y)>0 Then
                        set__color( item(b).col,1)
                        Draw String (item(b).w.x*_fw1,item(b).w.y*_fh1), Chr(176),,font2,custom,@_col
                        rlprint "The mine explodes under the "&enemy(i).sdesc &"!"
                    EndIf
                Case 29 'Monster steps on Trap
                    If item(b).v1<item(b).v2 Then
                        If rnd_range(1,6)+rnd_range(1,6)+item(b).v2-enemy(i).hp/2-enemy(i).intel>0 And enemy(i).intel<5 Then
                            'caught
                            item(b).v3=50*enemy(i).biomod+CInt(2*enemy(i).biomod*(enemy(i).hpmax^2)/3)'reward
                            item(b).v1+=1
                            item(b).ldesc = item(b).ldesc & " | "&enemy(i).sdesc
                            If vismask(enemy(i).c.x,enemy(i).c.y)>0 Then rlprint "The "&enemy(i).sdesc &" gets caught in the trap."
                            enemy(i)=enemy(lastenemy)
                            lastenemy-=1
                        Else
                            'evaded
                            If rnd_range(1,6)+rnd_range(1,6)+item(b).v2-enemy(i).hp/2-enemy(i).intel<0 Then'
                                'monster destroys trap
                                If vismask(enemy(i).c.x,enemy(i).c.y)>0 Then rlprint "The "&enemy(i).sdesc &" notices the trap and destroys it."
                                item(b).w.p=9999
                            Else
                                If vismask(enemy(i).c.x,enemy(i).c.y)>0 Then rlprint "The "&enemy(i).sdesc &" notices the trap."
                            EndIf
                        EndIf
                    EndIf
                end select
            endif
        next
    endif
    
    if enemy(i).invis=2 and enemy(i).aggr=0 and distance(enemy(i).c,awayteam.c)<2 then
        enemy(i).invis=0
        rlprint "A clever "&enemy(i).sdesc &" has been hiding here, waiting for prey!",c_yel
    endif
    
    
    if enemy(i).diet=4 and enemy(i).pickup=-1 and enemy(i).target.x=enemy(i).c.x and enemy(i).target.y=enemy(i).c.y then
        'Launch
        tmap(enemy(i).c.x,enemy(i).c.y)=tiles(4)
        If planetmap(enemy(i).c.x,enemy(i).c.y,slot)>0 Then planetmap(enemy(i).c.x,enemy(i).c.y,slot)=4
        If planetmap(enemy(i).c.x,enemy(i).c.y,slot)<0 Then planetmap(enemy(i).c.x,enemy(i).c.y,slot)=-4
        If vismask(enemy(i).c.x,enemy(i).c.y)>0 Then
            If tmap(enemy(i).c.x,enemy(i).c.y).no=86 Then
                rlprint "The other scoutship launches."
                companystats(basis(nearest_base(player.c)).company).profit+=1
            EndIf
            If tmap(enemy(i).c.x,enemy(i).c.y).no=272 Or tmap(enemy(i).c.x,enemy(i).c.y).no=273 Then rlprint "The alien ship launches."
        Else
            If tmap(enemy(i).c.x,enemy(i).c.y).no=86 Then
                rlprint "You see a scoutship starting in the distance."
                companystats(basis(nearest_base(player.c)).company).profit+=1
            EndIf
            If tmap(enemy(i).c.x,enemy(i).c.y).no=272 Or tmap(enemy(i).c.x,enemy(i).c.y).no=273 Then rlprint "You see an alien ship starting in the distance."
            companystats(basis(nearest_base(player.c)).company).profit+=1
        EndIf
        enemy(i)=enemy(lastenemy)
        lastenemy=lastenemy-1

    endif
    
    Return 0
End Function
    

Function ep_friendfoe(i As Short,j As Short) As Short
    dim as short fact
    if enemy(i).allied>0 then
        fact=enemy(i).allied
    else
        fact=enemy(i).faction
    endif
    If j=-1 Then Return enemy(i).aggr
    If enemy(j).attacked=i Then Return 0 'Not my friend!     
    If fact<>enemy(j).faction then 
        If fact<=8 And enemy(j).faction<=8 Then
            if (faction(fact).war(enemy(j).faction)>80 or faction(enemy(j).faction).war(fact)>80) Then return 0
        endif
        Select Case enemy(i).diet
        Case 1  'Herbivour
            If enemy(j).diet=2 And rnd_range(1,10)<enemy(i).intel Then return 0
        Case 2  'Carnivour
            If enemy(i).hp>enemy(j).hp And rnd_range(1,10)<2+enemy(i).intel Then return 0    
        Case 3  'Scavenger
            If enemy(i).hp>enemy(j).hp And rnd_range(1,10)<enemy(i).intel Then return 0
        case 4
            if enemy(i).hp>enemy(j).hp and rnd_range(1,10)>enemy(i).intel Then Return 0
        case 5
            if enemy(j).attacked<>0 then return 0
        End Select
    endif
    return 1 'Dont see you as foe, going to see you as friend
End Function


Function ep_nearest(i As Short) As Short
    Dim As Single d,dd,d2,dd2,ddd,d3,x,y
    Dim As Short j,k
    d=9999       
    dd=9999
    ddd=9999
    For j=1 To lastenemy
        If j<>i Then
            If enemy(j).hp>0 Then
                If ep_friendfoe(i,j)=1 Then
                    d2=distance(enemy(j).c,enemy(i).c)
                    If d2<d Then
                        d=d2
                        enemy(i).nearestfriend=j
                    EndIf
                Else
                    d3=distance(enemy(j).c,enemy(i).c)
                    If d3<ddd Then
                        ddd=d3
                        enemy(i).nearestenemy=j
                    EndIf
                EndIf
            Else
                dd2=distance(enemy(j).c,enemy(i).c)
                If dd2<dd Then
                    dd=dd2
                    enemy(i).nearestdead=j
                EndIf
            EndIf
        EndIf
    Next
    d2=distance(enemy(i).c,awayteam.c)
    If ep_friendfoe(i,-1)=1 Then
        if d2<d then
            d=d2
            enemy(i).nearestfriend=-1
        endif
    Else
        if d2<ddd then
            ddd=d2
            enemy(i).nearestenemy=-1
        EndIf
    endif
    enemy(i).denemy=ddd
    enemy(i).dfriend=d
    enemy(i).ddead=dd
    dd=9999
    enemy(i).nearestitem=0
    for x=enemy(i).c.x-enemy(i).sight to enemy(i).c.x+enemy(i).sight
        for y=enemy(i).c.y-enemy(i).sight to enemy(i).c.y+enemy(i).sight
            if x>=0 and y>=0 and x<=60 and y<=20 then
                if itemindex.last(x,y)>0 then
                    for k=1 to itemindex.last(x,y)
                        j=itemindex.index(x,y,k)
        
                        If item(j).w.p=0 And item(j).w.s=0 and (item(j).ty<>21 and item(j).ty<>22 and item(j).ty<>29) Then
                            if enemy(i).diet<>4 or item(j).ty=15 then
                                d2=distance(enemy(i).c,item(j).w)
                                If d2<dd Then
                                    enemy(i).nearestitem=j
                                    dd=d2
                                EndIf
                            endif
                        endif
                    next
                endif
            endif
        next
    Next    
    
    enemy(i).ditem=dd
    if enemy(i).diet=4 and enemy(i).nearestitem=0 then
        enemy(i).pickup=-1
        for x=0 to 60
            for y=0 to 20
                if tmap(x,y).spawnswhat=enemy(i).made then 
                    enemy(i).target.y=y
                    enemy(i).target.x=x
                endif
            next
        next
    endif
    Return 0
End Function


Function ep_monstermove(spawnmask() As _cords, lsp As Short, mapmask() As Byte,nightday() As Byte) As Short
    Dim As Short deadcounter,i,j,flee,slot
    Dim As Byte message(8),see1,see2
    
    slot=awayteam.slot
    for i=1 to lastenemy
        if enemy(i).hp>0 then
            ep_monsterupdate(i,spawnmask(),lsp,mapmask(),nightday(),message())
        endif
    next
    mapmask(awayteam.c.x,awayteam.c.y)=-1
    
    For i=1 To lastenemy
        flee=0
        If enemy(i).hp>0 Then
            
            If enemy(i).e.tick<0 And enemy(i).sleeping=0 Then
                'Nearest critter, dead, item?
                ep_nearest(i)
                'Reaction to critter
                if enemy(i).nearestitem>0 and enemy(i).c.x=item(enemy(i).nearestitem).w.x and item(enemy(i).nearestitem).w.p=0 and item(enemy(i).nearestitem).w.s=0 and enemy(i).c.y=item(enemy(i).nearestitem).w.y and (rnd_range(1,10)<enemy(i).pumod or enemy(i).pickup=1) then
                    item(enemy(i).nearestitem).w.p=i
                    if vismask(enemy(i).c.x,enemy(i).c.y)>0 then rlprint "The "&enemy(i).sdesc &" picks up the "&item(enemy(i).nearestitem).desig &"."
                    itemindex.remove(enemy(i).nearestitem,enemy(i).c)
                    enemy(i).pickup=0
                    enemy(i).nearestitem=0
                    enemy(i).add_move_cost
                endif

                If enemy(i).denemy>enemy(i).sight or enemy(i).nearestenemy=0 Then
                    'Can't see it
                    If (enemy(i).aggr=0 Or enemy(i).aggr=2) And enemy(i).diet>0 and rnd_range(1,20)+enemy(i).cmmod<enemy(i).intel And enemy(i).faction>8 Then
                        enemy(i).aggr=1
                        If vismask(enemy(i).c.x,enemy(i).c.y)>0 Then rlprint "The "&enemy(i).sdesc &" seems to calm down."
                    EndIf
                    
                    if enemy(i).pickup>=0 then enemy(i).target=rnd_point
                    
                    if (enemy(i).nearestitem>0 and enemy(i).diet=4) or (enemy(i).sight<enemy(i).ditem and enemy(i).nearestitem>0 and (rnd_range(1,10)<enemy(i).pumod or enemy(i).pickup=1)) then
                        enemy(i).pickup=1
                        enemy(i).target=item(enemy(i).nearestitem).w
                    endif
                Else
                    If enemy(i).nearestenemy=-1 Or enemy(i).nearestfriend=-1 Then
                        'Nearest is player
                        
                        'If its an animal does it change it's mood?
                        if enemy(i).faction>8 then ep_changemood(i,message())
                        
                        If enemy(i).aggr=0 Then 
                            enemy(i).attacked=-1
                        Else
                            enemy(i).attacked=0
                        EndIf
                        If enemy(i).aggr=1 Then enemy(i).target=rnd_point
                        If enemy(i).aggr=2 Then 
                            enemy(i).target=awayteam.c
                            flee=1
                        endif
                    Else
                        If enemy(i).denemy>enemy(i).sight Then
                            enemy(i).target=rnd_point
                        Else
                            enemy(i).attacked=enemy(i).nearestenemy
                        EndIf
                        if enemy(i).dfriend<enemy(i).sight then
                            if enemy(i).nearestfriend=-1 then
                                if awayteam.attacked>0 then
                                    if vismask(enemy(i).c.x,enemy(i).c.y)>0 then rlprint enemy(i).desc &" decides to help you!"
                                    enemy(i).attacked=awayteam.attacked
                                endif
                            else
                                if enemy(enemy(i).nearestfriend).attacked<>0 then
                                    if vismask(enemy(i).c.x,enemy(i).c.y)>0 then rlprint "The "&enemy(i).sdesc &" decides to help the " &enemy(enemy(i).nearestfriend).sdesc &"."
                                    enemy(i).attacked=enemy(enemy(i).nearestfriend).attacked
                                endif
                            endif
                        endif
                    EndIf
                    
                    

                    
                EndIf
                'Move
                'Monster k�nnen nur 3 dinge tun: Angreifen, auf ein ziel zugehen/weggehen, irgendwohin gehen
                If enemy(i).attacked<>0 Then
                    If enemy(i).denemy<=enemy(i).range Then
                        If enemy(i).attacked=-1 Then
                            if pathblock(awayteam.c,enemy(i).c,awayteam.slot,1)=-1 or distance(enemy(i).c,awayteam.c)<2 then
                                awayteam=monsterhit(enemy(i),awayteam,vismask(enemy(i).c.x,enemy(i).c.y))
                            endif
                        Else
                            if pathblock(enemy(i).c,enemy(enemy(i).attacked).c,awayteam.slot,1)=-1 or distance(enemy(i).c,enemy(enemy(i).attacked).c)<2 then
                                if enemy(enemy(i).attacked).hp>0 then
                                    enemy(enemy(i).attacked)=monsterhit(enemy(i),enemy(enemy(i).attacked),vismask(enemy(i).c.x,enemy(i).c.y))
                                    see1=0
                                    see2=0
                                    if vismask(enemy(i).c.x,enemy(i).c.y)>0 then see1=1
                                    if vismask(enemy(enemy(i).attacked).c.x,enemy(enemy(i).attacked).c.y)>0 then see2=1
                                    if see1=1 and see2=1 then rlprint "The "&enemy(i).sdesc &" attacks the "&enemy(enemy(i).attacked).sdesc &"."
                                    if see1=0 and see2=1 then rlprint "Something attacks the "&enemy(enemy(i).attacked).sdesc &"."
                                    if see1=1 and see2=0 then rlprint "The "&enemy(i).sdesc &" attacks something."
                                    If enemy(enemy(i).attacked).hp<=0 Then enemy(i).attacked=0
                                else
                                    enemy(i).attacked=0
                                endif
                            endif
                        EndIf
                        enemy(i).e.add_action(enemy(i).atcost)
                    Else
                        If enemy(i).attacked=-1 Then
                            enemy(i).target=awayteam.c
                        Else
                            enemy(i).target=enemy(enemy(i).attacked).c
                        EndIf
                        enemy(i).attacked=0
                    EndIf
                EndIf
                If enemy(i).attacked=0 And enemy(i).e.e<=0 Then
                    if enemy(i).diet<>2 and enemy(i).ddead=0 and enemy(i).faction<>enemy(enemy(i).nearestdead).faction and enemy(i).nearestdead>0 then
                        if enemy(i).faction>8 and enemy(enemy(i).nearestdead).faction>8 then
                            if vismask(enemy(i).c.x,enemy(i).c.y)>0 then rlprint "The "&enemy(i).sdesc &" eats of the "&enemy(enemy(i).nearestdead).sdesc
                            enemy(enemy(i).nearestdead).hpmax-=1
                            enemy(i).add_move_cost
                        endif
                    elseif enemy(i).diet=1 and tmap(enemy(i).c.x,enemy(i).c.y).vege>0 then
                        if vismask(enemy(i).c.x,enemy(i).c.y)>0 then rlprint "The "&enemy(i).sdesc &" eats of the plants in this area"
                        tmap(enemy(i).c.x,enemy(i).c.y).vege-=1
                        enemy(i).add_move_cost
                    else
                        if enemy(i).speed>0 then move_monster(i,enemy(i).target,flee,planets(slot).depth,mapmask())
                    endif
                EndIf
            EndIf 
        Else
            deadcounter+=1
        EndIf
    Next
    
    Return deadcounter
End Function


