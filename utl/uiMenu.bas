'uMenu.
#include once "uDefines.bi"
DeclareDependencies()
#include "fbGfx.bi"
#include "uDebug.bas"
#include "uUtils.bas"
#include "uiScreen.bas"
#include "file.bi"
#include "uFile.bas"
#include "uiColor.bas"
#include "uiConsole.bas"
#include "uRNG.bas"
#include "adtCoords.bas"
#include "uiBorder.bas"
#include "uiPrint.bas"
#include "uiScroller.bas"
#include "uiTextbox.bas"
#include "uGraphics.bas"
#include "uWindows.bas" 'auto-close
#define test 
#endif'DeclareDependencies()
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

Type tMenuCore Extends tArrayScroller'Object
'Type tMenuCore Extends tArrayScroller
	declare constructor()
	declare virtual destructor() 
	'
	declare virtual function init() as integer
	declare virtual function before() as integer
	declare abstract function DoProcess() as integer
	'
	declare function menu() as integer
	declare function go(te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1,loca as short=0) as integer
	'
	declare function ClearChoices() as integer
	declare function AddChoice(aTe as string, aTh as string="") as integer  
	'
	declare sub ShowHelp(i as integer)
	'
	dim a as short			=0
'	dim e as short			=0
'	dim th as string		="" 
	dim as string help
	'dim x as short			=2 
	'dim y as short			=2 
	dim blocked as short	=0 
	dim markesc as short	=0
	dim st as short			=-1
	dim loca as short		=1
	dim as integer lTe=0
	dim as integer lTh=0
Private:
	' 0= headline 1=first entry
	dim as short blen
	'dim as string bgname
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
	dim tlen as short
	dim longest as short
	dim as integer ofx= 1
	dim as integer l2
	dim as integer longestbox
	dim as integer longesthelp
	dim as integer offset
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
	return 0
End Function


Constructor tMenuCore()
	loca= 1
End Constructor

Destructor tMenuCore()
End Destructor

sub tMenuCore.ShowHelp(i as integer)
	if (helps(i)<>"") then 
'declare function textbox(text as string, x as short, y as short, wid as short,_
'    fg as short=11, bg as short=0,pixel as byte=0,byref op as Integer=0,byref offset as Integer=0) as short

		blen= 1+textbox(helps(i),ofx,2,hw,15,1,,,offset)
	EndIf
End sub

function tMenuCore.before() as integer
	'LogOut("uMenu.before()")
	dim as integer i
	dim as string a1
	if tScreen.isGraphic then
	    set__color( 15,0)
'	    tScreen.drawfx(_fw1,_fh1)    
'	    tScreen.drawfx(_fw2,_fh2)    
	    tScreen.draw2c(x,y,lines(0)&space(3))    
	    for i=1 to c
	        if loca=i then 
	            ShowHelp(i)
	            set__color( 15,5)
	            a1="*"
	        else
	            set__color( 11,0)
	            a1=" "
	        endif
	        tScreen.draw2c(x,y+i, a1+shrt(i) &") "& lines(i))
	    next
'	    tScreen.drawfx()    
	else
		tScreen.pushpos()
	    tScreen.xy(x,y,lines(0)&space(3))    
'debugbreak
	    for i=1 to c
	        if loca=i then 
	            ShowHelp(i)
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




function tMenuCore.init() as integer
	dim as integer a,e

    cls
	if tScreen.isGraphic then
		tGraphics.Background(0)		    	    
	else
	EndIf

    'help=th    
    if help<>"" then
        if right(help,len(help)-1)<>"/" then help=help &"/"
        e=0
        b=len(help)
        do
            tlen=instr(help,"/")
            helps(e)=left(help,tlen-1)
'? helps(e)            
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
    
    return 0
End Function


function tMenuCore.menu() as integer
	dim bGraphic as Short
	dim e as integer
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
	   	if (e<>0) and (key<>"") then e=DoProcess()
    wend
    return 0
End Function

'

Function tMenuCore.ClearChoices() as integer
	for i as integer = 0 to nlines
		lines(i)=""
	Next
	nLines=0
	lCount=0
	help=""
	lTe=0
	lTh=0
	return 0	
End Function

function tMenuCore.AddChoice(aTe as string, aTh as string="") as integer
	lines(nlines)=aTe
	help=	help + iif(len(help)>0,"/","") + aTh
	nLines +=1
	if len(aTe)>lTe then lTe=len(aTe)
	if len(aTh)>lTh then lTh=len(aTh)	
	'DbgPrint("AddChoice(aTe,aTh) "& aTe &" , " & aTh )
	lCount= nLines
	return 0	
End Function

function tMenuCore.go(ate as string, ahe as string="", sx as short=2, sy as short=2, sblocked as short=0, smarkesc as short=0, sst as short=-1, sloca as short=0) as integer
	'if tScreen.isGraphic then
	'	LogOut("tScreen.isGraphic")
	'else
	'	cls
	'	LogOut("tScreen.isConsole")
	'endif
	setlines(aTe,"/")
    help= ahe
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
#if (defined(test) or defined(registerTests))
#print -=-=-=-=-=-=-=- TEST:  -=-=-=-=-=-=-=-

	namespace nuMenu

	sub Menutest()
		chdir exepath
		chdir ".."
		
		cls
		tscreen.res
		tGraphics.LoadLogo("graphics/prospector.bmp")
		tGraphics.Randombackground()		    	    
		
		dim Mainmenu as tMainmenu
		with Mainmenu
			if tScreen.isGraphic then
				.x = tScreen.gtw *3 \4
				.y = tScreen.gth *3 \4
			else
				.x = uConsole.ttw *3 \4
				.y = uConsole.tth *3 \4
			endif
			.bIdx=true
			.bScrollbar=true
			.wid= 8
			.mhy= 8

			'
			.ClearChoices()
			.AddChoice("testing",	"this could be a title")  
			.AddChoice("one",		"test the menu")  
			.AddChoice("two",		"more help")  
			.AddChoice("three",		"and thrirdly..")
			.AddChoice("four",		"there's four")
			.AddChoice("five",		"and five")
			.AddChoice("six",		"and six")
			.AddChoice("seven",		"and seven")
			.AddChoice("eight",		"and eight too")
			.AddChoice("nine",		"and also nine or else")
		End With
		
		  
		dim aKey as String
		dim e as integer
		
		while not uConsole.Closing
			cls
			tGraphics.background(0)
			if not tGraphics.putlogo(39,69) then
			   	tScreen.draw2c(26,26,"MAINMENU")',,titlefont,custom,@_col
			endif

'			Mainmenu.e=0
'			e=Mainmenu.init()
'		   	if (e=0) then e=Mainmenu.before()
'		   	if (e<>0) then exit while
			Mainmenu.Scrollbox() 'aText,20)

'debugbreak
			aKey=Mainmenu.Getkey()
			
			if uConsole.keyaccept(aKey,keyl_onwards) then
				tScreen.draw2c(10,22, "you chose: "& Mainmenu.index _
					&" "& Mainmenu.lines(Mainmenu.index))
				tScreen.draw2c(10,24,"")
				uConsole.Pressanykey()
				exit while
			EndIf
'			tScreen.draw2c(10,22, pad(15,""))
		wend
	End Sub

	end namespace'nuMenu
	
	#ifdef test
		nuMenu.Menutest()
		'? "sleep": sleep
	#else
		tModule.registertest("uMainmenu",@nuMenu.Menutest())
	#endif'test
#endif'test