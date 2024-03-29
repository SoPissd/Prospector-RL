function friendly_pirates(f as short) as short
    dim as short a,b,i,mo,lastbay,r
    for i=1 to 10
        if player.cargo(i).x>=1 then lastbay+=1
    next
    a=menu(bg_ship,"The pirate fleet hails you, demanding you drop all your cargo/Tell them you have no cargo/Drop some cargo/Drop all cargo/Offer money/Try to flee/Attack","",0,16)
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
            b=menu(bg_ship,cargobay("Drop(" &mo & "Cr. dropped)/",0))
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

    
function meet_fleet(f as short)as short
    static lastturncalled as integer
    dim as short aggr,roll,frd,des,dialog,q,a,total,cloak,x,y
    dim question as string
    dim fname(10) as string
    gen_fname(fname())
    if findbest(25,-1)>0 then cloak=5
    if fleet(f).ty=10 then 
        lastturncalled=player.turn 
        eris_does
        return 0
    endif
    if player.turn>lastturncalled+50 and fleet(f).ty>0 and player.dead=0 and just_run=0 then
        if fleet(f).fighting=0 then
            if faction(0).war(fleet(f).ty)+rnd_range(1,10)>90 and fleet(f).ty<>1 then 'Merchants never attack 
                q=1
            else
                q=0
            endif
            if q=1 and f>5 then
                question="There is "&add_a_or_an(fname(fleet(f).ty),0) &" on an attack vector. Do you want to engage? (y/n)"
                if fleet(f).ty=2 and fleet(f).con(15)<rnd_range(1,20) then
                    'Friendly pirates
                    q=friendly_pirates(f)
                    lastturncalled=player.turn
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
    
    lastturncalled=player.turn
    display_stars(1)
    display_ship
    return 0
        
end function

function gen_fname(fname() as string) as short
    fname(1)="merchant convoy"
    fname(2)="pirate fleet"
    fname(3)="company patrol"
    fname(4)="pirate fleet"
    fname(5)="huge fast ship"
    fname(6)=civ(0).n &" fleet"
    fname(7)=civ(1).n &" fleet"
    fname(8)="space station"
    return 0
end function


function join_fight(f as short) as short
    dim as string q,fname(10)
    dim as short f2,des,faggr,f2aggr,i,debug,fty,f2ty,side 
    f2=fleet(f).fighting
    gen_fname(fname())
    fty=fleet(f).ty
    f2ty=fleet(f2).ty
    if f<=6 then fty=8
    if f2<=6 then f2ty=8
    rlprint add_a_or_an(fname(fty),1) &" and "& add_a_or_an(fname(f2ty),0) &" are fighting here."
    q="On which side do you want to join the fight?/"& fname(fty) &f &":"&fty &"/" & fname(f2ty)  &f2 &":"&f2ty  & "/Ignore fight"
    des=menu(bg_ship,q,"",0,18,1) 
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


function playerfightfleet(f as short) as short
    dim as short a,total,f2,e,ter,x,y
    dim text as string
    dim fname(10) as string
    gen_fname(fname()) 
    
    for a=1 to 9
        basis(10).inv(a).v=0
        basis(10).inv(a).p=0
    next
    for x=player.c.x-1 to player.c.x+1
        for y=player.c.y-1 to player.c.y+1
            if x>=0 and y>=0 and x<=sm_x and y<=sm_y then
                if spacemap(x,y)<>0 then ter+=1
            endif
        next
    next
    if fleet(f).ty=ft_ancientaliens then alliance(0)=1 'From now on we can build alliances
    spacecombat(fleet(f),spacemap(player.c.x,player.c.y)+ter)
    if player.dead=0 and fleet(f).flag>0 then player.questflag(fleet(f).flag)=2
    if player.dead>0 and fleet(f).ty=5 then player.dead=21
    for a=1 to 8
        total=total+basis(10).inv(a).v
    next 
    'rlprint ""&total
    if total>0 and player.dead=0 then trading(10)
    if player.dead=-1 then player.dead=0
    if player.dead>0 then
        for a=1 to 128
            if crew(a).hpmax>0 then player.deadredshirts+=1
        next
'        if fleet(f).ty=2 then player.dead=5
'        if fleet(f).ty=4 then player.dead=5
'        if fleet(f).ty=1 then player.dead=13
'        if fleet(f).ty=3 then player.dead=13
'        if fleet(f).ty=5 then player.dead=31
'        if fleet(f).ty=6 then player.dead=32
'        if fleet(f).ty=7 then player.dead=33
        
    endif
    fleet(f).ty=0
    return 0
end function

function merc_dis(fl as short,byref goal as short) as short
    dim as short i,j,dis
    for i=fleet(fl).t to lastwaypoint
        dis+=1
        for j=0 to 2
            if targetlist(i).x=basis(j).c.x and targetlist(i).y=basis(j).c.y then
                goal=j
                return dis
            end if
        next
    next
    
    for i=0 to lastwaypoint
        dis+=1
        for j=0 to 2
            if targetlist(i).x=basis(j).c.x and targetlist(i).y=basis(j).c.y then
                goal=j
                return dis
            end if
        next
    next
    return -1
end function

function fleet_battle(byref red as _fleet,byref blue as _fleet) as short
    dim as integer rscore,bscore
    dim as short i,f,t,j,debug,dam
    debug=1
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
                            if debug=1 and _debug=1 then rlprint blue.mem(i).desig &"hit "&red.mem(t).desig &" for " &dam &" damage"
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
    dim as byte fighting,aggr1,aggr2 ,debug
    
    
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
    if debug=1 and _debug=1 then rlprint "f1:"&aggr1 &"F2:"&aggr2
    'Ancient aliens attack everything
    if fleet(f1).ty=5 or fleet(f2).ty=5 then fighting=1
    
    if f1<=5 or f2<=5 and player.turn<5000 then fighting=0 'Spacestations aren't attcked before turn 5000
    
    if fighting=1 then
        if debug=1 and _debug=1 then rlprint "fight initiated between " &fleet(f1).ty &" and "&fleet(f2).ty
        fleet(f1).fighting=f2
        fleet(f2).fighting=f1
        fleet(f1).con(2)=f2
        fleet(f2).con(2)=f1
        if f1<3 then basis(f1).lastfight=f2
        if f2<3 then basis(f2).lastfight=f1
    endif
    return 0
end function

function ss_sighting(i as short) as short
    dim as string text,text2,text3
    dim as short fn,fn2,a,s,c,debug
    dim as _cords p
    if basis(i).lastsighting=0 then return 0
    fn=basis(i).lastsighting
    fn2=basis(i).lastfight
    debug=1
    if debug=1 and _debug=1 then rlprint fn &":"&fn2
    c=11
    
    if rnd_range(1,100)>basis(i).lastsightingturn-player.turn then
        if basis(i).lastsightingturn-player.turn<25 then
            text ="There are some rumors about"
            if basis(i).lastsightingturn-player.turn<10 then text="You hear a lot of people talking about"
            if basis(i).lastsightingturn-player.turn<5 then text="The station is abuzz with talk about"
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
                text3=text3 &" Word on the station is pirates have attacked!"
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
                            merctrade(fleet(a))
                        endif
                        if fleet(a).c.x=civ(fleet(a).ty-6).home.x and fleet(a).c.y=civ(fleet(a).ty-6).home.y then
                            fleet(a)=unload_f(fleet(a),11)
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
                        if fleet(a).c.x=basis(s).c.x and fleet(a).c.y=basis(s).c.y then merctrade(fleet(a))
                    endif
                    if fleet(a).ty<>3 and fleet(a).ty<>1 then 'No Merchant or Patrol
                        if distance(fleet(a).c,basis(s).c)<12 then
                            basis(s).lastsighting=a
                            basis(s).lastsightingdis=fix(distance(fleet(a).c,basis(s).c))
                            basis(s).lastsightingturn=player.turn
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

function make_fleet() as _fleet
    dim as short roll,i,e,debug
    dim as _fleet f
    roll=rnd_range(1,6)
    if (countfleet(1)<countfleet(2) or faction(0).war(1)>faction(0).war(2)) or (debug=1 and _debug=1) then 
        f=makemerchantfleet
    else
        if configflag(con_easy)=1 or player.turn>25000 then 
            if random_pirate_system>0 then f=makepiratefleet
        else
            f=makepatrol
        endif
    endif
    if roll+patrolmod>10 and debug=0 and _debug=1 then 
        if show_npcs=1 then rlprint roll &":" &patrolmod
        f=makepatrol
        patrolmod=0
        makepat=makepat+1
    endif
    e=999
    for i=1 to 15
        if f.mem(i).movepoints(0)<e and f.mem(i).movepoints(0)>0 then e=f.mem(i).movepoints(0)
    next
    f.mem(0).engine=e
    if f.mem(0).engine<1 then f.mem(0).engine=1
    return f 
end function

function random_pirate_system() as short
    dim pot(_NoPB+2) as short
    dim as short i,l
    for i=0 to _NoPB
        if piratebase(i)>0 then
            l+=1
            pot(l)=sysfrommap(piratebase(i))
            if i=0 then
                l+=1
                pot(l)=sysfrommap(piratebase(i))
            endif
        endif
    next
    if l=0 then
        return -1
    else
        return pot(rnd_range(1,l))
    endif
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

function makequestfleet(a as short) as _fleet
    dim f as _fleet
    dim as short b,c,i,e
    dim as _cords p1
    b=random_pirate_system
    if b<0 then
        p1.x=rnd_range(0,sm_x)
        p1.y=rnd_range(0,sm_y)
    else
        p1=map(b).c
    endif
    f.c=p1
    if a=5 then
        f.ty=4
        f.t=0 'All pirates start with target 9 (random point)
        f.mem(1)=make_ship(8)
        f.flag=15'the infamous anne bonny
    endif
    if a=4 then
        f.ty=4
        f.t=0 'All pirates start with target 9 (random point)
        f.mem(1)=make_ship(10) 'the infamous black corsair
        f.mem(2)=make_ship(2)
        f.mem(3)=make_ship(2)
        f.flag=16
    endif
    if a=3 then
        f.ty=4
        f.t=0 'All pirates start with target 9 (random point)
        f.mem(1)=make_ship(30) 'the infamous anne bonny
        f.mem(2)=make_ship(2)
        f.mem(3)=make_ship(2)
        f.flag=17
    endif
    if a=2 then
        f.ty=4
        f.t=0 'All pirates start with target 9 (random point)
        f.mem(1)=make_ship(31) 'the infamous anne bonny
        f.mem(2)=make_ship(2)
        f.mem(3)=make_ship(2)
        f.mem(4)=make_ship(2)
        f.flag=18
    endif
    if a=1 then
        f.ty=4
        f.t=0 'All pirates start with target 9 (random point)
        f.mem(1)=make_ship(32) 'the infamous anne bonny
        f.mem(2)=make_ship(2)
        f.mem(3)=make_ship(2)
        f.flag=19
    endif
    'Company ships
    if a=6 then
        f.ty=2
        f.t=0
        f.mem(1)=make_ship(34)
        f.c=basis(rnd_range(0,2)).c
    endif    
    if a=7 then
        f.ty=2
        f.t=0
        f.mem(1)=make_ship(35)
        f.c=basis(rnd_range(0,2)).c
    endif
    if a=8 then
        f.ty=2
        f.t=0
        f.mem(1)=make_ship(36)
        f.mem(2)=make_ship(12)
        f.mem(3)=make_ship(12)
        f.c=basis(rnd_range(0,2)).c
    endif
    if a=9 then
        f.ty=2
        f.t=0
        f.mem(1)=make_ship(37)
        f.mem(2)=make_ship(7)
        f.mem(3)=make_ship(7)
        f.c=basis(rnd_range(0,2)).c
    endif
    if a=10 then
        f.ty=2
        f.t=0
        f.mem(1)=make_ship(38)
        f.mem(2)=make_ship(7)
        f.mem(3)=make_ship(7)
        f.mem(4)=make_ship(12)
        f.mem(5)=make_ship(12)
        f.c=basis(rnd_range(0,2)).c
    endif
    e=0
    for i=1 to 15
        if f.mem(i).engine/f.mem(i).hull<e then e=f.mem(i).engine/f.mem(i).hull
    next
    f.mem(0).engine=e
    if f.mem(0).engine<1 then f.mem(0).engine=1
    return f
end function

function makepatrol() as _fleet
    dim f as _fleet
    f.ty=3
    f.mem(1)=make_ship(9)
    f.mem(2)=make_ship(7)
    f.mem(3)=make_ship(7)'one company battleship
    if rnd_range(1,100+player.turn/10000)>75 then f.mem(4)=make_ship(9)
    if rnd_range(1,100+player.turn/10000)>45 then f.mem(5)=make_ship(7)
    f.c=targetlist(firstwaypoint)
    f.t=firstwaypoint+1
    return f
end function

function makemerchantfleet() as _fleet
    dim f as _fleet
    dim text as string
    dim as short a,b,debug
    f.ty=1
    a=rnd_range(1,3)
    for b=1 to a
        f.mem(b)=make_ship(6) 'merchantmen
        text=text &f.mem(b).icon
    next
    if rnd_range(1,100)>80-makepat*2 then
        for b=a+1 to a+2
            if rnd_range(1,100)<45+makepat then
                f.mem(b)=make_ship(7) 'escorts
                text=text &f.mem(b).icon
            else
                f.mem(b)=make_ship(12)
            endif
        next
    endif
    f.c=targetlist(firstwaypoint)
    f.t=firstwaypoint+1
    if show_NPCs=1 then rlprint ""&a &":"& b &":"& text
    return f
end function 

function makepiratefleet(modifier as short=0) as _fleet
    dim f as _fleet
    dim as short maxroll,r,a
    
    dim as short b,c
    b=random_pirate_system
    f.ty=2
    f.con(15)=rnd_range(1,15)-rnd_range(1,10)-player.turn/10000 'Friendlyness
    f.t=0 'All pirates start with target 9 (random point)
    f.c=map(b).c
    maxroll=player.turn/15000'!
    if maxroll>60 then maxroll=60
    for a=1 to rnd_range(0,1)+cint(maxroll/20)    
        r=rnd_range(1,maxroll)+modifier
        f.mem(a)=make_ship(2)
        if r>15 then f.mem(a)=make_ship(3)
        if r>35 then f.mem(a)=make_ship(4)
        if r>45 then f.mem(a)=make_ship(5)
   next a
    return f
end function

function makealienfleet() as _fleet
    dim f as _fleet
    dim as short i,e,sys
    f.ty=5
    f.mem(1)=make_ship(11)
    sys=sysfrommap(specialplanet(29))
    if sys<0 then sys=sysfrommap(specialplanet(30))
    if sys<0 then sys=rnd_range(0,laststar)
    f.c=map(sys).c
    
    for i=1 to 15
        if f.mem(i).engine/f.mem(i).hull<e then e=f.mem(i).engine/f.mem(i).hull
    next
    f.mem(0).engine=e
    if f.mem(0).engine<1 then f.mem(0).engine=1
    return f
end function

function makecivfleet(slot as short) as _fleet
    dim f as _fleet
    dim as short s,p,i,e
    f.ty=6+slot
    s=civ(slot).phil
    if civ(slot).phil=2 and rnd_range(1,100)<50 then s=s+rnd_range(1,2)
    if civ(slot).phil=3 and rnd_range(1,100)<33 then s=s+rnd_range(2,8)
    if s<1 then s=1
    for p=1 to s
        if rnd_range(0,100)<55-civ(slot).phil*5 then
            f.mem(p)=civ(slot).ship(0)
        else
            f.mem(p)=civ(slot).ship(1)
        endif
        f.mem(p).c=rnd_point
    next
    f.c=civ(slot).home
    f.t=3+(slot*4)
    
    for i=1 to 15
        if f.mem(i).engine/f.mem(i).hull<e then e=f.mem(i).engine/f.mem(i).hull
    next
    f.mem(0).engine=e
    if f.mem(0).engine<1 then f.mem(0).engine=1
    return f
end function

function civfleetdescription(f as _fleet) as string
    dim t as string
    dim as short slot,nos,a
    slot=f.ty-6
    if slot<0 or slot>1 then return ""
    for a=1 to 15
        if f.mem(a).hull>0 then nos+=1
    next
    if nos=1 then t="a single "
    if nos>1 and nos<4 then t="a small group of "
    if nos>=4 and nos<8 then t="a group of "
    if nos>=8 then t="a fleet of "
    't=t &"("&slot &")"
    if f.mem(1).hull<=2 then t=t &" tiny "
    if f.mem(1).hull>2 and f.mem(1).hull<5 then t=t &" small "
    if f.mem(1).hull>10 and f.mem(1).hull<15 then t=t &" big "
    if f.mem(1).hull>15 then t=t &" huge "
    if nos=1 then
        t=t &" ship "
    else
        t=t &" ships "
    endif
    if civ(slot).contact=1 then
        if nos=1 then
            t=t &" It's configuration is "&civ(slot).n &"."
        else
            t=t &" They are "&civ(slot).n &"."
        endif
    else
        if nos=1 then
            t=t &"It's configuration is alien, but it seems to be "
            if civ(slot).inte=1 then t=t &"an explorer."
            if civ(slot).inte=2 then t=t &"a trader."
            if civ(slot).inte=3 then t=t &"a warship."
        else
            t=t &"their configuration is alien but they seem to be "
            if civ(slot).inte=1 then t=t &"explorers."
            if civ(slot).inte=2 then t=t &"traders."
            if civ(slot).inte=3 then t=t &"warships."
        endif
    endif
    if show_NPCs then t=t &slot
    return t
end function

function add_fleets(byref target as _fleet,byref source as _fleet) as _fleet
    dim as short a,b
    dim text as string
    ' Find last ship of target
    do
        a=a+1
        text=text & target.mem(a).icon
    loop until target.mem(a).hull=0 or a>14
    if a<15 then
        do 
            b=b+1
            target.mem(a)=source.mem(b)
            text=text & target.mem(a).icon
 
            a=a+1
        loop until a>14 or b>14
        source=empty_fleet
    endif
    'if target.ty=2 then target=piratecrunch(target)
    
    if show_NPCs=1 then rlprint text
    return target
end function

function piratecrunch(fl as _fleet) as _fleet
    'Turns pirates into bigger ship. 3 F=1C 3C=1D 3D=1B
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

function bestpilotinfleet(f as _fleet) as short
    dim as short a,r
    for a=1 to 15
        if f.mem(a).pilot(0)>r then r=f.mem(a).pilot(0)
    next
    return r
end function

function countfleet(ty as short) as short
    dim as short a,r
    for a=3 to lastfleet
        if fleet(a).ty=ty then r=r+1
    next
    return r
end function

function update_targetlist()as short
    static lastcalled as short
    dim as short b,piratesys
    piratesys=random_pirate_system
    if piratesys<0 then return 0
    targetlist(1).x=player.c.x
    targetlist(1).y=player.c.y
    if frac(lastcalled/25)=0 then
        targetlist(0).x=map(piratesys).c.x-30+rnd_range(0,60)
        targetlist(0).y=map(piratesys).c.y-10+rnd_range(0,20)
        targetlist(2)=map(piratesys).c
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

function count_diet(slot as short,diet as short) as short
    dim as short i,c
    for i=1 to 16
        if planets(slot).mon_template(i).diet=diet and planets(slot).mon_noamin(i)>0 then c=c+(planets(slot).mon_noamax(i)+planets(slot).mon_noamin(i))/2
    next
    return c
end function

function makemonster(a as short, map as short, forcearms as byte=0) as _monster
    dim enemy as _monster
    dim as short d,e,l,mapo,g,r,ahp,debug,prettybonus,tastybonus
    dim as single easy
    static ti(11) as string
    static ch(11) as short
    static ad(11) as single
    dim as string prefix
    debug=1
    if a=0 then
        if debug=1 and _debug=1 then rlprint "ERROR: Making monster 0",14
        return enemy
    endif
    
    enemy.made=a
    enemy.dhurt="hurt"
    enemy.dkill="dies"
        
    ti(0)="avian"
    ti(1)="arachnid"
    ti(2)="insect"
    ti(3)="mammal"
    ti(4)="reptile"
    ti(5)="snake"
    ti(6)="humanoid"
    ti(7)="cephalopod"
    ti(8)="centipede"
    ti(9)="amphibian"
    ti(10)="gastropod"
    ti(11)="fish"
    ad(0)=1
    ad(1)=0
    ad(2)=0
    ad(3)=3
    ad(4)=3
    ad(5)=1
    ad(6)=2
    ad(7)=1
    ad(8)=1
    ad(9)=1
    ad(10)=1
    
    ch(0)=66
    ch(1)=65
    ch(2)=73
    ch(3)=77
    ch(4)=asc("l")
    ch(5)=asc("s")
    ch(6)=asc("h")
    ch(7)=asc("q")
    ch(8)=asc("c")
    ch(9)=asc("f")
    ch(10)=asc("g")
    ch(11)=asc("f")
    for g=0 to 128
        if crew(g).hp>0 then ahp=ahp+1
    next
    
    'b=(ahp\12)+1 'HD size
'    'b=b+planets(map).depth
'    if b<2 then b=2
'    if b>8 then b=8
'    
'    c=(ahp\15)+1 'Times rolled
'    if c<1 then c=1
'    if c>10 then c=10
'     'maxpossible
'        
    enemy.made=a 'saves how the critter was made for respawning
    
    if a=1 or a=24 then 'standard critter
        'Postion
        if planets(map).atmos=1 then enemy.hasoxy=1
        'Fighting Stats
        enemy.range=1.5
        enemy.weapon=rnd_range(1,5)-3+planets(map).depth
        if enemy.weapon<0 then enemy.weapon=0
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(3,6)
        
        enemy.nocturnal=0
        if planets(map).rot>0 and planets(map).depth=0 then
            if rnd_range(1,100)<66 then
                enemy.nocturnal=rnd_range(1,2)
            endif
        endif
        'Behavior
        enemy.aggr=rnd_range(0,2)
        enemy.respawns=1
        d=rnd_range(1,8) '1 predator, 2 herbivore, 3 scavenger
      
        if d=8 then enemy.diet=3
        if d<5 then enemy.diet=2
        if d>=5 and d<8 then enemy.diet=1
        if enemy.diet=1 and debug=1 and _debug=1 then rlprint "Rate:" &(count_diet(map,1)+1)& ":" &(count_diet(map,2)+1)& "="& (count_diet(map,1)+1)/(count_diet(map,2)+1)
        if enemy.diet=1 and (count_diet(map,1)+1)/(count_diet(map,2)+1)<=.25 then enemy.diet=2 'Need 3 herbivoures at least to support one carni
        if enemy.diet=3 and (count_diet(map,3)+1)/(count_diet(map,1)+1)<=.25 then enemy.diet=2 'Need 3 carni at least to support one scav
        enemy.speed=rnd_range(0,5)+rnd_range(0,4)+rnd_range(0,enemy.weapon)
        if enemy.speed<1 then enemy.speed=1
        if enemy.speed>19 then enemy.speed=19
        if rnd_range(1,100)<(planets(map).atmos-1)*3/planets(map).grav then
            if a=1 or rnd_range(1,100)>66 then
                enemy.movetype=mt_fly
            endif
        endif
        'Looks
        enemy.cmmod=rnd_range(1,2)+enemy.diet*3
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.biomod=1
        enemy.lang=-1
        enemy.atcost=rnd_range(7,10)
        enemy.intel=rnd_range(1,5)
        if a=1 then enemy.intel=enemy.intel+rnd_range(1,3)
        if rnd_range(1,15)<enemy.intel then enemy.aggr=1
        if enemy.intel=6 and rnd_range(1,100)<33 then
            enemy.range=3
            enemy.sight=3
            enemy.pumod=-1 'gives 2 arms minimum
            enemy.swhat="shoots bows and arrows"
            enemy.scol=4
            enemy.atcost=rnd_range(6,8)
            enemy.items(1)=94
            enemy.itemch(1)=15
            enemy.items(2)=91
            enemy.itemch(2)=55
        endif
        if enemy.intel>=7 and rnd_range(1,100)<33  then
            enemy.range=4
            enemy.sight=4
            enemy.pumod=-1 'gives 2 arms minimum
            enemy.swhat="fires a primitive handgun"
            enemy.scol=7
            enemy.atcost=rnd_range(5,7)
            enemy.items(1)=94
            enemy.itemch(1)=15
            enemy.items(2)=94
            enemy.itemch(2)=15
            enemy.items(2)=92
            enemy.itemch(2)=55
        endif
        if forcearms>0 then enemy.pumod=-1 '2 arms minimum
        g=rnd_range(0,10)
        if a=24 and rnd_range(1,100)>50 then g=11
        enemy.tile=ch(g)
        enemy.sprite=261+g
        if g=1 then enemy.movetype=mt_climb 'Spinnen klettern
        if g=6 then enemy.intel=enemy.intel+1
        if g=9 or a=24 then enemy.movetype=mt_climb
        if g=10 then enemy.speed+=3
        if enemy.speed>19 then enemy.speed=19
        if rnd_range(1,100)<15-enemy.intel*2 then enemy.disease=rnd_range(1,15)
        enemy.hp=enemy.hp+rnd_range(1,5)+rnd_range(1,ad(g))+rnd_range(1,1+planets(map).depth)
            
        enemy.hp=enemy.hp+rnd_range(0,2)+enemy.weapon+planets(map).depth
        enemy.hpmax=enemy.hp
        enemy.sdesc=ti(g)
        enemy=randomcritterdescription(enemy,g,enemy.hp/planets(map).grav,enemy.movetype,enemy.pumod,enemy.diet,0,planets(map).depth)
        if a=24 then enemy=randomcritterdescription(enemy,g,enemy.hp,enemy.movetype,enemy.pumod,enemy.diet,1,planets(map).depth)
        if rnd_range(1,15)<planets(map).depth then
            enemy.breedson=rnd_range(0,5+planets(map).depth)
        endif
        if enemy.breedson=0 and enemy.aggr=0 and enemy.intel<4 and rnd_range(1,100)<33 then
            enemy.hp=enemy.hp+rnd_range(1,4)+rnd_range(1,2)
            enemy.hpmax=enemy.hp
            enemy.invis=2
            enemy.aggr=0
            enemy.weapon+=2
            enemy.speed-=4
            if enemy.speed<1 then enemy.speed=1
            enemy.atcost=enemy.atcost-2
            enemy.diet=1
        endif
        
        if enemy.weapon>2 then enemy.col=12
        if enemy.hp>9 then 
            enemy.tile=asc(ucase(chr(enemy.tile)))
            enemy.hpmax=enemy.hpmax+rnd_range(1,2)
            enemy.hp=enemy.hpmax
        else
            enemy.tile=asc(lcase(chr(enemy.tile)))
            if enemy.ti_no<>0 and enemy.ti_no<1000 then enemy.ti_no+=1
        endif
        if enemy.ti_no<1000 and forcearms<>0 then
            if enemy.ti_no>=930 and enemy.ti_no<942 then enemy.ti_no=942
            if enemy.ti_no>=917 and enemy.ti_no<929 then enemy.ti_no=929
            if enemy.ti_no>=904 and enemy.ti_no<916 then enemy.ti_no=916
            if enemy.ti_no>=891 and enemy.ti_no<903 then enemy.ti_no=903
            if enemy.ti_no>=879 and enemy.ti_no<890 then enemy.ti_no=890
            if enemy.ti_no>=864 and enemy.ti_no<878 then enemy.ti_no=878
            if enemy.ti_no>=852 and enemy.ti_no<864 then enemy.ti_no=864
            if enemy.ti_no>=839 and enemy.ti_no<851 then enemy.ti_no=851
            if enemy.ti_no>=826 and enemy.ti_no<838 then enemy.ti_no=838
            if enemy.ti_no>=813 and enemy.ti_no<825 then enemy.ti_no=825
            if enemy.ti_no>=800 and enemy.ti_no<812 then enemy.ti_no=812
        endif
        enemy.sdesc=enemy.sdesc
        'enemy.invis=2
        if enemy.hpmax>20 then prefix="giant"
        if enemy.hpmax>10 and enemy.hpmax<21 then prefix= "huge"
        if enemy.hpmax>10 then prefix=""
        if enemy.weapon>0 then 
            if prefix="" then
                prefix=prefix &"vicious"
            else 
                prefix=prefix &" ,vicious"
            endif
        endif
        if prefix<>"" then prefix=prefix &" "
        enemy.sdesc=prefix &enemy.sdesc
        if enemy.ti_no=0 then enemy.ti_no=g+1001
        if rnd_range(1,50)<enemy.hpmax then enemy.stunres=rnd_range(1,4)
    endif
    
    if a=2 then 'Powerful standard critter
        'Postion
        g=rnd_range(0,4)
        enemy.tile=ch(g)
        enemy.sdesc=ti(g)
        
        enemy.sprite=261+g
        'Fighting Stats
        enemy.range=1.5
        enemy.weapon=rnd_range(1,4)-2
        if enemy.weapon<0 then enemy.weapon=0
        enemy.hp=10+rnd_range(5,15)+rnd_range(5,ad(g))*5+rnd_range(1,1+planets(map).depth)
        enemy.hp=enemy.hp+rnd_range(1,2)+enemy.weapon
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(3,6)+2
        enemy.armor=1
        'Behavior
        enemy.aggr=0
        enemy.intel=rnd_range(1,4)
        enemy.respawns=1
        enemy.biomod=1.5
        enemy.stunres=rnd_range(3,6)
        enemy.diet=1
        enemy.speed=(rnd_range(1,5)+rnd_range(1,5)+rnd_range(0,enemy.weapon))
        
        enemy=randomcritterdescription(enemy,g,enemy.hp,enemy.movetype,enemy.pumod,enemy.diet,0,planets(map).depth)        
        
        enemy.ti_no=g+750
        enemy.atcost=rnd_range(6,8)
        if enemy.speed<=1 then enemy.speed=1
        if enemy.speed>19 then enemy.speed=19
        if rnd_range(1,100)<(planets(map).atmos-1)*3/planets(map).grav then 
            enemy.movetype=mt_fly
            g=1
            enemy=randomcritterdescription(enemy,g,enemy.hp,enemy.movetype,enemy.pumod,enemy.diet,0,planets(map).depth)        
        else
            if rnd_range(1,100)<33 then
            enemy.hasoxy=1
            enemy.stunres=7
            select case planets(map).temp
            case is>200
                    enemy.ti_no=1051
                    enemy.armor=2
                    enemy.col=12
                    enemy.tile=asc("W")
                    enemy.sprite=272
                    enemy.track=45
                    enemy.speed=8
                    enemy.sdesc="fireworm"
                    enemy.range=2.5
                    enemy.swhat="spits molten rock"
                    enemy.ldesc="A huge worm. It's biochemistry silicon based, wich allows it to live in extremely high heat. It's body is made of rock, and molten sulfur is used as blood."
                   case is<-150
                    enemy.ti_no=1052
                    enemy.armor=2
                    enemy.col=11
                    enemy.tile=asc("W")
                    enemy.sprite=273
                    enemy.track=26
                    enemy.speed=9
                    enemy.sdesc="ammoniaworm"
                    enemy.ldesc="A huge worm. It's biochemistry is ammonia based, allowing it to survive in very low temperatures. It slithers leaving an ammonia track."
                   
                   case else
                    enemy.ti_no=1053
                    
                    enemy.armor=2
                    enemy.col=4
                    enemy.tile=asc("W")
                    enemy.sprite=274
                    enemy.track=4
                    enemy.speed=4
                    enemy.sdesc="earthworm"
                    enemy.ldesc="A huge worm. It has no eyes and a huge maw. Feelers run alongside its body, with wich it touches the ground sensing the vibrations its prey causes." 
                end select
                for l=0 to rnd_range(2,5)
                    enemy.items(l)=99
                    enemy.itemch(l)=33
                next
                enemy.biomod=2.2
            endif
            If planets(map).depth>0 then
                enemy.stunres=8
                enemy.ti_no=1054
                enemy.movetype=mt_dig
                enemy.track=4
                enemy.weapon=5
                enemy.speed=4
                enemy.armor=4
                enemy.col=7
                enemy.tile=asc("W")
                enemy.track=4
                enemy.sdesc="stoneworm"
                enemy.sprite=275
                enemy.ldesc="This creature slowly digs through the stone, gnawing at it with metal teeth. It's thick skin is embedded with rocks and stones for protection."
            endif
        endif
                
        'Looks
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.lang=-1
        if enemy.tile=22 then enemy.movetype=mt_climb 'Spinnen klettern
        enemy.col=6
    endif
    
    if a=1 or a=2 or a=24 then 'Tasty and pretty for random critters
        if a=24 then prettybonus=5
        select case rnd_range(1,100)+prettybonus*5
        case 50 to 75
            enemy.pretty=rnd_range(1,10)
        case 76 to 95
            enemy.pretty=rnd_range(5,10)
        case 96 to 100
            enemy.pretty=rnd_range(8,10)
        end select
        if isgardenworld(map) then tastybonus=3
        if enemy.diet=0 then tastybonus+=1 'Herbivoures are usually better eating
        select case rnd_range(1,100)+tastybonus*5
        case 50 to 75
            enemy.tasty=rnd_range(1,10)
        case 76 to 95
            enemy.tasty=rnd_range(5,10)
        case is >96
            enemy.tasty=rnd_range(8,10)
        end select
    endif
    
    if a=3 or a=7 then'Pirate band
         '7 Non agressive
        'Postion
        enemy.intel=5
        enemy.atcost=rnd_range(7,9)
        enemy.hasoxy=1
        enemy.faction=2
        enemy.ti_no=a+1010
        'Fighting Stats
        enemy.weapon=rnd_range(1,4)
        enemy.range=0.5+enemy.weapon
        enemy.hp=enemy.hp+rnd_range(4,10)
        enemy.hp=enemy.hp+5+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.allied=2
        enemy.enemy=1
        'Behavior
        enemy.aggr=0
        enemy.respawns=0
        enemy.speed=(rnd_range(0,6)+rnd_range(0,6)+rnd_range(0,enemy.weapon))
        if enemy.speed<=4 then enemy.speed=4
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=rnd_range(17,19)
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=276
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.col=192
        enemy.sdesc="pirate band"
        enemy.ldesc="a squad of pirates, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=6
        enemy.lang=9
        if faction(0).war(2)>=100 then 
            enemy.aggr=0
        else
            enemy.aggr=1
        endif
        enemy.faction=2
    endif
    
    if a=4 then 'Plantmonster 
            
        enemy.ti_no=1014
        enemy.speed=-1
        
        enemy.weapon=rnd_range(0,1)
        enemy.range=2+enemy.weapon
        enemy.hp=(rnd_range(1,3)+rnd_range(1,3))*(enemy.weapon+1)
        
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.biomod=1.2
        enemy.tile=ASC("P")
        enemy.sprite=277
        enemy.ti_no=1014
        enemy.col=4
        enemy.scol=4
        enemy.atcost=rnd_range(6,8)
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.swhat="shoots a volley of sharp thorns"
        enemy.sdesc="Plantmonster"
        enemy.ldesc="A squat brownish trunk, 1.5 to 2m high, covered by dark green leaves. Extremly long vines are used to gather food for this immobile creature"
    endif
    
    if a=5 then 'apollo
        enemy.ti_no=1015
        enemy.lang=4
        enemy.weapon=4
        enemy.range=1.5
        enemy.hp=rnd_range(50,60)
        enemy.armor=2
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.speed=12
        enemy.tile=ASC("H")
        enemy.sprite=278
        enemy.col=14
        enemy.scol=11
        enemy.atcost=rnd_range(3,4)
        enemy.movetype=mt_ethereal
        enemy.hasoxy=1
        enemy.stunres=4
        enemy.intel=5
        enemy.sight=7
        enemy.biomod=2
        enemy.respawns=0
        enemy.dhurt="hurt"
        enemy.dkill="dies"   
        enemy.swhat="shoots a lightning bolt "
        enemy.sdesc="Apollo"
        enemy.ldesc="3 Meters tall, a mountain of muscles, lightning strikes wherever he points"
    endif
    
    if a=6 then 'Fighting leaf
        enemy.ti_no=1016
        'Fighting Stats
        enemy.range=1.5
        enemy.weapon=0
        enemy.hp=1
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(8,10)
        'Behavior
        enemy.aggr=0
        enemy.respawns=0
        enemy.speed=14
        enemy.movetype=mt_fly
        'Looks
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sdesc="leaf"
        enemy.ldesc="four prehensile leafs lift this small creature in the air. A dark red, woody appendege drips poison" 
        enemy.lang=-1
        enemy.biomod=0.5
        enemy.atcost=2
        enemy.tile=ASC("o")
        enemy.sprite=279
        enemy.col=10
    endif
    
    if a=8 then
        enemy.stunres=10
        enemy.ti_no=1018
        enemy.faction=5 'robots
        enemy.sdesc="defense robot"
        enemy.ldesc="a metal ball, about 1m in diameter, sensor array to the right, weapons array to the left. It wobbly floats, obviously using some sort of antigrav."
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shots a disintegrator beam "
        enemy.scol=12
        enemy.armor=2
        enemy.respawns=0
        enemy.lang=-3
        enemy.sight=5
        enemy.hasoxy=1
        for l=1 to 5
            enemy.hp=enemy.hp+rnd_range(1,5)
        next
        enemy.hp=5+enemy.hp+planets(a).depth
        enemy.biomod=0
        enemy.weapon=rnd_range(1,6)-3
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=enemy.weapon-1
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.speed=14
        enemy.tile=asc("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=280
        enemy.atcost=rnd_range(6,8)
        for l=1 to rnd_range(2,5)
            enemy.items(l)=96
            enemy.itemch(l)=33
        next       
        enemy.faction=5    
    endif
    
    if a=9 then
        enemy.stunres=10
        enemy.ti_no=1019
        enemy.faction=5 'Vault bots
        enemy.sdesc="defense robot"
        enemy.ldesc="a metal ball, about 1m in diameter, sensor array to the right, weapons array to the left. It wobbly floats, obviously using some sort of antigrav."
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shoots a disintegrator beam "
        enemy.scol=12
        enemy.respawns=0
        enemy.armor=1
        enemy.lang=-3
        enemy.sight=5
        enemy.hasoxy=1
        enemy.atcost=rnd_range(6,8)
        for l=1 to 5+planets(a).depth
            enemy.hp=enemy.hp+rnd_range(1,5+planets(a).depth)
        next
        enemy.hp=15+enemy.hp+planets(a).depth
        enemy.weapon=rnd_range(1,6)
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=enemy.weapon+1
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=0
        enemy.aggr=0
        enemy.speed=14
        enemy.tile=ASC("R")
        enemy.col=139
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=278
        for l=0 to rnd_range(2,6)
            enemy.items(l)=96
            enemy.itemch(l)=33
        next
        enemy.faction=5
    endif
            
    if a=10 then 'seeweed
        enemy.ti_no=1020
        enemy.made=10
        'Fighting Stats
        enemy.range=1.5
        enemy.weapon=0
        enemy.hp=1
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(8,10)
        enemy.biomod=0.5
        'Behavior
        enemy.aggr=1
        enemy.respawns=1
        enemy.breedson=12
        enemy.speed=2
        enemy.movetype=mt_climb
        enemy.atcost=rnd_range(6,8)
        'Looks
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sdesc="Seawead"
        enemy.ldesc="growing upwards from the bottom of the ocean, this seawead grows incredibly fast. It lazily brushes around, leaving acidburns on any fish or flesh it touches. obviously a carnivorous plant"
        enemy.tile=Asc("o")
        enemy.sprite=283
        enemy.col=10
    endif
     
    if a=11 then 'Sandworm
        enemy.stunres=8
        enemy.ti_no=1021
        enemy.made=11
        enemy.hp=50        
        for l=1 to 8
            enemy.hp=enemy.hp+rnd_range(1,10)
        next
        enemy.armor=3
        enemy.weapon=2
        enemy.speed=14
        enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=1.5
        enemy.aggr=0
        enemy.tile=Asc("W")
        enemy.sprite=284
        enemy.col=14
        enemy.atcost=rnd_range(3,5)
        enemy.sight=4
        enemy.hasoxy=1
        enemy.track=179
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sdesc="Sandworm"
        enemy.ldesc="At first a wave in the sand, and then a huge maw opens to devour whatever tresspasses in his domain." 
    endif
        
    if a=12 then  'Hunting Spider
        enemy.ti_no=1022
        enemy.sdesc="Spider"
        enemy.ldesc="A huge hunting spider. They seem to have found a taste for human flesh"
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sight=1
        enemy.range=1.5
        enemy.weapon=2
        enemy.hp=rnd_range(1,3)+8
        enemy.atcost=rnd_range(6,8)
        for l=1 to 3
            enemy.hp=enemy.hp+rnd_range(1,6)
        next
        enemy.hpmax=enemy.hp
        enemy.biomod=1
        enemy.speed=12
        enemy.aggr=0
        enemy.tile=Asc("A")
        enemy.sprite=285
        enemy.col=4
    endif
    
    if a=13 then 'Invisibles
        enemy.ti_no=1023
        enemy.sdesc="????"
        enemy.ldesc="Something is here. But you cant see anything."
        enemy.dhurt="hurt"
        enemy.dkill="silent"
        enemy.sight=4
        enemy.breedson=3
        enemy.invis=1
        enemy.range=1.5
        enemy.biomod=1.3
        enemy.atcost=rnd_range(9,12)
        enemy.weapon=1
        enemy.hp=rnd_range(1,3)
        for l=1 to 5
            enemy.hp=enemy.hp+rnd_range(1,5)
        next
        enemy.biomod=1.5
        enemy.hpmax=enemy.hp
        enemy.speed=16
        enemy.aggr=0
        enemy.tile=Asc("A")
        enemy.col=4
    endif
        
    if a=14 or a=88 then
        enemy.faction=8 'Citizen
        enemy.ti_no=-1
        enemy.sdesc="citizen"
        enemy.ldesc="a friendly human pioneer"
        enemy.lang=2
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.speed=8
        enemy.pumod=5
        enemy.sight=4
        enemy.allied=1
        enemy.enemy=2
        enemy.range=1.5
        enemy.atcost=rnd_range(6,12)
        enemy.hasoxy=1
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=4
        enemy.intel=5
        enemy.hp=4
        enemy.col=23
        enemy.aggr=1
        if a=88 then 
            enemy.faction=8
            enemy.allied=0
            enemy.aggr=1
            enemy.lang=34
        endif
    endif
    
    if a=15 then
        enemy.ti_no=1026
        enemy.faction=1 'Enemy Awayteam
        enemy.made=15
        enemy.sdesc="awayteam"
        enemy.ldesc="another freelancer team"
        enemy.lang=5
        enemy.intel=5
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=6
        enemy.allied=1
        enemy.enemy=2
        enemy.aggr=1
        enemy.hasoxy=1
        enemy.diet=4 'Resources
        enemy.sight=35
        enemy.pumod=60
        enemy.movetype=mt_fly
        enemy.atcost=rnd_range(6,8)
        
        enemy.range=rnd_range(1,4)+0.5
        if enemy.range<=2.5 then
            enemy.scol=11
            enemy.swhat="shoots gauss guns"
        else
            enemy.scol=12
            enemy.swhat="shoots lasers"
        endif
        enemy.hp=rnd_range(2,5)+rnd_range(2,5)
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(1,3)
        enemy.weapon=rnd_range(1,3)
        enemy.tile=64
        enemy.sprite=287
        enemy.col=9
        enemy.speed=8
        enemy.respawns=0
        enemy.items(1)=-RI_weaponsarmor
        enemy.itemch(1)=99
        enemy.items(2)=96
        enemy.itemch(2)=25
        enemy.items(3)=-RI_weaponsarmor
        enemy.itemch(3)=88
        enemy.items(3)=96
        enemy.itemch(3)=25
        enemy.items(4)=-RI_weaponsarmor
        enemy.itemch(4)=77
        enemy.items(5)=96
        enemy.itemch(5)=66
    
    endif
    
    if a=16 then 'Spitting Critter
        enemy.ti_no=1001+g
        enemy.range=2.5
        enemy.swhat="spits acid"
        enemy.scol=10
        enemy.weapon=rnd_range(1,4)-2
        if enemy.weapon<0 then enemy.weapon=0
        enemy.atcost=rnd_range(6,8)
        for l=1 to 5
            enemy.hp=enemy.hp+rnd_range(2,8)
        next
        enemy.hp=enemy.hp+rnd_range(1,2)+enemy.weapon
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(3,6)+2
        enemy.armor=1
        enemy.aggr=0
        enemy.respawns=1
        enemy.speed=(rnd_range(1,5)+rnd_range(1,5)-rnd_range(0,enemy.weapon))
        if enemy.speed<=1 then enemy.speed=1
        if rnd_range(1,100)<(planets(map).atmos-1)*10/planets(map).grav then 
            enemy.movetype=mt_fly
        endif
        'Looks
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.lang=-1
        g=rnd_range(0,4)
        enemy.tile=ch(g)
        if enemy.tile=22 then enemy.movetype=mt_climb 'Spinnen klettern
        enemy.col=6
        enemy.sdesc=ti(g)
        enemy=randomcritterdescription(enemy,g,enemy.hp,enemy.movetype,enemy.pumod,enemy.diet,0,planets(map).depth)
        enemy.sprite=270+g
        enemy.biomod=2.3
    endif
        
    
    if a=17 then 'Stone Monster
        enemy.ti_no=1026
        enemy.speed=-1
        enemy.atcost=rnd_range(8,12)
        enemy.weapon=rnd_range(1,2)
        enemy.range=2+enemy.weapon
        enemy.hp=(rnd_range(1,3)+rnd_range(1,3))*(enemy.weapon)
        enemy.biomod=1.4
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.tile=80
        enemy.col=7
        enemy.scol=15
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.swhat="shoots a volley of sharp stones"
        enemy.sdesc="Stonemonster"
        enemy.ldesc="a 3m tall stalactite, yet obviously alive. roots run across the floor, some of them connecting to the carcasses of other cave dwellers."
        enemy.sprite=288
    endif
    
    if a=18 then 'Breedworm
        enemy.ti_no=1027
        enemy.atcost=rnd_range(7,9)
        enemy.range=1.5
        enemy.weapon=rnd_range(1,5)-3+planets(map).depth
        if enemy.weapon<0 then enemy.weapon=0
        for l=1 to 1+planets(map).depth
            enemy.hp=enemy.hp+rnd_range(1,2)
        next
        enemy.hp=enemy.hp+rnd_range(0,2)+enemy.weapon+planets(map).depth
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(3,6)
        enemy.biomod=0.2
        'Behavior
        enemy.aggr=0
        enemy.respawns=1
        enemy.speed=(rnd_range(0,4)+rnd_range(0,3)-rnd_range(0,enemy.weapon))
        if enemy.speed<=1 then enemy.speed=1
        if enemy.tile=22 then enemy.movetype=mt_climb 'Spinnen klettern
        'Looks
        enemy.cmmod=rnd_range(1,2)
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.lang=-1
        enemy.tile=119
        enemy.sprite=289
        enemy.col=54
        enemy.sdesc="slimy worm"
        enemy.ldesc="A huge slimy worm. It seems to breed by splitting in the middle, and grows very very fast."
        enemy.breedson=rnd_range(2,8+planets(map).depth)        
        if enemy.breedson>6 then
            enemy.col=96
            enemy.armor=0
            enemy.hp=1
            enemy.hpmax=1
        endif
    endif
    
    if a=19 then 'Invisible bot
        enemy.ti_no=1028
        enemy.faction=5
        enemy.sdesc="????"
        enemy.ldesc="the air shimmers showing some kind of cloaking device."
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shoots a disintegrator beam "
        enemy.scol=12
        enemy.respawns=0
        enemy.atcost=rnd_range(3,5)
        enemy.armor=2
        enemy.lang=-3
        enemy.sight=5
        enemy.hasoxy=1
        enemy.invis=1
        enemy.hp=rnd_range(1,5)+rnd_range(1,5)+rnd_range(1,3)+planets(map).depth
        for l=1 to 5
            enemy.hp=enemy.hp+rnd_range(1,10)
        next
        enemy.weapon=rnd_range(4,6)-3
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=enemy.weapon-1
        if enemy.range<1.5 then enemy.range=1.5
        enemy.tile=28
        enemy.speed=13
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
    endif
            
    
    if a=20 then 'bluecap
        enemy.ti_no=1029
        enemy.atcost=rnd_range(6,8)
        enemy.sdesc="armed reptile"
        enemy.ldesc="A 3m tall reptile with yellow scales. It has 3 tentacles as arms, and 4 legs. It wears clothes and a blue helmet, and wields an obviously human made Gauss gun!"
        enemy.lang=6
        enemy.sprite=290
        enemy.faction=8
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.aggr=1
        enemy.biomod=1
        enemy.cmmod=5
        enemy.intel=5
        enemy.sight=3
        enemy.range=3.5
        enemy.weapon=2
        enemy.swhat="shoots its gaussgun!"
        enemy.scol=11
        for l=1 to 3
            enemy.hp=enemy.hp+rnd_range(1,3)
        next
        enemy.hpmax=enemy.hp
        enemy.speed=10
        enemy.aggr=1
        enemy.tile=Asc("L")
        enemy.col=47
        enemy.items(0)=7
        enemy.itemch(0)=66
    endif  

 
    if a=21 OR a=66 or a=67 or a=68 or a=69 then 'Tombspider 
        enemy.ti_no=1030
        enemy.sdesc="Spider"
        enemy.ldesc="A huge hunting spider. They seem to have found a taste for human flesh"
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.atcost=rnd_range(6,8)
        enemy.sight=1
        enemy.range=1.5
        enemy.weapon=2
        for l=1 to 3
            enemy.hp=enemy.hp+rnd_range(1,6)
        next
        enemy.sprite=274
        enemy.hpmax=enemy.hp
        enemy.speed=12
        enemy.aggr=0
        enemy.biomod=1.45
        enemy.tile=Asc("A")
        if a=66 then 'Tombworm
            enemy.ti_no=1031
            enemy.tile=Asc("I")
            enemy.col=8
            enemy.armor=3
            enemy.sdesc="Beetle"
            enemy.ldesc="A huge beetle with mandibles strong enough to sever a limb. By some curious coincidence it's carapace shows a marking resembling a human skull." 
            enemy.sprite=275
        endif
        if a=67 then enemy.invis=2 'Hiding TOmbspider
        if a=68 then 'Tombworm
            enemy.ti_no=1032
            enemy.tile=asc("w")
            enemy.col=15
            enemy.armor=0
            enemy.weapon=0
            enemy.hp=rnd_range(1,15)+5
            enemy.breedson=15
            enemy.sdesc="worm"
            enemy.ldesc="a swarm of slimy pale white worms with sharp teeth and 4 compound eyes on a ridge above its maw."
            enemy.invis=0
        endif 
        if a=69 then 'Tombworm
            enemy.ti_no=1033
            enemy.tile=asc("w")
            enemy.col=14
            enemy.armor=1
            enemy.weapon=1
            enemy.hp=rnd_range(1,15)+25
            enemy.sdesc="worm"
            enemy.ldesc="a swarm of slimy pale yellow worms with sharp teeth and 4 compound eyes on a ridge above its maw. Bone spikes portrude from their backs."
            enemy.invis=0
        endif
        enemy.col=8
    endif
    
    if a=22 then 'Intelligent Centipede
        enemy.ti_no=1034
        enemy.sdesc="centipede"
        enemy.ldesc="a 3m long centipede. It only uses its lower 12 legs for movement. It's upper body is erect and its 12 arms end in slender 3 fingered hands. It has a single huge compound eye at the top of its head. It has 2 mouths, one for eating and one for breathing and talking. It is a herbivore." 
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sight=3
        enemy.range=1.5
        enemy.weapon=1
        for l=1 to 2
            enemy.hp=enemy.hp+rnd_range(1,10)
        next
        enemy.cmmod=8
        enemy.atcost=rnd_range(6,8)
        enemy.hpmax=enemy.hp
        enemy.speed=6
        enemy.aggr=1
        enemy.intel=5
        enemy.diet=2
        enemy.biomod=3
        enemy.col=7
        enemy.tile=Asc("c")
        enemy.lang=8
        enemy.intel=9
        enemy.sprite=280
        
    endif
            
    if a=23 then 'Casino Thug
        enemy.ti_no=1512
        enemy.sight=35
        enemy.sdesc="thug"
        enemy.ldesc="an armed band of thugs"
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=6
        enemy.atcost=rnd_range(6,8)
        enemy.aggr=0
        enemy.diet=0 
        enemy.pumod=60
        enemy.hasoxy=1
        enemy.intel=5
        
        enemy.range=rnd_range(1,4)+0.5
        if enemy.range<=2.5 then
            enemy.scol=11
            enemy.swhat="shoots gauss guns"
        else
            enemy.scol=12
            enemy.swhat="shoots lasers"
        endif
        enemy.hp=rnd_range(2,5)+rnd_range(2,5)
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,1)
        enemy.weapon=rnd_range(1,3)
        enemy.tile=asc("H")
        enemy.sprite=277
        enemy.col=18
        enemy.speed=8
        enemy.respawns=0
        for l=0 to rnd_range(2,6)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
    endif   
    
    'a=24 is taken for fish
    
    if a=25 or a=26 or a=37 or a=80 then 'Intelligent Insectoids
        if a=25 then enemy.ti_no=1036
        if a=26 then enemy.ti_no=1037
        if a=37 or a=80 then enemy.ti_no=1038
        enemy.faction=9
        enemy.sight=3
        enemy.sdesc="insectoid"
        enemy.ldesc="an insect with 6 legs, compound eyes and long feelers. They are between 1 and 3 m long and can stand on their hindlegs to use theif front legs for manipulation. Their colourfull carapace seems to signifiy some caste system."
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        'enemy.intel=4
        enemy.biomod=1
        enemy.atcost=rnd_range(3,6)
        enemy.cmmod=6
        enemy.aggr=1'Resources
        enemy.pumod=60
        enemy.col=rnd_range(36,41)
        enemy.range=rnd_range(1,4)+0.5
        enemy.hp=rnd_range(2,5)+enemy.col/2
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,1)
        enemy.tile=asc("i")
        enemy.sprite=277
        enemy.cmmod=15
        enemy.col=rnd_range(108,113)
        enemy.speed=6
        enemy.hasoxy=1
        enemy.lang=-11
        if a=26 then enemy.lang=-13
        if a=25 then
            enemy.col=12
            enemy.weapon=2
            enemy.armor=2
            if rnd_range(1,150)<25 then enemy.lang=-12
        endif
        if a=37 then enemy.lang=-17
        if a=80 then enemy.lang=12
        enemy.respawns=1
    endif
    
    if a=27 then 'Living Plasma
        enemy.ti_no=1039
        enemy.stunres=9
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)
        enemy.atcost=rnd_range(6,8)
        enemy.movetype=mt_ethereal
        enemy.aggr=0
        enemy.sight=4
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.biomod=1
        enemy.hasoxy=1
        enemy.hp=rnd_range(2,18)+rnd_range(2,8)
        enemy.range=3.5
        enemy.weapon=2
        enemy.speed=18
        enemy.sdesc="cloud"
        enemy.ldesc="several mulitcolored gas clouds. They seem to be moving towards you and are held together by static electricity."
        enemy.tile=176
        enemy.col=205
        enemy.swhat="shoots lightning bolts"
        enemy.scol=11
        enemy.hpmax=enemy.hp
    endif
    
    if a=28 then 'Slaved Citizen
        enemy.ti_no=-1
        enemy.sdesc="citizen"
        enemy.ldesc="a dazed looking human pioneer"
        enemy.lang=14
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=2
        enemy.pumod=5
        enemy.intel=1
        enemy.sight=4
        enemy.range=1.5
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=4
        enemy.hp=4
        enemy.atcost=12
        enemy.col=23
        enemy.speed=6
        enemy.aggr=1
        enemy.hasoxy=1
    endif
    
    if a=29 then 'Living crystal
        enemy.stunres=9
        enemy.ti_no=1041
        enemy.sdesc="living crystal"
        enemy.ldesc="This being resembles an insect. 3 meters high, 6 legs and 5 arms and a tiny head. Underneath it's transparent crystaline shell you see pink flesh and blue veins."
        enemy.lang=15
        enemy.biomod=2
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=0
        enemy.pumod=5
        enemy.sight=4
        enemy.intel=5
        enemy.range=1.5
        enemy.weapon=4
        enemy.atcost=11
        enemy.armor=7
        enemy.hasoxy=1
        enemy.tile=Asc("*")
        enemy.sprite=180
        enemy.hpmax=24+rnd_range(2,5)+rnd_range(2,5)
        enemy.col=236
        enemy.aggr=0
        enemy.speed=7
        enemy.hp=enemy.hpmax
        enemy.faction=5
    endif
    
    
    if a=30 then
        enemy.ti_no=1042
        enemy.sight=3
        enemy.sdesc="starcreature"
        enemy.ldesc="This creature resembles are giant starfish with 5 legs bent downwards ending in 7 fingered hands. It uses them for walking as well as for fine manipulating. The top of it's body features 3 eye stalks with compound eyes. A tube under its body ends in a maw with sharp teeth."
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.intel=3
        enemy.biomod=1
        enemy.cmmod=6
        enemy.intel=5
        enemy.atcost=rnd_range(6,8)
        enemy.aggr=1'Resources
        enemy.pumod=60
        enemy.range=rnd_range(1,4)+0.5
        enemy.hp=rnd_range(1,4)+rnd_range(1,4)
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,1)
        enemy.tile=asc("x")
        enemy.sprite=277
        enemy.cmmod=15
        enemy.col=rnd_range(108,113)
        enemy.speed=8
        enemy.lang=-10
        enemy.respawns=1
    endif
    
    if a=31 then
        enemy.ti_no=1043
        enemy.sdesc="living crystal"
        enemy.ldesc="This being resembles an insect. 3 meters high, 6 legs and 5 arms and a tiny head. Underneath it's transparent crystaline shell you see pink flesh and blue veins."
        enemy.lang=15
        enemy.biomod=2
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=0
        
        enemy.intel=5
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.weapon=4
        enemy.atcost=11
        enemy.armor=7
        enemy.hasoxy=1
        enemy.tile=Asc("*")
        enemy.sprite=180
        enemy.hpmax=44+rnd_range(2,5)+rnd_range(2,5)
        enemy.hp=enemy.hpmax
        enemy.col=236
        enemy.aggr=0
        enemy.speed=7
        enemy.hp=enemy.hpmax
        enemy.faction=5
    endif

    if a=32 then
        enemy.ti_no=1044
        enemy.faction=1
        enemy.made=32
        enemy.sight=35
        enemy.sdesc="crewmember"
        enemy.ldesc="a member of the crew of this ship"
        enemy.lang=16
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=6
        enemy.intel=5
        enemy.aggr=1
        enemy.diet=0
        enemy.allied=1
        enemy.enemy=2
        enemy.hasoxy=1
        enemy.pumod=60
        enemy.atcost=rnd_range(6,8)
        enemy.range=rnd_range(1,4)+0.5
        if enemy.range<=2.5 then
            enemy.scol=11
            enemy.swhat="shoots gauss guns"
        else
            enemy.scol=12
            enemy.swhat="shoots lasers"
        endif
        enemy.hp=rnd_range(2,5)+rnd_range(2,5)
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(1,3)
        enemy.weapon=rnd_range(1,3)
        enemy.tile=Asc("H")
        enemy.sprite=287
        enemy.col=53
        enemy.speed=10
        enemy.respawns=0
        for l=0 to rnd_range(2,6)
            enemy.items(l)=20
            enemy.itemch(l)=15
        next
    endif
    
    if a=33 then
        enemy.ti_no=1045 'Dead Crewmembers
        enemy.made=32
        enemy.hpmax=rnd_range(2,5)+rnd_range(2,5)
        enemy.hp=0
        enemy.tile=64
        enemy.sprite=287
        enemy.col=53
        enemy.respawns=0
        enemy.sdesc="crewmember"
        enemy.ldesc="crewmember"
        e=rnd_range(1,100)
'        if e<20 then
'            d=rnd_range(3,9)
'            enemy.ldesc="A dead member of the crew of this ship. He has a " & make_item(d).desig &" between his legs, firm in his hands. His head is missing."
'            enemy.items(0)=d
'            enemy.itemch(0)=100
'        endif
'        if e>19 and e<50 then
'            enemy.ldesc="This crewmember suffocated in his spacesuit."
'        endif
'        if e>49 and e<60 then
'            enemy.ldesc="A crewmember lying dead in a corner."
'        endif
'        if e>59 and e<70 then
'            enemy.ldesc="This crewmember took off his helmet. His head is covered in ice."
'        endif
'        if e>69 and e<80 then
'            enemy.ldesc="This crewmember suffocated in his spacesuit."
'        endif
'        if e>79 then
'            enemy.ldesc="This crewmember suffocated in his spacesuit. His oxygen tank is missing"
'        endif
    endif
    
    if a=34 then 'Mushroom
        enemy.ti_no=1046
        enemy.hp=rnd_range(2,5)
        enemy.hpmax=enemy.hp
        enemy.tile=asc("9")
        enemy.col=26
        enemy.sdesc="crawling mushroom"
        enemy.ldesc="a huge mushroom with a prehensile rootsystem"
        enemy.biomod=1.2
        enemy.speed=2
        enemy.atcost=8
        enemy.range=2.5
        enemy.sight=3.5
        enemy.weapon=1
        enemy.swhat="shoots acidic spores."
        enemy.scol=10
        enemy.breedson=25
    endif
    
    if a=35 then
        enemy.ti_no=1001+g 'Powerful standard critter
        g=rnd_range(0,4)
        enemy.tile=ch(g)
        enemy.sdesc=ti(g)
        enemy.sprite=261+g
        'Fighting Stats
        enemy.range=1.5
        enemy.weapon=rnd_range(1,4)-2
        if enemy.weapon<0 then enemy.weapon=0
        for l=1 to 5+ad(g)
            enemy.hp=enemy.hp+rnd_range(3,6)
        next
        enemy.hp=enemy.hp+rnd_range(1,2)+enemy.weapon+10
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(3,6)+2
        enemy.armor=1
        'Behavior
        enemy.aggr=0
        enemy.intel=rnd_range(1,4)
        enemy.respawns=0
        enemy.biomod=1.5
        enemy.diet=1
        enemy.speed=rnd_range(1,5)+rnd_range(1,5)+rnd_range(0,enemy.weapon)
        if enemy.speed>19 then enemy.speed=19
        if enemy.speed<1 then enemy.speed=1
        enemy.invis=2
        enemy=randomcritterdescription(enemy,g,enemy.hp,enemy.movetype,enemy.pumod,enemy.diet,0,planets(map).depth)        
        enemy.atcost=5
        enemy.atcost=rnd_range(6,8)
        if rnd_range(1,100)<(planets(map).atmos-1)*10/planets(map).grav then 
            enemy.movetype=mt_fly
            g=1
            enemy=randomcritterdescription(enemy,g,enemy.hp,enemy.movetype,enemy.pumod,enemy.diet,0,planets(map).depth)        
        endif
        'Looks
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.lang=-1
        if enemy.tile=22 then enemy.movetype=mt_climb 'Spinnen klettern
        enemy.col=6
    endif
    
    if a=36 then
        enemy.ti_no=1047
        enemy.hp=1
        enemy.hpmax=1
        enemy.aggr=0
        enemy.speed=16
        enemy.atcost=99
        enemy.breedson=5
        enemy.tile=asc("o")
        enemy.col=39
        enemy.biomod=1
        enemy.sight=5
        enemy.hasoxy=1
        enemy.sdesc="batlike creature"
        enemy.ldesc="a small creature with 3 eyes, no mouth or legs, using 2 skin wings to fly"
        enemy.faction=9
    endif
    
    '37=aliens on generation ship
    
    if a=38 then 'Bouncy Ball
        enemy.ti_no=1048
        enemy.hp=1
        enemy.hpmax=enemy.hp
        enemy.tile=asc("Q")
        enemy.col=192
        enemy.aggr=0
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sdesc="bouncing ball"
        enemy.ldesc="a orange ball. It has several yellow eyespots, and moves by jumping and bouncing. It has two yellow birdlike claws at the lower end. It appears to be hollow, with no recognizable organs. How exactly it is alive is a mystery."        
        enemy.biomod=5.2
        enemy.speed=8
        enemy.atcost=5
        enemy.range=2.5
        enemy.sight=3.5
        enemy.hasoxy=1
        enemy.weapon=0
        enemy.scol=192
    endif
    
    
    if a=39 then 'Citizen
        enemy.ti_no=-1
        enemy.faction=8
        enemy.hasoxy=1
        enemy.sdesc="citizen"
        enemy.ldesc="a friendly human pioneer"
        enemy.lang=18
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.allied=1
        enemy.intel=5
        enemy.enemy=2
        enemy.pumod=5
        enemy.sight=4
        enemy.speed=8
        enemy.range=1.5
        enemy.atcost=rnd_range(6,12)
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=4
        enemy.hp=4
        enemy.col=23
        enemy.aggr=1
        enemy.faction=1
    endif
        
    if a=40 then 'zombies
        enemy.ti_no=1050
        enemy.hasoxy=1
        enemy.made=40
        enemy.sight=35
        enemy.sdesc="fast miner"
        enemy.ldesc="a miner in a spacesuit with an empty expression on his face. He moves increadibly fast!"
        enemy.lang=5
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=4
        enemy.aggr=0
        enemy.diet=1
        enemy.pumod=60
        enemy.atcost=3
        enemy.disease=17
        enemy.range=rnd_range(1,4)+0.5
        if enemy.range<=2.5 then
            enemy.scol=11
            enemy.swhat="shoots gauss guns"
        else
            enemy.scol=12
            enemy.swhat="shoots lasers"
        endif
        enemy.hp=rnd_range(2,5)+rnd_range(2,5)+5
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(1,3)
        enemy.weapon=rnd_range(1,3)
        enemy.tile=64
        enemy.sprite=287
        enemy.col=20
        enemy.speed=15
        enemy.respawns=0
        for l=0 to rnd_range(2,6) step 2
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
            enemy.items(l+1)=96
            enemy.itemch(l+1)=15
        next
    endif
    
    
    if a=41 then 'Powerful space standard critter
        enemy.ti_no=1001+g
        g=rnd_range(0,4)
        enemy.tile=ch(g)
        enemy.sdesc=ti(g)
        enemy.sprite=261+g
        enemy.range=1.5
        enemy.weapon=rnd_range(1,4)-2
        if enemy.weapon<0 then enemy.weapon=0
        for l=1 to 6+ad(g)
            enemy.hp=enemy.hp+rnd_range(3,6)
        next
        enemy.hp=enemy.hp+rnd_range(1,2)+enemy.weapon
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(3,6)+2
        enemy.armor=1
        'Behavior
        enemy.aggr=0
        enemy.intel=rnd_range(1,4)
        enemy.respawns=1
        enemy.biomod=1.5
        enemy.diet=1
        enemy.speed=(rnd_range(1,5)+rnd_range(1,5)+rnd_range(0,enemy.weapon))/10
        
        enemy=randomcritterdescription(enemy,g,enemy.hp,enemy.movetype,enemy.pumod,enemy.diet,0,planets(map).depth)        
        
        enemy.atcost=rnd_range(6,8)
        if enemy.speed>19 then enemy.speed=19
        if rnd_range(1,100)<(planets(map).atmos-1)*3/planets(map).grav then 
            enemy.movetype=mt_fly
            g=1
            enemy=randomcritterdescription(enemy,g,enemy.hp,enemy.movetype,enemy.pumod,enemy.diet,0,planets(map).depth)        
        else
            if rnd_range(1,100)<33 then
            select case planets(map).temp
                   case is>200
                    enemy.ti_no=1051
                    enemy.armor=2
                    enemy.col=12
                    enemy.tile=asc("W")
                    enemy.sprite=272
                    enemy.track=45
                    enemy.speed=12
                    enemy.sdesc="fireworm"
                    enemy.range=2.5
                    enemy.swhat="spits molten rock"
                    enemy.ldesc="A huge worm. It's biochemistry silicon based, wich allows it to live in extremely high heat. It's body is made of rock, and molten sulfur is used as blood."
                   case is<-150
                    enemy.ti_no=1052
                
                    enemy.armor=2
                    enemy.col=11
                    enemy.tile=asc("W")
                    enemy.sprite=273
                    enemy.track=26
                    enemy.speed=10
                    enemy.sdesc="ammoniaworm"
                    enemy.ldesc="A huge worm. It's biochemistry is ammonia based, allowing it to survive in very low temperatures. It slithers leaving an ammonia track."
                   
                   case else
                    enemy.ti_no=1053
                
                    enemy.armor=2
                    enemy.col=4
                    enemy.tile=asc("W")
                    enemy.sprite=274
                    enemy.track=4
                    enemy.speed=6
                    enemy.sdesc="earthworm"
                    enemy.ldesc="A huge worm. It has no eyes and a huge maw. Feelers run alongside its body, with wich it touches the ground sensing the vibrations its prey causes." 
                end select
                enemy.biomod=2.2
                for l=0 to rnd_range(2,5)
                    enemy.items(l)=99
                    enemy.itemch(l)=33
                next
            endif
            If planets(map).depth>0 then
                enemy.ti_no=1054
                enemy.movetype=mt_dig
                enemy.track=4
                enemy.weapon=5
                enemy.speed=4
                enemy.armor=2
                enemy.col=7
                enemy.tile=asc("W")
                enemy.track=4
                enemy.sdesc="stoneworm"
                enemy.sprite=275
                enemy.ldesc="This creature slowly digs through the stone, gnawing at it with metal teeth. It's thick skin is embedded with rocks and stones for protection."
            endif
        endif
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.lang=-1
        enemy.sdesc="mutated "&enemy.sdesc
        enemy.ldesc="mutated "&enemy.ldesc
        enemy.disease=16
        if enemy.tile=22 then enemy.movetype=mt_climb 'Spinnen klettern
        enemy.col=6
    endif
    
    if a=42 then 'Intelligent Cephalopods  
        enemy.ti_no=1055     
        enemy.sight=3
        enemy.sdesc="amphibious cephalopod"
        enemy.ldesc="A cephalopod with 9 arms, 3 end in big suction cups, with serrated edges that also serve as fingers. 3 others end in beaked mouths and 3 end in fins. It's saucer shaped body has 9 small eyes, spaced evenly along the rim. It's body is about 0.5m wide and its tentacles are 1m long."  
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.intel=3
        enemy.biomod=1
        enemy.cmmod=5
        enemy.atcost=rnd_range(6,8)
        enemy.aggr=1
        enemy.pumod=60
        enemy.range=rnd_range(1,4)+0.5
        enemy.hp=rnd_range(2,5)+rnd_range(2,5)
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,1)
        enemy.tile=asc("Q")
        enemy.movetype=mt_hover
        enemy.sprite=277
        enemy.cmmod=15
        enemy.col=rnd_range(180,185)
        enemy.speed=14
        enemy.lang=-19
        enemy.respawns=1
    endif
    
    if a=43 then 'Mushrroompickers
        enemy.ti_no=1056     
        enemy.sight=3
        enemy.sdesc="small humanoid"
        enemy.ldesc="a 0.5m high humaoid, with long arms and legs, and green, scaly skin. It's very light and thin, and its fingers end in sucking cups."
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.intel=3
        enemy.biomod=1
        enemy.cmmod=6
        enemy.atcost=rnd_range(6,8)
        enemy.aggr=1
        enemy.pumod=-60
        enemy.range=1.5
        enemy.hp=1
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,1)
        enemy.tile=asc("h")
        enemy.sprite=277
        enemy.cmmod=15
        enemy.col=rnd_range(102,107)
        enemy.speed=8
        enemy.lang=-20
        enemy.respawns=1
    endif
    
    if a=44 then 'Cavemonster
        enemy.ti_no=1057     
        enemy.sight=3
        enemy.sdesc="small humanoid"
        enemy.ldesc="a 1m high humaoid, with long arms and legs, and green, scaly skin. It's very light and thin, and its fingers end in sucking cups. It has horns and a spiked tail."
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.intel=3
        enemy.biomod=1.2
        enemy.cmmod=6
        enemy.atcost=rnd_range(6,8)
        enemy.aggr=0
        enemy.pumod=-60
        enemy.range=1.5
        enemy.hp=10
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,1)
        enemy.tile=asc("H")
        enemy.sprite=277
        enemy.cmmod=15
        enemy.col=rnd_range(102,107)
        enemy.speed=14
        enemy.respawns=0
    endif
    
    if a=45 then 'Scentient Tree
        enemy.ti_no=1058     
        enemy.sight=3
        enemy.sdesc="tree"
        enemy.ldesc="a small tree or big bush with a cone shaped trunk, and a wide surface root system. It has several small openings and a few flexible branches near the top that end in big blue globes. It is obviously capable of moving slowly!"
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.intel=4
        enemy.atcost=rnd_range(1,4)
        enemy.aggr=1
        enemy.lang=-21
        enemy.pumod=-60
        enemy.range=1.5
        enemy.hp=10+rnd_range(1,5)+rnd_range(1,5)
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,3)
        enemy.tile=asc("T")
        enemy.sprite=277
        enemy.cmmod=6
        enemy.col=2
        enemy.speed=4
        enemy.respawns=1
        enemy.biomod=4
        enemy.faction=9
    endif
        
    if a=46 then 'Defense bots
        enemy.stunres=10
        enemy.ti_no=1059     
        enemy.faction=5
        enemy.hasoxy=1
        enemy.sdesc="defense robot"
        enemy.ldesc="a metal ball, about 1m in diameter, sensor array to the right, weapons array to the left. It's locomotion unit seems to be damaged, it lies on the ground, surrounded by pieces of primitve art, now and then rising a few centimeters into the air, and slamming back into the ground."     
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shoots a disintegrator beam "
        enemy.scol=12
        enemy.respawns=0
        enemy.armor=1
        enemy.lang=-3
        enemy.sight=5
        enemy.atcost=rnd_range(6,8)
        for l=1 to 5+planets(a).depth
            enemy.hp=enemy.hp+rnd_range(1,6)
        next
        enemy.hp=50+enemy.hp+planets(a).depth
        
        enemy.weapon=rnd_range(1,6)
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=4
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=0
        enemy.aggr=0
        enemy.tile=ASC("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=278
        enemy.speed=-1
        enemy.col=20
        enemy.sdesc="armored robot"
        enemy.sight=enemy.sight+3
        enemy.range=enemy.sight
        enemy.armor=5
        enemy.weapon=enemy.weapon+1
        enemy.range=1.5
        enemy.atcost=rnd_range(7,9)
        enemy.sprite=282
        for l=0 to rnd_range(5,8)
            enemy.items(l)=94
            enemy.itemch(l)=33
        next
        enemy.faction=5
    endif
    
    if a=47 then 'Sgt Pinback
        enemy.ti_no=1060     
        enemy.made=47
        enemy.hpmax=rnd_range(2,5)+rnd_range(2,5)
        enemy.hp=0
        enemy.tile=64
        enemy.sprite=287
        enemy.col=53
        enemy.respawns=0
        enemy.sdesc="crewmember"
        enemy.ldesc="crewmember, on his uniform is a name tag identifying him as 'Sgt. Pinback'"
    endif
    
    if a=48 then 'Ted ROfes
        'enemy.ti_no=1061
        enemy.ti_no=1511
        enemy.biomod=0
        enemy.sdesc="Ted Rofes, the shipsdoctor. "
        enemy.ldesc="Ted Rofes, the shipsdoctor."
        enemy.lang=22
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=10
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.atcost=rnd_range(6,12)
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=4
        enemy.hp=4
        enemy.speed=10
        enemy.col=9
        enemy.aggr=1
        enemy.faction=9
        enemy.respawns=0
    endif
    
    if a=49 then 'Pirate Ship Crew
        enemy.ti_no=1062
        enemy.faction=2
        enemy.atcost=rnd_range(7,9)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(1,4)
        enemy.range=0.5+enemy.weapon
        enemy.hp=rnd_range(0,5)+5+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.respawns=0
        enemy.speed=(rnd_range(0,4)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<=5 then enemy.speed=6
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.allied=2
        enemy.intel=5
        enemy.enemy=2
        enemy.biomod=0
        enemy.col=rnd_range(17,19)
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=276
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.col=192
        enemy.sdesc="pirate band"
        enemy.ldesc="a squad of pirates, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=6
        enemy.lang=9
        if faction(0).war(2)>=100 then 
            enemy.aggr=0
        else
            enemy.aggr=1
        endif
        enemy.col=186
        enemy.sdesc="pirate shipcrew"
        enemy.armor=1
        enemy.weapon=enemy.weapon+1
        enemy.speed=10
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
        enemy.respawns=0
        if faction(0).war(2)>=100 then 
            enemy.aggr=0
        else
            enemy.aggr=1
        endif
        enemy.faction=2
    endif
    
    if a=50 then 'Pirate elite band
        enemy.ti_no=1063
        enemy.faction=2
        enemy.atcost=rnd_range(7,9)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(1,4)
        enemy.range=0.5+enemy.weapon
        enemy.hp=rnd_range(10,15)+15+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.allied=2
        enemy.enemy=2
        enemy.respawns=0
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
        enemy.movetype=rnd_range(0,2)
        enemy.biomod=0
        enemy.col=rnd_range(17,19)
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=276
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.col=192
        enemy.sdesc="pirate band"
        enemy.ldesc="a squad of pirates, armed to the teeth and ready to fight"        
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=6
        enemy.lang=9
        enemy.col=108  
        enemy.sdesc="pirate elite troop"
        enemy.armor=2
        enemy.weapon=enemy.weapon+2
        enemy.hp=enemy.hp+rnd_range(1,6)
        enemy.swhat="shoot plasmarifles "
        enemy.scol=20
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
        enemy.atcost=rnd_range(5,7)
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next           
        
        if faction(0).war(2)>=100 then 
            enemy.aggr=0
        else
            enemy.aggr=1
        endif
    endif
    
    if a=51 then 'Defensebot
        enemy.stunres=10
        enemy.ti_no=1064
        enemy.faction=5
        enemy.sdesc="defense robot"
        enemy.ldesc="a metal ball, about 1m in diameter, sensor array to the right, weapons array to the left. It wobbly floats, obviously using some sort of antigrav."
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shots a disintegrator beam "
        enemy.scol=12
        enemy.armor=2
        enemy.respawns=0
        enemy.lang=-3
        enemy.sight=5
        enemy.hasoxy=1
            
        for l=1 to 6
            enemy.hp=enemy.hp+rnd_range(1,6)
        next
        enemy.hp=15+enemy.hp+planets(a).depth
        enemy.biomod=0
        enemy.weapon=rnd_range(1,6)-3
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=enemy.weapon-1
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.speed=18
        enemy.tile=asc("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=280
        enemy.atcost=rnd_range(6,8)
        for l=1 to rnd_range(2,5)
            enemy.items(l)=96
            enemy.itemch(l)=33
        next  
        enemy.speed=18
        enemy.col=11
        enemy.sdesc="fast robot"
        enemy.sight=enemy.sight+3
        enemy.armor=0
        enemy.sprite=281
        enemy.atcost=rnd_range(4,6)
        enemy.items(0)=96
        enemy.itemch(0)=33
        enemy.faction=5
    endif
    
    if a=52 then 'Defensebot
        enemy.stunres=10
        enemy.ti_no=1065
        enemy.faction=5
        enemy.sdesc="defense robot"
        enemy.ldesc="a metal ball, about 1m in diameter, sensor array to the right, weapons array to the left. It wobbly floats, obviously using some sort of antigrav."
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shots a disintegrator beam "
        enemy.scol=12
        enemy.armor=2
        enemy.respawns=0
        enemy.lang=-3
        enemy.sight=5
        enemy.hasoxy=1
        for l=1 to 5
            enemy.hp=enemy.hp+rnd_range(1,5)
        next
        enemy.hp=15+enemy.hp+planets(a).depth
        enemy.biomod=0
        enemy.weapon=rnd_range(1,6)-3
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=enemy.weapon-1
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.speed=18
        enemy.tile=asc("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=280
        enemy.atcost=rnd_range(6,8)
        for l=1 to rnd_range(2,5)
            enemy.items(l)=96
            enemy.itemch(l)=33
        next  
        enemy.speed=14
        enemy.col=20
        enemy.sdesc="armored robot"
        enemy.sight=enemy.sight+3
        enemy.armor=5
        enemy.sprite=282
        enemy.atcost=rnd_range(8,10)
        enemy.items(0)=96
        enemy.itemch(0)=33
        enemy.faction=5
    endif
        
    if a=53 then 'Fast Bot
        enemy.stunres=10
        enemy.ti_no=1066
        enemy.faction=5
        enemy.hasoxy=1
        enemy.sdesc="defense robot"
        enemy.ldesc="a metal ball, about 1m in diameter, sensor array to the right, weapons array to the left. It's locomotion unit seems to be damaged, it lies on the ground, surrounded by pieces of primitve art, now and then rising a few centimeters into the air, and slamming back into the ground."     
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shoots a disintegrator beam "
        enemy.scol=12
        enemy.respawns=0
        enemy.armor=1
        enemy.lang=-3
        enemy.sight=5
        enemy.atcost=rnd_range(6,8)
        for l=1 to 3+planets(a).depth
            enemy.hp=enemy.hp+rnd_range(1,3)
        next
        enemy.hp=15+enemy.hp+planets(a).depth
        enemy.weapon=rnd_range(1,6)
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=4
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=0
        enemy.aggr=0
        enemy.speed=14
        enemy.tile=ASC("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=278
        enemy.speed=-1
        enemy.col=20
        enemy.sdesc="armored robot"
        enemy.sight=enemy.sight+3
        enemy.range=enemy.sight
        enemy.armor=5
        enemy.weapon=enemy.weapon+1
        enemy.range=1.5
        enemy.atcost=rnd_range(7,9)
        enemy.sprite=282
        for l=0 to rnd_range(5,8)
            enemy.items(l)=94
            enemy.itemch(l)=33
        next
        enemy.speed=16
        enemy.col=11
        enemy.sdesc="fast robot"
        enemy.sight=enemy.sight+3
        enemy.armor=0
        enemy.sprite=280
        enemy.atcost=rnd_range(3,4)
        enemy.items(0)=96
        enemy.itemch(0)=33
        enemy.faction=5
    endif
    
    if a=54 then 'Defense Bot
        enemy.stunres=10
        enemy.ti_no=1067
        enemy.faction=5
        enemy.hasoxy=1
        enemy.sdesc="defense robot"
        enemy.ldesc="a metal ball, about 1m in diameter, sensor array to the right, weapons array to the left. It's locomotion unit seems to be damaged, it lies on the ground, surrounded by pieces of primitve art, now and then rising a few centimeters into the air, and slamming back into the ground."     
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shoots a disintegrator beam "
        enemy.scol=12
        enemy.respawns=0
        enemy.armor=1
        enemy.lang=-3
        enemy.sight=5
        enemy.atcost=rnd_range(6,8)
        for l=1 to 3+planets(a).depth
            enemy.hp=enemy.hp+rnd_range(1,6)
        next
        enemy.hp=15+enemy.hp+planets(a).depth
        enemy.weapon=rnd_range(1,6)
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=4
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=0
        enemy.aggr=0
        enemy.speed=14
        enemy.tile=ASC("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=278
        enemy.speed=-1
        enemy.col=20
        enemy.sdesc="armored robot"
        enemy.sight=enemy.sight+3
        enemy.range=enemy.sight
        enemy.armor=5
        enemy.weapon=enemy.weapon+1
        enemy.range=1.5
        enemy.atcost=rnd_range(7,9)
        enemy.sprite=282
        for l=0 to rnd_range(5,8)
            enemy.items(l)=94
            enemy.itemch(l)=33
        next
        enemy.speed=12
        enemy.col=20
        enemy.sdesc="armored robot"
        enemy.sight=enemy.sight+3
        enemy.armor=5
        enemy.weapon=enemy.weapon+1
        enemy.range=1.5
        enemy.atcost=rnd_range(7,9)
        enemy.sprite=282
        enemy.items(0)=96
        enemy.itemch(0)=33
        enemy.faction=5
    endif
    
    if a=55 then 'Living Energy
        enemy.stunres=10
        enemy.ti_no=1068
        enemy.faction=5
        enemy.hasoxy=1
        enemy.sdesc="defense robot"
        enemy.ldesc="a metal ball, about 1m in diameter, sensor array to the right, weapons array to the left. It's locomotion unit seems to be damaged, it lies on the ground, surrounded by pieces of primitve art, now and then rising a few centimeters into the air, and slamming back into the ground."     
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shoots a disintegrator beam "
        enemy.scol=12
        enemy.respawns=0
        enemy.armor=1
        enemy.lang=-3
        enemy.sight=5
        enemy.atcost=rnd_range(6,8)
        for l=1 to 3+planets(a).depth
            enemy.hp=enemy.hp+rnd_range(1,6)
        next
        enemy.hp=15+enemy.hp+planets(a).depth
        enemy.weapon=rnd_range(1,6)
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=4
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=0
        enemy.aggr=0
        enemy.speed=14
        enemy.tile=ASC("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=278
        enemy.hp=rnd_range(1,5)+rnd_range(1,5)+rnd_range(1,3)+planets(map).depth
        for l=1 to 5
            enemy.hp=enemy.hp+rnd_range(1,5)
        next
        enemy.atcost=2
        enemy.sdesc="living energy"
        enemy.ldesc="a pulsating shimmer in the air, it moves through the metal walls as if they were not there, only getting slightly more solid before it fires."
        enemy.weapon=rnd_range(4,6)-3
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=enemy.weapon-1
        if enemy.range<1.5 then enemy.range=1.5
        enemy.tile=asc("Z")
        enemy.col=rnd_range(192,197)
        enemy.speed=18
        enemy.movetype=mt_ethereal
        enemy.hpmax=enemy.hp
        enemy.faction=5
    endif
    
    if a=56 then 'Bladebot
        enemy.stunres=10
        enemy.ti_no=1069
        enemy.faction=5
        enemy.hasoxy=1
        enemy.sdesc="defense robot"
        enemy.ldesc="a metal ball, about 1m in diameter, sensor array to the right, weapons array to the left. It's locomotion unit seems to be damaged, it lies on the ground, surrounded by pieces of primitve art, now and then rising a few centimeters into the air, and slamming back into the ground."     
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shoots a disintegrator beam "
        enemy.scol=12
        enemy.respawns=0
        enemy.armor=6
        enemy.lang=-3
        enemy.sight=5
        enemy.atcost=rnd_range(6,8)
        for l=1 to 3+planets(a).depth
            enemy.hp=enemy.hp+rnd_range(1,5)
        next
        enemy.hp=150+enemy.hp+planets(a).depth
        
        enemy.weapon=rnd_range(1,6)
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=4
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=0
        enemy.aggr=0
        enemy.speed=14
        enemy.tile=ASC("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=278
        enemy.hp=30+rnd_range(1,5)+rnd_range(1,5)+rnd_range(1,3)+planets(map).depth
        for l=1 to 5
            enemy.hp=enemy.hp+rnd_range(1,5)
        next
        enemy.sdesc="bladebot"
        enemy.weapon=10
        enemy.atcost=12
        enemy.tile=ASC("R")
        enemy.armor=8
        enemy.speed=12
        enemy.col=219
        enemy.ldesc="A massive ball of metal on tracks, 5 arms end in massive blades, so thin they are almost invisible."
        enemy.range=1.5
        enemy.sight=4
        enemy.hpmax=enemy.hp
        enemy.faction=5
    endif


    If a=57 then 'Armed Citizen
        enemy.ti_no=1513
        enemy.faction=8
        enemy.sight=5
        enemy.sdesc="armed citizen"
        enemy.ldesc="a gruff human pioneer hardened by living away from civilization"
        enemy.lang=18
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=6
        enemy.aggr=1
        enemy.intel=5
        enemy.allied=2
        enemy.enemy=1
        enemy.pumod=6
        enemy.atcost=rnd_range(6,8)
        
        enemy.movetype=rnd_range(0,2)
        enemy.range=rnd_range(1,4)+0.5
        if enemy.range<=2.5 then
            enemy.scol=11
            enemy.swhat="shoots gauss guns"
        else
            enemy.scol=12
            enemy.swhat="shoots lasers"
        endif
        enemy.hp=rnd_range(2,5)+rnd_range(2,5)
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(1,3)
        enemy.weapon=rnd_range(1,3)
        enemy.tile=asc("H")
        enemy.sprite=287
        enemy.col=20
        enemy.speed=10
        enemy.respawns=0
        enemy.faction=1
    endif
    
    
    if a=58 then 'Redhat
        enemy.ti_no=1071
        enemy.atcost=rnd_range(6,8)
        enemy.sdesc="armed reptile"
        enemy.ldesc="A 3m tall reptile with yellow scales. It has 3 tentacles as arms, and 4 legs. It wears clothes and a red helmet, and wields an obviously human made Gauss gun!"
        enemy.lang=7
        enemy.sprite=291
        enemy.faction=9
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.aggr=1
        enemy.intel=5
        enemy.biomod=1
        enemy.cmmod=5
        enemy.sight=3
        enemy.range=3.5
        enemy.weapon=2
        enemy.swhat="shoots its gaussgun!"
        enemy.scol=11
        for l=1 to 3
            enemy.hp=enemy.hp+rnd_range(1,3)
        next
        enemy.hpmax=enemy.hp
        enemy.speed=10
        enemy.aggr=1
        enemy.tile=Asc("L")
        enemy.col=144
        enemy.items(0)=7
        enemy.itemch(0)=66
    endif  
        
    if a=59 then 'Crystal Hybrid
        enemy.stunres=9
        enemy.ti_no=1072
        enemy.sdesc="living crystal"
        enemy.ldesc="This being resembles an insect. 3 meters high, 6 legs and 5 arms and a tiny head. Underneath it's transparent crystaline shell you see pink flesh and blue veins."
        enemy.lang=15
        enemy.biomod=2
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=0
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.weapon=4
        enemy.intel=5
        enemy.armor=7
        enemy.hasoxy=1
        enemy.sprite=180
        enemy.hp=24+rnd_range(2,15)+rnd_range(2,15)
        enemy.hpmax=enemy.hp
        enemy.col=239
        enemy.aggr=0
        enemy.speed=7
        enemy.tile=asc("H")
        enemy.sdesc="crystal hybrid"
        enemy.ldesc="this once was a human being. It's arms, legs and head are encased in crystal tubes, fused to bare flesh. The torso is covered in the torn remains of a starship uniform. The half covered head looks like a grotesque helmet."
        enemy.armor=3
        enemy.atcost=7
        enemy.speed=18
        enemy.range=rnd_range(1,4)+0.5
        if enemy.range<=2.5 then
            enemy.scol=11
            enemy.swhat="shoots gauss guns"
            enemy.items(0)=7
            enemy.itemch(0)=66
        else
            enemy.scol=12
            enemy.swhat="shoots lasers"
            enemy.items(0)=9
            enemy.itemch(0)=33
        endif
        enemy.faction=5
    endif
    
    if a=60 then 'Floater
        enemy.ti_no=1073
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)
        enemy.atcost=rnd_range(6,8)
        enemy.movetype=mt_fly2
        enemy.aggr=0
        enemy.sight=4
        enemy.speed=10
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.biomod=1
        enemy.hasoxy=1
        enemy.sdesc="floater"
        enemy.ldesc="A circular flat being floating among the clouds. Three bulges on the top are glowing with static electricity." 
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)
        enemy.armor=3
        enemy.weapon=1
        enemy.range=3
        enemy.swhat="shoots lightning bolts"
        enemy.scol=11
        enemy.tile=asc("F")
        enemy.col=138
    endif
    
    if a=61 then 'floauter
        enemy.ti_no=1074
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)
        enemy.atcost=rnd_range(6,8)
        enemy.movetype=mt_fly2
        enemy.aggr=0
        enemy.sight=4
        enemy.speed=10
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.biomod=1
        enemy.hasoxy=1
        enemy.sdesc="floater"
        enemy.ldesc="A circular flat being floating among the clouds. Three bulges on the top are glowing with static electricity." 
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)
        enemy.armor=3
        enemy.weapon=1
        enemy.range=3
        enemy.swhat="shoots lightning bolts"
        enemy.scol=11
        enemy.tile=asc("F")
        enemy.col=138
    endif

    if a=62 then 'Cloudshark
        enemy.ti_no=1075
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)
        enemy.atcost=rnd_range(6,8)
        enemy.movetype=mt_fly2
        enemy.aggr=0
        enemy.sight=4
        enemy.speed=16
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.biomod=1
        enemy.hasoxy=1            
        enemy.sdesc="cloudshark"
        enemy.ldesc="A large tube shaped creature with wide maws and sharp teeth!"
        enemy.hp=rnd_range(1,20)+rnd_range(1,20)+10
        enemy.armor=1
        enemy.weapon=1
        enemy.range=1.5
        enemy.tile=asc("S")
        enemy.col=205
    endif

    if a=63 then 'Living Mushroom
        enemy.ti_no=1076
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)
        enemy.atcost=rnd_range(6,8)
        enemy.movetype=mt_fly2
        enemy.aggr=0
        enemy.sight=4
        enemy.speed=4
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.biomod=1
        enemy.hasoxy=1
        enemy.hp=rnd_range(2,4)
        enemy.range=1.5
        enemy.weapon=1
        enemy.tile=asc("9")
        enemy.sdesc="floating mushroom"
        enemy.ldesc="a 30 cm big ball with long tentacles that connect it to the platform. It has a rim around the middle with 5 openings through wich it shoots hot gas jets to propell and defend itself."
        enemy.breedson=18
        enemy.atcost=11
        enemy.col=200
    endif

    if a=64 then 'Hydrogen Worm
        enemy.stunres=3
        enemy.ti_no=1077
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)
        enemy.atcost=rnd_range(6,8)
        enemy.movetype=mt_fly2
        enemy.aggr=0
        enemy.sight=4
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.biomod=1
        enemy.hasoxy=1
        enemy.sdesc="hydrogen worm"
        enemy.ldesc="A giant wormlike creature. It's biochemistry is based on liquid hydrogen. The heat of our engines is attracting it."
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)+20
        enemy.armor=4
        enemy.weapon=4
        enemy.range=1.5
        enemy.tile=asc("W")
        enemy.col=121
        enemy.speed=8
    endif
    
    if a=65 then 'Crystal Hybrid
        enemy.stunres=9
        enemy.ti_no=1078
        enemy.sdesc="living crystal"
        enemy.ldesc="This being resembles an insect. 3 meters high, 6 legs and 5 arms and a tiny head. Underneath it's transparent crystaline shell you see pink flesh and blue veins."
        enemy.lang=15
        enemy.biomod=2
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=0
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.weapon=2
        enemy.atcost=11
        enemy.armor=3
        enemy.hasoxy=1
        enemy.sprite=180
        enemy.hpmax=14+rnd_range(2,5)+rnd_range(2,5)
        enemy.col=240
        enemy.aggr=0
        enemy.speed=16
        enemy.tile=asc("H")
        enemy.sdesc="crystal hybrid"
        enemy.ldesc="this once was a human being. It's arms, legs and head are encased in crystal tubes, fused to bare flesh. The torso is still bare. You can see the torn uniform of a scout ship security team member."
        enemy.hpmax=rnd_range(2,5)+rnd_range(2,5)
        enemy.armor=3
        enemy.atcost=7
        enemy.speed=18
        enemy.range=rnd_range(1,4)+0.5
        if enemy.range<=2.5 then
            enemy.scol=11
            enemy.swhat="shoots gauss guns"
            enemy.items(0)=7
            enemy.itemch(0)=33
        else
            enemy.scol=12
            enemy.swhat="shoots lasers"
            enemy.items(0)=9
            enemy.itemch(0)=33
        endif
        enemy.hp=enemy.hpmax
        enemy.faction=5
    endif
    
    '66,67,68,69: Tomb critters
    
    
    if a=71 then
        enemy.ti_no=1079
        enemy.faction=1
        enemy.atcost=rnd_range(6,9)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(1,4)
        enemy.range=0.5+enemy.weapon
        enemy.hp=5+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.respawns=0
        
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
        
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=2
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="Smith Heavy Industries security team"
        enemy.ldesc="a squad of Smith Heavy Industries Security Troops, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=4
        enemy.lang=25
        enemy.aggr=1
        enemy.armor=1
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
    endif
    
    if a=72 then
        enemy.ti_no=1080
        enemy.faction=1
        enemy.atcost=rnd_range(5,6)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(2,5)
        enemy.range=0.5+enemy.weapon
        enemy.hp=10+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.respawns=0
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.intel=5
        enemy.biomod=0
        enemy.col=10
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="Elite Smith Heavy Industry security team"
        enemy.ldesc="a squad of Smith Heavy Industry Troops, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=66
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=3
        enemy.lang=26
        enemy.aggr=1
        enemy.armor=2
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
    endif
    
    
    if a=73 then 'Citizen
        enemy.ti_no=1509
        enemy.faction=8
        enemy.intel=-1 'Should make them not ally with the guards
        enemy.sdesc="worker"
        enemy.ldesc="a sullen looking very thin worker"
        enemy.lang=28
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.speed=6
        enemy.intel=5
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.atcost=rnd_range(6,12)
        enemy.hasoxy=1
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=4
        enemy.hp=4
        enemy.col=39
        enemy.aggr=1
    endif
    
    if a=74 then
        enemy.ti_no=1082
        enemy.faction=1
        enemy.atcost=rnd_range(6,9)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(1,4)
        enemy.range=0.5+enemy.weapon
        enemy.hp=5+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.respawns=0
        
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=2
        enemy.intel=5
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="Triax Traders security team"
        enemy.ldesc="a squad of Triax Traders security troops, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=4
        enemy.lang=25
        enemy.aggr=1
        enemy.armor=1
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
    endif
    
    
    if a=75 then
        enemy.ti_no=1083
        enemy.faction=1
        enemy.atcost=rnd_range(5,6)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(2,5)
        enemy.range=0.5+enemy.weapon
        enemy.hp=10+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.respawns=0
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=10
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.intel=5
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="Elite Triax Traders security team"
        enemy.ldesc="a squad of Triax Traders Troops, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=66
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=3
        enemy.lang=24
        enemy.aggr=1
        enemy.armor=2
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
    endif
    
    
    if a=76 then
        enemy.ti_no=1084
        enemy.faction=1
        enemy.atcost=rnd_range(6,9)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(1,4)
        enemy.range=0.5+enemy.weapon
        enemy.hp=5+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.intel=5
        enemy.respawns=0
        
        
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
        
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=2
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="Omega bioengineering security team"
        enemy.ldesc="a squad of Omega bioengineering security troops, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=4
        enemy.lang=25
        enemy.aggr=1
        enemy.armor=1
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
    endif
    
    
    if a=77 then
        enemy.ti_no=1085
        enemy.faction=1
        enemy.atcost=rnd_range(5,6)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(2,5)
        enemy.range=0.5+enemy.weapon
        enemy.hp=10+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.respawns=0
        enemy.intel=5
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=10
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="Elite Omega bioengineering security team"
        enemy.ldesc="a squad of Omega bioengineering Troops, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=66
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=3
        enemy.lang=24
        enemy.aggr=1
        enemy.armor=2
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
    endif
    
    if a=78 then 'Citizen
        if rnd_range(1,50)<50 then
            enemy.ti_no=1086
        else
            enemy.ti_no=1510
        endif
        
        enemy.faction=8
        enemy.intel=5 'Should make them not ally with the guards
        enemy.sdesc="scientist"
        enemy.ldesc="a busy looking scientist"
        enemy.lang=29
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.intel=5
        enemy.speed=8
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.atcost=rnd_range(6,12)
        enemy.hasoxy=1
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=1
        enemy.hp=1
        enemy.col=39
        enemy.aggr=1
    endif
    
    if a=79 then
        enemy.ti_no=1087
        enemy.aggr=0
        enemy.hp=rnd_range(1,30)+20
        enemy.hpmax=enemy.hp
        enemy.speed=12
        enemy.atcost=8
        enemy.breedson=2
        enemy.weapon=3
        enemy.armor=0
        enemy.sight=3
        enemy.range=1.5
        enemy.biomod=5
        enemy.hasoxy=1
        enemy.tile=asc("j")
        enemy.col=208
        enemy.faction=9
        enemy.sdesc="blob"
        enemy.ldesc="A huge pale amorphous mass wobbles towards you trying to engulf you. It's skin is covered in a highly corrosive substance"
    endif
    
    '80 taken
    
    if a=81 then
        enemy=civ(0).spec
        enemy.made=a
        enemy.diet=4
        enemy.hasoxy=1
        enemy.sight=35
        enemy.pumod=60
        enemy.movetype=rnd_range(0,2)
    endif
    
    if a=82 then
        enemy=civ(1).spec
        enemy.made=a
        enemy.diet=4
        enemy.hasoxy=1
        enemy.sight=35
        enemy.pumod=60
        enemy.movetype=rnd_range(0,2)
    endif
    
    
    if a=83 then  'Burrower
        enemy.ti_no=1088
        enemy.sdesc="Burrower"
        enemy.ldesc="A huge burrowing insect, with a thick carapace and huge mandibles. It hides in loose soil to suprise its prey"
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sight=4
        enemy.range=1.5
        enemy.weapon=1
        enemy.armor=1
        enemy.hp=rnd_range(3,5)
        enemy.atcost=rnd_range(6,8)
        enemy.hpmax=enemy.hp
        enemy.biomod=1
        enemy.speed=14
        enemy.aggr=0
        enemy.lang=-30
        enemy.tile=Asc("I")
        enemy.sprite=285
        enemy.col=162
        enemy.invis=2
    endif
    
    if a=84 then  'Burrower Mom
        enemy.ti_no=1089
        enemy.sdesc="Huge Burrower"
        enemy.ldesc="A huge burrowing insect, with a thick carapace and huge mandibles. It hides in loose soil to suprise its prey"
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.swhat="spits acid"
        enemy.scol=12
        enemy.sight=4
        enemy.range=2
        enemy.weapon=2
        enemy.armor=2
        enemy.hp=rnd_range(1,5)+8
        enemy.atcost=rnd_range(6,8)
        enemy.hpmax=enemy.hp
        enemy.biomod=1
        enemy.speed=14
        enemy.aggr=0
        enemy.tile=Asc("I")
        enemy.sprite=285
        enemy.items(1)=86
        enemy.itemch(1)=110
        enemy.col=204
        enemy.invis=2
        enemy.lang=-31
    endif
    
    if a=85 then 'Citizen
        enemy.faction=8
        enemy.ti_no=-1
        enemy.sdesc="citizen"
        enemy.ldesc="a friendly human pioneer"
        enemy.lang=23
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.speed=8
        enemy.pumod=5
        enemy.sight=4
        enemy.intel=5
        enemy.range=1.5
        enemy.allied=2
        enemy.enemy=1
        enemy.atcost=rnd_range(6,12)
        enemy.hasoxy=1
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=4
        enemy.hp=4
        enemy.col=23
        enemy.aggr=1
        enemy.faction=1
    endif
    
    
    if a=86 then
        enemy.ti_no=1091
        enemy.faction=1
        enemy.atcost=rnd_range(6,9)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(1,4)
        enemy.range=0.5+enemy.weapon
        enemy.hp=5+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.respawns=0
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=2
        enemy.intel=5
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="eridiani exploration security team"
        enemy.ldesc="a squad of Eridiani Security Troops, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=4
        enemy.lang=24
        enemy.aggr=1
        enemy.armor=1
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
    endif
    
    if a=87 then
        enemy.ti_no=1092
        enemy.faction=1
        enemy.atcost=rnd_range(5,6)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(2,5)
        enemy.range=0.5+enemy.weapon
        enemy.hp=10+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.respawns=0
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=10
        enemy.scol=10
        enemy.intel=5
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="Elite eridiani exploration security team"
        enemy.ldesc="a squad of Elite Eridiani Security Troops, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=66
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=3
        enemy.lang=24
        enemy.aggr=1
        enemy.armor=2
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
    endif
    
    '88=Station inhabitant
    '89=
    
    if a=90 then
        enemy.ti_no=1094
        enemy.stunres=10
        enemy.biomod=0
        enemy.sdesc="Repair Bot"
        enemy.ldesc="a 30 cm metal sphere. Several arms extrude from it. They end in multipurpose tools. It uses those for movement as well as manipulation."
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.cmmod=1
        enemy.speed=18
        enemy.pumod=8
        enemy.sight=4
        enemy.range=1.5
        enemy.atcost=2
        enemy.hasoxy=1
        enemy.tile=Asc("R")
        enemy.sprite=286
        enemy.hpmax=24
        enemy.hp=24
        enemy.weapon=1
        
        enemy.col=23
        enemy.aggr=1
        enemy.faction=5
    endif
    
    if a=91 then 'Bladebot
        enemy.stunres=10
        enemy.ti_no=1069
        enemy.faction=5
        enemy.hasoxy=1
        enemy.sdesc="battle robot"
        enemy.ldesc="a metal ball, about 2m in diameter, sensor array to the right, weapons array to the left."     
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shoots a disintegrator beam "
        enemy.scol=12
        enemy.respawns=0
        enemy.armor=16
        enemy.lang=-3
        enemy.sight=9
        enemy.atcost=4
        enemy.range=5
        enemy.weapon=10
        if enemy.weapon<0 then enemy.weapon=0
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=0
        enemy.aggr=0
        enemy.speed=12
        enemy.tile=ASC("R")
        enemy.col=12
        enemy.sprite=278
        enemy.hp=230+rnd_range(1,5)+rnd_range(1,5)+rnd_range(1,3)+planets(map).depth
        for l=1 to 5
            enemy.hp=enemy.hp+rnd_range(1,5)
        next
        enemy.weapon=10
        enemy.atcost=5
        enemy.tile=ASC("R")
        enemy.armor=8
        enemy.hpmax=enemy.hp
        enemy.faction=5
    endif

    if a=92 then
        enemy.ti_no=1095
        enemy.tile=asc("q")
        enemy.col=9
        enemy.sdesc="large squid"
        enemy.ldesc="A large squid-like creature with a 3m long body, 3 3m long tentacles and 3 shorter tentacles, only about 30cm long. They don't seem to have any eyes, but the short tentacles are covered in fine hair enabling them to sense vibrations."
        enemy.dhurt="hurt"
        enemy.dkill="killed"
        enemy.hp=rnd_range(1,5)+5
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.speed=12
        enemy.atcost=5
        enemy.weapon=1
        enemy.range=2
        enemy.sight=2
        enemy.faction=9
        enemy.biomod=1
        enemy.movetype=mt_hover
        enemy.hasoxy=1
    endif
    
    if a=93 then
        enemy.ti_no=1096
        enemy.tile=asc("Q")
        enemy.col=9
        enemy.sdesc="Huge squid"
        enemy.ldesc="A large squid-like creature with a 5m long body, 3 5m long tentacles and 3 shorter tentacles, only about 30cm long. They don't seem to have any eyes, but the short tentacles are covered in fine hair enabling them to sense vibrations. It's body is covered in very thick scales."
        enemy.hp=rnd_range(1,5)+25
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.speed=11
        enemy.atcost=5
        enemy.weapon=1
        enemy.armor=3
        enemy.range=2
        enemy.sight=4
        enemy.faction=9
        enemy.biomod=1.5
        enemy.dhurt="hurt"
        enemy.dkill="killed"
        enemy.movetype=mt_hover
        enemy.hasoxy=1
    endif
    
    if a=94 then
        enemy.ti_no=1097
        enemy.tile=asc("Q")
        enemy.col=119
        enemy.sdesc="Giant squid"
        enemy.ldesc="A large squid-like creature with a 7m long body, 3 7m long tentacles and 3 shorter tentacles, only about 1m long. They don't seem to have any eyes, but the short tentacles are covered in fine hair enabling them to sense vibrations. It's body is covered in very thick scales. The tips of its tentacles are glowing with static electricity."
        enemy.hp=rnd_range(1,5)+55
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.speed=10
        enemy.atcost=5
        enemy.weapon=1
        enemy.armor=5
        enemy.range=3.4
        enemy.sight=5
        enemy.scol=101
        enemy.swhat="shoots lightning"
        enemy.faction=9
        enemy.biomod=2
        enemy.dhurt="hurt"
        enemy.dkill="killed"
        enemy.movetype=mt_hover
        enemy.hasoxy=1
    endif
    
    if a=95 then
        enemy.ti_no=1098
        enemy.tile=asc("F")
        enemy.col=14
        enemy.sdesc="swarm of fish"
        enemy.ldesc="A large swarm of different kind of fish, forming some form of symbiotic relationship."
        enemy.hp=30
        enemy.hpmax=enemy.hp
        enemy.faction=10
        enemy.aggr=2
        enemy.atcost=9
        enemy.speed=14
        enemy.sight=3
        enemy.biomod=1
        enemy.dhurt="hurt"
        enemy.dkill="killed"
        enemy.movetype=mt_hover
        enemy.hasoxy=1
    endif
    
    if a=96 then
        enemy.ti_no=1099
        enemy.stunres=9
        enemy.tile=asc("~")
        enemy.col=15
        enemy.sdesc="dense cloud"
        enemy.ldesc="This cloud is obviously a lifeform capable of intelligent action. It is actually composed of tiny animals, similiar to a plankton swarm.  The biodata from this unique lifeform will be worth a lot."
        enemy.hp=5
        enemy.hpmax=enemy.hp
        
        enemy.atcost=9
        enemy.weapon=1
        enemy.armor=0
        enemy.range=1.4
        enemy.sight=2
        enemy.intel=rnd_range(1,8)
        
        enemy.faction=10
        enemy.aggr=1
        enemy.speed=8
        enemy.sight=3
        enemy.biomod=2
        enemy.dhurt="hurt"
        enemy.dkill="killed"
        enemy.movetype=mt_fly
    endif
    
    
    if a=97 then
        enemy.ti_no=1099
        enemy.stunres=9
        enemy.tile=asc("~")
        enemy.col=7
        enemy.sdesc="huge dense cloud"
        enemy.ldesc="This cloud is obviously a lifeform capable of intelligent action. It is actually composed of tiny animals, similiar to a plankton swarm. The biodata from this unique lifeform will be worth a lot."
        enemy.hp=15+rnd_range(1,10)
        enemy.hpmax=enemy.hp
        enemy.intel=rnd_range(1,8)
        enemy.atcost=9
        enemy.weapon=1
        enemy.armor=0
        enemy.range=2.4
        enemy.sight=3
        
        enemy.swhat="shoots lightning"
        enemy.scol=101
        
        enemy.faction=10
        enemy.aggr=1
        enemy.speed=7
        enemy.sight=3
        enemy.biomod=5
        enemy.dhurt="hurt"
        enemy.dkill="killed"
        
        enemy.movetype=mt_fly
    endif
    
    if a=98 then 'Citizen
        enemy.faction=8
        enemy.ti_no=1515
        enemy.sdesc="prospector"
        enemy.ldesc="a rich prospector"
        enemy.lang=35
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.armor=7
        enemy.speed=10
        enemy.pumod=5
        enemy.sight=4
        enemy.range=3.5
        enemy.allied=2
        enemy.enemy=1
        enemy.atcost=rnd_range(6,12)
        enemy.hasoxy=1
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=7
        enemy.hp=7
        enemy.swhat="shoots a disintegrator"
        enemy.scol=12
        
        enemy.movetype=rnd_range(0,2)
        enemy.col=23
        enemy.aggr=1
        enemy.items(1)=97
        enemy.itemch(1)=115
        enemy.items(2)=98
        enemy.itemch(2)=115
    endif
    
    if a=99 then 'Citizen
        enemy.ti_no=1086
        enemy.faction=8
        enemy.intel=5 'Should make them not ally with the guards
        enemy.sdesc="scientist"
        enemy.ldesc="a busy looking scientist"
        enemy.lang=36
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.speed=8
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.atcost=rnd_range(8,12)
        enemy.hasoxy=1
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=1
        enemy.hp=1
        enemy.col=39
        enemy.aggr=1
    endif
    
    
    if a=100 then 'Citizen
        enemy.ti_no=1086
        enemy.faction=8
        enemy.intel=5 'Should make them not ally with the guards
        enemy.sdesc="scientist"
        enemy.ldesc="a busy looking scientist"
        enemy.lang=37
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.speed=8
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.atcost=rnd_range(6,12)
        enemy.hasoxy=1
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=3
        enemy.hp=3
        enemy.col=39
        enemy.aggr=1
    endif
    
    if a=101 then
        enemy.sdesc="Tribble"
        enemy.ldesc="A most curious creature, it's trilling seems to have a tranquilizing effect on the human nervous system." 
        enemy.ti_no=2121
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=12
        enemy.tile=asc("*")
        enemy.col=7
        enemy.aggr=1
        enemy.speed=-1
        enemy.breedson=33
        enemy.biomod=.1
        enemy.hp=1
        enemy.hpmax=1
        enemy.hasoxy=0
    endif
    
    if a=102 then 
        enemy.sdesc="Icetroll"
        enemy.ldesc="This creature hibernates during the cold nights on this planet and reawakes in the morning. In it's hibernating state it is virtually indistinguishable from a large block of ice. It's active state is mobile and sluglike. It seems to be a scavenger."
        enemy.hpmax=rnd_range(1,6)+10
        enemy.hp=enemy.hpmax
        enemy.biomod=3
        enemy.hasoxy=1        
        enemy.tile=176
        enemy.ti_no=258
        enemy.col=11    
        enemy.weapon=6
        enemy.armor=2
        enemy.aggr=0
        enemy.speed=4
        enemy.atcost=11
        enemy.range=1.5
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        for l=1 to rnd_range(2,5)
            enemy.items(l)=96
            enemy.itemch(l)=66
        next       
        
    endif
    
    if a=103 then
        enemy.ti_no=1000
        enemy.faction=8
        enemy.allied=0
        enemy.atcost=rnd_range(7,10)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(1,3)
        enemy.range=0.5+enemy.weapon
        enemy.hp=2+enemy.weapon
        enemy.sight=rnd_range(2,5)
        enemy.aggr=1
        enemy.respawns=0
        
        
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=2
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="Station security team"
        enemy.ldesc="a station security team, keeping a watchful eye on visitors"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=22
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=4
        enemy.lang=38
        enemy.aggr=1
        enemy.armor=1
        enemy.diet=5'Critters who are fighting
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
        
    endif
    
    if a=104 then
        enemy.ti_no=1001
        enemy.sdesc="squatter"
        enemy.ldesc="a poor fellow"
        enemy.lang=40
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.speed=6
        enemy.pumod=1
        enemy.sight=4
        enemy.intel=5
        enemy.range=1.5
        enemy.allied=2
        enemy.enemy=1
        enemy.atcost=rnd_range(6,12)
        enemy.hasoxy=1
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=1
        enemy.hp=1
        enemy.col=23
        enemy.aggr=1
        enemy.faction=8
    
    endif
    
    if planets(map).atmos=1 and planets(map).depth=0 then enemy.hasoxy=1
    
    if easy_fights=1 then
        enemy.armor=0
        enemy.weapon=0
        enemy.hp=1
    endif
    
    
    if configflag(con_easy)=0 and enemy.hp>0 then
        easy=player.turn/50000'!
        if easy<.5 then easy=.5
        if easy>1 then easy=1
        enemy.hp=enemy.hp*easy
        if enemy.hp<1 then enemy.hp=1
        enemy.hpmax=enemy.hp
    endif
    
    
    if enemy.hp>0 then enemy.hpmax=enemy.hp
    
    return enemy
end function

function makecorp(a as short) as _basis
    dim basis as _basis
    dim as short b
    if a=0 then a=rnd_range(1,4)
    if a<0 then
        b=a
        do 
            a=rnd_range(1,4)
        loop until a<>-b
    endif
    basis.company=a
    if a=1 then
        basis.repname="Eridiani Explorations"
        basis.mapmod=1.8
        basis.biomod=1
        basis.resmod=1.5
        basis.pirmod=1
    endif
    if a=2 then
        basis.repname="Smith Heavy Industries"
        basis.mapmod=1
        basis.biomod=1
        basis.resmod=1.75
        basis.pirmod=0.95
    endif
    if a=3 then 
        basis.repname="Triax Traders Its."
        basis.mapmod=1
        basis.biomod=1
        basis.resmod=1.55
        basis.pirmod=1.1
    endif
    if a=4 then
        basis.repname="Omega Bioengineering"
        basis.mapmod=1
        basis.biomod=1.5
        basis.resmod=1.5
        basis.pirmod=1
    endif
    return basis 
end function

function make_ship(a as short) as _ship
dim p as _ship
dim as short c,b
    p.loadout=urn(0,3,12,0)
    if a=1 then
        'players ship    
        'retirementassets(9)=1
        'retirementassets(6)=1
        'retirementassets(11)=1
        'p.questflag(3)=1
        'artflag(5)=1
        'artflag(7)=1
        p.c=targetlist(firstwaypoint)
        p.di=nearest(basis(0).c,p.c)
        p.sensors=1
        p.hull=5
        p.hulltype=10
        p.ti_no=1
        p.fuel=100
        p.fuelmax=100
        p.fueluse=1
        p.money=Startingmoney
        income(mt_startcash)=startingmoney
        p.loadout=0
        p.engine=1
        p.weapons(1)=make_weapon(1)
        p.lastvisit.s=-1
    endif
    
    if a=2 then
        p.st=st_pfighter
        'pirate fighter
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=2
        p.ti_no=18
        p.pipilot=1
        p.pigunner=3
        p.engine=4
        p.desig="Pirate Fighter"
        p.icon="F"
        p.money=200
        p.weapons(1)=make_weapon(7)
        p.col=12
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.turnrate=3
        p.hull=p.hull*(1+urn(0,3,2,0)*.5)
    endif
    if a=3 then
        p.st=st_pcruiser
        'pirate Cruiser
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=10
        p.ti_no=19
        p.pipilot=1
        p.pigunner=4
        p.engine=3
        p.desig="Pirate Cruiser"
        p.icon="C"
        p.money=1000
        p.weapons(3)=make_weapon(7)       
        p.weapons(1)=make_weapon(7)
        p.weapons(2)=make_weapon(2)
        p.col=12
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.turnrate=2
        p.hull=p.hull*(1+urn(0,3,2,0)*.5)
    endif
    
    if a=4 then
        p.st=st_pdestroyer
        'pirate Destroyer
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=4
        p.hull=15
        p.ti_no=20
        p.shieldmax=1
        p.pipilot=2
        p.pigunner=5
        p.engine=4
        p.desig="Pirate Destroyer"
        p.icon="D"
        p.money=3000
        
        p.weapons(1)=make_weapon(8)
        p.weapons(2)=make_weapon(3)
        p.weapons(3)=make_weapon(1)
        p.weapons(4)=make_weapon(8)       
        
        p.col=12
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.cargo(3).x=1
        p.turnrate=2
        p.hull=p.hull*(1+urn(0,3,2,0)*.5)
    endif
    if a=5 then
        p.st=st_pbattleship
        'pirate Battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=25
        p.ti_no=21
        p.shieldmax=2
        p.pipilot=1
        p.pigunner=6
        p.engine=4
        p.desig="Pirate Battleship"
        p.icon="B"
        p.money=5000
        p.equipment(se_ecm)=1
               
        p.weapons(1)=make_weapon(9)
        p.weapons(2)=make_weapon(9)
        p.weapons(3)=make_weapon(4)
        p.weapons(4)=make_weapon(3)
        p.weapons(5)=make_weapon(3)
        p.weapons(6)=make_weapon(9)
        
        p.col=12
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.cargo(3).x=1
        p.cargo(4).x=1
        p.turnrate=1
        p.hull=p.hull*(1+urn(0,3,2,0)*.5)
    endif
    
    if a=6 then
        c=rnd_range(1,10)
        p.turnrate=1
        if c<5 then   
            p.st=st_lighttransport
            p.hull=3
            p.shieldmax=0
            
            p.sensors=2
            p.pipilot=1
            p.pigunner=1
            p.engine=1
            p.cargo(1).x=rarest_good+1
            for b=2 to 3
                p.cargo(b).x=rnd_range(2,6)
            next
            p.desig="light transport"
            p.icon="t"
            p.ti_no=22
        endif
        if c>4 then
            p.st=st_heavytransport
            p.hull=8
            p.shieldmax=0
            
            p.sensors=3
            p.pipilot=1
            p.pigunner=1
            p.engine=1
            for b=1 to 2
                p.cargo(b).x=rarest_good+1
            next
            for b=3 to 4
                p.cargo(b).x=rnd_range(2,6)
            next
            p.desig="heavy transport"
            p.weapons(1)=make_weapon(1)
            p.icon="T"
            p.ti_no=23
        endif
        if c>7 and c<10 then
            p.st=st_merchantman
            p.hull=12
            p.shieldmax=1
            
            p.sensors=3
            p.pipilot=1
            p.pigunner=2
            p.engine=2
            
            for b=1 to 3
                p.cargo(b).x=rarest_good+1
            next
            for b=4 to 5
                p.cargo(b).x=rnd_range(2,6)
            next
            p.weapons(1)=make_weapon(2)
            p.desig="merchantman"
            p.icon="m"
            p.ti_no=24
        endif
        if c=10 then 
            p.st=st_armedmerchant
            p.hull=15
            p.shieldmax=2
            
            p.sensors=4
            p.pipilot=1
            p.pigunner=2
            p.engine=3
            
            for b=1 to 4
                p.cargo(b).x=rarest_good+1
            next
            for b=5 to 6
                p.cargo(b).x=rnd_range(2,6)
            next
            p.weapons(2)=make_weapon(2)
            p.weapons(3)=make_weapon(2)
            p.desig="armed merchantman"
            p.icon="M"
            p.ti_no=25
        endif
        
        p.hull=p.hull*(1+urn(0,2,2,0)*.5)
        'Merchant
        p.c.x=60
        p.c.y=rnd_range(0,20)
        p.weapons(0)=make_weapon(1)
        
        p.money=0
        p.security=20
        p.shiptype=1
        p.col=10
        p.bcol=0
        p.mcol=12
    endif
    
    if a=7 then
        'Escort
        p.st=st_Cescort
        p.c.x=60
        p.c.y=rnd_range(0,20)
        p.sensors=2
        p.hull=2
        p.shieldmax=1
        p.pipilot=4
        p.pigunner=3
        p.engine=3
        p.weapons(3)=make_weapon(7)
        p.weapons(1)=make_weapon(1)
        p.weapons(2)=make_weapon(1)
        p.desig="Escort"
        p.icon="E"
        p.ti_no=26
        p.money=0
        p.security=20
        p.col=10
        p.bcol=0
        p.mcol=12
        p.turnrate=2
        p.hull=p.hull*(1+urn(0,3,2,0)*.5)
    endif

    if a=8 then
        p.st=st_annebonny
        'The dreaded Anne Bonny
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=30
        p.shieldmax=3
        p.pipilot=3
        p.pigunner=5
        p.engine=5
        p.desig="Anne Bonny"
        p.icon="A"
        p.ti_no=27
        p.money=15000
        p.loadout=3
        p.equipment(se_ecm)=2
        p.weapons(6)=make_weapon(9)       
        p.weapons(1)=make_weapon(9)
        p.weapons(2)=make_weapon(10)
        p.weapons(3)=make_weapon(5)
        p.weapons(4)=make_weapon(5)
        p.weapons(5)=make_weapon(5)
        p.col=8
        p.bcol=0
        p.mcol=10
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.cargo(3).x=1
        p.cargo(4).x=1
        p.cargo(5).x=1
        p.cargo(6).x=1
        p.turnrate=2
    endif
    if a=9 then
        p.st=st_cbattleship
        'company battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=25
        p.shieldmax=2
        p.pipilot=1
        p.pigunner=4
        p.engine=5
        p.desig="Company Battleship"
        p.icon="U"
        p.ti_no=28
        p.money=0
        
        p.equipment(se_ecm)=1
        p.weapons(4)=make_weapon(7)       
        p.weapons(1)=make_weapon(7)
        p.weapons(2)=make_weapon(7)
        p.weapons(3)=make_weapon(3)
        p.col=10
        p.bcol=0
        p.mcol=12
        p.turnrate=1
        p.hull=p.hull*(1+urn(0,2,2,0)*.5)
    endif
    
    if a=10 then
        p.st=st_blackcorsair
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=25
        p.shieldmax=3
        p.pipilot=1
        p.pigunner=5
        p.engine=3
        p.desig="Black Corsair"
        p.icon="D"
        p.ti_no=29
        p.money=8000
        
        p.equipment(se_ecm)=1
        
        p.weapons(6)=make_weapon(7)       
        p.weapons(1)=make_weapon(7)
        p.weapons(2)=make_weapon(7)
        p.weapons(3)=make_weapon(3)
        p.weapons(4)=make_weapon(3)
        p.weapons(5)=make_weapon(1)
        p.col=4
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.cargo(3).x=1
        p.cargo(4).x=1
        p.cargo(5).x=1
        p.turnrate=3
    endif
    
    if a=11 then
        p.st=st_alienscoutship
        'Alien scoutship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=6
        p.hull=35
        p.shieldmax=4
        p.pipilot=4
        p.pigunner=3
        p.engine=5
        p.desig="Ancient Alien Ship"
        p.icon="8"
        p.ti_no=30
        
        p.equipment(se_ecm)=3
        p.weapons(1)=make_weapon(66)
        p.weapons(2)=make_weapon(66)
        p.weapons(3)=make_weapon(3)
        p.weapons(4)=make_weapon(3)
        p.loadout=4
        p.col=7
        p.bcol=0
        p.mcol=14
        p.turnrate=3
    endif
    
    if a=12 then
        p.st=st_cfighter
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=2
        p.pipilot=1
        p.pigunner=1
        p.engine=4
        p.desig="Fighter"
        p.icon="F"
        p.ti_no=31
        p.weapons(1)=make_weapon(7)
        p.col=10
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.turnrate=3
    endif
    
    if a=21 then
        p.st=st_spacespider
        p.c.x=rnd_range(25,35)
        p.c.y=11
        p.hull=10
        p.hulltype=-1
        p.engine=3
        p.sensors=3
        p.pigunner=5
        p.icon="S"
        p.ti_no=37
        p.desig="crystal spider"
        p.col=11
        p.mcol=1
        p.weapons(1)=make_weapon(101)
        p.turnrate=3
    endif
    
    if a=22 then
        'Sphere
        p.st=st_livingsphere
        p.c.x=rnd_range(25,35)
        p.c.y=9
        p.hull=12
        p.hulltype=-1
        p.engine=0
        p.sensors=15
        p.pigunner=5
        p.icon="Q"
        p.ti_no=38
        p.desig="living sphere"
        p.col=8
        p.mcol=1
        p.weapons(1)=make_weapon(101)
        p.weapons(2)=make_weapon(102)
        p.weapons(3)=make_weapon(102)
        p.turnrate=3
    endif
    
    if a=23 then
        'cloud
        p.st=st_cloud
        p.c.x=rnd_range(25,35)
        p.c.y=11
        p.hull=15
        p.hulltype=-1
        p.engine=4
        p.sensors=2
        p.pigunner=2
        p.icon=chr(176)
        p.ti_no=39
        p.desig="symbiotic cloud"
        p.col=14
        p.mcol=1
        p.weapons(1)=make_weapon(101)
        p.weapons(2)=make_weapon(101)
        p.turnrate=3
    endif
    
    
    if a=24 then
        'Spacespider
        p.st=st_hydrogenworm
        p.c.x=rnd_range(25,35)
        p.c.y=9
        p.hull=4
        p.hulltype=-1
        p.engine=5
        p.sensors=3
        p.pigunner=3
        p.icon="W"
        p.ti_no=40
        p.desig="hydrogen worm"
        p.col=121
        p.mcol=1
        p.weapons(1)=make_weapon(101)
        p.turnrate=1
    endif
    
    
    if a=25 then
        p.st=st_livingplasma
        p.c.x=rnd_range(25,35)
        p.c.y=12
        p.c=movepoint(p.c,5)
        p.hull=18
        p.hulltype=-1
        p.engine=5
        p.sensors=4
        p.pigunner=4
        p.icon=chr(176)
        p.ti_no=41
        p.desig="living plasma"
        p.col=11
        p.mcol=14
        p.weapons(1)=make_weapon(101)
        p.turnrate=3
    endif
    
    if a=26 then
        p.st=st_starjellyfish
        p.c.x=rnd_range(25,35)
        p.c.y=11
        p.hull=8
        p.hulltype=-1
        p.engine=3
        p.sensors=3
        p.pigunner=2
        p.icon="J"
        p.ti_no=42
        p.desig="starjellyfish"
        p.col=11
        p.mcol=14
        p.weapons(1)=make_weapon(101)
        p.weapons(2)=make_weapon(101)
        p.weapons(3)=make_weapon(101)
        p.turnrate=2
    endif
    
    
    if a=27 then
        p.st=st_cloudshark
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.hull=2
        p.hulltype=-1
        p.engine=5
        p.sensors=3
        p.pigunner=2
        p.icon="S"
        p.desig="cloudshark"
        p.ti_no=43
        p.col=205
        p.mcol=1
        p.weapons(1)=make_weapon(101)
        p.turnrate=3
    endif
    
    if a=28 then
        p.st=st_gasbubble
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.hull=10
        p.hulltype=-1
        p.engine=2
        p.sensors=3
        p.pigunner=2
        p.icon="O"
        p.ti_no=44
        p.desig="Gasbubble"
        p.col=203
        p.mcol=1
        p.weapons(1)=make_weapon(103)
        p.turnrate=3
    endif
    
    
    if a=29 then
        p.st=st_floater
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.hull=10
        p.hulltype=-1
        p.engine=2
        p.sensors=3
        p.pigunner=2
        p.icon="F"
        p.ti_no=45
        p.desig="Floater"
        p.col=138
        p.mcol=1
        p.weapons(1)=make_weapon(104)
        p.weapons(2)=make_weapon(104)
        p.turnrate=1
    endif
    
    if a=30 then
        p.st=st_hussar
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=15
        p.shieldmax=2
        p.pipilot=1
        p.pigunner=5
        p.engine=2
        p.desig="Hussar"
        p.icon="C"
        p.ti_no=34
        p.money=5000
        p.equipment(se_ecm)=1
        p.weapons(2)=make_weapon(7)
        p.weapons(3)=make_weapon(3)
        p.weapons(4)=make_weapon(3)
        p.weapons(5)=make_weapon(1)
        p.col=4
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.cargo(3).x=1
        p.turnrate=3
    endif
    
    if a=31 then
        p.st=st_adder
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=5
        p.shieldmax=1
        p.pipilot=1
        p.pigunner=4
        p.engine=3
        p.desig="Adder"
        p.icon="F"
        p.ti_no=35
        p.money=2500
        
        p.equipment(se_ecm)=1
        p.weapons(1)=make_weapon(7)
        p.weapons(2)=make_weapon(7)
        p.col=4
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.turnrate=2
    endif
    
    if a=32 then
        p.st=st_blackwidow
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=5
        p.shieldmax=2
        p.pipilot=1
        p.pigunner=4
        p.engine=2
        p.desig="Black Widow"
        p.icon="F"
        p.ti_no=36
        p.money=2500
        
        p.equipment(se_ecm)=1
        p.weapons(1)=make_weapon(8)
        p.weapons(2)=make_weapon(13)
        p.col=4
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.turnrate=3
    endif
    
    if a=33 then
        p.st=st_spacestation
        p.c.x=30
        p.c.y=10
        p.shiptype=2
        p.sensors=7
        p.hull=500
        p.shieldmax=8
        p.pigunner=4
        p.engine=0
        
        p.equipment(se_ecm)=0
        p.desig="Spacestation"
        p.icon="S"
        p.ti_no=46
        p.col=15
        p.weapons(1)=make_weapon(7)
        p.weapons(2)=make_weapon(7)
        p.weapons(3)=make_weapon(7)
        p.weapons(4)=make_weapon(3)
        p.weapons(5)=make_weapon(3)
        p.weapons(6)=make_weapon(3)
        p.turnrate=1
        p.loadout=3
    endif
    
    if a=34 then
        p.st=st_cfighter
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.shieldmax=1
        p.hull=8
        p.pipilot=1
        p.pigunner=1
        p.engine=4
        p.desig="LRF Striker"
        p.icon="F"
        p.ti_no=31
        p.weapons(1)=make_weapon(3)
        p.weapons(2)=make_weapon(3)
        p.loadout=2
        p.col=10
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.turnrate=3
    endif
    
    if a=35 then
        p.st=st_cfighter
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.shieldmax=1
        p.hull=8
        p.pipilot=3
        p.pigunner=3
        p.engine=4
        p.desig="LRF Lightning"
        p.icon="F"
        p.ti_no=31
        p.weapons(1)=make_weapon(8)
        p.weapons(2)=make_weapon(8)
        p.col=10
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.turnrate=3
    endif
    
    
    if a=36 then
        'Escort
        p.st=st_Cescort
        p.c.x=60
        p.c.y=rnd_range(0,20)
        p.sensors=2
        p.hull=12
        p.shieldmax=2
        p.pipilot=4
        p.pigunner=5
        p.engine=5
        p.weapons(4)=make_weapon(89)
        p.weapons(3)=make_weapon(8)
        p.weapons(1)=make_weapon(3)
        p.weapons(2)=make_weapon(3)
        p.desig="EC Kursk"
        p.icon="E"
        p.ti_no=26
        p.money=0
        p.security=20
        p.col=10
        p.bcol=0
        p.mcol=12
        p.turnrate=3
    endif
    
    if a=37 then
        p.st=st_cbattleship
        'company battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=25
        p.shieldmax=2
        p.pipilot=1
        p.pigunner=5
        p.engine=4
        p.icon="U"
        p.ti_no=28
        p.money=0
        
        p.equipment(se_ecm)=2
        p.weapons(4)=make_weapon(8)       
        p.weapons(1)=make_weapon(8)
        p.weapons(2)=make_weapon(8)
        p.weapons(3)=make_weapon(5)
        p.col=10
        p.bcol=0
        p.mcol=12
        p.turnrate=2
        p.loadout=2
        p.desig="DS Argus"
    endif
    
    if a=38 then
        p.st=st_cbattleship
        'company battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=4
        p.hull=35
        p.shieldmax=3
        p.pipilot=1
        p.pigunner=4
        p.engine=5
        p.icon="U"
        p.ti_no=28
        p.money=0
        
        p.equipment(se_ecm)=2
        p.weapons(1)=make_weapon(9)       
        p.weapons(2)=make_weapon(9)
        p.weapons(3)=make_weapon(9)
        p.weapons(4)=make_weapon(89)
        p.weapons(5)=make_weapon(89)
        p.col=10
        p.bcol=0
        p.mcol=12
        p.turnrate=2
        p.loadout=3
        p.desig="BS Tyger"
    endif
    
    
    return p
end function
    
function debug_printfleet(f as _fleet) as string
    dim text as string
    dim a as short
    for a=1 to 15
        text=text &f.mem(a).icon
    next
    return text
end function
