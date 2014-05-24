'tScroller.
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
'     -=-=-=-=-=-=-=- TEST: tScroller -=-=-=-=-=-=-=-
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

#define test
#endif'test
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

type tScroller extends Object
	declare constructor()
	declare destructor()
	'
	nlines as Integer						'total lines
	offset as Integer						'scrolling starts at
	offsetx as Integer						'scrolling starts at
	'
	pheight as Integer						'represented via the scroller in lines
	height as Integer						'height/number of visible lines
	'
	xwidth as Integer						'xwidth/number of visible columns
	longestline as Integer					'limits horizontal scrolling
	'
	bHorizontal as Integer = true			'enable scrolling
	bVertical as integer = true						
	'
	declare function Getkey(accept as string="",deny as string="") as String
	declare function Init(iLines as integer, bScrollbar as integer=true) as integer
End Type

type tAreaScroller extends tScroller
	declare constructor()
	declare destructor()
	'
	x as Integer 
	y as Integer 
	fg as Integer=14 
	bg as Integer=5
	'
	xoffset as Integer	'border-offset
	yoffset as Integer	'border-offset
	mwx as Integer		'max width x
	mhy as Integer		'max height y
	'
	declare function Drawborder() as integer
	'
	cHoriz as string=chr(250)
	declare function Scrollbar() as integer
End Type


type tArrayScroller extends tAreaScroller 
	declare constructor()
	declare destructor()
	'
	text as string							'textbox text 
	wid as Integer							'textbox width to be used
    'ancestor longestline as integer 		'computed with bCount
    lcount as integer						'computed with bCount
	declare function Textbox(bCount as integer=false) as integer	
	
	bScrollbar as Integer
	declare function Scrollbox(byref aText as string,iWid as integer=20) as integer
End Type


#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tScroller -=-=-=-=-=-=-=-

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tScroller -=-=-=-=-=-=-=-
namespace nsScroller
function init(iAction as integer) as integer
	return 0
end function
end namespace'nsScroller


Constructor tScroller()
End Constructor

Destructor tScroller()
End Destructor

function tScroller.Init(iLines as integer, bScrollbar as integer=true) as integer
	nlines= iLines
    if tScreen.isGraphic then
    	xWidth= tScreen.gtw 
    	height= tScreen.gth 
    else
	    xwidth=(width() and &hFFFF)		' width is easy.
	    height=(width() shr (4*4))		' gives screen/console height
	    if (height>25) then height=25	' limit console height to 25 (at least on windows)    	
    EndIf
   	pheight=height-1			' take off 1 line for instructions and we get the viewport
    if pheight>nlines then		' viewport-height is more than lines of text to show 
   		pheight=nlines
    EndIf
	if bScrollbar then xwidth -=1
	return true
end function


function tScroller.Getkey(accept as string="",deny as string="") as String		'
	dim key as String
	dim i as Integer
	dim di as Integer
	
	while true
        key=uConsole.keyinput(accept,deny) '("12346789 ")'  key=keyin("12346789 ",1)
		di=uConsole.getdirection(key)

		i=0
        if di=7 then			'home
        	if bVertical then offset=0
        	if bHorizontal then offsetx=0
        	if bVertical or bHorizontal then i=1
        elseif di=1 then			'end
        	if bVertical then offset=nlines-pheight
        	if bHorizontal then offsetx=0
        	if bVertical or bHorizontal then i=1
        EndIf
		'
		if bVertical then
	        'if di=9 then			'pgup
	        if uConsole.keyaccept(key,keyl_menup) then 
	        	offset=offset-(height-1)
	        	i=1
	        'elseif di=3 then			'pgdn
	        elseif uConsole.keyaccept(key,keyl_mendn) then 
	        	offset=offset+(height-1)
	        	i=1
	        elseif di=2 then			
	        	offset=offset+1
	        	i=1
	        elseif di=8 then
	        	offset=offset-1
	        	i=1
	        endif
	        '
	        if offset>nlines-height+1 then offset=nlines-height+1
	        if offset<0 then offset=0
		EndIf
        '
        if bHorizontal then
	        if key=key__Ins then 
	        	offsetx=offsetx-(xwidth\2)
	        	i=1
	        elseif key=key__Del then 
	        	offsetx=offsetx+(xwidth\2)
	        	i=1
	        elseif di=4 then
	        	offsetx=offsetx-1
	        	i=1
	        elseif di=6 then
	        	offsetx=offsetx+1
	        	i=1
	        endif
	        '
	        if offsetx>longestline-xwidth then offsetx=longestline-xwidth
	        if (offsetx<0) or (xwidth>=longestline) then offsetx=0
        EndIf
		'
		if (i>0) or uConsole.Closing<>0 or uConsole.keyonwards(key) then exit while
	wend	
    return key
End Function

'

Constructor tAreaScroller()
End Constructor

Destructor tAreaScroller()
End Destructor

function tAreaScroller.Drawborder() as Integer
	return draw_border(xoffset,yoffset,mwx,mhy)
end function


function tAreaScroller.Scrollbar() as Integer
	dim iStartingline as Integer=	Offset
	dim iTotalLines as Integer=		nLines
	
    dim as double oneline
    dim as integer balkenh,offset2

	if pHeight>=iTotalLines then iStartingline=0		'already viewing the whole thing
	if iStartingline>iTotalLines-pHeight then iStartingline= iTotalLines-pHeight	'keep the scroller visible at the bottom
	
		
	dim as integer bReserveSpace, bShowMarkers
	bShowMarkers= pHeight>=6	'leaves -2 spaces to indicate the position
	bReserveSpace= pHeight>=10	'reserve -2 top and bottom slots to indicate bof/eof

	
	if bReserveSpace then iTotalLines -=2 'reserve top and bottom scrollbar positions vis 2 lines
	 
	'DbgPrint("--")
	'DbgPrint(iStartingline &" "& oneline  &" "& balkenh &" " & offset2)				
	'DbgPrint(iTotalLines &" "& iLinesShown  &" "& pHeight &" " )				
	'
    '
	dim as integer f,t,adj
	f=0 '1
	t=pHeight-2
	'
    if bShowMarkers then
		if tScreen.isGraphic then
		    tScreen.draw2c(x,y+f,chr(220))			'put a marker on top
		    tScreen.draw2c(x,y+t,chr(223))			'put a marker below
		else
		    tScreen.xy(x,y+f,chr(220))				'put a marker on top
		    tScreen.xy(x,y+t,chr(223))				'put a marker below
		endif
    	f += 1
    	t -= 1
    	adj +=1
    else
	endif
	'
    if bReserveSpace then
		if (iStartingline=0) then					'at the top
			if tScreen.isGraphic then
	    	    tScreen.draw2c(x,y+f,chr(178))		'indicate contents
			else
				tScreen.xy(x,y+f,chr(178))			'indicate contents
			endif
		elseif (iStartingline+pHeight-adj>iTotalLines) then		'at the bottom
			if tScreen.isGraphic then
	    	    tScreen.draw2c(x,y+t,chr(178))		'indicate contents
			else
				tScreen.xy(x,y+t,chr(178))			'indicate contents
			endif
		else										'in-between
			if tScreen.isGraphic then
	    	    tScreen.draw2c(x,y+f,cHoriz)		'indicate no-contents
	    	    tScreen.draw2c(x,y+t,cHoriz)		'indicate no-contents
			else
				tScreen.xy(x,y+f,cHoriz)			'indicate no-contents
				tScreen.xy(x,y+t,cHoriz)			'indicate no-contents
			endif
			f +=1									'reserve top and bottom scrollbar positions
			t -=1
	    	adj +=1
		endif
    endif
	'
    oneline=(t-f+1)/iTotalLines						'% of total represented by one scrollbar-unit
    balkenh=fix(pHeight*oneline)				'% of total lines shown in scrollbar-units
    offset2=fix((iStartingline+1)*oneline)			'starting line in scrollbar-units
	'
	'tScreen.xy(1,2)	
	'DbgPrint( "f:" & f &" t:" & t &" iStartingline:" & iStartingline &" oneline:" & oneline &" balkenh:" & balkenh &" offset2:" & offset2 )	
	dim as integer i
    for i=0 to t-f
		if tScreen.isGraphic then
	        if i>=offset2 and i<=offset2+balkenh then
	    	    tScreen.draw2c(x,y+f+i,chr(178))
	        else
	    	    tScreen.draw2c(x,y+f+i,cHoriz)
	        endif
		else
	        if i>=offset2 and i<=offset2+balkenh then
				tScreen.xy(x,y+f+i,chr(178))
	        else
				tScreen.xy(x,y+f+i,cHoriz)'" ") 
	        endif
		endif
    next
    return 0
end function

'

Constructor tArrayScroller()
End Constructor

Destructor tArrayScroller()
End Destructor

function tArrayScroller.textbox(bCount as integer=false) as Integer
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
    lcount=0    
    longestline=0 
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

    if bCount then
        'longestline
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
    return lcount
end function


'

function tArrayScroller.Scrollbox(byref atext as string,iWid as integer=20) as integer
	dim as short h 
	dim as short w 
	dim as short w2 
	text= atext

	wid=iWid
	Textbox(true)	'guess width/height
	w=longestline
	wid=w
	Textbox(true)	'better guess width/height

	
	xoffset=x-1
	yoffset=y-1
	mwx= wid+2
	mhy= lcount+2
	Drawborder() 'accept and draw a border. returns actual height used.
	'h -=2			'take off the offsets and we now know the height of the visible text
	DbgPrint("wid:"& wid &" longestline:"& longestline &" lcount:"& lcount &" visible:"& h)

	init(201,true)
	xwidth=Wid	
	height=mhy-1
	pheight=mhy-1
	
	Textbox(false)' text ,x,y,xwidth,fg,bg,0,0,offset)	'now place the text
	
	'DbgPrint("a.offset, a.nlines, a.pheight, a.height, x+a.xwidth")
	'DbgPrint(offset & " " & nlines & " " & pheight & " " & height & " " & x+xwidth+1)
	
	if bScrollbar then
		x += xwidth
		Scrollbar() 'a.offset, a.nlines, a.pheight, a.pheight, x+a.xwidth+1, y, fg, chr(124))
		x -= xwidth		
	EndIf
	return true
end function

#endif'main


#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tScroller -=-=-=-=-=-=-=-
	tModule.register("nsScroller",@nsScroller.init()) ',@nsScroller.load(),@nsScroller.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tScroller -=-=-=-=-=-=-=-
#undef test
'#include "uWindows.bas" 'auto-close
ReplaceConsole()
    
    
sub testScrollbox()    
	dim as string text= "display in the fabulous textbox!"' you know, the one that will get its scrollbars back soon. yeah."
	dim as string atext
	dim as integer w2
	for w2=1 to 200
		atext +="|"& w2 &text
	Next
	
	'draw_border(1,1,40,30)
	'sleep
	
	tScreen.res
	tScreen.drawfx(8,8)
	
	dim a as tArrayScroller
	a.x=	8
	a.y=	16
	a.fg=	15
	a.bg=	5
	a.bScrollbar=true
	
	while not uConsole.Closing
		cls
		tScreen.set(0)
		tScreen.rbgcolor(255,255,255)
		
		tScreen.xy(10,2,tModule.Status())
		tScreen.xy(10,5)
		
		draw_border(1,1,42,30)
		draw_border(3,3,42,30)
		draw_border(5,5,42,30)
	
		a.Scrollbox(aText,20)
		
	    ScreenSync
		ScreenCopy
	'   tScreen.set()
		if uConsole.keyaccept(a.GetKey(),keyl_onwards) then exit while
	wend
end sub

testScrollbox()

#endif'test
