'tQuest.
'
'defines:
'bounty_quest_text=0, show_quests=1
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(types) or defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#undef both
#define types
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tQuest -=-=-=-=-=-=-=-
#undef intest
#define test
#endif'test


#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

Enum questtype
    qt_empty'0
    qt_EI'1
    qt_autograph'2
    qt_outloan'3
    qt_stationimp'4
    qt_drug'5
    qt_souvenir'6
    qt_tools'7
    qt_showconcept'8
    qt_stationsensor'9
    qt_travel'10 Needs Debugging
    qt_cargo'11 Needs Debugging
    qt_locofpirates'12
    qt_locofspecial'13
    qt_locofgarden'14
    qt_research'15
    qt_megacorp'16
    qt_biodata'17
    qt_anomaly'18
    qt_juryrig'19
    qt_cursedship'20
End Enum

Type _bountyquest
    status As Byte '1 given, 2 ship destroyed by player, 3 ship destroyed by other, 4 reward given
    employer As Byte
    ship As Short
    reward As Short
    desig As String *32
    reason As Byte
    lastseen As _cords
End Type

Dim Shared As Short lastbountyquest=16
Dim Shared bountyquest(lastbountyquest) As _bountyquest

Type _patrolquest
    status As Byte
    employer As Byte
    Enum emp
        corporate
        pirate
    End Enum
    cord(12) As _cords
    lastcord As Byte
    Declare function generate(p As Short,maxdis As Short,danger As Short) As Short
    Declare function check() As Short
    Declare function reward() As Short
    Declare function show() As String
    Declare function pay() As Short
End Type

Dim Shared patrolquest(16) As _patrolquest
Dim Shared questroll As Short

#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tQuest -=-=-=-=-=-=-=-

declare function show_quests() as short
declare function bounty_quest_text() as string
declare function load_quest_cargo(t as short,car as short,dest as short) as short
declare function give_quest(st as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tQuest -=-=-=-=-=-=-=-

namespace tQuest
function init(iAction as integer) as integer
	return 0
end function
end namespace'tQuest


function bounty_quest_text() as string
    dim t as string
    dim i as short
    for i=1 to lastbountyquest
        if bountyquest(i).status=1 then t=t &"Destroy the "& bountyquest(i).desig &", last seen at "&cords(bountyquest(i).lastseen) &".|"
    next
    return t
end function

function show_quests() as short
    dim as short a,b,c,d,sys,p
    dim dest(10) as short
    dim as string txt,addtxt
    set__color( 15,0)
    cls
    txt="{15}Missions: |{11}"
    set__color( 11,0)
    for a=1 to 10
        if player.cargo(a).x=11 or player.cargo(a).x=12 then
            b+=1
            dest(b)=player.cargo(a).y+1
        endif
    next
    if b>0 then
        set__color( 15,0)
        txt=txt & "Cargo:|"
        for a=1 to b
            set__color( 11,0)
            txt=txt & "  Cargo for Station-"&dest(a) &"|"
        next
    endif
    if player.questflag(8)>0 and player.towed<0 then print " Deliver "&add_a_or_an(shiptypes(-player.towed),0) &" hull to Station "&player.questflag(8)+1

    if player.questflag(7)>0 then
        sys=sysfrommap(player.questflag(7))
        for d=1 to 9
            if map(sys).planets(d)=player.questflag(7) then p=d
        next
        txt=txt & "  Map planet in orbit "&p &" in the system at "&map(sys).c.x &":"&map(sys).c.y &"|"
    endif
    if player.questflag(9)=1 then txt=txt & "  Find a working robot factory"&"|"
    if player.questflag(10)>0 then txt=txt & "  Find a planet without life and "&add_a_or_an(atmdes(player.questflag(10)),0)&" atmosphere."&"|"
    if player.questflag(11)=1 then txt=txt & "  Find a missing company battleship"&"|"
    if player.questflag(2)=1 then txt=txt & "  Rescue a company executive from pirates"&"|"
    if player.questflag(12)=1 then txt=txt & "  A small green alien told you about a monster in their mushroom caves."
    if player.questflag(26)>0 then
        sys=sysfrommap(player.questflag(26))
        txt=txt & "  Find out what happened to an expedition last reported from "&cords( map(sys).c)&"."&"|"
    endif
    set__color( 15,0)
    txt=txt & "|{15}Headhunting:{11}"&"|"
    set__color( 11,0)
    txt=txt & bounty_quest_text
    if player.questflag(5)=1 then txt=txt & "  Bring down an unknown alien ship"&"|"
    if player.questflag(6)=1 then txt=txt & "  Bring down an unknown alien ship"&"|"

    txt=txt &"|{15}Escorting:{11}|"
    for a=6 to lastfleet
        if fleet(a).con(1)=1 then
            txt=txt &"  Escort merchant fleet "&a &" to station "&fleet(a).con(3)+1 &"."&"|"
        endif
    next
    txt=txt &"|{15}Patrol:{11}|"
    for a=0 to 12
#if __FB_DEBUG__ ' _debug=1111 
		txt &= patrolquest(a).status &" " 
#endif
        if patrolquest(a).status=1 then txt=txt &"  " &patrolquest(a).show &"|"
    next
    txt=txt &"|{15}Other:{11}|"
    for a=1 to lastquestguy
        if questguy(a).talkedto=2 then
        txt=txt &questguy(a).n &", last seen at "
        if questguy(a).location<0 then
            txt=txt &"a small station,"
        else
            txt=txt &"station-"&questguy(a).location+1 &","
        endif
        select case questguy(a).want.type
        case qt_EI'1
            txt=txt &" wants " &add_a_or_an(questguy(a).want.it.ldesc,0) &".|"
        case qt_autograph'3
            txt=txt &" wants to have an autograph from "&questguy(questguy(a).flag(1)).n &".|"
        case qt_outloan'4
            txt=txt &" wants money back from "&questguy(questguy(a).flag(1)).n &".|"
        case qt_stationimp'5
            txt=txt &" is looking for good engineers.|"
        case qt_drug'6
            txt=txt &" wants " &questguy(a).want.it.desig &".|"
        case qt_souvenir'7
            txt=txt &" wants to have a souvenir.|"
        case qt_tools'8
            txt=txt &" wants to have tools.|"
        case qt_showconcept'9
            txt=txt &" wants a showconcept.|"
        case qt_stationsensor'10
            txt=txt &" wants to have access to station sensors.|"
        case qt_locofpirates'13
            txt=txt &" wants to know the location of pirates.|"
        case qt_locofspecial'14
            txt=txt &" wants to know the location of a special planet.|"
        case qt_locofgarden'15
            txt=txt &" wants to know the location of an earthlike planet.|"
        case qt_research'18
            txt=txt &" is interested in "&questguy(questguy(a).flag(1)).n &"s research.|"
        case qt_megacorp'19
            txt=txt &" is lookin for information on "&companyname(questguy(a).flag(6)) &".|"
        case qt_biodata'20
            txt=txt &" buys biodata.|"
        case qt_anomaly'21
            txt=txt &" buys anomaly data.|"
        case qt_juryrig'22
            txt=txt &" buys plans for improvised repairs.|"
            'qt_cargo
        end select

        endif
    next

    textbox(txt,2,2,_mwx*_fw1/_fw2-4,,1)
    
    assert(pDisplayShip<>null)
    pDisplayShip(0)
    no_key=uConsole.keyinput()
    
    return 0
end function


function load_quest_cargo(t as short,car as short,dest as short) as short
    dim as short bay
    do
        bay=getnextfreebay
        if bay>0 then
            player.cargo(bay).x=t
            player.cargo(bay).y=dest
            car=car-1
        endif
    loop until getnextfreebay<0 or car=0
    if car>0 then rlprint "You don't have enough room and leave "&car &" tons behind.",c_yel
    return car
end function



function give_quest(st as short) as short
    dim as short a,b,bay, s,pl,car,st2,m,o,m2,o2,x,y,i,j,f
    dim as _cords p
    static stqroll as short
    if st<>player.lastvisit.s then stqroll=rnd_range(1,20)
    do
        st2=rnd_range(0,2)
    loop until st2<>st
    
#if __FB_DEBUG__
    'if _debug=1111 then questroll=14
#endif
    
    if questroll>16 then
        'standard quest by office
        if basis(st).company=1 then
            do
                m=rnd_range(0,laststar)
                o=rnd_range(1,9)
            loop until map(m).planets(o)>0
            if player.questflag(7)=0 then
                if askyn("The company rep offers you a contract to deliver complete maps of a newly discovered planet in orbit " & o &" around a star at "&map(m).c.x &":" &map(m).c.y &". They will pay 1000 cr. Do you accept?(y/n)") then
                    m=map(m).planets(o)
                    player.questflag(7)=m 
                    questroll=999'save m in .... a quest?
                endif
            else
                for m=0 to laststar
                    for o=1 to 9
                        if map(m).planets(o)=player.questflag(7) then 
                            m2=m
                            o2=o
                        endif
                    next
                next
                rlprint "The company rep reminds you that you still have a contract open to map a planet at "&map(m2).c.x &":" &map(m2).c.y &" orbit " & o2 &"."
            endif
        endif
        
        if basis(st).company=2 then
            if player.questflag(9)=0 then
                if askyn("The rep says:'We have learned that there are still working robot factories found on some planets on this sector. We would like to send a team of scientists to one of these. Would you be willing to find a suitable target for 5000 credits?('(y/n)") then 
                    player.questflag(9)=1
                    questroll=999
                endif
            else
                rlprint "The company rep reminds you that you have yet to locate a factory of the ancients"
            endif    
        endif
        
        if basis(st).company=3 then
            car=rnd_range(3,4)
            rlprint "The company rep offers you a contract to deliver "&car &" tons of cargo to station " &st2+1 &"."
            if askyn(" They will pay 200 cr per ton. Do you accept?(y/n)") then
                if getnextfreebay<0 then 
                    rlprint "You have no room.",c_red
                    return questroll
                endif
                load_quest_cargo(12,car,st2)
                questroll=999
            endif
        endif
        
        if basis(st).company=4 then
            if player.questflag(10)=0 then
                m=rnd_range(2,16)
                if askyn("Omega Bioengineering's scientists want to conduct an experiment. They need a planet with "&add_a_or_an(atmdes(m),0) &" atmosphere, and without plant life for that. They are willing to pay 2500 credits for the position of a possible candidate. Do you want to help in the search (y/n)?") then 
                    player.questflag(10)=m
                    questroll=999
                endif
            else 
                rlprint "The company rep reminds you that you have yet to find a planet with "&add_a_or_an(atmdes(player.questflag(10)),0)&" atmosphere without life."
            endif
        endif
    else
        'other quests
        do
            a=rnd_range(0,2)
        loop until a<>st
#if __FB_DEBUG__
'        if _debug=1111 then stqroll=14
#endif
        select case stqroll
        	case 1 to 3
            if askyn("The company rep needs some cargo delivered to station "&a+1 &". He is willing to pay 200 credits. Do you accept? (y/n)" ) then
                bay=getnextfreebay
                if bay<=0 then 
                    if askyn("Do you want to make room for the cargo ?(y/n)") then 
                        sellgoods(10)
                        bay=getnextfreebay
                    endif
                endif
                if bay>0 then
                    player.cargo(bay).x=12 'type=specialcargo
                    player.cargo(bay).y=a 'Destination
                endif
            endif
        
        case 4
            b=rnd_range(1,16)
            if askyn("The company rep needs "&add_a_or_an(shiptypes(b),0) &" hull towed to station "&a+1 &" for refits. He is willing to pay "& b*50 &" Cr. Do you accept(y/n)?") then
                if player.tractor=0 then
                    rlprint "You need a tractor beam for this job.",14
                else
                    player.towed=-b
                    player.questflag(8)=a
                endif
            endif
        
        case 5
            if player.questflag(2)=0 then
                rlprint "The company rep informs you that one of the local executives has been abducted by pirates. They demand ransom, but it is company policy to not give in to such demands. There is a bounty of 10.000 CR on the pirates, and a bonus of 5000 CR to bring back the exec alive.",15
                no_key= uConsole.keyinput()
                player.questflag(2)=1
                s=get_random_system
                if s=-1 then s=rnd_range(0,laststar)
                pl=getrandomplanet(s)
                if pl<0 then pl=rnd_range(1,9)
                makeplanetmap(pl,3,map(s).spec)
                for a=1 to rnd_range(1,3)
                    planetmap(rnd_range(0,60),rnd_range(0,20),pl)=-65
                next
                planetmap(rnd_range(0,60),rnd_range(0,20),pl)=-66
            endif
            
        case 6
            if player.questflag(5)=0 and tVersion.gameturn>3*30*24*60 then
                rlprint "The company rep warns you about a ship that has reportedly been preying on pirates and merchants alike. 'It's fast, it's dangerous, and a confirmed kill is worth 15.000 credits to my company.",15
                player.questflag(5)=1
                lastfleet=lastfleet+1
                fleet(lastfleet).ty=5
                fleet(lastfleet).mem(1)=make_ship(11)
                fleet(lastfleet).flag=5
                fleet(lastfleet).c=map(sysfrommap(specialplanet(29))).c            
            endif
            
        case 7
            if player.questflag(5)=2 then
                rlprint "The company rep warns you that there are reports about another ship prowling space of the type you destroyed before. The company again pays 15.000 Credits if you bring it down",15
                player.questflag(6)=1
                lastfleet=lastfleet+1
                fleet(lastfleet).ty=5
                fleet(lastfleet).mem(1)=make_ship(11)
                fleet(lastfleet).mem(2)=make_ship(11)
                fleet(lastfleet).mem(3)=make_ship(11)
                fleet(lastfleet).flag=6
                fleet(lastfleet).c.x=rnd_range(0,sm_x)     
                fleet(lastfleet).c.y=rnd_range(0,sm_y)     
            endif
            
        case 8
            if player.questflag(11)=0 and lastdrifting<128 then
                player.questflag(11)=1
                x=5-rnd_range(1,10)+map(sysfrommap(specialplanet(27))).c.x
                y=5-rnd_range(1,10)+map(sysfrommap(specialplanet(27))).c.y
                if x<0 then x=0
                if y<0 then y=0
                if x>sm_x then x=sm_x
                if y>sm_y then y=sm_y
                rlprint "The company rep tells you about a battleship that has gone missing. It's last known position was " & x &":" &y & ". There is a 5000 Credit reward for finding out what happened to it.",15
                lastdrifting=lastdrifting+1
                m=lastdrifting
                drifting(m).s=14
                drifting(m).x=x
                drifting(m).y=y
                drifting(m).m=lastplanet+1
                lastplanet=lastplanet+1
                load_map(14,lastplanet)
                make_drifter(drifting(m))
                p=rnd_point(lastplanet,0)
                planetmap(p.x,p.y,lastplanet)=-226
                player.questflag(11)=1
                m=lastplanet
                planets(m).darkness=0
                planets(m).depth=1
                planets(m).atmos=6
        
                planets(m).mon_template(0)=makemonster(29,m)
                planets(m).mon_noamin(0)=10
                planets(m).mon_noamax(0)=20
                planets_flavortext(m)="No hum from the engines is heard as you enter the Battleship. Emergency lighting bathes the corridors in red light, and the air smells stale."
            endif
            
        case 9 to 14
            give_bountyquest(0)
        
        case 15 to 17
            if player.questflag(26)=0 then
                s=get_random_system
                pl=getrandomplanet(s)
                if pl>0 then
                    rlprint "We haven't heard in a while from a ship that last reported from " & map(s).c.x &":"&map(s).c.y & ". We offer you 500 Cr. if you can find out what hapened to them."
                    player.questflag(26)=pl
                    placeitem(make_item(81,1),rnd_range(0,60),rnd_range(0,20),pl)
                endif
            endif
        case 18
            'Escort
            if askyn("There is an important delivery for station "&a+1 &". We are looking to enhance security. Would you be interested in flying escort? (y/n)") then
                f=set_fleet(makemerchantfleet)
                fleet(f).c=player.c
                fleet(f).con(1)=1
                fleet(f).con(3)=a
                fleet(f).con(2)=distance(player.c,basis(st).c)*50
                rlprint "The captain will pay you "&fleet(f).con(2) & " Cr. when you reach the target."
            endif
        
        case else
            give_patrolquest(0)
        end select
    endif
return questroll
end function


#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tQuest -=-=-=-=-=-=-=-
	tModule.register("tQuest",@tQuest.init()) ',@tQuest.load(),@tQuest.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tQuest -=-=-=-=-=-=-=-
#endif'test
