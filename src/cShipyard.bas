'tShipyard.
'
'defines:
'poolandtransferweapons=1, upgradehull=7, buy_ship=1, used_ships=2,
', change_armor=0, ship_design=0, custom_ships=0, ship_inspection=0,
', shipyard=9, missing_ammo=2, change_loadout=0, shipupgrades=3,
', buy_engine=0
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
'     -=-=-=-=-=-=-=- TEST: tShipyard -=-=-=-=-=-=-=-
#undef intest
#define test
#endif'test

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Enum ShipYards
    sy_civil
    sy_military
    sy_pirates
    sy_blackmarket
End Enum

Dim Shared shipyardname(sy_blackmarket) As String
#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tShipyard -=-=-=-=-=-=-=-

declare function poolandtransferweapons(s1 As _ship,s2 As _ship) As Short
declare function upgradehull(t as short,byref s as _ship,forced as short=0) as short
declare function buy_ship(st as short,ds as string,pr as short) as short
declare function used_ships() as short
declare function shipyard(where as byte) as short
declare function missing_ammo() as short
declare function shipupgrades(st as short) as short

'private function change_armor(st as short) as short
'private function ship_design(where as byte) as short
'private function custom_ships(where as byte) as short
'private function ship_inspection(price as short) as short
'private function change_loadout() as short
'private function buy_engine() as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tShipyard -=-=-=-=-=-=-=-

namespace tShipyard
function init() as Integer
    shipyardname(sy_military)="SHI Vessels Division ltd."
    shipyardname(sy_civil)="Eridiani Exploratory Craft ltd."
    shipyardname(sy_pirates)="Lost and Found"
    shipyardname(sy_blackmarket)="LeOfInCo ltd."'Leago of independant contractors
	return 0
end function
end namespace'tShipyard


function poolandtransferweapons(s1 As _ship,s2 As _ship) As Short
    Dim As Short e,f,c,g,d,x,y,bg
    Dim As String text,help,desc,Key
    Dim As _cords crs,h1,h2
    Dim weapons(1,10) As _weap
    e=0
    ' old weapons
    For f=1 To 5
        If s1.weapons(f).desig<>"" Then
            e=e+1
            weapons(0,e)=s1.weapons(f)
            s1.weapons(f)=make_weapon(0)
        Else
            If f<=s1.h_maxweaponslot Then weapons(0,f).desig="-empty-"
        EndIf
    Next
    'new weapons
    e=0
    For f=1 To 5
        If s2.weapons(f).desig<>"" Then
            e=e+1
            weapons(1,e)=s2.weapons(f)
            s2.weapons(f)=make_weapon(0)
        Else
            If f<=s2.h_maxweaponslot Then weapons(1,f).desig="-empty-"
        EndIf
    Next
    Do
        set__color( 15,0)
        Cls
        draw_string(0,0,"New Ship",font2,_col)
        draw_string(35*_fw2,0,"Old Ship",font2,_col)
        For x=0 To 1
            For y=1 To 5
                bg=0
                If h1.x=x And h1.y=y Then bg=5
                If h2.x=x And h2.y=y Then bg=5
                If crs.x=x And crs.y=y Then bg=11
                set__color( 15,bg)
                draw_string(x*35*_fw2,y*_fh2,Trim(weapons(x,y).desig)&" ",font2,_col)
            Next
        Next
        set__color( 15,0)
        draw_string(5*_fw2,6*_fh2,"x to swap, esc to exit",font2,_col)
        If weapons(crs.x,crs.y).desig<>"-empty-" Then
            help =weapons(crs.x,crs.y).desig & " | | Damage: "&weapons(crs.x,crs.y).dam &" | Range: "&weapons(crs.x,crs.y).range &"\"&weapons(crs.x,crs.y).range*2 &"\" &weapons(crs.x,crs.y).range*3
        Else
            help = "Empty slot"
        EndIf
        textbox(help,2,8,25,11,1)
        set__color( 15,0)
        Key=keyin()
        crs=movepoint(crs,getdirection(Key))
        If crs.x<0 Then crs.x=1
        If crs.x>1 Then crs.x=0
        If crs.y<1 Then crs.y=5
        If crs.y>5 Then crs.y=1
        If crs.x=0 And crs.y>player.h_maxweaponslot+1 Then crs.y=1
        If crs.x=1 And crs.y>s1.h_maxweaponslot+1 Then crs.y=1
        If Key=key__enter Then
            If crs.x=0 Then
                h1=crs
                If crs.y<1 Then crs.y=5
                If crs.y>5 Then crs.y=1
                If crs.y>s2.h_maxweaponslot Then crs.y=s2.h_maxweaponslot
            EndIf
            If crs.x=1 Then
                h2=crs
                If crs.y<1 Then crs.y=5
                If crs.y>5 Then crs.y=1
                If crs.y>s1.h_maxweaponslot Then crs.y=s1.h_maxweaponslot
            EndIf
        EndIf
        If Key="x" And h1.y<>0 And h2.y<>0 Then
            Swap weapons(h1.x,h1.y),weapons(h2.x,h2.y)
        EndIf
    Loop Until Key=key__esc
    For f=1 To player.h_maxweaponslot
        If weapons(0,f).desig<>"-empty-" Then player.weapons(f)=weapons(0,f)
    Next
    recalcshipsbays()
    Return 0
End function


function upgradehull(t as short,byref s as _ship,forced as short=0) as short
    dim as short f,flg,a,b,cargobays,weapons,tfrom,tto,m
    dim n as _ship
    dim d as _crewmember
    dim as string ques
    dim as string word(10)
    dim as string text
    if t<20 then
        n=gethullspecs(t,"data/ships.csv")
    else
        n=gethullspecs(t-22,"data/customs.csv")
    endif
    for a=1 to 10
        if s.cargo(a).x>0 then cargobays=cargobays+1
        if s.weapons(a).desig<>"" then weapons=weapons+1
    next
    
    'compare
    if s.h_maxhull>n.h_maxhull then ques=ques &"The new ship will have a lower maximum armor capacity than your current one. "
    if s.engine>n.h_maxengine and s.engine<6 then ques=ques &"You will need to downgrade your engine for the new hull. "
    if s.shieldmax>n.h_maxshield then ques=ques &"You will need to downgrade your shield generators for the new hull."
    if s.sensors>n.h_maxsensors and s.sensors<6 then ques=ques &"You will need to downgrade your sensors for the new hull."
    if cargobays>n.h_maxcargo then ques=ques &"The new ship will have less cargo space. "
    if s.h_maxcrew>n.h_maxcrew then ques=ques &"The new ship will have less space for crewmen. "
    if s.h_maxweaponslot>n.h_maxweaponslot then ques=ques &"The new ship will have fewer weapon turrets. "
    if s.h_maxfuel>n.h_maxfuel then ques=ques &"The new ship will have a lower fuel capacity than your current one."
    if forced=1 then
        ques=""
        flg=-1
    endif
    if ques<>"" then
        rlprint ques,14 
        if askyn("Do you really want to transfer to the new hull?") then 
            flg=-1
        else
            flg=0
        endif
    else
        flg=-1
    endif
    if flg=-1 then
        s.ti_no=n.h_no
        if s.ti_no=18 then s.ti_no=17 'ASCS is one step lower
        if s.ti_no>18 then s.ti_no=9
        s.h_no=n.h_no
        s.h_price=n.h_price
        s.h_desig=n.h_desig
        s.h_sdesc=n.h_sdesc
        s.h_maxhull=n.h_maxhull
        s.h_maxengine=n.h_maxengine
        s.h_maxsensors=n.h_maxsensors
        s.h_maxshield=n.h_maxshield
        s.h_maxcargo=n.h_maxcargo
        s.h_maxcrew=n.h_maxcrew
        if s.engine<6 and s.engine>s.h_maxengine then s.engine=s.h_maxengine
        if s.sensors<6 and s.sensors>s.h_maxsensors then s.sensors=s.h_maxsensors
        if s.shieldmax>s.h_maxshield then s.shieldmax=s.h_maxshield
        
        s.h_maxweaponslot=n.h_maxweaponslot
        s.h_maxfuel=n.h_maxfuel
        if s.hull=0 then s.hull=s.h_maxhull*0.8
        if s.hull>s.h_maxhull then s.hull=s.h_maxhull
        if s.fuel=0 or s.fuel>s.h_maxfuel then s.fuel=s.h_maxfuel
        if s.h_maxweaponslot<weapons then
            poolandtransferweapons(n,s)
'            do
'                tfrom=(s.h_maxweaponslot -tto)
'                text="Chose weapons to transfer ("&tfrom &"):"
'                b=1
'                for a=1 to 10
'                    if s.weapons(a).desig<>"" then 
'                        text=text &"/"&s.weapons(a).desig
'                        b=b+1
'                    endif
'                next
'                text=text &"/Exit"
'                a=menu(text)
'                if a<b then
'                    tto=tto+1
'                    n.weapons(tto)=s.weapons(a)
'                    rlprint "Transfering "&s.weapons(a).desig &" to slot "&tto
'                    weapons=weapons-1
'                endif
'                if a=b then
'                    if not(askyn("Do you really want to lose your remaining weapons(y/n)?")) then a=0
'                endif
'            loop until a=b or tto=s.h_maxweaponslot
'            for a=0 to 10
'                s.weapons(a)=n.weapons(a)
'            next
        endif
        
        recalcshipsbays
        
        if s.security>s.h_maxcrew+player.crewpod+player.cryo then
            s.security=s.h_maxcrew
            for a=s.h_maxcrew+player.crewpod+player.cryo to 255
                crew(a)=d
            next
        endif
        s.fuelmax=s.h_maxfuel+s.fuelpod
    endif
    return flg
end function


function buy_ship(st as short,ds as string,pr as short) as short
    
    if paystuff(pr) then
        if st<>player.h_no then
            if upgradehull(st,player)=-1 then
                rlprint "you buy "&add_a_or_an(ds,0)&" hull"
                return -1
            else
                player.money=player.money+pr'Just returning the money
            endif             
        else
            rlprint "You already have that hull."
            player.money=player.money+pr'Just returning the money
        endif
    endif
    return 0
end function


function used_ships() as short
    dim as short yourshipprice,i,a,yourshiphull,price(8),l
    dim s as _ship
    dim as single pmod
    dim as string mtext,htext,desig(8)
    do
        yourshiphull=player.h_no
        s=gethullspecs(yourshiphull,"data/ships.csv")
        yourshipprice=s.h_price*.1
        mtext="Used ships (" &credits(yourshipprice)& " Cr. for your ship.)/"
        htext="/"
        for i=1 to 8
            pmod=(80-usedship(i).y*3)/100
            s=gethullspecs(usedship(i).x,"data/ships.csv")
            l=len(trim(s.h_desig))+len(credits(s.h_price*pmod))
            mtext=mtext &s.h_desig &space(45-l)&credits(s.h_price*pmod) &" Cr./"
            price(i)=s.h_price*pmod-yourshipprice
            desig(i)=s.h_desig
            htext=htext &makehullbox(s.h_no,"data/ships.csv") &"/"
        next
        mtext=mtext &"Bargain bin/Sell equipment/Exit"
        a=textmenu(bg_shiptxt,mtext,htext,2,2)
        if a>=1 and a<=8 then
            if buy_ship(a,desig(a),price(a)) then
                usedship(a).x=yourshiphull
                player.cursed=usedship(a).y
                usedship(a).y=0
            endif
        endif
        if a=9 then shop(30,0.8,"Bargain bin")
        if a=10 then buysitems("","",0,.5)
    loop until a=11 or a=-1        
    return 0
end function


function change_armor(st as short) as short
    dim as short a,i,price(5),e
    dim as string text,help
    for i=1 to 5
        price(i)=player.hull*i+max_hull(player)*(0.5+0.5*i)
    next
    if artflag(21)=2 then
        e=6
    else
        e=5
    endif
    text="Armor/"
    text=text &"Standard (" & price(1) & "Cr.)/"
    text=text &"Laminate (" & price(2) & "Cr.)/"
    text=text &"Nanocomposite (" & price(3) & "Cr.)/"
    text=text &"Diamonoid (" & price(4) & "Cr.)/"
    if artflag(21)=2 then text=text &"Neutron (" & price(5) & "Cr.)/"
    text=text &"Exit"
    help=help &"/Standard armor alloy.| "&player.h_maxhull*1 &" max armor, at " &player.h_maxhull*1^2 &" cost /"
    help=help &"Standard armor alloy, reinforced with carbon fibers.| "&player.h_maxhull*1.5 &" max armor, at "& player.h_maxhull*1.5^2 &" cost /"
    help=help &"Polymers, reinforced with carbon nanotubes.| "&player.h_maxhull*2 &" max armor, at "& player.h_maxhull*2^2 &" cost /"
    help=help &"Carbon arranged in a diamond like structure.| "&player.h_maxhull*2.5 &" max armor, at "& player.h_maxhull*2.5^2 &" cost /"
    if artflag(21)=2 then help=help &"Armor made out of pure neutronium.| "&player.h_maxhull*3 &" max armor, at "& player.h_maxhull*3^2 &" cost /"
    a=textmenu(bg_ship,text,help)
    if a>0 and a<e then
        if a=player.armortype then
            rlprint "You already have that armortype"
        else
            if paystuff(price(a)) then player.armortype=a
        endif
    endif
        
    return 0
end function


function ship_design(where as byte) as short
    dim as short ptval,pts,a,b,cur,f,maxweapon,st,ex
    dim as string component(10),key
    dim price(10) as short
    dim value(10) as short
    dim incr(10) as short
    dim h as _ship
    if tFile.Countlines("data/customs.csv")>20 then 
        rlprint "Too many designs in custom.csv. You need to delete one before you can add new ones"
        return 0
    endif
    
    component(1)="Hull "
    price(1)=150
    incr(1)=1
    component(2)="Shield "
    price(2)=100
    incr(2)=1
    component(3)="Engine "
    price(3)=50
    incr(3)=1
    component(4)="Sensors "
    price(4)=50
    incr(4)=1
    component(5)="Cargo "
    price(5)=200
    incr(5)=1
    component(6)="Crew "
    value(6)=5
    price(6)=100
    incr(6)=1
    component(7)="Weaponslots "
    price(7)=300
    incr(7)=1
    component(8)="Fuel "
    price(8)=10
    incr(8)=5
    if where=sy_blackmarket then
        a=textmenu(bg_awayteam,"Choose shiptype/Small Ship/Medium Ship/Big Ship/Huge Ship/Exit")
        ex=5
    else
        a=textmenu(bg_ship,"Choose shiptype/Small Ship/Medium Ship/Exit")
        ex=3
    endif
    if a>0 and a<ex then
        maxweapon=a+2
        st=a
        if a=1 then ptval=300
        if a=2 then ptval=450
        if a=3 then ptval=600
        if a=4 then ptval=750
        pts=ptval
        a=1
        do
            price(0)=0
            for a=1 to 8
                price(0)+=price(a)*value(a)
                if cur=a then
                    set__color( 15,5)
                else
                    set__color( 11,0)
                endif
                draw string(2*_FW2,(3+a)*_FH2),space(25),,FONT2,Custom,@_col
                draw string (3*_FW2,(3+a)*_FH2),component(a)&"("&value(a)&"):"&price(a) &"Cr.",,FONT2,CUSTOM,@_COL
            next
            set__color( 15,0)
            draw string(2*_FW2,2*_FH2),space(25),,FONT2,Custom,@_col
            draw string(2*_FW2,3*_FH2),space(25),,FONT2,Custom,@_col
            draw string(2*_FW2,3*_FH2),"Points("&ptval &"): "&pts,,FONT2,Custom,@_col
            draw string(2*_FW2,12*_FH2),space(25),,FONT2,Custom,@_col
            draw string(2*_FW2,13*_FH2),space(25),,FONT2,Custom,@_col
            draw string(2*_FW2,12*_FH2),"Price: "&price(0),,FONT2,Custom,@_col
            if cur=a then
                set__color( 15,5)
            else
                set__color( 11,0)
            endif
            draw string(2*_FW2,13*_FH2),space(25),,FONT2,Custom,@_col
            draw string(2*_FW2,13*_FH2),"Exit",,FONT2,Custom,@_col
            
            key=keyin(key_north &key_south &"+-"&key_west &key_east)
            if key=key_north then cur=cur-1
            if key=key_south then cur=cur+1
            if cur<1 then cur=9
            if cur>9 then cur=1
            if cur<9 then
                
                if key=key_east or key="+" then 
                    if (cur<>7 or value(cur)<maxweapon) or (cur=5 and value(cur)<11) then
                        if pts>=price(cur)*incr(cur)/10 then
                            pts=pts-price(cur)*incr(cur)/10
                            value(cur)+=incr(cur)
                        endif
                    endif
                endif
                if key=key_west or key="-" then 
                    if (cur<>6 and value(cur)>0) or (cur=6 and value(cur)>5) then
                        pts=pts+price(cur)*incr(cur)/10
                        value(cur)-=incr(cur)
                    endif
                endif
            endif
        loop until ptval=0 or key=key__esc or (cur=9 and key=key__enter)
        if askyn("Do you want to keep this ship design?(y/n)") then
            h.h_maxhull=value(1)
            h.h_maxengine=value(3)
            h.h_maxshield=value(2)
            h.h_maxsensors=value(4)
            h.h_maxcargo=value(5)
            h.h_maxcrew=value(6)
            h.h_maxweaponslot=value(7)
            h.h_maxfuel=value(8)
            h.h_price=price(0)
            h.h_desc=""&st
            draw string(2*_FW2,12*_FH2),"Design Name: ",,FONT2,Custom,@_col
            draw string(2*_FW2,13*_FH2),space(25),,FONT2,Custom,@_col
            h.h_desig =gettext(2,13,24,"")
            draw string(2*_FW2,12*_FH2),"Design Short:",,FONT2,Custom,@_col
            draw string(2*_FW2,13*_FH2),space(25),,FONT2,Custom,@_col
            h.h_sdesc =gettext(2,13,4,"")
            f=freefile
            open "data/customs.csv" for append as #f
            print #f,h.h_desig &";"& h.h_price &";"& h.h_maxhull &";"& h.h_maxshield &";"& h.h_maxengine &";"& h.h_maxsensors &";"& h.h_maxcargo &";"& h.h_maxcrew &";"& h.h_maxweaponslot &";"& h.h_maxfuel &";"& h.h_sdesc &";10;" & h.h_desc
            close #f
            rlprint "Ship design saved"
        endif
    endif
    set__color(11,0)
    cls
    return 0
end function


function custom_ships(where as byte) as short
    dim as string men,des,dummy
    dim as short i,c,ex,f,nos,a,last,v
    dim pr(20) as ushort
    dim ds(20) as string
    dim st(20) as short
    dim as _ship s
    do
        nos=-1
        nos=tFile.Countlines("data/customs.csv")-1
        men="Custom hulls/Build custom hull/Delete custom hull/"
        des="Nil///"
        a=3
        last=3
        if nos>=0 then
            for i=0 to nos
                s=gethullspecs(i,"data/customs.csv")
                v=val(s.h_desc)
                if where=sy_blackmarket or v<3 then
                    s.h_desc=s.h_desig
                    st(a)=a+20
                    pr(a)=s.h_price
                    ds(a)=s.h_desig
                    a+=1
                    men=men & s.h_desig & " - " &s.h_price  &"Cr./"
                    des=des &makehullbox(i,"data/customs.csv") &"/"
                    last=last+1
                endif
            next
        endif
        men=men &"Exit"
        c=textmenu(bg_parent,men,des)
        if c=1 then ship_design(where)
        if c=2 then delete_custom(where)
        if c>2 and c<last then
            if paystuff(pr(c)) then
                if st(c)<>player.h_no then
                    if upgradehull(st(c),player)=-1 then
                        rlprint "you buy "&add_a_or_an(ds(c),0)&" hull"
                    else
                        player.money=player.money+pr(c)
                    endif             
                else
                    rlprint "You already have that hull."
                    player.money=player.money+pr(c)
                endif
            endif
            display_ship
        endif

    loop until c=-1 or c=last
    return 0
end function


function ship_inspection(price as short) as short
    if paystuff(price) then
        if rnd_range(1,6) +rnd_range(1,6)>10-player.cursed then 'Heavily cursed stuff is easier to find. It gets harder to find the little stuff
            if player.cursed=0 then
                rlprint "Your ship is in excellent shape.",c_gre
            else
                player.cursed-=1
                rlprint "The inspection does reveal some minor flaws. Luckily they are quickly fixed.",c_yel
            endif
        else
            rlprint "Your ship is in excellent shape.",c_gre
        endif
    endif
    return 0
end function

function shipyard(where as byte) as short
    dim as short a,b,c,d,e,last,designshop,ex,armor,shipstart,shipstop,shipstep,inspection
    dim as string men,des
    dim s as _ship
    dim pr(20) as integer
    dim ds(20) as string
    dim st(20) as short
    men=shipyardname(where)&"/"
    des="/"
    a=1
    select case where
    case sy_military
        shipstart=2
        shipstop=12
        shipstep=2
    case sy_civil
        shipstart=1
        shipstop=11
        shipstep=2
    case sy_pirates
        shipstart=2
        shipstop=16
        shipstep=2
    case sy_blackmarket
        shipstart=12
        shipstop=16
        shipstep=1
    end select
    
    for b=shipstart to shipstop step shipstep
        s=gethullspecs(b,"data/ships.csv")
        st(a)=b
        pr(a)=s.h_price*haggle_("down")
        ds(a)=s.h_desig
        men=men & s.h_desig & space(_swidth-len(trim(s.h_desig))-len(credits(pr(a)))) &credits(pr(a)) &" Cr./"
        des=des &makehullbox(b,"data/ships.csv") &"/"
        a+=1
        last=last+1
    next
    
    men=men &"General overhaul"&space(_swidth-16-len(credits(player.h_price*.05))) & credits(player.h_price*.05) &" Cr./"
    des=des &"A thorough inspection, looking for any possible source of technical problems./"
    inspection=last+1
    last+=1
    if where=sy_pirates then 'Pirateplanet has no shipshop
        armor=last+1
        ex=last+2
    else
        men=men & "Design Hull/"
        des=des &"/"
        designshop=last+1
        armor=last+2
        ex=last+3
    endif
    
    men=men &"Change Armortype/"
    des=des &"Strip the current Armor off your ship, and replace with another type/"
    men=men &"Exit"
    des=des &"/"
    do 
        c=textmenu(bg_shiptxt,men,des)
        if c<last then buy_ship(st(c),ds(c),pr(c))
        if c=armor then change_armor(0)
        if c=designshop then custom_ships(where)
        if c=inspection then ship_inspection(player.h_price*0.05)
    loop until c=ex or c=-1
    set__color(11,0)
    cls
    return 0
end function


function missing_ammo() as short
    dim as short a,r
    for a=1 to 9
        if player.weapons(a).ammomax>0 and player.weapons(a).ammo<player.weapons(a).ammomax then
            r=r+player.weapons(a).ammomax-player.weapons(a).ammo
        endif
    next
    return r
end function


function change_loadout() as short
    dim as short ammo,i,ex,a
    dim as string text,help
    
    text="Ammunitions/"&ammotypename(0)&"   1 Cr./"&ammotypename(1)&"      4 Cr./"&ammotypename(2)&"      9 Cr./"&ammotypename(3)&"      16 Cr."
    help="/A dumb shell, no explosives, no propulsion. Damage is mainly done through impact. || Dam: 1 | Price: 1 Cr"
    help=help &"/Like the dumb shell, but with additional explosives|| Dam: 2 | Price: 4 Cr."
    help=help &"/A small nuclear warhead for space combat || Dam: 3 | Price: 9 Cr."
    help=help &"/A fusion bomb for space combat || Dam: 4 | Price: 16 Cr"
    if artflag(22)=2 then
        text=text &"/"&ammotypename(4)&"     25 Cr."
        help=help &"/Based on alien technology, this warhead seems to detonate space itself. || Dam: 5 | Price: 25 Cr"
        ex=6
    else
        ex=5
    endif
    text=text &"/Exit"
    
    a=textmenu(bg_ship,text,help)
    if a>0 and a<ex then
        if a=player.loadout+1 then
            rlprint "You already have that loadout"
        else
            player.loadout=a-1
            for i=1 to 9
                if player.weapons(i).ammo>0 then player.weapons(i).ammo=0
            next
            rlprint "Your loadout is now "&ammotypename(player.loadout) &"."
        endif
    endif
    
    return 0
end function

    
function shipupgrades(st as short) as short
    dim as short b,c,d,e,i
    dim mtext as string
    dim help as string
'    shopitem(1,20).desig="sensors MK I"
'    shopitem(1,20).price=200
'    shopitem(1,20).v1=1
'    shopitem(1,20).ty=50
'    shopitem(1,20).ldesc="Basic ship sensor set. 1 Parsec Range" 
'    
'    shopitem(2,20).desig="sensors MK II"
'    shopitem(2,20).price=800
'    shopitem(2,20).v1=2
'    shopitem(2,20).v4=1
'    shopitem(2,20).ty=50
'    shopitem(2,20).ldesc="Basic ship sensor set. 2 Parsec Range" 
'    
'    shopitem(3,20).desig="Sensors MK III"
'    shopitem(3,20).price=1600
'    shopitem(3,20).v1=3
'    shopitem(3,20).ty=50
'    shopitem(3,20).ldesc="Ship sensor set. 3 Parsec Range" 
'        
'    shopitem(4,20).desig="sensors MK IV"
'    shopitem(4,20).price=3200
'    shopitem(4,20).v1=4
'    shopitem(4,20).ty=50
'    shopitem(4,20).ldesc="Advanced ship sensor set. 4 Parsec Range" 
'    
'    shopitem(5,20).desig="sensors MK V"
'    shopitem(5,20).price=6400                        
'    shopitem(5,20).ty=50
'    shopitem(5,20).v1=5
'    shopitem(5,20).ldesc="Advanced ship sensor set. 5 Parsec Range" 
'    

    help=help &"Change type of ammo used for missile weapons."
    do 
        c=textmenu(bg_parent,"Ship Upgrades:/Sensors,Shields & Engines/Weapons & Modules/Change Loadout/Change Armortype/Exit")
'            mtext="Sensors/" 
'            for i=1 to 15
'                mtext=mtext &shopitem(i,20).desig &space(_swidth-len(trim(shopitem(i,20).desig))-len(credits(shopitem(i,20).price))) &credits(shopitem(i,20).price) &" Cr./"
'            next
'            mtext=mtext &"Exit"
'            do
'            d=menu(bg_parent,mtext,help)
'                    
'            display_ship
'            if d<>-1 then
'                if d>0 and d<13 then
'                    if player.money>=shopitem(d,20).price then
'                        if shopitem(d,20).ty=50 then
'                            if shopitem(d,20).v1>player.h_maxsensors then rlprint "Your ship is too small for those."
'                            if shopitem(d,20).v1<player.sensors then rlprint "You already have better sensors."
'                            if shopitem(d,20).v1=player.sensors then rlprint "That is the same as your current sensor system."
'                            if shopitem(d,20).v1>player.sensors and shopitem(d,20).v1<=player.h_maxsensors then
'                                player.sensors=shopitem(d,20).v1
'                                paystuff(shopitem(d,20).price)
'                                rlprint "You buy "&shopitem(d,20).desig &"."
'                            endif
'                        endif
'                        if shopitem(d,20).ty>50 and shopitem(d,20).ty<53 then
'                            if findbest(shopitem(d,20).ty,-1)<0 then
'                                placeitem(shopitem(d,20),0,0,0,0,-1)
'                                paystuff(shopitem(d,20).price)
'                                rlprint "You buy "&shopitem(d,20).desig &"."
'                            else
'                                if item(findbest(shopitem(d,20).ty,-1)).v1<shopitem(d,20).v1 then
'                                    rlprint "You already have a better "&shopitem(d,20).desig &"."
'                                else
'                                    rlprint "You already have "&add_a_or_an(shopitem(d,20).desig,0) &"."
'                                endif
'                            endif
'                        endif
'                        if shopitem(d,20).ty=53 then
'                            if shopitem(d,20).v1<player.ecm then rlprint "you already have a better ECM system."
'                            if shopitem(d,20).v1=player.ecm then rlprint "That is the same as your current ECM system."
'                            if shopitem(d,20).v1>player.ecm then 
'                                player.ecm=shopitem(d,20).v1
'                                paystuff(shopitem(d,20).price)
'                                rlprint "You buy "&shopitem(d,20).desig &"."
'                            endif
'                        endif
'                        if shopitem(d,20).ty=54 then
'                            if shopitem(d,20).v1<player.shieldedcargo then rlprint "you already have a better cargo shielding."
'                            if shopitem(d,20).v1=player.shieldedcargo then rlprint "That is the same as your current cargo shielding."
'                            if shopitem(d,20).v1>player.shieldedcargo then 
'                                player.shieldedcargo=shopitem(d,20).v1
'                                paystuff(shopitem(d,20).price)
'                                rlprint "You buy "&shopitem(d,20).desig &"."
'                            endif
'                        endif
'                    else
'                        rlprint "You don't have enough money."
'                    endif
'                endif
'            endif
'            display_ship()
'            loop until d=-1 or d=16
'            for b=0 to lastitem
'                if item(b).ty=50 then
'                    item(b)=item(lastitem)
'                    lastitem=lastitem-1
'                endif
'            next
'            display_ship()
'        endif
'            
'            if c=2 then 'Shields
'                do
'                    d=menu(bg_parent,"Shields:/ Shields MKI   -  300 Cr/ Shields MKII  - 1200 Cr/ Shields MKIII - 2700 Cr/ Shields MKIV  - 4800 Cr/ Shields MKV   - 7500 Cr/ Exit")
'                    if d<6 and d<=player.h_maxshield then
'                        if d<player.shieldmax then rlprint "you already have better shields"
'                        if d=player.shieldmax then rlprint "You already have this shieldgenerator"
'                        if d>player.shieldmax and d<6 then
'                            if paystuff(d*d*300) then
'                                player.shieldmax=d
'                                rlprint "You upgrade your shields"
'                                d=6
'                            endif
'                        endif
'                    else
'                        if d<6 then rlprint "That shieldgenerator doesnt fit in your hull"
'                    endif
'                    display_ship()
'                loop until d=6
'                
'            endif
'                   
            if c=1 then shop(20,1,"Sensors, Shields & Engines")
            if c=2 then buy_weapon(st)
            if c=3 then change_loadout
            if c=4 then change_armor(0)
            display_ship()
        loop until c=5 or c=-1
    return 0
end function

function buy_engine() as short
    dim as string metxt,hetxt
    dim as string iname(10),ihelp(10)
    dim as short iprice(10),d,i
    iname(1)="Engine MKI"
    iprice(1)=300
    iname(2)="Engine MKII"
    iprice(2)=1200
    iname(3)="Engine MKIII"
    iprice(3)=2700
    iname(4)="Engine MKIV"
    iprice(4)=4800
    iname(5)="Engine MKV" 
    iprice(5)=7500
    iname(6)="AT Landing Gear"
    iprice(6)=250
    iname(7)="Imp. AT Landing Gear"
    iprice(7)=500
    iname(8)="Maneuverjets MKI"
    iprice(8)=250
    iname(9)="Maneuverjets MKII"
    iprice(9)=500
    iname(10)="Maneuverjets MKIII"
    iprice(10)=1000
    metxt="Engine:"
    for i=1 to 10
        iprice(i)=iprice(i)*haggle_("down")
        metxt &="/"&iname(i) &space(_swidth-len(iname(i))-len(credits(iprice(i)))) &credits(iprice(i)) &" Cr."
    next
    metxt &="/Exit"
    do
        hetxt="/"
        for i=1 to 5
            hetxt=hetxt &iname(i) &"||"
            if i<player.engine then hetxt=hetxt &"You already have a better engine now"
            if i=player.engine then hetxt=hetxt &"This is the same engine as you have now."
            if i>player.engine then hetxt=hetxt &"With this engine you would have " & int(i+2-player.h_maxhull\15) & " movement points."
            if i>player.h_maxengine then hetxt &= "|This engine is too big for your ship."
            hetxt &="/"
        next
        hetxt &="special landing struts designed to make landing in all kinds of terrain easier/Special landing struts designed to make landing in all kinds of terrain easier."
        hetxt &="/Adds 1 pt to movement"
        if player.manjets=1 then hetxt &="|You already have these maneuvering jets."
        hetxt &="/Add 2 pts to movement"
        if player.manjets=2 then hetxt &="|You already have these maneuvering jets."
        hetxt &="/Adds 3 pts to movement"
        if player.manjets=3 then hetxt &="|You already have these maneuvering jets."
    
        d=textmenu(bg_parent,metxt,hetxt)
        if d<6 and d<=player.h_maxengine then
            if d<player.engine then rlprint "You already have a better engine."
            if d=player.engine then rlprint "You already have this engine."
            if d>player.engine and d<6 then
                if paystuff(iprice(d)) then
                    player.engine=d
                    rlprint "You upgrade your engine."
                    display_ship()
                    d=6
                endif
            endif
        else
            if d<6 then rlprint "That engine doesn't fit in your hull."
            if d=6 then 
                if paystuff(250) then
                    rlprint "You buy all terrain landing gear."
                    placeitem(make_item(75),,,,,-1)
                endif
            endif
            if d=7 then 
                if paystuff(500) then
                    rlprint "You buy improved all terrain landing gear."
                    placeitem(make_item(76),,,,,-1)
                endif
            endif
            
            
            
            if d=8 then
                if paystuff(250) then
                    if player.manjets<1 then
                        rlprint "You buy Maneuver Jets I."
                        player.manjets=1
                    else
                        if player.manjets>1 then rlprint "you alrealdy have better maneuvering jets."
                        if player.manjets=1 then rlprint "you alrealdy have these maneuvering jets."
                        player.money=player.money+250 'Just returning money
                    endif
                endif
            endif
            
            if d=9 then
                if paystuff(500) then
                    if player.manjets<2 then
                        rlprint "You buy Maneuver Jets II."
                        player.manjets=2
                    else
                        if player.manjets>2 then rlprint "you alrealdy have better maneuvering jets."
                        if player.manjets=2 then rlprint "you alrealdy have these maneuvering jets."
                        player.money=player.money+500 'returning money
                    endif
                endif
            endif
            
            if d=10 then
                if paystuff(1000) then
                    if player.manjets<3 then
                        rlprint "You buy Maneuver Jets III."
                        player.manjets=3
                    else
                        if player.manjets>3 then rlprint "you alrealdy have better maneuvering jets."
                        if player.manjets=3 then rlprint "you alrealdy have these maneuvering jets."
                        player.money=player.money+1000 'Returning money
                    endif
                endif
            endif
        endif
    loop until d=11
    return 0
end function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tShipyard -=-=-=-=-=-=-=-
	tModule.register("tShipyard",@tShipyard.init()) ',@tShipyard.load(),@tShipyard.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tShipyard -=-=-=-=-=-=-=-
#endif'test
