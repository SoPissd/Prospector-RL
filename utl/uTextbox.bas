'tTextbox.
'
'defines:
'scroll_bar=1, textbox=31
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
'     -=-=-=-=-=-=-=- TEST: tTextbox -=-=-=-=-=-=-=-
#undef intest

#include "uDefines.bas"
#include "uModule.bas"
#include "uDefines.bas"
#include "uUtils.bas"
#include "uDebug.bas"
#include "uScreen.bas"
#include "file.bi"
#include "uFile.bas"
#include "uColor.bas"
#include "uConsole.bas"
#include "uVersion.bas"
#include "uError.bas"
#include "uRng.bas"
#include "uCoords.bas"
#include "uPrint.bas"
#include "uWindows.bas"
#include "uBorder.bas"
#include "uScroller.bas"

#define test
#endif'test
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tTextbox -=-=-=-=-=-=-=-

declare function textbox(text as string, x as short, y as short, wid as short,_
    fg as short=11, bg as short=0,pixel as byte=0,byref op as short=0,byref offset as Integer=0) as short

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
    fg as short=11, bg as short=0,pixel as byte=0,byref op as short=0,byref offset as Integer=0) as short
    'op=1 only count lines, don't print

	assert(pixel=0)

    dim as integer maxlines
	if tScreen.isGraphic then
	    maxlines=tScreen.gth	'tScreen.gth	'graphic terminal height
	else
	    maxlines=25 			'uConsole.tth	'text terminal height
	endif	    

    set__color(fg,bg)

    'Store and count words
    dim as integer i
    dim as integer wcount
    dim as string  words(6023)
    dim as string  c
    for i=0 to len(text)
    	c=mid(text,i,1)
        if c="{" or c="|" then wcount+=1
        words(wcount) +=c
'        if c=" " or c="|" or c="}" then wcount+=1
        if c=" " or c="|" then wcount+=1
        if wcount+1>=ubound(words) then exit for 'need to leave 1 empty word at the end
    next
   
    'Count lines
    dim as string w
    dim as integer xw,xwn 
    dim as integer longestline
    dim as integer lcount
     
    for i=0 to wcount
		w= trim(words(i))
		if len(w)>wid then continue for 'already accounted for the long word
        if w="|" then 'New line
            lcount +=1
            if xw>longestline then longestline=xw
            xw=0
        elseif Left(w,1)<>"{" and Right(w,1)<>"}" then 'Printable word
        	xwn=len(trim(words(i+1)))
        	if xwn>wid then
                lcount += 2 'finish first + long word on a line by itself
	            if xwn>longestline then longestline=xwn
                xw=0
        	else
        		if xw>0 then xw +=1
	            xw=xw+len(w)
	            if xw>wid then
	                lcount += 1
		            if xw>longestline then longestline=xw
	                xw=0
	            endif
        	EndIf
        endif
	'DbgPrint(lcount &" "& longestline  &" "& xw &" " + w)				
    next
    if xw>0 then
		lcount+=1
    	xw=0
    EndIf

    if op<>0 then
        op=longestline
        return lcount
    endif
    
    'restrain offset
    if offset>0 and lcount-offset<maxlines-1 then offset=lcount-maxlines-1
    if offset<0 then offset=0
    
    dim as integer j
    dim as integer isCol=0
    
    
    set__color(fg,bg)
    
'tScreen.draw2c(2,2,""& lcount)
'	if lcount+y >= tScreen.gth then
'		lcount= tScreen.gth -1 -y
'	EndIf    
'tScreen.draw2c(3,4,""& lcount &" wid:"& wid)
'
'    set__color(1,15)
'
'    for i=0 to lcount
'    	tScreen.draw2c(x,y+i,pad(wid,"X")) 'space(wid))
'    next
'    set__color(fg,bg)
    

    lcount=0
    for i=0 to wcount
		w= trim(words(i))
       	j= lcount-offset

        isCol= Left(w,1)="{" and Right(w,1)="}" 					'Color spec'd 
        if isCol then
			set__color( numfromstr(w),bg)
        elseif w="|" then 											'New line
            if y+j>=maxlines then exit for
			'if j>=0 then tScreen.draw2c(x+xw,y+j,space(wid-xw))
            lcount += 1
            xw=0
        else			 											'Print word
            if (len(trim(words(i+1)))>wid) or (xw+len(w)>wid) then	'Newline before long word or line to long
                if y+j>=maxlines then exit for
				'if j>=0 then tScreen.draw2c(x+xw,y+j,space(wid-xw))
                lcount += 1
		       	j= lcount-offset
                xw=0
            EndIf
			if y+j>=maxlines then exit for
       		if xw>0 then xw +=1
			if j>=0 then tScreen.draw2c(x+xw,y+j,w)
            xw=xw+len(w)
        endif
		'DbgPrint(lcount &" "& j &" "& longestline &" "& xw &" " & len(w) &" "& ":"+w+":")
    next
    
	'tScreen.rbgcolor(255,255,255)
	'for i=0 to wid-1
	'	tScreen.draw2c(x+i,y+lcount+1,right(""&i,1))    	
	'Next
	'DbgPrint(x &" "& y &" "& longestline &" "& maxlines)				
	'DbgPrint(""&y &" "& lcount &" "& maxlines)
    
    'if y+lcount>=maxlines then									' a full-screen textbox... for the finale

    '    if offset>0 then
    '        set__color(14,0)
    '    else
    '        set__color(14,0,0)
    '    endif
    '    
	'	wid -=1        
    '    tScreen.draw2c(x+wid,y            ,chr(24))
    '    tScreen.draw2c(x+wid,y+1          ,"-")
    '    
    '    if offset+maxlines<lcount-1 then
    '        set__color(14,0)
    '    else
    '        set__color(14,0,0)
    '    endif
    '    tScreen.draw2c(x+wid,maxlines-2	,"+")
    '    tScreen.draw2c(x+wid,maxlines-1	,chr(25))
	'	wid +=1        

    '    scroll_bar(offset, lcount, maxlines-y, maxlines-y -1 -4,x+wid,y+2,14)
	'endif
    
    set__color(11,0)
    op=longestline
    return lcount
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
'      -=-=-=-=-=-=-=- INIT: tTextbox -=-=-=-=-=-=-=-
	tModule.register("tTextbox",@tTextbox.init()) ',@tTextbox.load(),@tTextbox.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tTextbox -=-=-=-=-=-=-=-
#undef test
'#include "uWindows.bas" 'auto-close
ReplaceConsole()
'#include "uPrint.bas"

function aaskyn(q as string,col as short=11) as short
    dim key as string '*1
	?	q;" (y/n) "; ',col
    do
        key=uConsole.keyinput()
        displaytext(_lines-1) &= key
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

tScreen.res
testScrollbars()

#endif'test
