'tCompany.
'
'namespace: tCompany

'
'
'defines:
'init=16, private pay_bonuses=0, company=50, private unload_s=0,
', private unload_f=0, merctrade=3, com_remove=4, shares_value=1,
', sellshares=0, getshares=0, buyshares=0, getsharetype=0, portfolio=0,
', dividend=0, cropstock=0, display_stock=0, stockmarket=0, trading=13
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
'     -=-=-=-=-=-=-=- TEST: tCompany -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test


namespace tCompany



#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Type _share
    company As Byte
    bought As UInteger
    lastpayed As UInteger
End Type

Type _company
    profit As Integer
    capital As Integer
    rate As Integer
    shares As Short
End Type

Type _company_bonus
    Base As UInteger
    Value As UInteger
    rank As UInteger
End Type
#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tCompany -=-=-=-=-=-=-=-
declare function company(st as short) as short
declare function com_remove(attacker() as _ship, t as short,flag as short=0) as short

declare function shares_value() as short
declare function trading(st as short) as short
declare function merctrade(byref f as _fleet) as short

Dim Shared combon(9) As _company_bonus
Dim Shared shares(2048) As _share
Dim Shared lastshare As Short

Dim Shared companystats(5) As _company

'private function tCompany
'private function tCompany
'private function private pay_bonuses(st as short) as short
'private function private unload_s(s as _ship,st as short) as _ship    
'private function private unload_f(f as _fleet, st as short) as _fleet
'private function sellshares(comp as short,n as short) as short
'private function getshares(comp as short) as short
'private function buyshares(comp as short,n as short) as short
'private function getsharetype() as short
'private function portfolio(x as short,y2 as short) as short
'private function dividend() as short
'private function cropstock() as short
'private function display_stock() as short
'private function stockmarket(st as short) as short
declare function unload_f(f as _fleet, st as short) as _fleet

declare function init(iAction as integer) as integer

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tCompany -=-=-=-=-=-=-=-

	
public function Init(iAction as integer) as integer
	dim a as Integer
    '
    combon(0).base=10 'Planets Landed on
    combon(1).base=5 'Aliens scanned
    combon(2).base=150 'Minerals turned in
    combon(3).base=5 'Only sells to Smith
    combon(4).base=5 'Only sells to Erdidani
    combon(5).base=5 'Only sells to Triax
    combon(6).base=5 'Only sells to omega
    combon(7).base=100 'Turns survived
    combon(8).base=5 'Pirate Ships destroyed
    '
    Dim d_company As _company
    For a=0 To 4
        companystats(a)=d_company
    Next
    '
    Dim d_share As _share
    For a=0 To 2047
        shares(a)=d_share
    Next
    '
    lastshare=0
    '
    dim c as _company
    for a=0 to 5
        c=companystats(a)
        c.capital=25000
        c.profit=0
        c.rate=0
        c.shares=50
    next
    '
	return 0
End Function



private function pay_bonuses(st as short) as short
    DimDebug(0)
    dim as uinteger a,tarval,c
    dim as single factor
    for a=0 to 3
        if reward(a)>0 then c=1
    next
    if ano_money>0 then c=1
    DbgPrint(c &":"& basis(st).company+2)
    if c=1 then combon(basis(st).company+2).value+=1
    combon(7).value=tVersion.gameturn/(7*24*60)
    for a=0 to 8
        if a<3 or a>6 then
            tarval=combon(a).base*(combon(a).rank+1)^2
            DbgPrint(tarval &":"& combon(a).value)
            if combon(a).value>=tarval and combon(c).rank<6 then
                combon(a).rank+=1
                factor=(combon(a).rank^2/2)*100
                If a=0 then rlprint "For exploring "&(combon(a).value) &" planets you receive a bonus of "&credits(int(combon(a).rank*factor)) &" Cr.",11
                If a=1 then rlprint "For recording biodata of "&credits(combon(a).value) &" aliens you receive a bonus of "&credits(int(combon(a).rank*factor)) &" Cr.",11
                If a=2 then rlprint "For delivering "&credits(cint(reward(2)*basis(st).resmod*haggle_("up"))) &" Cr. worth of resources you receive a bonus of "&int(combon(a).rank*factor) &" Cr.",11
                If a=7 and combon(a).rank>1 then rlprint "For continued exclusive business over "&(combon(a).value) &" weeks you receive a bonus of "&credits(int(combon(a).rank*factor)) &" Cr.",11
                If a=8 then rlprint "For destroying "&credits(combon(a).value) &" pirate ships you receive a bonus of "&int(combon(a).rank*factor) &" Cr.",11
                combon(a).value=0
                addmoney(int(combon(a).rank*factor),mt_bonus)
            endif
        endif
    next
    for a=3 to 6
        tarval=combon(a).base*(combon(a).rank+1)^2
        DbgPrint(tarval &":"& combon(a).value)
    next
    
    if combon(3).value>1 and combon(4).value=0 and combon(5).value=0 and combon(6).value=0 then c=3
    if combon(3).value=0 and combon(4).value>1 and combon(5).value=0 and combon(6).value=0 then c=4
    if combon(3).value=0 and combon(4).value=0 and combon(5).value>1 and combon(6).value=0 then c=5
    if combon(3).value=0 and combon(4).value=0 and combon(5).value=0 and combon(6).value>1 then c=6
    if c>0 then
        if c=basis(st).company+2 then
            tarval=combon(c).base*(combon(c).rank+1)^2
            if combon(c).value>=tarval and combon(c).rank<6 then
                 combon(c).rank+=1
                 factor=(combon(a).rank^2/2)*100
                 rlprint "For exclusively selling to " & companyname(basis(st).company) & " you receive a bonus of "& credits(int(combon(c).rank*100)) & "Cr.",15
                 addmoney(int(combon(c).rank*factor),mt_bonus)
           endif
        endif
    endif

    return 0
end function


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


private function unload_s(s as _ship,st as short) as _ship    
    dim as short a,b,c,d,e,f,t
    
    for a=1 to 25
        if s.cargo(a).x>1 then
            if st<=2 then companystats(basis(st).company).profit+=1
            t=s.cargo(a).x-1 'type of cargo
            basis(st).inv(t).v=basis(st).inv(t).v+1  
            s.cargo(a).x=1
            'rlprint "sold " &t
        endif
    next
    return s
end function

'

private function unload_f(f as _fleet, st as short) as _fleet
    dim as short a
    for a=1 to 15
        f.mem(a)=unload_s(f.mem(a),st)
    next
    return f
end function


public function merctrade(byref f as _fleet) as short
    dim as short st,a
    st=-1
    for a=0 to 2
        if f.c.x=basis(a).c.x and f.c.y=basis(a).c.y then st=a
    next
    if st<>-1 then
        if show_NPCs then rlprint "fleet is trading at "&st+1 &"."
        f=unload_f(f,st)
        f=load_f(f,st)
        f=refuel_f(f,st)
    endif
    return 0
end function


'
function com_remove(attacker() as _ship, t as short,flag as short=0) as short
    dim a as short
    if flag=0 then attacker(t)=unload_s(attacker(t),10)
    if attacker(a).bounty>0 then bountyquest(attacker(a).bounty).status=2
    for a=t to 14 'This works since 15 is empty
        attacker(a)=attacker(a+1)
    next
    return 0
end function


function shares_value() as short
    dim as short a,v
    for a=1 to lastshare
        if shares(a).company>=0 and shares(a).company<=5 then
            v+=companystats(shares(a).company).rate
        endif
    next
    return v
end function


function sellshares(comp as short,n as short) as short
    dim as short a,b,c
    for a=1 to lastshare
        if shares(a).company=comp and n>0 then
            companystats(shares(a).company).capital-=1
            addmoney(companystats(shares(a).company).rate,mt_trading)
            shares(a).company=-1
            companystats(comp).shares+=1
            n=n-1
        endif
    next
    if a>2048 then a=2048
    do
        if shares(a).company=-1 and lastshare>=0 then
            shares(a)=shares(lastshare)
            lastshare-=1
        else
            a+=1
        endif
    loop until a>lastshare or lastshare<=0
    if lastshare<0 then lastshare=0
    
    return 0
end function


function getshares(comp as short) as short
    dim as short r,a
    for a=0 to lastshare
        if shares(a).company=comp then r+=1
    next
    return r
end function


function buyshares(comp as short,n as short) as short
    dim a as short
    if companystats(comp).shares=0 then rlprint "No shares availiable for this company",14
    if lastshare+n>2048 then n=2048-lastshare
    if n>0 and companystats(comp).shares>0 then
        for a=1 to n
            if lastshare<2048+n and companystats(comp).shares>0 then
                lastshare=lastshare+1
                shares(lastshare).company=comp
                shares(lastshare).bought=tVersion.gameturn
                shares(lastshare).lastpayed=tVersion.gameturn
                companystats(comp).shares-=1
            endif
        next
    else
        n=0
    endif
    return n
end function

function getsharetype() as short
    dim n(4) as integer
    dim cn(4) as integer
    dim as short a,b
    dim text as string
    dim help as string
    for a=0 to lastshare
        if shares(a).company>0 and shares(a).company<=4 then
            n(shares(a).company)+=1
        endif
    next
    help="/"
    for a=1 to 4
        if n(a)>0 then
            b+=1
            cn(b)=a
            text=text &companyname(a) &" ("&n(a) &") - "&companystats(a).rate &"/"
            help=help &":"&a &":"&cn(b) &"/"
        endif
    next
    help=help & "/"
    b+=1
    if text<>"" then
        text="Company/"&text &"Exit"
        a=textmenu(bg_parent,text,"",2,2)
        if a>0 and a<b then 
            return cn(a)
        else
            return -1
        endif
    else
        rlprint "You don't own any shares to sell"
    endif
    return -1
end function


function portfolio(x as short,y2 as short) as short
    dim n(4) as integer
    dim as short a,y
    for a=0 to lastshare
        if shares(a).company>0 and shares(a).company<=4 then
            n(shares(a).company)+=1
        endif
    next
    locate y,x
    set__color( 15,0)
    draw string(x*_fw1,y2*_fh1), "Portfolio:",,font2,custom,@_col
    set__color( 11,0)
    y=1
    for a=1 to 4
        if n(a)>0 then 
            locate y,x
            draw string(x*_fw1,y2*_fh1+y*_fh2), companyname(a) &": "& n(a),,font2,custom,@_col
            y+=1
        endif
    next
    
    return 0
end function


function dividend() as short
    dim payout(4) as single
    dim a as short
    for a=0 to lastshare
        if shares(a).company>0 and shares(a).lastpayed<=tVersion.gameturn-3*30*24*60 then '3 months
            payout(shares(a).company)=payout(shares(a).company)+companystats(shares(a).company).rate/100
            shares(a).lastpayed=tVersion.gameturn
        endif
    next
    for a=1 to 4
        payout(0)=payout(0)+payout(a)
    next
    if payout(0)>1 then
        for a=1 to 4
            if payout(a)>0 then rlprint "Your share in "&companyname(a) &" has paid a dividend of "&int(payout(a)) &" Cr."
        next
        addmoney(int(payout(0)),mt_trading)
    endif
        
    return 0
end function


function cropstock() as short
    dim as short s,a
    
    for a=0 to 2
        if companystats(basis(a).company).profit>0 then
            if s=0 or companystats(basis(a).company).profit<s then s=companystats(basis(a).company).profit
        endif
    next
    s=s/2
    if s<1 then s=1
    for a=0 to 2
        if companystats(basis(a).company).profit>0 then
            companystats(basis(a).company).profit=companystats(basis(a).company).profit/s
        endif
    next
    return 0
end function


function display_stock() as short
    dim as short a,dis(4),cn(4),last
    set__color (15,0)
    draw string(2*_fw1,2*_fh1), "Company",,font2,custom,@_col
    draw string(2*_fw1+28*_fw2,2*_fh1), "Price",,font2,custom,@_col
    set__color( 11,0)
    for a=0 to 2
        set__color( 11,0)
        if dis(basis(a).company)=0 then
            last+=1
            cn(last)=basis(a).company
            draw string(2*_fw1,2*_fh1+last*_fh2), companyname(basis(a).company),,font2,custom,@_col
            draw string(2*_fw1+28*_fw2,2*_fh1+last*_fh2), ""&companystats(basis(a).company).rate,,font2,custom,@_col
        endif
        dis(basis(a).company)=1
    next
    return last
end function


function stockmarket(st as short) as short
    dim dis(4) as byte
    dim as short a,b,c,d,amount,last
    dim cn(5) as short
    dim text as string
    text="Company" &space(18) &"Price"
    For a=0 to 2
       if dis(basis(a).company)=0 then
            b+=1
            cn(b)=basis(a).company
            dis(basis(a).company)=1 
            text=text &"/"& companyname(basis(a).company)
            text=text &space(32-len(companyname(basis(a).company))-len(credits(companystats(basis(a).company).rate)))&credits(companystats(basis(a).company).rate) &" Cr."
        endif
    next
    
    do
        last=display_stock
        portfolio(2,17)
        a=textmenu(bg_stock,"/Buy/Sell/Exit","",2,12)
        if a=1 then
            b=textmenu(bg_parent,text &"/Exit",,2,2)
            if b>0 and b<last+1 then
                if cn(b)>0 then
                    rlprint "How many shares of "&companyname(cn(b))&" do you want to buy?"
                    amount=getnumber(0,99,0)
                    if amount>0 then
                        if paystuff(companystats(cn(b)).rate*amount) then
                            amount=buyshares(cn(b),amount)
                            companystats(cn(b)).capital=companystats(cn(b)).capital+amount
                        endif
                    endif
                endif
            endif
        endif
        if a=2 then
            set__color(11,0)
            cls
            display_ship
            b=getsharetype
            if b>0 then
                c=getshares(b)
                if c>99 then c=99
                rlprint "How many shares of "&companyname(b)&" do you want to sell? (max "&c &")"
                    
                d=getnumber(0,c,0)
                if d>0 then
                    sellshares(b,d)
                endif
            endif
        endif
    loop until a=3
    return 0
end function



function trading(st as short) as short
    dim a as short
    tScreen.set(1)
    check_tasty_pretty_cargo
    if st<3 then
        do
            set__color(11,0)
            a=textmenu(bg_trading+st," /Buy/Sell/Price development/Stock Market/Exit",,2,14)
            if a=1 then buygoods(st)
            if a=2 then sellgoods(st)
            if a=3 then showprices(st)
            if a=4 then stockmarket(st)
        loop until a=5
    else
        do
            set__color(11,0)
            if st<>10 then a=textmenu(bg_trading+st," /Buy/Sell/Exit",,2,14,,st)
            if st=10 then a=textmenu(bg_trading+st," /Plunder/Leave behind/Exit",,2,14)
            if a=1 then buygoods(st)
            if a=2 then sellgoods(st)
        loop until a=3
    endif
    set__color(11,0)
    cls
    return 0
end function

#endif'main
end namespace


#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tCompany -=-=-=-=-=-=-=-
	tModule.register("tCompany",@tCompany.init()) ',@tCompany.load(),@tCompany.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tCompany -=-=-=-=-=-=-=-
#endif'test

