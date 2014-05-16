'tKeys.
'
'defines:
'getdirection=23, save_keyset=0, load_key=1, load_keyset=1, keybindings=4
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
'     -=-=-=-=-=-=-=- TEST: tKeys -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tKeys -=-=-=-=-=-=-=-

'declare function getdirection(key as string) as short
declare function load_key(byval t2 as string,byref n as string="") as string
declare function load_keyset() as short
declare function keybindings(allowed as string="") as short

'private function save_keyset() as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tKeys -=-=-=-=-=-=-=-

namespace tKeys
function init(iAction as integer) as integer
	return 0
end function
end namespace'tKeys


function save_keyset() as short
    dim f as short
    f=freefile
    open "keybindings.txt" for output as #f
    print #f,"key_nw = "&key_nw
    print #f,"key_north = "&key_north
    print #f,"key_ne = "&key_ne
    print #f,"key_west = "&key_west
    print #f,"key_east = "&key_east
    print #f,"key_sw = " &key_sw
    print #f,"key_south = "&key_south
    print #f,"key_se = "&key_se
    print #f,"key_wait = "&key_wait
    print #f,"key_portal = "&key_portal
    print #f,"key_autoexplore = "&key_autoexplore
    print #f,"key_optequip = "&key_optequip
    print #f,"key_layfire = "&key_layfire
    print #f,"key_manual = "&key_manual
    print #f,"key_messages = "&key_messages
    print #f,"key_configuration = "&key_configuration
    print #f,"key_autoinspect = "&key_autoinspect
    print #f,"key_autopickup = "&key_autopickup
    print #f,"key_shipstatus ="&key_shipstatus
    print #f,"key_awayteam ="&key_awayteam
    print #f,"key_togglehpdisplay ="&key_togglehpdisplay
    print #f,"key_tactics ="&key_tactics
    print #f,"key_filter ="&key_filter
    print #f,"key_logbook ="&key_logbook
    print #f,"key_quest ="&key_quest
    'print #f,"key_weapons ="&key_weapons
    print #f,"key_equipment ="&key_equipment
    print #f,"key_yes ="&key_yes
    print #f,"key_landing ="&key_la
    print #f,"key_scanning ="&key_sc
    print #f,"key_standing ="&key_standing
    print #f,"key_targetlanding ="&key_tala
    print #f,"key_dock ="&key_dock
    print #f,"key_save ="&key_save
    print #f,"key_quit="&key_quit
    print #f,"key_rename ="&key_rename
    print #f,"key_comment ="&key_comment
    print #f,"key_tow ="&key_tow
    print #f,"key_pickup ="&key_pickup
    print #f,"key_dropitem ="&key_drop
    print #f,"key_inspect ="&key_inspect
    print #f,"key_examine ="&key_ex
    print #f,"key_radio ="&key_ra
    print #f,"key_teleport ="&key_te
    print #f,"key_jump ="&key_ju
    print #f,"key_communicate ="&key_co
    print #f,"key_offer ="&key_of
    print #f,"key_grenade ="&key_gr
    print #f,"key_fire ="&key_fi
    print #f,"key_autofire ="&key_autofire
    print #f,"key_heal ="&key_he
    print #f,"key_walk ="&key_walk
    print #f,"key_oxygen ="&key_oxy
    print #f,"key_close ="&key_close
    print #f,"key_dropshield ="&key_dropshield
    print #f,"key_activatesensors ="&key_ac
    print #f,"key_run ="&key_ru
    print #f,"key_togglemanjets ="&key_togglemanjets
    print #f,"key_autoexplore ="&key_autoexplore
    close f
    return 0
end function


function load_key(byval t2 as string,byref n as string="") as string
    dim as short l,i,record
    dim as string t,t3
    t=t2
    for i=1 to len(t)
        if record=1 then t3 &=mid(t,i,1)
        if record=0 then n &=mid(t,i,1)
        if mid(t,i,1)="=" then record=1
    next
    return trim(t3)
end function


function load_keyset() as short
    dim as short f,a,b,c,i,j,li
    dim as string text,lctext
    dim keys(256) as string
    dim texts(256) as string
    f=freefile
    if fileexists("keybindings.txt") then

        open "keybindings.txt" for input as #f
        print "loading keyset";
        do
            b+=1
            line input #f,texts(b)
            if (len(text)>0) and ((instr(text,"#")=0) or (instr(text,"#")>instr(text,"="))) then
                a+=1
                keys(a)=right(text,1)
            endif
        loop until eof(f)
        for i=1 to a
            for j=1 to a
                if i<>j then
                    if keys(i)=keys(j) then
                        for c=1 to b
                            if right(texts(c),1)=keys(j) then li=c
                        next
                        print "Two commands bound to "&keys(j) &"in line "&li &" ("&texts(li) &")"
                        print "using default keys"
                        sleep 250
                        close f
                        return 0
                    endif
                endif
            next
        next

        close f

        for i=1 to b
        	if (i and 3)=0 then print ".";
            text=texts(i)
            if left(text,1)<>"#" and len(text)>0 then
                lctext=lcase(text)
                if instr(lctext,"key_autoexplore")>0 then key_autoexplore=load_key(text)
                if instr(lctext,"key_nw")>0 then key_nw=load_key(text)
                if instr(lctext,"key_north")>0 then key_north=load_key(text)
                if instr(lctext,"key_ne")>0 then key_ne=load_key(text)
                if instr(lctext,"key_west")>0 then key_west=load_key(text)
                if instr(lctext,"key_east")>0 then key_east=load_key(text)
                if instr(lctext,"key_sw")>0 then key_sw=load_key(text)
                if instr(lctext,"key_south")>0 then key_south=load_key(text)
                if instr(lctext,"key_se")>0 then key_se=load_key(text)
                if instr(lctext,"key_wait")>0 then key_wait=load_key(text)
                if instr(lctext,"key_portal")>0 then key_portal=load_key(text)
                if instr(lctext,"key_accounting")>0 then key_accounting=load_key(text)
                if instr(lctext,"key_autoexplore")>0 then key_autoexplore=load_key(text)
                if instr(lctext,"key_optequip")>0 then key_optequip=load_key(text)

                if instr(lctext,"key_layfire")>0 then key_layfire=load_key(text)
                if instr(lctext,"key_manual")>0 then key_manual=load_key(text)
                if instr(lctext,"key_messages")>0 then key_messages=load_key(text)
                if instr(lctext,"key_configuration")>0 then key_configuration=load_key(text)
                if instr(lctext,"key_autopickup")>0 then key_autopickup=load_key(text)
                if instr(lctext,"key_autoinspect")>0 then key_autoinspect=load_key(text)
                if instr(lctext,"key_shipstatus")>0 then key_shipstatus=load_key(text)
                if instr(lctext,"key_save")>0 then key_save=load_key(text)
                if instr(lctext,"key_quit")>0 then key_quit=load_key(text)
                if instr(lctext,"key_tactics")>0 then key_tactics=load_key(text)
                if instr(lctext,"key_filter")>0 then key_filter=load_key(text)
                if instr(lctext,"key_comment")>0 then key_comment=load_key(text)
                if instr(lctext,"key_awayteam")>0 then key_awayteam=load_key(text)
                if instr(lctext,"key_logbook")>0 then key_logbook=load_key(text)
                if instr(lctext,"key_equipment")>0 then key_equipment=load_key(text)
                if instr(lctext,"key_quest")>0 then key_quest=load_key(text)
                if instr(lctext,"key_tow")>0 then key_tow=load_key(text)
                if instr(lctext,"key_standing")>0 then key_standing=load_key(text)

                if instr(lctext,"key_landing")>0 then key_la=load_key(text)
                if instr(lctext,"key_scanning")>0 then key_sc=load_key(text)
                if instr(lctext,"key_comment")>0 then key_comment=load_key(text)
                if instr(lctext,"key_rename")>0 then key_rename=load_key(text)
                if instr(lctext,"key_targetlanding")>0 then key_tala=load_key(text)
                if instr(lctext,"key_togglehpdisplay")>0 then key_togglehpdisplay=load_key(text)

                if instr(lctext,"key_pickup")>0 then key_pickup=load_key(text)
                if instr(lctext,"key_dropitem")>0 then key_drop=load_key(text)
                if instr(lctext,"key_inspect")>0 then key_inspect=load_key(text)
                if instr(lctext,"key_examine")>0 then key_ex=load_key(text)
                if instr(lctext,"key_radio")>0 then key_ra=load_key(text)
                if instr(lctext,"key_teleport")>0 then key_te=load_key(text)
                if instr(lctext,"key_jump")>0 then key_ju=load_key(text)
                if instr(lctext,"key_communicate")>0 then key_co=load_key(text)
                if instr(lctext,"key_offer")>0 then key_of=load_key(text)
                if instr(lctext,"key_grenade")>0 then key_gr=load_key(text)
                if instr(lctext,"key_fire")>0 then key_fi=load_key(text)
                if instr(lctext,"key_autofire")>0 then key_autofire=load_key(text)
                if instr(lctext,"key_walk")>0 then key_walk=load_key(text)
                if instr(lctext,"key_heal")>0 then key_he=load_key(text)
                if instr(lctext,"key_oxygen")>0 then key_oxy=load_key(text)
                if instr(lctext,"key_close")>0 then key_close=load_key(text)

                if instr(lctext,"key_shield")>0 then key_dropshield=load_key(text)
                if instr(lctext,"key_activatesensors")>0 then key_ac=load_key(text)
                if instr(lctext,"key_run")>0 then key_ru=load_key(text)
                if instr(lctext,"key_togglemanjets")>0 then key_togglemanjets=load_key(text)
                if instr(lctext,"key_yes")>0 then key_yes=load_key(text)
                if instr(lctext,"key_extendedkey")>0 then key_extended=load_key(text)

            endif
        next
		Print
    else
        set__color( 14,0)
        print "File keybindings.txt not found. Using default keys"
        save_keyset
        set__color( 15,0)
        Sleep 1500
        return 1
    endif

    return 0
end function

function keybindings(allowed as string="") as short
    dim as short f,a,b,d,x,y,c,ls,lk,cl(99),colflag(99),lastcom,changed,fg,bg,o
    dim as _cords cc,ncc
    dim as short di
    dim as string keys(99),nkeys(99),varn(99),exl(99),coml(99),comn(99),comdes(99),text,newkey,text2
    if not fileexists("keybindings.txt") then
        save_keyset
    endif
    f=freefile
    open "keybindings.txt" for input as #f
    while not eof(f)
        ls+=1
        line input #f,text2
        if left(text2,1)<>"#" and len(text2)>0 then
            if allowed="" or instr(allowed,load_key(text2))>0 or val(text2)>0 then
                a+=1
                lk+=1
                text=text2
                keys(a)=load_key(text2,varn(a))
                nkeys(a)=keys(a)
                exl(a)=right(varn(a),len(varn(a))-4)
                exl(a)=Ucase(left(exl(a),1))&right(exl(a),len(exl(a))-1)
            endif
        else
            lastcom+=1
            coml(lastcom)=text2
            cl(lastcom)=ls
        endif
    wend
    close #f
    f=freefile
    open "data/commands.csv" for input as #f
    a=0
    cls
    while not eof(f)
       line input #f,text2

       a+=1
       coml(a)=left(text2,instr(text2,";")-1) &" = "
       comdes(a)=right(text2,len(text2)-instr(text2,";"))
    wend
    close #f
    do
        for a=1 to lk
            colflag(a)=0
        next
        for a=1 to lk
            for b=1 to lk
                if a<>b and nkeys(a)=nkeys(b) then
                    colflag(a)=1
                    colflag(b)=1
                endif
            next
        next
        b=0
        set__color( 11,0)
        cls
        if cc.x<1 then cc.x=1
        if cc.y<1 then cc.y=1
        if cc.x>4 then cc.x=4
        if cc.y>20 then cc.y=20
        'c=(cc.x-1)*20+cc.y
        if c<1 then c=lk
        if c>lk then c=1

        if varn(c)="" then cc=ncc
        tScreen.set(0)
        set__color( 15,0)
        draw string ((tScreen.x-12*_fw2)/2,1*_fh2),"Keybindings:",,FONT2,custom,@_col
        for x=1 to 4
            for y=1 to 20
                if x>1 or y>6 then
                b+=1
                if c=b then
                    fg=15
                    bg=5
                    cc.x=x
                    cc.y=y
                    for d=1 to 99
                        set__color( 15,0)
                        if ucase(trim(varn(b)))=ucase(trim(coml(d))) then draw string (5*_fw2,26*_fh2), comdes(d),,FONT2,custom,@_col
                    next
                else
                    fg=11
                    bg=0
                endif
                if colflag(b)=1 then fg=14
                set__color( fg,bg)

                draw string ((2*_fw2)+(x-1)*25*_fw2,(y+2)*_fh2),space(25),,FONT2,custom,@_col
                draw string ((2*_fw2)+(x-1)*25*_fw2,(y+2)*_fh2),exl(b)& nkeys(b),,FONT2,custom,@_col
                endif
            next
        next
        set__color( 11,0)
        draw string (5*_fw2,25*_fh2),"\C=Control Yellow: 2 commands bound to same key.",,FONT2,custom,@_col
        for b=1 to 8
            set__color( 11,0)
            if b=1 then
                draw string (2*_fw2,(3)*_fh2),nkeys(b),,FONT2,custom,@_col
            endif
            if b=2 then
                draw string (4*_fw2,(3)*_fh2),nkeys(b),,FONT2,custom,@_col
            endif
            if b=3 then
                draw string (6*_fw2,(3)*_fh2),nkeys(b),,FONT2,custom,@_col
            endif
            if b=4 then
                draw string (2*_fw2,(5)*_fh2),nkeys(b),,FONT2,custom,@_col
            endif
            if b=5 then
                draw string (6*_fw2,(5)*_fh2),nkeys(b),,FONT2,custom,@_col
            endif
            if b=6 then
                draw string (2*_fw2,(7)*_fh2),nkeys(b),,FONT2,custom,@_col
            endif
            if b=7 then
                draw string (4*_fw2,(7)*_fh2),nkeys(b),,FONT2,custom,@_col
            endif
            if b=8 then
                draw string (6*_fw2,(7)*_fh2),nkeys(b),,FONT2,custom,@_col
            endif
        next
        set__color( 15,0)
        draw string (3*_fw2,4*_fh2),"\|/",,FONT2,custom,@_col
        draw string (3*_fw2,5*_fh2),"- -",,FONT2,custom,@_col
        draw string (3*_fw2,6*_fh2),"/|\",,FONT2,custom,@_col
        set__color( 11,0)
        draw string (4*_fw2,5*_fh2),"@",,FONT2,custom,@_col

        no_key=uConsole.keyinput()
'        no_key=keyin
		di=uConsole.getdirection()'(no_key)
        o=c
        if di=8 then c-=1
        if di=2 then c+=1
        if di=4 then c-=20
        if di=6 then c+=20
        if c<1 then c=lk
        if c>lk then c=1
        'c=(cc.x-1)*20+cc.y
        if varn(c)="" then o=c

        if no_key=key__enter and keys(c)<>"" then
            tScreen.set(1)
            draw string ((2*_fw2)+(cc.x-1)*25*_fw2,(cc.y+2)*_fh2),space(25),,FONT2,custom,@_col
            draw string ((2*_fw2)+(cc.x-1)*25*_fw2,(cc.y+2)*_fh2),exl(c),,FONT2,custom,@_col
            newkey=gettext(2+(cc.x-1)*25+len(exl(c)),cc.y+2,3,"")
            newkey=trim(newkey)
            if newkey<>"" and newkey<>nkeys(c) then
                nkeys(c)=newkey
            endif
        endif
    loop until no_key=key__esc

    for a=1 to lk
        if keys(a)<>nkeys(a) then
            changed=1
        endif
    next

    if changed=1 then
        if askyn("Do you want to save changes(y/n)?") then
            f=freefile
            open "keybindings.txt" for output as #f
            lastcom=1
            b=1
            for a=1 to lk
                print #f,varn(a)&" "&nkeys(a)
            next
            close #f
            load_keyset
        endif
    endif
    return 0
end function

'#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tKeys -=-=-=-=-=-=-=-
	tModule.register("tKeys",@tKeys.init()) ',@tKeys.load(),@tKeys.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tKeys -=-=-=-=-=-=-=-
#endif'test
