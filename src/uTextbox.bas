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
#Print("uDebug loaded")				
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

#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tTextbox -=-=-=-=-=-=-=-

declare function textbox(text as string,x as short,y as short,w as short,_
    fg as short=11, bg as short=0,pixel as byte=0,byref op as short=0,byref offset as short=0) as short
declare function scroll_bar(offset as short,linetot as short,lineshow as short,winhigh as short, x as short,y as short,col as short) as short
declare function draw_border(xoffset as short,yoffset as short,mwx as short,mhy as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tTextbox -=-=-=-=-=-=-=-
namespace tTextbox
function init(iAction as integer) as integer
	return 0
end function
end namespace'tTextbox

conprint->ConsolePrint("text")
DbgPrint("HEAD")				

function textbox(text as string,x as short,y as short,wid as short,_
    fg as short=11, bg as short=0,pixel as byte=0,byref op as short=0,byref offset as short=0) as short
    'op=1 only count lines, don't print
   
conprint->ConsolePrint("HEAD")
DbgPrint("HEAD")				

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

	'for i = 0 to wcount: ? ":"+words(i)+":",len(words(i)) :Next :uConsole.pressanykey(0)
    'if words(wcount)<>"|" and bg<>0 and pixel=0 then
    '    wcount+=1
    '    words(wcount)="|"
    'endif
   
    'Count lines
    dim as string w
    dim as integer xw,xwn 
    dim as integer longestline
    dim as integer lcount
     
    for i=0 to wcount
		w= trim(words(i))
		if len(w)>wid then continue for 'already accounted for the long word
'DbgPrint(""&w &" "& lcount &" "& longestline &" " + w)				
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
    next
    if xw>0 then
		lcount+=1
    	xw=0
    EndIf
    
tScreen.xy(10,8)
 ? x,y,lcount,longestline

    if op<>0 then
        op=longestline
        return lcount
    endif
    
    'restrain offset
    if offset>0 and lcount-offset<maxlines-1 then offset=lcount-maxlines-1
    if offset<0 then offset=0
    
tScreen.xy(10,9)
? "LL",longestline


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
            'if j>=0 and j<maxlines then
            if j>=maxlines then exit for 
			tScreen.draw2c(x+xw,y+j,space(wid-xw))
            lcount += 1
            xw=0
        else			 											'Print word
            if (len(trim(words(i+1)))>wid) or (xw+len(w)>wid) then	'Newline before long word or line to long
                if j>=maxlines then exit for	
				tScreen.draw2c(x+xw,y+j,space(wid-xw))
                lcount += 1
		       	j= lcount-offset
                xw=0
            EndIf
			if j>=maxlines then exit for
			tScreen.draw2c(x+xw,y+j,w)          	
            xw=xw+len(w)
        endif
		'if j<0 or j>=maxlines then exit for						'Too long
    next
    
tScreen.xy(10,9)
? "LL",longestline
    
    'if linecount>maxlines then
    '    if offset>0 then
    '        set__color(14,0)
    '    else
    '        set__color(14,0,0)
    '    endif
    '    tScreen.draw2c(x+w-1,y              ,chr(24))
    '    tScreen.draw2c(x+w-1,y+1            ,"-")
    '    if offset+maxlines<linecount-1 then
    '        set__color(14,0)
    '    else
    '        set__color(14,0,0)
    '    endif
    '    tScreen.draw2c(x+w-1,y+maxlines-1	,"+")
    '    tScreen.draw2c(x+w-1,y+maxlines		,chr(25))

    '    DbgPrint("LC:" &linecount &"ML:"&maxlines)
    '    scroll_bar(offset,linecount,maxlines,maxlines-4,x+w-1,y,14)
    'endif
    set__color(11,0)
    op=longestline
    return lcount
end function


function scroll_bar(offset as short,linetot as short,lineshow as short,winhigh as short, x as short,y as short,col as short) as short
	'offset as short,	#starting line
	'linetot as short,	#of lines
	'lineshow as short,	#lines showing
	'winhigh,x,y,col	tallness,starting point, color
	
    dim as single part,i,balkenh,offset2,oneline

	if lineshow>=linetot then offset=0							'already viewing the whole thing
	if offset>=linetot-lineshow then offset= linetot-lineshow-1	'keep the scroller visible at the bottom 
    oneline=winhigh/linetot					'% of total represented by one scrollbar-unit
    balkenh=cint(lineshow*oneline)			'% of total lines shown in scrollbar-units
    offset2=cint(offset*oneline)			'starting line in scrollbar-units

    tScreen.drawfx( _fw1,_fh1)
    set__color(col,0)
    tScreen.draw2c(x,y-1,chr(220))			'put a marker on top
    tScreen.draw2c(x,y+winhigh,chr(223))	'put a marker below
    for i=0 to winhigh-1
        if i>=offset2 and i<=offset2+balkenh then
            set__color(col,0)
        else
            set__color(0,0)
        endif
        tScreen.draw2c(x,y+i,chr(178)) '"¦"
        'draw string(x,y+(i)*_fh2),chr(178),,font2,custom,@_col
    next
    tScreen.drawfx()
    set__color(col,0)
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
#include "uWindows.bas" 'auto-close

    
dim as string text
dim as short w 
dim as short w2 

'       12345678901234567890
text = "abcde fgh||ijkl mnopq"
text+= " rstu vwxyz ab cde fgh"
text+= " ijklmnopqrstuvwxyzabcde"
text+= " fgh ijkl mnopq rstu"
text+= " vwxyz"

text= "here is a new text string for display in the fabulous textbox! you know, the one that will get its scrollbars back soon. yeah."
w= 20


dim fg as short			= 11
dim bg as short			= 0
dim pixel as byte			= 0
'dim byref op as short 		= 0
'dim byref offset as short	= 0
    
'textbox(text,x,y,w,fg,bg,pixel),op,offset) ',fg,bg,pixel) ,op,offset)

fg=15
bg=5
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

x=12
y=16
w2=1
h=textbox(text,x,y,w,,,,w2)
w=w2
w2=1
h=textbox(text,x,y,w,,,,w2)
'? w2 &"*******************" 
draw_border(x-1,y-1,w2+2,h+2)
textbox(text,x,y,w2,fg,bg) 

x=48
y=16
h=textbox(text,x,y,w,,,,1)',w) 
draw_border(x-1,y-1,w+2,h+2)
textbox(text,x,y,w,fg,bg,,0,3) 


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
