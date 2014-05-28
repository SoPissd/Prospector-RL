'tAttack.
'
'defines:
'hitmonster=0, ep_fireeffect=0
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
'     -=-=-=-=-=-=-=- TEST: tAttack -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tAttack -=-=-=-=-=-=-=-
Dim Shared vacuum(60,20) As Byte


'declare function hitmonster(defender As _monster,attacker As _monster,mapmask() As Byte, first As Short=-1, last As Short=-1) As _monster
'declare function ep_fireeffect(p2 As _cords,slot As Short, c As Short, range As Short, mapmask() As Byte, first As Short=0,last As Short=0) As Short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tAttack -=-=-=-=-=-=-=-

namespace tAttack
function init(iAction as integer) as integer
	return 0
end function
end namespace'tAttack


#define cut2top


function hitmonster(defender As _monster,attacker As _monster,mapmask() As Byte, first As Short=-1, last As Short=-1) As _monster
    Dim a As Short
    Dim b As Single
    Dim As Single nonlet
    Dim c As Short
    Dim col As Short
    Dim noa As Short
    Dim text As String
    Dim wtext As String
    Dim mname As String
    Dim xpstring As String
    Dim SLBonus(255) As Byte
    Dim As String echo1,echo2
    Dim slbc As Short
    Dim As Short slot,xpgained,tacbonus,targetnumber
    slot=player.map
    play_sound(3)
    If defender.movetype=mt_fly Then
        mname="flying "
        targetnumber=15
    Else
        targetnumber=12
    EndIf
    targetnumber+=defender.speed/2
    mname=mname &defender.sdesc
    If first=-1 Or last=-1 Then
        first=0
        noa=attacker.hpmax
    Else
        noa=last
    EndIf
    If first<0 Then first=0
    If last>attacker.hpmax Then last=attacker.hpmax
    If player.tactic=3 Then
        tacbonus=0
    Else
        tacbonus=player.tactic
    EndIf

    For a=first To noa
        If crew(a).hp>0 And crew(a).onship=0 And crew(a).talents(27)>0 Then
            slbc+=1
            SLBonus(slbc)=1
        EndIf
    Next
    slbc=1
    For a=first To noa
        If noa-first<=5 Then
            echo2=crew(a).n &" attacks"
            echo1=crew(a).n &" shoots"
        EndIf
        If crew(a).hp>0 And crew(a).onship=0 And crew(a).disease=0 And distance(defender.c,attacker.c)<=attacker.secweapran(a)+1.5 Then
            slbc+=1
            If distance(defender.c,attacker.c)>1.5 Then
                If skill_test(-tacbonus+tohit_gun(a)+attacker.secweapthi(a)+SLBonus(slbc),targetnumber,echo1) Then
                    b=b+attacker.secweap(a)+add_talent(3,11,.1)+add_talent(a,26,.1)
                    xpstring=gainxp(a)
                    xpgained+=1
                EndIf
            Else
                If skill_test(-tacbonus+tohit_close(a)+SLBonus(slbc),targetnumber,echo2) Then
                    b=b+maximum(attacker.secweapc(a),attacker.secweap(a))+add_talent(3,11,.1)+add_talent(a,25,.1)+crew(a).augment(2)/10
                    xpstring=gainxp(a)
                    xpgained+=1
                EndIf
            EndIf
        EndIf
    Next
    If xpgained=1 Then rlprint xpstring,c_gre
    If xpgained>1 Then rlprint xpgained &" crewmembers gained 1 Xp.",c_gre
    text="You attack the "&defender.sdesc &"."
    If distance(defender.c,attacker.c)>1.5 Then b=b+1-Int(distance(defender.c,attacker.c)/2)
    b=CInt(b)-player.tactic+add_talent(3,10,1)
    If b<0 Then b=0
    If b>0 Then
       b=b-defender.armor
       If b>0 Then
            If player.tactic<>3 Then
                text=text &" You hit for " & b &" points of damage."
                defender.hp=defender.hp-b
            Else
                If defender.stunres<10 Then
                    b=b/2
                    b=(b*((10-defender.stunres)/10))
                    text=text &" You hit for " & b &" nonlethal points of damage."
                    defender.hpnonlethal+=b
                Else
                    b=b/2
                    defender.hp-=b
                EndIf
            EndIf
            If defender.hp/defender.hpmax<0.8 Then wtext =" The " & mname &" is slightly "&defender.dhurt &". "
            If defender.hp/defender.hpmax<0.5 Then wtext =" The " & mname &" is "&defender.dhurt &". "
            If defender.hp/defender.hpmax<0.3 Then wtext =" The " & mname &" is badly "&defender.dhurt &". "
            text=text &wtext
            col=10
            If defender.hp>0 Then 
                defender.target=attacker.c
            Else
                defender.target.x=0
                defender.target.y=0
            EndIf
        Else
            text=text &" You don't penetrate the "&mname &"s armor."
            col=14
        EndIf
    Else
        text=text &" Your fire misses. "
        col=14
    EndIf
    If defender.hp<=0 Then
        text=text &" the "& mname &" "&defender.dkill
        If defender.made=44 Then player.questflag(12)=28
        If defender.made=83 Then player.questflag(20)+=1
        If defender.made=84 Then player.questflag(20)+=2
        player.alienkills=player.alienkills+1
        If defender.allied>0 Then factionadd(0,defender.allied,1)
        If defender.enemy>0 Then factionadd(0,defender.enemy,-1)
        If defender.slot>=0 Then planets(slot).mon_killed(defender.slot)+=1
    Else
        If defender.hp=1 And b>0 And defender.aggr<>2 Then
            If rnd_range(1,6) +rnd_range(1,6)<defender.intel+defender.diet And defender.speed>0 Then
                defender.aggr=2
                text=text &"the " &mname &" is critically hurt and tries to FLEE. "
            EndIf
        Else
            If defender.aggr>0 And defender.hp<defender.hpmax Then
                If distance(defender.c,attacker.c)<=1.5 Or defender.intel+rnd_range(1,6)>attacker.invis Then
                    defender.aggr=0
                    text=text &" the "&mname &" tries to defend itself."
                Else
                    text=text &" the "&mname &" looks confused into your general direction"
                EndIf
            EndIf
        EndIf
    EndIf
    rlprint text,col
    Return defender
End function


function ep_fireeffect(p2 As _cords,slot As Short, c As Short, range As Short, mapmask() As Byte, first As Short=0,last As Short=0) As Short
    Dim As Short d,f,x,y,vacc
    Dim As Single dam
    If first=0 And last=0 Then
        first=1
        last=awayteam.hpmax
    EndIf
    For d=1 To lastenemy
        If enemy(d).c.x=p2.x And enemy(d).c.y=p2.y And enemy(d).hp>0 Then
            enemy(d)=hitmonster(enemy(d),awayteam,mapmask(),first,first+last)
            'e=1
        EndIf
    Next
    If tmap(p2.x,p2.y).shootable=1 Then
        dam=0
        For f=first To last
            If crew(f).hp>0 And crew(f).onship=0 Then dam=dam+awayteam.secweap(f)
        Next
        dam=CInt(dam-tmap(p2.x,p2.y).dr)
        'rlprint "in here with dam "&dam
        If dam>0 Or (awayteam.stuff(5)>0 And c=1) Then
            dam=dam+awayteam.stuff(5)
            If dam<=0 Then dam=awayteam.stuff(5)
            rlprint tmap(p2.x,p2.y).succt &" ("&dam &" damage)"
            tmap(p2.x,p2.y).hp=tmap(p2.x,p2.y).hp-dam
            If tmap(p2.x,p2.y).hp>=1 And tmap(p2.x,p2.y).hp<=tiles(tmap(p2.x,p2.y).no).hp*.25 Then rlprint "The "&tmap(p2.x,p2.y).desc &" is showing signs of serious damage."
            If tmap(p2.x,p2.y).hp<=0 Then
                If tmap(p2.x,p2.y).no=243 Then
                    If vacuum(p2.x,p2.y)=0 Then
                        For x=p2.x-1 To p2.x+1
                            For y=p2.y-1 To p2.y+1
                                If x>=0 And x<=60 And y>=0 And y<=20 Then
                                    If vacuum(x,y)=1 Then vacc=1
                                EndIf
                            Next
                        Next
                        If vacc=1 Then
                            rlprint "The air rushes out of the ship!",14
                            awayteam.helmet=1
                        EndIf
                    EndIf
                EndIf
                rlprint tmap(p2.x,p2.y).killt,10
                tmap(p2.x,p2.y)=tiles(tmap(p2.x,p2.y).turnsinto)
                If planetmap(p2.x,p2.y,slot)>0 Then planetmap(p2.x,p2.y,slot)=tmap(p2.x,p2.y).no
                If planetmap(p2.x,p2.y,slot)<0 Then planetmap(p2.x,p2.y,slot)=-tmap(p2.x,p2.y).no
            EndIf
        Else
            rlprint tmap(p2.x,p2.y).failt,14
        EndIf
    EndIf
    If tmap(p2.x,p2.y).firetru=1 Then
        c=range+1
    EndIf
    Return c
End function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tAttack -=-=-=-=-=-=-=-
	tModule.register("tAttack",@tAttack.init()) ',@tAttack.load(),@tAttack.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tAttack -=-=-=-=-=-=-=-
#endif'test
