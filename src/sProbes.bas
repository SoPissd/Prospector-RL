'tProbes.
'
'defines:
'launch_probe=1, move_probes=1
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
'     -=-=-=-=-=-=-=- TEST: tProbes -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tProbes -=-=-=-=-=-=-=-

declare function launch_probe() As Short
declare function move_probes() As Short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tProbes -=-=-=-=-=-=-=-

namespace tProbes
function init() as Integer
	return 0
end function
end namespace'tProbes


#define cut2top


function launch_probe() As Short
    Dim As Short i,d
    i=get_item(55)
    If i>0 Then
        tScreen.set(0)
        set__color(11,0)
        Cls
        display_stars(1)
        display_ship(1)
        rlprint "Which direction?"
        tScreen.update()
        d=getdirection(keyin())
        If d>0 Then
            lastprobe+=1
            If lastprobe>100 Then lastprobe=1
            probe(lastprobe).x=player.c.x
            probe(lastprobe).y=player.c.y
            probe(lastprobe).m=i
            probe(lastprobe).s=d
            probe(lastprobe).p=item(i).v4
            DbgPrint(probe(lastprobe).x &":"&probe(lastprobe).y)
            rlprint "Probe launched."
            item(i).w.s=0
        Else
            rlprint "Launch cancelled."
        EndIf
    Else
        rlprint "You have no probes."
    EndIf
    Return 0
End function


function move_probes() As Short
    Dim As Short i,x,y,j,navcom,t,d
    DbgPrint("Move probes")
    If lastprobe>0 Then
    navcom=player.equipment(se_navcom)
    For i=1 To lastprobe
        DbgPrint("Probe "&i &" exists.")
        If probe(i).m>0 Then
            probe(i).z-=item(probe(i).m).v5
            If probe(i).z<=0 Then
                DbgPrint("Moving probe "&i)
                probe(i).z+=10
                For j=laststar+1 To laststar+wormhole
                    If map(j).c.x=probe(i).x And map(j).c.y=probe(i).y Then
                        map(j).discovered=1
                        If askyn("Do you want to direct the probe into the wormhole?(y/n)") Then
                            If skill_test(player.pilot(0),st_hard) Then
                                t=map(j).planets(1)
                                d=distance(map(t).c,probe(i))
                                probe(i).x=map(t).c.x
                                probe(i).y=map(t).c.y
                                rlprint "The probe traveled " &d &" parsecs to "&map(t).c.x &":"&map(t).c.y &"."
                                Exit For
                            Else
                                rlprint "You lost contact with the probe."
                                item(probe(i).m).v3=0
                            EndIf
                        EndIf
                    EndIf
                Next

                    probe(i)=movepoint(probe(i),probe(i).s,,1)
                    item(probe(i).m).v3-=1
                    For x=probe(i).x-1 To probe(i).x+1
                        For y=probe(i).y-1 To probe(i).y+1
                            If x>=0 And y>=0 And x<=sm_x And y<=sm_y Then
                                If Abs(spacemap(x,y))<6 Then
                                    spacemap(x,y)=Abs(spacemap(x,y))
                                    If spacemap(x,y)=0 And navcom>0 Then spacemap(x,y)=1
                                EndIf
                                For j=1 To laststar
                                    If map(j).c.x=x And map(j).c.y=y And map(j).spec<8 Then map(j).discovered=1
                                    If map(j).c.x=probe(i).x And map(j).c.y=probe(i).y Then map(j).discovered=1
                                Next
                            EndIf
                        Next
                    Next
                    If Abs(spacemap(probe(i).x,probe(i).y))>=6 And skill_test(player.pilot(0),st_hard) Then spacemap(x,y)=Abs(spacemap(x,y))


                    For j=1 To lastdrifting
                        If drifting(j).x=probe(i).x And drifting(j).y=probe(i).y Then drifting(j).p=1
                    Next
                    If spacemap(probe(i).x,probe(i).y)>1 Then
                        If skill_test(item(probe(i).m).v2,st_average) Then item(probe(i).m).v1-=1
                    EndIf
                EndIf
            EndIf
            If probe(i).x=player.c.x And probe(i).y=player.c.y Then
                If askyn("Do you want to take the probe on board?(y/n)") Then

                    item(probe(i).m).v3=item(probe(i).m).v6 'Refuel
                    item(probe(i).m).w.s=-1 'Refuel
                    If lastprobe>1 Then
                        probe(i)=probe(lastprobe)
                    Else
                        probe(i)=probe(0)
                    EndIf
                    lastprobe-=1
                    tScreen.set(0)
                    set__color(11,0)
                    Cls
                    display_stars(1)
                    display_ship
                    rlprint ""
                    tScreen.update()
                EndIf
            EndIf

        Next
        For i=1 To lastprobe
            If item(probe(i).m).v3<=0 Or item(probe(i).m).v1<=0 Then
                rlprint "Lost contact with probe at "&probe(i).x &":"&probe(i).y &".",c_yel
                If lastprobe>1 Then
                    probe(i)=probe(lastprobe)
                Else
                    probe(i)=probe(0)
                EndIf
                lastprobe-=1
            EndIf
        Next
    EndIf
    Return 0
End function


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tProbes -=-=-=-=-=-=-=-
	tModule.register("tProbes",@tProbes.init()) ',@tProbes.load(),@tProbes.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tProbes -=-=-=-=-=-=-=-
#endif'test
