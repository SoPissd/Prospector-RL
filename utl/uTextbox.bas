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
#include "uScreen.bas"
#include "uDebug.bas"
#include "file.bi"
#include "uFile.bas"
#include "uColor.bas"
#include "uConsole.bas"
#include "uVersion.bas"
#include "uUtils.bas"
#include "uError.bas"
#include "uRng.bas"
#include "uCoords.bas"
#include "uPrint.bas"
#include "uWindows.bas"

#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tTextbox -=-=-=-=-=-=-=-

declare function textbox(text as string, x as short, y as short, wid as short,_
    fg as short=11, bg as short=0,pixel as byte=0,byref op as short=0,byref offset as short=0) as short

declare function scroll_bar(iStartingline as short, iTotalLines as short, iLinesShown as short, _
	iScrollerHeight as short, x as short=0, y as short=0, fg as short=0) as short

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


function textbox(text as string, x as short, y as short, wid as short,_
    fg as short=11, bg as short=0,pixel as byte=0,byref op as short=0,byref offset as short=0) as short
    'op=1 only count lines, don't print

	assert(pixel=0)
    tScreen.drawfx( _fw1,_fh1)

    dim as integer maxlines
	if tScreen.isGraphic then
	    maxlines=tScreen.gth
	else
	    maxlines=25 'uConsole.tth
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
            lcount=lcount+1
            if xw>longestline then longestline=xw
            xw=0
        elseif Left(w,1)<>"{" and Right(w,1)<>"}" then 'Printable word
        	xwn=len(trim(words(i+1)))
        	if xwn>wid then
                lcount=lcount+2 'finish first + long word on a line by itself
	            if xwn>longestline then longestline=xwn
                xw=0
        	else
	            xw=xw+len(w)
	            if xw>wid then
	                lcount=lcount+1
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
    
    lcount=0
    dim as integer j
    dim as integer isCol=0

    for i=0 to wcount
		w= trim(words(i))
       	j= lcount-offset

        isCol= Left(w,1)="{" and Right(w,1)="}" 					'Color spec'd 
        if isCol then
			set__color( numfromstr(w),bg)
        elseif w="|" then 											'New line
            if y+j>=maxlines then exit for
			if j>=0 then tScreen.draw2c(x+xw,y+j,space(wid-xw))
            lcount += 1
            xw=0
        else			 											'Print word
            if (len(trim(words(i+1)))>wid) or (xw+len(w)>wid) then	'Newline before long word or line to long
                if y+j>=maxlines then exit for
				if j>=0 then tScreen.draw2c(x+xw,y+j,space(wid-xw))
                lcount += 1
		       	j= lcount-offset
                xw=0
            EndIf
			if y+j>=maxlines then exit for
			if j>=0 then tScreen.draw2c(x+xw,y+j,w)
            xw=xw+len(w)
        endif
		'DbgPrint(lcount &" "& j &" "& longestline &" "& xw &" " & len(w) &" "& ":"+w+":")
    next
    
    ''the spaces left between chars need to be dealt with by a different version of the draw-string code
    ''http://www.freebasic.net/forum/viewtopic.php?f=3&t=17546&p=154151&hilit=draw+string+text+width#p154151
	'tScreen.rbgcolor(255,255,255)
	'for i=0 to wid-1
	'	tScreen.draw2c(x+i,y+lcount+1,right(""&i,1))    	
	'Next
	'DbgPrint(x &" "& y &" "& longestline &" "& maxlines)				


DbgPrint(""&y &" "& lcount &" "& maxlines)
    
    if y+lcount>=maxlines then									' a full-screen textbox... for the finale

        if offset>0 then
            set__color(14,0)
        else
            set__color(14,0,0)
        endif
        
wid -=1        
        tScreen.draw2c(x+wid,y            ,chr(24))
        tScreen.draw2c(x+wid,y+1          ,"-")
        
        if offset+maxlines<lcount-1 then
            set__color(14,0)
        else
            set__color(14,0,0)
        endif
        tScreen.draw2c(x+wid,maxlines-2	,"+")
        tScreen.draw2c(x+wid,maxlines-1	,chr(25))
wid +=1        

        scroll_bar(offset, lcount, maxlines-y, maxlines-y -1 -4,x+wid,y+2,14)
	endif
    
    set__color(11,0)
    op=longestline
    return lcount
end function


function scroll_bar(iStartingline as short, iTotalLines as short, iLinesShown as short, _
	iScrollerHeight as short, x as short=0, y as short=0, fg as short=0) as short
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
	'bShowMarkers= iScrollerHeight>=6	'leaves 3 spaces to indicate the position
	'bReserveSpace= iScrollerHeight>=5	'reserve top and bottom slots to indicate bof/eof

	iScrollerHeight -=1 'now its 0-based internally
	
	if bReserveSpace then iTotalLines -=2 'reserve top and bottom scrollbar positions vis 2 lines
	 
	'DbgPrint("--")
	'DbgPrint(iStartingline &" "& oneline  &" "& balkenh &" " & offset2)				
	'DbgPrint(iTotalLines &" "& iLinesShown  &" "& iScrollerHeight &" " )				
	'
	dim as integer f,t
	f=0 '1
	t=iScrollerHeight-1 'iScrollerHeight-2
	'
	'tScreen.drawfx(_fw1,_fh1)
    set__color(fg,0)
    '
    if bShowMarkers then
		if tScreen.isGraphic then
		    tScreen.draw2c(x,y,chr(220))					'put a marker on top
		    tScreen.draw2c(x,y+iScrollerHeight,chr(223))	'put a marker below
		else
		    tScreen.xy(x,y,chr(220))						'put a marker on top
		    tScreen.xy(x,y+iScrollerHeight,chr(223))		'put a marker below
		endif
    	f += 1
    	t -= 1
    else
	endif
	'
    if bReserveSpace then
		if (iStartingline=0) then									'at the top
			if tScreen.isGraphic then
	    	    tScreen.draw2c(x,y+f,chr(178))						'indicate contents
			else
				tScreen.xy(x,y+f,chr(178))							'indicate contents
			endif
		elseif (iStartingline=iTotalLines-iLinesShown) then		'at the bottom
			if tScreen.isGraphic then
	    	    tScreen.draw2c(x,y+t,chr(178))						'indicate contents
			else
				tScreen.xy(x,y+t,chr(178))							'indicate contents
			endif
		else														'in-between
			if tScreen.isGraphic then
	    	    tScreen.draw2c(x,y+f,chr(250))						'indicate no-contents
	    	    tScreen.draw2c(x,y+t,chr(250))						'indicate no-contents
			else
				tScreen.xy(x,y+f,chr(250))							'indicate no-contents
				tScreen.xy(x,y+t,chr(250))							'indicate no-contents
			endif
		endif
		f +=1		'reserve top and bottom scrollbar positions
		t -=1
    endif
	'
    oneline=(t-f+1)/iTotalLines						'% of total represented by one scrollbar-unit
'    oneline=(iScrollerHeight-2)/iTotalLines			'% of total represented by one scrollbar-unit
    balkenh=fix(iLinesShown*oneline)					'% of total lines shown in scrollbar-units
    offset2=fix((iStartingline+1)*oneline)				'starting line in scrollbar-units
    'if balkenh=0 then balkenh=1
    'if offset2=0 then offset2=1
	'
tScreen.xy(1,2)	
DbgPrint( "f:" & f &" t:" & t &" iStartingline:" & iStartingline &" oneline:" & oneline &" balkenh:" & balkenh &" offset2:" & offset2 )	
'popup(""& balkenh &" "& offset2) 	
	dim as integer i
    set__color(fg,0)
    for i=f to t
		if tScreen.isGraphic then
	        if i>=offset2 and i<=offset2+balkenh then
	    	    tScreen.draw2c(x,y+i,chr(178))
	        else
	    	    tScreen.draw2c(x,y+i,chr(250))
	        endif
		else
	        if i>=offset2 and i<=offset2+balkenh then
				tScreen.xy(x,y+i,chr(178))
	        else
				tScreen.xy(x,y+i,chr(250))'" ") 
	        endif
		endif
        'draw string(x,y+(i)*_fh2),chr(178),,font2,custom,@_col
    next
'    tScreen.drawfx()
    return 0
end function

'

function draw_border(xoffset as short) as short
    dim as short fh1,fw1,fw2,a
'    if configflag(con_tiles)=0 then
'        fh1=16
'        fw1=8
'        fw2=_fw2
'    else
        fh1=_fh1
        fw1=_fw1
        fw2=_fw2
'    endif
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


function draw_border(xoffset as short,yoffset as short,mwx as short,mhy as short) as short
    dim as short a
    'dim as short fh1,fw1,fw2,a
    'if configflag(con_tiles)=0 then
    '    fh1=16
    '    fw1=8
    '    fw2=_fw2
    'else
    '    fh1=_fh1
    '    fw1=_fw1
    '    fw2=_fw2
    'endif
    set__color( 224,1)
    tScreen.drawfx( _fw1,_fh1)

    tScreen.draw1c(xoffset,yoffset,chr(195))
    tScreen.draw1c(xoffset,yoffset+mhy-1,chr(195))
    for a=1 to mwx-1
        tScreen.draw1c(xoffset+a,yoffset,chr(196))
        tScreen.draw1c(xoffset+a,yoffset+mhy-1,chr(196))
    next
    for a=yoffset to yoffset+mhy-1
        set__color( 224,1)
        'draw string ((_mwx+1)*_fw1,a),chr(179),,Font1,custom,@_col
        tScreen.draw1c(xoffset,a,chr(179))
        tScreen.draw1c(xoffset+mwx-1,a,chr(179))
        'set__color(0,0)
        'tScreen.draw1c(xoffset+mwx+2,a,space(25))
    next
    set__color( 11,0)
    tScreen.drawfx()
    return 0
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

text= "here is a new text string for display in the fabulous textbox!"' you know, the one that will get its scrollbars back soon. yeah."
w= 20

for w2=1 to 10
	text +="|"+text
Next


dim fg as short			= 15
dim bg as short			= 5

_fw1=10
_fh1=10


tScreen.res
tScreen.drawfx( 10,10)
tScreen.rbgcolor(255,255,255)

tScreen.xy(10,3,tModule.Status())
tScreen.xy(10,5)

draw_border(1,0,40,30)
draw_border(2,2,40,30)
draw_border(4,4,40,30)

dim as short x,y,h

x=8
y=16
w2=1
h=textbox(text,x,y,w,,,,w2)
w=w2
w2=1
h=textbox(text,x,y,w,,,,w2)
'? w2 &"*******************" 
draw_border(x-1,y-1,w2+2,h+2)
textbox(text,x,y,w2,fg,bg,,,0) 

'x=48
'y=16
'h=textbox(text,x,y,w,,,,1)',w) 
'draw_border(x-1,y-1,w+2,h+2)
'textbox(text,x,y,w,fg,bg,,0,3) 

tScreen.xy(10,44)
uConsole.pressanykey(0)
end

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
	
	tScreen.xy(10,44)
	if uConsole.keyaccept(uConsole.pressanykey(0),keyl_onwards) then exit while
wend

#endif'test
