'tMakecastle.
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
'     -=-=-=-=-=-=-=- TEST: tMakecastle -=-=-=-=-=-=-=-
#undef intest
#define test
#endif'test

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tMakecastle -=-=-=-=-=-=-=-

declare function addcastle(from as _cords,slot as short) as short
declare function adaptmap(slot as short) as short
declare function makecavemap(enter as _cords,tumod as short,dimod as short, spemap as short, froti as short, blocked as short=1) as short
declare function make_mine(slot as short) as short
declare function make_eventplanet(slot as short) as short

'declare function content(r as _rect,tile as short,map()as short) as integer
'declare function findrect(tile as short,map() as short,er as short=10,fi as short=60) as _rect

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tMakecastle -=-=-=-=-=-=-=-

namespace tMakecastle
function init(iAction as integer) as integer
	pDigger= @Digger
	return 0
end function
end namespace'tMakecastle

'

function content(r as _rect,tile as short,map()as short) as integer
    dim as short con,x,y
    for x=r.x to r.x+r.w
      for y=r.y to r.y+r.h
          if map(x,y)<>tile then con=con+1
      next
    next
    return con
end function

function findrect(tile as short,map() as short,er as short=10,fi as short=60) as _rect
    dim as _rect best,current
    dim as short x,y,x2,y2,com,dx,dy,u,besta
    
    ' er = fehlerrate, up to er sqares may be something else
    ' fi = stop looking if one is larger than fi
    
    besta=15
    for x=0 to 60
        for y=0 to 20
            for x2=x+3 to 60
                for y2=y+3 to 20
                    current.x=x
                    current.y=y
                    current.w=x2-x
                    current.h=y2-y
                    if current.w*current.h>besta then
                        if map(current.x,current.y)=tile and  map(current.x+current.w,current.y)=tile and  map(current.x,current.y+current.h)=tile and  map(current.x+current.w,current.y+current.h)=tile then
                            if content(current,tile,map())<=er then 
                                best=current
                                besta=best.h*best.w
                                if besta>fi then exit for,for,for,for
                            endif
                        endif
                    endif
                next
            next
        next
    next
    return best
end function

'

function addcastle(from as _cords,slot as short) as short
    
    dim map(60,20) as short
    dim r(1) as _rect
    dim vaults(6) as _rect
    dim as short x,y,a,b,c,c2,x2,xm,ym,x1,y1,sppc(1200),last,lasttrap
    dim  as _cords p,p2,dest,spp(1200),traps(1200)
    xm=0
    ym=0
    for b=0 to 1+rnd_range(0,10)
    
        r(1).x=rnd_range(2,35+xm)
        r(1).y=rnd_range(2,8+ym)
        r(1).w=rnd_range(8,20-xm)
        r(1).h=rnd_range(5,10-ym)
        if xm<6 and b mod 2=0 then xm+=1
        if ym<4 and b mod 2=0 then ym+=1
        if map(r(1).x-1,r(1).y-1)=1 and map(r(1).x-1,r(1).y+r(1).h+1)=1 and map(r(1).x+r(1).w+1,r(1).y-1)=1 and map(r(1).x+r(1).w+1,r(1).y+r(1).h+1)=1 then
            for x=r(1).x to r(1).x+r(1).w
                for y=r(1).y to r(1).y+r(1).h
                    map(x,y)=0
                next
            next
        else
            for x=r(1).x to r(1).x+r(1).w
                for y=r(1).y to r(1).y+r(1).h
                    map(x,y)=1
                next
            next
        endif
    next
    
    if rnd_range(1,100)<20 then
        c=4
        x2=rnd_range(15,45)
        for y=1 to 19
            map(x2,y)=1
        next
        for x=x2-2 to x2+2
            for y=0 to 3
                map(x,y)=1
            next
            for y=17 to 20
                map(x,y)=1
            next
        next
    endif
    a=rnd_range(1,100)        
    if rnd_range(1,100)<10 or a<60 then
        c=rnd_range(3,6)
        for x=0 to c
            for y=0 to c
                map(x,y)=1
            next
        next
        vaults(0).x=0
        vaults(0).y=0
        vaults(0).h=c
        vaults(0).w=c
        vaults(0).wd(5)=4
        vaults(0).wd(6)=-1
    endif
    if rnd_range(1,100)<30 or a<60 then
        c=rnd_range(3,6)
        for x=0 to c
            for y=20-c to 20
                map(x,y)=1
            next
        next
        vaults(1).x=0
        vaults(1).y=20-c
        vaults(1).h=c
        vaults(1).w=c
        vaults(1).wd(5)=4
        vaults(1).wd(6)=-1
    endif
    if rnd_range(1,100)<40 or a<60 then
        c=rnd_range(3,6)
        for x=60-c to 60
            for y=20-c to 20
                map(x,y)=1
            next
        next
        
        vaults(2).x=60-c
        vaults(2).y=20-c
        vaults(2).h=c
        vaults(2).w=c
        vaults(2).wd(5)=4
        vaults(2).wd(6)=-1
    endif
    if rnd_range(1,100)<50 or a<60 then
        c=rnd_range(3,6)
        for x=60-c to 60
            for y=0 to c
                map(x,y)=1
            next
        next
        vaults(3).x=60-c
        vaults(3).y=0
        vaults(3).h=c
        vaults(3).w=c
        vaults(3).wd(5)=4
        vaults(3).wd(6)=-1
    endif
    
'    tScreen.set(1)
'    for x=0 to 60
'        for y=0 to 20
'            locate y+1,x+1
'            if map(x,y)=1 then print "#";
'            if map(x,y)=0 then print " ";
'            if map(x,y)=7 then print "=";
'        next
'    next
'    sleep
    for x=1 to 59
        for y=1 to 19
            if map(x,y)=1 then
                if map(x-1,y)=0 or map(x+1,y)=0 or map(x,y+1)=0 or map(x,y-1)=0 or map(x-1,y-1)=0 or map(x-1,y+1)=0 or map(x+1,y+1)=0 or map(x+1,y-1)=0 then
                    map(x,y)=1
                else
                    map(x,y)=2
                endif
            endif
        next
    next
'
'    if rnd_range(1,100)<33+addpyramids*100 then
'        for x=1 to 59
'            for y=1 to 19
'                if (x=1 or y=1 or x=59 or y=19) and map(x,y)=0 then map(x,y)=7
'            next
'        next
'    endif
'
    for a=0 to rnd_range(5,13)
        
        do
            p.x=rnd_range(2,58)
            p.y=rnd_range(2,18)
            b+=1
        loop until b>5000 or map(p.x,p.y)=2 and map(p.x,p.y-1)=2 and map(p.x,p.y+1)=2 and map(p.x-1,p.y)=2 and map(p.x+1,p.y)=2
        if b<5000 then
            p2=p
            select case rnd_range(1,2)
            case is<2
                p=p2
                do    
                    map(p.x,p.y)=1
                    p.x-=1
                    if p.x=0 or p.x=60 then map(p.x,p.y)=1
                loop until map(p.x,p.y)=1 or map(p.x+1,p.y-1)=1 or map(p.x+1,p.y+1)=1
                p=p2
                do    
                    map(p.x,p.y)=1
                    p.x+=1
                    if p.x=0 or p.x=60 then map(p.x,p.y)=1
                loop until map(p.x,p.y)=1 or map(p.x-1,p.y-1)=1 or map(p.x-1,p.y+1)=1            
            case else
                p=p2
                do    
                    map(p.x,p.y)=1
                    p.y-=1
                    if p.y=0 or p.y=20 then map(p.x,p.y)=1
                loop until map(p.x,p.y)=1 or map(p.x-1,p.y+1)=1 or map(p.x+1,p.y+1)=1
                p=p2
                do    
                    map(p.x,p.y)=1
                    p.y+=1
                    if p.y=0 or p.y=20 then map(p.x,p.y)=1
                loop until map(p.x,p.y)=1 or map(p.x-1,p.y-1)=1 or map(p.x+1,p.y-1)=1
            end select
        endif
    next

    for x=1 to 59
        for y=1 to 19
            if map(x,y)=2 and map(x+1,y)=1 and map(x,y+1)=1 and map(x+1,y+1)=2 then map(x,y)=1
            if map(x,y)=1 and map(x+1,y)=2 and map(x,y+1)=2 and map(x+1,y+1)=1 then map(x,y)=2
        next
    next
    for a=0 to 3
        do
            p.x=rnd_range(1,59)
            p.y=rnd_range(1,19)
        loop until map(p.x,p.y)=1 and ((map(p.x-1,p.y)=0 and map(p.x+1,p.y)=2) or (map(p.x+1,p.y)=0 and map(p.x-1,p.y)=2) or (map(p.x,p.y-1)=0 and map(p.x,p.y+1)=2) or (map(p.x,p.y+1)=0 and map(p.x,p.y-1)=2)) 
        map(p.x,p.y)=3
    next
    b=0
    p2.x=1
    p2.y=1
    do
        
        floodfill4(map(),p2.x,p2.y)
        a=0
        for x=0 to 60
            for y=0 to 20
                if map(x,y)=2 or map(x,y)=0 then a+=1
            next
        next
        
        if a>0 then
            add_door(map())
        endif
        
        for x=1 to 59
            for y=1 to 19
                if map(x,y)>5 then map(x,y)=map(x,y)-10
            next
        next
            
            
    loop until a=0

    remove_doors(map())


    for x=0 to 60
        for y=0 to 20
            if x=0 or y=0 or x=60 or y=20 then map(x,y)=1
        next
    next
    
    for a=0 to rnd_range(14,24)
        add_door2(map())
    next
    
    'Find spawn points+chance
    last=0
    
    vaults(4)=findrect(2,map(),0,40)
    if addpyramids=1 then rlprint "Vault 4 at "&vaults(4).x &":"& vaults(4).y
    
    if rnd_range(1,100)<33+addpyramids*100 then
        if rnd_range(1,100)<33 then
            vaults(3).wd(5)=4
            vaults(3).wd(6)=-1
        else
            if rnd_range(1,100)< 50 then
                for x=vaults(4).x to vaults(4).x+vaults(4).w
                    for y=vaults(4).y to vaults(4).y+vaults(4).h
                        placeitem(make_item(94,2,3),x,y,lastplanet)
                    next
                next
            else
                for x=vaults(4).x to vaults(4).x+vaults(4).w
                    for y=vaults(4).y to vaults(4).y+vaults(4).h
                        placeitem(make_item(96,2,3),x,y,lastplanet)
                    next
                next
            endif
        endif
    endif    
    
    vaults(5)=findrect(0,map(),0,60)
    if addpyramids=1 then rlprint "garden at "&vaults(5).w &":"& vaults(5).h
    
    for x=1 to 59
        for y=1 to 19
            if map(x,y)=2 then
                c=0
                c2=0
                for x1=x-1 to x+1
                    for y1=y-1 to y+1
                        if map(x1,y1)=1 then c+=1
                        if map(x1,y1)=3 then c2+=1
                    next
                next
                last+=1
                if c2=1 and c=7 then
                    sppc(last)=100
                else
                    if map(x-1,y)=2 and map(x+1,y)=2 then c=c-20
                    if map(x,y-1)=2 and map(x,y+1)=2 then c=c-20
                    if c2=0 then sppc(last)=c*10
                endif
                spp(last).x=x
                spp(last).y=y
                if c=6 then
                    lasttrap+=1
                    traps(lasttrap).x=x
                    traps(lasttrap).y=y
                endif
            endif
        next
    next
    
    'Translate to real map
    lastplanet+=1
    for a=0 to 25
        b=rnd_range(3,9)
        p=rnd_point
        for x=0 to 60
            for y=0 to 20
                p2.x=x
                p2.y=y
                if distance(p2,p)<b then 
                    planetmap(x,y,lastplanet)+=1
                    if planetmap(x,y,lastplanet)>5 then planetmap(x,y,lastplanet)=0
                endif
            next
        next
    next
    sleep
    for x=0 to 60
        for y=0 to 20
            if planetmap(x,y,lastplanet)<2 and planetmap(x,y,lastplanet)>=0 then planetmap(x,y,lastplanet)=-10
            if planetmap(x,y,lastplanet)=2 and planetmap(x,y,lastplanet)>=0 then planetmap(x,y,lastplanet)=-6
            if planetmap(x,y,lastplanet)=3 and planetmap(x,y,lastplanet)>=0 then planetmap(x,y,lastplanet)=-5
            if planetmap(x,y,lastplanet)=4 and planetmap(x,y,lastplanet)>=0 then planetmap(x,y,lastplanet)=-12
            if planetmap(x,y,lastplanet)>4 and planetmap(x,y,lastplanet)>=0 then planetmap(x,y,lastplanet)=-3
        next
    next
    
    if rnd_range(1,100)<33+addpyramids*100 then
        for x=vaults(5).x+1 to vaults(5).x+vaults(5).w-2
            for y=vaults(5).y+1 to vaults(5).y+vaults(5).h-2
                planetmap(x,y,lastplanet)=-96
            next
        next
    endif
    
    for x=0 to 60
        for y=0 to 20
            if map(x,y)=1 then planetmap(x,y,lastplanet)=-51
            if map(x,y)=2 then planetmap(x,y,lastplanet)=-4
            if map(x,y)=3 then 
                if rnd_range(1,100)<33 then
                    planetmap(x,y,lastplanet)=-151
                else
                    if rnd_range(1,100)<50 then
                        planetmap(x,y,lastplanet)=-156
                    else
                        planetmap(x,y,lastplanet)=-157
                    endif
                endif
            endif
            if map(x,y)=7 then planetmap(x,y,lastplanet)=-2
        next
    next
    
    'Add stuff & features
    for a=0 to rnd_range(1,10)+rnd_range(1,10)
        b=find_high(sppc(),last)
        if b>0 then
            for c=0 to rnd_range(1,3)
                if rnd_range(1,100)<10 then
                    planetmap(spp(b).x,spp(b).y,lastplanet)=-154
                else
                    if rnd_range(1,100)<50 then
                        placeitem(make_item(96,2,3),spp(b).x,spp(b).y,lastplanet)
                    else
                        placeitem(make_item(94,2,3),spp(b).x,spp(b).y,lastplanet)
                    endif
                endif
            next
            spp(b)=spp(last)
            sppc(b)=sppc(last)
            last-=1
        endif
    next
    
    for a=0 to rnd_range(0,5)+rnd_range(0,5)
        b=rnd_range(1,lasttrap)
        if b>0 and lasttrap>1 then
            planetmap(traps(b).x,traps(b).y,lastplanet)=-154
            traps(b)=traps(lasttrap)
            lasttrap-=1
        endif
    next
    
    planets(lastplanet)=planets(slot)
    modsurface(lastplanet,5)
    a=findsmartest(lastplanet)
    deletemonsters(lastplanet)
    planets(lastplanet).mon_template(0)=planets(slot).mon_template(a)
    planets(lastplanet).mon_noamin(0)=15
    planets(lastplanet).mon_noamax(0)=25
    planets(lastplanet).mon_template(0).faction=7
    planets(lastplanet).mon_template(1)=planets(slot).mon_template(a)
    planets(lastplanet).mon_noamin(1)=5
    planets(lastplanet).mon_noamax(1)=15
    planets(lastplanet).mon_template(1).hpmax+=rnd_range(5,15)
    planets(lastplanet).mon_template(1).hp=planets(lastplanet).mon_template(0).hpmax
    planets(lastplanet).mon_template(1).sdesc=planets(lastplanet).mon_template(1).sdesc &" guard"
    planets(lastplanet).mon_template(1).weapon+=2
    planets(lastplanet).mon_template(1).armor+=2
    planets(lastplanet).mon_template(1).faction=7
    planets(lastplanet).depth=1
    planets(lastplanet).mapmod=0
    planets(lastplanet).grav=.5
    planets(lastplanet).weat=0
    planets(lastplanet).vault(0)=vaults(0)
    planets(lastplanet).vault(1)=vaults(1)
    planets(lastplanet).vault(2)=vaults(2)
    planets(lastplanet).vault(3)=vaults(3)
    if planets(lastplanet).temp>300 then planets(lastplanet).temp=300
    dest.x=30
    dest.y=0
    dest.m=lastplanet
    if planetmap(30,1,lastplanet)=-51 then dest.x+=1
    planetmap(dest.x,0,lastplanet)=-4
    from.m=slot
    addportal(from,dest,1,asc("O"),"A Fortress.",15)
    addportal(dest,from,1,asc("o"),"The front gate.",7)
    if addpyramids=1 then rlprint "Fortress at "&from.x &":"&from.y &":"&from.m
    return 0
end function


function adaptmap(slot as short) as short
    dim as short in,start,cur,a,b,c,pyr,hou,i,ti,x,y,vt
    dim houses(2) as short
    dim r as _rect
    dim as _cords p
    dim as _cords from,dest
    p=rnd_point
    if lastenemy>1 and planets(slot).atmos>1 then
        for a=1 to lastenemy
            if enemy(a).intel>=6 then
                if enemy(a).intel=6 then in=0
                if enemy(a).intel=7 then in=1
                if enemy(a).intel>7 then in=2
                if rnd_range(1,100)<66 then houses(in)=houses(in)+1
                if houses(in)>5 then houses(in)=5
            endif
        next
        for i=0 to 2
            p=rnd_point
            for a=0 to 2
               if houses(a)>0 then
                   for b=1 to houses(a)
                       c=rnd_range(1,8)
                       if c=5 then c=9
                       p=movepoint(p,c)
                       p=movepoint(p,c)
                       'put house
                       if rnd_range(1,100)<66 then
                            ti=90+in
                       else
                            ti=93+in
                       endif
                       if rnd_range(1,100)<16+planets(slot).atmos then
                            planetmap(p.x,p.y,slot)=-ti
                            if show_all=1 then planetmap(p.x,p.y,slot)=-planetmap(p.x,p.y,slot)
                            pyr=pyr+10+2*(a+1)                
                            if rnd_range(1,100)<ti-66 then placeitem(make_item(94),p.x,p.y,slot,0,0)
                            if rnd_range(1,100)<ti-66 then placeitem(make_item(94),p.x,p.y,slot,0,0)
                            if rnd_range(1,100)<ti-66 and ti>=93 then placeitem(make_item(94),p.x,p.y,slot,0,0)
                            if rnd_range(1,100)<ti-66 and ti>=93 then placeitem(make_item(94),p.x,p.y,slot,0,0)
                            if rnd_range(1,100)<ti-66 and ti>=93 then placeitem(make_item(94),p.x,p.y,slot,0,0)
                       endif
                       c=rnd_range(1,8)
                       if c=5 then c=9
                       p=movepoint(p,c)
                       'put cultivated land 
                       if abs(planetmap(p.x,p.y,slot))<90 then planetmap(p.x,p.y,slot)=-96                            
                   next
               endif 'no int aliens
                   
            next
        next
    endif
    
    if houses(0)=0 and houses(1)=0 and houses(2)=0 and rnd_range(1,100)<55 and isgardenworld(slot)<>0 then makesettlement(rnd_point,slot,rnd_range(0,4))
       
       
    if (rnd_range(1,100)<pyr+7 and pyr>0) or addpyramids=1 then         
        if show_all=1 then planetmap(p.x,p.y,slot)=-planetmap(p.x,p.y,slot)
        if rnd_range(1,100)<pyr+5 or addpyramids=1 then 
            if rnd_range(1,100)<33 then
                planetmap(p.x,p.y,slot)=-150
                addpyramid(p,slot)
            else
                planetmap(p.x,p.y,slot)=-4
                addcastle(p,slot)
            endif
        endif
    endif

    for b=0 to lastitem
        if item(b).w.m=slot and item(b).w.s>0 and slot<>specialplanet(9) then
            if item(b).ty=99 then
                planetmap(item(b).w.x,item(b).w.y,slot)=-149
                if rnd_range(1,100)>50 then 
                    planetmap(item(b).w.x,item(b).w.y,slot)=-148
                    p.x=item(b).w.x
                    p.y=item(b).w.y
                    for c=0 to rnd_range(1,3)
                        p=movepoint(p,5)
                        planetmap(item(b).w.x,item(b).w.y,slot)=-148
                    next
                    if rnd_range(1,100)>50 then planetmap(item(b).w.x,item(b).w.y,slot)=-100
                    
                endif
            endif
        endif
    next
    
    return 0
end function


function makecavemap(enter as _cords,tumod as short,dimod as short, spemap as short, froti as short, blocked as short=1) as short
    dim as short x,y,a,count,loops,b,slot,n,door,c,d,notu,t
    dim map2(60,20) as short 'hardness
    dim map3(60,20) as short 'to make vault
    dim seedps(64) as _cords
    dim r as _rect
    dim as _cords p1,p2,p3,rp,sp,ep
    dim gascloud as short
    gascloud=spacemap(player.c.x,player.c.y)
    slot=enter.m
    if show_all=1 then rlprint "Made cave at "&slot
        
    if planets(slot).depth=0 then planets(slot).depth=1
    planets(slot).darkness=5
    planets(slot).vault(0)=r
    
                     
    for a=0 to rnd_range(1,6)+rnd_range(1,6)+gascloud
        p1=rnd_point
        placeitem(make_item(96,-2,-3),p1.x,p1.y,slot)
    next
    
    for x=0 to 60
        for y=0 to 20
            planetmap(x,y,slot)=5
            map2(x,y)=100
        next
    next

    for a=0 to 20+tumod
        seedps(a).x=rnd_range(1,59)
        seedps(a).y=rnd_range(1,19)
        planetmap (seedps(a).x,seedps(a).y,slot)=0
    next
    planetmap(enter.x,enter.y,slot)=0
    
    if (rnd_range(1,100)<45 or spemap>0) and blocked=0 then
        lastportal+=1
        lastplanet+=1
        
        portal(lastportal).desig="A natural tunnel. "
        portal(lastportal).tile=111
        portal(lastportal).ti_no=3003
        portal(lastportal).col=7
        portal(lastportal).from.s=enter.s
        portal(lastportal).from.m=enter.m
        portal(lastportal).from.x=rnd_range(1,59)
        portal(lastportal).from.y=rnd_range(1,19)
        portal(lastportal).dest.m=lastplanet
        portal(lastportal).dest.s=portal(lastportal).from.s
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_portals
        map(portal(lastportal).from.s).discovered=3
        for b=0 to lastportal
            if portal(a).dest.m=portal(b).from.m then
                if portal(a).dest.x=portal(b).from.x and portal(a).from.y=portal(b).from.y then
                    portal(a).from.x=rnd_range(1,59)
                    portal(a).from.y=rnd_range(1,19)
                endif
            endif
        next
        
        planetmap(portal(a).from.x,portal(a).from.y,slot)=-4
    endif
    
    do
        count=0
    for x=1 to 59
        for y=1 to 19
            p1.x=x
            p1.y=y
            for a=1 to 9
                if a<>5 then
                    p2=movepoint(p1,a)
                    map2(x,y)=map2(x,y)-(5-planetmap(p2.x,p2.y,slot))*10
                endif
            next
        next
    next
    
    for x=0 to 60
        for y=0 to 20
            if rnd_range(1,100)>map2(x,y) then 
                planetmap(x,y,slot)=planetmap(x,y,slot)-1
                
                if planetmap(x,y,slot)<0 then 
                    count=count+1
                    planetmap(x,y,slot)=0
                endif
            endif
        next
    next
    loops=loops+1
    loop until loops>6+dimod
    'add vault
    for x=0 to 60
        for y=0 to 20
            map3(x,y)=planetmap(x,y,slot)
            if map3(x,y)>2 then map3(x,y)=5
        next
    next
    
    r=findrect(5,map3())
    
    'add tunnels
    notu=tumod+rnd_range(5,10)
    if notu>64 then notu=64
    for a=0 to notu
        
            b=rnd_range(0,20+tumod)
            sp.x=seedps(b).x
            sp.y=seedps(b).y
            c=rnd_range(0,20+tumod)
            ep.x=seedps(a+1).x
            ep.y=seedps(a+1).y
        do 
            
            d=nearest(sp,ep)
            if frac(d/2)<>0 then d=bestaltdir(d,rnd_range(0,1))
            ep=movepoint(ep,d)
            planetmap(ep.x,ep.y,slot)=0
        loop until ep.x=sp.x and ep.y=sp.y
    next
    
    

    'add noise
    for x=0 to 60
        for y=0 to 20
            n=rnd_range(1,10)+rnd_range(1,10)+rnd_range(1,10)
            'if n>22 then planetmap(x,y,slot)=planetmap(x,y,slot)+1
            if n<15 then planetmap(x,y,slot)=planetmap(x,y,slot)-1
            if planetmap(x,y,slot)<0 then planetmap(x,y,slot)=0
            if planetmap(x,y,slot)>5 then planetmap(x,y,slot)=5
        next
    next
    
    if (r.h*r.w>15 and rnd_range(1,100)<38) or make_vault=1 then 'realvault
        if r.h>3 or r.w>3 then 'really really vault
            sp.x=r.x+r.w/2
            sp.y=r.y+r.h/2
            ep.x=30
            ep.y=15
            for a=0 to 20+tumod
                if distance(seedps(a),sp)<distance(ep,sp) then ep=seedps(a)
            next
            makevault(r,slot,ep,rnd_range(1,6),0)   
        endif
    endif

    
    
    'translate from 0 to 5 to real tiles
    for x=0 to 60
        for y=0 to 20
            if planetmap(x,y,slot)=15 then 
                planetmap(x,y,slot)=-4
                placeitem(make_item(96,planets(a).depth),x,y,slot)
            endif
            if planetmap(x,y,slot)=0 then planetmap(x,y,slot)=-4
            if planetmap(x,y,slot)>0 then planetmap(x,y,slot)=-(46+planetmap(x,y,slot))
        next
    next
    for a=0 to gascloud+Rnd_range(1,5+planets(slot).depth)+rnd_range(1,5+planets(slot).depth)
        placeitem(make_item(96,planets(a).depth),rnd_range(0,60),rnd_range(0,20),slot)
    next
    
    if rnd_range(1,100)<3*planets(slot).depth then
        p1=rnd_point
        b=rnd_range(1,3)
        
        if rnd_range(1,200)<6 then
            p1=rnd_point
            b=rnd_range(1,3)+rnd_range(0,2)
            for x=p1.x-b to p1.x+b
                for y=p1.y-b to p1.y+b
                    if x>=0 and y>=0 and x<=60 and y<=20 then
                        p2.x=x
                        p2.y=y
                        if distance(p1,p2)<=b then 
                            if rnd_range(1,100)<88 then planetmap(x,y,slot)=-13
                            if rnd_range(1,100)<15 then placeitem(make_item(96,-3,-2),x,y,slot)
                        endif
                    endif
                next
            next
        endif
    endif
    
    if rnd_range(1,100)<20*planets(slot).depth or show_portals=1 then
        p1=rnd_point
        b=rnd_range(4,6)
        c=rnd_range(1,100)
        select case rnd_range(1,100)
            
        case 1 to 10
            t=1
        case 10 to 20
            t=13
        case 21 to 30
            t=14
        case 31 to 40
            t=20
        case 41 to 50
            t=26
        case 51 to 60
            t=47
        case 61 to 70
            t=159
        case 71 to 80
            t=12
            if c>50 then c=rnd_range(1,90)
        case 81 to 90
            t=rnd_range(28,30)'Geysers
            if c>50 then c=rnd_range(1,90)
        case else
            t=45
            if c>50 then c=rnd_range(1,90)
        end select
        
        for x=p1.x-b-1 to p1.x+b+1
            for y=p1.y-b-1 to p1.y+b+1
                if x>0 and y>0 and x<60 and y<20 then
                    p2.x=x
                    p2.y=y
                    if distance(p1,p2)<b and rnd_range(1,100)<100-distance(p1,p2)*10 then 
                        planetmap(x,y,slot)=-t
                        if show_portals=1 then planetmap(x,y,slot)=abs(planetmap(x,y,slot))
                        if c<50 or rnd_range(1,100)<10 then placeitem(make_item(96),x,y,slot)
                        if t=1 or t=20 and rnd_range(1,100)<100-distance(p1,p2)*10 then planetmap(x,y,slot)=-t-1'Deep water and deep acid
                    endif
                endif
            next
        next
                
    
    endif
    
    if abs(froti)=1 or abs(froti)=2 then
        if rnd_range(1,100)<abs(froti)*8 then
            do
                p1=rnd_point
            loop until p1.x=0 or p1.y=0 or p1.x=60 or p1.y=20
            do
                p2=rnd_point
            loop until (p2.x=0 or p2.y=0 or p2.x=60 or p2.y=20) and (p1.x<>p2.x and p1.y<>p2.y)
            a=0
            do                 
               a=a+1
               d=nearest(p1,p2)
               if frac(d/2)<>0 then d=bestaltdir(d,rnd_range(0,1))
               
               p2=movepoint(p2,d)
               if planetmap(p2.x,p2.y,slot)=-52 or planetmap(p2.x,p2.y,slot)=-53 then
                   p2=rnd_point
               else
                   planetmap(p2.x,p2.y,slot)=-2
                    for b=1 to 9
                        p3=movepoint(p2,b)
                        if planetmap(p3.x,p3.y,slot)<>-52 or planetmap(p3.x,p3.y,slot)<>-53 then planetmap(p3.x,p3.y,slot)=planetmap(p3.x,p3.y,slot)+rnd_range(1,6)
                        if planetmap(p3.x,p3.y,slot)>-48 then planetmap(p3.x,p3.y,slot)=-1
                    next
               endif
            loop until (p1.x=p2.x and p1.y=p2.y) or a>900
        endif
    endif
    
    if abs(froti)=5 then
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,slot)=-4 then
                    if rnd_range(1,100)<3 then planetmap(x,y,slot)=-59 'Leafy tree
                    if rnd_range(1,100)<5 then planetmap(x,y,slot)=-5 'Special tree
                    if rnd_range(1,100)<5 then planetmap(x,y,slot)=-5 'Tree
                    if rnd_range(1,100)<5 then planetmap(x,y,slot)=-3 'Dirt
                    if rnd_range(1,100)<15 then planetmap(x,y,slot)=-11 'Grass
                endif
            next
        next
    endif
    
    if rnd_range(1,100)<33 then
    
        for b=1 to rnd_range(1,6)+rnd_range(1,6)
            select case rnd_range(1,100)
            case 1 to 33 
                c=-87
            case 34 to 66
                c=-88
            case else
                c=-97
            end select
            p1=rnd_point
            d=rnd_range(1,4)
            for x=p1.x-d to p1.x+d
                for y=p1.y-d to p1.y+d
                    p2.x=x
                    p2.y=y
                    if x>=0 and y>=0 and y<=20 and x<=60 and distance(p1,p2)<=d then
                        if planetmap(x,y,slot)=-4 then planetmap(x,y,slot)=c
                    endif
                        
                next
            next
                
        next
        
    endif
    
    if rnd_range(1,100)<5 then 'Geyser caves
        for d=0 to rnd_range(1,10)+rnd_range(10,15)
            p1=rnd_point(slot,0)
            if planets(slot).temp>-50 then
                planetmap(p1.x,p1.y,slot)=-28
            else
                planetmap(p1.x,p1.y,slot)=-30
            endif
        next
    endif
    
    if rnd_range(1,100)<planets(slot).depth then
        p1=rnd_point(slot,0)
        planetmap(p1.x,p1.y,slot)=-298
    endif
    
    planetmap(0,0,slot)=-51
    if show_all=1 then
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,slot)=-planetmap(x,y,slot)
            next
        next
    endif
    
    return 0
end function


function make_mine(slot as short) as short
    dim as short x,y
    dim as _cords p1,gc1,gc
    p1.x=rnd_range(0,50)
    p1.y=rnd_range(0,15)
    planetmap(p1.x,p1.y,slot)=-76
    planetmap(p1.x+2,p1.y,slot)=-76
    planetmap(p1.x+2,p1.y+2,slot)=-76
    planetmap(p1.x+1,p1.y,slot)=-32
    planetmap(p1.x+1,p1.y+2,slot)=-32
    planetmap(p1.x,p1.y+1,slot)=-33
    planetmap(p1.x+2,p1.y+1,slot)=-33        
    planetmap(p1.x+3,p1.y,slot)=-32
    planetmap(p1.x+4,p1.y,slot)=-32
    planetmap(p1.x+5,p1.y,slot)=-32
    planetmap(p1.x+6,p1.y,slot)=-68
    planetmap(p1.x+1,p1.y+1,slot)=-4
    if rnd_range(1,100)<66 then
        planets(slot).flags(22)=-1
        planetmap(p1.x,p1.y+2,slot)=-99
    else
        planets(slot).flags(22)=rnd_range(1,6)
        planetmap(p1.x,p1.y+2,slot)=-99
    endif
    gc1.x=p1.x+1
    gc1.y=p1.y+1
    gc1.m=slot
    
    lastplanet=lastplanet+1
    gc.x=rnd_range(1,59)
    gc.y=rnd_range(1,19)
    gc.m=lastplanet
    
    assert(pMakemonster)
    
    makecavemap(gc,8,-1,0,0)
    planets(lastplanet)=planets(slot)
    planets(lastplanet).grav=1.4
    planets(lastplanet).depth=2
    planets(lastplanet).mon_template(0)=pMakemonster(1,lastplanet)
    planets(lastplanet).mon_noamax(0)=rnd_Range(2,12)+6
    planets(lastplanet).mon_noamin(0)=rnd_Range(2,12)
    for x=0 to 60
        for y=0 to 20
            if planetmap(x,y,lastplanet)=-4 and rnd_range(0,100)<66 then planetmap(x,y,lastplanet)=-47
        next
    next
    gc=rnd_point(lastplanet,0)
    gc.m=lastplanet
    addportal(gc1,gc,0,ASC("#"),"A mineshaft.",14)
    return 0
end function


function make_eventplanet(slot as short) as short
    DimDebug(0)'4
    dim as _cords p1,from,dest
    dim as _cords gc1,gc
    dim as short x,y,a,b,t1,t2,t,maxt

    assert(pMakemonster<>null)
    
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
        no_key= uConsole.keyinput()
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
        planets(slot).mon_template(0)=pMakemonster(3,slot)
        planets(slot).mon_noamax(0)=rnd_Range(2,12)+6
        planets(slot).mon_noamin(0)=rnd_Range(2,12)
        
        planets(slot).mon_template(1)=pMakemonster(50,slot)
        planets(slot).mon_noamax(1)=rnd_Range(0,2)+3
        planets(slot).mon_noamin(1)=rnd_Range(1,2)
        
        planets(slot).mon_template(2)=pMakemonster(71,slot)
        planets(slot).mon_template(2).cmmod=5
        planets(slot).mon_template(2).lang=29
        planets(slot).mon_noamax(2)=rnd_Range(2,12)+6
        planets(slot).mon_noamin(2)=rnd_Range(2,12)
        
        planets(slot).mon_template(3)=pMakemonster(72,slot)
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
        planets(slot).mon_template(0)=pMakemonster(4,slot)
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
        planets(slot).mon_template(0)=pMakemonster(92,slot)
        planets(slot).mon_noamin(0)=rnd_Range(2,12)
        planets(slot).mon_noamax(0)=planets(slot).mon_noamin(0)+6
        
        planets(slot).mon_template(1)=pMakemonster(93,slot)
        planets(slot).mon_noamin(1)=rnd_Range(2,12)
        planets(slot).mon_noamax(1)=planets(slot).mon_noamin(0)+6
        
        planets(slot).mon_template(2)=pMakemonster(95,slot)
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
        planets(lastplanet).mon_template(0)=pMakemonster(92,slot)
        planets(lastplanet).mon_noamin(0)=rnd_Range(2,12)
        planets(lastplanet).mon_noamax(0)=planets(slot).mon_noamin(0)+6
        
        planets(lastplanet).mon_template(1)=pMakemonster(93,slot)
        planets(lastplanet).mon_noamin(1)=rnd_Range(2,12)
        planets(lastplanet).mon_noamax(1)=planets(lastplanet).mon_noamin(1)+6
        
        planets(lastplanet).mon_template(2)=pMakemonster(94,slot)
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
        
        planets(slot).mon_template(0)=pMakemonster(97,slot)
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
'      -=-=-=-=-=-=-=- INIT: tMakecastle -=-=-=-=-=-=-=-
	tModule.register("tMakecastle",@tMakecastle.init()) ',@tMakecastle.load(),@tMakecastle.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tMakecastle -=-=-=-=-=-=-=-
#endif'test
