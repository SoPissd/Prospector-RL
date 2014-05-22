'tShops.
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
'     -=-=-=-=-=-=-=- TEST: tShops -=-=-=-=-=-=-=-
#undef intest
#define test
#endif'test

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Enum shops
    sh_shipyard
    sh_modules
    sh_equipment
    sh_used
    sh_mudds
    sh_bots
End Enum

Enum moduleshops
    ms_energy
    ms_projectile
    ms_modules
End Enum

Enum slse
    slse_arena
    slse_zoo
    slse_slaves
End Enum

Dim Shared moduleshopname(ms_modules) As String
Dim Shared shop_order(2) As Short


#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tShops -=-=-=-=-=-=-=-

declare function get_biodata(e as _monster) as integer
declare function reroll_shops() as short
declare function shop(sh as short,pmod as single,shopn as string) as short
declare function sell_alien(sh as short) as short
declare function botsanddrones_shop() as short
declare function buy_weapon(st as short) as short

'declare function place_shop_order(sh as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tShops -=-=-=-=-=-=-=-

namespace tShops
function init(iAction as integer) as integer
    moduleshopname(ms_energy)="OBE High Energy Research Lab"
    moduleshopname(ms_projectile)="SHI Weapons Division ltd."
    moduleshopname(ms_modules)="Triax Ship-Accesoirs"
    
	return 0
end function
end namespace'tShops



function reroll_shops() as short
    dim it as _items 
    dim delit as _items 
    dim as short a,b,i,c,sh,flag,roll,spec,shopno
    dim sortinvlist(20) as _items
    dim dummynumber(20) as short
    for shopno=0 to 29
        for a=0 to 20
            shopitem(a,shopno)=delit 'Delete Item
        next
    next
    
    for i=0 to 24
        if i<>20 then
        b=0
        a=1
        do
            b+=1
            flag=0
            it=delit 'Delete Item
            if i<=3 then 'Station Shops
                spec=basis(i).shop(sh_equipment)
                if a<=5 then
                    it=rnd_item(RI_StandardShop)
                else
                    if spec=1 then it=rnd_item(RI_ShopExplorationGear)
                    if spec=2 then 
                        if rnd_range(1,100)<50 then 
                            it=rnd_item(RI_WeakWeapons)
                        else
                            it=rnd_item(RI_WeakStuff)
                        endif
                    endif
                    if spec=3 then it=rnd_item(RI_ShopSpace)
                    if spec=4 then it=rnd_item(RI_ShopWeapons)
                endif
            endif
            if i=4 then 'Colony I
                if b=19 then it=make_item(97)'Disintegrator
                if b=18 then it=make_item(98)'adaptive bodyarmor
                if b<17 then
                    it=make_item(RI_Standardshop)
                endif
            endif
            if i=6 then 'Black market
                it=rnd_item(RI_AllButWeaponsAndMeds)
            endif
            if i=7 then 'Mudds
                if b=1 then 
                    it=make_item(250)
                else
                    it=make_item(rnd_range(1,80))
                endif
            endif
            if i=5 or (i>7 and i<21) then
                if a<=3 then
                    it=make_item(31+a)
                endif
                it=rnd_item(RI_StandardShop)
            endif
            
            if i>=21 and i<=24 then 'Medical supplies
                select case rnd_range(1,100)
                case 1 to 18
                    it=rnd_item(RI_Infirmary)
                case 19 to 60
                    it=rnd_item(RI_Medpacks)
                case 61 to 80
                    it=rnd_item(RI_KODrops)
                case else
                    it=rnd_item(RI_Cage)
                end select
            endif
            
            for c=1 to 20
                if shopitem(c,i).desig="" then
                    shopitem(c,i)=it
                    a+=1
                    exit for
                endif
                if shopitem(c,i).id=it.id then exit for
            next
        loop until a>=20 or (i=20 and a>=15) or (i>=21 and a>=10)
        endif
    next
    
    'Engine Sensors Shieldshop
    a=0
    roll=rnd_range(1,90)+tVersion.gameturn/2500
    if roll>0 then 
        a+=1
        shopitem(a,20)=make_shipequip(1)
    endif
    if roll>10 then 
        a+=1
        shopitem(a,20)=make_shipequip(2)
    endif
    if roll>25 then 
        a+=1
        shopitem(a,20)=make_shipequip(3)
    endif
    if roll>75 then 
        a+=1
        shopitem(a,20)=make_shipequip(4)
    endif
    if roll>90 then 
        a+=1
        shopitem(a,20)=make_shipequip(5)
    endif
    
    roll=rnd_range(1,90)+tVersion.gameturn/2500
    if roll>0 then 
        a+=1
        shopitem(a,20)=make_shipequip(6)
    endif
    if roll>10 then 
        a+=1
        shopitem(a,20)=make_shipequip(7)
    endif
    if roll>25 then 
        a+=1
        shopitem(a,20)=make_shipequip(8)
    endif
    if roll>75 then 
        a+=1
        shopitem(a,20)=make_shipequip(9)
    endif
    if roll>90 then 
        a+=1
        shopitem(a,20)=make_shipequip(10)
    endif
    
    roll=rnd_range(1,90)+tVersion.gameturn/2500
    if roll>10 then 
        a+=1
        shopitem(a,20)=make_shipequip(11)
    endif
    if roll>25 then 
        a+=1
        shopitem(a,20)=make_shipequip(12)
    endif
    if roll>75 then 
        a+=1
        shopitem(a,20)=make_shipequip(13)
    endif
    if roll>90 then 
        a+=1
        shopitem(a,20)=make_shipequip(14)
    endif
    for b=15 to 23
        if rnd_range(1,100)<50 and a<=19 then 
            a+=1
            shopitem(a,20)=make_shipequip(b)
        endif
    next
    a+=1
    if a>20 then a=20
    shopitem(a,20)=make_shipequip(21)
    'Droneshop
    c=1
    
    for b=50 to 55 
        if rnd_range(1,100)<77 then
            shopitem(c,25)=make_item(b)
            c+=1
        endif
    next
    if rnd_range(1,100)<77 then 
        c+=1
        shopitem(c,25)=make_item(30)'Comsat
    endif
    
    for b=100 to 102
        if rnd_range(1,100)<77 then
            shopitem(c,25)=make_item(b,,25)
            c+=1
        endif
    next
    
    for b=104 to 105
        if rnd_range(1,100)<77 then
            shopitem(c,25)=make_item(b)
            c+=1
        endif
    next
    
    for b=110 to 112
        if rnd_range(1,100)<77 then
            shopitem(c,25)=make_item(b,,25)
            c+=1
        endif
    next
    
    for b=0 to 3 'Module Stores in spacestations
        for i=1 to 10
            select case basis(b).shop(sh_modules)
            case ms_energy
                makew(i,b)=rnd_range(6,10)
            case ms_projectile
                makew(i,b)=rnd_range(1,5)
            case ms_modules
                if rnd_range(1,100)<66 then
                    makew(i,b)=rnd_range(84,99)
                else
                    makew(i,b)=rnd_range(97,99)
                endif
            end select
        next
        for i=11 to 15
            makew(i,b)=rnd_range(84,99)
        next
        c=16
        for i=16 to 19
            if rnd_range(1,100)<20+tVersion.gameturn/1000 then
                select case rnd_range(1,100)
                case 1 to 33
                    makew(c,b)=rnd_range(4,5)
                case 34 to 66
                    makew(c,b)=rnd_range(9,10)
                case else
                    makew(c,b)=rnd_range(84,99)
                end select
                c+=1
            endif
        next
    next
    
    
    for b=4 to 5 'Shipweapons shops
        i=0
        c=0
        if b=5 then sh=1
        for a=1 to 4+sh
            if rnd_range(1,100)<(130-(c*10)+(sh*20)) then
                i=i+1
                if i>20 then i=20
                makew(i,b)=a
            endif
            c=c+1
        next
        c=0
        for a=6 to 9+sh
            if rnd_range(1,100)<(130-(c*10)+(sh*20)) then
                i=i+1
                if i>20 then i=20
                makew(i,b)=a
            endif
            c=c+1
        next
        c=0
        if sh>0 then
            for a=11 to 14
                if rnd_range(1,100)<(100-(c*10)+(sh*20)) then
                    i=i+1
                    if i>20 then i=20
                    makew(i,b)=a
                endif
                c=c+1
            next
        endif
        
        for a=84 to 99
            if rnd_range(1,100)<55 then
                i+=1
                if i>20 then i=20
                makew(i,b)=a
            endif
        next
    next   
    
    
    for b=26 to 29
        i=0
        i+=1
        shopitem(i,b)=make_item(75)
        if rnd_range(1,100)<50 then
           i+=1
           shopitem(i,b)=make_item(76)
        endif
        
        i+=1
        shopitem(i,b)=make_item(104)
        if rnd_range(1,100)<25 then
           i+=1
           shopitem(i,b)=make_item(105)
        endif
        
        i+=1
        shopitem(i,b)=make_item(100)
        if rnd_range(1,100)<75 then
           i+=1
           shopitem(i,b)=make_item(101)
        endif
        if rnd_range(1,100)<25 then
           i+=1
           shopitem(i,b)=make_item(102)
        endif
        
        i+=1
        shopitem(i,b)=make_item(110)
        if rnd_range(1,100)<75 then
           i+=1
           shopitem(i,b)=make_item(111)
        endif
        if rnd_range(1,100)<25 then
           i+=1
           shopitem(i,b)=make_item(112)
        endif
        
        'sort_items(shopitem(,b))
    next
    for i=1 to 8
        usedship(i).x=rnd_range(1,12)
        usedship(i).y=rnd_range(0,3)
    next
    
    for i=1 to 12
        select case rnd_range(1,100)
        case 1 to 50
            it=rnd_item(RI_weakweapons)
        case 51 to 90
            it=rnd_item(RI_weakstuff)
        case else
            it=rnd_item(RI_shopexplorationgear)
        end select
        it.res=it.res/1.2
        shopitem(i,30)=it
    next           
    
    return 0
end function

'

function place_shop_order(sh as short) as short
    dim as string t,w
    dim as short a,b,f
    dim as single bestmatch,bmc,candidate,s,l
    dim tried(80) as byte
    dim as _cords p
    dim as _items i
    p=locEOL
    rlprint "What would you like to order?"
    t=gettext(p.x,p.y,26,t)
    t=ucase(t)
    f=0
    do
    bestmatch=9999
    f+=1
    for a=1 to 80
        i=make_item(a)
        i.desig=ucase(i.desig)
        l=len(i.desig)
        w=""
        if trim(ucase(i.desig))=trim(ucase(t)) and tried(a)=0 then
            candidate=a
            bestmatch=0
        else
            for b=1 to l
                w=w &mid(i.desig,b,1)
                print #f,w
                if mid(i.desig,b,1)=" " or b=l then
                    s=fuzzymatch(w,t)
                    if s<bestmatch and tried(a)=0 then
                        candidate=a
                        bestmatch=s
                    endif
                    print #f,"score:";s;"Words:";t;":";w
                    w=""
                endif
            next
        endif
    next
    if bestmatch<0.2 then
        i=make_item(candidate)
        if askyn("Do you want to order "&add_a_or_an(i.desig,0) &"? (y/n)") then
            shop_order(sh)=candidate
            rlprint "I can't say for certain when it will arive, but it should be here soon."
            f=3
            candidate=0
        else
            tried(candidate)=1
        endif
    else
        rlprint "I don't think I ever heard of those."
        f=3
    endif
    loop until f=3
    return 0
end function


function shop(sh as short,pmod as single,shopn as string) as short
    dim as short a,b,c,e,v,i,best,order,ex
    dim as string t
    dim inv(20) as _items
    dim lonest as short
    dim desc as string
    dim l as string
    c=1
    i=20
    order=-2
    t=shopn
    
    assert(pHaggle<>null)
    pmod=pmod* pHaggle("DOWN")
    
    for a=1 to 9999
        for b=1 to i
            if shopitem(b,sh).ty=a then
                inv(c)=shopitem(b,sh)
                c=c+1
            endif
        next
    next
        
    sort_items(inv())
    
    for b=1 to i
        for a=1 to i-1
            if inv(a).desig="" then inv(a)=inv(a+1)
        next
    next
    b=1
        
    for a=1 to c-1
        t=t &"/" &inv(a).desig & space(_swidth-len(trim(inv(a).desig))-len(credits(inv(a).price*pmod))) & credits(int(inv(a).price*pmod)) &" Cr." 
        desc=desc &"/"&inv(a).describe
        b=b+1
    next
    if sh<=3 then
        order=b
        b+=1
        t=t &"/Order Item"
        desc=desc &"/Order an item not in tCompany for double the price"
    endif
    ex=b
    t=t & "/Exit"
    desc=desc &"/"
    
    assert(pDisplayShip<>null)
    pDisplayShip()
    
    rlprint("")
    c=textmenu(t,desc,2,2)
    select case c
    case order
        place_shop_order(sh)
    case ex,-1
        return -1
    case else
        select case inv(c).ty
        case 150'sensors
            if inv(c).v1<player.sensors then rlprint "You already have better sensors."
            if inv(c).v1=player.sensors then rlprint "These sensors aren't better than the one you already have."
            if inv(c).v1>player.h_maxsensors then rlprint "These sensors don't fit in your ship."
            if inv(c).v1>player.sensors and inv(c).v1<=player.h_maxsensors then
                if paystuff(inv(c).price*pmod) then 
                    player.sensors=inv(c).v1
                    rlprint "You buy a "&inv(c).desig &"."
                endif
            endif
        case 151'engine
            if inv(c).v1<player.engine then rlprint "You already have a better engine."
            if inv(c).v1=player.engine then rlprint "this engine isn't better than the one you already have."
            if inv(c).v1>player.h_maxengine then rlprint "This engine doesn't fit in your ship."
            if inv(c).v1>player.engine and inv(c).v1<=player.h_maxengine then
                if paystuff(inv(c).price*pmod) then
                    player.engine=inv(c).v1
                    rlprint "You buy a "&inv(c).desig &"."
                endif
            endif
        case 152'shield
            if inv(c).v1<player.shieldmax then rlprint "You already have a better shieldgenerator."
            if inv(c).v1=player.shieldmax then rlprint "This shield generator isn't better than the one you already have."
            if inv(c).v1>player.h_maxshield then rlprint "This shield generator doesn't fit in your ship."
            if inv(c).v1>player.shieldmax and inv(c).v1<=player.h_maxshield then
                if paystuff(inv(c).price*pmod) then
                    player.shieldmax=inv(c).v1
                    rlprint "You buy a "&inv(c).desig &"."
                endif
            endif
        case 153 'Shipdetection
            if inv(c).v1<player.equipment(se_shipdetection) then rlprint "You already have a better ship detection system."
            if inv(c).v1=player.equipment(se_shipdetection) then rlprint "You already have the same ship detection system."
            if inv(c).v1>player.equipment(se_shipdetection) then 
                if paystuff(inv(c).price*pmod) then 
                    player.equipment(se_shipdetection)=inv(c).v1
                    rlprint "You buy a "&inv(c).desig &"."
                endif
            endif
        case 154 'navcomp
            if inv(c).v1=player.equipment(se_navcom) then rlprint "You already have a navigational computer."
            if inv(c).v1>player.equipment(se_navcom) then 
                if paystuff(inv(c).price*pmod) then 
                    player.equipment(se_navcom)=inv(c).v1
                    rlprint "You buy a "&inv(c).desig &"."
                endif
            endif
            
        case 155 'ECM
            if inv(c).v1<player.equipment(se_ECM) then rlprint "You already have a better ECM system."
            if inv(c).v1=player.equipment(se_ECM) then rlprint "You already have the same ECM system."
            if inv(c).v1>player.equipment(se_ECM) then 
                if paystuff(inv(c).price*pmod) then 
                    player.equipment(se_ECM)=inv(c).v1
                    rlprint "You buy a "&inv(c).desig &"."
                endif
            endif
            
        case 156 'Cargoshielding
            if inv(c).v1<player.equipment(se_CargoShielding) then rlprint "You already have better cargo shielding."
            if inv(c).v1=player.equipment(se_CargoShielding) then rlprint "You already have the same cargo shielding."
            if inv(c).v1>player.equipment(se_CargoShielding) then 
                if paystuff(inv(c).price*pmod) then player.equipment(se_CargoShielding)=inv(c).v1
            endif
        case 157 'Fuelsystem
            if inv(c).v1<player.equipment(se_Fuelsystem) then rlprint "You already have a better fuel system."
            if inv(c).v1=player.equipment(se_Fuelsystem) then rlprint "You already have the same fuel system."
            if inv(c).v1>player.equipment(se_Fuelsystem) then 
                if paystuff(inv(c).price*pmod) then 
                    player.equipment(se_fuelsystem)=inv(c).v1
                    player.fueluse=1-inv(c).v1/10
                    rlprint "You buy " &add_a_or_an(inv(c).desig,0) & "."
            
                endif
            endif
        case 21
            best=findbest(21,-1)
            if best>0 then
                if item(best).v1>inv(c).v1 then rlprint "you already have a better infirmary"
                if item(best).v1=inv(c).v1 then rlprint "you already have such an infirmary"
                if item(best).v1<inv(c).v1 then 
                    if paystuff(inv(c).price*pmod) then 
                        placeitem(inv(c),0,0,0,0,-1)'player already has one and t his one is better
                        rlprint "You buy " &add_a_or_an(inv(c).desig,0) & "."
            
                    endif
                endif
            else
                if paystuff(inv(c).price*pmod) then 
                    placeitem(inv(c),0,0,0,0,-1)'Its the first
                    rlprint "You buy " &add_a_or_an(inv(c).desig,0) & "."
            
                endif
            endif
        
        case else
            if paystuff(int(inv(c).price*pmod))=-1 then
                player.money=player.money+int(inv(c).price*pmod)'Giving back
                rlprint "How many "&inv(c).desigp &" do you want to buy? (Max: " &fix(player.money/(inv(c).price*pmod)) &")"
                v=getnumber(0,fix(player.money/(inv(c).price*pmod)),0)
                if v>0 then
                    if paystuff(inv(c).price*pmod*v)=-1 and v>0 then
                        for a=1 to v
                            uid+=1
                            inv(c).uid=uid
                            placeitem(inv(c),0,0,0,0,-1)
                        next
                        if v=1 then
                            rlprint "you buy "&add_a_or_an(inv(c).desig,0) & " for "& credits(int(inv(c).price*pmod))&" Cr."
                        else
                            rlprint "you buy "& v &" "&inv(c).desigp &" for "&credits(int(inv(c).price*pmod*v)) &" Cr."
                        endif
                    endif
                endif
            endif
        end select
    end select
    return c
end function


function get_biodata(e as _monster) as integer
    if e.hp>0 then
        return (50)*(1+e.stunres/2)*e.biomod+cint(2*e.biomod*(e.hpmax^2)/3)
    else
        return e.biomod*(e.hpmax^2/3)
    endif
end function


function sell_alien(sh as short) as short
    dim t as string
    dim as short i,c,biodata
'DbgLogExplorePlanet("sell_alien: " &sh &"; lastcagedmonster: " &lastcagedmonster &"; ub cagedmonster: " &ubound(cagedmonster))
    if lastcagedmonster=0 then
        rlprint "You have nothing to sell."
        return 0
    endif
    do
        t="Sell liveform:"
        for i=1 to lastcagedmonster
            t=t &"/"&cagedmonster(i).sdesc
        next
        t=t & "/Exit"
'DbgLogExplorePlanet("sell_alien: " & t)
        c=textmenu(t)
        if c>0 and c<=lastcagedmonster then
            biodata=get_biodata(cagedmonster(c))
            select case sh
            case slse_arena
                biodata=biodata*(cagedmonster(c).weapon+cagedmonster(c).armor)
            case slse_zoo
                biodata=biodata*1.1
            case slse_slaves
                if cagedmonster(c).lang>1 or (cagedmonster(c).intel>1 and cagedmonster(c).intel<5) then
                    biodata=cagedmonster(c).hpmax*cagedmonster(c).intel*cagedmonster(c).pumod/5
                else
                    biodata=0
                endif
            end select
            if biodata>0 then
                if askyn("I would give you "&credits(biodata)&"Cr. for your "&cagedmonster(c).sdesc &"(y/n)") then
                    addmoney(biodata,mt_piracy)
                    biodata=get_biodata(cagedmonster(c))
                    item(cagedmonster(c).c.s).v3-=biodata'Remove the biodata from the cage
                    reward(1)-=biodata
                    cagedmonster(c)=cagedmonster(lastcagedmonster)
                    lastcagedmonster-=1
                endif
            else
                rlprint "I wouldn't know what to do with that."
            endif
            c=0
        endif
    loop until c=-1 or c=lastcagedmonster+1 or lastcagedmonster=0
    return 0
end function

function botsanddrones_shop() as short
    dim as integer a,b,c,il(lastitem),price
    dim as string wreckquestion
    
    assert(pHaggle<>null)
    price= 15 * pHaggle("UP")
    do
	
	    assert(pDisplayShip<>null)
	    pDisplayShip()
	
	    rlprint "Welcome to the Bot-Bin! This sectors most sophisticated 2nd hand robot store."
	    a=textmenu("The Bot-bin/Buy/Sell/Exit")
	    if a=1 then 
	        do
	            b=shop(25,0.8,"The Bot-bin")
			    
	        loop until b=-1
	    endif
	    if a=2 then
	        if askyn("Always looking for spare parts we offer " &price & " Cr. for bot and rover debris. Do you want to sell? (y/n)") then
	            for b=0 to lastitem
	                if item(b).w.s<0 then
	                    if item(b).id=65 then
	                        c+=1
	                        il(c)=b
	                    endif
	                endif
	            next
	            if c>0 then
	                if c=1 then wreckquestion="You have "&c &" wreck. Do you want to sell them?(y/n)"
	                if c>1 then wreckquestion="You have "&c &" wrecks. Do you want to sell them?(y/n)"
	                if askyn(wreckquestion) then
	                    addmoney(c*price,mt_quest2)
	                    for b=1 to c
	                        item(il(b)).w.s=99
	                    next
	                    for b=0 to lastitem
	                        if item(b).w.s=99 then
	                            item(b)=item(lastitem)
	                            lastitem-=1
	                        endif
	                    next
	                endif
	            else
	                rlprint "You don't have any debris to sell."
	            endif
	        endif
	    endif
    loop until a=3
    return 0
end function



function buy_weapon(st as short) as short
    dim as short a,b,c,d,i,mod1,mod2,mod3,mod4,ex
    dim as short last
    dim it as _items 
    dim weapons as string
    dim key as string
    dim wmenu as string
    dim help as string
    
    assert(pHaggle<>null)   
    assert(pDisplayShip<>null)
    
    do
        i=0
        for a=1 to 20
            if makew(a,st)<>0 then i+=1
        next
        weapons="Weapons:"
        help=""
        for a=1 to i
            b=_swidth-len(trim(wsinv(a).desig))-len(credits(wsinv(a).p*pHaggle("down")))
            weapons=weapons &"/ " &trim(wsinv(a).desig) & space(b) &credits(wsinv(a).p*pHaggle("down"))&" Cr."
            help=help &"/"&make_weap_helptext(wsinv(a))
        next

        weapons=weapons &"/Exit"
        help=help &" /"
        last=i
        ex=i+1
        
        tScreen.set(0)
        set__color(11,0)
        cls
	    pDisplayShip()
        rlprint ""
        
        d=textmenu(weapons,help,2,2)
        tScreen.update()
        if d>=1 and d<=last then
            b=player.h_maxweaponslot
            wmenu="Weapon Slot/"
            for a=1 to b
                if player.weapons(a).desig="" then
                    wmenu=wmenu & "-Empty-/"
                else
                    wmenu=wmenu & player.weapons(a).desig & "/"
                endif
            next
            wmenu=wmenu+"Exit"
            b=b+1            
            c=textmenu(wmenu)
            if c<b then
                if player.weapons(c).desig<>"" and d<>5 then 
                    if not(askyn("Do you want to replace your "&player.weapons(c).desig &"(y/n)")) then c=b
                endif
                if c<b then
                    if paystuff(wsinv(d).p*pHaggle("down")) then
                        if wsinv(d).made<=14 then
                            rlprint "You buy "&add_a_or_an(wsinv(d).desig,0) &"."
                        else
                            rlprint "You buy "&wsinv(d).desig &"."
                        endif
                        player.weapons(c)=wsinv(d)
                        for i=d to last
                            wsinv(d)=wsinv(d+1)
                            makew(d,st)=makew(d+1,st)
                        next
                        wsinv(last)=make_weapon(0)
                        makew(last,st)=0
                    endif
                endif
            endif
        endif

		assert(pRecalcshipsbays<>null)
        pRecalcshipsbays()

    loop until d=ex
    return 0
end function


#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tShops -=-=-=-=-=-=-=-
	tModule.register("tShops",@tShops.init()) ',@tShops.load(),@tShops.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tShops -=-=-=-=-=-=-=-
#endif'test
