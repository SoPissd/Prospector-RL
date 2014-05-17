'tTrading.
'
'defines:
'check_tasty_pretty_cargo=3, merchant=27, station_goods=0, getfreecargo=0,
', displaywares=1, buygoods=2, cargobay=3, getinvbytype=3,
', get_invbay_bytype=0, sellgoods=3, showprices=1, buysitems=9
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
'     -=-=-=-=-=-=-=- TEST: tTrading -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tTrading -=-=-=-=-=-=-=-

declare function check_tasty_pretty_cargo() as short
declare function merchant() as single
declare function displaywares(st as short) as short
declare function buygoods(st as short) as short
declare function cargobay(text as string,st as short,sell as byte=0) as string
declare function getinvbytype(t as short) as short
declare function sellgoods(st as short) as short
declare function showprices(st as short) as short
declare function buysitems(desc as string,ques as string, ty as short, per as single=1,aggrmod as short=0) as short

'private function station_goods(st as short, tb as byte) as string
'private function getfreecargo() as short
'private function get_invbay_bytype(t as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tTrading -=-=-=-=-=-=-=-

namespace tTrading
function init(iAction as integer) as integer
	return 0
end function
end namespace'tTrading


#define cut2top




function check_tasty_pretty_cargo() as short
    dim as short freebay
    freebay=getnextfreebay
    if freebay>0 then
        if reward(rwrd_pretty)>=100 then
            rlprint "You have collected enough beautiful animal parts to produce a cargo ton of luxury items"
            if askyn("Do you want to do so?(y/n)") then
                reward(rwrd_pretty)-=100
                player.cargo(freebay).x=4
                player.cargo(freebay).y=0
                freebay=getnextfreebay
            endif
        endif
    endif
    
    if freebay>0 then
        if reward(rwrd_tasty)>=100 then
            rlprint "You have collected enough tasty animal parts to produce a cargo ton of food!"
            if askyn("Do you want to do so?(y/n)") then
                reward(rwrd_tasty)-=100
                player.cargo(freebay).x=2
                player.cargo(freebay).y=0
            endif
        endif
    endif
return 0
end function

'

function merchant() as single
    dim as single m
    m=(70+5*crew(1).talents(6))/100
    if m>0.9 then merchant=0.9
    return m
end function


function station_goods(st as short, tb as byte) as string
    dim as string text,pl,LR
    dim a as short
    dim off as short
    if tb=0 then 'Textbox or menu
        LR="/"
        text=space(25)&"Buy        Sell"&LR
    else
        LR="|"
        
        text="{15}"&space(25)&"Buy        Sell"&LR &"{11}"
    endif
    for a=1 to 9
        if tb=1 then text=text &"   "
        text=text & trim(goodsname(a))&space(17-len(trim(goodsname(a)))) 
        pl=""& credits(basis(st).inv(a).p) &" Cr."
        text=text & space(12-len(pl))
        text=text & pl
        
        pl=""& credits(cint(basis(st).inv(a).p*merchant))&" Cr."
        text=text & space(12-len(pl))
        text=text & pl &space(4)
        if basis(st).inv(a).v>=10 then
            text=text & basis(st).inv(a).v
        else
            text=text & " "& basis(st).inv(a).v
        endif
        text=text & LR
    next
    if tb=0 then text=text & "Exit"
    return text
end function



function getfreecargo() as short
    dim re as short
    dim a as short
    for a=1 to 10
        if player.cargo(a).x=1 then re=re+1
    next
    return re
end function


function displaywares(st as short) as short
    textbox(station_goods(st,1),2,3,(_mwx*_fw1-4*_fw1)/_fw2)
'    dim a as short
'    dim t as string
'    dim as single pricelevel,merchant
'    pricelevel=basis(st).pricelevel
'    merchant=(80+5*crew(1).talents(6))/100
'    if merchant>pricelevel then merchant=pricelevel-0.05
'    set__color( 15,0 )
'    draw string (2*_fw1,2*_fh1),"Wares",,font2,custom,@_col
'    draw string (2*_fw1+22*_fw2,2*_fh1),"Price",,font2,custom,@_col
'    draw string (2*_fw1+35*_fw2,2*_fh1),"Qut.",,font2,custom,@_col
'    draw string (2*_fw1+17*_fw2,2*_fh1+_fh2),"Buy",,font2,custom,@_col
'    draw string (2*_fw1+25*_fw2,2*_fh1+_fh2),"Sell",,font2,custom,@_col
'    for a=1 to 9
'        set__color( 11,0)
'        draw string(2*_fw1+3*_fw2,3*_fh1+a*_fh2),basis(st).inv(a).n,,font2,custom,@_col
'        draw string(2*_fw1+18*_fw2,3*_fh1+a*_fh2),credits(int(basis(st).inv(a).p*pricelevel)),,font2,custom,@_col
'        draw string(2*_fw1+26*_fw2,3*_fh1+a*_fh2),credits(int(basis(st).inv(a).p*merchant)),,font2,custom,@_col
'        if basis(st).inv(a).v<10 then
'            draw string(2*_fw1+34*_fw2,3*_fh1+a*_fh2)," "& basis(st).inv(a).v,,font2,custom,@_col
'        else
'            draw string(2*_fw1+34*_fw2,3*_fh1+a*_fh2),""& basis(st).inv(a).v,,font2,custom,@_col
'        endif
'    next
    
    return 0
end function


function buygoods(st as short) as short
    dim a as short
    dim c as short
    dim m as short
    dim d as short
    dim p as short
    dim f as short
    dim text as string
    
    text=station_goods(st,0)
    set__color(11,0)
    c=textmenu(bg_ship,text,"",2,3)
    if c<10 then
        m=basis(st).inv(c).v
        if basis(st).inv(c).v>0 then
            if m>getfreecargo() then m=getfreecargo
            if m>0 then
                display_ship
                displaywares(st)
                if st<>10 then rlprint "how many tons of "& goodsname(c) &" do you want to buy?"
                if st=10 then rlprint "how many tons of "& goodsname(c) &" do you want to transfer?"
                d=getnumber(0,m,0)
                p=basis(st).inv(c).p
                if d>0 and d<=m then 
                    if paystuff(p*d) then
                        for a=1 to d
                            f=getnextfreebay
                            player.cargo(f).x=c+1
                            player.cargo(f).y=p
                        next
                        if d=1 then 
                            if st=10 then
                                rlprint "You transfer a ton of "& goodsname(c) &"."
                            else
                                rlprint "You buy a ton of "& goodsname(c) &" for "& credits(p*d) &" Cr."
                            endif
                        endif
                        if d>1 then
                            if st=10 then
                                rlprint "You transfer "& d & " tons of "& goodsname(c) &"."
                            else
                                rlprint "You buy "& d & " tons of "& goodsname(c) &" for "& credits(p*d) &" Cr."
                            endif
                        endif
                        basis(st).inv(c).v=basis(st).inv(c).v-d
                    endif
                endif
            else
                rlprint "No room for additional cargo.",14
                no_key=keyin
            endif
        endif
    endif
    display_ship
    return 0
end function


function cargobay(text as string,st as short,sell as byte=0) as string
    dim a as short
    
    for a=1 to 10        
        if player.cargo(a).x=1  then text=text &"Empty/"
        if player.cargo(a).x>1 and player.cargo(a).x<=10 then
            text=text & goodsname(player.cargo(a).x-1) &" for " &credits(cint(basis(st).inv(player.cargo(a).x-1).p*merchant)) &" Cr.," 
            if player.cargo(a).y=0 then
                text=text &" found/"
            else
                text=text & " bought at " &credits(player.cargo(a).y) &" Cr./"
            endif
        endif
        if player.cargo(a).x=11 then text=text &"Sealed Box/"
        if player.cargo(a).x=12 then text=text &"TriaxTraders Cargo/"
    next
    if sell=1 then
        text=text &"Sell all/"
    endif
    text=text &"Exit"
    return text
end function


function getinvbytype(t as short) as short
    dim a as short
    dim r as short
    t=t+1
    for a=1 to 10
        if player.cargo(a).x=t then
            r=r+1
        endif
    next
    return r
end function


function get_invbay_bytype(t as short) as short
    dim as short a
    for a=1 to 10
        if player.cargo(a).x=t+1 then return a
    next
    return -1
end function


function sellgoods(st as short) as short
    dim text as string
    dim a as short
    dim b as short
    dim c as short
    dim em as short
    dim sold as short
    dim m as short
    dim as short mt,bay,ct,i    
    
    
    do
        if st=10 then
            text=cargobay("Leave behind:/",10,1)
        else
            text=cargobay("Sell:/",st,1)
        endif
        b=0
        em=0
        for a=1 to 25
            if player.cargo(a).x>=1 then b=b+1
            if player.cargo(a).x>1 then em=em+1
        next
        set__color(11,0)
        if em>0 then
            c=textmenu(bg_trading+st,text,,2,14)
            if c>0 and c<=b then
                if player.cargo(c).x>1 and player.cargo(c).x<25 then
                    ct=player.cargo(c).x-1
                    m=getinvbytype(ct) ' wie viele insgesamt
                    if player.cargo(c).x<=10 then
                        if st<>10 then 
                            rlprint "how many tons of "& goodsname(ct) &" do you want to sell?"
                        else
                            rlprint "how many tons of "& goodsname(ct) &" do you want to leave behind?"
                        endif
                        sold=getnumber(0,m,0)
                        if sold>0 then
                            for i=1 to sold
                                bay=get_invbay_bytype(ct)
                                rlprint "Unloading " & goodsname(ct) &" in bay "& bay &"."
                                if player.cargo(bay).y=0 then
                                    addmoney(basis(st).inv(ct).p*merchant,mt_piracy)
                                else
                                    addmoney(basis(st).inv(ct).p*merchant,mt_trading)
                                endif
                                basis(st).inv(ct).v=basis(st).inv(ct).v+1
                                player.cargo(bay).x=1
                                player.cargo(bay).y=0
                            next
                            if st<>10 then rlprint "Sold " & sold & " tons of " & goodsname(Ct) & " for " & cint(basis(st).inv(ct).p*sold*merchant) &" Cr."
                            'removeinvbytype(player.cargo(c).x-1,sold)
                            'no_key=keyin
                            'c=b+1
                        endif
                    endif
                endif
            endif
        else
            c=-1
        endif
        if em=0 then rlprint "Your cargo bays are empty.",c_yel
        if c=b+1 then
            if askyn("Do you really want to sell all?(y/n)") then
                for i=1 to 10
                    if player.cargo(i).x>1 and player.cargo(i).x<10  then
                        ct=player.cargo(i).x-1
                        if player.cargo(i).y=0 then
                            addmoney(basis(st).inv(ct).p*merchant,mt_piracy)
                        else
                            addmoney(basis(st).inv(ct).p*merchant,mt_trading)
                        endif
                        rlprint "You sell a ton of "& goodsname(ct) &" for "&credits(basis(st).inv(ct).p*merchant) &" Cr."
                        player.cargo(i).x=1
                        player.cargo(i).y=0
                    else
                        if player.cargo(i).x>1 then rlprint "Can't sell cargo in bay "&i &".",c_yel
                    endif
                next
            endif
        endif
    loop until c>=b+2 or c=-1 or em=0
    display_ship
    return 0
end function


function showprices(st as short) as short
    dim as short a,b,sHighest,relhigh(9),sRelative
    do
        sHighest=0
        for a=0 to 9
            relhigh(a)=0
        next
        set__color(11,0)
        cls
        set__color( 11,0)
        for a=0 to 9
        set__color( a+8,0)
        if a=0 then 
            set__color( 11,0)
            draw string (0,a*_fh2),"Time :",,font2,custom,@_col
        else
            draw string (0,a*_fh2),goodsname(a) &":",,font2,custom,@_col
        endif
        b=0
        draw string ((b*5)*_fw2+15*_fw2,a*_fh2),display_time(goods_prices(a,b,st),2),,font2,custom,@_col
        for b=1 to 11
            draw string ((b*5)*_fw2+15*_fw2,a*_fh2),credits(goods_prices(a,b,st)),,font2,custom,@_col
            if goods_prices(a,b,st)>relhigh(a) then relhigh(a)=goods_prices(a,b,st)
            if goods_prices(a,b,st)>sHighest then sHighest=goods_prices(a,b,st) 
        next
    next
    if sRelative=0 then
        for a=1 to 9
            for b=0 to 10
                set__color( a+8,0)
                line (b*(5*_fw2)+15*_fw2,(sHighest-goods_prices(a,b,st))/20+20*_fh2+a)-((b+1)*(5*_fw2)+15*_fw2,(sHighest-goods_prices(a,b+1,st))/20+20*_fh2+a)
            next
            draw string (0,(sHighest-goods_prices(a,0,st))/21+20*_fh2+a*2),goodsname(a) &":",,font2,custom,@_tcol
            
        next
    else
        for a=1 to 9
            for b=0 to 10
                set__color( a+8,0)
                line (b*(5*_fw2)+15*_fw2,(goods_prices(a,b,st)/relhigh(a))*50+20*_fh2+a)-((b+1)*(5*_fw2)+15*_fw2,(goods_prices(a,b+1,st)/relhigh(a))*50+20*_fh2+a)
            next
            draw string (0,(goods_prices(a,0,st))/relhigh(a)*50+20*_fh2+a*2),goodsname(a) &":",,font2,custom,@_tcol
            
        next

    endif
    rlprint "a: absolute, r: sRelative, esq to quit."
    no_key=keyin
    if no_key="a" then sRelative=0
    if no_key="r" then sRelative=1
    loop until no_key=key__esc
    return 0
end function


function buysitems(desc as string,ques as string, ty as short, per as single=1,aggrmod as short=0) as short
    dim as integer a,b,answer,price,really
    dim text as string
    if configflag(con_autosale)=0 then 
        rlprint desc & " (autoselling on)"
    else
        rlprint desc & " (autoselling off)"
    endif
    if ques<>"" then
        answer=askyn(ques)
    else
        answer=-1
    endif
    if answer=-1 then
        if configflag(con_autosale)=1 or ty=0 then
            do
                set__color(11,0)
                cls
                a=get_item()
                if a>0 then 
                    if (item(a).ty=ty or ty=0) and item(a).w.s<0  then
                        if item(a).ty<>26 then
                            price=cint(item(a).price*per)
                        else
                            price=cint(item(a).v1*25*per)
                        endif
                        if configflag(con_autosale)=1 or b=0 then b=askyn("Do you want to sell the "&item(a).desig &" for "& price &" Cr.?(y/n)")             
                        if item(a).w.s=-2 and b=-1 then b=askyn("The "&item(a).desig &" is in use. do you really want to sell it?(y/n)")
                        if b=-1 then    
                            rlprint "you sell the "&item(a).desig &" for " &price & " Cr."
                            addmoney(price,mt_trading)
                            reward(2)=reward(2)-item(a).v5               
                            factionadd(0,1,item(a).price/disnbase(player.c)/100*aggrmod)
                            factionadd(0,2,-item(a).price/disnbase(player.c)/100*aggrmod)
                            destroyitem(a)    
                            b=0
                        endif
                    endif
                endif
            loop until a<0
        else            
            for a=0 to lastitem
                if item(a).ty<>26 then
                    price=cint(item(a).price*per)
                else
                    price=cint(item(a).v1*50*per)
                endif
                if item(a).ty=ty and item(a).w.s=-1 then
                    text=text &"You sell the "&item(a).desig &" for "& price & " Cr. "
                    addmoney(price,mt_trading)
                    if item(a).ty=15 then reward(2)=reward(2)-item(a).v5                        
                    factionadd(0,1,item(a).price/disnbase(player.c)/100*aggrmod)
                    factionadd(0,2,-item(a).price/disnbase(player.c)/100*aggrmod)
                    destroyitem(a)
                endif
            next
            if text<>"" then
                rlprint text
            else
                rlprint "You couldn't sell anything."
            endif
            
        endif
    endif
    return 0
end function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tTrading -=-=-=-=-=-=-=-
	tModule.register("tTrading",@tTrading.init()) ',@tTrading.load(),@tTrading.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tTrading -=-=-=-=-=-=-=-
#endif'test
