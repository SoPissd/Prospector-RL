'tMenu.
'
'defines:
'menu=12
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tMenu -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tMenu -=-=-=-=-=-=-=-

declare function menu(_
		bg as short,te as string, he as string="", x as short=2, y as short=2, _
	    blocked as short=0, markesc as short=0,st as short=-1,loca as short=1) as short


Dim Shared _last_title_pic As Byte=14

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tMenu -=-=-=-=-=-=-=-

namespace tMenu
function init() as Integer
	return 0
end function
end namespace'tMenu


#define cut2top


function menu(bg as short,te as string, he as string="", x as short=2, y as short=2, _
	          blocked as short=0, markesc as short=0,st as short=-1,loca as short=0) as short
    ' 0= headline 1=first entry
    dim as short blen
    dim as string text,help
    dim as string bgname
    dim lines(256) as string
    dim helps(256) as string
    dim shrt(256) as string
    dim as string key,delhelp
    dim a as short
    dim b as short
    dim c as short
    'static loca as short
    'dim loca as short
    dim e as short
    dim l as short
    dim hfl as short
    dim hw as short
    dim lastspace as short
    dim tlen as short
    dim longest as short
    dim as short ofx,l2,longestbox,longesthelp,backpic,offset

    if bg<0 then
	    backpic=-bg
	    bg=bg_title
    else
	    backpic=rnd_range(1,_last_title_pic)
    endif
    
    dim as any ptr logo
    if bg=bg_title then
        logo= bmp_load("graphics/prospector.bmp")
    endif
    
    text=te
    help=he
    b=len(text)
    text=text &"/"
    c=0
    do
        tlen=instr(text,"/")
        lines(c)=left(text,tlen-1)
        text=mid(text,tlen+1)
        c=c+1
    loop until len(text)<=0
    c=c-1
    
    if help<>"" then
        if right(help,len(help)-1)<>"/" then help=help &"/"
        hfl=1
        e=0
        b=len(help)
        do
            tlen=instr(help,"/")
            helps(e)=left(help,tlen-1)
            'if len(helps(e))>len(delhelp) then delhelp=space(len(helps(e)))
            help=mid(help,tlen+1)
            e=e+1
        loop until len(help)<=0
        e=0
    endif
    
    if loca>c then loca=c
    b=0
    for a=0 to c
        shrt(a)=chr(96+b+a)
        if getdirection(lcase(shrt(a)))>0 or getdirection(lcase(shrt(a)))>0 or val(shrt(a))>0 or ucase(shrt(a))=ucase(key_awayteam) then
            do 
                b+=1
                shrt(a)=chr(96+b+a)
            loop until getdirection(lcase(shrt(a)))=0 and getdirection(shrt(a))=0 and val(shrt(a))=0
        endif
        if len(trim(lines(a)))>longest then longest=len(trim(lines(a)))
    next
    
    for a=0 to c
        lines(a)=lines(a)&space(longest-len(lines(a)))
    next
    hw=_mwx*_fw1-((longest)*_fw2)-(3+x)*_fw1
    hw=hw/_fw2
    
    for a=0 to c
        longesthelp=1
        l2=textbox(helps(a),ofx,2,hw,15,1,,longesthelp)
        if l2>longestbox then longestbox=l2
    next
    
    if longestbox>20 or (longestbox/hw)>2 or hw<8 then
        hw=tScreen.x-((4+x)*_fw1)-((longest)*_fw2)
        hw=hw/_fw2
    endif
    'if hw>longesthelp then hw=longesthelp
    ofx=x+4+(longest*_fw2/_fw1)
    e=0
    do        
        if bg<>bg_noflip then
            tScreen.set(0)
            set__color(15,0)
            cls
            select case bg
            case bg_title
           		background(backpic &".bmp")
                if logo<>NULL then
                    put (39,69),logo,trans
                else
                    draw string(26,26),"PROSPECTOR",,titlefont,custom,@_col
                endif
            case bg_ship
                display_ship
            case bg_shiptxt
                display_ship
                rlprint ""
            case bg_shipstars
                display_stars(1)
                display_ship
            case bg_shipstarstxt
                display_stars(1)
                display_ship
                rlprint ""
            case bg_awayteam
                display_awayteam(0)
            case bg_awayteamtxt
                display_awayteam(0)
                rlprint ""
            case bg_randompic
                background(backpic &".bmp")
            case bg_randompictxt
                background(backpic &".bmp")
                rlprint ""
            case bg_stock
                display_ship
                tCompany.display_stock
                tCompany.portfolio(17,2)
                rlprint ""
            case bg_roulette
                drawroulettetable
                display_ship
                rlprint ""
            case is>=bg_trading
                display_ship()
                displaywares(bg-bg_trading)
            end select
        endif
        set__color( 15,0)
        draw string(x*_fw1,y*_fh1), lines(0)&space(3),,font2,custom,@_col
        
        for a=1 to c
            if loca=a then 
                if hfl=1 and loca<=c and helps(a)<>"" then blen=textbox(helps(a),ofx,2,hw,15,1,,,offset)
                set__color( 15,5)
            else
                set__color( 11,0)
            endif
            draw string(x*_fw1,y*_fh1+a*_fh2),shrt(a) &") "& lines(a),,font2,custom,@_col
        next
        
        if bg<>bg_noflip then 
            tScreen.update()
        else
            rlprint ""
        endif

		tConsole.ClearKeys
        if player.dead=0 then key=keyin(,96+c)
        
        if hfl=1 then 
            for a=1 to blen
                set__color( 0,0)
                draw string(ofx*_fw1,y*_fh1+(a-1)*_fh2), space(hw),,font2,custom,@_col
            next
        endif
        if getdirection(key)=8 then loca=loca-1
        if getdirection(key)=2 then loca=loca+1
        if help<>"" then
            if key="+" then offset+=1
            if key="-" then offset-=1
        endif
        if loca<1 then loca=c
        if loca>c then loca=1
        if key=key__enter then e=loca
        for a=0 to c
            if key=lcase(shrt(a)) then loca=a
        next
'        if player.dead<>0 then e=c
'        if key=key__esc then e=-27
        if key=key__esc or player.dead<>0 then e=c
    loop until e>0 
    if key=key__esc and markesc=1 then e=-asc(key__esc)
    set__color( 0,0)
    for a=0 to c
        locate y+a,x
        draw string(x*_fw1,y*_fh1+a*_fh2), space(59),,font2,custom,@_col
    next
    set__color( 11,0)
    cls
    tScreen.set(1)
    if logo <> 0 then
      ImageDestroy(Logo)
    EndIf
'	ClearKeys()
'? #fErrOut,e
    return e
end function
#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tMenu -=-=-=-=-=-=-=-
	tModule.register("tMenu",@tMenu.init()) ',@tMenu.load(),@tMenu.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tMenu -=-=-=-=-=-=-=-
#endif'test
