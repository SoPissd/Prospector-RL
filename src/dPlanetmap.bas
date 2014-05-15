'tPlanetmap.
'
'defines:
'rnd_point=3, vege_per=1, display_item=3, cursor=4, display_planetmap=17,
', fixstarmap=2, planet_cursor=0, get_nonspecialplanet=0,
', get_planet_cords=0, changetile=13, load_map=4, isbuilding=0,
', get_colony_building=0, remove_building=1, closest_building=0,
', makeplatform=5, makecomplex=22, makecomplex2=0, makefinalmap=3,
', makeplanetmap=12, make_eventplanet=1
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
'     -=-=-=-=-=-=-=- TEST: tPlanetmap -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tPlanetmap -=-=-=-=-=-=-=-

Dim Shared planetmap(60,20,max_maps) As Short

declare function cursor(target as _cords,map as short,osx as short,osy as short=0,radius as short=0) as string

declare function rnd_point(m as short=-1,w as short=-1,t as short=-1,vege as short=-1)as _cords
declare function vege_per(slot as short) as single
declare function display_item(i as integer,osx as short,slot as short) as short
declare function display_planetmap(slot as short,osx as short,bg as byte) as short
declare function fixstarmap() as short
declare function changetile(x as short,y as short,m as short,t as short) as short
declare function load_map(m as short,slot as short)as short
declare function remove_building(map as short) as short
declare function makeplatform(slot as short,platforms as short,rooms as short, translate as short, adddoors as short=0) as short
declare function makecomplex(byref enter as _cords, down as short,blocked as byte=0) as short
declare function makefinalmap(m as short) as short
declare function makeplanetmap(a as short,orbit as short,spect as short) as short
declare function make_eventplanet(slot as short) as short
declare function get_nonspecialplanet(disc as short=0) as short

'private function planet_cursor(p as _cords,mapslot as short,byref osx as short,shteam as byte) as string
'private function get_planet_cords(byref p as _cords,mapslot as short,shteam as byte=0) as string
'private function isbuilding(x as short,y as short,map as short) as short 
'private function get_colony_building(map as short) as _cords
'private function closest_building(p as _cords,map as short) as _Cords
'private function makecomplex2(slot as short,gc1 as _cords, gc2 as _cords, roundedcorners1 as short,roundedcorners2 as short,nocol1 as short,nocol2 as short,doorchance as short,loopchance as short,loopdoor as short,adddoor as short,addloop as short,nosmallrooms as short,culdesacruns as short, t as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tPlanetmap -=-=-=-=-=-=-=-

namespace tPlanetmap
function init() as Integer
	return 0
end function
end namespace'tPlanetmap


function rnd_point(m as short=-1,w as short=-1,t as short=-1,vege as short=-1)as _cords
    dim p(1281) as _cords
    dim as short last,x,y,a
    
    if m>0 and w>=0 then
        for x=0 to 60
            for y=0 to 20
                if tiles(abs(planetmap(x,y,m))).walktru=w then
                    p(a).x=x
                    p(a).y=y
                    a=a+1
                endif
            next
        next
        if a>0 then return p(rnd_range(0,a-1))
    endif
    if m>0 and t>0 and w=-1 then
        DbgPrint("Looking for tile "&t)
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,m))=t then
                    a+=1
                    p(a).x=x
                    p(a).y=y
                endif
            next
        next
        if a=0 then 
			DbgPrint("No tiles found")
        EndIf
        if a>0 then 
            a=rnd_range(1,a)
            DbgPrint("Point returned was "&p(a).x &":"&p(a).y)
            return p(a)
        else
            p(0).x=-1
            p(0).y=-1
            return p(0) 
        endif
    endif
    
    if m>0 and vege=1 then 'Return a point with vege>0
        a=0
        for x=0 to 60
            for y=0 to 20
                if tmap(x,y).vege>0 then
                    a+=1
                    p(a).x=x
                    p(a).y=y
                endif
            next
        next
        if a>0 then
            return p(rnd_range(1,a))
        else
            p(0).x=-1
            p(0).y=-1
            return p(0)
        endif
    endif
            
                    
    
    p(0).x=rnd_range(0,60)
    p(0).y=rnd_range(0,20)
    return p(0)
end function


function vege_per(slot as short) as single
    dim as short x,y,vege,total
    for x=0 to 60
        for y=0 to 20
            if planetmap(x,y,slot)>0 then
                total+=1
                if tiles(planetmap(x,y,slot)).vege>0 then vege+=1
            endif
        next
    next
    if total=0 then return 0
    return vege/total
end function


function display_item(i as integer,osx as short,slot as short) as short
    dim as _cords p
    dim as short x2,bg,fg,alp
    If item(i).w.s=0 And item(i).w.p=0 Then
        p.x=item(i).w.x
        p.y=item(i).w.y
        If awayteam.c.x=p.x And awayteam.c.y=p.y And comstr.comitem=0 Then
            comstr.t=comstr.t &key_pickup &" Pick up;"
            comstr.comitem=1
        EndIf
            
        If  item(i).discovered=1 or (tiles(Abs(planetmap(p.x,p.y,slot))).hides=0 and vismask(item(i).w.x,item(i).w.y)>0) Then
            If item(i).discovered=0 And walking<11 Then walking=0
            item(i).discovered=1
            If tiles(Abs(planetmap(item(i).w.x,item(i).w.y,slot))).walktru>0 And item(i).bgcol=0 Then
                bg=tiles(Abs(planetmap(item(i).w.x,item(i).w.y,slot))).col
            Else
                If item(i).bgcol>=0 Then bg=item(i).bgcol
            EndIf
            If item(i).col>0 Then
                fg=item(i).col
            Else
                fg=rnd_range(Abs(item(i).col),Abs(item(i).bgcol))
            EndIf
            set__color( fg,bg)
            If configflag(con_tiles)=0 Then
                p.x=item(i).w.x
                p.y=item(i).w.y
                If vismask(p.x,p.y)=0 Then
                    alp=197
                Else
                    alp=255
                EndIf
                x2=item(i).w.x-osx
                If x2<0 Then x2+=61
                If x2>60 Then x2-=61
                Put (x2*_tix,item(i).w.y*_tiy),gtiles(gt_no(item(i).ti_no)),alpha,alp
#if __FB_DEBUG__
                Draw String(x*_tix,item(i).w.y*_tiy),cords(item(i).vt) &":"&item(i).w.m,,font1,custom,@_tcol'REMOVE
#endif
            Else
                If configflag(con_transitem)=1 Then
                    Draw String(p.x*_fw1,P.y*_fh1), item(i).ICON,,font1,custom,@_col
                Else
                    If item(i).bgcol<=0 Then
                        set__color( 241,0)
                        Draw String(p.x*_fw1-1,P.y*_fh1), item(i).ICON,,font1,custom,@_tcol
                        Draw String(p.x*_fw1+1,P.y*_fh1), item(i).ICON,,font1,custom,@_tcol
                        Draw String(p.x*_fw1,P.y*_fh1+1), item(i).ICON,,font1,custom,@_tcol
                        Draw String(p.x*_fw1,P.y*_fh1-1), item(i).ICON,,font1,custom,@_tcol
                        set__color( fg,bg)
                        Draw String(p.x*_fw1,P.y*_fh1), item(i).ICON,,font1,custom,@_tcol
                    Else
                        Draw String(p.x*_fw1,P.y*_fh1), item(i).ICON,,font1,custom,@_col
                    EndIf
                EndIf
            EndIf
        EndIf
    endif
    return 0
end function


function cursor(target as _cords,map as short,osx as short,osy as short=0,radius as short=0) as string
    dim key as string
    dim as _cords p2
    dim as short border,eo
    if configflag(con_tiles)=1 then
        set__color( 11,11)
        draw string (target.x*_fw1,target.y*_fh1)," ",,font1,custom,@_col
    else
        'if map>0 then
            put ((target.x-osx)*_tix,(target.y-osy)*_tiy),gtiles(85),trans
        'else
        '    put ((target.x+osx)*_tix,(target.y+osy)*_tiy),gtiles(85),trans
        'endif
    endif
    key=keyin
    if map>0 then
        border=0
        if planets(map).depth=0 then
            eo=4
        else
            eo=0
        endif
    endif
    if map<=0 then border=1
    'rlprint ""&planetmap(target.x,target.y,map)
    if map>0 then
        if planetmap(target.x,target.y,map)<0 then
            if configflag(con_tiles)=0 then
                put ((target.x-osx)*_tix,(target.y-osy)*_tiy),gtiles(0),trans
            else
                set__color( 0,0)
                draw string (target.x*_fw1,target.y*_fh1)," ",,font1,custom,@_col
            endif
        else
            if target.x>=0 and target.y>=0 and target.x<=60 and target.y<=20 then dtile(target.x-osx,target.y,tiles(planetmap(target.x,target.y,map)),1)
        endif
    else
        if configflag(con_tiles)=0 then
            put ((target.x-osx)*_tix,(target.y-osy)*_tiy),gtiles(0),trans
        else
            set__color( 0,0)
            draw string (target.x*_fw1,target.y*_fh1)," ",,font1,custom,@_col
        endif
    endif
    set__color( 11,0)
    p2=target
    target=movepoint(target,getdirection(key),eo,border)
    if radius>0 and distance(target,awayteam.c)>radius then target=p2
    return key
end function


function display_planetmap(slot as short,osx as short,bg as byte) as short

    dim x as short
    dim y as short
    dim b as short
    dim x2 as short
    dim debug as byte

    for x=_mwx to 0 step-1
        for y=0 to 20
            x2=x+osx
            if x2>60 then x2=x2-61
            if x2<0 then x2=x2+61
            if planetmap(x2,y,slot)>0 then
                if tmap(x2,y).no=0 then tmap(x2,y)=tiles(planetmap(x2,y,slot))
                dtile(x,y,tmap(x2,y),bg)
#if __FB_DEBUG__
                draw string(x,y),""&planetmap(x2,y,slot)
#endif
            endif
            if itemindex.last(x2,y)>0 then
                for b=1 to itemindex.last(x2,y)
                    display_item(itemindex.index(x2,y,b),osx,slot)
                next
            endif
        next
    next

    display_portals(slot,osx)

#if __FB_DEBUG__
    if lastapwp>0 then
        for b=0 to lastapwp
            if apwaypoints(b).x-osx>=0 and apwaypoints(b).x-osx<=_mwx then
                set__color( 11,0)
                draw string((apwaypoints(b).x-osx)*_tix,apwaypoints(b).y*_tiy),""& b,,Font1,custom,@_col
            endif
        next
    endif
#endif

    return 0
end function


function fixstarmap() as short
    dim p(2048) as short
    dim sp(lastspecial) as short
    dim as string l
    dim as short a,b,c,fixed,fsp,pis,newfix,cc,spfix,f
        
    do
        cc+=1
        newfix=0
        
        for a=0 to laststar
            for b=1 to 9
                if map(a).planets(b)>0 then
                    p(map(a).planets(b))=0
                endif
            next
        next
        
        for a=0 to laststar
            pis=0
            for b=1 to 9
                if map(a).planets(b)>0 then
                    pis+=1
                    p(map(a).planets(b))+=1
                    if p(map(a).planets(b))>1  then
                        newfix+=1
                        lastplanet=lastplanet+1
                        fixed=fixed+1
                        map(a).planets(b)=lastplanet
                        p(lastplanet)+=1
                    endif
                    for c=0 to lastspecial
                        if specialplanet(c)=map(a).planets(b) and specialplanet(c)>0 then sp(c)=sp(c)+1
                    next
                endif
            next
            if map(a).spec=8 and pis=0 then 
                fixed+=1
                newfix+=1
                lastplanet+=1
                p(lastplanet)+=1
                map(a).planets(1)=lastplanet
            endif
        next
    loop until newfix=0
    for c=0 to lastspecial
        if sp(c)=0 then 
            fsp=fsp+1
        endif
    next
    for c=0 to lastspecial
        if specialplanet(c)>0 and specialplanet(c)<max_maps then
            if planetmap(0,0,specialplanet(c))<>0 then spfix+=1
            planetmap(0,0,specialplanet(c))=0
        endif
    next
    for a=0 to laststar
        map(a).ti_no=map(a).spec+68
        if map(a).spec=8 then map(a).ti_no=rnd_range(33,38)
        if map(a).spec=10 then map(a).ti_no=89
    next
    return 0
end function


function planet_cursor(p as _cords,mapslot as short,byref osx as short,shteam as byte) as string
    dim key as string
    tScreen.set(0)
    cls
    osx=calcosx(p.x,planets(mapslot).depth)
    display_planetmap(mapslot,osx,4)
    if shteam=0 then
        draw_border(0)
    else
        display_awayteam(,osx)
    endif
    if planetmap(p.x,p.y,mapslot)>0 then
        rlprint cords(p)&": "&tiles(planetmap(p.x,p.y,mapslot)).desc
    else
        rlprint cords(p)&": "&"Unknown"
    endif
    tScreen.update()
    return key
end function


function get_nonspecialplanet(disc as short=0) as short
    dim pot(1024) as short
    dim as short a,b,last
    for a=0 to laststar
        if map(a).discovered=0 or disc=0 then
            for b=1 to 9
                if map(a).planets(b)>0 and is_special(map(a).planets(b))=0 then
                    if planetmap(0,0,map(a).planets(b))=0 then
                        last+=1
                        pot(last)=map(a).planets(b)
                    endif
                endif
            next
        endif
    next
    if last>0 then
        return pot(rnd_range(1,last))
    else 
        return 0
    end if
end function


function get_planet_cords(byref p as _cords,mapslot as short,shteam as byte=0) as string
    dim osx as short
    dim as string key
    display_planetmap(mapslot,osx,1)
    display_ship
    do
        key=planet_cursor(p,mapslot,osx,shteam)
        key=cursor(p,mapslot,osx)
    loop until key=key__esc or key=key__enter

    return key
end function


function changetile(x as short,y as short,m as short,t as short) as short
    if planetmap(x,y,m)<0 then
        planetmap(x,y,m)=abs(t)*-1
    else
        planetmap(x,y,m)=abs(t)
    endif
    return 0
end function



function load_map(m as short,slot as short)as short
    dim as short f,b,x,y
    f=freefile
    open "data/deckplans.dat" for binary as #f
    for b=1 to m
        for x=0 to 60
            for y=0 to 20
                get #f,,planetmap(x,y,slot)
                planetmap(x,y,slot)=-planetmap(x,y,slot)
            next
        next
    next
    close #f
    return 0
end function



function isbuilding(x as short,y as short,map as short) as short 
    if abs(planetmap(x,y,map))=16 then return -1
    if abs(planetmap(x,y,map))=68 then return -1
    if abs(planetmap(x,y,map))=69 then return -1
    if abs(planetmap(x,y,map))=70 then return -1
    if abs(planetmap(x,y,map))=71 then return -1
    if abs(planetmap(x,y,map))=72 then return -1
    if abs(planetmap(x,y,map))=74 then return -1
    if abs(planetmap(x,y,map))=98 then return -1
    if abs(planetmap(x,y,map))=237 then return -1
    if abs(planetmap(x,y,map))=238 then return -1
    if abs(planetmap(x,y,map))=261 then return -1
    if abs(planetmap(x,y,map))=262 then return -1
    if abs(planetmap(x,y,map))=266 then return -1
    if abs(planetmap(x,y,map))=268 then return -1
    if abs(planetmap(x,y,map))=294 then return -1
    if abs(planetmap(x,y,map))=299 then return -1
    if abs(planetmap(x,y,map))=300 then return -1
    if abs(planetmap(x,y,map))=301 then return -1
    if abs(planetmap(x,y,map))=302 then return -1
    return 0
end function



function get_colony_building(map as short) as _cords
    dim p(255) as _cords
    dim as short x,y,x1,y1,i
    dim cand(60,20) as short
    p(255).x=-1
    p(255).y=-1
    for x=0 to 60
        for y=0 to 20
            if isbuilding(x,y,map)=-1 then
                for x1=x-2 to x+2
                    for y1=y-2 to y+2
                        if x1>=0 and x1<=60 and y1>=0 and y1<=20 then
                            if x1=x-2 or x1=x+2 or y1=y-2 or y1=y+2 then
                                cand(x1,y1)=1
                            else
                                cand(x1,y1)=0
                            endif
                        endif
                    next
                next
            endif
        next
    next
    for x=0 to 60
        for y=0 to 20
            if cand(x,y)=1 and tiles(abs(planetmap(x,y,map))).walktru=0 and i<255 then 
                i+=1
                p(i).x=x
                p(i).y=y
            endif
        next
    next
    if i=0 then        
        for x=0 to 60
            for y=0 to 20
                if cand(x,y)=1 then 
                    i+=1
                    p(i).x=x
                    p(i).y=y
                endif
            next
        next
    endif
    
    if i=0 then return p(255)
    
    return p(rnd_range(1,i))
end function

function remove_building(map as short) as short
    dim as _cords p(255),c
    dim as short i,j
    for x=0 to 60
        for y=0 to 20
            if isbuilding(x,y,map)=-1 then 
                if abs(planetmap(x,y,map))>=299 then
                    p(255).x=x
                    p(255).y=y
                else
                    i+=1
                    p(i).x=x
                    p(i).y=y
                endif
            endif
        next
    next
    if i>0 then 
        j=rnd_range(1,i)
     else
         j=255
         planets(map).colflag(0)=-1
     endif
     planetmap(p(j).x,p(j).y,map)=76
     return 0
 end function
 

function closest_building(p as _cords,map as short) as _Cords
    dim as short x,y,i,j
    dim as single d
    dim as _cords points(1281),result
    for x=0 to 60
        for y=0 to 20
            if isbuilding(x,y,map)=-1 then
                i+=1
                points(i).x=x
                points(i).y=y
            endif
        next
    next
    d=9999
    for j=1 to i
        if distance(p,points(j))<d and (points(j).x<>p.x or points(j).y<>p.y) then
            d=distance(p,points(j))
            result=points(j)
        endif
    next
    return result
end function


function makeplatform(slot as short,platforms as short,rooms as short, translate as short, adddoors as short=0) as short
    
    dim map(60,20) as short
    dim as short x,y,a,w,h,c,d,b,n,flag,door,c0
    dim as _cords p(platforms)
    dim sides(4) as byte
    for x=0 to 60
        for y=0 to 20
            'map(x,y)=99
        next
    next
    
    
    n=rnd_range(5,12)
    
    
    for a=1 to platforms
        d=0
        do
            p(a).x=rnd_range(1,50)
            p(a).y=rnd_range(1,14)
            w=rnd_range(5,9)
            h=rnd_range(3,5)
            c=0
            for x=p(a).x-1 to p(a).x+w+1
                for y=p(a).y-1 to p(a).y+h+1
                    if map(x,y)>0 then c=1
                next
            next
            d+=1
        loop until c=0 or d>=100
        if c=0 then
            for x=p(a).x to p(a).x+w
                for y=p(a).y to p(a).y+h
                    map(x,y)=1
                next
            next
            map(p(a).x,p(a).y)=0
            map(p(a).x,p(a).y+h)=0
            map(p(a).x+w,p(a).y)=0
            map(p(a).x+w,p(a).y+h)=0
            p(a).x=p(a).x+w/2
            p(a).y=p(a).y+h/2
        endif
    next
    
    for a=1 to platforms-1       
        do
            while p(a).x<>p(a+1).x 
                if p(a).x>p(a+1).x then p(a).x-=1
                if p(a).x<p(a+1).x then p(a).x+=1
                if (map(p(a).x,p(a).y-1)<>2 and map(p(a).x,p(a).y+1)<>2) and p(a).x<>p(a+1).x and map(p(a).x,p(a).y)=0 then map(p(a).x,p(a).y)=2
            wend
            if map(p(a).x,p(a).y)=0 then map(p(a).x,p(a).y)=2
            while p(a).y<>p(a+1).y 
                if p(a).y>p(a+1).y then p(a).y-=1
                if p(a).y<p(a+1).y then p(a).y+=1
                if (map(p(a).x-1,p(a).y)<>2 and map(p(a).x+1,p(a).y)<>2) and p(a).y<>p(a+1).y and map(p(a).x,p(a).y)=0 then map(p(a).x,p(a).y)=2
            wend
        loop until (p(a).x=p(a+1).x and p(a).y=p(a+1).y) 'or map(p(0).x,p(0).y)=1
        c=0
    next
    
    for a=0 to rooms
        flag=0
        c0=0
        
        do
            p(0).x=rnd_range(1,49)
            p(0).y=rnd_range(1,14)
            p(1).x=p(0).x+rnd_range(3,10)
            p(1).y=p(0).y+rnd_range(3,5)
            flag=0
            c0=0
            for x=p(0).x-1 to p(1).x+1
                for y=p(0).y-1 to p(1).y+1
                    if map(x,y)=0 then c0+=1
                    if map(x,y)=3 then flag=1
                    if (x=p(0).x-1 or x=p(0).x+1 or y=p(0).y-1 or y=p(0).y+1) and map(x,y)=4 then flag=1 
                next
            next
        loop until flag=0 and c0>0 and c0<(2+p(1).x-p(0).x)*(2+p(1).y-p(0).y)
        
        
        for x=p(0).x to p(1).x
            for y=p(0).y to p(1).y
                if x=p(0).x or x=p(1).x or y=p(0).y or y=p(1).y then
                    map(x,y)=4
                else
                    map(x,y)=3
                endif
            next
        next
        sides(1)=0
        sides(2)=0
        sides(3)=0
        sides(4)=0
        for x=p(0).x to p(1).x
            for y=p(0).y to p(1).y
                if x=p(0).x or x=p(1).x or y=p(0).y or y=p(1).y then
                    if (map(x-1,y)<4 and map(x+1,y)<4 and map(x-1,y)>0 and map(x+1,y)>0 and (map(x,y-1)=4 or map(x,y+1)=4)) then
                        door=5
                        if x=p(0).x and sides(1)=1 then door=4
                        if x=p(1).x and sides(2)=1 then door=4
                        if y=p(0).y and sides(3)=1 then door=4
                        if y=p(1).y and sides(4)=1 then door=4
                        map(x,y)=door
                        if x=p(0).x then sides(1)=1
                        if x=p(1).x then sides(2)=1
                        if y=p(0).y then sides(3)=1
                        if y=p(1).y then sides(4)=1
                    endif
                    if (map(x,y-1)<4 and map(x,y+1)<4 and map(x,y-1)>0 and map(x,y+1)>0 and (map(x-1,y)=4 or map(x+1,y)=4)) then
                        door=5
                        if x=p(0).x and sides(1)=1 then door=4
                        if x=p(1).x and sides(2)=1 then door=4
                        if y=p(0).y and sides(3)=1 then door=4
                        if y=p(1).y and sides(4)=1 then door=4
                        map(x,y)=door
                        if x=p(0).x then sides(1)=1
                        if x=p(1).x then sides(2)=1
                        if y=p(0).y then sides(3)=1
                        if y=p(1).y then sides(4)=1
                    endif
                endif
            next
        next
        for x=p(0).x to p(1).x
            for y=p(0).y to p(1).y
                if (x=p(0).x and y=p(0).y) or (x=p(0).x and y=p(1).y) or (x=p(1).x and y=p(0).y) or (x=p(1).x and y=p(1).y) then
                    if map(x+1,y)=2 or map(x-1,y)=2 or map(x,y+1)=2 or map(x,y-1)=2 then
                        if map(x+1,y)<>5 and map(x-1,y)<>5 and map(x,y+1)<>5 and map(x,y-1)<>5 then map(x,y)=5
                    endif
                endif
            next
        next
    next
    
    for x=0 to 60
        for y=0 to 20
            if translate=1 then
                if map(x,y)=0 then planetmap(x,y,slot)=-rnd_range(175,177) 'gasclouds
                if map(x,y)=1 then planetmap(x,y,slot)=-68 'platform
                if map(x,y)=2 then 'corridor
                    planetmap(x,y,slot)=-80
                    if rnd_range(1,100)<10 then planetmap(x,y,slot)=-81
                endif
                if map(x,y)=3 then planetmap(x,y,slot)=-80 'internal of room
                if map(x,y)=4 then planetmap(x,y,slot)=-52 'wall
                if map(x,y)=5 then planetmap(x,y,slot)=-54 'door
            endif
        
            if translate=2 then
                if map(x,y)=0 then 
                    planetmap(x,y,slot)=-rnd_range(49,51) 'stone walls
                    p(0).x=x
                    p(0).y=y
                    c=0
                    for b=1 to 9
                        p(2)=movepoint(p(0),b)
                        if planetmap(p(2).x,p(2).y,slot)=-158 then c=c+5
                    next
                    if rnd_range(1,100)<30+c-adddoors*3 then planetmap(p(0).x,p(0).y,slot)=-158
                endif
                if map(x,y)=1 then planetmap(x,y,slot)=-80 'platform
                if map(x,y)=2 then 'corridor
                    planetmap(x,y,slot)=-80
                    if rnd_range(1,100)<10 then planetmap(x,y,slot)=-81
                endif
                if map(x,y)=3 then planetmap(x,y,slot)=-80 'internal of room
                if map(x,y)=4 then planetmap(x,y,slot)=-52 'wall
                if map(x,y)=5 then 
                    if rnd_range(1,100)>66 then 'door
                        planetmap(x,y,slot)=-54
                    else 
                        planetmap(x,y,slot)=-55
                    endif
                endif
                if rnd_range(1,100)<adddoors and x>0 and x<60 and y>0 and y<20 then
                    if map(x+1,y)>0 and map(x+1,y)<4 and map(x-1,y)>0 and map(x-1,y)<4 and map(x,y+1)=4 and map(x,y-1)=4 then planetmap(x,y,slot)=-54
                    if map(x,y+1)>0 and map(x,y+1)<4 and map(x,y-1)>0 and map(x,y-1)<4 and map(x+1,y)=4 and map(x-1,y)=4 then planetmap(x,y,slot)=-54
                endif            
            endif
            
            
            if translate=3 then
                if map(x,y)=0 then 
                    planetmap(x,y,slot)=-rnd_range(49,51) 'stone walls
                    p(0).x=x
                    p(0).y=y
                    c=0
                    for b=1 to 9
                        p(2)=movepoint(p(0),b)
                        if planetmap(p(2).x,p(2).y,slot)=-158 then c=c+(10-adddoors)
                    next
                    if rnd_range(1,100)<adddoors+c then planetmap(p(0).x,p(0).y,slot)=-158
                endif
                if map(x,y)=1 then planetmap(x,y,slot)=-4 'platform
                if map(x,y)=2 then planetmap(x,y,slot)=-4
                
                if map(x,y)=3 then planetmap(x,y,slot)=-4 'internal of room
                if map(x,y)=4 then planetmap(x,y,slot)=-51 'wall
                if map(x,y)=5 then planetmap(x,y,slot)=-156 
                            
            endif
            
            if translate=4 then
                if map(x,y)=0 then planetmap(x,y,slot)=-rnd_range(175,177) 'gasclouds
                if map(x,y)=1 then planetmap(x,y,slot)=-68 'platform
                if map(x,y)=2 then planetmap(x,y,slot)=-80 'Corridor
                if map(x,y)=3 then planetmap(x,y,slot)=-80 'internal of room
                if map(x,y)=4 then planetmap(x,y,slot)=-52 'wall
                if map(x,y)=5 then planetmap(x,y,slot)=-156 'door
            endif
            
        next
    next

    return 0
end function


function makecomplex(byref enter as _cords, down as short,blocked as byte=0) as short
    
    dim as short last,wantsize,larga,largb,lno,x,y,mi,slot,old,a,dx,dy,dis,d,b,c,best,startdigging
    dim t as _rect
    dim r(255) as _rect
    dim rfl(255) as short
    dim map2(60,20) as short
    dim sp(255) as _cords
    dim as short roomsize
    dim p as _cords
    dim p1 as _cords
    dim p2 as _cords
    dim  as integer counter,bigc
    dim as short varchance
    slot=enter.m

    if show_all=1 then rlprint "Made complex at "&slot
    if planets(slot).depth=0 then planets(slot).depth=1
    planets(slot).darkness=5
    planets(slot).vault(0)=r(0)
    planets(slot).teleport=1
    
    planets(slot).temp=25
    planets(slot).atmos=3    
    planets(slot).grav=.8
    planets(slot).mon_template(0)=makemonster(9,slot)
    planets(slot).mon_noamin(0)=8
    planets(slot).mon_noamax(0)=16+planets(slot).depth
    planets(slot).mon_template(1)=makemonster(90,slot)
    planets(slot).mon_noamin(1)=16
    planets(slot).mon_noamax(1)=26+planets(slot).depth
    if rnd_range(1,100)<15+planets(slot).depth*3 then
        planets(slot).mon_template(2)=makemonster(56,slot)
        planets(slot).mon_noamin(2)=1
        planets(slot).mon_noamax(2)=2+planets(slot).depth
    endif
    if rnd_range(1,100)<25+planets(slot).depth*5 then
        planets(slot).mon_template(3)=makemonster(19,slot)
        planets(slot).mon_noamin(3)=0
        planets(slot).mon_noamax(3)=1+planets(slot).depth
    endif
    if rnd_range(1,100)<15+planets(slot).depth*5 then
        planets(slot).mon_template(4)=makemonster(91,slot)
        planets(slot).mon_noamin(4)=1
        planets(slot).mon_noamax(4)=2+planets(slot).depth
    endif
do   
    last=0
    for a=0 to 255
            r(a)=r(255)
    next
    roomsize=25
    wantsize=100 'chop to this size
    mi=2 'minimum
    
    r(0).x=0
    r(0).y=0
    r(0).h=20
    r(0).w=60
    
    do
        larga=0
        largb=0
        'find largestrect
        for a=0 to last
            if r(a).h>larga then 
                larga=r(a).h
                lno=a
            endif
            if r(a).w>larga then 
                larga=r(a).w
                lno=a
            endif
            if r(a).h*r(a).w>largb then
                largb=r(a).h*r(a).w
                lno=a
            endif
        next
        ' Half largest _rect 
        last=last+1
        if r(lno).h>r(lno).w then
            y=rnd_range(mi,r(lno).h-mi)
            old=r(lno).h
            t=r(lno)
            r(last)=t
            t.h=y-1
            r(last).y=r(last).y+y
            r(last).h=old-y
            r(lno)=t
        else
            x=rnd_range(mi,r(lno).w-mi)
            old=r(lno).w
            t=r(lno)
            r(last)=t
            t.w=x-1
            r(last).x=r(last).x+x
            r(last).w=old-x
            r(lno)=t
        endif
    loop until largb<wantsize 
    for a=0 to last
        fill_rect(r(a),1,0,map2())
    next
    
    for a=0 to last
        'make rects smaller
        fill_rect(r(a),1,1,map2())
        if r(a).h*r(a).w>roomsize then
            r(a).x=r(a).x+1
            r(a).y=r(a).y+1
            r(a).w=r(a).w-2
            r(a).h=r(a).h-2
            do 
                b=rnd_range(1,4)
                   
                if r(a).w>=r(a).h then
                    if b=1 then 
                        r(a).x=r(a).x+1
                        r(a).w=r(a).w-2
                    endif
                    if b=4 then r(a).w=r(a).w-2
                endif
                if r(a).h>r(a).w then
                    if b=2 then
                        r(a).y=r(a).y+1
                        r(a).h=r(a).h-2
                    endif
                    if b=3 then r(a).h=r(a).h-2
                endif
            loop until r(a).h*r(a).w<=roomsize
            if r(a).h>1 and r(a).w>1 then 
                fill_rect(r(a),0,0,map2())
            else 
                r(a).wd(5)=1 
            endif            
        else 
            r(a).wd(5)=1 
        endif
        
    next

    for a=0 to last
        if r(a).wd(5)=0 then
            c=0
            do
                do
                    if b>-1 then r(a).wd(b)=1
                    b=rndwall(r(a))
                    if b=-1  or c>52 then exit do
                    p1=rndwallpoint(r(a),b)
                    c=c+1
                loop until p1.x>2 and p1.y>1 and p1.x<58 and p1.y<19 and r(a).wd(b)=0
                if c<=52 and b>0 then
                    if rnd_range(1,100)<33 then map2(p1.x,p1.y)=3
                    b=digger(p1,map2(),b)
                    if rnd_range(1,100)<33 then map2(p1.x,p1.y)=3
                endif
            loop until b<=0 or c>52
        endif    
    next a        
    
    flood_fill(r(1).x,r(1).y,map2())
    
    counter=counter+1
    c=0
    for a=0 to last
        if map2(r(a).x,r(a).y)<10 and r(a).wd(5)=0 then c=c+1
        
    next
        
    loop until c=0
    for x=0 to 60
        for y=0 to 20
            planetmap(x,y,slot)=-52
            if map2(x,y)=1 then planetmap(x,y,slot)=-52 'Wall
            if map2(x,y)=11 then planetmap(x,y,slot)=-80 'Floor
            if map2(x,y)=13 then planetmap(x,y,slot)=-80 'Wall
            if map2(x,y)=14 then 
                if rnd_range(1,100)>planets(slot).depth*10 then
                    if rnd_range(1,100)<88 then
                        planetmap(x,y,slot)=-55 'Door
                    else
                        planetmap(x,y,slot)=-54
                    endif
                else
                    planetmap(x,y,slot)=-289 'secretdoor
                endif
            endif
            if map2(x,y)=15 then planetmap(x,y,slot)=-81 'Trap
            
        next
    next
    do
        a=rnd_range(0,last)
    loop until r(a).wd(5)=0
    'Put portal in room a 
    enter.x=r(a).x+r(a).w/2
    enter.y=r(a).y+r(a).h/2
    b=a
    for c=1 to rnd_range(1,planets(slot).depth+1)
        do
            a=rnd_range(0,last)
        loop until r(a).wd(5)=0 and a<>b
        x=r(a).x+r(a).w/2
        y=r(a).y+r(a).h/2
        planetmap(x,y,slot)=-82
    next
    for a=1 to rnd_range(1,planets(slot).depth+1)-rnd_range(1,planets(slot).depth-1)
        do
            a=rnd_range(0,last)
        loop until r(a).wd(5)=0 and a<>b
        x=r(a).x+r(a).w/2
        y=r(a).y+r(a).h/2
        planetmap(x,y,slot)=-84
        placeitem(make_item(99),x,y,slot)
    next
    for a=0 to rnd_range(1,planets(slot).depth+1)+rnd_range(1,planets(slot).depth-1)
        do
            a=rnd_range(0,last)
        loop until r(a).wd(5)=0 and a<>b
        x=rnd_range(r(a).x,r(a).x+r(a).w)
        y=rnd_range(r(a).y,r(a).y+r(a).h)
        planetmap(x,y,slot)=-84
    next
    if (rnd_range(1,100)<33 or planets(slot).depth>7) and blocked=0 then
        do
            a=rnd_range(0,last)
        loop until r(a).wd(5)=0 and a<>b
        x=rnd_range(r(a).x,r(a).x+r(a).w)
        y=rnd_range(r(a).y,r(a).y+r(a).h)
        lastportal+=1
        lastplanet+=1
        a=lastportal
        portal(a).desig="A shaft. "
        portal(a).tile=111
        portal(a).ti_no=3003
        portal(a).col=14
        portal(a).from.s=enter.s
        portal(a).from.m=enter.m
        'portal(a).from.m=map(portal(a).from.s).planets(portal(a).from.p)
        portal(a).from.x=x
        portal(a).from.y=y
        portal(a).dest.m=lastplanet
        portal(a).dest.s=portal(a).from.s
        portal(a).dest.x=rnd_range(1,59)
        portal(a).dest.y=rnd_range(1,19)
        portal(a).discovered=show_portals
        map(portal(a).from.s).discovered=3
        planetmap(portal(a).from.x,portal(a).from.y,slot)=0
    endif
    
    for a=0 to planets(slot).depth*5
        do
            p=rnd_point(slot,0)
            if p.x=0 then p.x=1
            if p.x=60 then p.x=59
            if p.y=0 then p.y=1
            if p.y=20 then p.y=19
        loop until (abs(planetmap(p.x,p.y-1,slot))=52 and abs(planetmap(p.x,p.y+1,slot))=52) or (abs(planetmap(p.x-1,p.y,slot))=52 and abs(planetmap(p.x+1,p.y,slot))=52) 
        planetmap(p.x,p.y,slot)=-289
    next
    planetmap(enter.x,enter.y,slot)=-80
    
    varchance=0
    
    if rnd_range(1,100)<planets(slot).depth*2 then
        planets(slot).vault(0)=r(rnd_range(0,last))
        planets(slot).vault(0).wd(5)=1
        varchance-=5
    endif
    varchance+=5
    if rnd_range(1,100)<15+planets(slot).depth*2+varchance then
        p=rnd_point(slot,0)
        planetmap(p.x,p.y,slot)=-298
        varchance-=5
    endif
    varchance+=5
    if rnd_range(1,100)<15+planets(slot).depth*2+varchance then
        p=rnd_point(slot,0)
        planetmap(p.x,p.y,slot)=-288
        varchance-=5
    endif
    varchance+=5
    if rnd_range(1,100)<15+planets(slot).depth*2+varchance then
        p=rnd_point(slot,0)
        planetmap(p.x,p.y,slot)=-288
        varchance-=5
    endif
    varchance+=5
    if rnd_range(1,100)<15+planets(slot).depth*2+varchance then
        p=rnd_point(slot,0)
        planetmap(p.x,p.y,slot)=-291
        varchance-=5
    endif
    varchance+=5
    
    if rnd_range(1,100)<5+planets(slot).depth*2+varchance then
        p=rnd_point(slot,0)
        planetmap(p.x,p.y,slot)=-293
        varchance-=4
    endif
    varchance+=5
    if rnd_range(1,100)<25+planets(slot).depth*2+varchance then
        for b=0 to rnd_range(1,planets(slot).depth)
            p=rnd_point(slot,0)
            if abs(planetmap(p.x,p.y,slot))=80 then planetmap(p.x,p.y,slot)=-225
        next
        varchance-=5
    endif
    varchance+=5
    if rnd_range(1,100)<25+planets(slot).depth*2+varchance then
        p=rnd_point(slot,0)
        if abs(planetmap(p.x,p.y,slot))=80 then planetmap(p.x,p.y,slot)=-292
        varchance-=5
    endif
    varchance+=5
    if rnd_range(1,100)<25+planets(slot).depth*2+varchance then
        for b=0 to rnd_range(1,planets(slot).depth)
            p=rnd_point(slot,0)
            if abs(planetmap(p.x,p.y,slot))=80 then planetmap(p.x,p.y,slot)=-290
        next
        varchance-=5
    endif
    varchance+=5
    if rnd_range(1,100)<15+planets(slot).depth*2+varchance then
        p=rnd_point(slot,0)
        planetmap(p.x,p.y,slot)=-231
        planets(slot).atmos=1
        planets(slot).grav=1
    endif
    return 0
end function

function makecomplex2(slot as short,gc1 as _cords, gc2 as _cords, roundedcorners1 as short,roundedcorners2 as short,nocol1 as short,nocol2 as short,doorchance as short,loopchance as short,loopdoor as short,adddoor as short,addloop as short,nosmallrooms as short,culdesacruns as short, t as short) as short

	dim as short map(60,20)
	dim as short map2(60,20)
	dim as short map3(60,20)
	dim as short x,y,c,a,ff,x1,y1,xx,yy,coll
	dim as short rw1,rh1 ,rn1 ,rmw1 ,rmh1 ,rw2 ,rh2,rn2 ,rmw2 ,rmh2 
	dim valid(1300) as _cords
	dim lastvalid as short
	dim valneigh(4) as _cords
	dim lastneig as short
	dim collision as short
	dim as short w,h
	
	rmw1=gc1.x
	rmh1=gc1.y
	rw1=gc1.p
	rh1=gc1.s
	rn1=gc1.m
	
	rmw2=gc2.x
	rmh2=gc2.y
	rw2=gc2.p
	rh2=gc2.s
	rn2=gc2.m
	
	for x=0 to 60
	    for y=0 to 20
	        map(x,y)=1
	    next
	next
	
	for x=1 to 59 step 2
	    for y=1 to 19 step 2
	        map(x,y)=0
	    next
	next
	
	if rn1>0 then
	    a=0
	    do
	        w=rnd_range(rmw1,rw1)
	        h=rnd_range(rmh1,rh1)
	        valid(c).x=rnd_range(1,59-w)
	        valid(c).y=rnd_range(1,19-h)
	        if nocol1=1 then
	            do
	                w=rnd_range(rmw1,rw1)
	                h=rnd_range(rmh1,rh1)
	                valid(c).x=rnd_range(1,59-w)
	                valid(c).y=rnd_range(1,19-h)
	                collision=0
	                for x=valid(c).x-1 to valid(c).x+w+1
	                    for y=valid(c).y-1 to valid(c).y+h+1
	                        if map2(x,y)=1 then 
	                            collision=1
	                        endif
	                    next
	                next
	                if collision=0 then
	                    for x=valid(c).x to valid(c).x+w
	                        for y=valid(c).y to valid(c).y+h
	                            map2(x,y)=1
	                        next
	                    next    
	                endif
	            loop until collision=0
	        else
	            collision=0
	        endif
	            
	        if collision=0 then
	            for x=valid(c).x to valid(c).x+w
	                for y=valid(c).y to valid(c).y+h
	                    if x=valid(c).x or y=valid(c).y or x=valid(c).x+w or y=valid(c).y+h then
	                        map(x,y)=1
	                    else
	                        if map(x,y)=1 then map(x,y)=0
	                    endif
	            
	
	                next
	            next    
	            
	            if rnd_range(1,100)<roundedcorners1  and h>4 and w>4 then
	                map(valid(c).x+1,valid(c).y+1)=1
	                map(valid(c).x+w-1,valid(c).y+1)=1
	                map(valid(c).x+w-1,valid(c).y+h-1)=1
	                map(valid(c).x+1,valid(c).y+h-1)=1
	            endif
	            a+=1
	        endif
	    loop until a>=rn1
	endif
	
	if rn2>0 then
	    a=0
	    do
	        w=rnd_range(rmw2,rw2)
	        h=rnd_range(rmh2,rh2)
	        valid(c).x=rnd_range(1,59-w)
	        valid(c).y=rnd_range(1,19-h)
	        if nocol2=1 then
	            collision=0
	            for x=valid(c).x-1 to valid(c).x+w+1
	                for y=valid(c).y-1 to valid(c).y+h+1
	                    if map2(x,y)=1 then 
	                        collision=1
	                    endif
	                next
	            next
	            if collision=0 then
	                for x=valid(c).x to valid(c).x+w
	                    for y=valid(c).y to valid(c).y+h
	                        map2(x,y)=1
	                    next
	                next    
	            endif
	        else
	            collision=0
	        endif
	            
	        if collision=0 then
	            for x=valid(c).x to valid(c).x+w
	                for y=valid(c).y to valid(c).y+h
	                    if x=valid(c).x or y=valid(c).y or x=valid(c).x+w or y=valid(c).y+h then
	                        map(x,y)=1
	                    else
	                        if map(x,y)=1 then map(x,y)=0
	                    endif
	            
	
	                next
	            next    
	            
	            if rnd_range(1,100)<roundedcorners2  and h>4 and w>4 then
	                map(valid(c).x+1,valid(c).y+1)=1
	                map(valid(c).x+w-1,valid(c).y+1)=1
	                map(valid(c).x+w-1,valid(c).y+h-1)=1
	                map(valid(c).x+1,valid(c).y+h-1)=1
	            endif
	            a+=1
	        endif
	    loop until a>=rn2
	endif
	
	do
	    lastvalid=0
	    for x=1 to 59
	        for y=1 to 19
	            if checkvalid(x,y,map()) then
	                lastvalid+=1
	                valid(lastvalid).x=x
	                valid(lastvalid).y=y
	            endif
	        next
	    next
	    if lastvalid>=1 then
	        c=rnd_range(1,lastvalid)
	        x=valid(c).x
	        y=valid(c).y
	        lastneig=0
	        if checkvalid(x-2,y,map()) then
	            lastneig+=1
	            valneigh(lastneig).x=x-2
	            valneigh(lastneig).y=y
	        endif
	        
	        if checkvalid(x+2,y,map()) then
	            lastneig+=1
	            valneigh(lastneig).x=x+2
	            valneigh(lastneig).y=y
	        endif
	        
	        if checkvalid(x,y+2,map()) then
	            lastneig+=1
	            valneigh(lastneig).x=x
	            valneigh(lastneig).y=y+2
	        endif
	        
	        if checkvalid(x,y-2,map()) then
	            lastneig+=1
	            valneigh(lastneig).x=x
	            valneigh(lastneig).y=y-2
	        endif
	        
	        if lastneig>0 then
	            c=rnd_range(1,lastneig)
	            if valneigh(c).x>x then map(x+1,y)=0
	            if valneigh(c).x<x then map(x-1,y)=0
	            if valneigh(c).y>y then map(x,y+1)=0
	            if valneigh(c).y<y then map(x,y-1)=0
	        else
	            'print "No valid neighbour"
	        endif
	
	    endif
	    
	loop until lastvalid=0 or lastneig=0
	    
	do
	    ff=1
	    
	    for x=0 to 60
	        for y=0 to 20
	            if map(x,y)=-1 then map(x,y)=0
	            'if map(x,y)=-2 then map(x,y)=2
	            
	        next
	    next
	
	    floodfill3(1,1,map())
	        
	    
	    lastvalid=0
	    for x=1 to 59 
	        for y=1 to 19 
	            if checkdoor(x,y,map()) then
	                lastvalid+=1
	                valid(lastvalid).x=x
	                valid(lastvalid).y=y
	                
	            endif
	        next
	    next
	    
	
	    
	    
	    
	    if lastvalid>0 then
	        c=rnd_range(1,lastvalid)
	        if rnd_range(1,100)<doorchance then
	            map(valid(c).x,valid(c).y)=2
	        else
	            map(valid(c).x,valid(c).y)=0
	        endif
	    endif
	
	    for x=0 to 60
	        for y=0 to 20
	            if map(x,y)=0 then ff=0
	        next
	    next
	    
	loop until ff=1 or lastvalid=0
	
	for x=0 to 60
	    for y=0 to 20
	        if map(x,y)=-1 then map(x,y)=0
	        if map(x,y)=-2 then map(x,y)=2
	    next
	next
	
	if culdesacruns>0 then
	for a=0 to culdesacruns
	    for x=0 to 60
	        for y=0 to 20
	            map2(x,y)=map(x,y)
	        next
	    next
	    for x=1 to 59
	        for y=1 to 19
	            ff=0
	            for x1=x-1 to x+1
	                for y1=y-1 to y+1
	                    if map(x1,y1)=1 then ff=ff+1
	                next
	            next
	            if map(x,y)=1 or map(x,y)=0 then
	                if map(x-1,y)<>2 and map(x+1,y)<>2 and map(x,y-1)<>2 and map(x,y+1)<>2 then
	                    if ff<3 and map(x,y)=1 then 
	                        map2(x,y)=0
	                        map3(x,y)=1
	                    endif
	                    if ff>=7 and map(x,y)=0 then 
	                        map2(x,y)=1
	                        map3(x,y)=1
	                    endif
	                    if map(x,y)=0 then
	                        if map(x-1,y-1)=1 and map(x-1,y)=1 and map(x-1,y+1)=1 and map(x,y-1)=1 and map(x,y+1)=1 then
	                            map2(x,y)=1
	                            map3(x,y)=1
	                        endif
	                        if map(x+1,y-1)=1 and map(x+1,y)=1 and map(x+1,y+1)=1 and map(x,y-1)=1 and map(x,y+1)=1 then
	                            map2(x,y)=1
	                            map3(x,y)=2
	                        endif
	                        if map(x+1,y-1)=1 and map(x,y-1)=1 and map(x-1,y-1)=1 and map(x-1,y)=1 and map(x+1,y)=1 then
	                            map2(x,y)=1
	                            map3(x,y)=3
	                        endif
	                        if map(x+1,y+1)=1 and map(x,y+1)=1 and map(x-1,y+1)=1 and map(x-1,y)=1 and map(x+1,y)=1 then
	                            map2(x,y)=1
	                            map3(x,y)=4
	                        endif
	                    endif
	                endif
	            endif
	        next
	            
	    next
	
	    for x=0 to 60
	        for y=0 to 20
	            map(x,y)=map2(x,y)
	        next
	    next
	next
	endif
	
	if nosmallrooms>0 then
	for a=0 to nosmallrooms
	
	    for x=0 to 60
	        for y=0 to 20
	            map2(x,y)=map(x,y)
	        next
	    next
	    for x=1 to 59
	        for y=1 to 19
	            ff=0
	            for x1=x-1 to x+1
	                for y1=y-1 to y+1
	                    if map(x1,y1)=1 then ff=ff+1
	                next
	            next
	            if ff=7 and nosmallrooms=1 then
	                if map(x-1,y)=2 and map(x+1,y)=1 and map(x,y-1)=1 and map(x,y+1)=1 then
	                    map2(x-1,y)=1
	                    map3(x-1,y)=2
	                    map2(x,y)=1
	                    map3(x,y)=2
	                endif
	                if map(x-1,y)=1 and map(x+1,y)=2 and map(x,y-1)=1 and map(x,y+1)=1 then
	                    map2(x+1,y)=1
	                    map3(x+1,y)=3
	                    map2(x,y)=1
	                    map3(x,y)=3
	                endif
	                if map(x-1,y)=1 and map(x+1,y)=1 and map(x,y-1)=2 and map(x,y+1)=1 then
	                    map2(x,y-1)=1
	                    map3(x,y-1)=4
	                    map2(x,y)=1
	                    map3(x,y)=4
	                endif
	                if map(x-1,y)=1 and map(x+1,y)=1 and map(x,y-1)=1 and map(x,y+1)=2 then
	                    map2(x,y+1)=1
	                    map3(x,y+1)=5
	                    map2(x,y)=1
	                    map3(x,y)=5
	                endif
	            endif
	        next
	    next
	
	    for x=0 to 60
	        for y=0 to 20
	            map(x,y)=map2(x,y)
	        next
	    next
	
	next
	endif
	
	
	for x=0 to 58
	    for y=0 to 18
	        if map(x+1,y+1)=1 then
	        'if rnd_range(1,100)<loopchance and map(x,y)=1 and map(x+1,y)=0 and map(x+2,y)=1 and map(x,y+1)=1 and map(x+1,y+1)=1 and map(x+2,y+1)=1 and map(x+2,y)=1 and map(x+2,y+1)=0 and map(x+3,y+2)=1 then map2(x+1,y+1)=0
	        'if rnd_range(1,100)<loopchance and map(x,y)=1 and map(x,y+1)=0 and map(x,y+2)=1 and map(x+1,y)=1 and map(x+1,y+1)=1 and map(x+1,y+2)=1 and map(x+2,y)=1 and map(x+2,y+1)=0 and map(x+2,y+2)=1 then map2(x+1,y+1)=0
	            if map(x+1,y)=1 and map(x+1,y+2)=1 and map(x,y+1)=0 and map(x+2,y+1)=0 then
	                if rnd_range(1,100)<loopdoor and adddoor=1 then map(x+1,y+1)=2 
	                if rnd_range(1,100)<loopchance and addloop=1 then map(x+1,y+1)=0
	            endif
	                
	            if map(x,y+1)=1 and map(x+2,y+1)=1 and map(x+1,y)=0 and map(x+1,y+2)=0 then
	                if rnd_range(1,100)<loopdoor and adddoor=1 then map(x+1,y+1)=2 
	                if rnd_range(1,100)<loopchance and addloop=1 then map(x+1,y+1)=0
	            endif
	            
	        endif
	    next
	    
	next
	
	x1=0
	y1=0
	for x=0 to 30
	    for y=0 to 10
	        if map(x,y)=0 and x1=0 and y1=0 then
	            x1=x
	            y1=y
	        endif
	    next
	next    
	
	floodfill3(x1,y1,map())
	    
	for x=0 to 60
	    for y=0 to 20
	        if map(x,y)=-1 then map(x,y)=0
	        if map(x,y)=-2 then map(x,y)=2
	    next
	next
	
	if t=1 then
	    for xx=0 to 60
	        for yy=0 to 20
	            if map(xx,yy)=1 then planetmap(xx,yy,slot)=-50
	            if map(xx,yy)=0 then planetmap(xx,yy,slot)=-202
	            if xx>1 and yy>1 and xx<60 and yy<20 and map(xx,yy)=0 then
	                coll=0
	                for x=xx-1 to xx+1
	                    for y=yy-1 to yy+1
	                        if map(x,y)<>0 then coll+=1
	                    next
	                next
	                if coll=0 and rnd_range(1,100)<60 then planetmap(xx,yy,slot)=-223
	                if coll=7 and rnd_range(1,100)<60 then planetmap(xx,yy,slot)=-221
	                if coll=4 and rnd_range(1,100)<60 then planetmap(xx,yy,slot)=-248
	            endif
	            if map(xx,yy)=3 then planetmap(xx,yy,slot)=-47
	            if map(xx,yy)=4 then planetmap(xx,yy,slot)=-156
	        next
	    next
	endif
	    
	return 0
end function


function makefinalmap(m as short) as short
    dim as _cords p,p2
    dim as short f,x,y,c,l
    planets(m).darkness=5
    planets(m).teleport=1
    f=freefile
    open "data/lstlvl.dat" for binary as #f
    for y=0 to 20
        for x=0 to 60
            get #f,,l
            planetmap(x,y,m)=l
            if planetmap(x,y,m)=-80 and rnd_range(1,100)<20 then planetmap(x,y,m)=-81
            if planetmap(x,y,m)=-54 and rnd_range(1,100)<80 then planetmap(x,y,m)=-55
        next
    next
    close #f
    p2.x=31
    p2.y=2
    do
        p=rnd_point(m,0)
    loop until distance(p,p2)>15
    planetmap(p.x,p.y,m)=-127
    for y=0 to 20
        for x=0 to 60
             if show_all=1 then planetmap(x,y,m)=planetmap(x,y,m)*-1
        next
    next
    planets(m).depth=10
    planets(m).mon_template(0)=makemonster(19,m)
    planets(m).Mon_noamax(0)=28
    planets(m).mon_noamin(0)=22
    planets(m).mon_template(1)=makemonster(56,m)
    planets(m).Mon_noamax(1)=12
    planets(m).mon_noamin(1)=10
    planets(m).mon_template(2)=makemonster(55,m)
    planets(m).Mon_noamax(2)=12
    planets(m).mon_noamin(2)=10
    planets(m).mon_template(3)=makemonster(91,m)
    planets(m).Mon_noamax(3)=12
    planets(m).mon_noamin(3)=10
    planets(m).grav=0.5
    planets(m).atmos=3
    return 0
end function


function makeplanetmap(a as short,orbit as short,spect as short) as short
    DimDebugL(0)
    dim gascloud as short
    dim b1 as short
    dim b2 as short
    dim b3 as short
    dim o as short
    dim as short roll,planettype
    dim x as short
    dim y as short
    dim wx as short
    dim wy as short
    dim ice as short
    dim cnt as short
    dim as short b,c,d,e
    dim watercount as integer
    dim waterreplace as short
    dim as short prefmin
    dim as _cords p,p1,p2,p3,p4
    dim ti as short
    dim it as _items
    dim r1 as _rect
    dim t as _rect
    dim r(255) as _rect
    dim wmap(60,20) as short
    dim as short last,wantsize,larga,largb,lno,mi,old,alwaysstranded
    if a<=0 then 
       rlprint "ERROR: Attempting to make planet map at "&a,14
       return 0
    endif
    
    prefmin=rnd_range(1,14)
    planettype=rnd_range(1,100)
    o=orbit
    planets(a).orbit=o
    planets(a).water=(rnd_range(1,3)+rnd_range(1,3)+rnd_range(1,3)+rnd_range(1,3)+rnd_range(1,3)-orbit)*10
    if o<3 then planets(a).water=planets(a).water-rnd_range(70,100)
    if planets(a).water<0 then planets(a).water=0
    if planets(a).water>=75 then planets(a).water=75
    planets(a).atmos=rnd_range(1,21)
    if planets(a).atmos=21 then planets(a).atmos=2
    if planets(a).atmos=1 then planets(a).atmos=2
    if planets(a).atmos>16 then planets(a).atmos=planets(a).atmos-9
    
    if planets(a).atmos>16 then planets(a).atmos=16
    if planets(a).atmos<1 then planets(a).atmos=1
    planets(a).grav=(3+rnd_range(1,10)+rnd_range(1,8))/10
    planets(a).weat=0.5+(rnd_range(0,10)-5)/10
    if planets(a).weat<=0 then planets(a).weat=0.5
    if planets(a).weat>1 then planets(a).weat=0.9
    gascloud=abs(spacemap(player.c.x,player.c.y))
    if spect=1 then gascloud=gascloud-2
    if spect=2 then gascloud=gascloud-2
    if spect=3 then gascloud=gascloud-1
    if spect=4 then gascloud=gascloud-1
    if spect=5 then gascloud=gascloud-1
    if spect=6 then gascloud=gascloud
    if spect=7 then gascloud=gascloud+1
    if spect=8 then gascloud=gascloud+2
    planets(a).minerals=rnd_range(2,spect)+rnd_range(1,4)+disnbase(player.c)\7
    if gascloud<6 then planets(a).minerals+=gascloud
    
    roll=rnd_range(1,100)
    b1=3
    b2=4
    b3=12
    if roll<55 then
        b1=4
        b2=3
        b3=12
    endif
    if roll<75 then
        b1=12
        b2=3
        b3=4    
    endif
    'background
    for x=0 to 60
        for y=0 to 20
            planetmap(x,y,a)=-4
            if rnd_range(1,100)<60 then planetmap(x,y,a)=-b1
            if rnd_range(1,100)<20 then planetmap(x,y,a)=-b2            
            if rnd_range(1,100)<20 then planetmap(x,y,a)=-b3
        next
    next
    
    b2=planets(a).water    
    if b2>20 then
        cnt=0
        do    
            cnt=cnt+1
            wx=rnd_range(0,1)+rnd_range(0,1)+1
            wy=rnd_range(0,1)+rnd_range(0,1)+1
            p1.x=rnd_range(0,(60-(wx*2)))
            p1.y=rnd_range(0,(20-(wy*2)))
            p2.x=p1.x+wx-rnd_range(0,1)
            p2.y=p1.y+wy-rnd_range(0,1)
        
            if wx>wy then
                b1=cint(100/wx)
            else
                b1=cint(100/wy)
            endif
        
            for x=p1.x to p1.x+wx*2
                for y=p1.y to p1.y+wy*2
                    p3.x=x
                    p3.y=y
                    d=distance(p3,p2)
                    if rnd_range(1,100)<(101-(d*d*d*b1*b1)) then
                        planetmap(x,y,a)=rnd_range(1,2)*-1
                        watercount=watercount+1
                    endif
                next
            next
        loop until watercount>b2*12 or cnt>500
    else
        for b=1 to b2*12
            planetmap(rnd_range(0,60),rnd_range(0,20),a)=-2
            watercount=watercount+1
        next
    endif
  
    
    p1.x=rnd_range(1,59)
    p1.y=rnd_range(1,19)
    
    b1=100+rnd_range(25,50)+rnd_range(1,25)-planets(a).water
    if b1<=0 then b1=rnd_range(1,10)+rnd_range(1,10)
    
    for x=0 to b1
        planetmap(p1.x,p1.y,a)=-8
        if rnd_range(1,100)<planets(a).grav then planetmap(p1.x,p1.y,a)=-245
        if rnd_range(1,100)<(80-planets(a).water) then
            p1=movepoint(p1,5)
        else
            p1.x=rnd_range(1,59)
            p1.y=rnd_range(1,19)
        endif
    next
    for b=0 to rnd_range(0,b2)-10
        wx=rnd_range(0,2)+rnd_range(0,1)+1
        wy=rnd_range(0,2)+rnd_range(0,1)+1
        p1.x=rnd_range(0,(60-(wx*2)))
        p1.y=rnd_range(0,(20-(wy*2)))
        p2.x=p1.x+wx
        p2.y=p1.y+wy
        for x=p1.x to p1.x+wx*2
            for y=p1.y to p1.y+wy*2
                p3.x=x
                p3.y=y
                d=distance(p3,p2)
                if rnd_range(1,100)<=100-(d*25) then
                    if rnd_range(1,100)<50 then
                        planetmap(rnd_range(1,60),rnd_range(2,18),a)=-5
                    else
                        planetmap(rnd_range(1,60),rnd_range(2,18),a)=-6
                    endif
                endif
            next
        next
    next
    togglingfilter(a)
    togglingfilter(a,8,7)
    togglingfilter(a,5,6)
    
    if planettype>=22 and planettype<33 then
        makemossworld(a,o)
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            d=0
            p=rnd_point
            if specialplanet(15)<>a then placeitem(make_item(96,planets(a).depth+planets(a).minerals,planets(a).depth+planets(a).minerals,prefmin),p.x,p.y,a,0,0)
        next b
    endif
    
    if planettype>=33 and planettype<44 then
        makeoceanworld(a,o)
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            d=0
            p=rnd_point
            if specialplanet(15)<>a then placeitem(make_item(96,planets(a).depth+planets(a).minerals,planets(a).depth+planets(a).minerals,prefmin),p.x,p.y,a,0,0)
        next b
    endif
    
    if planettype>=44 and planettype<65 then 
        makecanyons(a,o)'canyons
        
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            d=0
            do
               d=d+1
               p=rnd_point
            loop until planetmap(p.x,p.y,a)=-7 or planetmap(p.x,p.y,a)=-8 or d=10
            if specialplanet(15)<>a then placeitem(make_item(96,planets(a).depth+disnbase(player.c)\5+gascloud,planets(a).depth+disnbase(player.c)\6+gascloud,prefmin),p.x,p.y,a,0,0)
        next b
    
    endif
    if (planettype>=65 and planettype<80) or spect=8 then 
        makecraters(a,o)'craters
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            p=rnd_point
            if specialplanet(15)<>a then placeitem(make_item(96,planets(a).depth+planets(a).minerals,planets(a).depth+planets(a).minerals,prefmin),p.x,p.y,a,0,0)
            if rnd_range(1,100)<66 then
                d=158
            else
                d=47
            endif
            for c=0 to rnd_range(0,2)
                planetmap(p.x,p.y,a)=d
                p=movepoint(p,5)
            next
        next b
    
    endif
    if planettype>=80 and planettype<95 then 
        makeislands(a,o)'islands
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            d=0
            do
               d=d+1
               p=rnd_point
            loop until planetmap(p.x,p.y,a)=-1 or planetmap(p.x,p.y,a)=-2 or d=10
            if specialplanet(15)<>a then placeitem(make_item(96,planets(a).depth+planets(a).minerals,planets(a).depth+planets(a).minerals,prefmin),p.x,p.y,a,0,0)
        next b
    
    endif
    if planettype>=95 and o>6 then
        makegeyseroasis(a)
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            d=0
            p=rnd_point
            if specialplanet(15)<>a then placeitem(make_item(96,planets(a).depth+planets(a).minerals,planets(a).depth+planets(a).minerals,prefmin),p.x,p.y,a,0,0)
        next b
    endif
    makeice(a,o)    
    
    planets(a).dens=(planets(a).atmos-1)-6*((planets(a).atmos-1)\6)
    'planets(a).temp=round_nr(spect*83-o*(53+rnd_range(1,20)/10),1)'(8-planets(a).dens)
    planets(a).temp=fix(((Spect*500*(1-planets(a).dens/10))/(16*3.14*5.67*((orbit*75)^2)))^0.25*2500)*(3/orbit)-173.15
    if spect=8 then planets(a).temp=-273
    if planets(a).temp<-270 then planets(a).temp=-270+rnd_range(1,10)/10
    
    '
    ' "Normal" specials
    '
    
    ' 
    if a<>piratebase(0) then
        if planets(a).depth=0 and rnd_range(1,100)<15-disnbase(player.c) then
            p1=rnd_point
            planetmap(p1.x,p1.y,a)=-86 '2nd landingparty
        endif
        
        if planets(a).depth=0 and rnd_range(1,100)<15-distance(player.c,map(sysfrommap(specialplanet(7))).c) then
            p1=rnd_point
            planetmap(p1.x,p1.y,a)=-283
        endif
        
        if planets(a).depth=0 and rnd_range(1,100)<15-distance(player.c,map(sysfrommap(specialplanet(46))).c) then
            p1=rnd_point
            planetmap(p1.x,p1.y,a)=-284
        endif
        
        if planets(a).depth=0 and rnd_range(1,150)<20-disnbase(player.c) then
            p1=rnd_point
            makemudsshop(a,p1.x,p1.y) 'Mud's Bazar
        endif
        
        
        if rnd_range(1,200)<16 and planets(a).atmos>1 then
            if rnd_range(1,100)<66 then
                p1=rnd_point
                if p1.x>56 then p1.x=56
                if p1.y>16 then p1.y=16
                planetmap(p1.x+1,p1.y,a)=-8
                planetmap(p1.x+2,p1.y,a)=-8
                planetmap(p1.x,p1.y+1,a)=-8
                planetmap(p1.x+3,p1.y+1,a)=-8
                planetmap(p1.x,p1.y+2,a)=-8
                planetmap(p1.x+3,p1.y+2,a)=-8
                planetmap(p1.x+1,p1.y+3,a)=-8
                planetmap(p1.x+2,p1.y+3,a)=-8
                
                
                planetmap(p1.x+1,p1.y+1,a)=-2
                planetmap(p1.x+2,p1.y+1,a)=-2
                planetmap(p1.x+1,p1.y+2,a)=-2
                planetmap(p1.x+2,p1.y+2,a)=-2
            else
                p1=rnd_point
                b=rnd_range(3,5)
                for x=0 to 60
                    for y=0 to 20
                        p2.x=x
                        p2.y=y
                        if distance(p1,p2)<=b then planetmap(x,y,a)=-8
                        if distance(p1,p2)<b-1 then planetmap(x,y,a)=-2
                    next
                next
                if rnd_range(1,100)>33 then planetmap(p1.x,p1.y,a)=-7
                if rnd_range(1,100)>33 then placeitem(make_item(96,10,-1),p1.x,p1.y,a,0,0)
            endif
        
        endif
        
        if rnd_range(1,200)<25 then 'Geyser
            for b=0 to rnd_range(1,8)+rnd_range(1,8)+planets(a).atmos
                p1=rnd_point
                planetmap(p1.x,p1.y,a)=-29
                if planets(a).temp<-100 then planetmap(p1.x,p1.y,a)=-30
                if planets(a).temp>-10 and planets(a).temp<130 then planetmap(p1.x,p1.y,a)=-28
            next
        endif
        
        if rnd_range(1,380)<disnbase(player.c)/5 then
            p2=rnd_point
            for b=1 to rnd_range(1,6)+rnd_range(1,3)
                p1=movepoint(p2,b)
                planetmap(p1.x,p1.y,a)=-148
            next
            planetmap(p2.x,p2.y,a)=-100 'Lone factory
        endif
        
        'pink sand
        if rnd_range(1,200)<9 then
            p1=rnd_point
            b=rnd_range(1,3)+rnd_range(0,2)+1
            for x=p1.x-4 to p1.x+4
                for y=p1.y-4 to p1.y+4
                    if x>=0 and y>=0 and x<=60 and y<=20 then
                        p2.x=x
                        p2.y=y
                        if distance(p1,p2)<b then 
                            if rnd_range(1,100)<88 then planetmap(x,y,a)=-13
                            if rnd_range(1,100)<15 then placeitem(make_item(96,-2,-3),x,y,a,0,0)
                        endif
                    endif
                next
            next
        endif
        
        planets(a).life=(((planets(a).water/10)+1)*planets(a).atmos)/10
        if planettype>=44 and planettype<65 then planets(a).life+=rnd_range(1,3)
    
        if planets(a).orbit>2 and planets(a).orbit<6 then planets(a).life=planets(a).life+rnd_range(1,5)
        if planets(a).life>10 then planets(a).life=10 
        planets(a).rot=(rnd_range(0,10)+rnd_range(0,5)+rnd_range(0,5)-4)/10
        if planets(a).rot<0 then planets(a).rot=0 
        
        'Flowers
        if rnd_range(1,200)<planets(a).atmos+planets(a).life and planets(a).atmos>1 then
            b=rnd_range(0,12)+rnd_range(0,12)+rnd_range(0,12)+1
            for x=1 to b
                p2=rnd_point
                if rnd_range(1,100)<88 then planetmap(p2.x,p2.y,a)=-146
            next
        endif
        alwaysstranded=1
        'Stranded ship
        if rnd_range(1,300)<15-disnbase(player.c)/10+planets(a).grav*10 or (alwaysstranded=1 and debug>0) then
            p1=rnd_point
            b=rnd_range(1,100+tVersion.gameturn/5000)'!
            c=rnd_range(1,6)
            if c=5 or c=6 then c=1
            d=0
            if b>50 then d=4
            if b>75 then d=8
            if b>95 then d=12
            planetmap(p1.x,p1.y,a)=(-127-c-d)*-1
            if alwaysstranded=1 and debug=1 then planetmap(p1.x,p1.y,a)=241
            'planetmap(p1.x,p1.y,a)=241
            for b=0 to 1+d
                if rnd_range(1,100)<11 then placeitem(rnd_item(RI_StrandedShip),p1.x,p1.y,a)
            next
        endif
        
        'Mining
        if rnd_range(1,200)<15-disnbase(player.c) then
            p1=rnd_point
            planetmap(p1.x,p1.y,a)=-76
            for b=0 to rnd_range(1,4)
                if rnd_range(1,100)<25 then placeitem(rnd_item(RI_Mining),p1.x,p1.y,a)
                if rnd_range(1,100)<66 then placeitem(make_item(96,-2,-2),p1.x,p1.y,a,0,0)
            next
            if rnd_range(1,100)<42 then 
                p1=movepoint(p1,5)
                planetmap(p1.x,p1.y,a)=-68
            endif
            if rnd_range(1,100)<25 then
                for b=0 to rnd_range(1,4)
                    do
                        p2=rnd_point
                    loop until distance(p1,p2)<10
                    if rnd_range(1,100)<25 then placeitem(rnd_item(RI_MiningBots),p2.x,p2.y,a)
                next
            endif
        endif
        
        if rnd_range(1,100)<planets(a).grav then
            for b=1 to rnd_range(1,planets(a).grav*2)
                p=rnd_point
                planetmap(p.x,p.y,a)=-245
            next
        endif
        
        
        if rnd_range(1,100)<3 then
            p=rnd_point
            do
                planetmap(p.x,p.y,a)=-193
                p=movepoint(p,5)
            loop until rnd_range(1,100)<77
        endif
        
        if rnd_range(1,200)<3+disnbase(player.c)/10 then 'Abandoned squidsuit
            p=rnd_point
            placeitem(make_item(123),p.x,p.y,a)
        endif
        
        'radioactive crater   
        if rnd_range(1,200)<1+disnbase(player.c)/10 then
            p1=rnd_point
            b=rnd_range(0,2)+rnd_range(0,2)+2
            for x=p1.x-4 to p1.x+4
                for y=p1.y-4 to p1.y+4
                    if x>=0 and y>=0 and x<=60 and y<=20 then
                        p2.x=x
                        p2.y=y
                        if distance(p1,p2)<b then planetmap(x,y,a)=-160
                        if distance(p1,p2)=b then planetmap(x,y,a)=-159
                            
                    endif
                next
            next
            it=make_item(96,9,9)
            it.v2=6
            it.col=11
            it.desig="transuranic metals"
            it.v5=(it.v1+rnd_range(1,player.science(0)+it.v2))*(it.v2*rnd_range(1,10-player.science(0)))
            placeitem(it,p1.x,p1.y,a)        
        endif
        

    endif
    
    planets(a).mapmod=0.5+planets(a).dens/10+planets(a).grav/5
    
    modsurface(a,o)
    
    if spect=8 or spect=10 then
        makecraters(a,9)
        planets(a).darkness=5
        planets(a).orbit=9
        planets(a).temp=-270+rnd_range(1,10)/10
        planets(a).rot=-1
    endif
    
    for b=0 to planets(a).life
#if __FB_DEBUG__
        if debug=99 then 
			DbgPrint("chance:" &b &(planets(a).life+1)*3)
        EndIf
#endif
        if rnd_range(1,100)<(planets(a).life+1)*3 then 
            planets(a).mon_template(b)=makemonster(1,a)
            planets(a).mon_noamin(b)=cint((rnd_range(1,planets(a).life)*planets(a).mon_template(b).diet)/2)
            planets(a).mon_noamax(b)=cint((rnd_range(1,planets(a).life)*2*planets(a).mon_template(b).diet)/2)
            if planets(a).mon_noamin(b)>planets(a).mon_noamax(b) then swap planets(a).mon_noamin(b),planets(a).mon_noamax(b)
        endif
    next
    
    if rnd_range(1,100)<(planets(a).life+1)*3 then
        planets(a).mon_noamin(11)=1
        planets(a).mon_noamax(11)=1
        planets(a).mon_template(11)=makemonster(2,a)
    endif
    
    for b=1 to _NoPB '1 because 0 is mainbase
        if a=piratebase(b) then makeoutpost(a)
    next
    b=0
    for x=0 to 60
        for y=0 to 20
            if tiles(abs(planetmap(x,y,a))).walktru=1  or planetmap(x,y,a)=-1 or planetmap(x,y,a)=-20 or planetmap(x,y,a)=-25 or planetmap(x,y,a)=-27 then b=b+1
        next
    next
    planets(a).water=(b/1200)*100
    planets(a).darkness=3-cint((5-planets(a).orbit)/2)
    
    planets(a).dens=planets(a).atmos
    if planets(a).dens>5 then planets(a).dens-=5
    if planets(a).dens>5 then planets(a).dens-=5
    planets(a).dens-=1
    
    if show_all=1 then
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=-planetmap(x,y,a)
            next
        next
    endif
    make_special_planet(a)
    if is_special(a)=0 then
        if sysfrommap(a)>0 then
            if distance(map(sysfrommap(a)).c,civ(0).home)<2*civ(0).tech+2*civ(0).aggr and rnd_range(1,100)<civ(0).aggr*15 then
                make_aliencolony(0,a,rnd_range(2,4))    
                planets(a).mon_template(1)=civ(0).spec
                planets(a).mon_noamin(1)=rnd_range(2,4)
                planets(a).mon_noamax(1)=planets(a).mon_noamin(1)+rnd_range(2,4)
            endif
        endif
    endif    
    for b=0 to planets(a).minerals+planets(a).life
        if specialplanet(15)<>a and planettype<44 and isgasgiant(a)=0 then placeitem(make_item(96,planets(a).depth+disnbase(player.c)\6+gascloud,planets(a).depth+disnbase(player.c)\7+gascloud),rnd_range(0,60),rnd_range(0,20),a)
    next b
    if add_tile_each_map<>0 then
        p=rnd_point
        planetmap(p.x,p.y,a)=add_tile_each_map
    endif
    if isgardenworld(a) then planets_flavortext(a)="This place is lovely."
        
    if planets(a).temp=0 and planets(a).grav=0 then rlprint "Made a 0 planet,#"&a,c_red
    return 0
end function


function make_eventplanet(slot as short) as short
    DimDebug(0)'4
    dim as _cords p1,from,dest
    dim as _cords gc1,gc
    dim as short x,y,a,b,t1,t2,t,maxt    
    static generated(11) as short
    
    if orbitfrommap(slot)<>1 then
        maxt=10
    else
        maxt=11
    endif
    do
        t1=rnd_range(0,maxt)+disnbase(map(sysfrommap(slot)).c)/10
        t2=rnd_range(0,maxt)+disnbase(map(sysfrommap(slot)).c)/10
        if t1<1 then t1=1
        if t2<1 then t2=1
        if t1>maxt then t1=maxt
        if t2>maxt then t2=maxt
    loop until t1<>t2
    if generated(t1)>generated(t2) then t=t2
    if generated(t1)<generated(t2) then t=t1
    if generated(t1)=generated(t2) then 
        if rnd_range(1,100)<=50 then
            t=t1
        else
            t=t2
        endif
    endif
    
    if t<1 then t=1
    if t>maxt then t=maxt
    
    generated(t)+=1
    't=4

#if __FB_DEBUG__
    if debug=1 then 
        print "making "&t & " on planet "&slot &" in system " &sysfrommap(slot)
        no_key=keyin
    endif
    if debug=4 then t=7
#endif
    
    if t=1 then 'Mining Colony in Distress Flag 22 
        make_mine(slot)
    endif
    
    if t=2 then 'Icetrolls
        deletemonsters(slot)
        makecraters(slot,3)
        planets(slot).temp=-100+rnd_range(1,15)/2
        planets(slot).atmos=1
        planets(slot).rot=rnd_range(1,3)/100
        planets(slot).grav=rnd_range(6,16)/10
        for x=0 to 60
            for y=0 to 20
                if tiles(abs(planetmap(x,y,slot))).walktru=0 then
                    if rnd_range(1,100)<25 then planetmap(x,y,slot)=-304
                endif
            next
        next
    endif
    
    if t=3 then
        planetmap(rnd_range(0,60),rnd_range(0,20),slot)=-9
    endif
    
    if t=4 then 'Smith & Pirates fighting over an ancient factory Flag 23
        for a=0 to rnd_range(2,5)
            p1=rnd_point()
            planetmap(p1.x,p1.y,slot)=264
        next
        for a=0 to rnd_range(2,5)
            p1=rnd_point()
            planetmap(p1.x,p1.y,slot)=-67
        next
        planets(slot).flags(23)=1
        
        planets(slot).mon_template(0)=makemonster(3,slot)
        planets(slot).mon_noamax(0)=rnd_Range(2,12)+6
        planets(slot).mon_noamin(0)=rnd_Range(2,12)
        
        planets(slot).mon_template(1)=makemonster(50,slot)
        planets(slot).mon_noamax(1)=rnd_Range(0,2)+3
        planets(slot).mon_noamin(1)=rnd_Range(1,2)
        
        planets(slot).mon_template(2)=makemonster(71,slot)
        planets(slot).mon_template(2).cmmod=5
        planets(slot).mon_template(2).lang=29
        planets(slot).mon_noamax(2)=rnd_Range(2,12)+6
        planets(slot).mon_noamin(2)=rnd_Range(2,12)
        
        planets(slot).mon_template(3)=makemonster(72,slot)
        planets(slot).mon_template(3).cmmod=5
        planets(slot).mon_template(3).lang=29
        planets(slot).mon_noamax(3)=rnd_Range(0,2)+3
        planets(slot).mon_noamin(3)=rnd_Range(1,2)
            
        gc.m=slot
        gc.x=rnd_range(2,60)
        gc.y=rnd_range(1,18)
        lastplanet+=1
        gc1.m=lastplanet
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        makecomplex(gc1,1)
        addportal(gc,gc1,0,asc("o"),"A shaft",14)
    
    endif
    
    if t=5 or t=6 then
        deletemonsters(slot)
        planets(slot).flags(24)=1
        planets(slot).atmos=5
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,slot)=-4
                if rnd_range(1,100)<77 then
                    if rnd_range(1,100)<80 then
                        planetmap(x,y,slot)=-6
                    else
                        planetmap(x,y,slot)=-5
                    endif
                endif
            next
        next
        for x=0 to 29+rnd_range(1,6)
            planetmap(rnd_range(0,60),rnd_range(0,20),slot)=-146
        next
        for x=0 to rnd_range(1,5)
            placeitem(make_item(96,planets(slot).depth+disnbase(player.c)\5,planets(a).depth+disnbase(player.c)\6),rnd_range(0,60),rnd_range(0,20),slot,0,0)
        next
        for x=0 to 3
            p1=rnd_point
            planetmap(p1.x,p1.y,slot)=-59
            placeitem(make_item(96,planets(slot).depth+disnbase(player.c)\5,planets(a).depth+disnbase(player.c)\6),p1.x,p1.y,slot,0,0)

        next
        
        lastportal=lastportal+1
        lastplanet=lastplanet+1
        makeroots(lastplanet)
        
        portal(lastportal).desig="An opening between the roots. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).col=4
        portal(lastportal).ti_no=3003
        portal(lastportal).from=rnd_point(0,slot)
        portal(lastportal).from.m=slot
        portal(lastportal).dest=rnd_point(0,lastplanet)
        portal(lastportal).dest.m=lastplanet
        portal(lastportal).discovered=show_portals
#if __FB_DEBUG__
        if debug<>0 then portal(lastportal).discovered=1
#endif
        planets(slot).mon_template(0)=makemonster(4,slot)
        planets(slot).mon_noamin(0)=15
        planets(slot).mon_noamax(0)=25
        planets(lastplanet)=planets(slot)
        planets(lastplanet).depth=3
        planets(lastplanet).grav=0
        for b=0 to rnd_range(0,6)+disnbase(player.c)\4
            placeitem(make_item(96,planets(lastplanet).depth+disnbase(player.c)\5,planets(lastplanet).depth+disnbase(player.c)\6),rnd_range(0,60),rnd_range(0,20),lastplanet)
        next b
        
    endif
    if t=7 or t=8 then
        makemossworld(slot,5)
        planets(slot).atmos=4
        planets(slot).flags(25)=1
    endif
    
    if t=9 then 'Squid underwater cave world
        makeoceanworld(slot,3)
        lastplanet+=1
        makeroots(lastplanet)
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,lastplanet))=152 then planetmap(x,y,lastplanet)=-48
                if abs(planetmap(x,y,lastplanet))=3 then planetmap(x,y,lastplanet)=-1
                if abs(planetmap(x,y,lastplanet))=59 then planetmap(x,y,lastplanet)=-97
                if abs(planetmap(x,y,lastplanet))=146 then planetmap(x,y,lastplanet)=-165
            next
        next
        deletemonsters(slot)
        planets(slot).mon_template(0)=makemonster(92,slot)
        planets(slot).mon_noamin(0)=rnd_Range(2,12)
        planets(slot).mon_noamax(0)=planets(slot).mon_noamin(0)+6
        
        planets(slot).mon_template(1)=makemonster(93,slot)
        planets(slot).mon_noamin(1)=rnd_Range(2,12)
        planets(slot).mon_noamax(1)=planets(slot).mon_noamin(0)+6
        
        planets(slot).mon_template(2)=makemonster(95,slot)
        planets(slot).mon_noamin(2)=rnd_Range(2,12)
        planets(slot).mon_noamax(2)=planets(slot).mon_noamin(0)+6
        
        
        planets(slot).temp=30
        for b=1 to 5
            from=rnd_point(slot,1)
            from.m=slot
            dest=rnd_point(lastplanet,1)
            dest.m=lastplanet
            addportal(from,dest,1,asc("o"),"An underwater cave",9)
            addportal(Dest,from,1,asc("o"),"A tunnel to the surface",9)
        next
        planets(slot).flags(26)=1
        planets(slot).atmos=6
        planets(lastplanet).atmos=1
        planets(lastplanet).depth=5
        planets(lastplanet).mon_template(0)=makemonster(92,slot)
        planets(lastplanet).mon_noamin(0)=rnd_Range(2,12)
        planets(lastplanet).mon_noamax(0)=planets(slot).mon_noamin(0)+6
        
        planets(lastplanet).mon_template(1)=makemonster(93,slot)
        planets(lastplanet).mon_noamin(1)=rnd_Range(2,12)
        planets(lastplanet).mon_noamax(1)=planets(lastplanet).mon_noamin(1)+6
        
        planets(lastplanet).mon_template(2)=makemonster(94,slot)
        planets(lastplanet).mon_noamin(2)=rnd_Range(2,4)
        planets(lastplanet).mon_noamax(2)=planets(slot).mon_noamin(2)+2
        for b=0 to 20+rnd_range(0,6)+disnbase(player.c)\4
            gc=rnd_point(lastplanet,0)
            placeitem(make_item(96,planets(lastplanet).depth+disnbase(player.c)\5,planets(lastplanet).depth+disnbase(player.c)\6),gc.x,gc.y,lastplanet,0,0)
        next b
    endif
    if t=10 then 'Living geysers
        makegeyseroasis(slot)
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,slot))=28 then planetmap(x,y,slot)=-295
            next
        next
        
        planets(slot).mon_template(0)=makemonster(97,slot)
        planets(slot).mon_noamin(0)=rnd_Range(2,12)
        planets(slot).mon_noamax(0)=planets(slot).mon_noamin(0)+6
    endif
    
    if t=11 then
        deletemonsters(slot)
        planets(slot).flags(27)=1
        planets(slot).water=0
        planets(slot).atmos=1
        planets(slot).grav=3
        planets(slot).temp=4326+rnd_range(1,100)
        planets(slot).death=10+rnd_range(0,6)+rnd_range(0,6)
        for b=0 to rnd_range(1,8)+rnd_range(1,5)+rnd_range(1,3)
            placeitem(make_item(96,4,4),rnd_range(0,60),rnd_range(0,20),slot,0,0)
        next
        for b=0 to rnd_range(0,15)+15
            placeitem(make_item(96,9,7),rnd_range(0,60),rnd_range(0,20),slot,0,0)
        next
    endif
    return 0
    
end function


#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tPlanetmap -=-=-=-=-=-=-=-
	tModule.register("tPlanetmap",@tPlanetmap.init()) ',@tPlanetmap.load(),@tPlanetmap.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tPlanetmap -=-=-=-=-=-=-=-
#endif'test

