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

#define test
#endif'test
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
type tScroller extends Object
	declare constructor()
	declare destructor()
	offset as Integer
	offsetx as Integer
	nlines as Integer
	pheight as Integer
	height as Integer
	xwidth as Integer
	longest as Integer
	declare function Getkey(accept as string="",deny as string="") as String
	declare function Init(iLines as integer, bScrollbar as integer=true) as integer
End Type

type tArrayScroller extends tScroller 
	declare constructor()
	declare destructor()
	x as Integer 
	y as Integer 
	mwx as Integer		'max width x
	mhy as Integer		'max height y
	fg as Integer=15 
	bg as Integer=5
	xoffset as Integer	'border-offset
	yoffset as Integer	'border-offset
	declare function Drawborder() as integer
	text as string 
	lind as Integer
	wid as Integer
	op as Integer=0 
	offset as Integer=0
	declare function Textbox() as integer
	bScrollbar as integer
	iScrollerHeight as integer 
	cHoriz as string=chr(250)
	declare function Scrollbar() as integer
	declare function Scrollbox(byref aText as string,iWid as integer=20) as integer
End Type


#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tTextbox -=-=-=-=-=-=-=-

declare function textbox(text as string, x as short, y as short, wid as short,_
    fg as short=11, bg as short=0,pixel as byte=0,byref op as short=0,byref offset as Integer=0) as short

declare function scroll_bar(iStartingline as short, iTotalLines as short, iLinesShown as short, _
	iScrollerHeight as short, x as short=0, y as short=0, fg as short=0,cHoriz as string=chr(250)) as short

declare function draw_border overload (xoffset as short,yoffset as short,mwx as short,mhy as short) as short
declare function draw_border overload (xoffset as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tTextbox -=-=-=-=-=-=-=-
namespace tTextbox
function init(iAction as integer) as integer
	return 0
end function
end namespace'tTextbox


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
        key=uConsole.keyinput(accept,deny) '("12346789 ")'            key=keyin("12346789 ",1)
		i=0
		di=uConsole.getdirection(key)

        if 	   di=7 then			'home
        	offset=0
        	offsetx=0
        	i=1
        elseif di=1 then			'end
        	offset=nlines-pheight
        	offsetx=0
        	i=1
        'elseif di=9 then			'pgup
        elseif uConsole.keyaccept(key,keyl_menup) then 
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
        elseif di=4 then
        	offsetx=offsetx-1
        	i=1
        elseif di=6 then
        	offsetx=offsetx+1
        	i=1
        elseif key=key__Ins then 
        	offsetx=offsetx-(xwidth\2)
        	i=1
        elseif key=key__Del then 
        	offsetx=offsetx+(xwidth\2)
        	i=1
        endif
		'
		'if offset>nlines then offset=nlines
        if offset>nlines-height+1 then offset=nlines-height+1
        if offset<0 then offset=0
        if offsetx>longest-xwidth then offsetx=longest-xwidth
        if (offsetx<0) or (xwidth>=longest) then offsetx=0
		'
		if (i>0) or uConsole.Closing<>0 or uConsole.keyonwards(key) then
			exit while
		EndIf
	wend
	
    return key
End Function


Constructor tArrayScroller()
End Constructor

Destructor tArrayScroller()
End Destructor


function tArrayScroller.textbox() as Integer
	'iStartingline as short,	#starting line
	'iTotalLines as short,	#of lines
	'iLinesShown as short,	#lines showing
	'iScrollerHeight,x,y,col	tallness,starting point, color
	
	if fg=0 then fg=15
	
    dim as double oneline
    dim as integer balkenh,offset2

	if pheight>=nlines then offset=0		'already viewing the whole thing
	if offset>nlines-pheight then offset= nlines-pheight	'keep the scroller visible at the bottom
	
		
	dim as integer bReserveSpace, bShowMarkers
	bShowMarkers= iScrollerHeight>=6	'leaves -2 spaces to indicate the position
	bReserveSpace= iScrollerHeight>=10	'reserve -2 top and bottom slots to indicate bof/eof

	dim as Integer iTotalLines = nlines
	dim as Integer iScrollerHeight = pheight
	iScrollerHeight 					-=1 'now its 0-based internally	
	if bReserveSpace then iTotalLines 	-=2 'reserve top and bottom scrollbar positions vis 2 lines
	 
	'DbgPrint("--")
	'DbgPrint(iStartingline &" "& oneline  &" "& balkenh &" " & offset2)				
	'DbgPrint(iTotalLines &" "& iLinesShown  &" "& iScrollerHeight &" " )				
	'
    set__color(fg,0)
    '
	dim as integer f,t,adj
	f=0 '1
	t=iScrollerHeight-1 'iScrollerHeight-2
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
		if (offset=0) then					'at the top
			if tScreen.isGraphic then
	    	    tScreen.draw2c(x,y+f,chr(178))		'indicate contents
			else
				tScreen.xy(x,y+f,chr(178))			'indicate contents
			endif
		elseif (offset+pheight-adj>iTotalLines) then		'at the bottom
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
    balkenh=fix(pheight*oneline)				'% of total lines shown in scrollbar-units
    offset2=fix((offset+1)*oneline)					'starting line in scrollbar-units
	'
	'tScreen.xy(1,2)	
	'DbgPrint( "f:" & f &" t:" & t &" iStartingline:" & iStartingline &" oneline:" & oneline &" balkenh:" & balkenh &" offset2:" & offset2 )	
	dim as integer i
    set__color(fg,0)
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


function tArrayScroller.Scrollbar() as Integer
	dim iStartingline as Integer=	Offset
	dim iTotalLines as Integer=		nLines
	dim iLinesShown as Integer=		pHeight
	dim iScrollerHeight as Integer=	pHeight
	
	if fg=0 then fg=15
	
    dim as double oneline
    dim as integer balkenh,offset2

	if iLinesShown>=iTotalLines then iStartingline=0		'already viewing the whole thing
	if iStartingline>iTotalLines-iLinesShown then iStartingline= iTotalLines-iLinesShown	'keep the scroller visible at the bottom
	
		
	dim as integer bReserveSpace, bShowMarkers
	bShowMarkers= iScrollerHeight>=6	'leaves -2 spaces to indicate the position
	bReserveSpace= iScrollerHeight>=10	'reserve -2 top and bottom slots to indicate bof/eof

	iScrollerHeight -=1 'now its 0-based internally
	
	if bReserveSpace then iTotalLines -=2 'reserve top and bottom scrollbar positions vis 2 lines
	 
	'DbgPrint("--")
	'DbgPrint(iStartingline &" "& oneline  &" "& balkenh &" " & offset2)				
	'DbgPrint(iTotalLines &" "& iLinesShown  &" "& iScrollerHeight &" " )				
	'
    set__color(fg,0)
    '
	dim as integer f,t,adj
	f=0 '1
	t=iScrollerHeight-1 'iScrollerHeight-2
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
		elseif (iStartingline+iLinesShown-adj>iTotalLines) then		'at the bottom
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
    balkenh=fix(iLinesShown*oneline)				'% of total lines shown in scrollbar-units
    offset2=fix((iStartingline+1)*oneline)			'starting line in scrollbar-units
	'
	'tScreen.xy(1,2)	
	'DbgPrint( "f:" & f &" t:" & t &" iStartingline:" & iStartingline &" oneline:" & oneline &" balkenh:" & balkenh &" offset2:" & offset2 )	
	dim as integer i
    set__color(fg,0)
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


function scroll_bar(iStartingline as short, iTotalLines as short, iLinesShown as short, _
	iScrollerHeight as short, x as short=0, y as short=0, fg as short=0, cHoriz as string=chr(250)) as short
	'iStartingline as short,	#starting line
	'iTotalLines as short,	#of lines
	'iLinesShown as short,	#lines showing
	'iScrollerHeight,x,y,col	tallness,starting point, color
	
	if fg=0 then fg=15
	
    dim as double oneline
    dim as integer balkenh,offset2

	if iLinesShown>=iTotalLines then iStartingline=0		'already viewing the whole thing
	if iStartingline>iTotalLines-iLinesShown then iStartingline= iTotalLines-iLinesShown	'keep the scroller visible at the bottom
	
		
	dim as integer bReserveSpace, bShowMarkers
	bShowMarkers= iScrollerHeight>=6	'leaves -2 spaces to indicate the position
	bReserveSpace= iScrollerHeight>=10	'reserve -2 top and bottom slots to indicate bof/eof

	iScrollerHeight -=1 'now its 0-based internally
	
	if bReserveSpace then iTotalLines -=2 'reserve top and bottom scrollbar positions vis 2 lines
	 
	'DbgPrint("--")
	'DbgPrint(iStartingline &" "& oneline  &" "& balkenh &" " & offset2)				
	'DbgPrint(iTotalLines &" "& iLinesShown  &" "& iScrollerHeight &" " )				
	'
    set__color(fg,0)
    '
	dim as integer f,t,adj
	f=0 '1
	t=iScrollerHeight-1 'iScrollerHeight-2
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
		elseif (iStartingline+iLinesShown-adj>iTotalLines) then		'at the bottom
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
    balkenh=fix(iLinesShown*oneline)				'% of total lines shown in scrollbar-units
    offset2=fix((iStartingline+1)*oneline)			'starting line in scrollbar-units
	'
	'tScreen.xy(1,2)	
	'DbgPrint( "f:" & f &" t:" & t &" iStartingline:" & iStartingline &" oneline:" & oneline &" balkenh:" & balkenh &" offset2:" & offset2 )	
	dim as integer i
    set__color(fg,0)
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

function draw_border(xoffset as short) as short
    dim as short fh1,fw1,fw2,a
    set__color( 224,1)
    if xoffset>0 then draw string(xoffset*fw2,21*_fh1),chr(195),,Font1,Custom,@_col
    for a=(xoffset+1)*fw2 to (_mwx+1)*_fw1 step fw1
        draw string (a,21*_fh1),chr(196),,Font1,custom,@_col
    next
    for a=0 to tScreen.y-fh1 step fh1
        set__color( 224,1)
        'draw string ((_mwx+1)*_fw1,a),chr(179),,Font1,custom,@_col
        draw string ((_mwx+1)*_fw1,a),chr(179),,Font1,custom,@_col
        set__color(0,0)
        draw string ((_mwx+2)*_fw1,a),space(25),,font1,custom,@_col
    next
    set__color( 224,1)
    draw string ((_mwx+1)*_fw1,21*_fh1),chr(180),,Font1,custom,@_col
    set__color( 11,0)
    return 0
end function


function tArrayScroller.Drawborder() as Integer
    dim as short a
    set__color( 224,1)

	if tScreen.isGraphic then
		if xoffset+mwx-1 > tScreen.gtw then mwx = tScreen.gtw-xoffset+1
		if yoffset+mhy-1 > tScreen.gth then mhy = tScreen.gth-yoffset+1
		
	    for a=1 to mwx-1
	        tScreen.draw1c(xoffset+a,yoffset,		chr(196))
	        tScreen.draw1c(xoffset+a,yoffset+mhy-1,	chr(196))
	    next
	    for a=yoffset to yoffset+mhy-1
	        'draw string ((_mwx+1)*_fw1,a),chr(179),,Font1,custom,@_col
	        tScreen.draw1c(xoffset,a,				chr(179))
	        tScreen.draw1c(xoffset+mwx-1,a,			chr(179))
	        'tScreen.draw1c(xoffset+mwx+2,a,space(25))
	    next
	    tScreen.xy(xoffset,			yoffset,		chr(218))
	    tScreen.xy(xoffset,			yoffset+mhy-1,	chr(192))
	    tScreen.xy(xoffset+mwx-1,	yoffset,		chr(191))
	    tScreen.xy(xoffset+mwx-1,	yoffset+mhy-1,	chr(217))
	else
		if xoffset+mwx-1 > uConsole.ttw then mwx = uConsole.ttw-xoffset+1
		if yoffset+mhy-1 > uConsole.tth then mhy = uConsole.tth-yoffset+1
		
	    for a=1 to mwx-1
	        tScreen.xy(xoffset+a,	yoffset,		chr(196))
	        tScreen.xy(xoffset+a,	yoffset+mhy-1,	chr(196))
	    next
	    for a=1 to mhy-1
	        tScreen.xy(xoffset,		yoffset+a,		chr(179))
	        tScreen.xy(xoffset+mwx-1,yoffset+a,		chr(179))
	    next
	    tScreen.xy(xoffset,			yoffset,		chr(218))
	    tScreen.xy(xoffset,			yoffset+mhy-1,	chr(192))
	    tScreen.xy(xoffset+mwx-1,	yoffset,		chr(191))
	    tScreen.xy(xoffset+mwx-1,	yoffset+mhy-1,	chr(217))
	endif
	
    set__color( 11,0)
    return 0
end function


function draw_border(xoffset as short,yoffset as short,mwx as short,mhy as short) as short
    dim as short a
    set__color( 224,1)

	if tScreen.isGraphic then
		if xoffset+mwx-1 > tScreen.gtw then mwx = tScreen.gtw-xoffset+1
		if yoffset+mhy-1 > tScreen.gth then mhy = tScreen.gth-yoffset+1
		
	    for a=1 to mwx-1
	        tScreen.draw1c(xoffset+a,yoffset,		chr(196))
	        tScreen.draw1c(xoffset+a,yoffset+mhy-1,	chr(196))
	    next
	    for a=yoffset to yoffset+mhy-1
	        'draw string ((_mwx+1)*_fw1,a),chr(179),,Font1,custom,@_col
	        tScreen.draw1c(xoffset,a,				chr(179))
	        tScreen.draw1c(xoffset+mwx-1,a,			chr(179))
	        'tScreen.draw1c(xoffset+mwx+2,a,space(25))
	    next
	    tScreen.xy(xoffset,			yoffset,		chr(218))
	    tScreen.xy(xoffset,			yoffset+mhy-1,	chr(192))
	    tScreen.xy(xoffset+mwx-1,	yoffset,		chr(191))
	    tScreen.xy(xoffset+mwx-1,	yoffset+mhy-1,	chr(217))
	else
		if xoffset+mwx-1 > uConsole.ttw then mwx = uConsole.ttw-xoffset+1
		if yoffset+mhy-1 > uConsole.tth then mhy = uConsole.tth-yoffset+1
		
	    for a=1 to mwx-1
	        tScreen.xy(xoffset+a,	yoffset,		chr(196))
	        tScreen.xy(xoffset+a,	yoffset+mhy-1,	chr(196))
	    next
	    for a=1 to mhy-1
	        tScreen.xy(xoffset,		yoffset+a,		chr(179))
	        tScreen.xy(xoffset+mwx-1,yoffset+a,		chr(179))
	    next
	    tScreen.xy(xoffset,			yoffset,		chr(218))
	    tScreen.xy(xoffset,			yoffset+mhy-1,	chr(192))
	    tScreen.xy(xoffset+mwx-1,	yoffset,		chr(191))
	    tScreen.xy(xoffset+mwx-1,	yoffset+mhy-1,	chr(217))
	endif
	
    set__color( 11,0)
    return mhy
end function


function tArrayScroller.Scrollbox(byref atext as string,iWid as integer=20) as integer
	dim as short h 
	dim as short w 
	dim as short w2 
	text= atext

	w=iWid:	w2=1:	h=Textbox()'atext,x,y,w,,,0,w2)		'guess width/height
	w=w2:	w2=1:	h=Textbox()'atext,x,y,w,,,0,w2)		'better guess width/height
	 
	xoffset=x-1
	yoffset=y-1
	mwx= w2+2
	mhy= h+2
	w=Drawborder() 'x-1,y-1,,)	'accept and draw a border
	
	init(201,true)
	
	height=w-1
	pheight=w-2
	xwidth=w2-1	
	Textbox()' text ,x,y,xwidth,fg,bg,0,0,offset)	'now place the text
	
DbgPrint("a.offset, a.nlines, a.pheight, a.height, x+a.xwidth")
DbgPrint(offset & " " & nlines & " " & pheight & " " & height & " " & x+xwidth+1)
	
	if bScrollbar then Scrollbar() 'a.offset, a.nlines, a.pheight, a.pheight, x+a.xwidth+1, y, fg, chr(124))
	return true
end function

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
    
dim as string text
dim as short w 
dim as short w2 

'       12345678901234567890
text = "abcde fgh||ijkl mnopq"
text+= " rstu vwxyz ab cde fgh"
text+= " ijklmnopqrstuvwxyzabcde"
text+= " fgh ijkl mnopq rstu"
text+= " vwxyz"

text= "display in the fabulous textbox!"' you know, the one that will get its scrollbars back soon. yeah."

dim as string atext
for w2=1 to 200
	atext +="|"& w2 &text
Next



dim fg as short			= 15
dim bg as short			= 5

'draw_border(1,1,40,30)
'sleep


tScreen.res
tScreen.drawfx(8,8)

dim as short x,y,h
dim as Short o = -1

dim a as tArrayScroller
dim bScrollbar as integer = true
while not uConsole.Closing
	cls
	tScreen.set(0)
	tScreen.rbgcolor(255,255,255)
	
	tScreen.xy(10,2,tModule.Status())
	tScreen.xy(10,5)
	
	draw_border(1,1,42,30)
	draw_border(3,3,42,30)
	draw_border(5,5,42,30)

	a.x=8
	a.y=16
	a.Scrollbox(aText,20)
	
			'	w=20:	w2=1:	h=textbox(atext,x,y,w,,,0,w2)		'guess width/height
			'	w=w2:	w2=1:	h=textbox(atext,x,y,w,,,0,w2)		'better guess width/height 
			'					w=draw_border(x-1,y-1,w2+2,h+2)	'accept and draw a border
			'				'	textbox(text,x,y,w2,fg,bg,,,0)	'now place the text 
			'	init(201,true)
			'	height=w-1
			'	pheight=w-2
			'	xwidth=w2-1
			'	'declare function textbox(text as string, x as short, y as short, wid as short,_
			'	'    fg as short=11, bg as short=0,pixel as byte=0,byref op as short=0,byref offset as Integer=0) as short
			'	
			'	textbox(atext,x,y,a.xwidth,fg,bg,0,0,a.offset)	'now place the text
			'	'
			'	'function scroll_bar(iStartingline as short, iTotalLines as short, iLinesShown as short, _
			'	'	iScrollerHeight as short, x as short=0, y as short=0, fg as short=0, cHoriz as string=chr(250)) as short
			'	'iStartingline as short,	#starting line
			'	'iTotalLines as short,	#of lines
			'	'iLinesShown as short,	#lines showing
			'	'iScrollerHeight,x,y,col	tallness,starting point, color
			'tScreen.xy(10,15)
			'DbgPrint("a.offset, a.nlines, a.pheight, a.height, x+a.xwidth")
			'DbgPrint(a.offset & " " & a.nlines & " " & a.pheight & " " & a.height & " " & x+a.xwidth)
			'
			'	if bScrollbar then scroll_bar( a.offset, a.nlines, a.pheight, a.pheight, x+a.xwidth+1, y, fg, chr(124))
			'	'scroll_bar( a.offset, h,w,w-1,x+w2, 		'a.xwidth

	'tScreen.update()

    ScreenSync
	ScreenCopy
'   tScreen.set()
	if uConsole.keyaccept(a.GetKey(),keyl_onwards) then exit while
wend
end

'x=48
'y=16
'h=textbox(text,x,y,w,,,,1)',w) 
'draw_border(x-1,y-1,w+2,h+2)
'textbox(text,x,y,w,fg,bg,,0,3) 


while not uConsole.Closing
	'scroll_bar(offset as short,linetot as short,lineshow as short,winhigh as short, x as short,y as short,col as short) as short
	for w = 0 to 40
tScreen.xy(10,44,pad(20,"scrollbar="&w))
		scroll_bar(  10,  40,  w,20,0,20,11) 'raise lines shown to total
		scroll_bar(   w,  40,  5,20,1,20,11) 'raise offset from first to last line
		'
		scroll_bar(  10,40\4,w\4,20,2,20,11)
		scroll_bar( w\4,40\4,  5,20,3,20,11)
		'
		scroll_bar(  10,40*2,w*2,20,4,20,11)
		scroll_bar( w*2,40*2,  5,20,5,20,11)
		'
tScreen.xy(10,44,pad(25,""))		
		sleep 50		
	Next 
	
	tScreen.xy(10,15)
	if uConsole.keyaccept(uConsole.pressanykey(0),keyl_onwards) then exit while
wend

#endif'test
