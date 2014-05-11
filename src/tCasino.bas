'tCasino
declare function add_passenger(n as string,typ as short, price as short, bonus as short, target as short, ttime as short, gender as short) as short
declare function questguy_dialog(i as short) as short


function drawroulettetable() as short
    dim as short x,y,z
    dim coltable(36) as short
    coltable(0)=10
    coltable(1)=12
    coltable(2)=15
    coltable(3)=12
    coltable(4)=15
    coltable(5)=12
    coltable(6)=15
    coltable(7)=12
    coltable(8)=15
    coltable(9)=12
    coltable(10)=15
    coltable(11)=15
    coltable(12)=12
    coltable(13)=15
    coltable(14)=12
    coltable(15)=15
    coltable(16)=12
    coltable(17)=15
    coltable(18)=12
    coltable(19)=12
    coltable(20)=15
    coltable(21)=12
    coltable(22)=15
    coltable(23)=12
    coltable(24)=15
    coltable(25)=12
    coltable(26)=15
    coltable(27)=12
    coltable(28)=15
    coltable(29)=15
    coltable(30)=12
    coltable(31)=15
    coltable(32)=12
    coltable(33)=15
    coltable(34)=12
    coltable(35)=15
    coltable(36)=12

    z=0
    for y=1 to 12
        for x=1 to 3
            z=z+1
            locate y+2,x*3+45,0
            if coltable(z)=12 then
                set__color( 12,2)
            else
                set__color( 0,2)
            endif
            if z<10 then
                if x<3 then
                    draw string ((x*3+45)*_fw2,(y+2)*_fh2)," "&z &" ",,font2,custom,@_col
                else
                    draw string ((x*3+45)*_fw2,(y+2)*_fh2)," "&z,,font2,custom,@_col
                endif
            else
                if x<3 then
                    draw string ((x*3+45)*_fw2,(y+2)*_fh2),z &" ",,font2,custom,@_col
                else
                    draw string ((x*3+45)*_fw2,(y+2)*_fh2),""&z ,,font2,custom,@_col
                endif
            endif
        next
    next
    set__color( 15,0)
    return 0
end function


function casino(staked as short=0, st as short=-1) as short
    DimDebugL(0)
    dim as short a,b,c,d,e,f,pr,bet,num,fi,col,times,mbet,gpld,asst,x,y,z,t,price,bonus,passenger,i
    dim ba(3) as short
    dim localquestguy(lastquestguy+4) as short
    dim leave as short
    dim as uinteger mwon,mlos
    dim as integer result
    dim as string text,menustring
    dim p as _cords
    dim coltable(36) as short
    dim qgindex(15) as short
    dim as string randomgender
    if rnd_range(1,100)<50 then
        randomgender="he"
    else
        randomgender="her"
    endif
    
    coltable(0)=10
    coltable(1)=12
    coltable(2)=15
    coltable(3)=12
    coltable(4)=15
    coltable(5)=12
    coltable(6)=15
    coltable(7)=12
    coltable(8)=15
    coltable(9)=12
    coltable(10)=15
    coltable(11)=15
    coltable(12)=12
    coltable(13)=15
    coltable(14)=12
    coltable(15)=15
    coltable(16)=12
    coltable(17)=15
    coltable(18)=12
    coltable(19)=12
    coltable(20)=15
    coltable(21)=12
    coltable(22)=15
    coltable(23)=12
    coltable(24)=15
    coltable(25)=12
    coltable(26)=15
    coltable(27)=12
    coltable(28)=15
    coltable(29)=15
    coltable(30)=12
    coltable(31)=15
    coltable(32)=12
    coltable(33)=15
    coltable(34)=12
    coltable(35)=15
    coltable(36)=12
    if st=-1 then 'More passengers outside of stations
        passenger=-30
    else
        passenger=0
    endif
    bg_parent=bg_noflip
    
    tScreen.set(1)
    do
        menustring="Casino:/Play Roulette/Play Slot Machine/Play Poker/Have a drink/"
        leave=5
        for i=1 to lastquestguy
            if questguy(i).location=st then
                questguy(i).lastseen=st 'For the quest log
                localquestguy(leave)=i
#if __FB_DEBUG__
#endif
                if debug=1 then menustring=menustring &st &"(W:"&questguy(i).want.type &" M:" &questguy(i).want.motivation &")"
                menustring=menustring & questguyjob(questguy(i).job) &" "&questguy(i).n &"/"
                qgindex(leave)=i
                leave+=1
            endif
        next
        menustring=menustring &"Leave"
        cls
        display_ship(0)
        drawroulettetable()
        a=menu(bg_parent,menustring)
        if a=1 then
        do 
            drawroulettetable()
            b=menu(bg_roulette,"Roulette:/Bet on Number/Bet on Pair/Bet on Impair/Bet on Rouge/Bet on Noir/Don't play")
            if b<>6 then 
                drawroulettetable()
                if b=1 then 
                    rlprint "which number?"
                    fi=getnumber(1,36,18)
                endif
                if player.money>50+staked*50 then 
                    mbet=50+staked*50
                else
                    mbet=player.money
                endif
                rlprint "how much? (0-"& mbet &")"
                bet=getnumber(0,mbet,0)
                player.money=player.money-bet
                display_ship()
                if bet>0 then
                    changemoral(bet/3,0)
                    locate 14,25
                    rlprint "Rien Ne va plus "
                    for d=1 to rnd_range(1,6)+10
                        num=rnd_range(0,36)
                        col=coltable(num)
                        set__color( col,0)
                        Draw string (15*_fw1,10*_fh1)," "&num &" ",,font2,custom,@_col
                        sleep d*d*2
                    next
                    if staked=1 then
                        if gpld<10 then
                            if b=1 then num=fi
                            if b=2 and frac(num/2)<>0 then 
                                num=num+1
                                if num>36 then num=36
                            endif
                            if b=3 and frac(num/2)=0 then 
                                num=num+1
                            endif
                            if b=4 and coltable(num)=15 then
                               do 
                                   num=rnd_range(0,36)
                               loop until coltable(num)=12
                            endif
                            if b=5 and coltable(num)=12 then 
                                do 
                                   num=rnd_range(0,36)
                               loop until coltable(num)=15
                            endif
                        else
                            if b=1 and num=fi then num=num+1
                            if b=2 and frac(num/2)<>0 then 
                                num=num+1
                                if num>36 then num=36
                            endif
                            if b=3 and frac(num/2)<>0 then 
                                num=num+1
                            endif
                            if b=4 and coltable(num)=12 then
                               do 
                                   num=rnd_range(0,36)
                               loop until coltable(num)=15
                            endif
                            if b=5 and coltable(num)=15 then 
                                do 
                                   num=rnd_range(0,36)
                               loop until coltable(num)=12
                            endif
                        endif
                        col=coltable(num)
                        set__color( col,0)
                        Draw string (15*_fw1,10*_fh1)," "&num &" ",,font2,custom,@_col
                        sleep d*d*2
                    endif
                    if crew(1).talents(5)=1 then
                        if b=1 and fi<>num then num=rnd_range(0,36)
                        if b=2 and frac(num/2)<>0 then num=rnd_range(0,36)
                        if b=3 and frac(num/2)=0 then num=rnd_range(0,36)
                        if b=4 and coltable(num)=15 then num=rnd_range(0,36)
                        if b=5 and coltable(num)=12 then num=rnd_range(0,36)                        
                        col=coltable(num)
                        set__color( col,0)
                        Draw string (15*_fw1,10*_fh1)," "&num &" ",,font2,custom,@_col
                        sleep d*d*2
                    endif
                    times=0
                    if num=0 then rlprint "Bank wins"
                    if b=1 and fi=num then times=35
                    if b=2 and frac(num/2)=0 then times=2
                    if b=3 and frac(num/2)<>0 then times=2
                    if b=4 and coltable(num)=12 then times=2
                    if b=5 and coltable(num)=15 then times=2
                    if times>0 then
                        rlprint "you win " & credits(bet*times) & " Credits!"
                        addmoney(bet*times,mt_gambling)
                        mwon=mwon+bet*times
                    else
                        rlprint "You lose"
                        mlos=mlos+bet
                    endif
                    gpld=gpld+1
                endif
                
            endif
            display_ship
            drawroulettetable()
            if b=6 and staked=1 then
                drawroulettetable()
                if gpld<3 or mwon>mlos then 
                    if asst<5 then
                        rlprint "cmon, play another one"
                        b=0
                        asst=asst+1
                    endif
                else
                    if askyn("I am sure your luck will return! do you really want to leave?(y/n)") then
                       b=6
                       gpld=2
                    else
                        rlprint "good decision!"
                        b=0
                    endif
                endif
            endif
            loop until b=6
        endif
        if a=2 then play_slot_machine
        if a=3 then play_poker(st)
        if a=4 then
            drawroulettetable()
            if not paystuff(1) then                 
                rlprint "you can't even afford a drink."
                if rnd_range(1,100)<20 and player.money>=-4 then 
                    rlprint "The barkeep has pity and hands you 5 credits to bet at the roulette table."
                    player.money+=5
                endif
            else
                rlprint "you have a drink."
                changemoral(1,0)
            endif
            if rnd_range(1,100)<25-passenger then 'Passenger
                b=rnd_range(0,2)
                passenger+=rnd_range(5,25)
                if b<>st then
                    t=tVersion.gameturn+(rnd_range(15,25)/10)*distance(player.c,basis(b).c)
                    price=distance(player.c,basis(b).c)*rnd_range(1,20)
                    bonus=rnd_range(1,15)
                    if askyn("A passenger needs to get to space station "& b+1 &" by "& display_time(t) &". He offers you "&price &" Cr, and a "& bonus &" Cr. Bonus for every day you arrive there earlier. Do you want to take him with you?(y/n)") then
                        add_passenger("Passenger for S-"& b+1,30,price,bonus,b+1,t,0)
                    endif
                endif
            endif
            if rnd_range(1,100)<66 and player.money>=0 then
                if BonesFlag>0 and planets(Bonesflag).visited=0 then
                    b=rnd_range(1,45)
                    if rnd_range(1,30)<100 then b=1001
                else
                    b=rnd_range(1,45)
                endif
                c=rnd_range(0,2)
                d=rnd_range(1,5)
                if faction(0).war(1)>50 or income(mt_trading)/player.money>0.5 then 
                    if basis(st).spy=0 and rnd_range(1,100)<25 and st>-1 then b=100
                    if income(mt_trading)=0 and faction(0).war(1)<51 then b=rnd_range(1,39)
                endif
                p=fleet(rnd_range(1,lastfleet)).c
                if p.x=0 and p.y=0 then p=rnd_point
                if b=16 and rnd_range(1,100)<66 then p=map(piratebase(rnd_range(0,_NoPB))).c
                if b=1 then rlprint "An old miner tells you a tall tale about a planet he worked on. Short version: they dug too deep and released invisible monsters that drove them off the planet."
                if b=2 then rlprint "Another prospector tells you that he used ground radar to locate the ruins of an alien temple. Unfortunately the weather on the planet was so harsh his crew muntinied and demanded to return to the station immediately."
                if b=3 then rlprint "A merchant captain claims to have outrun the infamous 'Anne Bonny' at coordinates "&cords(p)&"."
                if b=4 then rlprint "A patrol captain claims to have shot down the infamous 'Anne Bonny' at coordinates "&cords(p)&"."
                if b=5 then rlprint "Your science officer finds no drinks he hasnt seen yet."
                if b=6 then rlprint "Your pilot wants to leave."
                if b=7 then rlprint "Your gunner thinks the owners could put up a dartboard here for practice."
                if b=8 then rlprint "A lone drunk informs you that the roulette wheel is rigged! He then asks you to buy him a drink."
                if b=9 then rlprint "A scoutship captain claims to have found a lutetium deposit at coordinates "&rnd_range(1,59) &":" &rnd_range(1,19) &" that was too large to load into his ship."
                if b=10 then rlprint "A security team member tells you a tall tale about fighting alien robots in an ancient city ruin 'They aren't gone. they are sleeping is what i say!'"
                if b=11 then rlprint "Another prospector and a patrol ship captain are discussing an incident on a planet at coordinates "&rnd_range(1,59) &":" &rnd_range(1,19) &". Two freelance prospectors had landed on it at the same time and got into a dispute over a palladium deposit. The patrol captain remarks that 'those guys should be taught a lesson'" 
                if b=12 then rlprint "A young man shows pictures of his brother. He was last seen on Station "&rnd_range(1,3)&", leaving with a scoutship, and hasn't returned."
                if b=13 then rlprint "you get told that the weather in the stations hydroponic garden was remarkably pleasant lately!"
                if b=14 then rlprint "you learn that the view from port E on the 5th ring of the station is spectacular"
                if b=15 then rlprint "You hear a story about an ancient robot ship prowling the sector, attacking everything on sight. The Anne Bonny is said to have escaped it once. Everything else is destroyed."
                if b=16 then rlprint "A patrolboat captain claims to have fought a big pirate fleet at coordinates "&cords(p) &"."
                if b=17 then rlprint "A light transport captain claims in a discussion on traderoutes that the average price for  "& goodsname(1) &" is "&avgprice(1) &"."
                if b=18 then rlprint "A Merchantman captain claims in a discussion on traderoutes that the average price for  "& goodsname(2) &" is "&avgprice(2) &"."
                if b=19 then rlprint "A heavy transport captain claims in a discussion on traderoutes that the average price for  "& goodsname(3) &" is "&avgprice(3) &"."
                if b=20 then rlprint "A Merchantman captain claims in a discussion on traderoutes that the average price for  "& goodsname(4) &" is "&avgprice(4) &"."
                if b=21 then rlprint "A armed merchantman captain claims in a discussion on traderoutes that the average price for  "& goodsname(5) &" is "&avgprice(5) &"."
                if b=22 and st<>c then rlprint "In a discussion about traderoutes a heavy transport captain claims that at station "& c+1 &" the price for  "& goodsname(d) &" is "& basis(c).inv(d).p &"."
                if b=23 and st<>c then rlprint "In a discussion about traderoutes a light transport captain claims that at station "& c+1 &" the price for  "& goodsname(d) &" is "& basis(c).inv(d).p &"."
                if b=24 and st<>c then rlprint "In a discussion about traderoutes a merchantman captain claims that at station "& c+1 &" the there is a  "& basis(c).inv(d).v &" ton stock of "& goodsname(d) &"."
                if b=25 and st<>c then rlprint "In a discussion about traderoutes a armed merchantman captain claims that at station "& c+1 &" the there is a  "& basis(c).inv(d).v &" ton stock of "& goodsname(d) &"."
                if b=26 then rlprint "Another prospector tells you that there is a rumor about a planet whith immortal inhabitants."
                if b=27 then rlprint "A science officer tells you that most animals on earth live for about 5 million heartbeats. 'Life expectancy is mainly a function of metabolism. A mouse just uses them up a little faster than an elephant.'"
                if b=28 then rlprint "A scout captain tells you that he went refueling on a gas giant when his sensors picked up a huge metallic structure. He decided discretion was the better part of valor and left, barely making it back to base."
                if b=29 then
                    'Merchant captain selling data
                    c=rnd_range(0,3)
                    d=c+1
                    if d>3 then d=1
                    if d<c then swap d,c
                    ba(0)=10
                    for e=10 to lastwaypoint
                        if targetlist(e).x=basis(0).c.x and targetlist(e).y=basis(0).c.y then ba(1)=e 
                        if targetlist(e).x=basis(1).c.x and targetlist(e).y=basis(1).c.y then ba(2)=e 
                        if targetlist(e).x=basis(2).c.x and targetlist(e).y=basis(2).c.y then ba(3)=e 
                    next
                    pr=abs(ba(d)-ba(c))
                    if c=0 then 
                        text="A merchant captain offers to sell sensor data from his trip form earth to station 1 for " &pr &" Credits."
                    else
                        text="A merchant captain offers to sell sensor data from his trip form station "&c &" to station "&d &" for " &pr &" Credits."
                    endif
                    ba(0)=10
                    if askyn(text &"(y/n)") then
                        if paystuff(pr) then
                            rlprint "The merchant captain hands you a data crystal."
                            for e=ba(c) to ba(d)
                                for x=targetlist(e).x-1 to targetlist(e).x+1
                                    for y=targetlist(e).y-1 to targetlist(e).y+1
                                        if x>=0 and y>=0 and x<=sm_x and y<=sm_y then
                                            if spacemap(x,y)=0 then
                                                spacemap(x,y)=1
                                            else
                                                spacemap(x,y)=abs(spacemap(x,y))
                                            endif
                                            for f=0 to laststar
                                                if map(f).c.x=x and map(f).c.y=y then map(f).discovered=1
                                            next
                                        endif
                                    next
                                next
                            next
                        endif
                    endif
                endif
                if b=30 then
                    c=sysfrommap(specialplanet(13))
                    rlprint "A frequent patron tells you that Murchesons ditch is at coordinates "&cords(map(c).c)&"."
                endif
                if b=31 then
                    c=sysfrommap(specialplanet(10))
                    rlprint "A scout pilot tells you that there is an independent colony at coordinates "&cords(map(c).c)&"."
                endif
                if b=32 then
                    c=sysfrommap(specialplanet(14))
                    rlprint "A well doing merchant tells you that he bought his armed merchantman class ship in a system at coordinates "&cords(map(c).c)&"."
                endif
                if b=34 then
                    c=sysfrommap(specialplanet(27))
                    rlprint "A scout pilot claims that nobody has ever returned from exploring a system at coordinates "& cords(map(c).c) &"."
                endif
                if b=35 then
                    c=sysfrommap(specialplanet(39))
                    rlprint "A merchant says he buys all his grain at coordinates "&cords(map(c).c) &"."
                endif
                if b=36 or b=37 or b=38 or b=39 then
                    rlprint "A scout ship captain tells a tale about how he got chased back to his ship by hostile aliens, but then had the genius idea to order his ship by radio to fire it's ship weapons at them, with devastating results!"
                endif
                
                if b=40 or b=41 then
                    rlprint "A cruiser captain recounts a battle against a pirate fleet, that was going badly, until he managed to force his opponents into his plasma stream, destroying their ships."
                endif
                
                if b=42 then rlprint "Somebody tells you that the leader of the pirates is choosen in a spaceship duel."
                
                
                if b=44 then rlprint "A merchant captain proclaims: 'If you want to avoid pirate attacks, just fly a triax traders flag!' " &first_uc(randomgender) & " is pretty drunk and refuses to elaborate."
                
                if b=1001 then rlprint "An explorer captain tells a funny story about a captain "& randomgender &" knew, who didn't return from an expedition to a system at "&cords(map(bonesflag).c) &"."

                if b=100 then 
                    if faction(0).war(1)>50 then
                        if askyn ("A seedy looking indivdual approaches you. 'If you are interested I could keep you informed about what the merchants are loading. What do you say? 100 Cr. each time you come here?'(y/n)") then
                            factionadd(0,1,-1)
                            basis(st).spy=1 
                            rlprint "'Deal then. Of course we never had this conversation'"
                        else
                            rlprint "He says: 'I must have mistaken you for someone else. I apologize' and dissapears in the crowd."
                            factionadd(0,1,1)
                        endif
                    else
                        if askyn ("A seedy looking indivdual comes up to you. 'If you are interested i could see to it that the pirates don't get information about your cargo. what do you say? 100 Cr. each time you come here?'(y/n)") then
                            factionadd(0,1,-1)
                            basis(st).spy=2 
                            rlprint "'Deal then. Of course we never had this conversation'"
                        else
                            rlprint "He says: 'I must have mistaken you for someone else. I apologize' and dissapears in the crowd."
                            factionadd(0,1,+1)
                        endif
                    endif
                endif
           endif
        endif
        display_ship
        drawroulettetable()
        if a>=5 and a<leave then questguy_dialog(qgindex(a))
    loop until a=leave or a=-1
    set__color(11,0)
    cls
    result =mwon-mlos
    if result>30000 then result=30000
    return mwon-mlos
end function
