Declare function reward_bountyquest(employer as short) as short
Declare function give_quest(st as short) as short

'

private function load_s(s as _ship, good as short, st as short) as short
    dim as short bay,result,a
    for a=1 to 25
        if s.cargo(a).x=1 and bay=0 then bay=a
    next
    if bay=0 then result=-1
    if bay>0 then
        result=bay
        basis(st).inv(good).v=basis(st).inv(good).v-1
        s.cargo(bay).x=s.cargo(bay).x+good
        'rlprint "bought " &good &" stored in "& bay &" Inv:"& basis(st).inv(good).v 
    endif
    return result
end function

private function load_f(f as _fleet, st as short) as _fleet
    dim as short curship,curgood,buylevel,vol,suc,a
    dim loaded(8) as short
    dim text as string
    buylevel=11
    do
        vol=0
        for a=1 to 5
            vol=vol+basis(st).inv(a).v
        next
        if vol>0 then
            for a=1 to 8
                if basis(st).inv(a).v>buylevel and curship<16 then
                    do 
                        suc=load_s(f.mem(curship),a,st)
                        if suc=-1 then 
                            curship=curship+1
                        else
                            'save what was loaded
                            loaded(a)=loaded(a)+1
                        endif
                    loop until suc<>-1 or curship>=15
                endif
            next
        endif
        buylevel=buylevel-1
    loop until vol<5 or buylevel<3 or curship>=15
    if basis(st).spy=1 then
        for a=1 to 4
            if loaded(a)>0 then text=text & loaded(a) &" tons of "& goodsname(a)
            if loaded(a)>0 and loaded(a+1)>0 then text=text &", "
        next
        if loaded(5)>0 then text=text & loaded(a) &" tons of "& goodsname(a) &"."
        if player.landed.m=0 then rlprint "We have a transmission from station "&st+1 &". A trader just left with "&text &".",15    
    endif
    
    return f
end function

private function refuel_f(f as _fleet, st as short) as _fleet
    'Refuels a fleet at a space station
    dim as short demand,ships,a
    for a=0 to 15
        if f.mem(a).hull>0 then ships+=1
    next
    demand=cint(f.fuel*ships/30)
    basis(st).inv(9).v-=demand
    if basis(st).inv(9).v<0 then basis(st).inv(9).v=0
    DbgPrint(ships &" ships refueling "&demand &" fuel, on base " & basis(st).inv(9).v)
    f.fuel=0
    return f
end function

   
    

private function refuel(st as short,price as single) as short
    dim as single refueled,b,totammo
    player.fuel=fix(Player.fuel)
    refueled=player.fuelmax+player.fuelpod-player.fuel
    if refueled>0 and player.money>0 then
        if cint(refueled*price)>player.money then refueled=fix(player.money/price)
        player.money-=cint(refueled*price)
        player.fuel+=cint(refueled)
        rlprint "Your fill your tanks."
    else
        if refueled=0 then
            rlprint "Your tanks are full."
        else
            rlprint "You have no money."
        endif
    endif
    totammo=missing_ammo
    if totammo*((player.loadout+1)^2)>player.money then totammo=fix(player.money/((player.loadout+1)^2))
    if totammo>0 and player.money>0 then
        do
            for b=1 to 10
                if player.weapons(b).ammo<player.weapons(b).ammomax and totammo>0 and player.money>=(player.loadout+1)^2 then
                    player.money-=(player.loadout+1)^2
                    player.weapons(b).ammo+=1
                    totammo-=1
                endif
            next
        loop until totammo=0 or player.money<(player.loadout+1)^2
        rlprint "You reload."
    else
        if totammo=0 then
            rlprint "Your ammo bins are full."
        else
            rlprint "You have no money."
        endif
    endif
    return 0
end function

private function repair_hull(pricemod as single=1) as short
    dim as short a,b,c,d,add
    
    display_ship
    if player.hull<max_hull(player) then
        rlprint "you can add up to " & max_hull(player)-player.hull &" Hull points (" & credits(fix(pricemod*100*(0.5+0.5*player.armortype))) & " Cr. per point, max " &minimum(max_hull(player)-player.hull,int(player.money/100)) &")"
        b=getnumber(0,max_hull(player)-player.hull,player.hull)
        if b>0 then
            if b+player.hull>max_hull(player) then b=max_hull(player)-player.hull
            if paystuff(b*pricemod*100*(0.5+0.5*player.armortype)) then player.hull=player.hull+b
        endif
    else
        rlprint "your ship is fully armored"
    endif

    return 0
end function

private function sick_bay(st as short=0,obe as short=0) as short
    dim text as string
    dim lastaug as byte
    dim augn(20) as string
    dim augp(20) as short
    dim augd(20) as string
    dim augf(20) as byte
    dim augv(20) as byte
    dim n as string
    '"Augments/ Targeting - 100 Cr/ Muscle Enhancement - 100 Cr/ Infrared Vision - 100 Cr/ Speed Enhancement - 100 Cr/ Exosceleton - 100 Cr/ Damage resistance - 100Cr/Exit")
                
    augn(1)="Targeting"
    augp(1)=100-st*20
    augd(1)="A targeting computer linked directly to the brain"
    augf(1)=1
    augv(1)=1
    
    augn(2)="Muscle Enhancement"
    augp(2)=100-st*20
    augf(2)=2
    augv(2)=1
    augd(2)="Artificial glands producing adrenalin on demand, increasing strength."
    
    augn(3)="Improved lungs"
    augp(3)=80-st*20
    augf(3)=3
    augv(3)=1
    augd(3)="User has lower oxygen requirement." 
    
    augn(4)="Speed Enhancement"
    augp(4)=150-st*20
    augd(4)="Artificial muscular tissue, increasing running speed"
    augf(4)=4
    augv(4)=1
    
    augn(5)="Exoskeleton"
    augp(5)=100-st*20
    augd(5)="An artificial exoskeleton to prevent damage."
    augf(5)=5
    augv(5)=1
    
    augn(6)="Metabolism Enhancement"
    augp(6)=150-st*20
    augd(6)="Increased pain threshholds and higher hormone output enable to withstand wounds longer."
    augf(6)=6
    augv(6)=1
    
    augn(7)="Floatation Legs"
    augp(7)=50-st*20
    augd(7)="Allowes walking on water"
    augf(7)=7
    augv(7)=1
    
    augn(8)="Built in Jetpack"
    augp(8)=200-st*20
    augd(8)="Allowes the user to fly similiar like when using a jetpack"
    augf(8)=8
    augv(8)=1
    
    augn(9)="Chameleon Skin"
    augp(9)=100-st*20
    augd(9)="Not so much like a skin, this installs a field bending light around the wearer, rendering him invisible."
    augf(9)=9
    augv(9)=1
    
    augn(10)="Neural Computer"
    augp(10)=100-st*20
    augd(10)="Increases the users learning ability."
    augf(10)=10
    augv(10)=1
    
    augn(11)="Targeting II"
    augp(11)=300-st*20
    augd(11)="A targeting computer linked directly to the brain"
    augf(11)=1
    augv(11)=2
    
    augn(12)="Muscle Enhancement II"
    augp(12)=300-st*20
    augf(12)=2
    augv(12)=2
    augd(12)="Artificial glands producing adrenalin on demand, increasing strength."

    augn(13)="Exoskeleton II"
    augp(13)=300-st*20
    augd(13)="An artificial exoskeleton to prevent damage."
    augf(13)=5
    augv(13)=2
    
    augn(14)="Metabolism Enhancement II"
    augp(14)=450-st*20
    augd(14)="Increased pain threshholds and higher hormone output enable to withstand wounds longer."
    augf(14)=6
    augv(14)=2    
    
    if st=1 then
        n="Surgeries - no questions asked"
        lastaug=20
        
        augn(15)="Targeting III"
        augp(15)=500-st*20
        augd(15)="A targeting computer linked directly to the brain. This level of augmentation is usually reserved for the Military and megacorps."
        augf(15)=1
        augv(15)=3
        
        augn(16)="Muscle Enhancement III"
        augp(16)=500-st*20
        augf(16)=2
        augv(16)=3
        augd(16)="Artificial glands producing adrenalin on demand, increasing strength. This level of augmentation is usually reserved for the Military and megacorps"
    
        augn(17)="Exoskeleton III"
        augp(17)=500-st*20
        augd(17)="An artificial exoskeleton to prevent damage. This level of augmentation is usually reserved for the Military and megacorps"
        augf(17)=5
        augv(17)=3
        
        augn(18)="Metabolism Enhancement III"
        augp(18)=750-st*20
        augd(18)="Increased pain threshholds and higher hormone output enable to withstand wounds longer. This level of augmentation is usually reserved for the Military and megacorps"
        augf(18)=6
        augv(18)=3
        
        augn(19)="Loyalty chip"
        augp(19)=200
        augd(19)="Instills respect and loyalty, making it impossible to retire. There are rumors that these are used in some elite military squads, but in most places they are illegal."
        augf(19)=11
        augv(19)=1
    
        augn(20)="Synthetic Nerves"
        augp(20)=300
        augd(20)="Replaces the recipients nerve system, making it easer to control augmentations (And survive the process of adding them)."
        augf(20)=12
        augv(20)=1
    
    else
        if obe=4 then
            n="OBE Research Lab"
            lastaug=14
        else
            n="Sickbay"
            lastaug=8
        endif
    endif
    
    dim as short a,b,c,price,cured,c2
    for a=1 to lastaug
        augn(0)=augn(0)&augn(a)&space(_swidth-len(augn(a))-len(credits(augp(a))))  &credits(augp(a))&" Cr. /"
        augd(0)=augd(0)&augd(a)&"/"
    next
    do
        set__color(11,0)
        cls
        display_ship()
        rlprint ""
        a=menu(bg_parent,n &"/ Buy supplies / Treat crewmembers/ Buy crew augments/Exit")
        if a=1 then
            shop(21+st,1,"Medical Supplies")
        endif
        if a=2 then
            'if player.disease>0 then price=price+10*player.disease
            price=0
            for b=1 to 255
                if crew(b).disease>0 and crew(b).hp>0 and crew(b).hpmax>0 then
                    price=price+5*crew(b).disease-st*3
                endif
            next
            if player.disease>0 then price=price+5*player.disease
            if price>0 then
                if askyn("Treatment will cost "&price &" Cr. Do you want the treatment to begin?") then
                    if paystuff(price) then
                        for b=1 to 255
                            if crew(b).disease>0 and crew(b).hp>0 and crew(b).hpmax>0 then
                                cured+=1
                                crew(b).disease=0
                                crew(b).onship=crew(b).oldonship
                            endif
                        next
                        rlprint cured &" crewmembers were cured."
                        player.disease=0
                    endif
                endif
            else
                rlprint "You have no sick crewmembers."
                player.disease=0
            endif
        endif
        if a=3 then
            do
                set__color(11,0)
                cls
                display_ship()
                rlprint ""
                b=menu(bg_parent,"Augments/"&augn(0)&"Exit","/"&augd(0))
                if b>0 and b<=lastaug then
                    do
                        c=showteam(0,1,augn(b)&c)
                        if c>0 then c2=1
                        if c=-1 then
                            if crew(6).hpmax>0 then
                                c=6
                            else
                                c=1
                            endif
                            c2=0
                        endif
                        screenset 0,1
                        set__color(11,0)
                        cls
                        display_ship()
                        flip
                        screenset 1,1
                        if c<>0 then
                            do
                                if c=1 and b=19 then 'No Loyalty Chip for Captain 
                                    if c2=0 then 
                                        c=2
                                    else
                                        c=0
                                    endif
                                endif
                                if (crew(c).typ<=9 or crew(c).typ>=14) and b>0 and c>0 then
                                    if crew(c).augment(augf(b))<augv(b) then
                                        if player.money>=augp(b) and crew(c).hp>0 then
                                            if crew(c).augment(0)<=2 or st<>0 then
                                                if st<>0 and crew(c).augment(0)>2 then 
                                                    if not(askyn("Installing more than 3 augmentations can be dangerous, even kill the recipient. shall we proceed? (y/n)")) then c=-1
                                                endif        
                                                if c>=0 then
                                                    if crew(c).augment(augf(b))=0 then crew(c).augment(0)+=1
                                                    player.money=player.money-augp(b)
                                                    if augf(b)=6 then 
                                                        crew(c).hp=crew(c).hp+augv(b)-crew(c).augment(augf(b))
                                                        crew(c).hpmax=crew(c).hpmax+augv(b)-crew(c).augment(augf(b))
                                                    endif
                                                    crew(c).augment(augf(b))=augv(b)
                                                    rlprint augn(b) & " installed in "&crew(c).n &"."
                                                    if crew(c).augment(0)>3 and rnd_range(1,6) +rnd_range(1,6)-crew(c).augment(12)*2>11-crew(c).augment(0) then
                                                        if rnd_range(1,100)<33-crew(c).augment(12)*15 then
                                                            crew(c).hp=0
                                                        else
                                                            crew(c).hpmax-=rnd_range(1,3-crew(c).augment(12)*2)
                                                            if crew(c).hp>crew(c).hpmax then crew(c).hp=crew(c).hpmax
                                                        endif
                                                        if crew(c).hp<=0 then
                                                            rlprint crew(c).n &" has died during the operation."
                                                        else
                                                            rlprint crew(c).n &" was permanently injured during the operation."
                                                        endif
                                                        no_key=keyin
                                                        if c=1 then player.dead=28
                                                    endif
                                                endif
                                            else
                                                rlprint "We can't install more than 3 augmentations."
                                                no_key=keyin
                                            endif
                                        else
                                            if crew(c).hp>0 then 
                                                rlprint "You don't have enough money.",14
                                                no_key=keyin
                                            else 
                                                rlprint crew(c).n &" is dead."
                                                no_key=keyin
                                            endif
                                        endif
                                    else
                                        rlprint crew(c).n &" already has "&augn(b)&"."
                                        no_key=keyin
                                    endif
                                else
                                    rlprint "We can only install augments in humans."
                                    no_key=keyin
                                endif
                                c+=1
                            loop until crew(c).hpmax<=0 or c2>0 or player.money<augp(b)
                        endif
                    loop until c=0
                endif
            loop until b=lastaug+1 or b=-1 or player.dead<>0
        endif
    loop until a=4
    return player.disease
end function



private function pirateupgrade() as short
    dim a as short
    if player.h_maxcrew>=10 then
        player.h_maxcrew=player.h_maxcrew-5
        player.h_maxcargo=player.h_maxcargo+1
        for a=1 to 9
            if player.cargo(a).x=0 then
                player.cargo(a).x=1
                recalcshipsbays()
                return 0
            endif
        next
    endif
    recalcshipsbays()
    return 0
end function

private function customize_item() as short
    dim as integer a,b,i,i2,j,price,c,nr
    dim as string t
    dim as byte debug=0
    do
        set__color(11,0)
        cls
        display_ship()
        a=menu(bg_awayteam,"Customize item/Increase accuracy/Add camo/Add imp. Camo/Acidproof/Exit")
        set__color(11,0)
        cls
        display_ship()
        if a=1 then
            i=get_item(2,4)
            if i>0 then
                rlprint "Let's take a look at your "&item(i).desig &"."
                if item(i).v3<4 then
                    nr=count_items(item(i))
                    if nr>1 then 
                        rlprint "How many?(1-"&nr &")"
                        nr=getnumber(0,nr,0)
                    endif
                    DbgPrint(""&nr)
                    price=(item(i).v3+1)*(item(i).v3+1)*100*nr*haggle_("down")
                    if askyn("That will cost "&price &" Cr.(y/n)") then
                        if paystuff(price) then 
                            for j=1 to nr
                                i=lowest_by_id(item(i).id)
                                    item(i).id+=2000
                                item(i).v3+=1
                                t=left(item(i).ldesc,instr(item(i).ldesc,"| |"))
                                for c=1 to len(item(i).ldesc)
                                    if mid(item(i).ldesc,c,1)<>"|" then
                                        t=t &mid(item(i).ldesc,c,1)
                                    else
                                        exit for
                                    endif
                                next
                                if item(i).ty=4 then item(i).ldesc=t &  "  | | Accuracy: "&item(i).v3 &" | Damage: "&item(i).v1 
                                if item(i).ty=2 then item(i).ldesc=t &  "  | | Accuracy: "&item(i).v3 &" | Damage: "&item(i).v1 &" | Range:"&item(i).v2
                            next
                        endif
                    endif
                endif
            else
                rlprint "Come back when you have a weapon to modify."
            endif
        endif
        if a=2 or a=3 then
            i=get_item(3)
            if i>0 then
                rlprint "Let's take a look at your "&item(i).desig &"."
                i2=lowest_by_id(item(i).id)
                if i2>0 then i=i2
                if a=2 then price=100
                if a=3 then price=250
                if item(i).v2>0 then 
                    rlprint "That suit is already camoflaged."
                else
                    price=price*nr*haggle_("down")
                    if askyn("that will cost "&price &" Cr.(y/n)") then
                        if paystuff(price) then
                            if a=2 then 
                                item(i).id+=1200
                                item(i).v2=1
                                item(i).desig="Camo "&item(i).desig
                            endif
                            if a=3 then 
                                item(i).id+=1300
                                item(i).v2=3
                                item(i).desig="Imp. Camo "&item(i).desig
                            endif
                        endif
                    endif
                endif
            else
                rlprint "Come back when you have a suit to modify."
            endif
        endif
        if a=4 then
            i=get_item()
            if i>0 then
                rlprint "Let's take a look at your "&item(i).desig &"."
                price=50*haggle_("down")
                if askyn("That will cost " &price & " cr.(y/n)") then
                    if paystuff(price) then
                        item(i).id+=1500
                        item(i).res=120
                        item(i).desig="Acidproof "&item(i).desig
                    endif
                endif
            else
                rlprint "Come back when you have something to acidproof."
            endif
        endif
    loop until a=5
    return 0
    
end function


private function nextemptyc() as short
dim re as short
    dim a as short
    dim b as short
    for a=1 to 10
        if player.cargo(a).x=0 and b=0 then
        	b=a
        	exit for
        EndIf
    next
    return b
end function


private function change_prices(st as short,etime as short) as short
    DimDebug(0)
    dim a as short
    dim b as short
    dim c as short
    dim supply as short
    dim demand as short
    dim change as short
    dim c1 as single
    dim c2 as single
    dim c3 as single
    for a=1 to 8
        'basis(st).inv(a).test2=basis(st).inv(a).p
        supply=0
        demand=0
        for b=1 to etime
            if a<6 then
                demand=demand+rnd_range(1,6-a/2)
                if basis(st).inv(a).p>baseprice(a)/2 then
                    supply=supply+rnd_range(1,6-a/2)
                else
                    supply=0
                endif
                if basis(st).company=3 then supply+=1
            else
                if st<=5 then
                    if a>=6 and a<=8 then 
                        demand=rnd_range(1,3)
                        if basis(st).inv(a).p>baseprice(a)/2 then supply=rnd_range(1,3)
                    endif
                    if basis(st).company=1 and a=8 then 
                        if basis(st).inv(a).p>baseprice(a)/2 then supply+=1
                        demand-=1
                    endif
                    if basis(st).company=2 and a=7 then 
                        if basis(st).inv(a).p>baseprice(a)/2 then supply+=1
                        demand-=1
                    endif
                    if basis(st).company=4 and a=6 then 
                        if basis(st).inv(a).p>baseprice(a)/2 then supply+=1
                        demand-=1
                    endif
                    'TT can't make the stuff
                else
                    demand-=4
                    supply=0
                endif
            endif
        next
        change=demand-supply
        basis(st).inv(a).v=basis(st).inv(a).v-change 'Change inventory
        if change>3 then change=3
        if change<-3 then change=-3
        if basis(st).inv(a).v<0 then
            basis(st).inv(a).v=0
            change=change+1
        endif
        if basis(st).inv(a).v>10 then
            basis(st).inv(a).v=10
            change=change-1
        endif
        
        'if change>0 then basis(st).inv(a).p+=rnd_range(1,3) 
        'if change<0 then basis(st).inv(a).p-=rnd_range(1,3) 
        basis(st).inv(a).p=basis(st).inv(a).p+fix(baseprice(a)*change/10)'Change price
        
        'market extremes
        if basis(st).inv(a).p<baseprice(a)/2 then 
            basis(st).inv(a).p=baseprice(a)/2
            basis(st).inv(a).v=basis(st).inv(a).v-rnd_range(1,3)
        endif
        if basis(st).inv(a).v<1 then basis(st).inv(a).v=rnd_range(1,3)
        if basis(st).inv(a).p>baseprice(a)*3 then 
            basis(st).inv(a).v=basis(st).inv(a).v+rnd_range(1,3)
            basis(st).inv(a).p=baseprice(a)*3
        endif
        
    next
    
    'gasprice
    for b=1 to etime step 10
        supply=rnd_range(0,2)+rnd_range(0,count_gas_giants_area(basis(st).c,7))
        'supply=((2+count_gas_giants_area(basis(st).c,10))*basis(st).inv(9).p/30)-rnd_range(0,3)
        if basis(st).inv(9).v+supply>7 then basis(st).inv(9).p-=rnd_range(1,3)
        if basis(st).inv(9).v+supply<3 then basis(st).inv(9).p+=rnd_range(1,3)
        if basis(st).inv(9).v+supply<0 then basis(st).inv(9).p+=1
        basis(st).inv(9).v+=supply
        if basis(st).inv(9).v<1 then basis(st).inv(9).v=1
        if basis(st).inv(9).v>10 then basis(st).inv(9).v=10
        if basis(st).inv(9).p<20 then basis(st).inv(9).p=20 
        if basis(st).inv(9).p>300 then basis(st).inv(9).p=300 
        DbgPrint("Price st "&st &":"& basis(st).inv(9).p)
    next
    for c=12 to 1 step -1
        goods_prices(0,c,st)=goods_prices(0,c-1,st)
    next
    goods_prices(0,c,st)=gameturn
    for b=1 to 8
        for c=12 to 1 step -1
            goods_prices(b,c,st)=goods_prices(b,c-1,st)
        next
        goods_prices(b,0,st)=basis(st).inv(b).p
        avgprice(b)=0
        for a=0 to 4
            if a<>3 then
                avgprice(b)=avgprice(b)+basis(a).inv(b).p
            endif
        next
        avgprice(b)=avgprice(b)/4
    next
    return 0
end function

private function removeinvbytype( t as short, am as short) as short
    dim a as short
    dim b as short
    t=t+1
    for a=1 to 25
        if player.cargo(a).x=t and am>0 then
            player.cargo(a).x=1
            am=am-1
        endif
    next
    return am
end function

