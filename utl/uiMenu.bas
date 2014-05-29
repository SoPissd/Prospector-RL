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
	declare function menu(accept as string="",deny as string="") as string
	declare function go(te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1,loca as short=0) as integer
	'
	declare function ClearChoices() as integer
	declare function AddChoice(aTe as string, aTh as string="") as integer  
	'
	declare sub ShowHelp(i as integer)
	'
	dim as string title

	dim as integer lTe=0
	dim as integer lTh=0
Private:
	' 0= headline 1=first entry
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
End Constructor

Destructor tMenuCore()
End Destructor

sub tMenuCore.ShowHelp(i as integer)
	if (helps(i)<>"") then textbox(helps(i),ofx,2,hw,15,1,,,offset)
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
	    for i=0 to c
'	        if loca=i then 
'	            ShowHelp(i)
'	            set__color( 15,5)
'	            a1="*"
'	        else
	            set__color( 11,0)
	            a1=" "
'	        endif
	        tScreen.draw2c(x,y+i, a1+shrt(i) &") "& lines(i))
	    next
'	    tScreen.drawfx()    
	else
		tScreen.pushpos()
	    tScreen.xy(x,y,lines(0)&space(3))    
'debugbreak
	    for i=1 to c
'	        if loca=i then 
	            'ShowHelp(i)
'	            tScreen.rbgcolor(255,255,255)
'	            a1="*"
'	        else
	            tScreen.rbgcolor(127,127,127)
	            a1=" "
'	        endif
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
    
    for a=0 to nLines-1
    	if a<=26 then
	        shrt(a)=chr(asc("a")+a)
	    elseif a<=26*2 then
	        shrt(a)=chr(asc("A")+a-26-1)
	    elseif a<=26*2+10 then
	        shrt(a)=chr(asc("0")+a-26*2-1)
	    endif
    next


    hw=_mwx*_fw1-((longest)*_fw2)-(3+x)*_fw1
    if _fw2>0 then
	    hw=hw/_fw2
	else
	    hw=1'hw/_fw2
    EndIf

	dim as integer longesthelp
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

'

Function tMenuCore.ClearChoices() as integer
	for i as integer = 0 to nlines-1
		lines(i)=""
		helps(i)=""
	Next
	nLines=0
	lTe=0
	lTh=0
	return 0
End Function

function tMenuCore.AddChoice(aTe as string, aTh as string="") as integer
	'DbgPrint("AddChoice(aTe,aTh) "& aTe &" , " & aTh )
	lines(nlines)=aTe
	helps(nlines)=aTh
	nLines +=1
	if len(aTe)>lTe then lTe=len(aTe)
	if len(aTh)>lTh then lTh=len(aTh)	
	return 0	
End Function

function tMenuCore.menu(accept as string="",deny as string="") as string
	if title<>"" then tScreen.draw2c(x,y-1,title)
	Scrollbox()
	ShowHelp(index)
	dim as string aKey= this.Getkey(accept,deny)
	return aKey
End Function


function tMenuCore.go(ate as string, ahe as string="", sx as short=2, sy as short=2, sblocked as short=0, smarkesc as short=0, sst as short=-1, sloca as short=0) as integer
'junked: sblocked sst.  handling smarkesc locally 
    x= sx
    y= sy    
	'
	dim as integer ilines,ilongestline
	setlines(aTe,"/")
	loadarray(helps(),ilines,ilongestline,aHe,"/")
	title= lines(0)
	for i as integer = 1 to nlines-1
		lines(i-1)= lines(i)
		'if the conventional call has no help for the title... remove the next line!
		if ilines+1<>nlines then helps(i-1)= helps(i)
	Next
	nlines -=1

	height= nlines
	mhy= nlines

	bIdx=true
    index= sloca
	bScrollbar=false
	bDrawborder=false

	while not uConsole.Closing
		dim as string aKey=Menu()

		if uConsole.Closing then exit while
		if (aKey=key__esc) then 
			if (smarkesc<>0) then
				continue while
			else
				return -1
			EndIf
		EndIf
		if uConsole.keyaccept(aKey,keyl_onwards) then return index
	wend

	return -1
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
			.bDrawborder=false
			.wid= 8
			.mhy= 8
			.height= 8
			.title= "Testing the Menu"
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
			.AddChoice("Exit",		"what it says")
		End With
		
		  
		dim aKey as String

		while not uConsole.Closing
			cls
			tGraphics.background(0)
			if not tGraphics.putlogo(39,69) then
			   	tScreen.draw2c(26,26,"MAINMENU")',,titlefont,custom,@_col
			endif

			aKey=Mainmenu.Menu("i,I")
			'DbgPrint("aKey :"& akey &": height="& Mainmenu.height)			
			if uConsole.Closing then exit while

			if aKey="i" then  Mainmenu.index = Mainmenu.nlines-1
			if aKey="I" then  Mainmenu.index = 0

			if aKey=key__esc then
				if Mainmenu.index = Mainmenu.nLines-1 then
					tGraphics.Randombackground()
				else
					Mainmenu.index = Mainmenu.nLines-1
				EndIf
				continue while
			EndIf
			'if Mainmenu.index=0 then continue while

			if uConsole.keyaccept(aKey,keyl_onwards) then
				tScreen.draw2c(10,22, "you chose: "& Mainmenu.index _
					&" "& Mainmenu.lines(Mainmenu.index))

				select case as const Mainmenu.index
					case 0 to 3
						dim x as tMainmenu
						dim as integer i,ix,iy
						if tScreen.isGraphic then
							ix = tScreen.gtw \2
							iy = tScreen.gth \2
						else
							ix = uConsole.ttw \2
							iy = uConsole.tth \2
						endif
						ix -= 2
						iy -= 2						
						i= x.go("Title/abc/def/ghi/jkl","/one/two/three/four",ix,iy)
						if i>=0 then
							tScreen.draw2c(10,24,""& i &": "& x.lines(i))
							uConsole.Pressanykey()
						EndIf 
					case else
						if (Mainmenu.index <> Mainmenu.nLines-1) then
							tScreen.draw2c(10,24,"")
							uConsole.Pressanykey()
						else
							exit while
						endif
				End Select
			EndIf
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