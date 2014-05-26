'tTextbox.
#print uTextbox
#include once "uDefines.bi"
DeclareDependencies()
'#include "uUtils.bas"
'#include "uDebug.bas"
'#include "uScreen.bas"
'#include "file.bi"
'#include "uFile.bas"
'#include "uColor.bas"
'#include "uConsole.bas"
'#include "uVersion.bas"
'#include "uError.bas"
'#include "uRng.bas"
'#include "uCoords.bas"
'#include "uWindows.bas"
'#include "uPrint.bas"
'#include "uBorder.bas"
'#include "uScroller.bas"
#define test 
#endif'DeclareDependencies()
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tTextbox -=-=-=-=-=-=-=-

declare function textbox(text as string, x as short, y as short, wid as short,_
    fg as short=11, bg as short=0,pixel as byte=0,byref op as Integer=0,byref offset as Integer=0) as short

declare function scroll_bar(iStartingline as short, iTotalLines as short, iLinesShown as short, _
	iScrollerHeight as short, x as short=0, y as short=0, fg as short=0,cHoriz as string=chr(250)) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tTextbox -=-=-=-=-=-=-=-
namespace tTextbox
function init(iAction as integer) as integer
	return 0
end function
end namespace'tTextbox


function textbox(text as string, x as short, y as short, wid as short,_
    fg as short=11, bg as short=0,pixel as byte=0,byref op as Integer=0,byref offset as Integer=0) as short
    'op=1 only count lines, don't print

	assert(pixel=0)

    set__color(fg,bg)
	dim a as tArrayScroller
	a.setlines(text)'=	text
	a.x=	x
	a.y=	y
	a.wid=	wid
	return a.Textbox()	
end function


function scroll_bar(iStartingline as short, iTotalLines as short, iLinesShown as short, _
	iScrollerHeight as short, x as short=0, y as short=0, fg as short=0, cHoriz as string=chr(250)) as short
	'iStartingline as short,	#starting line
	'iTotalLines as short,	#of lines
	'iLinesShown as short,	#lines showing
	'iScrollerHeight,x,y,col	tallness,starting point, color
    set__color(fg,0)
	dim a as tArrayScroller
	a.x=	x
	a.y=	y
	'a.fg=	fg
	'a.bg=	0
	a.init(iTotalLines,True)
	a.nlines=	iTotalLines	
	a.height=	iLinesShown
	a.pheight=	iScrollerHeight
	a.offset=	iStartingline
	a.cHoriz=	cHoriz
	return a.Scrollbar()
end function

'

#endif'main


#if (defined(main) or defined(test))
	tModule.register("tTextbox",@tTextbox.init()) ',@tTextbox.load(),@tTextbox.save())
#endif'main


'#if false

#if (defined(test) or defined(registerTests))
#print -=-=-=-=-=-=-=- TEST: tTextbox -=-=-=-=-=-=-=-

	namespace tTextbox

	function aaskyn(q as string,col as short=11) as short
	    dim key as string '*1
		?	q;" (y/n) "; ',col
	    do
	        key=uConsole.keyinput()
'	        displaytext(_lines-1) &= key
	'        if key <>"" then 
	''			rlprint ""
	'			'if configflag(con_anykeyno)=0 and not isKeyYes(key) then key="N"
	'        endif
	    loop until (uConsole.Closing<>0) or (uConsole.isKeyNo()) or uConsole.isKeyYes()  
	    
	    if uConsole.isKeyYes() then 
	       print "Yes.";',15
	        return true
	    else
	        print "No. ";',15
	        return false
	    endif
	    
	    
	end function
	
	
	sub testScrollbars()	
		dim w as Integer
		dim b as Integer
		dim bCls as Integer
		
		' this construction lets you interrupt a loop by noticing pending events
		
		while not uConsole.Closing
			'scroll_bar(offset as short,linetot as short,lineshow as short,winhigh as short, x as short,y as short,col as short) as short
			bCls=true
			for w = 1 to 20
				cls
				if bCls then
					uConsole.ClearEvents()
					bCls=false
				EndIf
	'		tScreen.set(0)
				tScreen.xy(10,44,pad(20,"scrollbar="&w))
				
	' scroll_bar(iStartingline as short, iTotalLines as short, iLinesShown as short,
	'			iScrollerHeight as short, x as short=0, y as short=0, fg as short=0)
	
				scroll_bar(  w, 60, 20,20,10,20,09) 'raise lines shown to total
				scroll_bar(  w,w*3, 20,20,11,20,10) 'raise offset from first to last line
				'
				scroll_bar(  w, 40, 20,20,22,20,11)
				scroll_bar(  w,w*2, 20,20,23,20,12)
				'
				scroll_bar(  w, 30, 20,20,34,20,13)
				scroll_bar(  w, 30, 20,20,35,20,14)
				'
				tScreen.xy(10,44,pad(25,""))		
	'	    ScreenSync
	'		ScreenCopy
				sleep 50
				if uConsole.EventPending() then 
					tScreen.xy(10,15)
					if aaskyn("Exit?",0) then
						exit for	
					EndIf
					bCls=true
				EndIf
				if uConsole.Closing then exit for 			
			Next 
			
			tScreen.xy(10,15)
			if uConsole.keyaccept(uConsole.pressanykey(0),keyl_onwards) then exit while
		wend
		
	End Sub
	
	sub testTextbox()
	'declare function textbox(text as string, x as short, y as short, wid as short,_
	'    fg as short=11, bg as short=0,pixel as byte=0,byref op as short=0,byref offset as Integer=0) as short
	dim text as string ="testing, one, two, three... is this thing on?"
	text= text+"|"+text+"|"+text+"|"+text+"|"+text+"|"+text
	'text= text+"|"+text+"|"+text+"|"+text+"|"+text+"|"+text
		textbox(text,45,5,25,,,,0,0)
		uConsole.pressanykey(0)
	End Sub

	end namespace'tTime
	
	#ifdef test
		ReplaceConsole()
		tScreen.res
		tTextbox.testScrollbars()
		tTextbox.testTextbox()
		'? "sleep": sleep
	#else
		tModule.registertest("uTextbox",@tTextbox.testScrollbars(),"testScrollbars")
		tModule.registertest("uTextbox",@tTextbox.testTextbox(),"testTextbox")
	#endif'test
#endif'test
'#endif'false
