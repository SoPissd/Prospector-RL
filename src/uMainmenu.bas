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
#undef both
#define types
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: uMenu -=-=-=-=-=-=-=-
#undef intest
#print     -=-=-=-=-=-=-=- TEST: uMenu -=-=-=-=-=-=-=-

#include "fbGfx.bi"
#include "uDefines.bas"
#include "uModule.bas"
#include "uDefines.bas"
#include "uScreen.bas"
#include "file.bi"
#include "uFile.bas"
#include "uColor.bas"
#include "uConsole.bas"
#include "uRNG.bas"
#include "uCoords.bas"
#include "uPrint.bas"
#include "uUtils.bas"
#include "uDebug.bas"
#include "uWindows.bas" 'auto-close
#include "uTextbox.bas"
#include "uGraphics.bas"

#define test
#endif'test
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

Type tMenuCore Extends Object
  declare constructor()
  declare virtual destructor() 
  '
  declare virtual function init() as integer
  declare virtual function before() as integer
  declare abstract function DoProcess() as integer
  declare virtual function after() as integer
  declare virtual function finish() as integer
  '
  declare function menu() as integer
  declare function go(te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1,loca as short=0) as integer
  '
  declare function ClearChoices() as integer
  declare function AddChoice(aTe as string, aTh as string="") as integer  
'
    dim a as short			=0
    dim e as short			=0
    dim te as string		=""
    dim th as string		="" 
    dim x as short			=2 
    dim y as short			=2 
    dim blocked as short	=0 
    dim markesc as short	=0
    dim st as short			=-1
    dim loca as short		=1
    dim iLines as short
Private:
    ' 0= headline 1=first entry
    dim as short blen
    dim as string text,help
    'dim as string bgname
    dim lines(256) as string
    dim helps(256) as string
    dim shrt(256) as string
    dim as string key,delhelp
    dim b as short
    dim c as short
    'static loca as short
    'dim loca as short
    dim l as short
    dim hfl as short
    dim hw as short
    dim lastspace as short
    dim tlen as short
    dim longest as short
    dim as short ofx,l2,longestbox,longesthelp,backpic,offset
    '
End Type

type tMainmenu extends tMenuCore
	declare function DoProcess() as integer
End Type


#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: uMenu -=-=-=-=-=-=-=-

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: uMenu -=-=-=-=-=-=-=-

namespace nuMenu
function init(iAction as integer) as integer
	return 0
end function
end namespace'nuMenu


function  tMainmenu.DoProcess() as integer
	return e
End Function


Constructor tMenuCore()
	loca= 1
End Constructor

Destructor tMenuCore()
End Destructor

function tMenuCore.before() as integer
	'LogOut("uMenu.before()")
	dim as integer i
	dim as string a1
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
'	    tScreen.drawfx(_fw1,_fh1)    
	    tScreen.drawfx(_fw2,_fh2)    
	    tScreen.draw2c(x,y,lines(0)&space(3))    
	    for i=1 to c
	        if loca=i then 
	            if hfl=1 and loca<=c and helps(i)<>"" then blen=textbox(helps(i),ofx,2,hw,15,1,,,offset)
	            set__color( 15,5)
	        else
	            set__color( 11,0)
	        endif
	        tScreen.draw2c(x,y+i,shrt(i) &") "& lines(i))
	    next
	    tScreen.drawfx()    
	else
		tScreen.pushpos()
	    tScreen.xy(x,y,lines(0)&space(3))    
	    for i=1 to c
	        if loca=i then 
	            if hfl=1 and loca<=c and helps(i)<>"" then blen=textbox(helps(i),ofx,2,hw,15,1,,,offset)
	            tScreen.rbgcolor(255,255,255)
	            a1="*"
	        else
	            tScreen.rbgcolor(127,127,127)
	            a1=" "
	        endif
		    tScreen.xy(x,y+i, a1+shrt(i) &") "& lines(i))
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

function tMenuCore.after() as integer
	'LogOut("uMenu.after()")
	dim as integer i
	dim as integer iDir
	if tScreen.isGraphic then
	    tScreen.drawfx(_fw2,_fh2)    
	    if hfl=1 then 
	        for i=1 to blen
	            set__color( 0,0)
	            tScreen.draw2c(ofx,y+i-1,space(hw))
	        next
	    endif
	    tScreen.drawfx()    
	else
	    if hfl=1 then 
			tScreen.pushpos()
	        for i=1 to blen
			    tScreen.xy(ofx,y+i-1,space(hw))
	        next
			tScreen.poppos()
	    endif
	EndIf
	'
    iDir=uConsole.getdirection(key)
    if iDir =8 then
		loca=loca-1 
    elseif iDir =2 then 
    	loca=loca+1
    elseif help<>"" then
        if uConsole.keyaccept(key,keyl_menup) then offset +=1
        if uConsole.keyaccept(key,keyl_mendn) then offset -=1
    endif

    for i=0 to c
        if lcase(key)=lcase(shrt(i)) then			'select with lower case
			loca=i
			if (c<26) and (key=ucase(key)) then key=key__enter	'select and go with upper case up to 26 choices
			exit for
        EndIf
    next
    
    if loca<1 then loca=c
    if loca>c then loca=1

    if key=key__enter then e=loca
    if key=key__esc then e= -uConsole.aKey2i(key__esc)
    
'   if player.dead<>0 then e=c
'   if key=key__esc or player.dead<>0 then e=c
	return e
end function
	          


function tMenuCore.init() as integer
	'DbgPrint(a)
	'LogOut("uMenu.init()")
	dim as integer a

    cls
	if tScreen.isGraphic then
		tGraphics.Background(0)		    	    
	'    if bg=bg_title then
	'    	backpic= 0
	'        logo= bmp_load("graphics/prospector.bmp")
	'    endif
    
	else
	EndIf

	text=te
    help=th
    b=len(text)
    text=text &"/"
    c=0
    do
        tlen=instr(text,"/")
        lines(c)=left(text,tlen-1)
? lines(c)
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
? helps(e)            
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
        if uConsole.getdirection(lcase(shrt(a)))>0 or val(shrt(a))>0 then 
        'or getdirection(lcase(shrt(a)))>0 _
         'or ucase(shrt(a))=ucase(key_awayteam) then
            do 
                b+=1
                shrt(a)=chr(96+b+a)
            loop until uConsole.getdirection(lcase(shrt(a)))=0 _
            		and uConsole.getdirection(shrt(a))=0 and val(shrt(a))=0
        endif
        if len(trim(lines(a)))>longest then longest=len(trim(lines(a)))
    next
    
    for a=0 to c
        lines(a)=lines(a)&space(longest-len(lines(a)))
    next
    
    hw=_mwx*_fw1-((longest)*_fw2)-(3+x)*_fw1
    if _fw2>0 then
	    hw=hw/_fw2
	else
	    hw=1'hw/_fw2
    EndIf
    
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
    
    e=0
    return e
End Function


function tMenuCore.finish() as integer
	'DbgPrint(e)
	'LogOut("uMenu.finish()")
	dim as integer a
    if key=key__esc and markesc=1 then e=-uConsole.aKey2i(key__esc)
    
	if tScreen.isGraphic then
	    set__color( 0,0)
	    tScreen.drawfx(_fw2,_fh2)    
	    tScreen.drawfx()    
	    for a=0 to c
	        'locate y+a,x
	        tScreen.draw2c(x,y+a,space(longest))
	    next
'	    set__color( 11,0)
'	    cls
'		tScreen.set(1)
'	    if logo <> 0 then
'			ImageDestroy(Logo)
'	    EndIf
	else
		tScreen.pushpos()
	    for a=0 to c
		    tScreen.xy(x,y+a,space(longest))
	    next
		tScreen.poppos()
	EndIf
	return e
End Function


function tMenuCore.menu() as integer
	dim bGraphic as Short
	bGraphic=not tScreen.isGraphic
    while (not uConsole.Closing) and (e=0)	
    	'changed modes?
    	if bGraphic<>tScreen.isGraphic then
			bGraphic=tScreen.isGraphic 		
	   	EndIf
		e=init()
		'DbgPrint("e=init() a=" &a):uConsole.Pressanykey			
	   	if (e=0) then e=before()    		
	   	if (e=0) then key=uConsole.keyinput() 'key=keyin(,96+c)
	   	if (e=0) then e=after()
	   	if (e<>0) and (key<>"") then e=DoProcess()
    wend
    return finish()
End Function

'

Function tMenuCore.ClearChoices() as integer
	te=""
	th=""
	iLines=0
	return 0	
End Function

function tMenuCore.AddChoice(aTe as string, aTh as string="") as integer
	te= te + iif(len(te)>0,"/","") + aTe
	th=	th + iif(len(th)>0,"/","") + aTh
	iLines +=1
	return 0	
End Function

function tMenuCore.go(ate as string, ahe as string="", sx as short=2, sy as short=2, sblocked as short=0, smarkesc as short=0, sst as short=-1, sloca as short=0) as integer
	'if tScreen.isGraphic then
	'	LogOut("tScreen.isGraphic")
	'else
	'	cls
	'	LogOut("tScreen.isConsole")
	'endif
    te= ate
    th= ahe
    x= sx
    y= sy
    blocked= sblocked
    markesc= smarkesc
    st= sst
    loca= sloca
	'LogOut("x,y " &x &"," &y)
	
	return menu()
end function

#endif'main


#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: uMenu -=-=-=-=-=-=-=-
	tModule.register("uMenu",@nuMenu.init()) ',@nuMenu.load(),@nuMenu.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: uMenu -=-=-=-=-=-=-=-
#undef test
chdir exepath
chdir ".."


dim Mainmenu as tMainmenu
  Mainmenu.ClearChoices()
  Mainmenu.AddChoice("testing",	"this could be a title")  
  Mainmenu.AddChoice("one",		"test the menu")  
  Mainmenu.AddChoice("two",		"more help")  
  Mainmenu.AddChoice("three",	"and thrirdly..")
  

cls
tGraphics.Randombackground()		    	    
while not uConsole.Closing
	tscreen.res
	Mainmenu.menu()
	tScreen.xy(10,22, "you chose: "&Mainmenu.e)
	tScreen.xy(10,24)
	if uConsole.keyaccept(uConsole.pressanykey(0),keyl_onwards) then exit while
	tScreen.xy(10,22, pad(15,""))
wend

#endif'test
