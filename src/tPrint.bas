'tPrint

Dim Shared As Byte _lines=25
Dim Shared As Byte _textlines

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
    winh=fix((_screeny-_fh1*22)/_fh2)-1
    do
        firstline+=1
    loop until firstline*_fh2>=22*_fh1

    y=firstline+winh
    for a=firstline+winh to firstline step -1
        if displaytext(a+1)="" then y=a
    next
    x=len(displaytext(y))+1
    p.x=x
    p.y=y
    return p
end function


function rlprint(t as string, col as short=11) as short
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
    firstline=fix((22*_fh1)/_fh2)
    winw=fix(((_fw1*_mwx+1))/_fw2)
    winh=fix((_screeny-_fh1*22-_fh2)/_fh2)
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
    curline=locEOL.y+1
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
                        'draw string(0,(b-firstline)*_fh2+22*_fh1), space(winw),,font2,custom,@_col
                        draw string(0,b*_fh2), space(winw),,font2,custom,@_col
                        set__color( dtextcol(b),0)
                        draw string(0,b*_fh2), displaytext(b),,font2,custom,@_col
                        'draw string(0,(b-firstline)*_fh2+22*_fh1), displaytext(b),,font2,custom,@_col
                    next
                    set__color( 14,1)
                    if displaytext(firstline+winh+1)<>"" then
                        draw string((winw+1)*_fw2,_screeny-_fh2), chr(25),,font2,custom,@_col
                        no_key=keyin
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
        draw string(0,b*_fh2), space(winw),,font2,custom,@_col
        set__color( dtextcol(b),0)
        'draw string(0,(b-firstline)*_fh2+22*_fh1), displaytext(b),,font2,custom,@_col
        draw string(0,b*_fh2), displaytext(b),,font2,custom,@_col
    next
    locate 24,1
    set__color( 11,0)
    return 0
end function


