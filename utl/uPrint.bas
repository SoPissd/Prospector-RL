'tPrint.
'
'defines:
'scrollup=0, locEOL=0, rlprint=1759
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
'     -=-=-=-=-=-=-=- TEST: tPrint -=-=-=-=-=-=-=-
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

#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tPrint -=-=-=-=-=-=-=-

Dim Shared displaytext(255) As String
Dim Shared dtextcol(255) As Short

Dim Shared As Byte _lines=25
Dim Shared As Byte _textlines

declare function calcosx(x as short,wrap as byte) as short 'Caculates Ofset X for windows less than 60 tiles wide


Const c_red=12
Const c_gre=10
Const c_yel=14

declare function rlprint(t as string, col as short=11) as short

'declare function scrollup(b as short) as short
'declare function locEOL() as _cords

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tPrint -=-=-=-=-=-=-=-

namespace tPrint
function init(iAction as integer) as integer
	return 0
end function
end namespace'tPrint

function scrollup(b as short) as short
    dim as short a,c
    for c=0 to b
        for a=0 to 254
            displaytext(a)=displaytext(a+1)
            dtextcol(a)=dtextcol(a+1)
        next
        displaytext(255)=""
        dtextcol(255)=11
    next
    return 0
end function


function locEOL() as _cords
    'puts cursor at end of last displayline
    dim as short y,x,a,winh,firstline
    dim as _cords p
	if tScreen.isGraphic then
'?"	    winh=fix((tScreen.y-_fh1*22)/_fh2)-1"
	    winh=fix((tScreen.y-_fh1*22)/_fh2)-1
'?winh
	    do
	        firstline+=1
	    loop until firstline*_fh2>=22*_fh1
	else
		winh= width() shr (4*4)
	EndIf
    y=firstline+winh
    for a=firstline+winh to firstline step -1
        if (a+1>lbound(displaytext)) then exit for
        if (displaytext(a+1)="") then y=a
    next
    if y>lbound(displaytext) then y=lbound(displaytext)
    x=len(displaytext(y))+1		
    p.x=x
    p.y=y
    return p
end function


function rlprint(t as string, col as short=11) as short
	dim as Integer no_key
    dim as short a,b,c,delay
    dim text as string
    dim wtext as string
    'static offset as short
    dim tlen as short
    'dim addt(64) as string
    dim lastspace as short
    dim key as string
    dim as short winw,winh
    dim firstline as byte
    dim words(4064) as string
    static curline as single
    static lastmessage as string
    static lastmessagecount as short
'if tScreen.isGraphic then
    firstline=fix((22*_fh1)/_fh2)
    winw=fix(((_fw1*_mwx+1))/_fw2)
    winh=fix((tScreen.y-_fh1*22-_fh2)/_fh2)
'else
''	_fh1=8
'	_fh2=8
'    winw=(width() and &hFFFF)' gives screen/console width
'    winh=(width() shr (4*4)) ' gives screen/console height
'    firstline=22
'    _lines=winh
'endif
    if t<>"" then
	'    firstline=0
	'    do
	'        firstline+=1
	'    loop until firstline*_fh2>=22*_fh1
	'
	    if _fh1=_fh2 then
	        firstline=22
	        winh=_lines-22
	    endif
	'?"curline=locEOL.y+1"
	    curline=locEOL.y+1
	'?"=",curline
	    for a=0 to len(t)
	        if mid(t,a,1)<>"|" then text=text & mid(t,a,1)
	    next
	    
	    if text<>"" and len(text)<winw-4 then
	        if lastmessage=t then
	            a=curline-1
	            lastmessagecount+=1
	            if len(displaytext(a))<winw-4 then
	                displaytext(a)=text &"(x"&lastmessagecount &")"
	                t=""
	            else
	                displaytext(a)=text
	                displaytext(a+1)="(x"&lastmessagecount &")"
	                t=""
	            endif
	            text=""
	        else
	            lastmessage=t
	            lastmessagecount=1
	        endif
	    endif
	
	    'draw string (61*_fw1,firstline*_fh2),"*",,font1,custom,@_col
	    'draw string (61*_fw1,(firstline+winh)*_fh2),"*",,font1,custom,@_col
	    'find offset
	    'if offset=0 then offset=firstline
	
	    if text<>"" then
	        while displaytext(curline)<>""
	            curline+=1
	        wend
	        for a=0 to len(text)
	            words(b)=words(b)&mid(text,a,1)
	            if mid(text,a,1)=" " then b+=1
	        next
	        for a=0 to b
	            if instr(ucase(words(a)),"\C")>0 then
	                words(a)="Ctrl-"&right(trim(words(a)),1) &" "
	            endif
	        next
	        for a=0 to b
	            if len(displaytext(curline+tlen))+len(words(a))>=winw then
	                displaytext(curline+tlen)=trim(displaytext(curline+tlen))
	                tlen+=1
	            endif
	            displaytext(curline+tlen)=displaytext(curline+tlen)&words(a)
	            dtextcol(curline+tlen)=col
	        next
	
	        if curline+tlen>firstline+winh then
	            if tlen<winh then
	                scrollup(tlen-1)
	            else
	                do
	                    scrollup(winh-2)
	                    for b=firstline to firstline+winh
	                        set__color( 0,0)
	                        tScreen.draw2c(0,b*_fh2, space(winw))
	                        'draw string(0,(b-firstline)*_fh2+22*_fh1), space(winw),,font2,custom,@_col
	                        'draw string(0,b*_fh2), space(winw),,font2,custom,@_col
	                        set__color( dtextcol(b),0)
	                        tScreen.draw2c(0,b*_fh2, displaytext(b))
	                        'draw string(0,b*_fh2), displaytext(b),,font2,custom,@_col
	                        'draw string(0,(b-firstline)*_fh2+22*_fh1), displaytext(b),,font2,custom,@_col
	                    next
	                    set__color( 14,1)
	                    if displaytext(firstline+winh+1)<>"" then
	                        tScreen.draw2c((winw+1)*_fw2,tScreen.y-_fh2, chr(25)) 'Ctrl-Y???
	                        'draw string((winw+1)*_fw2,tScreen.y-_fh2), chr(25),,font2,custom,@_col
	                        no_key=uConsole.iGetKey() 'keyin
	                    endif
	                loop until displaytext(_textlines+1)=""
	            endif
	        else
	            if curline=firstline+winh then scrollup(0)
	        endif
	        while displaytext(_textlines+1)<>""
	            scrollup(0)
	        wend
	    endif
    endif
    
    for b=firstline to firstline+winh
        set__color( 0,0)
        'draw string(0,(b-firstline)*_fh2+22*_fh1), space(winw),,font2,custom,@_col
        'draw string(0,b*_fh2), space(winw),,font2,custom,@_col
        tScreen.draw2c(0,b*_fh2, space(winw))
        if b<ubound(dtextcol) then set__color( dtextcol(b),0)
        'draw string(0,(b-firstline)*_fh2+22*_fh1), displaytext(b),,font2,custom,@_col
        if b<ubound(displaytext) then tScreen.draw2c(0,b*_fh2, displaytext(b))
    next
    locate 24,1
    set__color( 11,0)
    return 0
end function


function calcosx(x as short,wrap as byte) as short 'Caculates Ofset X for windows less than 60 tiles wide
    dim osx as short
    osx=x-_mwx/2
    if wrap>0 then
        if osx<0 then osx=0
        if osx>60-_mwx then osx=60-_mwx
    endif
    if _mwx=60 then osx=0
    return osx
end function


function askyn(q as string,col as short=11,sure as short=0) as short
    dim key as string '*1
'    rlprint (q,col)
    do
        key=uConsole.keyinput()
'? key        
'        key=keyin
        displaytext(_lines-1) &= key
        if key <>"" then 
			rlprint ""
			'if configflag(con_anykeyno)=0 and not isKeyYes(key) then key="N"
        endif
    loop until (uConsole.Closing<>0) or (uConsole.isKeyNo(key)) or uConsole.isKeyYes(key)  
    
    if uConsole.isKeyYes(key) then 
	    if (sure=1) then 
			return askyn("Are you sure? Let me ask that again:" & q,0)    	
	    EndIf
        rlprint "Yes.",15
        return -1
    else
        rlprint "No.",15
        return 0
    endif
end function


#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tPrint -=-=-=-=-=-=-=-
	tModule.register("tPrint",@tPrint.init()) ',@tPrint.load(),@tPrint.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tPrint -=-=-=-=-=-=-=-
#undef test
#endif'test
