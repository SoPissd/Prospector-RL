'tCompany

function company(st as short) as short
    DimDebugL(0)
    dim as short b,c,q,complete
    dim m as integer
    dim as single a
    dim as string s
    dim towed as _ship
    dim p as _cords
    display_ship(0)
    m=player.money
    if configflag(con_autosale)=0 then q=-1
    rlprint "you enter the company office"                    
    reward_bountyquest(0)
    if player.questflag(1)=1 then
        if basis(st).repname="Omega Bioengineering" then
            a=25000
        else
            a=15000
        endif
        if askyn("The Rep offers to buy your data on the ancients pets for "&credits(a) &" Cr. Do you accept?(y/n)") then
            addmoney(a,mt_artifacts)
            player.questflag(1)=2
            if a=25000 then player.questflag(1)=3
        endif
        a=0
    endif
    if player.questflag(2)=2 then
        rlprint "The Company Rep congratulates you on a job well done and pays you 15,000 Cr.",10
        factionadd(0,1,-15)
        addmoney(15000,mt_quest)
        player.questflag(2)=4
    endif
    if player.questflag(2)=3 then
        rlprint "The Company Rep congratulates you on a job well done and pays you 10,000 Cr.",10
        factionadd(0,1,-15)
        addmoney(10000,mt_quest)
        player.questflag(2)=4
    endif
    if player.questflag(3)=1 then
        rlprint "After some negotiations you convince the company rep to buy the secret of controling the alien ships for ... 1,000,000 CR!",10
        factionadd(0,1,-15)
        addmoney(1000000,mt_artifacts)
        player.questflag(3)=2
    endif
    if player.questflag(5)=2 then
        rlprint "The Company Rep congratulates you on a job well done and pays you 15,000 Cr.",10
        factionadd(0,1,-15)
        addmoney(15000,mt_quest)
        player.questflag(5)=3
    endif 
    if player.questflag(6)=2 then
        rlprint "The Company Rep congratulates you on a job well done and pays you 15,000 Cr.",10
        factionadd(0,1,-15)
        addmoney(15000,mt_quest)
        player.questflag(6)=3
    endif
    if player.questflag(7)>0 and basis(st).company=1 and planets(player.questflag(7)).flags(21)=1 then
        addmoney(1000,mt_map)
        factionadd(0,1,-15)
        rlprint "The company rep pays your 1,000 Cr. contract for mapping the planet",10
        player.questflag(7)=0
    endif
    if player.questflag(9)=2 and basis(st).company=2 then 
        addmoney(5000,mt_artifacts)
        factionadd(0,1,-15)
        rlprint "The company rep pays your 5,000 Cr. contract for finding a robot factory.",10
        player.questflag(9)=3
    endif
    if player.questflag(10)<0 and basis(st).company=4 then
        addmoney(2500,mt_quest)
        factionadd(0,1,-15)
        rlprint "The company rep pays you 2,500 Cr. for finding a planet to conduct their experiment on.",10
        planetmap(rnd_range(0,60),rnd_range(0,20),abs(player.questflag(10)))=16
        player.questflag(10)=0
    endif
    if player.questflag(11)=2 then 
        addmoney(5000,mt_quest)
        factionadd(0,1,-15)
        rlprint "The company rep remarks that these crystal creatures could be a threat to colonizing this sector and pays you your reward of 5,000 Cr.",10
        player.questflag(11)=3
    endif
    if player.questflag(12)=0 and checkcomplex(specialplanet(33),1)=4 then 
        player.questflag(12)=1
        factionadd(0,1,-15)
        addmoney(10000,mt_quest)
        rlprint "The company rep pays you 10,000 Cr. for destroying the pirates asteroid hideout.",10
    endif
    
    if player.questflag(15)=2 then 
        player.questflag(15)=3
        factionadd(0,1,-15)
        addmoney(10000,mt_pirates)
        rlprint "The company rep pays you 10,000 Cr. for destroying the pirate Battleship 'Anne Bonny'.",10
    endif
    
    if player.questflag(16)=2 then 
        player.questflag(16)=3
        factionadd(0,1,-15)
        addmoney(8000,mt_pirates)
        rlprint "The company rep pays you 8,000 Cr. for destroying the pirate Destroyer 'Black corsair'.",10
    endif
    
    if player.questflag(17)=2 then 
        player.questflag(17)=3
        factionadd(0,1,-15)
        addmoney(5000,mt_pirates)
        rlprint "The company rep pays you 5,000 Cr. for destroying the pirate Cruiser 'Hussar'.",10
    endif
    
    if player.questflag(18)=2 then 
        player.questflag(18)=3
        factionadd(0,1,-15)
        addmoney(2500,mt_pirates)
        rlprint "The company rep pays you 2,500 Cr. for destroying the pirate fighter 'Adder'.",10
    endif
    
    if player.questflag(19)=2 then 
        player.questflag(19)=3
        factionadd(0,1,-15)
        addmoney(2500,mt_pirates)
        rlprint "The company rep pays you 2,500 Cr. for destroying the pirate fighter 'Widow'.",10
    endif
    
    for a=0 to lastitem
        if item(a).w.s=-1 and item(a).ty=47 and item(a).v1>1 then 
            if item(a).v2=0 then
                rlprint "The relatives of the spacer who's ID-tag you found put a reward of " & credits(item(a).v1*20) &" credits on any information on his wereabouts."
                addmoney(item(a).v1*20,mt_quest)
            else
                rlprint "At least now we know. Here is your reward."
                addmoney(500,mt_quest)
                player.questflag(26)=0
            endif
            destroyitem(a)
        endif
    next
    
    if player.questflag(21)=1 then
        if basis(st).company=1 then
            if askyn("Do you want to blackmail Eridiani Explorations with your information on their Drug business?(y/n)") then
                factionadd(0,1,1)
                addmoney(1000,mt_blackmail)
                companystats(1).capital=companystats(1).capital-rnd_range(1,100)
                rlprint "The Rep pays 1,000 Cr. for your Silence"
            endif
        else
            if askyn("Do you want to sell "&companyname(basis(st).company) &" the secret of Eridiani Explorations Drug business?(y/n)") then
                rlprint "The Rep pays 10,000 Cr. for your the information"
                companystats(1).capital=companystats(1).capital-15000
                if companystats(1).capital<0 then companystats(1).capital=0
                player.questflag(21)=2
                addmoney(10000,mt_blackmail)
            endif
        endif
    endif
    
    
    if player.questflag(22)=1 then
        if basis(st).company=2 then
            if askyn("Do you want to blackmail Smith Heavy Industries with your information on their slave work?(y/n)") then
                factionadd(0,1,1)
                addmoney(1000,mt_blackmail)
                companystats(2).capital=companystats(2).capital-rnd_range(1,100)
                rlprint "The Rep pays 1,000 Cr. for your Silence"
            endif
        else
            if askyn("Do you want to sell "&companyname(basis(st).company) &" the secret of Smith Heavy Industries slave business?(y/n)") then
                rlprint "The Rep pays 10,000 Cr. for your the information"
                companystats(2).capital=companystats(2).capital-15000
                if companystats(2).capital<0 then companystats(2).capital=0
                player.questflag(22)=2
                addmoney(10000,mt_blackmail)
            endif
        endif
    endif
    
    if player.questflag(23)=2 then
        if basis(st).company=3 then
            if askyn("Do you want to blackmail Triax Traders with your information on their agreement with pirates?(y/n)") then
                factionadd(0,1,1)
                addmoney(1000,mt_blackmail)
                companystats(3).capital=companystats(3).capital-rnd_range(1,100)
                rlprint "The Rep pays 1,000 Cr. for your Silence"
            endif
        else
            if askyn("Do you want to sell "&companyname(basis(st).company) &" your information on Triax Traders agreement with pirates?(y/n)") then
                rlprint "The Rep pays 10,000 Cr. for your the information"
                companystats(3).capital=companystats(3).capital-15000
                if companystats(3).capital<0 then companystats(3).capital=0
                player.questflag(23)=3
                addmoney(10000,mt_blackmail)
            endif
        endif
    endif
    
    if player.questflag(24)=1 then
        if basis(st).company=4 then
            if askyn("Do you want to blackmail Omega Bioengineering with your information on their experiments?(y/n)") then
                factionadd(0,1,1)
                addmoney(1000,mt_blackmail)
                companystats(4).capital=companystats(4).capital-rnd_range(1,100)
                rlprint "The Rep pays 1,000 Cr. for your Silence"
            endif
        else
            if askyn("Do you want to sell "&companyname(basis(st).company) &" the secret of Omega Bioengineerings experiments?(y/n)") then
                rlprint "The Rep pays 10,000 Cr. for your the information"
                companystats(4).capital=companystats(4).capital-15000
                if companystats(4).capital<0 then companystats(4).capital=0
                player.questflag(24)=2
                addmoney(10000,mt_blackmail)
            endif
        endif
    endif
    
    if specialflag(31)=1 then
        if askyn("The company rep is fascinated about your report on the ancient space station in the asteroid belt. He offers you 75,000 Credits for the coordinates. Do you accept?(y/n)") then
            addmoney(75000,mt_quest)
            a=sysfrommap(specialplanet(31))
            factionadd(0,1,-25)
            basis(4)=makecorp(0)
            basis(4).discovered=1
            basis(4).c=map(a).c
            fleet(5).c=map(a).c
            for b=1 to 9
                if map(a).planets(b)=specialplanet(31) then map(a).planets(b)=-rnd_range(1,8)
            next
            specialflag(31)=2
        endif
    endif 
    
    if artflag(21)=1 then
        if askyn("The company is highly interested in buying the specs on neutronium hulls. They offer 10.000 Cr.(y/n)") then 
            artflag(21)=2
            addmoney(10000,mt_artifacts)
        endif
    endif
    
    if artflag(22)=1 then
        if askyn("The company is highly interested in buying this new technology for quantum warheads. Do you want to sell it for 10.000 Cr.? (y/n)") then
            artflag(22)=2
            addmoney(10000,mt_artifacts)
        endif
    endif
    
    if findbest(24,-1)>0 then
        b=findbest(24,-1)
        if item(b).v5 mod 10=0 then
            rlprint "The company Rep is highly interested in buying that portable nanobot factory. He offers you "&credits((50000+100*item(b).v5)*basis(st).biomod) &" credits."
            if askyn("Accept(y/n)") then
                factionadd(0,1,-35)
                addmoney((50000+100*item(b).v5)*basis(st).biomod,mt_artifacts)
                destroyitem(findbest(24,-1))
            else
                rlprint "The offer stands."
            endif
        else
            item(b).v5+=1
            if item(b).v5>500 then item(b).v5=491
        endif
    endif    
    
    if findbest(87,-1)>0 and basis(st).company=4 then
        if askyn("The company rep would buy the burrowers eggsacks for 100 Credits a piece. Do you want to sell?(y/n)") then
            for a=0 to lastitem
                if item(a).ty=87 and item(a).w.s=-1 then 
                    destroyitem(a)
                    addmoney(100,mt_bio)
                endif
            next
        endif
    endif
    
    if basis(st).company=2 then
        c=0
        for a=1 to lastplanet
            if planets(a).flags(23)=2 then c=a
        next
        if c>0 then
            rlprint "Thanks for helping wiping out those pirates!"
            planets(c).flags(23)=3
            addmoney(2500,mt_pirates)
        endif
    endif
    if player.towed<>0 then
        if player.towed>0 then
            towed=gethullspecs(drifting(player.towed).s,"data/ships.csv")
            a=towed.h_price
            if planets(drifting(player.towed).m).genozide<>1 then a=a/2
            a=a/2
            a=int(a)
            if planets(drifting(player.towed).m).mon_template(0).made<>32 then
                if askyn ("the company offers you "& credits(a) &" Cr. for the "&towed.h_desig &" you have in tow. Do you accept?(y/n)") then
                    drifting(player.towed)=drifting(lastdrifting)
                    lastdrifting-=1
                    addmoney(a,mt_towed)
                    player.towed=0
                endif
            else
                a=disnbase(drifting(player.towed).start)
                a=int(a*100)
                rlprint "The company pays you "&credits(a) &" Cr. for towing in the ship."
                drifting(player.towed)=drifting(lastdrifting)
                lastdrifting-=1
                addmoney(a,mt_towed)
                player.towed=0
            endif
        endif
        a=0
    endif
            
    c=0
    for b=0 to 4
        c=c+reward(b)
    next
    c=c+ano_money
    if c=0 then 
        rlprint "You have nothing to sell to "& basis(st).repname
    else
        companystats(basis(st).company).profit=companystats(basis(st).company).profit+1
        rlprint basis(st).repname &":"
        factionadd(1,0,1)
    endif
    
    if questroll<33 or debug then questroll=give_quest(st)    
    
    pay_bonuses(st)
    
    if reward(0)>1 then
        if configflag(con_autosale)=1 then q=askyn("do you want to sell map data? (y/n)")
        for a=0 to laststar
            for b=1 to 9
                if map(a).planets(b)>0 then
                    if planets(map(a).planets(b)).flags(21)=1 then
                        complete+=1
                        planets(map(a).planets(b)).flags(21)=2
                    endif
                endif
            next
        next
        if q=-1 and basis(st).repname="Eridiani Explorations" then
            if complete>1 then rlprint "Eridiani explorations pays "&credits(complete*50) &" Cr. for the complete maps of "&complete &"planets"
            if complete=1 then rlprint "Eridiani explorations pays "&credits(complete*50) &" Cr. for the complete map of a planet"
            addmoney(complete*50,mt_map)
        endif
        
        if q=-1 then
            if cint((reward(7)/15)*basis(st).mapmod*haggle_("up"))>0 then
                rlprint "you transfer new map data on "&reward(0)&" km2. you get paid "&credits(cint((reward(7)/15)*basis(st).mapmod*haggle_("up")))&" Cr."
                addmoney(cint((reward(7)/15)*basis(st).mapmod*haggle_("up")),mt_map)
            endif
            reward(0)=0
            reward(7)=0
        endif
    endif
    
    if reward(1)>0 then
        if configflag(con_autosale)=1 then q=askyn("do you want to sell bio data? (y/n)")
        if q=-1 then
            if lastcagedmonster=0 then
                rlprint "you transfer data on alien lifeforms worth "& credits(cint(reward(1)*basis(st).biomod*(1+0.1*crew(1).talents(2)))) &" Cr."
            else
                rlprint "you transfer data on alien lifeforms and " &lastcagedmonster & " live specimen worth "& credits(cint(reward(1)*basis(st).biomod*(1+0.1*crew(1).talents(2)))) &" Cr."
            endif
            addmoney((reward(1)*basis(st).biomod*haggle_("up")),mt_bio)
            reward(1)=0
            lastcagedmonster=0
            for a=0 to lastitem
                if item(a).ty=26 and item(a).w.s<0 then 
                    item(a).v1=0 'Empty cages
                    item(a).ldesc="For trapping wild animals. Just place it on the ground and wait for an animal to wander into it. Contains:"
                endif
                if item(a).ty=29 and item(a).w.s<0 then item(a).v1=0
            next
        endif
    endif
    if reward(2)>0 then
        if configflag(con_autosale)=1 then q=askyn("do you want to sell resources? (y/n)")
        if q=-1 then
            rlprint "you transfer resources for "& credits(cint(reward(2)*basis(st).resmod*(1+0.1*crew(1).talents(2)))) &" Cr."
            addmoney(cint(reward(2)*basis(st).resmod*(1+0.1*crew(1).talents(2))),mt_ress)
            reward(2)=0
            destroy_all_items_at(15,-1)
        endif
    endif
    reward_patrolquest()    
    if reward(3)>0 then
        if configflag(con_autosale)=1 then q=askyn("do you want to collect your bounty for destroyed pirate ships? (y/n)")
        if q=-1 then
            rlprint "You recieve "&credits(cint(reward(3)*basis(st).pirmod*(1+0.1*crew(1).talents(2)))) &" Cr. as bounty for destroyed pirate ships."
            addmoney(cint(reward(3)*basis(st).pirmod*(1+0.1*crew(1).talents(2))),mt_pirates)
            reward(3)=0
        endif
    endif
    if ano_money>0 then
        if configflag(con_autosale)=1 then q=askyn("do you want to sell your information on wormholes and anomalies? (y/n)")
        if q=-1 then
            if basis(st).company=3 then ano_money=cint(ano_money*1.5)
            rlprint "You recieve "&credits(ano_money) &" credits for your information on wormholes and anomalies."
            addmoney(ano_money,mt_ano)
            ano_money=0
        endif
    endif
    if reward(4)>0 then
        if configflag(con_autosale)=1 then q=askyn("do you want to sell your artifacts? (y/n)")
        if q=-1 then
            m=0
            for a=1 to reward(4) 
                m+=(rnd_range(1,3)+rnd_range(1,3))*1000
            next
            if m<0 then m=2147483647
            rlprint basis(st).repname &" pays " &credits(m) &" credits for the alien curiosity"
            addmoney(m,mt_artifacts)
            reward(4)=0
        endif
    endif
    if reward(6)>1 then
        rlprint "The Company pays you 50,000 Cr. for eliminating the pirate threat in this sector!"
        addmoney(50000,mt_pirates)
        reward(6)=-1
    endif
    if reward(8)>0 then
        rlprint "The Company pays "&credits(reward(8)) &" Cr. for destroying pirate outposts"
        addmoney(reward(8),mt_pirates)
        reward(8)=0
    endif
    
    ask_alliance(1)
    
    rlprint "you leave the company office"
    if m<0 and player.money>0 then factionadd(0,1,-1)
    return 0
end function


