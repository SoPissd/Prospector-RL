'Declare Function Cursor(target As _cords,map As Short, osx As Short,osy As Short=0,radius As Short=0) As String

'function keyin(byref allowed as string="" , blocked as short=0)as string

function keyplus(key as string) as short
    dim r as short
    if key=key__up or key=key__lt or key=key_south or key="+" then r=-1
    return r
end function

function keyminus(key as string) as short
    dim r as short
    if key=key__dn or key=key__rt or key=key_north or key="-" then r=-1
    return r
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


function getnumber(a as integer,b as integer, e as integer) as integer
    dim key as string
    dim buffer as string
    dim as integer c,d,i
    dim p as _cords
    screenset 1,1
    rlprint ""
    if configflag(con_altnum)=0 then
        p=locEOL
        c=numfromstr((gettext(p.x,p.y,46,"")))
        if c>b then c=b
        if c<a then c=e
        return c
    else
        
        set__color( 11,1)
        for i=1 to 61
            draw string (i*_fw1,21*_fh1),chr(196),,font1,custom,@_col
        next
        set__color( 11,11)
        draw string (28*_fw1,21*_fh1),space(5),,font1,custom,@_col
        c=a
        if e>0 then c=e
        do 
            set__color( 11,1)
            
            draw string (27*_fw1,22*_fh1),chr(180),,font1,custom,@_col
            set__color( 5,11)
            
            draw string (29*_fw1,21*_fh1),"-",,font1,custom,@_col
            print "-"
    
            if c<10 then 
                set__color( 1,11)
                print "0" &c
                draw string (30*_fw1,21*_fh1),"0"&c,,font2,custom,@_col
            else
                set__color( 1,11)
                draw string (30*_fw1,21*_fh1),""&c,,font2,custom,@_col
            endif
            
            locate 22,32
            set__color( 5,11)        
            draw string (32*_fw1,21*_fh1),"+",,font1,custom,@_col
            
            set__color( 11,1)
            draw string (33*_fw1,21*_fh1),chr(195),,font1,custom,@_col
            key=keyin(key__up &key__dn &key__rt &key__lt &"1234567890+-"&key__esc &key__enter)
            if keyplus(key) then c=c+1
            if keyminus(key) then c=c-1
            if key=key__enter then d=1
            if key=key__esc then d=2
            buffer=buffer+key
            if len(buffer)>5 then buffer=""
            if val(buffer)<>0 or buffer="0" then c=val(buffer)
            
            if c>b then c=b
            if c<a then c=a
            
        loop until d=1 or d=2
        if d=2 then c=-1
        set__color( 11,0)
    endif
    return c
end function    


function gettext(x as short, y as short, ml as short, text as string,pixel as short=0) as string
    dim as short l,lasttimer
    dim key as string
    dim p as _cords
    l=len(text)
    if pixel=0 then
        x=x*_fw2
        y=y*_fh2
    endif
    if l>ml and text<>"" then
        text=left(text,ml-1)
        l=ml-1
    endif
    do 
            
        key=""
        set__color( 11,0)
        draw string (x,y), text &"_ ",,font2,custom,@_col
        do
            do
                sleep 1
                lasttimer+=1
                if lasttimer>100 then
                    draw string (x,y), text &"  ",,font2,custom,@_col
                else
                    draw string (x,y), text &"_ ",,font2,custom,@_col
                endif
                if lasttimer>200 then lasttimer=0
            loop until screenevent(@evkey)
            
            if evkey.type=FB.EVENT_KEY_press then
                if evkey.ascii=asc(key__esc) then key=key__esc
                if evkey.ascii=8 then key=chr(8)
                if evkey.ascii=32 then key=chr(32)
                if evkey.ascii=asc(key__enter) then key=key__enter
                if evkey.ascii>32 and evkey.ascii<123 then key=chr(evkey.ascii)
            endif
        loop until key<>""  
        
        if key=chr(8) and l>=1 then
           l=l-1
           text=left(text,len(text)-1)
           if text=chr(8) then text=""
        endif
        if l<ml and key<>key__enter and key<>chr(8) and key<>key__esc then
            text=text &key
            l=l+1
        endif
        if l>ml then 
            l=ml
            text=left(text,ml)
        endif
        
    loop until key=key__enter or key=key__esc
    if key=key__esc or l<1 then
    endif
    if len(text)=0 then text=""
    if text=key__enter or text=key__esc or text=chr(8) then text=""
    return text
end function


function askyn(q as string,col as short=11,sure as short=0) as short
    dim a as short
    dim key as string*1
    rlprint (q,col)
    do
        key=keyin
        displaytext(_lines-1)=displaytext(_lines-1)&key
        if key <>"" then 
            rlprint ""
            if configflag(con_anykeyno)=0 and key<>key_yes then key="N"
        endif
    loop until key="N" or key="n" or key=" " or key=key__esc or key=key__enter or key=key_yes  
    
    if key=key_yes or key=key__enter then a=-1
    if key<>key_yes and sure=1 then a=askyn("Are you sure? Let me ask that again:" & q)
    if key=key_yes then 
        rlprint "Yes.",15
    else
        rlprint "No.",15
    endif
    return a
end function

