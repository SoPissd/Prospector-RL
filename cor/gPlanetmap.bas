'tPlanetmap.
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
'     -=-=-=-=-=-=-=- TEST: tPlanetmap -=-=-=-=-=-=-=-
#undef intest
#define test
#endif'test

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Const show_all=0
Const show_portals=0 		'Shows .... portals!

Dim Shared lastapwp As Short
Dim Shared planetmap(60,20,max_maps) As Short

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tPlanetmap -=-=-=-=-=-=-=-
declare function dtile(x as short,y as short, tiles as _tile,visible as byte) as short
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
declare function get_nonspecialplanet(disc as short=0) as short
declare function makemudsshop(slot as short, x1 as short, y1 as short)  as short
declare function floodfill3(x as short,y as short,map() as short) as short
declare function checkdoor(x as short,y as short, map() as short) as short
declare function togglingfilter(slot as short, high as short=1, low as short=2) as short     

declare function calcosx(x as short,wrap as byte) as short 'Caculates Ofset X for windows less than 60 tiles wide
declare function planet_cursor(p as _cords,mapslot as short,byref osx as short,shteam as byte) as string

'declare function get_planet_cords(byref p as _cords,mapslot as short,shteam as byte=0) as string
'declare function isbuilding(x as short,y as short,map as short) as short 
'declare function get_colony_building(map as short) as _cords
'declare function closest_building(p as _cords,map as short) as _Cords
'declare function makecomplex2(slot as short,gc1 as _cords, gc2 as _cords, roundedcorners1 as short,roundedcorners2 as short,nocol1 as short,nocol2 as short,doorchance as short,loopchance as short,loopdoor as short,adddoor as short,addloop as short,nosmallrooms as short,culdesacruns as short, t as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tPlanetmap -=-=-=-=-=-=-=-

namespace tPlanetmap
function init(iAction as integer) as integer
	pRnd_point = @rnd_point
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
'#if __FB_DEBUG__
'                Draw String(x*_tix,item(i).w.y*_tiy),cords(item(i).vt) &":"&item(i).w.m,,font1,custom,@_tcol'REMOVE
'#endif
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


function dtile(x as short,y as short, tiles as _tile,visible as byte) as short
    dim as short col,bgcol,slot,tino
    slot=player.map
    col=tiles.col
    bgcol=tiles.bgcol
    tino=tiles.ti_no
    if tino>1000 then
        tino=2500+(tino-2500)+planets(slot).wallset*10
    endif
    'if tiles.walktru=5 then bgcol=1
    if tiles.col<0 and tiles.bgcol<0 then
        col=col*-1
        bgcol=bgcol*-1
        col=rnd_range(col,bgcol)
        bgcol=0
    endif
    if configflag(con_tiles)=0 then
        if visible=1 then
            put (x*_tix,y*_tiy),gtiles(gt_no(tino)),pset
        else
            put (x*_tix,y*_tiy),gtiles(gt_no(tino)),alpha,196
        endif
    else
        if configflag(con_showvis)=0 and visible>0 and bgcol=0 then
            bgcol=234
        endif
        set__color( col,bgcol,visible)
        draw string (x*_fw1,y*_fh1),chr(tiles.tile),,Font1,custom,@_col
    endif
    set__color( 11,0)
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
    
    key=uConsole.keyinput()
    
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
            if target.x>=0 and target.y>=0 and target.x<=60 and target.y<=20 then 
				dtile(target.x-osx,target.y,tiles(planetmap(target.x,target.y,map)),1)
            EndIf
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
    target=movepoint(target,uConsole.getdirection(key),eo,border)
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

'

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

function planet_cursor(p as _cords,mapslot as short,byref osx as short,shteam as byte) as string
    dim key as string
    tScreen.set(0)
    cls
    osx=calcosx(p.x,planets(mapslot).depth)
    display_planetmap(mapslot,osx,4)
    if shteam=0 then
        draw_border(0)
    else
    	assert(pDisplayawayteam<>null)
		pDisplayawayteam(,osx)
    endif
    if planetmap(p.x,p.y,mapslot)>0 then
        rlprint cords(p)&": "&tiles(planetmap(p.x,p.y,mapslot)).desc
    else
        rlprint cords(p)&": "&"Unknown"
    endif
    tScreen.update()
    return key
end function


function get_planet_cords(byref p as _cords,mapslot as short,shteam as byte=0) as string
    dim osx as short
    dim as string key
    display_planetmap(mapslot,osx,1)
    assert(pDisplayShip<>null)
    pDisplayShip()

    do
        key=planet_cursor(p,mapslot,osx,shteam)
        key=cursor(p,mapslot,osx)
    loop until key=key__esc or key=key__enter

    return key
end function

'

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
	dim as short x,y
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


function flood_fill(x as short,y as short,map() as short, flag as short=0) as short
  if flag=0 then 
      if x>0 and y>0 and x<60 and y<20 then
          if (map(x,y)=0 or map(x,y)=2 or map(x,y)=3 or map(x,y)=4) and map(x,y)<10 then
              map(x,y)=map(x,y)+11
          else
              return 0
          endif
          Flood_Fill(x+1,y,map())
          Flood_Fill(x-1,y,map())
          Flood_Fill(x,y+1,map())
          Flood_Fill(x,y-1,map())
      endif
  endif
  if flag=1 then
      if x>=0 and y>=0 and x<=sm_x and y<=sm_y then
          if map(x,y)=0 then
              map(x,y)=255
          else
              return 0
          endif
          Flood_Fill(x+1,y,map(),1)
          Flood_Fill(x-1,y,map(),1)
          Flood_Fill(x,y+1,map(),1)
          Flood_Fill(x,y-1,map(),1)
      endif
  endif
  if flag=2 then
      if x>=0 and y>=0 and x<=60 and y<=20 then
          if map(x,y)=0 then
              map(x,y)=255
          else
              return 0
          endif
          Flood_Fill(x+1,y,map(),2)
          Flood_Fill(x-1,y,map(),2)
          Flood_Fill(x,y+1,map(),2)
          Flood_Fill(x,y-1,map(),2)
      endif
  endif
  if flag=3 then
      if x>=0 and y>=0 and x<=60 and y<=20 then
          if map(x,y)=0 then
              map(x,y)=255
          else
              return 0
          endif
          Flood_Fill(x+1,y,map(),3)
          Flood_Fill(x-1,y,map(),3)
          Flood_Fill(x,y+1,map(),3)
          Flood_Fill(x,y-1,map(),3)
          Flood_Fill(x+1,y+1,map(),3)
          Flood_Fill(x-1,y-1,map(),3)
          Flood_Fill(x-1,y+1,map(),3)
          Flood_Fill(x+1,y-1,map(),3)
      endif
  endif
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

	assert(pMakemonster<>null)

    if show_all=1 then rlprint "Made complex at "&slot
    if planets(slot).depth=0 then planets(slot).depth=1
    planets(slot).darkness=5
    planets(slot).vault(0)=r(0)
    planets(slot).teleport=1
    
    planets(slot).temp=25
    planets(slot).atmos=3    
    planets(slot).grav=.8
    planets(slot).mon_template(0)=pMakemonster(9,slot)
    planets(slot).mon_noamin(0)=8
    planets(slot).mon_noamax(0)=16+planets(slot).depth
    planets(slot).mon_template(1)=pMakemonster(90,slot)
    planets(slot).mon_noamin(1)=16
    planets(slot).mon_noamax(1)=26+planets(slot).depth
    if rnd_range(1,100)<15+planets(slot).depth*3 then
        planets(slot).mon_template(2)=pMakemonster(56,slot)
        planets(slot).mon_noamin(2)=1
        planets(slot).mon_noamax(2)=2+planets(slot).depth
    endif
    if rnd_range(1,100)<25+planets(slot).depth*5 then
        planets(slot).mon_template(3)=pMakemonster(19,slot)
        planets(slot).mon_noamin(3)=0
        planets(slot).mon_noamax(3)=1+planets(slot).depth
    endif
    if rnd_range(1,100)<15+planets(slot).depth*5 then
        planets(slot).mon_template(4)=pMakemonster(91,slot)
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
    
    Assert(pDigger<>null)

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
                    b=pDigger(p1,map2(),b)
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
    
    assert(pMakeitem<>null)
    
    for a=1 to rnd_range(1,planets(slot).depth+1)-rnd_range(1,planets(slot).depth-1)
        do
            a=rnd_range(0,last)
        loop until r(a).wd(5)=0 and a<>b
        x=r(a).x+r(a).w/2
        y=r(a).y+r(a).h/2
        planetmap(x,y,slot)=-84
        placeitem(pMakeitem(99),x,y,slot)
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


function checkvalid(x as short,y as short, map() as short) as short
    if x<=0 then return 0
    if y<=0 then return 0
    if x>=60 then return 0
    if y>=20 then return 0
    if map(x-1,y)=1 and map(x+1,y)=1 and map(x,y-1)=1 and map(x,y+1)=1 then
            return -1
        endif
        return 0
end function


function floodfill3(x as short,y as short,map() as short) as short
    if x>=0 and y>=0 and x<=60 and y<=20 then
		if map(x,y)=0 or map(x,y)=2 or map(x,y)=-2 then
			if map(x,y)=0 then map(x,y)=-1
			if map(x,y)=2 then map(x,y)=-2
		else
			return 0
		endif
		FloodFill3(x+1,y,map())
		FloodFill3(x-1,y,map())
		FloodFill3(x,y+1,map())
		FloodFill3(x,y-1,map())
    endif
    return 0
end function


function checkdoor(x as short,y as short, map() as short) as short
    if map(x-1,y)=1 and map(x+1,y)=1 and map(x,y)=1 then
        if map(x,y+1)=-1 and map(x,y-1)=0 then return -1
        if map(x,y-1)=-1 and map(x,y+1)=0 then return -1
    endif
    
    if map(x,y-1)=1 and map(x,y+1)=1 and map(x,y)=1 then
        if map(x+1,y)=-1 and map(x-1,y)=0 then return -1
        if map(x-1,y)=-1 and map(x+1,y)=0 then return -1
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
    
    assert(pMakemonster<>null)
    planets(m).depth=10
    planets(m).mon_template(0)=pMakemonster(19,m)
    planets(m).Mon_noamax(0)=28
    planets(m).mon_noamin(0)=22
    planets(m).mon_template(1)=pMakemonster(56,m)
    planets(m).Mon_noamax(1)=12
    planets(m).mon_noamin(1)=10
    planets(m).mon_template(2)=pMakemonster(55,m)
    planets(m).Mon_noamax(2)=12
    planets(m).mon_noamin(2)=10
    planets(m).mon_template(3)=pMakemonster(91,m)
    planets(m).Mon_noamax(3)=12
    planets(m).mon_noamin(3)=10
    planets(m).grav=0.5
    planets(m).atmos=3
    return 0
end function


function makemudsshop(slot as short, x1 as short, y1 as short)  as short
    dim as short x,y
    dim as _cords p3
    if x1<3 then x1=3
    if x1>57 then x1=57
    if y1<3 then y1=3
    if y1>17 then y1=17
    planetmap(x1,y1,slot)=-262
    planetmap(x1-1,y1,slot)=-32
    planetmap(x1+1,y1,slot)=-32
    planetmap(x1,y1+1,slot)=-31
    planetmap(x1,y1-1,slot)=-31
    planetmap(x1-2,y1,slot)=-68
    planetmap(x1+2,y1,slot)=-68
    planetmap(x1,y1+2,slot)=-68
    planetmap(x1,y1-2,slot)=-68
    
    p3.x=x1+2
    p3.y=y1+2
    if p3.x+3<60 and p3.y+3<20 and rnd_range(1,100)<10 then 
        for x=p3.x to p3.x+3
            for y=p3.y to p3.y+3
                planetmap(x,y,slot)=68
            next
        next
        planetmap(p3.x+1,p3.y,slot)=70
        planetmap(p3.x+2,p3.y,slot)=71
    
    endif
    return 0
end function


function togglingfilter(slot as short, high as short=1, low as short=2) as short     
dim as short x,y,ti1,ti2
dim as short a
dim as _cords p1,p2
dim workmap(60,20) as short
dim workmap2(60,20) as short

for x=0 to 60
    for y=0 to 20
        if abs(planetmap(x,y,slot))=high then workmap(x,y)=1
        if abs(planetmap(x,y,slot))=low then workmap(x,y)=1
    next
next

for x=1 to 59
    for y=1 to 19
        if workmap(x,y)>0 then
        p1.x=x
        p1.y=y
        for a=1 to 9
            if a<>5 then
                p2=movepoint(p1,a)
                if workmap(p2.x,p2.y)>0 then workmap2(x,y)=workmap2(x,y)+1
            endif
        next
        endif
    next
next

for x=59 to 1 step -1
    for y=1 to 19
        if workmap(x,y)<>0 then
            if workmap2(x,y)<4 then planetmap(x,y,slot)=-rnd_range(3,6)
            if workmap2(x,y)>3 then planetmap(x,y,slot)=-high
            if workmap2(x,y)>7 then planetmap(x,y,slot)=-low
            
        endif
    next
next
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

