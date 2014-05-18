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
#include "uDebug.bas"

#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tTextbox -=-=-=-=-=-=-=-

declare function scroll_bar(offset as short,linetot as short,lineshow as short,winhigh as short, x as short,y as short,col as short) as short
declare function textbox(text as string,x as short,y as short,w as short,_
    fg as short=11, bg as short=0,pixel as byte=0,byref op as short=0,byref offset as short=0) as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tTextbox -=-=-=-=-=-=-=-

namespace tTextbox
function init(iAction as integer) as integer
	return 0
end function
end namespace'tTextbox


#define cut2top


function scroll_bar(offset as short,linetot as short,lineshow as short,winhigh as short, x as short,y as short,col as short) as short
    dim as single part,i,balkenh,offset2,oneline
    oneline=winhigh/(linetot-1)
    balkenh=cint(lineshow*oneline)
    offset2=cint(offset*oneline)
    for i=0 to winhigh
        if i>=offset2 and i<=offset2+balkenh then
            set__color(col,0)
        else
            set__color(0,0)
        end if

        tScreen.draw2c(x,y+(i)*_fh2,chr(178)) '"¦"
        'draw string(x,y+(i)*_fh2),chr(178),,font2,custom,@_col
    next
    return 0
end function


function textbox(text as string,x as short,y as short,w as short,_
    fg as short=11, bg as short=0,pixel as byte=0,byref op as short=0,byref offset as short=0) as short
    'op=1 only count lines, don't print
    dim as short lastspace,tlen,p,wcount,lcount,xw,a,longestline,linecount,maxlines,blocks
    dim words(6023) as string
    dim addt as string
    addt=text

    if pixel=0 then
        x=x*_fw1
        y=y*_fh1
    endif
    maxlines=(20*_fh1-y)/_fh2
    'if len(text)<=w then addt(0)=text
    for p=0 to len(text)
        if mid(text,p,1)="{" or mid(text,p,1)="|" then wcount+=1
        words(wcount)=words(wcount)&mid(text,p,1)
        if mid(text,p,1)=" " or mid(text,p,1)="|" or  mid(text,p,1)="}" then wcount+=1
    next
    if words(wcount)<>"|" and bg<>0 and pixel=0 then
        wcount+=1
        words(wcount)="|"
    endif
    set__color( fg,bg)
    'Count lines
    for p=0 to wcount
        if words(p)="|" then
            linecount+=1
            xw=0
        else
            if xw+len(words(p))>w then
                linecount+=1
                xw=0
            endif
            xw=xw+len(words(p))
        endif
    next
    xw=0
    if offset>0 and linecount-offset<maxlines-1 then offset=linecount-maxlines-1
    if offset<0 then offset=0

    for p=0 to wcount

        if words(p)="|" then 'New line
            if op=0 and lcount-offset>=0  and (lcount-offset)<=maxlines then 
				tScreen.draw2c((x)+xw*_fw2,y+(lcount-offset)*_fh2,space(w-xw))
				'draw string((x)+xw*_fw2,y+(lcount-offset)*_fh2),space(w-xw),,font2,custom,@_col
            EndIf
            lcount=lcount+1
            xw=0
        endif

        if Left(trim(words(p)),1)="{" and Right(trim(words(p)),1)="}" then 'Color
            set__color( numfromstr(words(p)),bg)
        endif

        if words(p)<>"|" and not(Left(trim(words(p)),1)="{" and Right(trim(words(p)),1)="}") then 'Print word
            if xw+len(words(p))>w then 'Newline
                if op=0 and lcount-offset>=0 and (lcount-offset)<=maxlines then 
                	tScreen.draw2c((x)+xw*_fw2,y+(lcount-offset)*_fh2,space(w-xw))
                EndIf
                lcount=lcount+1
                xw=0
            endif
            if op=0 and lcount-offset>=0 and (lcount-offset)<=maxlines then 
               	tScreen.draw2c((x)+xw*_fw2,y+(lcount-offset)*_fh2,words(p))          	
            EndIf
            xw=xw+len(words(p))
            if xw>longestline then longestline=xw
        endif

        if (lcount-offset)>maxlines then 'Too long
            if op<>0 then
                op=longestline
                return lcount
            endif
            set__color( fg,bg)
        endif
    next
    if linecount>maxlines then
        if offset>0 then
            set__color(14,0)
        else
            set__color(14,0,0)
        endif
        tScreen.draw2c(x+w*_fw2-_fw2,y						,chr(24))
        tScreen.draw2c(x+w*_fw2-_fw2,y+_fh2					,"-")
        if offset+maxlines<linecount-1 then
            set__color(14,0)
        else
            set__color(14,0,0)
        endif
        tScreen.draw2c(x+w*_fw2-_fw2,y+maxlines*_fh2-_fh2	,"+")
        tScreen.draw2c(x+w*_fw2-_fw2,y+maxlines*_fh2		,chr(25))

        DbgPrint("LC:" &linecount &"ML:"&maxlines)
        scroll_bar(offset,linecount,maxlines,maxlines-4,x+w*_fw2-_fw2,y+2*_fh2,14)
    endif
    text=addt
    set__color(11,0)
    op=longestline
    return lcount
end function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tTextbox -=-=-=-=-=-=-=-
	tModule.register("tTextbox",@tTextbox.init()) ',@tTextbox.load(),@tTextbox.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tTextbox -=-=-=-=-=-=-=-

'textbox(text as string,x as short,y as short,w as short,_
'    fg as short=11, bg as short=0,pixel as byte=0,byref op as short=0,byref offset as short=0) as short
    
    
dim text as string		= "kslf jlekrfj ksdfjvlkdsajfklj fklvj lekrtioeufidclvj;lgk ae;rtl d;flk;dlft o"
dim x as short			= 10
dim y as short			= 10
dim w as short			= 16
dim fg as short			= 11
dim bg as short				= 0
dim pixel as byte			= 0
'dim byref op as short 		= 0
'dim byref offset as short	= 0
    
'textbox(text,x,y,w,fg,bg,pixel),op,offset) ',fg,bg,pixel) ,op,offset)

textbox(text,x,y,w) 

uConsole.pressanykey

#endif'test
