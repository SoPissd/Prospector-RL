'tStockmarket

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
                shares(lastshare).bought=gameturn
                shares(lastshare).lastpayed=gameturn
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
        a=menu(bg_parent,text,"",2,2)
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
        if shares(a).company>0 and shares(a).lastpayed<=gameturn-3*30*24*60 then '3 months
            payout(shares(a).company)=payout(shares(a).company)+companystats(shares(a).company).rate/100
            shares(a).lastpayed=gameturn
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
        a=menu(bg_stock,"/Buy/Sell/Exit","",2,12)
        if a=1 then
            b=menu(bg_parent,text &"/Exit",,2,2)
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
    screenset 1,1
    check_tasty_pretty_cargo
    if st<3 then
        do
            set__color(11,0)
            a=menu(bg_trading+st," /Buy/Sell/Price development/Stock Market/Exit",,2,14)
            if a=1 then buygoods(st)
            if a=2 then sellgoods(st)
            if a=3 then showprices(st)
            if a=4 then stockmarket(st)
        loop until a=5
    else
        do
            set__color(11,0)
            if st<>10 then a=menu(bg_trading+st," /Buy/Sell/Exit",,2,14,,st)
            if st=10 then a=menu(bg_trading+st," /Plunder/Leave behind/Exit",,2,14)
            if a=1 then buygoods(st)
            if a=2 then sellgoods(st)
        loop until a=3
    endif
    set__color(11,0)
    cls
    return 0
end function


