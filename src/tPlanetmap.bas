'tPlanetmap

Dim Shared planetmap(60,20,max_maps) As Short


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


function chksrd(p as _cords, slot as short) as short'Returns the sum of tile values around a point, -1 if at a border
    dim r as short
    dim as short x,y
    for x=p.x-1 to p.x+1
        for y=p.y-1 to p.y-1
            if x<0 or y<0 or x>60 or y>20 then 
                return -1
            else
                r=r+abs(planetmap(x,y,slot))
            endif
        next
    next
    return r
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
    screenset 0,1
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
    flip
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

