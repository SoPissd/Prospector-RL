'tInput.
'
'defines:
'gettext=2, getnumber=1, askyn=212
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(types) or defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tInput -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tInput -=-=-=-=-=-=-=-

declare function gettext(x as short, y as short, ml as short, text as string,pixel as short=0) as string
declare function getnumber(a as integer,b as integer, e as integer) as integer
'declare function askyn(q as string,col as short=11,sure as short=0) as short


#endif'head

#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tInput -=-=-=-=-=-=-=-

namespace tInput
function init(iAction as integer) as integer
	return 0
end function
end namespace'tInput

Dim Shared evkey As FB.Event

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
        tScreen.draw2c(x,y, text &"_ ")
        do
            do
                sleep 1
                lasttimer+=1
                if lasttimer>100 then
                    tScreen.draw2c(x,y, text &"  ")
                else
                    tScreen.draw2c(x,y, text &"_ ")
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


function getnumber(a as integer,b as integer, e as integer) as integer
    dim key as string
    dim buffer as string
    dim as integer c,d,i
    dim p as _cords
    tScreen.set(1)
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
            tScreen.draw1c(i*_fw1,21*_fh1,chr(196))
        next
        set__color( 11,11)
        tScreen.draw1c(28*_fw1,21*_fh1,space(5))
        c=a
        if e>0 then c=e
        do 
            set__color( 11,1)
            
            tScreen.draw1c(27*_fw1,22*_fh1,chr(180))
            set__color( 5,11)
            
            tScreen.draw1c(29*_fw1,21*_fh1,"-")
            print "-"
    
            if c<10 then 
                set__color( 1,11)
                print LeadingZero(2,c)				'???
                tScreen.draw2c(30*_fw1,21*_fh1,LeadingZero(2,c))
            else
                set__color( 1,11)
                tScreen.draw2c(30*_fw1,21*_fh1,""&c) '???
            endif
            
            locate 22,32
            set__color( 5,11)        
            tScreen.draw1c(32*_fw1,21*_fh1,"+")
            
            set__color( 11,1)
            tScreen.draw1c(33*_fw1,21*_fh1,chr(195))
            
            key=uConsole.keyinput(key__up &key__dn &key__rt &key__lt &"1234567890+-"&key__esc &key__enter)
            
'            key=keyin(key__up &key__dn &key__rt &key__lt &"1234567890+-"&key__esc &key__enter)
            if uConsole.keyplus(key) then c=c+1
            if uConsole.keyminus(key) then c=c-1
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

#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tInput -=-=-=-=-=-=-=-
	tModule.register("tInput",@tInput.init()) ',@tInput.load(),@tInput.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tInput -=-=-=-=-=-=-=-
#endif'test
