


function settactics() as short
    dim as short a
    dim text as string
    screenshot(1)
    text="Tactics:/"
    for a=1 to 6
        if a=player.tactic+3 then
            text=text &" *"&tacdes(a)&"   "
        else
            text=text &"  "&tacdes(a)&"   "
        endif
        text=text &"/"
    next
    text=text &"Exit"
    a=menu(bg_awayteam,text,,,,1)
    if a<7 then
        player.tactic=a-3
    endif
    screenshot(2)
    return 0
end function



function manual() as short
    dim as integer f,offset,c,a,lastspace
    dim lines(512) as string
    dim col(512) as short
    dim as string key,text
    'dim evkey as EVENT
    screenshot(1)
    set__color( 15,0)
    cls
    f=freefile
    if (open ("readme.txt" for input as #f))=0 then
        do
            line input #f,lines(c)
            while len(lines(c))>80
                text=lines(c)
                lastspace=80
                do
                    lastspace=lastspace-1
                loop until mid(text,lastspace,1)=" "
                lines(c)=left(text,lastspace)
                lines(c+1)=mid(text,lastspace+1,(len(text)-lastspace+1))
                c=c+1
            wend
            c=c+1

        loop until eof(f) or c>512
        close #f
        for a=1 to c
            col(a)=11
            if left(lines(a),2)="==" then
                col(a)=7
                col(a-1)=14
            endif
            'if left(lines(a),1)="*" then col(a)=14
        next
        do
            key=""
            cls
            set__color( 11,0)
            for a=1 to 24
                locate a,1
                set__color( col(a+offset),0)
                print lines(a+offset);
            next
            locate 25,15
            set__color( 14,0)
            print "Arrow down and up to browse, esc to exit";
            key=keyin("12346789 ",1)
            if keyplus(key)  then offset=offset-22
            if keyminus(key)  then offset=offset+22
            if offset<0 then offset=0
            if offset>488 then offset=488
        loop until key=key__esc or key=" "
    else
        locate 10,10
        print "Couldnt open readme.txt"
    endif
    cls
    while inkey<>""
    wend
    screenshot(2)
    return 0
end function




'function display_planetmap(slot as short,osx as short,bg as byte) as short
'
'    dim x as short
'    dim y as short
'    dim b as short
'    dim x2 as short
'    dim debug as byte
'
'    for x=_mwx to 0 step-1
'        for y=0 to 20
'            x2=x+osx
'            if x2>60 then x2=x2-61
'            if x2<0 then x2=x2+61
'            if planetmap(x2,y,slot)>0 then
'                if tmap(x2,y).no=0 then tmap(x2,y)=tiles(planetmap(x2,y,slot))
'                dtile(x,y,tmap(x2,y),bg)
'#if __FB_DEBUG__
'                draw string(x,y),""&planetmap(x2,y,slot)
'#endif
'            endif
'            if itemindex.last(x2,y)>0 then
'                for b=1 to itemindex.last(x2,y)
'                    display_item(itemindex.index(x2,y,b),osx,slot)
'                next
'            endif
'        next
'    next
'
'    display_portals(slot,osx)
'
'#if __FB_DEBUG__
'    if lastapwp>0 then
'        for b=0 to lastapwp
'            if apwaypoints(b).x-osx>=0 and apwaypoints(b).x-osx<=_mwx then
'                set__color( 11,0)
'                draw string((apwaypoints(b).x-osx)*_tix,apwaypoints(b).y*_tiy),""& b,,Font1,custom,@_col
'            endif
'        next
'    endif
'#endif
'
'    return 0
'end function

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



'function getshipweapon() as short
'    dim as short a,b,c
'    dim p(7) as short
'    dim t as string
'    t="Chose weapon/"
'    for a=1 to 5
'        if player.weapons(a).dam>0 then
'            b=b+1
'            p(b)=a
'            t=t &player.weapons(a).desig & "/"
'        endif
'    next
'    b=b+1
'    p(b)=-1
'    t=t &"Cancel"
'    c=b-1
'    if b>1 then c=p(menu(t))
'    return c
'end function


