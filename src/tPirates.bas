'ttPirates.
'
'defines:
'clearfleetlist=1, set_fleet=5, friendly_pirates=0, join_fight=0,
', meet_fleet=0, getship=0, fleet_battle=0, resolve_fight=0,
', decide_if_fight=0, collide_fleets=1, ss_sighting=1, update_targetlist=0,
', move_fleets=1, piratecrunch=0, setmonster=0, monster2crew=0,
', debug_printfleet=0
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
'     -=-=-=-=-=-=-=- TEST: tPirates -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tPirates -=-=-=-=-=-=-=-

declare function clearfleetlist() as short
declare function set_fleet(fl as _fleet) as short
declare function collide_fleets() as short
declare function ss_sighting(i as short) as short
declare function move_fleets() as short

'private function friendly_pirates(f as short) as short
'private function join_fight(f as short) as short
'private function meet_fleet(f as short)as short
'private function getship(f as _fleet) as short
'private function fleet_battle(byref red as _fleet,byref blue as _fleet) as short
'private function resolve_fight(f2 as short) as short
'private function decide_if_fight(f1 as short,f2 as short) as short
'private function update_targetlist()as short
'private function piratecrunch(fl as _fleet) as _fleet
'private function setmonster(enemy as _monster,map as short,spawnmask()as _cords,lsp as short,x as short=0,y as short=0,mslot as short=0,its as short=0) as _monster    
'private function monster2crew(m as _monster) as _crewmember
'private function debug_printfleet(f as _fleet) as string

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tPirates -=-=-=-=-=-=-=-

namespace pirates
function init() as Integer
	return 0
end function
end namespace'pirates


function clearfleetlist() as short
    dim as short a,b,c
    do
    c=0
    countpatrol=0
    for a=3 to lastfleet
        if fleet(a).ty=3 then countpatrol=countpatrol+1
        if fleet(a).ty=0 then
            c=c+1
            fleet(a)=fleet(lastfleet)
            lastfleet=lastfleet-1
        endif
    next
    loop until c=0
    return 0
end function


function set_fleet(fl as _fleet) as short
    dim as short i,f
    clearfleetlist
    lastfleet+=1
    if lastfleet>ubound(fleet) then
        lastfleet-=1
        for i=1 to lastfleet
            if fleet(i).ty=0 then f=i
        next
        if f=0 then f=rnd_range(6,lastfleet)
    else
        f=lastfleet
    endif
    fleet(f)=fl
    return f
end function


function friendly_tPirates(f as short) as short
    dim as short a,b,i,mo,lastbay,r
    for i=1 to 10
        if player.cargo(i).x>=1 then lastbay+=1
    next
    a=textmenu(bg_ship,"The pirate fleet hails you, demanding you drop all your cargo/Tell them you have no cargo/Drop some cargo/Drop all cargo/Offer money/Try to flee/Attack","",0,16)
    select case a
    	case 1
        if getnextfreebay=1 or player.cargo(1).x<=0 then
            'Really has no cargo
            rlprint "You convince them that you don't have cargo, and they leave.",c_gre
            fleet(f).con(15)+=1
            r=0
        else
            if rnd_range(1,10)<fleet(f).mem(1).sensors*10-player.equipment(se_CargoShielding) then
                rlprint "They don't believe you!",c_red
                fleet(f).con(15)+=1
                r=1
            else
                rlprint "They believe you and agree to leave you alone.",c_gre
                fleet(f).con(15)-=1
                r=0
            endif
            'lying
        endif
    case 2
        do
            b=textmenu(bg_ship,cargobay("Drop(" &mo & "Cr. dropped)/",0))
            if b>=1 or b<=lastbay then
                mo+=player.cargo(i).y
                player.cargo(i).x=1
                player.cargo(i).y=0
            endif
        loop until b=-1 or b>lastbay
        if rnd_range(1,mo)<fleet(f).con(1)+mo/3 or getnextfreebay=1 then
            rlprint "They are satisfied.",c_gre
            fleet(f).con(15)+=1
            r=0
        else
            rlprint "They don't think it's enough!",c_red
            fleet(f).con(15)-=1
            r=1
        endif
    case 3
        for i=1 to 10
            if player.cargo(i).x>1 then 
                player.cargo(i).x=1
                player.cargo(i).y=0
            endif
        next
        rlprint "They are satisfied and leave.",c_gre
        fleet(f).con(15)+=1
        r=0
    case 4
        rlprint "How much do you offer?"
        mo=getnumber(0,player.money,0)
        if mo>player.money/20+rnd_range(1,player.money/10)+rnd_range(1,player.money/10) then 
            paystuff(mo)
            rlprint "They agree to leave you alone.",c_gre
            fleet(f).con(15)+=1
            r=0
        else
            rlprint "They don't think it's enough!",c_red
            fleet(f).con(15)-=1
            r=1
        endif
    case 5
        fleet(f).con(15)-=1
        r=1
    case 6
        fleet(f).con(15)-=2
        r=1
    end select
    if r=1 then
        factionadd(0,2,15)
    else
        factionadd(0,2,-5)
    endif
    return r
end function

    
'function playerfightfleet(f as short) as short
'    dim as short a,total,f2,e,ter,x,y
'    dim text as string
'    dim fname(10) as string
'    gen_fname(fname()) 
'    
'    for a=1 to 9
'        basis(10).inv(a).v=0
'        basis(10).inv(a).p=0
'    next
'    for x=player.c.x-1 to player.c.x+1
'        for y=player.c.y-1 to player.c.y+1
'            if x>=0 and y>=0 and x<=sm_x and y<=sm_y then
'                if spacemap(x,y)<>0 then ter+=1
'            endif
'        next
'    next
'    if fleet(f).ty=ft_ancientaliens then alliance(0)=1 'From now on we can build alliances
'    spacecombat(fleet(f),spacemap(player.c.x,player.c.y)+ter)
'    if player.dead=0 and fleet(f).flag>0 then player.questflag(fleet(f).flag)=2
'    if player.dead>0 and fleet(f).ty=5 then player.dead=21
'    for a=1 to 8
'        total=total+basis(10).inv(a).v
'    next 
'    'rlprint ""&total
'    if total>0 and player.dead=0 then trading(10)
'    if player.dead=-1 then player.dead=0
'    if player.dead>0 then
'        for a=1 to 128
'            if crew(a).hpmax>0 then player.deadredshirts+=1
'        next
''        if fleet(f).ty=2 then player.dead=5
''        if fleet(f).ty=4 then player.dead=5
''        if fleet(f).ty=1 then player.dead=13
''        if fleet(f).ty=3 then player.dead=13
''        if fleet(f).ty=5 then player.dead=31
''        if fleet(f).ty=6 then player.dead=32
''        if fleet(f).ty=7 then player.dead=33
'        
'    endif
'    fleet(f).ty=0
'    return 0
'end function


function join_fight(f as short) as short
    dim as string q,fname(10)
    dim as short f2,des,faggr,f2aggr,i,fty,f2ty,side
     
    f2=fleet(f).fighting
    gen_fname(fname())
    fty=fleet(f).ty
    f2ty=fleet(f2).ty
    if f<=6 then fty=8
    if f2<=6 then f2ty=8
    rlprint add_a_or_an(fname(fty),1) &" and "& add_a_or_an(fname(f2ty),0) &" are fighting here."
    q="On which side do you want to join the fight?/"& fname(fty) &f &":"&fty &"/" & fname(f2ty)  &f2 &":"&f2ty  & "/Ignore fight"
    des=textmenu(bg_ship,q,"",0,18,1) 
    if des=3 or des=-1 then return 0
    if des=1 then 'aggr1=On PCs side
        faggr=1
        f2aggr=0
        side=fty
    else
        faggr=0
        f2aggr=1
        side=f2ty
    endif
'    fname(0)=""
'    fname(1)=""
    for i=1 to 14
        if fleet(f).mem(i).hull>0 then fleet(f).mem(i).aggr=faggr
        if fleet(f2).mem(i).hull>0 then fleet(f2).mem(i).aggr=f2aggr
        if fleet(f).mem(i).hull>0 then fname(0)=fname(0)&fleet(f).mem(i).aggr
        if fleet(f2).mem(i).hull>0 then fname(1)=fname(1)&fleet(f2).mem(i).aggr
    next
    if faggr=1 then
        factionadd(0,fleet(f2).ty,15)
        factionadd(0,fleet(f).ty,-25)
    else
        factionadd(0,fleet(f).ty,15)
        factionadd(0,fleet(f2).ty,-25)
    endif
    rlprint "You join the fight on the side of the "&fname(side) &".",c_yel
    fleet(f)=add_fleets(fleet(f),fleet(f2))
    playerfightfleet(f)
    if player.dead=0 then
        rlprint "The " & fname(side) & " hails your ship and thank you for your help in the battle.",c_gre
        fleet(f).ty=side
    endif
    return 0
end function


function meet_fleet(f as short)as short
    static lastturncalled as integer
    dim as short aggr,roll,frd,des,dialog,q,a,total,cloak,x,y
    dim question as string
    dim fname(10) as string
    gen_fname(fname())
    if findbest(25,-1)>0 then cloak=5
    if fleet(f).ty=10 then 
        lastturncalled=tVersion.gameturn 
        eris_does
        return 0
    endif
    if tVersion.gameturn>lastturncalled+50 and fleet(f).ty>0 and player.dead=0 and just_run=0 then
        if fleet(f).fighting=0 then
            if faction(0).war(fleet(f).ty)+rnd_range(1,10)>90 and fleet(f).ty<>1 then 'Merchants never attack 
                q=1
            else
                q=0
            endif
            if q=1 and f>5 then
                question="There is "&add_a_or_an(fname(fleet(f).ty),0) &" on an attack vector. Do you want to engage? (y/n)"
                if fleet(f).ty=2 and fleet(f).con(15)<rnd_range(1,20) then
                    'Friendly tPirates
                    q=friendly_tPirates(f)
                    lastturncalled=tVersion.gameturn
                    display_stars(1)
                    display_ship
                    if q=0 then return 0
                endif
            endif
            if q=0 and f>5 then question="There is "&add_a_or_an(fname(fleet(f).ty),0) &" hailing us."
            if q=1 then
                des=askyn(question)
            else
                rlprint question
                return f
            endif
            if des=0 then
                if q=1 then
                    if skill_test(player.pilot(location)+cloak-fleet(f).count,st_hard) then
                        rlprint "You got away!",c_gre
                    else
                        rlprint "They are closing in..."
                        des=-1
                    endif
                else
                    rlprint "you return the greeting"
                endif
            endif
            if des=-1 then
                factionadd(0,fleet(f).ty,15)
                playerfightfleet(f)
            endif
        else
            join_fight(f)
        endif
    endif
    
    lastturncalled=tVersion.gameturn
    display_stars(1)
    display_ship
    return 0
        
end function


function getship(f as _fleet) as short
    dim as short i,c
    dim as short m(15)
    for i=1 to 15
        if f.mem(i).hull>0 then
            c+=1
            m(c)=i
        endif
    next
    if c=0 then return -1
    return m(rnd_range(1,c))
end function


function fleet_battle(byref red as _fleet,byref blue as _fleet) as short
    dim as integer rscore,bscore
    dim as short i,f,t,j,dam

    'Only one side shoots, collide fleets calls both alternately
    for i=1 to 15
        if red.mem(i).hull>0 and rnd_range(1,6)>4 then 'exits and has Initiative
            rscore+=1
            for f=1 to 25
                if red.mem(i).weapons(f).dam>0 and skill_test(red.mem(i).gunner(0),st_average) then
                    t=getship(blue)
                    if t>0 then
                        dam=red.mem(i).weapons(f).dam-blue.mem(t).shieldmax
                        if dam>0 then 
                            blue.mem(t).hull=blue.mem(t).hull-red.mem(i).weapons(f).dam
                            if blue.mem(t).hull<=0 and blue.mem(t).bounty>0 then bountyquest(blue.mem(t).bounty).status=3
                            DbgPrint(blue.mem(i).desig &"hit "&red.mem(t).desig &" for " &dam &" damage")
                        endif
                    endif
                endif
            next
        endif
    next
    for i=1 to 15
        if blue.mem(i).hull>0 then bscore+=1
    next
    if bscore>0 then return 0
    return -1
end function


function resolve_fight(f2 as short) as short
    if f2<5 then
        basis(f2-1).c.x=-1 'Destroy station f2-1 by moving it off the map
        fleet(f2).ty=0 'Delete fleet for basis f2-1
    endif
    
    if rnd_range(1,100)<=2 and lastdrifting<128 then 'Add drifting debris
        If fleet(f2).ty=1 then
            lastdrifting+=1                                    
            lastplanet+=1
            drifting(lastdrifting).x=fleet(f2).c.x
            drifting(lastdrifting).y=fleet(f2).c.y
            drifting(lastdrifting).s=rnd_range(1,16)
            drifting(lastdrifting).m=lastplanet
            make_drifter(drifting(lastdrifting))
            planets(lastplanet).darkness=0
            planets(lastplanet).depth=1
            planets(lastplanet).atmos=4
            planets(lastplanet).mon_template(1)=makemonster(32,lastplanet)
            planets(lastplanet).mon_template(2)=makemonster(33,lastplanet)
            planets_flavortext(lastplanet)="No hum from the engines is heard as you enter the " &shiptypes(drifting(lastdrifting).s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        
        endif
    endif
    if fleet(f2).ty=1 or fleet(f2).ty=3 then patrolmod+=1
    fleet(f2).ty=0
    return 0
end function


function decide_if_fight(f1 as short,f2 as short) as short
    'Decides if f1 and f2 should start a fight
    dim as byte fighting,aggr1,aggr2
    
    
    fighting=0
    if fleet(f1).ty<0 or fleet(f2).ty<0 or fleet(f1).ty>7 or fleet(f2).ty>7 then return 0
    aggr1=faction(fleet(f1).ty).war(fleet(f2).ty)
    aggr2=faction(fleet(f2).ty).war(fleet(f1).ty)
    
    if fleet(f1).ty=6 then aggr1+=civ(0).aggr+civ(0).inte
    if fleet(f1).ty=7 then aggr1+=civ(1).aggr+civ(1).inte
    if fleet(f2).ty=6 then aggr2+=civ(0).aggr+civ(0).inte
    if fleet(f2).ty=7 then aggr2+=civ(1).aggr+civ(1).inte
    
    aggr1+=rnd_range(1,10)
    aggr2+=rnd_range(1,10)
    
    if aggr1>=100 or aggr2>=100 then fighting=1
    
    'Eris always annihilates fleets that aren't space stations
    if (fleet(f1).ty=10 and f2<=5) then fleet(f2).ty=0 
    if (fleet(f2).ty=10 and f1<=5) then fleet(f1).ty=0 
    DbgPrint("f1:"&aggr1 &"F2:"&aggr2)
    'Ancient aliens attack everything
    if fleet(f1).ty=5 or fleet(f2).ty=5 then fighting=1
    
    if f1<=5 or f2<=5 and tVersion.gameturn<5000 then fighting=0 'Spacestations aren't attcked before turn 5000
    
    if fighting=1 then
        DbgPrint("fight initiated between " &fleet(f1).ty &" and "&fleet(f2).ty)
        fleet(f1).fighting=f2
        fleet(f2).fighting=f1
        fleet(f1).con(2)=f2
        fleet(f2).con(2)=f1
        if f1<3 then basis(f1).lastfight=f2
        if f2<3 then basis(f2).lastfight=f1
    endif
    return 0
end function


function collide_fleets() as short
    dim as short f1,f2
    for f1=1 to lastfleet
        for f2=1 to lastfleet
            if f1<>f2 and distance(fleet(f1).c,fleet(f2).c)<2 and fleet(f1).ty<>fleet(f2).ty then
                if fleet(f1).fighting<>0 then 'They already are in battle
                    if fleet_battle(fleet(f1),fleet(fleet(f1).fighting))=-1 then
                        'F1 has won
                        resolve_fight(fleet(f1).fighting)
                        battleslost(fleet(fleet(f1).fighting).ty,fleet(f1).ty)+=1
                        fleet(f1).fighting=0
                    endif
                else
                    decide_if_fight(f1,f2)
                endif
            endif
        next
    next
    
    return 0
end function


function ss_sighting(i as short) as short
    dim as string text,text2,text3
    dim as short fn,fn2,a,s,c
    dim as _cords p
    
    if basis(i).lastsighting=0 then return 0
    fn=basis(i).lastsighting
    fn2=basis(i).lastfight

    DbgPrint(fn &":"&fn2)
    c=11
    
    if rnd_range(1,100)>basis(i).lastsightingturn-tVersion.gameturn then
        if basis(i).lastsightingturn-tVersion.gameturn<25 then
            text ="There are some rumors about"
            if basis(i).lastsightingturn-tVersion.gameturn<10 then text="You hear a lot of people talking about"
            if basis(i).lastsightingturn-tVersion.gameturn<5 then text="The station is abuzz with talk about"
        else
            return 0
        endif
        if basis(i).lastsightingdis>5 then
            text=text & " a long distance unidentified sensor contact, "& basis(i).lastsightingdis &" parsecs out."
        else
            if basis(i).lastsightingdis>2 and basis(i).lastsightingdis<=5  then
                text = text &" mid range sensor contact with"
            endif
            if basis(i).lastsightingdis<=2  then
                text = text &" short range sensor contact with"
            endif
            if fleet(fn).ty=2 then text=text &" a pirate fleet."
            if fleet(fn).ty=4 then 
                if basis(i).lastsightingdis<=3  then
                    text=text &" the pirate ship "& fleet(fn).mem(1).desig &"!"
                else
                    text=text &" a pirate fleet."
                endif
            endif
            if fleet(fn).ty=5 then text=text &" a mysterious huge and fast ship with high energy readings."
            if fleet(fn).ty=6 or fleet(fn).ty=7 then
                s=fleet(fn).ty-6
                if civ(s).contact=1 then
                    text=text &add_a_or_an(civ(s).n,0) &" ship."
                else
                    text =text &" a ship of unknown configuration."
                endif
            endif
            '8 and 9 are GG and asteroid belt monsters. 
            if fleet(fn).ty=10 then text=text &" an entity calling herself eris."
        endif
    endif
    if fleet(i).mem(1).hull<300 then
        text3="There is some damage from a fight being repaired."
    endif
    if fleet(i).mem(1).hull<200 then
        c=c_yel
        text3="There is some heavy damage from a fight being repaired."
    endif
    if fleet(i).mem(1).hull<50 then
        c=c_red
        text3="The station is heavily damaged, barely operational."
    endif
    if fleet(i+1).con(2)>0 then
        select case fleet(fleet(i+1).con(2)).ty
            case is=2
                text3=text3 &" Word on the station is tPirates have attacked!"
            case is=4
                text3=text3 &" Word on the station is the pirate ship "& fleet(fn).mem(1).desig &" attacked!"
            case is=5
                text3=text3 &" Word on the station is that a single, huge ship, with powerful weapons attacked!"
            case 6,7
                s=fleet(fleet(i+1).con(2)).ty-6
                if civ(s).contact=1 then
                    text3=text3 &" Word on the station is " &civ(s).n &" ships have attacked."
                else
                    text3=text3 &" Word on the station is an unknown civilisation has attacked."
                endif
        end select
    endif
    if rnd_range(1,100)>alienattacks and player.questflag(3)=0 then
        if alienattacks>5 then text2=" You hear a rumor about disappearing scout ships." 
        if alienattacks>10 then text2=" You hear a rumor about disappearing merchant convoys." 
        if alienattacks>25 then text2=" You hear a rumor about disappearing patrol ships." 
        if alienattacks>50 then text2=" Every conversation you overhear seems to be about disappearing ships and fleets." 
        if alienattacks>75 then
            if sysfrommap(specialplanet(29))>0 then
                p=map(sysfrommap(specialplanet(29))).c
            else
                p=map(sysfrommap(specialplanet(30))).c
            endif
            for a=0 to rnd_range(1,6)
                p=movepoint(p,5)
            next
            text2=" The station is abuzz with talk about ships disappearing around coordinates "&p.x &":"&p.y &"." 
        endif
    endif
    'text=text & fn &"typ:"&fleet(fn).ty
    if text<>"" or text3<>"" or text2<>"" then 
        rlprint (text3),c
        rlprint (text),c
        rlprint (text2),c
    endif
    return 0
end function


function update_targetlist()as short
    static lastcalled as short
    dim as short b,tPiratesys
    tPiratesys=random_pirate_system
    if tPiratesys<0 then return 0
    targetlist(1).x=player.c.x
    targetlist(1).y=player.c.y
    if frac(lastcalled/25)=0 then
        targetlist(0).x=map(tPiratesys).c.x-30+rnd_range(0,60)
        targetlist(0).y=map(tPiratesys).c.y-10+rnd_range(0,20)
        targetlist(2)=map(tPiratesys).c
        targetlist(3).x=rnd_range(0,sm_x)
        targetlist(3).y=rnd_range(0,sm_y)
        targetlist(4).x=rnd_range(0,sm_x)
        targetlist(4).y=rnd_range(0,sm_y)
        targetlist(5).x=rnd_range(0,sm_x)
        targetlist(5).y=rnd_range(0,sm_y)
        
        targetlist(7).x=rnd_range(0,sm_x)
        targetlist(7).y=rnd_range(0,sm_y)
        targetlist(8).x=rnd_range(0,sm_x)
        targetlist(8).y=rnd_range(0,sm_y)
        targetlist(9).x=rnd_range(0,sm_x)
        targetlist(9).y=rnd_range(0,sm_y)
    endif
    if civ(0).inte=2 or 1=1 then
        if civ(0).knownstations(0)=1 then targetlist(3)=basis(0).c
        if civ(0).knownstations(1)=1 then targetlist(4)=basis(1).c
        if civ(0).knownstations(2)=1 then targetlist(5)=basis(2).c
    endif
    targetlist(6)=civ(0).home
    if civ(1).inte=2 or 1=1 then
        if civ(1).knownstations(0)=1 then targetlist(7)=basis(0).c
        if civ(1).knownstations(1)=1 then targetlist(8)=basis(1).c
        if civ(1).knownstations(2)=1 then targetlist(9)=basis(2).c
    endif
    targetlist(10)=civ(1).home
    lastcalled=lastcalled+1
    return 0
end function

    
function move_fleets() as short
    dim as short a,b,c,roll,direction,freecargo,s
    a=0
    if lastfleet>255 then lastfleet=255
    for a=6 to lastfleet
        update_targetlist()
        if fleet(a).ty=1 and fleet(a).con(1)=1 then fleet(a).c=player.c 
        if fleet(a).e.tick=-1 then
            if fleet(a).fighting=0 then
                if fleet(a).ty=2 then
                    freecargo=0
                    for b=1 to 15
                        if fleet(a).mem(b).hull>0 then 
                            for c=1 to 10
                                if fleet(a).mem(b).cargo(c).x=1 then freecargo+=1
                            next
                        endif
                    next
                    if freecargo=0 then fleet(a).t=0
                endif
                if skill_test(bestpilotinfleet(fleet(a)),st_veryeasy) or (fleet(a).ty=1 or fleet(a).ty=3) then
                    'move towards target
                    if fleet(a).t>=0 and fleet(a).t<=4068 then
                        direction=nearest(targetlist(fleet(a).t),fleet(a).c)
                    else 
                        fleet(a).t=0
                        direction=5
                    endif
                else
                    'move random
                    direction=5
                endif
                fleet(a).c=movepoint(fleet(a).c,direction,,1)
                fleet(a).add_move_cost
            
                fleet(a).fuel+=1
                if fleet(a).ty=10 then
                    if spacemap(fleet(a).c.x,fleet(a).c.y)<0 and rnd_range(1,100)<10 then spacemap(fleet(a).c.x,fleet(a).c.y)=0
                    if spacemap(fleet(a).c.x,fleet(a).c.y)>1 and rnd_range(1,100)<10 then spacemap(fleet(a).c.x,fleet(a).c.y)=0
                    if fleet(a).c.x=targetlist(fleet(a).t).x and fleet(a).c.y=targetlist(fleet(a).t).y then
                        eris_finds_apollo
                    endif
                endif
                'Check if reached target 
                if fleet(a).c.x=targetlist(fleet(a).t).x and fleet(a).c.y=targetlist(fleet(a).t).y then
                    if fleet(a).ty>5 and fleet(a).ty<8 then
                        if civ(fleet(a).ty-6).inte=2 then
                            tCompany.merctrade(fleet(a))
                        endif
                        if fleet(a).c.x=civ(fleet(a).ty-6).home.x and fleet(a).c.y=civ(fleet(a).ty-6).home.y then
                            fleet(a)=tCompany.unload_f(fleet(a),11) 
                            fleet(a)=load_f(fleet(a),11)
                        endif
                    endif
                    if fleet(a).con(1)=0 then
                        fleet(a).t+=1 
                    else
                        fleet(a).t=1
                    endif
                    if fleet(a).t>=lastwaypoint and (fleet(a).ty=1 or fleet(a).ty=3) then fleet(a).t=firststationw
                    if (fleet(a).ty=2 or fleet(a).ty=4) and fleet(a).t>2 then fleet(a).t=0
                    if fleet(a).ty=6 and fleet(a).t>6 then fleet(a).t=3
                    if fleet(a).ty=7 and fleet(a).t>10 then fleet(a).t=7
                endif
                
                for s=0 to 2
                    
                    if fleet(a).ty=1 or fleet(a).ty=3 then
                        if fleet(a).c.x=basis(s).c.x and fleet(a).c.y=basis(s).c.y then tCompany.merctrade(fleet(a))
                    endif
                    if fleet(a).ty<>3 and fleet(a).ty<>1 then 'No Merchant or Patrol
                        if distance(fleet(a).c,basis(s).c)<12 then
                            basis(s).lastsighting=a
                            basis(s).lastsightingdis=fix(distance(fleet(a).c,basis(s).c))
                            basis(s).lastsightingturn=tVersion.gameturn
                        endif
                    endif
                    if fleet(a).ty>5 and fleet(a).ty<8 then
                        if distance(fleet(a).c,basis(s).c)<fleet(a).mem(1).sensors then 
                            civ(fleet(a).ty-6).knownstations(s)=1
                            if show_npcs then rlprint civ(fleet(a).ty-6).n &"has discovered station "&s+1
                        endif
                    endif
                next
                
                
            endif
        endif
    next
    return 0
end function


function piratecrunch(fl as _fleet) as _fleet
    'Turns tPirates into bigger ship. 3 F=1C 3C=1D 3D=1B
    dim r as _fleet
    dim as short ss,ts,a,i
    dim as string w,search(3)
    dim as short f,c,d,b,counter
    
    dim p as short
    b=random_pirate_system
    p=b
    c=0
    b=0
    for a=0 to 10
        if fl.mem(a).icon="F" then f=f+1
        if fl.mem(a).icon="C" then c=c+1
        if fl.mem(a).icon="D" then d=d+1
    next
    if f<=5 and c<=4 and d<=3 then 
        r=fl
    else
        do 
            counter=counter+1
            if f>5 then
                f=f-5
                c=c+1
            endif
            if c>4 then
                c=c-4
                d=d+1
            endif
            if d>3 then
                d=d-3
                b=b+1
            endif
        loop until (f<=3 and c<=3 and d<=3) or counter>15
        for a=1 to f
            r.mem(a)=make_ship(2)
        next
        for a=f+1 to f+c
            r.mem(a)=make_ship(3)
        next
        for a=f+c+1 to f+c+d
            r.mem(a)=make_ship(4)
        next
        if b>1 then r.mem(b+c+d+1)=make_ship(5)
    endif
    r.ty=2
    r.c=map(piratebase(p)).c
    r.t=8
    return r
end function

function setmonster(enemy as _monster,map as short,spawnmask()as _cords,lsp as short,x as short=0,y as short=0,mslot as short=0,its as short=0) as _monster    
    dim as short l,c
    if x=0 and y=0 then
        do
            l=rnd_range(0,lsp)
            c+=1
        loop until vismask(spawnmask(l).x,spawnmask(l).y)=0 or c=500
    endif
    if x=0 then x=spawnmask(l).x
    if y=0 then y=spawnmask(l).y
    enemy.c.x=x
    enemy.c.y=y  
    
    select case rnd_range(1,100)
    case 1 to 25
        enemy.hpmax=cint(enemy.hpmax*1.1)
    case 75 to 100
        enemy.hpmax=cint(enemy.hpmax*.9)
    end select
    
    if enemy.hpmax<0 then enemy.hpmax=1
    if enemy.hp>0 then enemy.hp=enemy.hpmax
    if its>0 then
        for l=0 to 8
            if rnd_range(1,100)<enemy.itemch(l) and enemy.items(l)<>0 then
                if enemy.items(l)>0 then
                    placeitem(make_item(enemy.items(l)),x,y,map,mslot,0)
                else
                    placeitem(rnd_item(-enemy.items(l)),x,y,map,mslot,0)
                endif
            endif
        next
    endif
    if enemy.allied<>0 then
        if rnd_range(1,100)<faction(0).war(enemy.allied) then
            enemy.aggr=0
        else
            enemy.aggr=1
        endif
    endif
    return enemy
end function

function monster2crew(m as _monster) as _crewmember
    dim c as _crewmember
    c.icon=Chr(m.tile)
    c.hpmax=m.hpmax/5
    c.hp=c.hpmax
    if m.pumod>4 then
        c.equips=1
    else
        c.equips=0
    endif
    return c
end function

    
#if __FB_DEBUG__
function debug_printfleet(f as _fleet) as string
    dim text as string
    dim a as short
    for a=1 to 15
        text=text &f.mem(a).icon
    next
    return text
end function
#endif

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: pirates -=-=-=-=-=-=-=-
	tModule.register("pirates",@pirates.init()) ',@pirates.load(),@pirates.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: pirates -=-=-=-=-=-=-=-
#endif'test
