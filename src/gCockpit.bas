'tCockpit.
'
'defines:
'show_dotmap=2, show_minimap=1, show_wormholemap=1, messages=3
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
'     -=-=-=-=-=-=-=- TEST: tCockpit -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tCockpit -=-=-=-=-=-=-=-

declare function show_dotmap(x1 as short, y1 as short) as short
declare function show_minimap(xx as short,yy as short) as short
declare function show_wormholemap(j as short=0) as short
'declare function messages() as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tCockpit -=-=-=-=-=-=-=-

namespace tCockpit
function init(iAction as integer) as integer
	return 0
end function
end namespace'tCockpit


#define cut2top


function show_dotmap(x1 as short, y1 as short) as short
    dim as short a,x,y,px,py
    x1=x1*2
    y1=y1*2
    px=tScreen.x-2-sm_x*2
    py=11*_fh1+_fh2+2
    set__color( 1,0)
    
    for x=-1 to sm_x*2+1
        for y=-1 to sm_y*2+1
            set__color( 0,0)
            pset(x+px,y+py)
        next
    next
    for x=0 to sm_x
        for y=0 to sm_y
            if spacemap(x,y)=0 then set__color( 0,0)
            if spacemap(x,y)=1 then set__color( 1,0)
            if spacemap(x,y)>1 then set__color( 9,0)
            pset((x*2)+px,(y*2)+py)
            'pset((x*2)+px,(y*2)+py+1)
            'pset((x*2)+px+1,(y*2)+py)
            pset((x*2)+px+1,(y*2)+py+1)
        next
    next
    for a=0 to laststar
        if map(a).discovered>0 then
            set__color( spectraltype(map(a).spec),0)
            x=map(a).c.x
            y=map(a).c.y
            pset((x*2)+px,(y*2)+py)
            pset((x*2)+px,(y*2)+py+1)
            pset((x*2)+px+1,(y*2)+py)
            pset((x*2)+px+1,(y*2)+py+1)
        endif
    next
    for x=x1-10 to x1+10
        for y=y1-10 to y1+10
            if x=x1-10 or x=x1+10 or y=y1-10 or y=y1+10 then
                set__color( 15,0)
                pset(x+px,y+py)
            endif
        next
    next
    set__color( 224,0)
            
    for x=-1 to sm_x*2+1
        for y=-1 to sm_y*2+1
            if y=-1 or x=-1 or y=sm_y*2+1 or x=sm_x*2+1 then pset(x+px,y+py)
        next
    next
    if lastapwp>0 then
        for a=1 to lastapwp
            if spacemap(apwaypoints(a).x,apwaypoints(a).y)>1 then
                set__color( 12,0)
            else
                set__color( 10,0)
            endif
            pset(apwaypoints(a).x*2+px,apwaypoints(a).y*2+py)
            pset(apwaypoints(a).x*2+1+px,apwaypoints(a).y*2+py)
            pset(apwaypoints(a).x*2+px,apwaypoints(a).y*2+1+py)
            pset(apwaypoints(a).x*2+1+px,apwaypoints(a).y*2+1+py)
        next
    endif
        
    return 0
end function

function show_minimap(xx as short,yy as short) as short
    DimDebug(0)
    dim as short a,x1,y1,x,y,osx,osy,n,bg,wid,px,py,f
    
    x1=xx
    y1=yy
    wid=fix(20*_fw2/_fw1)
    wid=fix(wid/2)
    if configflag(con_tiles)=0 then
        px=_mwx*_fw1+_fw1+8
    else
        px=_mwx*_fw1+_fw1+_fw2
    endif
    osx=wid-xx
    osy=5-yy+py
    for x=xx-wid to xx+wid
        for y=yy-5 to yy+5
            if x>=0 and y>=0 and x<=sm_x and y<=sm_y then
                if spacemap(x,y)>=2 and  spacemap(x,y)<=5 then 
                    if configflag(con_tiles)=0 then
                        put ((x+osx)*_fw1+px,(y+osy)*_fh1),gtiles(abs(spacemap(x,y))+49),trans
                    else                        
                        set__color( rnd_range(48,59),1)
                        'if spacemap(x,y)=2 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(48,59),1
                        'if spacemap(x,y)=3 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(96,107),1
                        'if spacemap(x,y)=4 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(144,155),1
                        'if spacemap(x,y)=5 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(192,203),1
                        draw string ((x+osx)*_fw1+px,(y+osy)*_fh1),chr(176),,Font1,custom,@_col
                    endif
                endif
                if spacemap(x,y)>5 then
                
                endif
            endif
            'locate y+osy,x+osx
            'if spacemap(x,y)>0 then print "#"
        next
    next
    for a=0 to laststar+wormhole
        if map(a).c.x>=x1-wid and map(a).c.x<=x1+wid and map(a).c.y>=y1-5 and map(a).c.y<=y1+5 then
            if map(a).discovered>0 then
                x=map(a).c.x
                y=map(a).c.y
                if xx<>x or yy<>y then 
                    bg=0
                else
                    bg=5
                endif

                if configflag(con_tiles)=0 then
                    put ((x+osx)*_tix+px,(y+osy)*_tiy),gtiles(map(a).ti_no),trans
                    if bg=5 then put ((x+osx)*_tix+px,(y+osy)*_tiy),gtiles(85),trans
    
                else        
                    set__color( spectraltype(map(a).spec),bg)
                    if map(a).spec<8 then draw string ((x+osx)*_fw1+px,(y+osy)*_fh1),"*",,Font1,custom,@_col
                    if map(a).spec=8 then     
                        set__color( 7,bg)
                        draw string ((x+osx)*_fw1+px,(y+osy)*_fh1),"o",,Font1,custom,@_col
                    endif
                        
                    if map(a).spec=9 then 
                        n=distance(map(a).c,map(map(a).planets(1)).c)/5
                        if n<1 then n=1
                        if n>6 then n=6
                        set__color( 179+n,bg)
                        draw string ((map(a).c.x+osx)*_fw1+px,(map(a).c.y+osy)*_fh1),"o",,Font1,custom,@_col
                    endif
                endif
            endif
        endif
    
    next
    
    for a=0 to lastdrifting
        x=drifting(a).x
        y=drifting(a).y
        
        if planets(drifting(a).m).flags(0)=0 then
            set__color( 7,0)
            DbgPrint(drifting(a).g_tile.x &":"& drifting(a).g_tile.y &":"& drifting(a).y)
            'drifting(a).g_tile.y=1
            'drifting(a).p=1
            if drifting(a).g_tile.x=0 or drifting(a).g_tile.x=5 or drifting(a).g_tile.x>9 then drifting(a).g_tile.x=rnd_range(1,4)
            if drifting(a).s=20 then set__color( 15,0)
            if drifting(a).p>0 then
                if x>=x1-wid and x<=x1+wid and y>=y1-5 and y<=y1+5 then 
                    x=x+osx
                    y=y+osy
                    if configflag(con_tiles)=0 then
                        put (x*_tix+px,y*_tiy),stiles(drifting(a).g_tile.x,drifting(a).g_tile.y),trans
                    else
                        draw string (x*_fw1+px,y*_fh1+py),"s",,Font1,custom,@_col
                    endif                
                endif
            endif
        endif
    next
    
    for a=0 to 2
        if basis(a).discovered>0 then
            if basis(a).c.x>=x1-wid and basis(a).c.x<=x1+wid and basis(a).c.y>=y1-5 and basis(a).c.y<=y1+5 then
                x=basis(a).c.x+osx
                y=basis(a).c.y+osy
                set__color( 15,0)
                if configflag(con_tiles)=1 then
                    draw string (x*_fw1+px,y*_fh1),"S",,Font1,custom,@_col
                else
                    put (x*_tix+px,y*_tiy),gtiles(44),trans
                endif
            endif
        endif
    next
    if player.c.x>=x1-wid and player.c.x<=x1+wid and player.c.y>=y1-5 and player.c.y<=y1+5 then        
        x=player.c.x
        y=player.c.y
        if configflag(con_tiles)=0 then
            put (x*_tix+px,y*_tiy),stiles(player.di,player.ti_no),trans
        else
            set__color( _shipcolor,0)
            draw string (x*_fw1+px,y*_fh1),"@",,Font1,custom,@_col
        endif
    endif
    set__color( 11,0)
    return 0
end function

function show_wormholemap(j as short=0) as short
    DimDebugL(0)
    dim as short px,py,i
    
    px=tScreen.x-2-sm_x*2
    py=11*_fh1+_fh2+2
    
    if j>0 then
#if __FB_DEBUG__
        if debug=1 then map(j).planets(2)=1
#endif
        if map(j).planets(2)=1 then
            set__color( 1,0)
            line(map(j).c.x*2+px,map(j).c.y*2+py)-(map(map(j).planets(1)).c.x*2+px,map(map(j).planets(1)).c.y*2+py),15
        endif
        return 0
    endif
    
    for i=laststar+1 to laststar+wormhole
#if __FB_DEBUG__
        if debug=1 then map(i).planets(2)=1
#endif
        if map(i).planets(2)=1 then
            set__color( 1,0)
            line(map(i).c.x+px,map(i).c.y+py)-(map(map(i).planets(1)).c.x+px,map(map(i).planets(1)).c.y+py),15
        endif
    next
    return 0
end function

'    cls
'    displayship
'    for x=0 to sm_x
'        for y=0 to sm_y
'            if spacemap(x,y)>0 then
'                set__color( 1,0
'                locate map(i).c.y+1,map(i).c.x+1
'                print "."
'            endif
'        next
'    next
'    set__color( 15,0
'    
'    for i=laststar+1 to laststar+wormhole
'        if map(i).planets(2)=1 then
'            l=line_in_points(map(i).c,map(map(i).planets(1)).c,p())
'            n=distance(map(i).c,map(map(i).planets(1)).c)/5
'            if n<1 then n=1
'            if n>6 then n=6
'            set__color( 179+n,0
'            for i2=1 to l-1
'                locate p(i2).y+1,p(i2).x+1
'                print "."
'            next
'        endif
'    next
'    for i=laststar+1 to laststar+wormhole
'        if map(i).discovered<>0 then
'            n=distance(map(i).c,map(map(i).planets(1)).c)/5
'            if n<1 then n=1
'            if n>6 then n=6
'            set__color( 179+n,0
'            locate map(i).c.y+1,map(i).c.x+1
'            print "o"
'            locate map(i).c.y+1,map(i).c.x+2
'        endif
'    next
'    for i=1 to laststar
'        if map(i).discovered<>0 then
'            set__color( spectraltype(map(i).spec),0
'            locate map(i).c.y+1,map(i).c.x+1
'            print "*"
'        endif
'    next
'    rlprint "Displaying wormhole map"
'    no_key=keyin


'function messages() as short
'    dim as short a,ll
'    screenshot(1)
'    ll=_lines*_fh1/_fh2
'    set__color( 15,0)
'    cls
'    for a=1 to ll
'        locate a,1
'        set__color( dtextcol(a),0)
'        draw string (0,a*_fh2), displaytext(a),,font2,custom,@_col
'    next
'    no_key=keyin(,1)
'    cls
'    screenshot(2)
'    return 0
'end function


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tCockpit -=-=-=-=-=-=-=-
	tModule.register("tCockpit",@tCockpit.init()) ',@tCockpit.load(),@tCockpit.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tCockpit -=-=-=-=-=-=-=-
#endif'test
