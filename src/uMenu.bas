'uMenu.
'
'defines:
'menu=12
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
'     -=-=-=-=-=-=-=- TEST: uMenu -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

Type uMenu
  declare constructor()
  declare destructor()
  declare function go(bg as short,te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1,loca as short=0) as short
  declare function init() as short
  declare function before() as short
  declare function after() as short
  declare function finish() as short
Private:
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
    '
    dim bg as short
    dim te as string 
    dim he as string="" 
    dim x as short=2 
    dim y as short=2 
    dim blocked as short=0 
    dim markesc as short=0
    dim st as short=-1
    dim loca as short=0
    '
    dim as any ptr logo
End Type


#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: uMenu -=-=-=-=-=-=-=-

declare function textmenu overload (bg as short,te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1,loca as short=1) as short
declare function textmenu overload (            te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1,loca as short=1) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: uMenu -=-=-=-=-=-=-=-

namespace nuMenu
function init(iAction as integer) as integer
	return 0
end function
end namespace'nuMenu

Constructor uMenu()
End Constructor

Destructor uMenu()
End Destructor

function uMenu.before() as short
	'LogOut("uMenu.before()")
	dim as integer i
	dim as string a
    'if bg<>bg_noflip then
    '    tScreen.set(0)
    '    set__color(15,0)
    '    cls
    '    select case bg
    '    case bg_title
    '   		background(backpic &".bmp")
    '        if logo<>NULL then
    '            put (39,69),logo,trans
    '        else
    '            draw string(26,26),"PROSPECTOR",,titlefont,custom,@_col
    '        endif
    '    case bg_ship
    '        display_ship
    '    case bg_shiptxt
    '        display_ship
    '        rlprint ""
    '    case bg_shipstars
    '        display_stars(1)
    '        display_ship
    '    case bg_shipstarstxt
    '        display_stars(1)
    '        display_ship
    '        rlprint ""
    '    case bg_awayteam
    '        display_awayteam(0)
    '    case bg_awayteamtxt
    '        display_awayteam(0)
    '        rlprint ""
    '    case bg_randompic
    '        background(backpic &".bmp")
    '    case bg_randompictxt
    '        background(backpic &".bmp")
    '        rlprint ""
    '    case bg_stock
    '        display_ship
    '        tCompany.display_stock
    '        tCompany.portfolio(17,2)
    '        rlprint ""
    '    	case bg_roulette
    '        drawroulettetable
    '        display_ship
    '        rlprint ""
    '    case is>=bg_trading
    '        display_ship()
    '        displaywares(bg-bg_trading)
    '    end select
    'endif
	if tScreen.isGraphic then
	    set__color( 15,0)
	    draw string(x*_fw1,y*_fh1), lines(0)&space(3),,font2,custom,@_col    
	    for i=1 to c
	        if loca=i then 
	            if hfl=1 and loca<=c and helps(i)<>"" then blen=textbox(helps(i),ofx,2,hw,15,1,,,offset)
	            set__color( 15,5)
	        else
	            set__color( 11,0)
	        endif
	        draw string(x*_fw1,y*_fh1+i*_fh2),shrt(i) &") "& lines(i),,font2,custom,@_col
	    next
	else
		tScreen.pushpos()
	    tScreen.xy(x,y,lines(0)&space(3))    
	    for i=1 to c
	        if loca=i then 
	            if hfl=1 and loca<=c and helps(i)<>"" then blen=textbox(helps(i),ofx,2,hw,15,1,,,offset)
	            tScreen.rgbcol(255,255,255)
	            a="*"
	        else
	            tScreen.rgbcol(127,127,127)
	            a=" "
	        endif
		    tScreen.xy(x,y+i, a+shrt(i) &") "& lines(i))
	    next
		tScreen.poppos()
	EndIf
    
    'if bg<>1 then 'bg_noflip then 
    '    tScreen.update()
    'else
    '    rlprint ""
    'endif
	return 0
end function

function uMenu.after() as short
	'LogOut("uMenu.after()")
	dim as integer a
	if tScreen.isGraphic then
	    if hfl=1 then 
	        for a=1 to blen
	            set__color( 0,0)
	            draw string(ofx*_fw1,y*_fh1+(a-1)*_fh2), space(hw),,font2,custom,@_col
	        next
	    endif
	else
	    if hfl=1 then 
			tScreen.pushpos()
	        for a=1 to blen
			    tScreen.xy(ofx,y+a-1,space(hw))
	        next
			tScreen.poppos()
	    endif
	EndIf
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
    if key=key__esc then e= uConsole.aKey2i(key__esc)
'    if key=key__esc or player.dead<>0 then e=c
	return e
end function
	          


function uMenu.init() as short
	'LogOut("uMenu.init()")
	dim as integer a

    cls
	if tScreen.isGraphic then
		if bg<0 then
		    backpic=-bg
		    bg= 0'bg_title
		else
			tGraphics.Randombackground()		    
		endif
	    
	'    if bg=bg_title then
	'    	backpic= 0
	'        logo= bmp_load("graphics/prospector.bmp")
	'    endif
    
	else
	EndIf

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
        if getdirection(lcase(shrt(a)))>0 _ 'or getdirection(lcase(shrt(a)))>0 _
        or val(shrt(a))>0 then 'or ucase(shrt(a))=ucase(key_awayteam) then
            do 
                b+=1
                shrt(a)=chr(96+b+a)
            loop until getdirection(lcase(shrt(a)))=0 _
            		and getdirection(shrt(a))=0 and val(shrt(a))=0
        endif
        if len(trim(lines(a)))>longest then longest=len(trim(lines(a)))
    next
    
    for a=0 to c
        lines(a)=lines(a)&space(longest-len(lines(a)))
    next
    
'	if tScreen.isGraphic then
	    hw=_mwx*_fw1-((longest)*_fw2)-(3+x)*_fw1
	    if _fw2>0 then
		    hw=hw/_fw2
		else
		    hw=1'hw/_fw2
	    EndIf
'LogOut("hw=" & hw &", _mwx=" &_mwx &", longest=" &longest )
'LogOut( "hw=" &hw &", _mwx=" &_mwx &", longest=" &longest )
	    
	    for a=0 to c
	        longesthelp=1
	        l2=textbox(helps(a),ofx,2,hw,15,1,,longesthelp)
	        if l2>longestbox then longestbox=l2
	    next
	    
	if tScreen.isGraphic then
	    if longestbox>20 or (longestbox/hw)>2 or hw<8 then
	        hw=tScreen.x-((4+x)*_fw1)-((longest)*_fw2)
	        hw=hw/_fw2
	    endif
	    'if hw>longesthelp then hw=longesthelp
	    ofx=x+4+(longest*_fw2/_fw1)
	else
	    if longestbox>20 then
	        hw=tScreen.x-4+x-longest
	    endif
	    'if hw>longesthelp then hw=longesthelp
	    ofx=x+4+longest
	EndIf
	'LogOut("hw=" & hw & ", ofx=" & ofx)
    
    e=0
    return e
End Function


function uMenu.finish() as short
	'LogOut("uMenu.finish()")
	dim as integer a
    if key=key__esc and markesc=1 then e=-uConsole.aKey2i(key__esc)
    
	if tScreen.isGraphic then
	    set__color( 0,0)
	    for a=0 to c
	        'locate y+a,x
	        draw string(x*_fw1,y*_fh1+a*_fh2), space(longest),,font2,custom,@_col
	    next
	    set__color( 11,0)
	    cls
	    tScreen.set(1)
	    if logo <> 0 then
			ImageDestroy(Logo)
	    EndIf
	else
		tScreen.pushpos()
	    for a=0 to c
		    tScreen.xy(x,y+a,space(longest))
	    next
		tScreen.poppos()
	EndIf
	return e
End Function


function uMenu.go(sbg as short,ate as string, ahe as string="", sx as short=2, sy as short=2, sblocked as short=0, smarkesc as short=0, sst as short=-1, sloca as short=0) as short
	dim bGraphic as Short
	bGraphic=tScreen.isGraphic
	'if tScreen.isGraphic then
	'	LogOut("tScreen.isGraphic")
	'else
	'	cls
	'	LogOut("tScreen.isConsole")
	'endif
    bg= sbg
    te= ate
    he= ahe
    x= sx
    y= sy
    blocked= sblocked
    markesc= smarkesc
    st= sst
    loca= sloca
	'LogOut("x,y " &x &"," &y)

	if (uConsole.Closing<>0) then return 0
   	e=init()
   	if e=0 then
	    while (uConsole.Closing=0) and (e=0)	
	    	e=before()    		
			key=uConsole.keyinput() 'key=keyin(,96+c)        
	    	e=after()
	    	'changed modes?
	    	if bGraphic<>tScreen.isGraphic then
				bGraphic=tScreen.isGraphic 		
   				e=init()
			   	if e<>0 then return e
		   	EndIf
	    wend
	    return finish()
   	else
	    return e
   	EndIf
end function

function textmenu overload (bg as short,te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1,loca as short=0) as short
	dim aMenu as uMenu
	return aMenu.go(bg,te,he,x,y,blocked,markesc,st,loca) 	          
end function

function textmenu overload (te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1,loca as short=0) as short
	dim aMenu as uMenu
	return aMenu.go(0,te,he,x,y,blocked,markesc,st,loca) 	          
end function

#endif'main


#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: uMenu -=-=-=-=-=-=-=-
	tModule.register("uMenu",@nuMenu.init()) ',@nuMenu.load(),@nuMenu.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: uMenu -=-=-=-=-=-=-=-
#endif'test
