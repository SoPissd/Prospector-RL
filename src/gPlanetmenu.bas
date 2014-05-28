'tPlanetmenu.
'
'defines:
'planetflags_toship=0, ep_gives=1, gets_entry=0, ep_planetmenu=0
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
'     -=-=-=-=-=-=-=- TEST: tPlanetmenu -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tPlanetmenu -=-=-=-=-=-=-=-

declare function ep_gives(awayteam As _monster, ByRef nextmap As _cords, shipfire() As _shipfire, spawnmask() As _cords,lsp As Short,Key As String, loctemp As Single) As Short
declare function ep_planetmenu(entrycords as _cords,slot As Short,shipfire() As _shipfire,spawnmask() As _cords, lsp As Short,loctemp As Single) As _cords

'declare function planetflags_toship(m As Short) As _ship
'declare function gets_entry(x as short,y as short, slot as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tPlanetmenu -=-=-=-=-=-=-=-

namespace tPlanetmenu
function init(iAction as integer) as integer
	return 0
end function
end namespace'tPlanetmenu


#define cut2top


function planetflags_toship(m As Short) As _ship
    Dim s As _ship
    Dim As Short f,e
    e=0
    For f=6 To 10
        If planets(m).flags(f)>0 Then
            e=e+1
            s.weapons(e)=make_weapon(planets(m).flags(f))
        EndIf
        If planets(m).flags(f)=-1 Then
            e=e+1
            s.weapons(e)=make_weapon(99)
        EndIf
        If planets(m).flags(f)=-2 Then
            e=e+1
            s.weapons(e)=make_weapon(98)
        EndIf
        If planets(m).flags(f)=-3 Then
            e=e+1
            s.weapons(e)=make_weapon(97)
        EndIf
    Next
    Return s
End function



function ep_gives(awayteam As _monster, ByRef nextmap As _cords, shipfire() As _shipfire, spawnmask() As _cords,lsp As Short,Key As String, loctemp As Single) As Short
    Dim As Short a,b,c,d,e,r,sf,slot,st
    Dim As Single fuelsell,fuelprice,minprice
    Dim towed As _ship
    Dim As String text
    Dim As _cords p,p1,p2
    dim as integer x,y
    
	DbgLogExplorePlanet("in ep_gives: " &tmap(awayteam.c.x,awayteam.c.y).gives)
    awayteam.e.add_action(10)
    slot=player.map
    DbgPrint(""&tmap(awayteam.c.x,awayteam.c.y).gives)
    st=nearest_base(player.c)
    fuelprice=round_nr(basis(st).inv(9).p/30+disnbase(player.c)/15-count_gas_giants_area(player.c,3)/2,2)
    If fuelprice<1 Then fuelprice=1
    If planets(slot).flags(26)=9 Then fuelprice=fuelprice*3
    fuelsell=fuelprice/2
    If tmap(awayteam.c.x,awayteam.c.y).gives=1 Then
        If specialplanet(1)=slot Then specialflag(1)=1
        findartifact(0)
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=2 Then
        rlprint "'Ah great. Imagining people again are we?' the occupant of this bunker looks like he had a pretty bad time. 'No wait. You are real? I am not imagining you?' He explains to you that he managed to survive for months, alone, after the sandworms had demolished his ship, and eaten his crewmates."
        If askyn("He is quite a good gunner and wants to join your crew. do you let him? (y/n)") Then
            add_member(2,6)
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=3 Then
        rlprint "The pirates are holding the executive in this ship!"
        If rnd_range(1,100)<55 Then
            rlprint "He is still alive!",10
            player.questflag(2)=2
        Else
            rlprint "They killed him.",12
            player.questflag(2)=3
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives>=4 And tmap(awayteam.c.x,awayteam.c.y).gives<=8 Then
        If tmap(awayteam.c.x,awayteam.c.y).gives<>8 Then rlprint "The local stock exchange."
        If tmap(awayteam.c.x,awayteam.c.y).gives=8 Then rlprint "The insect colonists are eager to trade."
        If slot<>piratebase(0) Or faction(0).war(2)<=0 Then
            If tmap(awayteam.c.x,awayteam.c.y).gives=7 And specialflag(20)=0 Then
                For a=1 To 8
                    basis(8).inv(a).v=0
                Next
            EndIf
            If tmap(awayteam.c.x,awayteam.c.y).gives=8 Then
                For a=1 To 8
                    basis(9).inv(a).v=rnd_range(1,8-a)
                Next
            EndIf
            tCompany.trading(tmap(awayteam.c.x,awayteam.c.y).gives+1)
            player.lastvisit.s=tmap(awayteam.c.x,awayteam.c.y).gives+1
            player.lastvisit.t=tVersion.gameturn
        Else
            rlprint "they dont want to trade with you."
        EndIf
    EndIf




    If tmap(awayteam.c.x,awayteam.c.y).gives=12 Then
        rlprint "you found some still working laser drills"
        player.stuff(5)=2
        placeitem(make_item(15),0,0,0,0,-1)
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=13 Then
        rlprint "The crew of this ship not only survived the crash landing, they opened a casino here!"
        If specialflag(11)=0 Then
            no_key=keyin
            b=casino(1)
            If b>0 Then
                If b>1000 Then b=1100
                For a=0 To b Step 100
                p1=movepoint(awayteam.c,5)
                lastenemy=lastenemy+1
                enemy(lastenemy)=makemonster(23,slot)
                enemy(lastenemy)=setmonster(enemy(lastenemy),slot,spawnmask(),lsp,p1.x,p1.y,lastenemy)
                Next
                specialflag(11)=1
            EndIf
        Else
            rlprint "you are informed that you are barred from the casino."
        EndIf
    EndIf


    If tmap(awayteam.c.x,awayteam.c.y).gives=15 Then
        buysitems("This house is stuffed floor to ceiling with antiquities. Paintings, statues, furniture, jewelery, some is of earth origin, some clearly not.","Do you think you have anything to sell him?(y/n)",23)
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=16 Then
        If planets(slot).flags(22)=0 Then rlprint "The miners inform you that they have just shipped all their ore to the nearest spacestation."
        If planets(slot).flags(22)=-1 Then
            buysitems("There was an explosion in the mine. A lot of the workers have been injured. The medical officer offers to buy any medical supplies you may have.","Do you want to sell your medpacks?",11,1.25)
            planets(slot).flags(22)=0
        EndIf
        If planets(slot).flags(22)>0 Then
            b=planets(slot).flags(22)
            For a=lastitem+1 To lastitem+1+b
                Do
                    item(a)=make_item(96)
                Loop Until item(a).ty=15
                item(a).v5+=10
                item(a).v2+=10
                minprice+=item(a).v5

            Next
            minprice=10+CInt(minprice*(5/(5+disnbase(player.c))))
            If askyn("The miners are willing to sell some ore for "&credits(minprice)&" Cr. Do you want to buy it? (y/n)") Then
                If paystuff(minprice) Then
                    For a=lastitem+1 To lastitem+1+b
                        item(a).w.s=-1
                        reward(2)+=item(a).v5
                    Next
                    lastitem=lastitem+1+b        
                    planets(slot).flags(22)=0
                EndIf
            EndIf
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=17 Then
        buysitems("A big warehouse. A shady character is sitting behind a counter. He explains 'I am very interested in buying weapons of any kind, especially without going through the hassle a purchase at one of the stations would cause.'","Do you want to sell weapons?",2,1.15,1)
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=18 Then
        buysitems("A big warehouse. A shady character is sitting behind a counter. He explains 'I am very interested in buying raw materials we can use to repair ships.'","Do you want to sell Resources?",15,0.95,1)
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=19 Then
        rlprint "This is where the leaders of the planet meet. They express interest in high tech goods, and are willing to offer some automated gadgets they have been building."
        rlprint "They are actually very sophisticated! The technology of these creatures is behind that of humanity in term of energy generation mainly, but everything else they seem to be equal or even surpassing."
        If rnd_range(1,100)>planets(slot).flags(28) Then
            If askyn ("Do you want to trade your tech goods for luxury goods?(y/n)") Then
                b=0
                For a=0 To 9
                    If player.cargo(a).x=4 Then
                        player.cargo(a).x=5
                        player.cargo(a).y=0
                        b=b+1
                    EndIf
                Next
                If b=0 Then rlprint "You don't have any high tech goods to trade"
                If b>0 Then rlprint "You trade "& b &" tons of high tech goods for luxury goods."
                planets(slot).flags(28)+=b
                If planets(slot).flags(28)>=5 Then

                    p.x=-1
                    p=rnd_point(slot,107)
                    If p.x>0 Then
                        planets(slot).flags(28)-=5
                        planetmap(p.x,p.y,slot)=297
                        tmap(p.x,p.y)=tiles(297)
                    Else
                        rlprint "The leaders tell you that they managed to upgrade all factories on their planet"
                        specialflag(17)=1
                    EndIf
                EndIf
                no_key=keyin
            EndIf
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=26 Then
        rlprint "A Weapons and Equipment store"
        If slot<>piratebase(0) Or faction(0).war(2)<=0 Then
            Do
                Cls
                display_ship
                If slot=piratebase(0) Then
                    c=shop(5,0.8,"Equipment")
                Else
                    If slot=specialplanet(14) Then
                        c=shop(6,0.9,"Equipment")
                    Else
                        c=shop(4,0.9,"Equipment")
                    EndIf
                EndIf
            Loop Until c=-1
        Else
            rlprint "they dont want to trade with you"& faction(0).war(2)
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=27 Then
        rlprint "A Bar"
        If slot=piratebase(0) Then
            If faction(0).war(2)<=30 Then
                If rnd_range(1,100)>10+crew(2).morale+add_talent(1,4,10) Then
                    rlprint "Pilot "&crew(2).n &" doesn't want to come out again.",14
                    crew(2)=crew(0)
                EndIf
                If rnd_range(1,100)>10+crew(3).morale+add_talent(1,4,10) Then
                    rlprint "Gunner "&crew(3).n &" reckons he can make a fortune playing darts and decides to stay.",14
                    crew(3)=crew(0)
                EndIf
                If rnd_range(1,100)>10+crew(4).morale+add_talent(1,4,10) Then
                    rlprint "Science Officer "&crew(4).n &" has discovered an unknown drink. He decides to make a new carreer in barkeeping to study it.",14
                    crew(4)=crew(0)
                EndIf
                If rnd_range(1,100)>10+crew(5).morale+add_talent(1,4,10) Then
                    rlprint "Doctor "&crew(5).n &" comes to the conclusion that he is needed more here than on your ship." ,14
                    crew(5)=crew(0)
                EndIf
            Else
                rlprint "they dont want to serve you"& faction(0).war(2)
            EndIf
        EndIf
        If slot<>piratebase(0) Or faction(0).war(2)<=30 Then
            hiring(0,rnd_range(0,5),maximum(4,awayteam.hp))
            equip_awayteam(slot)
            If awayteam.oxygen<awayteam.oxymax Then awayteam.oxygen=awayteam.oxymax
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=28 Then
        rlprint "Spaceship fuel for sale"
        If planets(slot).flags(26)=9 Then rlprint "Due to a fuel shortage the price has been increased."
        If slot<>piratebase(0) Or faction(0).war(2)<=30 Then
            If askyn("Do you want to refuel (" &fuelprice &" Cr. per ton) and reload ammo? (y/n)") Then refuel(planets(slot).flags(29),fuelprice)
        Else
            rlprint "they deny your request"& faction(0).war(2)
        EndIf
    EndIf


    If tmap(awayteam.c.x,awayteam.c.y).gives=29 Then
        rlprint "Ships Repair"
        If slot<>piratebase(0) Or faction(0).war(2)<=20 Then
            repair_hull(0.8)
        Else
            rlprint "they dont want to repair a ship they shot up themselves"& faction(0).war(2)
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=30 Then
        rlprint "Entering "&Shipyardname(sy_pirates)
        If slot<>piratebase(0) Or faction(0).war(2)<=20 Then
            If slot=piratebase(0) Then
                shipupgrades(4)
            Else
                shipupgrades(5)
            EndIf
        Else
            rlprint "they dont want to upgrade a ship they are going to shoot up themselves"& faction(0).war(2)
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=31 Then
        rlprint "Entering "&Shipyardname(sy_pirates)

        If slot<>piratebase(0) Or faction(0).war(2)<=20 Then
            shipyard(sy_pirates)
        Else
            rlprint "they dont want to upgrade a ship they are going to shoot up themselves"& faction(0).war(2)
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=132 Then
        If alliance(0)=1 And alliance(2)=0 Then
            If askyn("Do you want to order your pirates to join the alliance against the robot ships?(y/n)") Then
                rlprint "We stand by your side."
                alliance(2)=1
                factionadd(0,2,-100)
            EndIf
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=32 Then
        rlprint "This is the Villa of the Pirate Leader."
        If faction(0).war(2)<=20 Then
            reward_bountyquest(1)
            reward_patrolquest()
            Select Case questroll
            Case 10 To 25 
                give_bountyquest(1)
            Case 1 To 10
                give_patrolquest(1)
            End Select
            
            If player.towed<>0 Then
                towed=gethullspecs(drifting(player.towed).s,"data/ships.csv")
                a=towed.h_price
                If planets(drifting(player.towed).m).genozide<>1 Then a=a/2
                a=CInt(a)
                If askyn ("the pirate chief offers you "&a &" Cr. for the "&towed.h_desig &" you have in tow. Do you accept?(y/n)") Then
                    drifting(player.towed)=drifting(lastdrifting)
                    lastdrifting-=1
                    addmoney(a,mt_piracy)
                    player.towed=0
                EndIf
            EndIf
            rlprint "You sit down for some drinks and discuss your travels."
            planet_bounty()
        EndIf
        If faction(0).war(2)<=60 Then
            If askyn("Do you want to challenge him to a duel?(y/n)") Then
                rlprint "He accepts. The Anne Bonny launches and awaits you in orbit."
                no_key=keyin
                lastfleet=lastfleet+1
                fleet(lastfleet)=makequestfleet(5)
                spacecombat(fleet(lastfleet),3)
                If player.dead=0 Then
                    rlprint "Defeating the pirate chief makes you the new pirate chief!",c_gre
                    addmoney(100000,mt_piracy)
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=198
                Else
                    player.dead=26
                EndIf
            EndIf
            ask_alliance(2)

        EndIf
        If faction(0).war(2)>60 Then
            rlprint "He does not want to talk to you"
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=33 Then specialflag(27)=1

    If tmap(awayteam.c.x,awayteam.c.y).gives=34 Then buy_weapon(1)

    If tmap(awayteam.c.x,awayteam.c.y).gives=35 Then shipyard(sy_blackmarket)

    If tmap(awayteam.c.x,awayteam.c.y).gives=36 Then
        If slot<>piratebase(0) Or faction(0).war(1)<=0 Then
            rlprint "The captain of this scoutship says: 'Got any bio or mapdata? I can sell that stuff at the space station and offer to split the money 50:50"
            If askyn("Do you want to sell data(y/n)") Then
                rlprint "you transfer new map data on "&reward(0)&" km2. you get paid "&CInt((reward(7)/15)*.5*(1+0.1*crew(1).talents(2)))&" credits"
                addmoney(CInt((reward(7)/15)*.5*(1+0.1*crew(1).talents(2))),mt_map)
                reward(0)=0
                reward(7)=0
                rlprint "you transfer data on alien lifeforms worth "& CInt(reward(1)*.5*(1+0.1*crew(1).talents(2))) &" credits."
                addmoney(CInt(reward(1)*.5*(1+0.1*crew(1).talents(2))),mt_bio)
                reward(1)=0
                For a=0 To lastitem
                    If item(a).ty=26 And item(a).w.s=-1 Then item(a).v1=0
                Next
            EndIf
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=39 Then
        'Food planet
        If player.questflag(25)=0 Then
            If player.questflag(20)>0 Then
                If player.questflag(20)=1 Then rlprint "The colonists pay you "&player.questflag(20)*10 &" Cr. for the killed burrower."
                If player.questflag(20)>1 Then rlprint "The colonists pay you "&player.questflag(20)*10 &" Cr. for the killed burrowers."
                addmoney(player.questflag(20)*10,mt_trading)
                player.questflag(20)=0
            EndIf

            If findbest(87,-1)>0 Then
                If askyn("The colonists would buy the burrowers eggsacks for 50 Credits a piece. Do you want to sell?(y/n)") Then
                    For a=0 To lastitem
                        If item(a).ty=87 And item(a).w.s=-1 Then
                            destroyitem(a)
                            addmoney(50,mt_bio)
                        EndIf
                    Next
                EndIf
            EndIf
        Else
            If player.questflag(25)=1 Then
                player.questflag(25)=2
                rlprint "The colonists leader accepts the burrowers terms. They offer you 1000 Cr. for your help in negotiating a peace"
                addmoney(1000,mt_quest2)
            EndIf
        EndIf
        If askyn("Do you want to trade with the colonists?(y/n)") Then
            If player.questflag(25)=0 Then
                basis(9).inv(1).v=10
                basis(9).inv(1).p=10
                basis(9).inv(2).p=100
                basis(9).inv(3).p=300
                For a=2 To 8
                    basis(9).inv(a).v=0
                Next
            Else
                basis(9).inv(1).v=5
                basis(9).inv(1).p=15
                basis(9).inv(2).p=100
                basis(9).inv(3).p=300
                For a=2 To 8
                    basis(9).inv(a).v=0
                Next
            EndIf
            tCompany.trading(9)
        EndIf

    EndIf


    If tmap(awayteam.c.x,awayteam.c.y).gives=40 Then
        rlprint "A nagging feeling in the back of your head you had since you landed on this planet suddenly dissapears."
        specialflag(20)=1
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=41 Then
        rlprint "A nagging feeling in the back of your head you had since you entered this ship suddenly dissapears."
        player.questflag(11)=2
    EndIf


    If tmap(awayteam.c.x,awayteam.c.y).gives=42 Then
        If slot<>piratebase(0) Or faction(0).war(2)<=0 Then
            If askyn("This shop offers hullrefits, turning 5 crew bunks into an additional cargo hold for 1000 Cr. Do you want your ship modified?(y/n)") Then
                If paystuff(1000) Then pirateupgrade
            EndIf
        Else
            rlprint "they dont want to repair a ship they are going to shoot up themselves."
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=43 Then
        player.disease=sick_bay(1)
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=44 Then
        If planets(slot).mon_killed(1)=0 Then
            If askyn("Do you want to fight in the arena? (y/n)") Then
                planets(slot).depth=0
                enemy(1)=makemonster(2,slot)
                enemy(1)=setmonster(enemy(1),slot,spawnmask(),lsp,awayteam.c.x+3,awayteam.c.y,1)
                enemy(1).slot=1
                planets(slot).plantsfound=(enemy(1).hpmax^2+enemy(1).armor+enemy(1).weapon+rnd_range(1,2))*10

                planets(slot).depth=1

                For x=awayteam.c.x+1 To awayteam.c.x+5
                    For y=awayteam.c.y-2 To awayteam.c.y+2
                        If rnd_range(1,100)<66 Then
                            planetmap(x,y,slot)=rnd_range(2,4)
                        Else
                            planetmap(x,y,slot)=rnd_range(1,7)
                        EndIf
                        tmap(x,y)=tiles(planetmap(x,y,slot))
                    Next
                Next
            EndIf
            If askyn("Do you want to sell your aliens as arena contestants?(y/n)") Then
                sell_alien(slse_arena)
            EndIf

        Else
            addmoney(planets(slot).plantsfound,mt_gambling)
            rlprint "You get "& planets(slot).plantsfound &" Cr. for the fight.",10
            planets(slot).mon_killed(1)=0
            planets(slot).plantsfound=0
            For x=awayteam.c.x+1 To awayteam.c.x+5
                For y=awayteam.c.y-2 To awayteam.c.y+2
                    planetmap(x,y,slot)=4
                    tmap(x,y)=tiles(planetmap(x,y,slot))
                Next
            Next
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=45 Then 
        If is_drifter(slot) Then
            casino(,-1)
        Else
            casino(,10)
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=46 Then
        sell_alien(slse_zoo)
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=47 Then tRetirement.retirement()

    If tmap(awayteam.c.x,awayteam.c.y).gives=48 Then tRetirement.buytitle()

    If tmap(awayteam.c.x,awayteam.c.y).gives=49 Then customize_item()

    If tmap(awayteam.c.x,awayteam.c.y).gives=50 Then
        If planets(slot).flags(26)=1 Then rlprint "The admin informs you that there is a alien lifeform lose on the station, and advises you to stay clear of dark corners."
        If planets(slot).flags(26)=4 Then rlprint "The admin informs you that there is a mushroom infestation on the station, and that he pays 50 credits for each dead one."
        If planets(slot).flags(26)=5 Then rlprint "The admin informs you that there is a group of pirates on the station and asks you to be polite."
        If planets(slot).flags(26)=6 Then rlprint "The admin informs you that the station has been hit by an asteroid and is currently leaking. He apologizes for the inconvenience."
        If planets(slot).flags(26)=9 Then rlprint "The admin informs you that there is a fuel shortage and the prices have been increased to "&fuelprice &" for buying and 5 Cr. a ton for selling"
        If planets(slot).flags(26)=10 Then rlprint "The admin is very excited: There is a party of civilized aliens on board!"
        If planets(slot).flags(26)=12 Then rlprint "The admin informs you that there is a tribble infestation on the station, and that he pays 10 credits for each dead one."
        For a=1 To lastenemy
            If enemy(a).hp<=0 Then
                If enemy(a).made=2 Then planets(slot).flags(26)=2
                If enemy(a).made=7 Then planets(slot).flags(27)+=1
                If enemy(a).made=34 Then planets(slot).flags(27)+=1
                If enemy(a).made=101 Then planets(slot).flags(27)+=1
                enemy(a)=enemy(lastenemy)
                lastenemy-=1
            EndIf
        Next
        If planets(slot).flags(26)=2 Then
            planets(slot).flags(26)=3
            player.money=player.money=100
            rlprint "The Admininstrator thanks you for dispatching the beast, and gives you 100 Cr."
        EndIf
        If planets(slot).flags(27)>0 And planets(slot).flags(26)=4 Then
            rlprint "You get "&50*planets(slot).flags(27) &" Cr. for the destroyed mushrooms."
            addmoney(50*planets(slot).flags(27),mt_quest2)
            planets(slot).flags(27)=0
        EndIf
        If planets(slot).flags(27)>0 And planets(slot).flags(26)=5 Then
            rlprint "'Thanks for helping to fight back the pirates' You get "&250*planets(slot).flags(27) &" Cr. for the destroyed mushrooms."
            addmoney(250*planets(slot).flags(27),mt_quest2)
            planets(slot).flags(27)=0
        EndIf

        If planets(slot).flags(27)>0 And planets(slot).flags(26)=12 Then
            rlprint "You get "&10*planets(slot).flags(27) &" Cr. for the killed tribbles."
            addmoney(10*planets(slot).flags(27),mt_quest2)
            planets(slot).flags(27)=0
        EndIf

        If askyn("Do you want to sell fuel for " &fuelsell &" Credits per ton? (y/n)") Then
            If getinvbytype(9)>0 Then
                If askyn( "Do you want to sell fuel stored in your cargo hold?") Then
                    rlprint "How much fuel do you want to sell?"
                    a=getnumber(0,getinvbytype(9),0)
                    addmoney(Int(a*30*fuelsell),mt_trading)
                    removeinvbytype(9,a)
                    If planets(slot).flags(26)=9 Then
                        If rnd_range(1,100)<planets(slot).flags(27) Then planets(slot).flags(26)=0
                    EndIf
                    rlprint "You sell "&30*a &" tons of fuel for "& Int(30*a*fuelsell) &" Cr."
                EndIf
            EndIf
            rlprint "How much fuel do you want to sell? (" &player.fuel &")"
            a=getnumber(0,player.fuel,0)
            If a>0 Then
                player.fuel=player.fuel-a
                addmoney(Int(a*fuelsell),mt_trading)
                If planets(slot).flags(26)=9 Then
                    If rnd_range(1,100)<planets(slot).flags(27) Then planets(slot).flags(26)=0
                EndIf
                rlprint "You sell "&a &" tons of fuel for "& Int(a*fuelsell) &" Cr."
            EndIf
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=51 Then
        rlprint tmap(awayteam.c.x,awayteam.c.y).hitt
        For a=0 To lastenemy
            If enemy(a).made<>73 Then enemy(a).aggr=0
        Next
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=55 Then
        If askyn("A tank full of processed ship fuel. Do you want to use it?(y/n)") Then
            player.fuel=player.fuelmax+player.fuelpod
            rlprint "You refuel your ship."
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=56 Then
        If askyn("Do you want to repair it?(y/n)") Then
            If skill_test(player.science(location),st_average,"Repair") Then
                If skill_test(player.science(location),st_average,"Repair") Then
                    rlprint "You succeed!"
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=232
                    planets(slot).atmos=5
                Else
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=231
                    rlprint "You fail."
                EndIf
            Else
                tmap(awayteam.c.x,awayteam.c.y).turnsinto=233
                rlprint "You destroy the console in your attempt to repair it."
            EndIf

        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=57 Then 'repairing reactor
        If askyn("Do you want to repair it?(y/n)") Then
            If skill_test(player.science(location),st_average,"Repair") Then
                If skill_test(player.science(location),st_average,"Repair") Then
                    rlprint "You succeed!"
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=235
                    specialflag(31)=1
                    'hide map
                    'put station 3 in positon
                EndIf
            Else
                tmap(awayteam.c.x,awayteam.c.y).turnsinto=236
                rlprint "You destroy the console in your attempt to repair it."
            EndIf
            If tmap(awayteam.c.x,awayteam.c.y).turnsinto=234 Then rlprint "You fail."
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=58 Then 'shutting down reactor
        If askyn("Do you want to shut it down? (y/n)") Then
            For x=0 To 60
                For y=0 To 20
                    If planetmap(x,y,specialplanet(9))=-18 Then planetmap(x,y,specialplanet(9))=-4
                    If planetmap(x,y,specialplanet(9))=18 Then planetmap(x,y,specialplanet(9))=4
                Next
            Next
            If Not(skill_test(player.science(location),st_easy)) Then
                rlprint "Something went wrong... this thing is about to blow up!"
                sf=sf+1
                If sf>15 Then sf=0
                shipfire(sf).where=awayteam.c
                shipfire(sf).when=3
                shipfire(sf).what=10+sf
                player.weapons(shipfire(sf).what)=make_weapon(rnd_range(1,5))
                sf=sf+1 'Sets set__color( to blueish
            EndIf
        EndIf
    EndIf
            If tmap(awayteam.c.x,awayteam.c.y).gives=59 Then 'Scrapyard
                botsanddrones_shop
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=60 Then 'Town hall in settlements
                If askyn("Do you want to trade with the locals?(y/n)") Then
                    '
                    ' Trading
                    '
                    For a=11 To 13
                        If planets(slot).flags(a)<0 Then
                            c=Int(baseprice(a-10)*(rnd_range(1,2)+Abs(planets(slot).flags(a))))
                            If a=11 Then text="The colonists are in dire need of food. They are willing to pay "&c &" per ton. Do you want to sell? (y/n)"
                            If a=12 Then text="The colonists are in dire need of basic goods. They are willing to pay "&c &" per ton. Do you want to sell? (y/n)"
                            If a=13 Then text="The colonists are in dire need of tech goods. They are willing to pay "&c &" per ton.Do you want to sell? (y/n)"
                            If getinvbytype(a-10)>0 Then
                                If askyn(text) Then
                                    For b=1 To player.h_maxcargo
                                        If player.cargo(b).x=a-9 Then
                                            rlprint "You sell a ton of "& goodsname(a-10) &" for "& c &" Cr."
                                            player.cargo(b).x=1
                                            addmoney(c,mt_trading)
                                            planets(slot).flags(a)=0
                                        EndIf
                                    Next
                                EndIf
                            EndIf
                        ElseIf planets(slot).flags(a)>0 Then
                            c=Int(baseprice(a-10)/(rnd_range(1,2)+Abs(planets(slot).flags(a))))
                            If a=11 Then text="The colonists have a surplus of food. They are willing to sell it for "&c &" cr. per ton. Do you want to buy? (y/n)"
                            If a=12 Then text="The colonists have a surplus of basic goods. They are willing to sell it for "&c &" cr. per ton. Do you want to buy? (y/n)"
                            If a=13 Then text="The colonists have a surplus of tech goods. They are willing to sell it for "&c &" cr. per ton. Do you want to buy? (y/n)"
                            If askyn(text) Then
                                d=getnextfreebay()
                                If d>0 Then
                                    If paystuff(c) Then
                                        rlprint "You buy a ton of "& goodsname(a-10) &" for "& c &" Cr."
                                        player.cargo(d).x=a-9
                                        player.cargo(d).y=c
                                        planets(slot).flags(a)=0
                                    Else
                                        rlprint "You don't have enough money."
                                    EndIf
                                Else
                                    rlprint "You don't have enough room."
                                EndIf
                            EndIf
                        EndIf
                    Next
                    If planets(slot).flags(14)>0 Then
                        If askyn("The colonists have some equipment they no longer need. Do you want to look at it?(y/n)") Then shop(planets(slot).flags(14),.75,"Equipment for sale")
                    EndIf
                    For a=15 To 20
                        If planets(slot).flags(a)>0 Then
                            'selling equipment
                            text=""
                            If planets(slot).flags(a)=1 Then text="They need jetpacks and hoverplatforms. They offer to pay 150% of station prices. "
                            If planets(slot).flags(a)=2 Then text="They need long range weapons. They offer to pay 150% of station prices. "
                            If planets(slot).flags(a)=3 Then text="They need armor. They are offer to pay 150% of station prices. "
                            If planets(slot).flags(a)=4 Then text="They need melee weapons. They offer to pay 150% of station prices. "
                            If planets(slot).flags(a)=5 Then text="They need mining equipment. They offer to pay 150% of station prices. "
                            If planets(slot).flags(a)=11 Then text="They need medical supplies. They offer to pay 150% of station prices. "
                            If text<>"" Then buysitems(text,"Do you want to sell?(y/n)",planets(slot).flags(a),1.5)
                        EndIf
                    Next
                EndIf
            EndIf


            If tmap(awayteam.c.x,awayteam.c.y).gives=61 Then
                rlprint "This computer contains files detailing how eridiani explorations uses the plants on this planet to produce a powerfull halluzinogenic drug, and smuggles it onto space stations. If this information went public it could seriously harm their business."
                player.questflag(21)=1
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=62 Then
                rlprint "This computer runs a database, containing all the 'workers' in this complex. They all were 'convicted' for violating Smith Heavy Industries company policies, and have to work off their fine here. There is an alarmingly high number of 'work related accidents' Money paid for food for the workers is on the other hand alarmingly low. No wonder SHI doesn't advertise about this place."
                player.questflag(22)=1
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=63 Then
                x=player.c.x-basis(0).c.x/2
                y=player.c.y-basis(0).c.y/2
                x=basis(0).c.x+x
                y=basis(0).c.y+y
                If player.questflag(23)=0 Then
                    lastdrifting=lastdrifting+1
                    If lastdrifting>128  Then lastdrifting=128

                    drifting(lastdrifting).s=14
                    drifting(lastdrifting).x=x
                    drifting(lastdrifting).y=y
                    drifting(lastdrifting).m=lastplanet+1
                    lastplanet=lastplanet+1
                    load_map(13,lastplanet)
                    p=rnd_point(lastplanet,0)
                    planetmap(p.x,p.y,lastplanet)=-255
                    planets(lastplanet).mon_template(0)=makemonster(74,lastplanet)
                    planets(lastplanet).mon_noamin(0)=10
                    planets(lastplanet).mon_noamax(0)=16
                    planets(lastplanet).mon_template(1)=makemonster(75,lastplanet)
                    planets(lastplanet).mon_noamin(1)=5
                    planets(lastplanet).mon_noamin(1)=6
                EndIf
                player.questflag(23)=1
                rlprint "At this terminal the routes of a big number of freelance traders are displayed. Triax Traders Ships are specially marked. Also the pirates are supposed to rendezvous with a ship at "&x &":"&y &" at regulare intervals."
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=64 Then
                player.questflag(23)=2
                rlprint "This computer details the plan that Triax Traders is sponsoring Pirates."
            EndIf


            If tmap(awayteam.c.x,awayteam.c.y).gives=65 Then
                player.questflag(24)=1
                rlprint "Here are detailed experiments by Omega Bionegineering to breed crystal/human hybrids. They buy 'Volunteers' from a pirate captain. If this gets public it would break their neck."
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=66 Then
                mudds_shop
            EndIf


            If tmap(awayteam.c.x,awayteam.c.y).gives=67 Then
                buysitems("We buy all pieces of art you may 'find'.","Do you think you have anything to sell?(y/n)",23,.25)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=68 Then
                rlprint "The center of this temple contains a forcefield. In it is a beautiful, 3m tall woman, with long black hair, wearing a white robe.",15
                If askyn("A generator seems to provide the energy for the forcefield, do you want to try to turn it off?(y/n)") Then
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=297
                    rlprint "You manage to switch it off"
                    no_key=keyin
                    rlprint "As soon as the forcefield collapses the figure flies up through the cieling of the temple, shattering it.",15
                    lastfleet+=1
                    fleet(lastfleet).c=player.c
                    fleet(lastfleet).ty=10
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=57
                Else
                    rlprint "She looks at you pleading, and pointing at the generator."
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=296
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=69 Then sell_alien(slse_zoo)

            If tmap(awayteam.c.x,awayteam.c.y).gives>=70 And tmap(awayteam.c.x,awayteam.c.y).gives<=73 Then
                If planets(slot).colflag(0)=0 Then
                    basis(10)=makecorp(tmap(awayteam.c.x,awayteam.c.y).no-298)
                Else
                    basis(10)=makecorp(planets(slot).colflag(0))
                    planets(slot).colflag(1)+=reward(0)/10
                    planets(slot).colflag(1)+=reward(1)/10
                    planets(slot).colflag(1)+=reward(2)/10
                    planets(slot).colflag(1)+=reward(3)/10
                    planets(slot).colflag(1)+=reward(4)/10
                    planets(slot).colflag(1)+=reward(5)/10
                    planets(slot).colflag(1)+=reward(6)/10
                    planets(slot).colflag(1)+=reward(7)/10
                EndIf
                basis(10).mapmod=basis(10).mapmod*0.75
                basis(10).biomod=basis(10).biomod*0.75
                basis(10).resmod=basis(10).resmod*0.75
                basis(10).pirmod=basis(10).pirmod*0.75
                tCompany.company(10)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=74 Then sell_alien(slse_slaves)

            If tmap(awayteam.c.x,awayteam.c.y).gives=75 Then used_ships



            If tmap(awayteam.c.x,awayteam.c.y).gives=167 Then
                If askyn("A working security camera terminal. Do you want to try to use it?(y/n)") Then
                    If skill_test(player.science(location),st_average) Then
                        p1=awayteam.c
                        awayteam.c=rnd_point(slot,0)
                        rlprint "You manage to access a camera at "&awayteam.c.x &":" &awayteam.c.y &"."
                        Do
                            make_vismask(awayteam.c,awayteam.sight,slot)
                            display_planetmap(slot,calcosx(awayteam.c.x,1),0)
                            ep_display()
                            display_awayteam()
                            rlprint ""
                            no_key=keyin
                            p2=movepoint(awayteam.c,uConsole.getdirection(no_key))
                            If tmap(p2.x,p2.y).walktru=0 Then awayteam.c=p2
                        Loop Until no_key=key__esc Or Not(skill_test(player.science(location),st_easy))
                        awayteam.c=p1
                    Else
                        rlprint "You do not get it to work properly."
                        If Not(skill_test(player.science(location),11)) Then
                            rlprint "Actually you manged to break it completely."
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84
                        EndIf
                    EndIf
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=168 Then
                If askyn("A switched off security robot. Do you want to try and reprogram it and turn it on again?(y/n)") Then
                    If skill_test(player.science(location),st_veryhard,"Repair") Then
                        rlprint "You manage!"
                        If get_freecrewslot>-1 Then
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=80
                            add_member(13,0)
                        Else
                            rlprint "But you don't have enough room on your ship for the robot."
                        EndIf
                    Else
                        If skill_test(player.science(location),st_average) Then
                            'Failure
                            rlprint "This robot is beyond repair"
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84

                        Else
                            'Catastrophic Failure
                            rlprint "You manage to switch it on but not to reprogram it!",c_red
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=80
                            lastenemy+=1
                            enemy(lastenemy)=setmonster(makemonster(9,slot),slot,spawnmask(),lsp,awayteam.c.x,awayteam.c.y)
                        EndIf
                    EndIf
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=169 Then
                If askyn("A working security terminal. Do you want to try to use it?(y/n)") Then
                    If skill_test(player.science(location),st_average) Then
                        If skill_test(player.science(location),st_hard) Then
                            rlprint "You manage to shut down the traps on this level."
                            For x=0 To 60
                                For y=0 To 20
                                    If tmap(x,y).tohit<>0 Then
                                        tmap(x,y).tohit=0
                                        tmap(x,y).dam=0
                                        tmap(x,y).hitt=""
                                    EndIf
                                Next
                            Next
                        Else
                            rlprint "You manage to shut down some of the traps on this level."
                            For x=0 To 60
                                For y=0 To 20
                                    If skill_test(player.science(location),st_veryhard) And tmap(x,y).tohit<>0 Then
                                        tmap(x,y).tohit=0
                                        tmap(x,y).hitt=""
                                    EndIf
                                Next
                            Next
                        EndIf
                    Else
                        rlprint "You do not get it to work properly."
                        If Not(skill_test(player.science(1),11)) Then
                            rlprint "Actually you manged to break it completely."
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84
                        EndIf
                    EndIf
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=170 Then
                If askyn("A working security terminal. Do you want to try to use it?(y/n)") Then
                    If skill_test(player.science(location),st_hard) Then
                        rlprint "You manage to reveal hidden doors on this level."
                        For x=0 To 60
                            For y=0 To 20
                                If tmap(x,y).turnsoninspect=54 Then
                                    planetmap(x,y,slot)=tmap(x,y).turnsoninspect
                                    tmap(x,y)=tiles(tmap(x,y).turnsoninspect)
                                EndIf
                            Next
                        Next
                    Else
                        rlprint "You do not get it to work properly."
                        If Not(skill_test(player.science(location),st_easy)) Then
                            rlprint "Actually you manged to break it completely."
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84
                        EndIf
                    EndIf
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=171 Then
                If askyn("A working security terminal. Do you want to try to use it?(y/n)") Then
                    If skill_test(player.science(location),st_average) Then
                        rlprint "You get it to display a map of this complex."
                        For x=0 To 60
                            For y=0 To 20
                                If planetmap(x,y,slot)<0 Then planetmap(x,y,slot)=planetmap(x,y,slot)*-1
                            Next
                        Next
                    Else
                        rlprint "You do not get it to work properly."
                        If Not(skill_test(player.science(location),st_easy)) Then
                            rlprint "Actually you manged to break it completely."
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84
                        EndIf
                    EndIf
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=172 Then
                If askyn("A working computer terminal. Do you want to try to use it?(y/n)") Then
                    If skill_test(player.science(location),st_veryhard) Then
                        rlprint "It's a database on the technology of the ancient aliens."
                        If reward(4)>0 Then
                            reward(4)-=1
                            findartifact(0)
                        Else
                            rlprint "Unfortunately you do not have any technology of the ancient aliens."
                        EndIf
                    Else
                        rlprint "You do not get it to work properly."
                        If Not(skill_test(player.science(location),st_hard)) Then
                            rlprint "Actually you manged to break it completely."
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84
                        EndIf
                    EndIf
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=111 Then
                rlprint "This is a data collection about all the 'enhanced pets' of the ancient aliens. They used the tree beings as scientific advisors, and made a silicium based lifeform they were somehow able to use as a powersource. It doesn't really go into detail about that. Also missing is any information on the aliens themselves."
                player.questflag(1)=1
            EndIf

            b=0
            If tmap(awayteam.c.x,awayteam.c.y).gives=205 Then
                'Just don't land here
            EndIf
            If tmap(awayteam.c.x,awayteam.c.y).gives=206 Then
                If planets(slot).flags(3)>0 Then
                    If askyn("A grade "&planets(slot).flags(3) &" engine. Do you want to transfer it to your ship?(y/n)") Then
                        If planets(slot).flags(3)<player.engine Then
                            rlprint "You already have a better engine than this."
                        Else
                            If planets(slot).flags(3)<=player.h_maxengine Or planets(slot).flags(3)=6 Then
                                player.engine=planets(slot).flags(3)
                                planets(slot).flags(3)=0
                                b=1
                                If player.engine=6 Then artflag(6)=1
                            Else
                                rlprint "This engine is too big for your ship"
                            EndIf
                        EndIf
                    Else
                        b=scrap_component
                    EndIf
                    
                Else
                    rlprint "An empty engine case."
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=207 Then
                If planets(slot).flags(4)>0 Then
                    If askyn("A grade "&planets(slot).flags(4) &" sensor suite. Do you want to transfer it to your ship?(y/n)") Then
                        If planets(slot).flags(4)<player.sensors Then
                            rlprint "You already have a better sensors than this."
                        Else
                            If planets(slot).flags(4)<=player.h_maxsensors Or planets(slot).flags(4)=6 Then
                                player.sensors=planets(slot).flags(4)
                                planets(slot).flags(4)=0
                                b=1
                                If player.sensors=6 Then artflag(7)=1
                            Else
                                rlprint "This sensor array is too big for your ship"
                            EndIf
                        EndIf
                    Else
                        b=scrap_component
                    EndIf
                Else
                    rlprint "An empty sensor case."
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=208 Then
                If planets(slot).flags(5)>0 Then
                    If askyn("A grade "&planets(slot).flags(5) &" shield generator. Do you want to transfer it to your ship?(y/n)") Then
                        If planets(slot).flags(5)<player.shieldmax Then
                            rlprint "You already have a better shields than this."
                        Else
                            If planets(slot).flags(5)<=player.h_maxshield Then
                                player.shieldmax=planets(slot).flags(5)
                                planets(slot).flags(5)=0
                                b=1
                            Else
                                rlprint "This shield generator is too big for your ship"
                            EndIf
                        EndIf
                    Else
                        b=scrap_component
                    EndIf
                Else
                    rlprint "An empty shield generator case."
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=210 Then
                c=tmap(awayteam.c.x,awayteam.c.y).turnsinto-209
                rlprint c & " " & planets(slot).flags(c)
                If planets(slot).flags(c+6)=0 Then
                    rlprint "An empty weapons turret."
                Else
                    If askyn(add_a_or_an((planets(slot).weapon(c)).desig,1) &". Do you want to transfer it to your ship?(y/n)") Then
                        d=player.h_maxweaponslot
                        text="Weapon Slot/"
                        For a=1 To d
                            If player.weapons(a).desig="" Then
                                text=text & "-Empty-/"
                            Else
                                text=text & player.weapons(a).desig & "/"
                            EndIf
                        Next
                        text=text+"Exit"
                        d=d+1
                        e=textmenu(bg_awayteam,text)
                        If e<d Then
                            player.weapons(e)=(planets(slot).weapon(c))
                            b=1
                            planets(slot).flags(c)=0
                            recalcshipsbays
                        EndIf
                    Else
                        b=scrap_component
                    EndIf
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=211 Then
                c=tmap(awayteam.c.x,awayteam.c.y).turnsinto-203'Flags 12 to 16
                If planets(slot).flags(c)>1 Then
                    If planets(slot).flags(c)=2 Then text="Food"
                    If planets(slot).flags(c)=3 Then text="Basic goods"
                    If planets(slot).flags(c)=4 Then text="Tech goods"
                    If planets(slot).flags(c)=5 Then text="Luxury goods"
                    If planets(slot).flags(c)=6 Then text="Weapons"
                    If askyn("A cargo crate with "& text &". Do you want to transfer it to your ship?(y/n)") Then
                        For a=1 To 10
                            If player.cargo(a).x=1 And b=0 Then
                                b=1
                                player.cargo(a).x=planets(slot).flags(c)
                                planets(slot).flags(c)=0
                            EndIf
                            If b=0 Then rlprint "Your cargo hold is full."
                        Next
                    EndIf
                Else
                    rlprint "An empty cargo crate"
                EndIf
                If planets(slot).flags(26)=8 Then b=0 'Small spacestation abandoned cargo
            EndIf

            If b>0 Then
                For a=0 To lastenemy
                    If enemy(a).hp>0 Then
                        enemy(a).aggr=0
                    EndIf
                Next
                If planets(slot).atmos>1 Then rlprint "You hear alarm sirens!",14
                If planets(slot).atmos=1 Then rlprint "You see a red alert light flashing!",14
            EndIf

            For a=1 To lastdrifting
                If slot=drifting(a).m Then c=drifting(a).s
            Next

            If tmap(awayteam.c.x,awayteam.c.y).gives=221 Then
                If askyn("These seem to be the controls of this ship. Do you want to try to use them?(y/n)") Then
                    If skill_test(player.science(1),st_veryhard) Then
                        tmap(awayteam.c.x,awayteam.c.y)=tiles(220)
                        planetmap(awayteam.c.x,awayteam.c.y,slot)=220
                    Else
                        rlprint "It looks like it started some sort of countdown"
                        tmap(awayteam.c.x,awayteam.c.y).gives=0
                        planets(slot).death=5
                    EndIf
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=220 Then
                textbox(shiptypes(planets(slot).flags(1)) &" | | " &makehullbox(planets(slot).flags(1),"data/ships.csv"),3,5,25)
                If askyn("The bridge. Do you want to abandon your ship and take over this one?(y/n)") Then
                    b=0
                    For a=0 To lastenemy
                        If enemy(a).hp>0 Then
                            enemy(a).aggr=1
                            b=b+1
                        EndIf
                    Next
                    If b=0 Then
                        If upgradehull(planets(slot).flags(1),player)=-1 Then
                            player.hull=planets(slot).flags(2)
                            planets(slot).flags(0)=1
                            nextmap.m=-1
                            If player.hull<1 Then player.hull=1
                            rlprint "You take over the ship."
                            Key=key_north
                            walking=1
                            'Weapons...
                            poolandtransferweapons(player,planetflags_toship(slot))

                            If planets(slot).flags(3)>player.engine Then player.engine=planets(slot).flags(3)
                            If planets(slot).flags(4)>player.sensors Then player.sensors=planets(slot).flags(4)
                            If planets(slot).flags(5)>player.shieldmax Then player.shieldmax=planets(slot).flags(5)
                            recalcshipsbays
                            If player.landed.m<>slot Then
                                For c=0 To lastportal
                                    If portal(c).from.m=slot Or portal(c).dest.m=slot Then
                                        player.landed=portal(c).from
                                        nextmap=portal(c).from
                                        deleteportal(portal(c).from.m,portal(c).dest.m)
                                        deleteportal(portal(c).dest.m,portal(c).from.m)
                                    EndIf
                                Next
                            EndIf
                        EndIf
                    Else
                        rlprint "You better make sure this ship is really abandoned before moving in.",14
                    EndIf
                EndIf
            EndIf

            '
            ' Alien Civs
            '
            If tmap(awayteam.c.x,awayteam.c.y).gives=301 Then
                tCompany.trading(11)
                player.lastvisit.s=tmap(awayteam.c.x,awayteam.c.y).gives+1
                factionadd(0,6,-5)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=302 Then
                tCompany.trading(12)
                player.lastvisit.s=tmap(awayteam.c.x,awayteam.c.y).gives+1
                factionadd(0,7,-5)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=311 Then
                If civ(0).phil=1 Then rlprint "This is the house where the "&civ(0).n & "council meets."
                If civ(0).phil=2 Then rlprint "This is the "&civ(0).n &" parliament"
                If civ(0).phil=3 Then rlprint "This is the "&civ(0).n &" leaders home"
                foreignpolicy(0,0)
                ask_alliance(6)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=312 Then
                If civ(1).phil=1 Then rlprint "This is the house where the "&civ(1).n & "council meets."
                If civ(1).phil=2 Then rlprint "This is the "&civ(1).n &" parliament"
                If civ(1).phil=3 Then rlprint "This is the "&civ(1).n &" leaders home"
                foreignpolicy(1,0)
                ask_alliance(7)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=321 Then
                rlprint add_a_or_an(civ(0).n,1) &" shop"
                If faction(0).war(6)<50 Then
                    shop(26,1,civ(0).n &" shop")
                Else
                    rlprint "They don't want to trade with you"
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=322 Then
                rlprint add_a_or_an(civ(1).n,1) &" shop"
                If faction(0).war(7)<50 Then
                    shop(27,1,civ(1).n &" shop")
                Else
                    rlprint "They don't want to trade with you"
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=330 Then
                buysitems("They are very interested in buying living creatures for the Zoo."," Do you want to sell?(y/n)",26,8,0)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=401 Then
                rlprint "Population:"&planets(slot).colonystats(0) &" Food:"&planets(slot).colonystats(10)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=886 Then
                If askyn("Do you want to install the cryo chamber on your ship?(y/n)") Then
                    player.cryo=player.cryo+1
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=202
                Else
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=tmap(awayteam.c.x,awayteam.c.y).no
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=887 Then
                rlprint "With the forcefield down it is easy to remove the disintegrator canon"
                artifact(4)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=888 Then
                rlprint "This computer controls the planetary defense system."
                no_key=keyin
                rlprint "Your science officer manages to disable it!"
                no_key=keyin
                specialflag(2)=2
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=999 Then
                rlprint "This terminal displays information on the status of this sector. The computer is obviously interpreting the human presence as an invasion!"
                no_key=keyin
                rlprint "The spaceships are being made ready to repell the invaders!"
                no_key=keyin
                rlprint "Your science officer tries to reprogram the computer"
                no_key=keyin
                rlprint "He succeeds! you can now use the robot ships to explore this sector and beyond without risking human life!"
                player.questflag(3)=1
                no_key=keyin
            EndIf

        If tmap(awayteam.c.x,awayteam.c.y).survivors>rnd_range(1,44) Then
            rlprint "you have found a crashed spaceship!"
            no_key=keyin
            rlprint "there are survivors! You offer to take them to the space station."
            b=rnd_range(1,6) +rnd_range(1,6)-3
            no_key=keyin
            If b>0 Then
                If askyn( b &" security personel want to join your crew. (y/n)") Then
                    If b>max_security Then b=max_security
                    For a=1 To b
                        add_member(8,0)
                    Next
                EndIf
            EndIf
            b=rnd_range(5,7)
            If b>6 Then b=6
            c=rnd_range(1,100)
            If c<33 Then
                If askyn("a pilot, skillevel " & b & " wants to join you. (y/n)") Then
                    add_member(2,b)
                EndIf
            EndIf
            If c>32 And c<66 Then
                If askyn("a gunner, skillevel " & b & " wants to join you. (y/n)") Then
                    add_member(3,b)
                EndIf
            EndIf
            If c>65 Then
                If askyn("a science officer, skillevel " & b & " wants to join you. (y/n)") Then
                    add_member(4,b)
                EndIf
            EndIf
            planetmap(awayteam.c.x,awayteam.c.y,slot)=62
        EndIf

    If tmap(awayteam.c.x,awayteam.c.y).resources>rnd_range(1,100) Then
        rlprint "you plunder the resources of the ship and move on."
        For a=0 To 2
            reward(a)=reward(a)+rnd_range(10,50)+rnd_range(10,50)+500
        Next
        planetmap(awayteam.c.x,awayteam.c.y,slot)=62
    EndIf

    If planetmap(awayteam.c.x,awayteam.c.y,slot)=17 Then
        walking=0
        If skill_test(player.science(location),st_hard) Then
            rlprint "you find an ancient computer, your Science officer manages to get map data out of it!"
            reward(5)=3
        Else
            rlprint "you find an ancient computer, but you cant get it to work"
        EndIf
        planetmap(awayteam.c.x,awayteam.c.y,slot)=16
    EndIf

    tmap(awayteam.c.x,awayteam.c.y)=tiles(tmap(awayteam.c.x,awayteam.c.y).turnsinto)
    planetmap(awayteam.c.x,awayteam.c.y,slot)=tmap(awayteam.c.x,awayteam.c.y).no
    Return 0
End function


function gets_entry(x as short,y as short, slot as short) as short
    if planetmap(x,y,slot)<0 then return 0
    If tmap(x,y).no<2 then return 0
    if tmap(x,y).gives>=69 and tmap(x,y).gives<=75 then return -1
    if tmap(x,y).gives=66 or tmap(x,y).gives=67 then return -1
    if tmap(x,y).gives=59 or tmap(x,y).gives=60 then return -1
    if tmap(x,y).gives=55 then return -1
    if tmap(x,y).gives>=44 and tmap(x,y).gives<=46 then return -1
    if tmap(x,y).gives>=13 and tmap(x,y).gives<=31 then return -1
    if tmap(x,y).gives>=4 and tmap(x,y).gives<=8 then return -1
    return 0
end function
    

function ep_planetmenu(entrycords as _cords,slot As Short,shipfire() As _shipfire,spawnmask() As _cords, lsp As Short,loctemp As Single) As _cords
    Dim As Short x,y,entry,launch,explore,a
    Dim As _cords mgcords(24),nextmap
    Dim As String text,Key
    'tScreen.set(1)
    text="Facilities"
    For x=0 To 60
        For y=0 To 20
            if gets_entry(x,y,slot)=-1 and entry<23 then
                entry+=1
                mgcords(entry).x=x
                mgcords(entry).y=y
                Select Case tmap(x,y).gives
                Case 4 To 8
                    text=text &"/Trading"
                Case 26
                    text=text &"/Store"
                Case 27
                    text=text &"/Bar"
                Case 28
                    text=text &"/Fuel & Ammo"
                Case 29
                    text=text &"/Repair ship"
                Case 30
                    text=text &"/Ship modules"
                Case 31
                    text=text &"/Hulls"
                Case 34
                    text=text &"/Shipweapons"
                Case 35
                    text=text &"/Shipyard"
                Case 42
                    text=text &"/Refits"
                Case 43
                    text=text &"/Sickbay"
                Case 44
                    text=text &"/Arena"
                Case 45
                    text=text &"/Casino"
                Case 46
                    text=text &"/Zoo"
                Case 47
                    text=text &"/Retirement"
                Case 48
                    text=text &"/Titles & Deeds"
                Case 49
                    text=text &"/Custom Items"
                Case 50
                    text=text &"/Administration"
                Case 59
                    text=text &"/Botbin"
                Case Else
                    text=text &"/"&tmap(x,y).desc
                End Select
            EndIf
        Next
    Next
    If entry>2 Then 'Not if there are only a few giving tiles.
        explore=entry+1
        launch=entry+2
        text=text &"/Explore area/Launch"
        Do
            a=textmenu(bg_shiptxt,text)
            Select Case a
            Case explore
            Case launch,-1
                nextmap.m=-1
            Case Else
                awayteam.c=mgcords(a)
                ep_gives(awayteam,nextmap,shipfire(),spawnmask(),lsp,Key,loctemp)
            End Select
        Loop Until a=-1 Or a=launch Or a=explore
        If a=explore Then awayteam.c=entrycords
    EndIf
    Return nextmap
End function


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tPlanetmenu -=-=-=-=-=-=-=-
	tModule.register("tPlanetmenu",@tPlanetmenu.init()) ',@tPlanetmenu.load(),@tPlanetmenu.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tPlanetmenu -=-=-=-=-=-=-=-
#endif'test
