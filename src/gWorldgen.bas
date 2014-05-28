'tWorldgen.
'
'defines:
'findcompany=0, create_spacemap=0, make_spacemap=2
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
'     -=-=-=-=-=-=-=- TEST: tWorldgen -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tWorldgen -=-=-=-=-=-=-=-
Const show_eventp=0 		'Show eventplanets
Const _debug_bones=0
Const Show_all_specials=0	'38 'special planets already discovered
Const show_dangerous=0
Const _clearmap=0
Const show_space=0

declare function make_spacemap() as short

'declare function findcompany(c as short) as short
'declare function create_spacemap() as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tWorldgen -=-=-=-=-=-=-=-

namespace tWorldgen
function init(iAction as integer) as integer
	return 0
end function
end namespace'tWorldgen


#define cut2top


function findcompany(c as short) as short
    dim a as short
    for a=0 to 2
        if basis(a).company=c then return 1
    next
    return 0
end function

Dim Shared scount(10) As Short

function create_spacemap(iBg as short=0) as short
    dim as short a,f,b,c,d,e,astcou,gascou,x,y,i
    dim as byte makelog=0
    dim as _cords p1,p2,p3
    dim as _planet del 
    dim showclouds as byte
    if makelog=1 then
        f=freefile
        open "creation.log" for output as #f
    endif
    tScreen.set(1)
	if iBg<0 then iBg=-iBg else iBg=0
	if iBg=0 then tGraphics.Randombackground()
    
    set__color 1,1
    for a=0 to 3
        draw string(tScreen.x/2-(8*_fw1),tScreen.y/2-(2-a)*_fh1),space(27),,font1,custom,@_col
        draw string(tScreen.x/2-(8*_fw1),tScreen.y/2-(2-a)*_fh1+_fh1/2),space(27),,font1,custom,@_col
    next
    set__color 15,1
    draw string(tScreen.x/2-(6*_fw1),tScreen.y/2-_fh1),"Generating Sector:",,font1,custom,@_col
    set__color 5,1
    draw string(tScreen.x/2-(7*_fw1),tScreen.y/2),string(1,178),,font1,custom,@_col
    showclouds=0
    for a=0 to max_maps
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=0
            next
        next
        planets(a)=del
    next
    if makelog=1 then print #f,,"Generated sector"
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(2,178),,font1,custom,@_col
    
    for a=0 to 1024
        portal(a).oneway=0
    next
    if makelog=1 then print #f,,"Portals done" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(3,178),,font1,custom,@_col
    
    gen_shops
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(4,178),,font1,custom,@_col
    
    reroll_shops
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(5,178),,font1,custom,@_col
    if makelog=1 then print #f,,"Reroll shops done" &lastitem
    
    add_stars
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(6,178),,font1,custom,@_col
    if makelog=1 then print #f,,"add_stars done" &lastitem
    
    add_wormholes
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(7,178),,font1,custom,@_col
    if makelog=1 then print #f,,"add_wormholes done" &lastitem
    
    distribute_stars
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(8,178),,font1,custom,@_col
    if makelog=1 then print #f,,"distribute_stars done" &lastitem
    
    make_clouds()
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(9,178),,font1,custom,@_col
    if makelog=1 then print #f,"make_clouds done" &lastitem
    
    gen_traderoutes()
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(10,178),,font1,custom,@_col
    if makelog=1 then print #f,"gen_traderoutes done" &lastitem
    
    add_stations
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(11,178),,font1,custom,@_col
    
    gascou+=1
    for a=0 to laststar
        if spacemap(map(a).c.x,map(a).c.y)<>0 then gascou+=1
    next
    
    add_easy_planets(targetlist(firstwaypoint))
    if makelog=1 then print #f,"add_easy_planets done" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(12,178),,font1,custom,@_col
    
    add_special_planets
    if makelog=1 then print #f,"add_special_planets done" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(13,178),,font1,custom,@_col
    
    add_event_planets
    if makelog=1 then print #f,"addeventplanets done" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(14,178),,font1,custom,@_col
    
    fixstarmap()
    if makelog=1 then print #f,"Fixstarmap" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(15,178),,font1,custom,@_col
    
    add_caves
    if makelog=1 then print #f,"addcaves" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(16,178),,font1,custom,@_col
    
    add_piratebase
    if makelog=1 then print #f,"addpiratbase" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(17,178),,font1,custom,@_col
    
    add_drifters
    if makelog=1 then print #f,"adddrifters" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(18,178),,font1,custom,@_col
    
    load_bones
    if makelog=1 then print #f,"loadbones done" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(19,178),,font1,custom,@_col
    
    for a=0 to laststar
        if map(a).discovered=2 then map(a).discovered=show_specials
        if map(a).discovered=3 then map(a).discovered=show_eventp
        if map(a).discovered=4 then map(a).discovered=_debug_bones
        if map(a).discovered=5 then map(a).discovered=show_portals
        if map(a).discovered=6 then map(a).discovered=-1
        if abs(spacemap(map(a).c.x,map(a).c.y))>1 and map(a).spec<8 then
            map(a).spec=map(a).spec+abs(spacemap(map(a).c.x,map(a).c.y))/2
            if map(a).spec>7 then map(a).spec=7
            map(a).ti_no=map(a).spec+68
        endif
        scount(map(a).spec)+=1
        for b=1 to 9
            if map(a).planets(b)<-20000 then gascou+=1
            if map(a).planets(b)>-20000 and map(a).planets(b)<0  then astcou+=1
        next
    next
    if show_specials<>0 then
        for a=0 to laststar
            for b=1 to 9
                if map(a).planets(b)=show_specials then map(a).discovered=1
            next
        next
        if map(a).spec=10 then map(a).discovered=1
    endif
    if show_all_specials=1 then
        for a=0 to laststar
            for b=1 to 9
                for c=0 to lastspecial
                    if map(a).planets(b)=specialplanet(c) then map(a).discovered=1
                next            
            next
        next
    endif
    if show_dangerous=1 then
        for a=0 to laststar
            for b=1 to 9
                if map(a).planets(b)=specialplanet(2) then map(a).discovered=1
                if map(a).planets(b)=specialplanet(3) then map(a).discovered=1
                if map(a).planets(b)=specialplanet(4) then map(a).discovered=1
                if map(a).planets(b)=specialplanet(26) then map(a).discovered=1
                if map(a).planets(b)=specialplanet(27) then map(a).discovered=1
            next
        next
        
    endif
    if makelog=1 then print #f,"Making Civs"
    
    make_civilisation(0,specialplanet(7))
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(20,178),,font1,custom,@_col
    
    if makelog=1 then print #f,"makeciv1 done" &lastitem
    make_civilisation(1,specialplanet(46))
    
    if makelog=1 then print #f,"makeciv2 done" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(21,178),,font1,custom,@_col
    
    add_questguys
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(22,178),,font1,custom,@_col
    
    if findcompany(1)=0 then specialplanet(40)=32767
    if findcompany(2)=0 then specialplanet(41)=32767
    if findcompany(3)=0 then specialplanet(42)=32767
    if findcompany(4)=0 then specialplanet(43)=32767
    
    if makelog=1 then print #f,"delete company specials" &lastitem
    
    fleet(1).mem(1)=make_ship(33)
    fleet(1).ty=1
    fleet(1).c=basis(0).c
    fleet(2).mem(1)=make_ship(33)
    fleet(2).ty=1
    fleet(2).c=basis(1).c
    fleet(3).mem(1)=make_ship(33)
    fleet(3).ty=1
    fleet(3).c=basis(2).c
    fleet(5).mem(1)=make_ship(33)
    fleet(5).ty=1
    fleet(5).c=basis(4).c
    
    lastfleet=12
    for a=6 to lastfleet
        fleet(a)=makemerchantfleet
        fleet(a).t=rnd_range(firstwaypoint,lastwaypoint)
        fleet(a).c=targetlist(fleet(a).t)
        e=999
        for b=1 to 15
            if fleet(a).mem(b).movepoints(0)<e and fleet(a).mem(b).movepoints(0)>0 then e=fleet(a).mem(b).movepoints(0)
        next
        fleet(a).mem(0).engine=e
        if fleet(a).mem(0).engine<1 then fleet(a).mem(0).engine=1
        
    next
    
    if _clearmap=1 then
        for a=0 to laststar+wormhole+1
            if map(a).discovered>0 then 
                map(a).discovered=0
                for b=1 to 9
                    if map(a).planets(b)>0 then planets(map(a).planets(b)).visited=0
                next
'            else
'                print "system "&a &" at "& map(a).c.x &":"& map (a).c.y
'                map(a).discovered=1
'                sleep
            endif
        next
    endif
    if showclouds=1 then
        for x=0 to sm_x
            for y=0 to sm_y
                spacemap(x,y)=abs(spacemap(x,y))
            next
        next
        for a=0 to laststar+wormhole+1
            player.discovered(map(a).spec)+=1
            map(a).desig=spectralshrt(map(a).spec)&player.discovered(map(a).spec)&"-"&int(disnbase(map(a).c))&"("&map(a).c.x &":"& map(a).c.y &")"
        
        next
    endif
    
    gen_bountyquests()
    
    if makelog=1 then 
        print #f,"Clear stuff" &lastitem
        close #f
    endif
    
    if show_space=1 then
        for a=0 to laststar
            map(a).discovered=1
        next
        for a=0 to lastdrifting
            drifting(a).p=1
        next
        for x=0 to sm_x
            for y=0 to sm_y
                if spacemap(x,y)=0 then spacemap(x,y)=1
                spacemap(x,y)=abs(spacemap(x,y))
            next
        next
    endif
    set__color( 11,0)
    print
    print "Universe created with "&laststar &" stars and "&lastplanet-lastdrifting &" planets."
    set__color( 15,0)
    print "Star distribution:"
    for a=1 to 10
        print spectralname(a);":";scount(a)
    next
    print "Asteroid belts:";astcou
    print "Gas giants:";gascou
    sleep 1250
#if __FB_DEBUG__
    dim key as string
    key=uConsole.keyinput()
#endif
    return 0
end function


function make_spacemap() as short
    dim as short a,f,b,c,d,e,astcou,gascou,x,y,i
    dim as byte makelog=0
    dim as _cords p1,p2,p3
    dim as _planet del 
    dim showclouds as byte
    if makelog=1 then
        f=freefile
        open "creation.log" for output as #f
    endif
    tScreen.set(1)
    
    set__color 1,1
    for a=0 to 3
        draw string(tScreen.x/2-(8*_fw1),tScreen.y/2-(2-a)*_fh1),space(27),,font1,custom,@_col
        draw string(tScreen.x/2-(8*_fw1),tScreen.y/2-(2-a)*_fh1+_fh1/2),space(27),,font1,custom,@_col
    next
    set__color 15,1
    draw string(tScreen.x/2-(6*_fw1),tScreen.y/2-_fh1),"Generating Sector:",,font1,custom,@_col
    set__color 5,1
    draw string(tScreen.x/2-(7*_fw1),tScreen.y/2),string(1,178),,font1,custom,@_col
    showclouds=0
    for a=0 to max_maps
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=0
            next
        next
        planets(a)=del
    next
    if makelog=1 then print #f,,"Generated sector"
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(2,178),,font1,custom,@_col
    
    for a=0 to 1024
        portal(a).oneway=0
    next
    if makelog=1 then print #f,,"Portals done" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(3,178),,font1,custom,@_col
    
    gen_shops
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(4,178),,font1,custom,@_col
    
    reroll_shops
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(5,178),,font1,custom,@_col
    if makelog=1 then print #f,,"Reroll shops done" &lastitem
    
    add_stars
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(6,178),,font1,custom,@_col
    if makelog=1 then print #f,,"add_stars done" &lastitem
    
    add_wormholes
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(7,178),,font1,custom,@_col
    if makelog=1 then print #f,,"add_wormholes done" &lastitem
    
    distribute_stars
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(8,178),,font1,custom,@_col
    if makelog=1 then print #f,,"distribute_stars done" &lastitem
    
    make_clouds()
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(9,178),,font1,custom,@_col
    if makelog=1 then print #f,"make_clouds done" &lastitem
    
    gen_traderoutes()
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(10,178),,font1,custom,@_col
    if makelog=1 then print #f,"gen_traderoutes done" &lastitem
    
    add_stations
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(11,178),,font1,custom,@_col
    
    gascou+=1
    for a=0 to laststar
        if spacemap(map(a).c.x,map(a).c.y)<>0 then gascou+=1
    next
    
    add_easy_planets(targetlist(firstwaypoint))
    if makelog=1 then print #f,"add_easy_planets done" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(12,178),,font1,custom,@_col
    
    add_special_planets
    if makelog=1 then print #f,"add_special_planets done" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(13,178),,font1,custom,@_col
    
    add_event_planets
    if makelog=1 then print #f,"addeventplanets done" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(14,178),,font1,custom,@_col
    
    fixstarmap()
    if makelog=1 then print #f,"Fixstarmap" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(15,178),,font1,custom,@_col
    
    add_caves
    if makelog=1 then print #f,"addcaves" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(16,178),,font1,custom,@_col
    
    add_piratebase
    if makelog=1 then print #f,"addpiratbase" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(17,178),,font1,custom,@_col
    
    add_drifters
    if makelog=1 then print #f,"adddrifters" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(18,178),,font1,custom,@_col
    
    load_bones
    if makelog=1 then print #f,"loadbones done" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(19,178),,font1,custom,@_col
    
    for a=0 to laststar
        if map(a).discovered=2 then map(a).discovered=show_specials
        if map(a).discovered=3 then map(a).discovered=show_eventp
        if map(a).discovered=4 then map(a).discovered=_debug_bones
        if map(a).discovered=5 then map(a).discovered=show_portals
        if map(a).discovered=6 then map(a).discovered=-1
        if abs(spacemap(map(a).c.x,map(a).c.y))>1 and map(a).spec<8 then
            map(a).spec=map(a).spec+abs(spacemap(map(a).c.x,map(a).c.y))/2
            if map(a).spec>7 then map(a).spec=7
            map(a).ti_no=map(a).spec+68
        endif
        scount(map(a).spec)+=1
        for b=1 to 9
            if map(a).planets(b)<-20000 then gascou+=1
            if map(a).planets(b)>-20000 and map(a).planets(b)<0  then astcou+=1
        next
    next
    if show_specials<>0 then
        for a=0 to laststar
            for b=1 to 9
                if map(a).planets(b)=show_specials then map(a).discovered=1
            next
        next
        if map(a).spec=10 then map(a).discovered=1
    endif
    if show_all_specials=1 then
        for a=0 to laststar
            for b=1 to 9
                for c=0 to lastspecial
                    if map(a).planets(b)=specialplanet(c) then map(a).discovered=1
                next            
            next
        next
    endif
    if show_dangerous=1 then
        for a=0 to laststar
            for b=1 to 9
                if map(a).planets(b)=specialplanet(2) then map(a).discovered=1
                if map(a).planets(b)=specialplanet(3) then map(a).discovered=1
                if map(a).planets(b)=specialplanet(4) then map(a).discovered=1
                if map(a).planets(b)=specialplanet(26) then map(a).discovered=1
                if map(a).planets(b)=specialplanet(27) then map(a).discovered=1
            next
        next
        
    endif
    if makelog=1 then print #f,"Making Civs"
    
    make_civilisation(0,specialplanet(7))
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(20,178),,font1,custom,@_col
    
    if makelog=1 then print #f,"makeciv1 done" &lastitem
    make_civilisation(1,specialplanet(46))
    
    if makelog=1 then print #f,"makeciv2 done" &lastitem
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(21,178),,font1,custom,@_col
    
    add_questguys
    draw string(tScreen.x/2-7*_fw1,tScreen.y/2),string(22,178),,font1,custom,@_col
    
    if findcompany(1)=0 then specialplanet(40)=32767
    if findcompany(2)=0 then specialplanet(41)=32767
    if findcompany(3)=0 then specialplanet(42)=32767
    if findcompany(4)=0 then specialplanet(43)=32767
    
    if makelog=1 then print #f,"delete company specials" &lastitem
    
    fleet(1).mem(1)=make_ship(33)
    fleet(1).ty=1
    fleet(1).c=basis(0).c
    fleet(2).mem(1)=make_ship(33)
    fleet(2).ty=1
    fleet(2).c=basis(1).c
    fleet(3).mem(1)=make_ship(33)
    fleet(3).ty=1
    fleet(3).c=basis(2).c
    fleet(5).mem(1)=make_ship(33)
    fleet(5).ty=1
    fleet(5).c=basis(4).c
    
    lastfleet=12
    for a=6 to lastfleet
        fleet(a)=makemerchantfleet
        fleet(a).t=rnd_range(firstwaypoint,lastwaypoint)
        fleet(a).c=targetlist(fleet(a).t)
        e=999
        for b=1 to 15
            if fleet(a).mem(b).movepoints(0)<e and fleet(a).mem(b).movepoints(0)>0 then e=fleet(a).mem(b).movepoints(0)
        next
        fleet(a).mem(0).engine=e
        if fleet(a).mem(0).engine<1 then fleet(a).mem(0).engine=1
        
    next
    
    if _clearmap=1 then
        for a=0 to laststar+wormhole+1
            if map(a).discovered>0 then 
                map(a).discovered=0
                for b=1 to 9
                    if map(a).planets(b)>0 then planets(map(a).planets(b)).visited=0
                next
'            else
'                print "system "&a &" at "& map(a).c.x &":"& map (a).c.y
'                map(a).discovered=1
'                sleep
            endif
        next
    endif
    if showclouds=1 then
        for x=0 to sm_x
            for y=0 to sm_y
                spacemap(x,y)=abs(spacemap(x,y))
            next
        next
        for a=0 to laststar+wormhole+1
            player.discovered(map(a).spec)+=1
            map(a).desig=spectralshrt(map(a).spec)&player.discovered(map(a).spec)&"-"&int(disnbase(map(a).c))&"("&map(a).c.x &":"& map(a).c.y &")"
        
        next
    endif
    
    gen_bountyquests()
    
    if makelog=1 then 
        print #f,"Clear stuff" &lastitem
        close #f
    endif
    
    if show_space=1 then
        for a=0 to laststar
            map(a).discovered=1
        next
        for a=0 to lastdrifting
            drifting(a).p=1
        next
        for x=0 to sm_x
            for y=0 to sm_y
                if spacemap(x,y)=0 then spacemap(x,y)=1
                spacemap(x,y)=abs(spacemap(x,y))
            next
        next
    endif
    set__color( 11,0)
    print
    print "Universe created with "&laststar &" stars and "&lastplanet-lastdrifting &" planets."
    set__color( 15,0)
    print "Star distribution:"
    for a=1 to 10
        print spectralname(a);":";scount(a)
    next
    print "Asteroid belts:";astcou
    print "Gas giants:";gascou
    sleep 1250
#if __FB_DEBUG__
    dim key as string
    key=uConsole.keyinput()
#endif
    return 0
end function
#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tWorldgen -=-=-=-=-=-=-=-
	tModule.register("tWorldgen",@tWorldgen.init()) ',@tWorldgen.load(),@tWorldgen.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tWorldgen -=-=-=-=-=-=-=-
#endif'test
