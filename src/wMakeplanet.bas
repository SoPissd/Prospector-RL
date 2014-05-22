'tMakeplanet.
'
'defines:
'checkdoor=1, digger=0, flood_fill=4, flood_fill2=1, floodfill3=2,
', floodfill4=0, checkvalid=5, checkbord=0, makecomplex3=11,
', makecomplex4=1, makelabyrinth=3, makeroots=2, chksrd=0, makevault=1,
', makecavemap=16, makegeyseroasis=2, modsurface=1, makeice=2,
', makecraters=7, togglingfilter=3, makeislands=12, makeoceanworld=3,
', makemossworld=6, makecanyons=3, addportal=32, deleteportal=4,
', makesettlement=0, makeroad=15, findsmartest=0, invisiblelabyrinth=1,
', station_event=2, clean_station_event=1, make_mine=1, makeoutpost =0,
', make_drifter=9, is_drifter=3, make_aliencolony=2, addpyramid=1,
', remove_doors=0, add_door2=0, add_door=0, addcastle=0, adaptmap=1,
', dominant_terrain=0, countasteroidfields=2, countgasgiants=4,
', checkcomplex=1, get_random_system=0, getrandomplanet=0, get_system=1,
', fillmap=0
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
'     -=-=-=-=-=-=-=- TEST: tMakeplanet -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Const make_vault=0
Const Show_specials=0		'1'12'13'5'38 'special planets already discovered
Const addpyramids=0
Const add_tile_each_map=0

type tMakespecialplanet as function(a as short) as short
dim Shared pMakespecialplanet as tMakespecialplanet

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tMakeplanet -=-=-=-=-=-=-=-

declare function flood_fill2(x as short,y as short, xm as short, ym as short, map() as byte) as short
declare function makecomplex3(slot as short,cn as short, rc as short,columns as short,tileset as short) as short
declare function makecomplex4(slot as short,rn as short,tileset as short) as short
declare function makelabyrinth(slot as short) as short
declare function makeroots(slot as short) as short
declare function makevault(r as _rect,slot as short,nsp as _cords, typ as short,ind as short) as short
declare function makecavemap(enter as _cords,tumod as short,dimod as short, spemap as short, froti as short, blocked as short=1) as short
declare function makegeyseroasis(slot as short) as short
declare function modsurface(a as short,o as short) as short
declare function makeice(a as short,o as short) as short
declare function makecraters(a as short, o as short) as short
declare function makeislands(a as short, o as short) as short
declare function makeoceanworld(a as short,o as short) as short
declare function makemossworld(a as short, o as short) as short
declare function makecanyons(a as short, o as short) as short
declare function addportal(from as _cords, dest as _cords, oneway as short, tile as short,desig as string, col as short) as short
declare function deleteportal(f as short=0, d as short=0) as short
declare function makeroad(byval s as _cords,byval e as _cords, a as short) as short
declare function invisiblelabyrinth(tmap() as _tile,xoff as short ,yoff as short, _x as short=11, _y as short=11) as short
declare function station_event(m as short) as short
declare function clean_station_event() as short
declare function make_mine(slot as short) as short
declare function make_drifter(d as _driftingship, bg as short=0,broken as short=0,f2 as short=0) as short
declare function is_drifter(m as short) as short
declare function make_aliencolony(slot as short,map as short, popu as short) as short
declare function addpyramid(p as _cords, slot as short) as short
declare function adaptmap(slot as short) as short
declare function countasteroidfields(sys as short) as short
declare function countgasgiants(sys as short) as short
declare function checkcomplex(map as short,fl as short) as integer
declare function get_system() as short  'returns the number of the system the player is in
declare function get_random_system(unique as short=0,gascloud as short=0,disweight as short=0,hasgarden as short=0) as short 'Returns a random system. If unique=1 then specialplanets are possible
declare function getrandomplanet(s as short) as short
declare function dominant_terrain(x as short,y as short,m as short) as short
declare function digger(byval p as _cords,map() as short,d as byte,ti as short=2,stopti as short=0) as short
declare function makeoutpost (slot as short,x1 as short=0, y1 as short=0) as short

declare function makeplanetmap(a as short,orbit as short,spect as short) as short
declare function make_eventplanet(slot as short) as short

'declare function floodfill4(map() as short,x as short,y as short) as short
'declare function checkbord(x as short,y as short, map() as short) as short
'declare function chksrd(p as _cords, slot as short) as short'Returns the sum of tile values around a point, -1 if at a border
'declare function makesettlement(p as _cords,slot as short, typ as short) as short
'declare function findsmartest(slot as short) as short
'declare function remove_doors(map() as short) as short
'declare function add_door2(map() as short) as short
'declare function add_door(map() as short) as short
'declare function addcastle(from as _cords,slot as short) as short
'declare function fillmap(map() as short,tile as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tMakeplanet -=-=-=-=-=-=-=-

namespace tMakeplanet
function init(iAction as integer) as integer
	pDigger= @Digger
	return 0
end function
end namespace'tMakeplanet


#define cut2top




function digger(byval p as _cords,map() as short,d as byte,ti as short=2,stopti as short=0) as short
    dim d2 as short
    dim c as short
    do
        c=c+1
        if p.y=0 or p.x=0 or p.x=60 or p.y=20 then return 1
        if d=1 and p.y<=1 then d2=1
        if d=2 and p.x>=59 then d2=2
        if d=3 and p.y>=19 then d2=3
        if d=4 and p.y<=1 then d2=4
        if d2=1 or d2=3 then
            if rnd_range(1,100)<51 then
                d=2
            else
                d=4
            endif
            d2=0
        endif
        if d2=2 or d2=4 then
            if rnd_range(1,100)<51 then
                d=1
            else
                d=3
            endif
            d2=0
        endif
        if map(p.x,p.y)=stopti then return 0
        map(p.x,p.y)=ti
        if rnd_range(1,100)<10 then map(p.x,p.y)=4
        if d=1 or d=3 then
            if map(p.x-1,p.y)=stopti or map(p.x+1,p.y)=stopti then return 0
        else
            if map(p.x,p.y-1)=stopti or map(p.x,p.y+1)=stopti then return 0
        endif
        if d=1 then p.y=p.y-1
        if d=2 then p.x=p.x+1
        if d=3 then p.y=p.y+1
        if d=4 then p.x=p.x-1
    loop until c>512
    return 0
end function


function flood_fill2(x as short,y as short, xm as short, ym as short, map() as byte) as short
    if x>=0 and y>=0 and x<=xm and y<=ym then
      if map(x,y)=1 then
          map(x,y)=2
      else
          return 0
      endif
      Flood_Fill2(x+1,y,xm,ym,map())
      Flood_Fill2(x-1,y,xm,ym,map())
      Flood_Fill2(x,y+1,xm,ym,map())
      Flood_Fill2(x,y-1,xm,ym,map())
  endif
end function


function floodfill4(map() as short,x as short,y as short) as short
    if x<0 or y<0 or x>60 or y>20 then return 0
    if map(x,y)<>1 and map(x,y)<5 then
        map(x,y)=map(x,y)+10
    else
        return 0
    endif
    floodfill4(map(),x+1,y)
    floodfill4(map(),x-1,y)
    floodfill4(map(),x,y+1)
    floodfill4(map(),x,y-1)
end function


function checkbord(x as short,y as short, map() as short) as short
    if x<=0 then return 0
    if y<=0 then return 0
    if x>=60 then return 0
    if y>=20 then return 0
    dim r as short
    if map(x-1,y)=0 and map(x+1,y)=1 and map(x,y-1)=1 and map(x,y+1)=1 then r=1
    if map(x-1,y)=1 and map(x+1,y)=0 and map(x,y-1)=1 and map(x,y+1)=1 then r=2
    if map(x-1,y)=1 and map(x+1,y)=1 and map(x,y-1)=0 and map(x,y+1)=1 then r=3
    if map(x-1,y)=1 and map(x+1,y)=1 and map(x,y-1)=1 and map(x,y+1)=0 then r=4
    if map(x-1,y)=1 and map(x+1,y)=1 and map(x,y-1)=1 and map(x,y+1)=1 then r=5
    return r
end function



function makecomplex3(slot as short,cn as short, rc as short,columns as short,tileset as short) as short

dim map(60,20) as short
dim filled as short
dim as short x,y,h,w,coll,xx,yy,dx,dy,a,x1,x2,y1,y2,made,t
dim as integer giveup,giveup2
dim as single d
dim route(128) as _cords
dim lastr as short

rc=0
columns=0
coll=0
x=rnd_range(20,40)
y=rnd_range(8,16)
h=rnd_range(3,4)
w=rnd_range(3,5)
if x+w>59 then x=59-w
if y+h>19 then y=19-h
for xx=x to x+w
    for yy=y to y+h
        map(xx,yy)=1
    next
next
do
    giveup=0
    do
        coll=0
        x=rnd_range(1,59)
        y=rnd_range(1,19)
        h=rnd_range(2,6)
        w=rnd_range(3,9)
        if x+w>59 then x=59-w
        if y+h>19 then y=19-h
        for xx=x-4 to x+w+4
            for yy=y-3 to y+h+3
                if xx>0 and yy>0 and xx<60 and yy<20 then
                    if map(xx,yy)<>0 then coll=1
                endif
            next
        next
        
        giveup+=1
    loop until coll=0 or giveup>100
    for xx=0 to 60
        for yy=0 to 20
            if xx>=x and xx<=x+w and yy>=y and yy<=y+h and giveup<=100 then map(xx,yy)=2
        next
    next
    if rnd_range(1,100)<rc and giveup<=100 and h>=3 and w>3 then
        map(x,y)=0
        map(x+w,y)=0
        map(x+w,y+h)=0
        map(x,y+h)=0
    endif
    
        
    
    route(0).x=x+rnd_range(1,w-1)
    route(0).y=y+rnd_range(1,h-1)
    d=999999
    for xx=0 to 60
        for yy=0 to 20
            if map(xx,yy)=1 then
                route(1).x=xx
                route(1).y=yy
                if distance(route(0),route(1))<d then
                    d=distance(route(0),route(1))
                    route(2)=route(1)
                endif
            endif
        next
    next
    
    
    if giveup<=100 then
    do
        dx=route(0).x-route(2).x
        dy=route(0).y-route(2).y
        if abs(dx)>=abs(dy) then
            do
                dx=route(0).x-route(2).x
                map(route(0).x,route(0).y)=2
                if dx>0 then route(0).x=route(0).x-1
                if dx<0 then route(0).x=route(0).x+1
            loop until dx=0 or map(route(0).x,route(0).y)<>0 
        endif
        if abs(dx)<abs(dy) then
            do 
                dy=route(0).y-route(2).y
                map(route(0).x,route(0).y)=2
                if dy>0 then route(0).y=route(0).y-1
                if dy<0 then route(0).y=route(0).y+1
            loop until dy=0 or map(route(0).x,route(0).y)<>0
        endif
    
    loop until dx=0 and dy=0
    
    if rnd_range(1,100)<columns then
        if h>=5 and w>h and frac(w/2)=0 then
            for xx=x+1 to x+w-1 step 2
                map(xx,y+1)=3
                map(xx,y+h-1)=3
            next
        endif
        if w>=5 and h>w and frac(h/2)=0 then 
            for yy=y+1 to y+h-1 step 2
                map(x+1,yy)=3
                map(x+w-1,yy)=3
            next
        endif
    endif
    endif
    
    filled=0
    for xx=0 to 60
        for yy=0 to 20
            if map(xx,yy)=2 then map(xx,yy)=1
            if map(xx,yy)=1 then filled=filled+1
        next
    next

    giveup2+=1
loop until filled>750 or giveup2>500


made=0
do
    do
        y=rnd_range(1,19)
        x=rnd_range(1,59)
        coll=0
        for xx=x-1 to x+1
            for yy=y-2 to y+2
                if xx>=0 and yy>=0 and xx<=60 and yy<=20 then
                if map(xx,yy)<>0 then coll=1
                endif
            next
        next
        
    loop until coll=0
    x1=0
    x2=0
    for xx=x to 59
        if x1=0 and (map(xx,y)<>0 or map(xx,y+1)<>0 or map(xx,y-1)<>0) then x1=xx
    next
    for xx=x to 1 step -1
        if x2=0 and (map(xx,y)<>0 or map(xx,y+1)<>0 or map(xx,y-1)<>0) then x2=xx
    next
    
    if x1>x2 then swap x1,x2
    if x1>1 and x2<59 then
        map(x1,y)=1
        map(x2,y)=1
        for x=x1 to x2
            if map(x,y)=0 and map(x,y-1)=0 and map(x,y+1)=0 then map(x,y)=2
        next
        made=made+1
    endif

    do
        y=rnd_range(1,19)
        x=rnd_range(1,59)
        coll=0
        for xx=x-2 to x+2
            for yy=y-1 to y+1
                if xx>=0 and yy>=0 and xx<=60 and yy<=20 then
                if map(xx,yy)<>0 then coll=1
                endif
            next
        next
        
    loop until coll=0
    y1=0
    y2=0
    for yy=y to 19
        if y1=0 and (map(x,yy)<>0 or map(x+1,yy)<>0 or map(x-1,yy)<>0) then y1=yy
    next
    for yy=y to 1 step -1
        if y2=0 and (map(x,yy)<>0 or map(x-1,yy)<>0 or map(x+1,yy)<>0) then y2=yy
    next
    
    if y1>y2 then swap y1,y2
    if y1>1 and y2<19 then
        map(x,y1)=1
        map(x,y2)=1
        for y=y1 to y2
            if map(x,y)=0 and map(x-1,y)=0 and map(x+1,y)=0 then map(x,y)=2
        next
        made=made+1
    endif
loop until made>=cn



for xx=1 to 59
    for yy=1 to 19
        if map(xx,yy)=1 or map(xx,yy)=2 then
            if map(xx-1,yy)=0 and map(xx+1,yy)=0 then
                if map(xx,yy+1)=1 and (map(xx-1,yy+1)=1 or map(xx+1,yy+1)=1) then map(xx,yy)=4
                if map(xx,yy-1)=1 and (map(xx-1,yy-1)=1 or map(xx+1,yy-1)=1) then map(xx,yy)=4
            endif
            if map(xx,yy+1)=0 and map(xx,yy-1)=0 then
                if map(xx-1,yy)=1 and (map(xx-1,yy+1)=1 or map(xx-1,yy-1)=1) then map(xx,yy)=4
                if map(xx+1,yy)=1 and (map(xx+1,yy+1)=1 or map(xx+1,yy-1)=1) then map(xx,yy)=4
            endif
            if map(xx,yy)=4 and (map(xx-1,yy)=4 or map(xx+1,yy)=4 or map(xx,yy-1)=4 or map(xx,yy+1)=4) then map(xx,yy)=1 
        endif
    next
next

if tileset=1 then
    
    for x=0 to 60
        for y=0 to 20
            if map(x,y)=0 then planetmap(x,y,slot)=-50
            if map(x,y)=1 then planetmap(x,y,slot)=-202
            if map(x,y)=2 then planetmap(x,y,slot)=-202
            if map(x,y)=1 and rnd_range(1,100)<5+planets(slot).depth then planetmap(x,y,slot)=-248
            if map(x,y)=1 and rnd_range(1,100)<10 then 
                if map(x-1,y)=0 or map(x+1,y)=0 or map(x,y+1)=0 or map(x,y-1)=0 then planetmap(x,y,slot)=-221
            endif
            if map(x,y)=1 and rnd_range(1,100)<10 then 
                if map(x-1,y)=0 or map(x+1,y)=0 or map(x,y+1)=0 or map(x,y-1)=0 then planetmap(x,y,slot)=-223
            endif
            if map(x,y)=4 then planetmap(x,y,slot)=-156            
        next
    next
endif

if tileset=2 then
    a=215
    planets(slot).flags(10)=rnd_range(4,6)
    planets(slot).flags(11)=rnd_range(4,6)
    planets(slot).flags(12)=rnd_range(4,6)
    planets(slot).flags(13)=rnd_range(4,6)
    planets(slot).flags(14)=rnd_range(4,6)
    planets(slot).flags(15)=rnd_range(4,6)
    for x=0 to 60
        for y=0 to 20
            if map(x,y)=0 then planetmap(x,y,slot)=-50
            if map(x,y)=1 then planetmap(x,y,slot)=-202
            if map(x,y)=2 then planetmap(x,y,slot)=-202
            if map(x,y)=1 and rnd_range(1,100)<5+planets(slot).depth then planetmap(x,y,slot)=-248
            if map(x,y)=1 and rnd_range(1,100)<10 then 
                if map(x-1,y)=0 or map(x+1,y)=0 or map(x,y+1)=0 or map(x,y-1)=0 then planetmap(x,y,slot)=-221
            endif
            if map(x,y)=4 then planetmap(x,y,slot)=-156
            if map(x,y)=1 then
                if map(x-1,y)=1 and map(x+1,y)=1 and map(x,y-1)=1 and map(x,y+1)=1 and a<=219 then 
                    planetmap(x,y,slot)=-a
                    a+=1
                endif
            endif
                    
        next
    next
endif

if tileset=3 then
    for x=0 to 60
        for y=0 to 20
            if map(x,y)=0 then planetmap(x,y,slot)=-50
            if map(x,y)=1 then planetmap(x,y,slot)=-202
            if map(x,y)=2 then planetmap(x,y,slot)=-202
            if map(x,y)=4 then planetmap(x,y,slot)=-202
        next
    next
endif

return 0
end function

function makecomplex4(slot as short,rn as short,tileset as short) as short
        
    dim as short map(60,20)
    dim as short map2(60,20)
    dim valid(1300) as _cords
    dim as short x,y,lastvalid,c,d,cc,h,w,xx,yy,coll,filled
    dim center(25) as _cords
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
    
    do
        lastvalid=0
        cc=0
        for x=1 to 59 step 2
            for y=1 to 19 step 2
                if checkbord(x,y,map())>0 then
                    lastvalid+=1
                    valid(lastvalid).x=x
                    valid(lastvalid).y=y
                    if checkbord(x,y,map())=5 then cc+=1
                
                endif
            next
        next
        if lastvalid>0 then
            c=rnd_range(1,lastvalid)
            if checkbord(valid(c).x,valid(c).y,map())=5 then
                d=rnd_range(1,4)
            else
                d=checkbord(valid(c).x,valid(c).y,map())
            endif
            if d=1 and valid(c).x+1<60 then 
                if checkbord(valid(c).x+2,valid(c).y,map())=5 then map(valid(c).x+1,valid(c).y)=0
            endif
            if d=2 and valid(c).x-1>0 then 
                if checkbord(valid(c).x-2,valid(c).y,map())=5 then map(valid(c).x-1,valid(c).y)=0
            endif
            if d=3 and valid(c).y+1<20 then 
                if checkbord(valid(c).x,valid(c).y+2,map())=5 then map(valid(c).x,valid(c).y+1)=0
            endif
            if d=4 and valid(c).y-1>0 then 
                if checkbord(valid(c).x,valid(c).y-2,map())=5 then map(valid(c).x,valid(c).y-1)=0
            endif
        endif
    loop until lastvalid<=200 or cc<=5
    
    for x=1 to 59 step 2
        for y=1 to 19 step 2
            if checkbord(x,y,map())=5 then map(x,y)=1
        next
    next
    
    if rn>0 then
        for c=0 to rn
            do
                x=rnd_range(1,28)*2
                y=rnd_range(1,8)*2
                h=rnd_range(2,3)*2
                w=rnd_range(1,4)*2
                if x+w>60 then x=58-w
                if y+h>20 then y=18-h
                if x<0 then x=0
                if y<0 then y=0
                coll=0
                for xx=x to x+w
                    for yy=y to y+w
                        if xx>=0 and yy>=0 and xx<=60 and yy<=20 then
                            if map2(xx,yy)=1 then coll=1
                        endif
                    next
                next
            loop until coll=0
            for xx=x to x+w
                for yy=y to y+h
                    if xx>=0 and yy>=0 and xx<=60 and yy<=20 then
                    if xx=x or yy=y or xx=x+w or yy=y+h then 
                        map(xx,yy)=1
                    else
                        map(xx,yy)=0
                    endif
                    map2(xx,yy)=1
                    endif
                next
            next
            center(c).x=x+w/2
            center(c).y=y+w/2
        next
    endif
    for x=1 to 59 step 2
        for y=1 to 19 step 2
            if checkbord(x,y,map())=5 then map(x,y)=1
        next
    next
    
    for c=0 to 5
        do
            x=rnd_range(1,59)
            y=rnd_range(1,20)
        loop until map(x,y)=0
        center(c).x=x
        center(c).y=y
    next
    c=0
    do
        filled=0
        for x=0 to 60
            for y=0 to 20
                if map(x,y)=-2 then map(x,y)=2
                if map(x,y)=-1 then filled+=1
                if map(x,y)=-1 then map(x,y)=0
            next
        next
        c+=1
        if c>5 then c=0
        floodfill3(center(c).x,center(c).y,map())
        lastvalid=0
        for x=1 to 59 
            for y=1 to 19 
                map2(x,y)=0
                if checkdoor(x,y,map()) then
                    lastvalid+=1
                    valid(lastvalid).x=x
                    valid(lastvalid).y=y
                    map2(x,y)=1
                endif
            next
        next
        d=rnd_range(1,lastvalid)
        map(valid(d).x,valid(d).y)=2
        
    loop until lastvalid=0 or filled>=1000
    
    if tileset=1 then
        for x=0 to 60
            for y=0 to 20
                if map(x,y)=0 then planetmap(x,y,slot)=4
                if map(x,y)=1 then planetmap(x,y,slot)=50
                if map(x,y)=2 then planetmap(x,y,slot)=156
                if map(x,y)=-2 then planetmap(x,y,slot)=156
                if map(x,y)=-2 then planetmap(x,y,slot)=156
            next
        next
        planetmap(0,0,slot)=50
    endif
    return 0
end function

function makelabyrinth(slot as short) as short
    
    dim map(60,20) as short
    dim as short x,y,a,b,c,count
    dim p as _cords
    dim p2 as _cords
    dim border as short   
    dim t as integer
    
    planets(slot).darkness=5
    t=timer
    for x=0 to 60
        for y=0  to 20
            map(x,y)=1
            
        next
    next
    
    map(rnd_range(1,59),rnd_range(1,19))=0
    
    if slot=specialplanet(3) or slot=specialplanet(4) then
        map(rnd_range(1,59),rnd_range(1,19))=0
        map(rnd_range(1,59),rnd_range(1,19))=0
        map(rnd_range(1,59),rnd_range(1,19))=0
    endif
    do
        count=count+1
        p.x=rnd_range(1,59)
        p.y=rnd_range(1,19)
        if map(p.x,p.y)=1 then
            if map(p.x-1,p.y)=0 or map(p.x,p.y+1)=0 or map(p.x+1,p.y)=0 or map(p.x,p.y-1)=0 then
                if map(p.x,p.y-1)=1 and map(p.x,p.y+1)=1 and map(p.x-1,p.y)=1 and map(p.x-1,p.y-1)=1 and map(p.x-1,p.y+1)=1 then map(p.x,p.y)=0
                if map(p.x,p.y-1)=1 and map(p.x,p.y+1)=1 and map(p.x+1,p.y)=1 and map(p.x+1,p.y-1)=1 and map(p.x+1,p.y+1)=1 then map(p.x,p.y)=0
                if map(p.x-1,p.y)=1 and map(p.x+1,p.y)=1 and map(p.x-1,p.y-1)=1 and map(p.x,p.y-1)=1 and map(p.x+1,p.y-1)=1 then map(p.x,p.y)=0
                if map(p.x-1,p.y+1)=1 and map(p.x,p.y+1)=1 and map(p.x-1,p.y)=1 and map(p.x+1,p.y)=1 and  map(p.x+1,p.y+1)=1 then map(p.x,p.y)=0
            endif
            if map(p.x,p.y)=0 then
                c=0
                for x=0 to 60
                    for y=0  to 20
                        if map(x,y)=0 then c=c+1
                    next
                next
            endif
        endif
    loop until c+rnd_range(1,20)>575 or timer>t+15
    
    c=0
    do
        p.x=rnd_range(1,59)
        p.y=rnd_range(1,19)
        if map(p.x,p.y)=0 then
            if map(p.x-1,p.y-1)=2 or map(p.x,p.y-1)=2 or map(p.x+1,p.y-1)=2 or map(p.x+1,p.y)=2 or map(p.x+1,p.y-1)=2 or map(p.x,p.y+1)=2 or map(p.x+1,p.y)=2 or map(p.x-1,p.y+1)=2 then
                map(p.x,p.y)=3
            else
                if map(p.x-1,p.y)=1 and map(p.x+1,p.y)=1 and map(p.x,p.y-1)<>1 and map(p.x,p.y+1)<>1 then map(p.x,p.y)=2 
                if map(p.x,p.y-1)=1 and map(p.x,p.y+1)=1 and map(p.x-1,p.y)<>1 and map(p.x+1,p.y)<>1 then map(p.x,p.y)=2 
            endif
            if map(p.x,p.y)=2 then c=c+1
        endif
    loop until c>12+rnd_range(1,6)+rnd_range(1,6) or t>timer+20
    
    c=0
    do
        p.x=rnd_range(1,59)
        p.y=rnd_range(1,19)
        if map(p.x,p.y)=0 then
            if map(p.x-1,p.y-1)=5 or map(p.x,p.y-1)=5 or map(p.x+1,p.y-1)=5 or map(p.x+1,p.y)=5 or map(p.x+1,p.y-1)=5 or map(p.x,p.y+1)=5 or map(p.x+1,p.y)=5 or map(p.x-1,p.y+1)=5 then
                map(p.x,p.y)=3
            else
                if map(p.x-1,p.y)=1 and map(p.x+1,p.y)=1 and map(p.x,p.y-1)<>1 and map(p.x,p.y+1)<>1 then map(p.x,p.y)=5 
                if map(p.x,p.y-1)=1 and map(p.x,p.y+1)=1 and map(p.x-1,p.y)<>1 and map(p.x+1,p.y)<>1 then map(p.x,p.y)=5 
            endif
            if map(p.x,p.y)=5 then c=c+1
        endif
    loop until c>12+rnd_range(1,6)+rnd_range(1,6) or t>timer+25
    
    c=0
    do
        p.x=rnd_range(1,59)
        p.y=rnd_range(1,19)
        if map(p.x,p.y)=0 then
            map(p.x,p.y)=3
            c=c+1
        endif
    
    loop until c>12+rnd_range(1,6)+rnd_range(1,6) or t>timer+30
    
    for c=1 to 20
        p.x=rnd_range(1,59)
        p.y=rnd_range(1,19)
        if  map(p.x,p.y)=0 and map(p.x+1,p.y)=0 and map(p.x,p.y+1)=0 and map(p.x-1,p.y)=0 and map(p.x,p.y-1)=0 then
            map(p.x,p.y)=3
        endif
    next
    for x=0 to 60
       for y=0 to 20
           if map(x,y)=0 then planetmap(x,y,slot)=-4     
           if map(x,y)=1 then planetmap(x,y,slot)=-51     
           if map(x,y)=2 then 
               planetmap(x,y,slot)=-156 
               if rnd_range(1,100)<45 then planetmap(x,y,slot)=-157 
           endif
           if map(x,y)=3 then planetmap(x,y,slot)=-154     
           if map(x,y)=5 then planetmap(x,y,slot)=-151                    
       next
    next
    return 0
end function

function makeroots(slot as short) as short
    dim as _cords p,p2
    dim as short a,b,c,x,y
    if planets(slot).depth=0 then planets(slot).depth=1
    for x=0 to 60
        for y=0 to 20
            if x=0 or y=0 or x=60 or y=20 then
                planetmap(x,y,slot)=-152
            else
                planetmap(x,y,slot)=-3
            endif
        next
    next
            
    for a=0 to 730
        do
            c=0
            p=rnd_point
            for b=1 to 9
                if b<>5 then
                    p2=movepoint(p,b)
                    if planetmap(p2.x,p2.y,slot)<>-3 then c=c+1
                endif
            next
        loop until c>0 and c<4
        planetmap(p.x,p.y,slot)=-152
    next
    for a=0 to 9
        p=rnd_point
        planetmap(p.x,p.y,slot)=-59
    next
    for a=0 to 29+rnd_range(1,6)
        p=rnd_point
        planetmap(p.x,p.y,slot)=-146
    next
    if show_specials=1 then
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,slot)=-planetmap(x,y,slot)
            next
        next
    endif
    return 0
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


function makevault(r as _rect,slot as short,nsp as _cords, typ as short,ind as short) as short
    dim as short x,y,a,b,c,d,nodo,best,bx,by
    dim p(31) as _cords
    dim wmap(r.w,r.h) as short
    dim as single rad
    
    r.wd(16)=typ
    if typ=1 or typ=2 then
        do
           if r.h>10 then r.h=r.h-rnd_range(3,6)
           if r.w>10 then r.w=r.w-rnd_range(3,6)
        loop until r.h+r.w<30
        
        for x=r.x to r.x+r.w
            for y=r.y to r.y+r.h
                if x=r.x or y=r.y or x=r.x+r.w or y=r.y+r.h then
                    planetmap(x,y,slot)=6
                else
                    planetmap(x,y,slot)=0
                endif
            next
        next
        
        for a=1 to 10
            do 
                do
                    d=rnd_range(1,8)
                    if d=4 then d=d+1
                loop until frac(d/2)=0
                p(a)=rndrectwall(r,d)
            loop until p(a).x>0 and p(a).y>0 and p(a).y<60 and p(a).y<20
        next
        
        nodo=rnd_range(1,5)+rnd_range(1,5)-4
        if nodo<1 then nodo=1
        for a=1 to nodo
            best=99
            for b=1 to 10
                if p(b).x>0 then
                   if chksrd(p(b),slot)<=best and chksrd(p(b),slot)>0 then
                       c=b
                       best=chksrd(p(c),slot)
                       if show_all then rlprint "Points of door pos:"& best
                    endif
                endif
            next
            if p(c).x>0 and p(c).y>0 and p(c).x<60 and p(c).y<20 then planetmap(p(c).x,p(c).y,slot)=8
            p(c).x=-1
        next
        r.wd(5)=1
        r.wd(6)=9
    endif
    
    if typ>2 and typ<7 then
        p(1).x=r.x+r.w/2
        p(1).y=r.y+r.h/2
        bx=r.w/2
        by=r.h/2
        do
        for rad=0 to 6.243 step .1
            x=cos(rad)*bx+p(1).x
            y=sin(rad)*by+p(1).y
            if x<0 then x=0
            if y<0 then y=0
            if x>60 then x=60
            if y>20 then y=20
            planetmap(x,y,slot)=0
        next
        bx=bx-1
        by=by-1
        if bx<0 then bx=0
        if by<0 then by=0
        loop until bx=0 and by=0
'        for x=r.x to r.x+r.w
'            for y=r.y to r.y+r.h
'                planetmap(x,y,slot)=2
'                p(2).x=x
'                p(2).y=y
'                if distance(p(1),p(2))<b then planetmap(x,y,slot)=0
'            next
'        next
        for y=r.y to r.y+r.h
            if planetmap(x,y,slot)=0 then
                if rnd_range(1,100)<11 then placeitem(rnd_item(RI_StrandedShip),x,y,slot)
                if rnd_range(1,100)<21 then placeitem(make_item(96,-3,-3),x,y,slot)
                if rnd_range(1,100)<3 then placeitem(make_item(99),x,y,slot)                
            endif
        next
        p(1).x=r.x+r.w/2
        p(1).y=r.y+r.h/2
        p(2)=nsp
        do 
            d=nearest(p(1),p(2))
            if frac(d/2)<>0 then d=bestaltdir(d,rnd_range(0,1))
            p(2)=movepoint(p(2),d)
            planetmap(p(2).x,p(2).y,slot)=0
        loop until p(2).x=p(1).x and p(2).y=p(1).y
        
        r.wd(5)=2
        if rnd_range(1,6)<3 then r.wd(6)=18
        if rnd_range(1,6)<3 then r.wd(6)=17
        r.wd(6)=16
    endif
    if typ=99 then
        for x=r.x to r.x+r.w
            for y=r.y to r.y+r.h
                if x=r.x or x=r.x+r.w or y=r.y or y=r.y+r.h then
                    planetmap(x,y,slot)=-51
                else    
                    planetmap(x,y,slot)=-4
                    if rnd_range(1,100)<21 then placeitem(make_item(7),x,y,slot)
                    if rnd_range(1,100)<15 then placeitem(make_item(96,5,5),x,y,slot)
                endif
            next
        next
        p(1).x=r.x+r.w/2
        p(1).y=r.y+r.h/2
        p(2)=nsp
        do 
            d=nearest(p(1),p(2))
            if frac(d/2)<>0 then d=bestaltdir(d,rnd_range(0,1))
            p(2)=movepoint(p(2),d)
            planetmap(p(2).x,p(2).y,slot)=-4
        loop until p(2).x=p(1).x and p(2).y=p(1).y
        
        r.wd(5)=2
        r.wd(6)=3
    endif
    
    planets(slot).vault(ind)=r
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


function makegeyseroasis(slot as short) as short
    ' Makes a planet map covered in ice and mountains with geysers surrounded by greenlands
    dim as short x,y,r,oasis,mountains,i,x1,y1
    dim as short camap(60,20)
    dim as _cords p,p2
    for x=0 to 60
        for y=0 to 20
            planetmap(x,y,slot)=-14
        next
    next
    mountains=rnd_range(4,10)
    for i=0 to mountains
        p=rnd_point
        do
            p=movepoint(p,5)
            planetmap(p.x,p.y,slot)=-8
        loop until rnd_range(1,100)<10
    next
    oasis=rnd_range(4,10)
    for i=0 to oasis
        p=rnd_point
        r=rnd_range(3,5)
        for x=0 to 60
            for y=0 to 20
                p2.x=x
                p2.y=y
                if distance(p2,p)=r then planetmap(x,y,slot)=-12
                if distance(p2,p)<r then
                    planetmap(x,y,slot)=-11
                    if rnd_range(1,100)<20 then
                        if rnd_range(1,100)<60 then
                            if rnd_range(1,100)<60 then
                                planetmap(x,y,slot)=-5
                            else
                                planetmap(x,y,slot)=-146
                            endif
                        else
                            planetmap(x,y,slot)=-6
                        endif
                    endif
                endif
            next
        next
        planetmap(p.x,p.y,slot)=-28
    next
    for x=0 to 60
        for y=0 to 20
            for x1=x-1 to x+1
                for y1=y-1 to y+1
                    if x1>=0 and y1>=0 and x1<=60 and y1<=20 then
                        if planetmap(x1,y1,slot)=-14 then camap(x,y)+=1
                        if planetmap(x1,y1,slot)=-8 then camap(x,y)+=1
                    endif
                next
            next
        next
    next
    for x=0 to 60
        for y=0 to 20
            if planetmap(x,y,slot)=-14 then
                if rnd_range(1,100)>88 then 
                    planetmap(x,y,slot)=-145
                else
                    if rnd_range(1,100)<camap(x,y) then planetmap(x,y,slot)=-158
                endif
            endif
        next
    next
    
    return 0
end function


function modsurface(a as short,o as short) as short
dim as integer x,y
    
    if o>6 and rnd_range(1,100)<35 then
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)=-1 or planetmap(x,y,a)=-20 then planetmap(x,y,a)=-26 
                if planetmap(x,y,a)=-2 or planetmap(x,y,a)=-21  then planetmap(x,y,a)=-26
                if planetmap(x,y,a)=-10 or planetmap(x,y,a)=-22 or planetmap(x,y,a)=-3 or planetmap(x,y,a)=-4 then planetmap(x,y,a)=-145
                if planetmap(x,y,a)=-11 or planetmap(x,y,a)=-25 then planetmap(x,y,a)=-145
                if planetmap(x,y,a)=-5 or planetmap(x,y,a)=-23 then planetmap(x,y,a)=-145
                if planetmap(x,y,a)=-6 or planetmap(x,y,a)=-24 then planetmap(x,y,a)=-145
                if planetmap(x,y,a)=-12 or planetmap(x,y,a)=-13 then planetmap(x,y,a)=-14
                if planetmap(x,y,a)=-8 or planetmap(x,y,a)=-13 then planetmap(x,y,a)=-7
            next
        next
    endif
    
    
    if planets(a).temp<0 then
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)=-1 then planetmap(x,y,a)=-260
                if planetmap(x,y,a)=-2 then planetmap(x,y,a)=-27 
            next
        next
    endif
    
    
    if planets(a).temp>100 and planets(a).temp<180 then
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,a))=1 or abs(planetmap(x,y,a))=2 then planetmap(x,y,a)=-12 
            next
        next
    endif
    
    if planets(a).temp>179 then
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)=-1 then 
                    planetmap(x,y,a)=-4
                    if rnd_range(1,100)>33 then planetmap(x,y,a)=-45
                endif
                if abs(planetmap(x,y,a))=2 then planetmap(x,y,a)=-45
                if abs(planetmap(x,y,a))=5 then planetmap(x,y,a)=-25
                if abs(planetmap(x,y,a))=6 then planetmap(x,y,a)=-25
                if abs(planetmap(x,y,a))=10 then planetmap(x,y,a)=-4
                if abs(planetmap(x,y,a))=11 then planetmap(x,y,a)=-4
                if abs(planetmap(x,y,a))=22 then planetmap(x,y,a)=-4
            next
        next
    endif
    
    if planets(a).atmos>=8 then
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,a))=1 then planetmap(x,y,a)=-20
                if abs(planetmap(x,y,a))=2 then planetmap(x,y,a)=-21
                if abs(planetmap(x,y,a))=10 then planetmap(x,y,a)=-22
                if abs(planetmap(x,y,a))=11 then planetmap(x,y,a)=-25
                if abs(planetmap(x,y,a))=5 then planetmap(x,y,a)=-23
                if abs(planetmap(x,y,a))=6 then planetmap(x,y,a)=-24
                if abs(planetmap(x,y,a))=12 and rnd_range(1,100)>33 then planetmap(x,y,a)=-13
            next
        next
    endif
    return 0
end function


function makeice(a as short,o as short) as short
    dim as short ice,x,y
    ice=(10-o)*rnd_range(5,10)
    if o<3 then ice=100
    if a<0 or a>1024 then print a
    for x=0 to 60
        for y=0 to 10
            if rnd_range(1,100)<=(100-(y*ice)) then
                if rnd_range(1,100)<65 then
                   
                    planetmap(x,y,a)=-14
                else
                    if rnd_range(1,100)<65 then
                        planetmap(x,y,a)=-7
                    else
                        planetmap(x,y,a)=-145
                    endif
                endif
            endif
            if rnd_range(1,100)<=(100-(y*ice)) then
               if rnd_range(1,100)<65 then
                    planetmap(x,20-y,a)=-14
                else
                    if rnd_range(1,100)<65 then
                        planetmap(x,20-y,a)=-7
                    else
                        planetmap(x,20-y,a)=-145
                    endif
                endif
            endif
        next
    next
    return 0
end function


function makecraters(a as short, o as short) as short
    dim as short x,y,d,b,b1,wx,wy,ice
    dim as _cords p3,p2,p1
    planets(a).water=0
    planets(a).atmos=1
    planets(a).grav=planets(a).grav-0.1
    
    for x=0 to 60
        for y=0 to 20
            if rnd_range(1,100)<60 then
                planetmap(x,y,a)=-4
            else
                planetmap(x,y,a)=-14
            endif
        next
    next
    b1=rnd_range(1,3)+rnd_range(1,3)+5
    for b=0 to b1
        wx=rnd_range(1,2)+rnd_range(1,3)+1
        wy=wx
        p1.x=rnd_range(0,(60-(wx*2)))
        p1.y=rnd_range(0,(20-(wy*2)))
        p2.x=p1.x+wx
        p2.y=p1.y+wy
        'do
        for x=0 to 60
            for y=0 to 20
                p3.x=x
                p3.y=y
                d=distance(p3,p2)                    
                if d=wy then
                    planetmap(x,y,a)=-8
                endif
                if d<wy then
                    planetmap(x,y,a)=-14
                endif
                if rnd_range(1,200)>197 then
                    p3=movepoint(p3,5)
                    planetmap(p3.x,p3.y,a)=-8
                endif
            next
        next
        wy=wy-1
        'loop until rnd_range(1,100)>11 
    next
    for b=0 to rnd_range(1,20)+rnd_range(1,10)+3
        planetmap(rnd_range(0,60),rnd_range(0,20),a)=-7
    next
    if rnd_range(1,100)<50 then makeice(a,o)
    return 0
end function



function makeislands(a as short, o as short) as short
    
dim as integer b,cir,r2,r,ry,bx,by,i,water,mount,mount2,sand,woods,x,y,highest,lowest
dim map(60,20) as short
dim as _cords p1,p2
dim as single elset1,elset2
dim as single rad
water=planets(a).water\10-1
if water>5 then water=5
sand=water+1
woods=sand+1
if water<1 then 
    elset1=-3
    elset2=-4
else
    elset1=-10
    elset2=-11
endif
    
cir=rnd_range(15,15+planets(a).water)
r2=rnd_range(2,4)
highest=0
for i=0 to cir 
    
    p1.x=rnd_range(0,60)
    p1.y=rnd_range(0,20)
    bx=rnd_range(2,r2*2)
    by=rnd_range(1,r2)
    do
        for rad=0 to 6.243 step .1
            x=cos(rad)*bx+p1.x
            y=sin(rad)*by+p1.y
            if x<0 then x=0
            if y<0 then y=0
            if x>60 then x=60
            if y>20 then y=20
            map(x,y)=map(x,y)+1
            if map(x,y)>highest then  highest=map(x,y)
        next
        bx=bx-1
        by=by-1
        if bx<0 then bx=0
        if by<0 then by=0
    loop until bx=0 and by=0
    
next
mount=highest-1
mount2=highest

for x=60 to 0 step -1
    for y=0 to 20
        select case map(x,y)
            case is<water
                planetmap(x,y,a)=-2
            case is=water
                planetmap(x,y,a)=-1
            case is=sand
                planetmap(x,y,a)=-12
            case is=woods
                if rnd_range(1,100)<66 and water>1 then
                    planetmap(x,y,a)=-5
                else
                    planetmap(x,y,a)=-6
                endif                    
            case is=mount
                planetmap(x,y,a)=-8
            case is=mount2
                planetmap(x,y,a)=-7
            case else
                if rnd_range(1,100)<66 then
                    planetmap(x,y,a)=elset2
                else
                    planetmap(x,y,a)=elset1
                endif
         end select
         map(x,y)=0
    next
next

b=100+rnd_range(25,50)+rnd_range(1,25)-planets(a).water
if b<=0 then b=rnd_range(1,10)+rnd_range(1,10)

for x=0 to b
    planetmap(p1.x,p1.y,a)=-8
    if rnd_range(1,100)<(80-planets(a).water) then
        p1=movepoint(p1,5)
    else
        p1.x=rnd_range(1,59)
        p1.y=rnd_range(1,19)
    endif    
next

togglingfilter(a)
togglingfilter(a,8,7)
makeice(a,o)
return 0
end function

function makeoceanworld(a as short,o as short) as short
    dim as short x,y,r,b,h
    dim as _cords p1,p2
    dim map(60,20) as byte
    for b=0 to rnd_range(10,20)+rnd_range(10,30)
        
        p1=rnd_point
        r=rnd_range(1,6)+rnd_range(0,5)            
        for x=0 to 60
            for y=0 to 20
                p2.x=x
                p2.y=y
                if distance(p1,p2)<=r then
                    map(x,y)=map(x,y)+1
                    if map(x,y)>h then h=map(x,y)
                endif
            next
        next
    next
    
    for x=0 to 60
        for y=0 to 20
            planetmap(x,y,a)=-2
            if map(x,y)>=h-2 then planetmap(x,y,a)=-1
            if map(x,y)>=h-1 and rnd_range(1,100)<66 then planetmap(x,y,a)=-165
        next
    next
    p1=rnd_point
    for b=0 to rnd_range(0,19)+rnd_range(0,19)
        if rnd_range(1,100)>33 then 
            p1=rnd_point
        else 
            p1=movepoint(p1,5)
        endif
        if p1.x=0 then p1.x=1
        if p1.y=0 then p1.y=1
        if p1.x=60 then p1.x=59
        if p1.y=20 then p1.y=19
        if rnd_range(1,100)<66 then
            planetmap(p1.x,p1.y,a)=-7
            planetmap(p1.x-1,p1.y,a)=-13
            planetmap(p1.x+1,p1.y,a)=-13
            planetmap(p1.x,p1.y-1,a)=-13
            planetmap(p1.x,p1.y+1,a)=-13
        else
            planetmap(p1.x,p1.y,a)=-28
            if planetmap(p1.x-1,p1.y,a)=-2 then planetmap(p1.x-1,p1.y,a)=-1
            if planetmap(p1.x+1,p1.y,a)=-2 then planetmap(p1.x+1,p1.y,a)=-1
            if planetmap(p1.x,p1.y-1,a)=-2 then planetmap(p1.x,p1.y-1,a)=-1
            if planetmap(p1.x,p1.y+1,a)=-2 then planetmap(p1.x,p1.y+1,a)=-1
        endif    
    next
    assert(pMakemonster<>null)
    planets(a).mon_template(0)=pMakemonster(24,a)
    planets(a).mon_template(1)=pMakemonster(10,a)
    makeice(a,o)
    return 0
end function

function makemossworld(a as short, o as short) as short
    dim as short x,y,r,b,h,l,t1,t2
    dim as _cords p1,p2
    dim map(60,20) as byte
    l=100
    for b=0 to 20+rnd_range(10,20)+rnd_range(10,30)
        
        p1=rnd_point
        r=rnd_range(1,3)+rnd_range(0,3)            
        for x=0 to 60
            for y=0 to 20
                if map(x,y)<l then l=map(x,y)
                
                p2.x=x
                p2.y=y
                if distance(p1,p2)<=r then
                    map(x,y)=map(x,y)+1
                    if map(x,y)>h then h=map(x,y)
                endif
            next
        next
    next   
    t1=rnd_range(l+3,h-1)
    t2=rnd_range(l+3,h-1)
    for x=0 to 60
        for y=0 to 20
            planetmap(x,y,a)=-102
            if map(x,y)=l then planetmap(x,y,a)=-2 
            if map(x,y)=l+1 then planetmap(x,y,a)=-1 
            if map(x,y)=l+2 then planetmap(x,y,a)=-103 
            if map(x,y)=h then planetmap(x,y,a)=-104
            if map(x,y)=t1 then planetmap(x,y,a)=-105
            if map(x,y)=t2 then planetmap(x,y,a)=-106
            if rnd_range(1,200)<12 then planetmap(x,y,a)=-146
        next
    next
    return 0
end function

function makecanyons(a as short, o as short) as short
    dim as _cords p1,p2
    dim as _rect r(128),t
    dim as short x,y,last,mi,wantsize,larga,largb,lno,b,c,d,cnt,old,bx,by
    dim as single rad
    planets(a).orbit=planets(a).orbit+3
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=-7
                
            next
        next
        
    last=0    
    wantsize=60 'chop to this size
    mi=3 'minimum
    
    r(0).x=0
    r(0).y=0
    r(0).h=20
    r(0).w=60
    
    do
        larga=0
        largb=0
        'find largestrect
        for b=0 to last
            if r(b).h>larga then 
                larga=r(b).h
                lno=b
            endif
            if r(b).w>larga then 
                larga=r(b).w
                lno=b
            endif
            if r(b).h*r(b).w>largb then
                largb=r(b).h*r(b).w
                lno=b
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
    for b=0 to last 
        p1.x=r(b).x+r(b).w/2-1+rnd_range(1,2)
        p1.y=r(b).y+r(b).h/2-1+rnd_range(1,2)
        bx=r(b).w/2-1
        by=r(b).h/2-1
        if bx<2 then bx=2
        if by<2 then by=2
        'if r(b).w*r(b).h>46 then 
            do
                for rad=0 to 6.243 step .1
                    x=cos(rad)*bx+p1.x
                    y=sin(rad)*by+p1.y
                    if x<0 then x=0
                    if y<0 then y=0
                    if x>60 then x=60
                    if y>20 then y=20
                    if rnd_range(1,100)<4 then planetmap(x,y,a)=-3
                    if rnd_range(1,100)<4 then planetmap(x,y,a)=-5
                    if rnd_range(1,100)<4 then planetmap(x,y,a)=-11
                    if rnd_range(1,100)<4 then planetmap(x,y,a)=-12
                    if rnd_range(1,100)<4 then planetmap(x,y,a)=-14
        '            planetmap(x,y,a)=-13
                next
                bx=bx-1
                by=by-1
                if bx<0 then bx=0
                if by<0 then by=0
            loop until bx=0 and by=0
        'endif
    next
    

    for b=0 to last step 2
        c=b+1
        p1.x=r(b).x+r(b).w/2
        p1.y=r(b).y+r(b).h/2
         
        p2.x=r(c).x+r(c).w/2
        p2.y=r(c).y+r(c).h/2
        cnt=0     
        do 
            cnt=cnt+1
            if rnd_range(1,100)<16 then planetmap(p2.x,p2.y,a)=-3
            if rnd_range(1,100)<16 then planetmap(p2.x,p2.y,a)=-5
            if rnd_range(1,100)<16 then planetmap(p2.x,p2.y,a)=-11
            if rnd_range(1,100)<16 then planetmap(p2.x,p2.y,a)=-12
            if rnd_range(1,100)<15 then planetmap(p2.x,p2.y,a)=-14
            d=nearest(p1,p2)
            if frac(d/2)<>0 then d=bestaltdir(d,rnd_range(0,1))
            if rnd_range(1,100)<15 then d=d+1
            p2=movepoint(p2,d)
        loop until distance(p1,p2)<1.5 or cnt>500        
    next    
    togglingfilter(a,8,7)
    togglingfilter(a,8,7)
    if rnd_range(1,100)<10 then
        planets(a).atmos=1
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)<>-7 and planetmap(x,y,a)<>-8 then 
                    if rnd_range(1,100)<66 then
                        planetmap(x,y,a)=-4
                    else
                        planetmap(x,y,a)=-14
                    endif
                    if rnd_range(1,100)<6 then planetmap(x,y,a)=-158
                endif
            next
        next
    endif
    planets(a).water=0
    if rnd_range(1,100)<50 then makeice(a,o)
    return 0
end function


function addportal(from as _cords, dest as _cords, oneway as short, tile as short,desig as string, col as short) as short
    dim as short e,a
    if from.x<0 then 
        rlprint "error. tried to create portal at from.x="&from.x
        dest.x=0
    endif
    if from.y<0 then 
        rlprint "error. tried to create portal at from.y="&from.y
        from.y=0
    endif
    if from.x>60 then
        rlprint "error. tried to create portal at from.x="&from.x 
        from.x=60
    endif
    if from.y>20 then 
        rlprint "error. tried to create portal at from.y="&from.y
        from.y=20
    endif
    
    if dest.x<0 then 
        rlprint "error. tried to create portal at dest.x="&dest.x
        dest.x=0
    endif
    if dest.y<0 then 
        rlprint "error. tried to create portal at dest.y="&dest.y
        dest.y=0
    endif
    if dest.x>60 then
        rlprint "error. tried to create portal at dest.x="&dest.x 
        dest.x=60
    endif
    if dest.y>20 then 
        rlprint "error. tried to create portal at Dest.y="&dest.y
        dest.y=20
    endif
    lastportal=lastportal+1
    portal(lastportal).from=from
    portal(lastportal).dest=dest
    portal(lastportal).oneway=oneway
    portal(lastportal).tile=tile
    portal(lastportal).col=col
    portal(lastportal).desig=desig
    portal(lastportal).discovered=show_all
    portal(lastportal).ti_no=3001
    if tile=asc("#") and col=14 then portal(lastportal).ti_no=3002
    if tile=asc("o") and col=14 then portal(lastportal).ti_no=3003
    if tile=asc(">") then portal(lastportal).ti_no=3004
    if tile=asc("^") then portal(lastportal).ti_no=250
    if tile=asc("@") then portal(lastportal).ti_no=3007
    if tile=asc("o") and col=7 then portal(lastportal).ti_no=3004
    if tile=asc("O") then portal(lastportal).ti_no=3006
    'rlprint chr(tile)&":"&portal(lastportal).ti_no
'    for e=0 to lastportal-1
'        for f=0 to lastportal-1
'            if f<>e then
'                if portal(e).from.x=portal(f).from.x and portal(e).from.y=portal(f).from.y and portal(e).from.m=portal(f).from.m then movepoint(portal(e).from,5)
'                if portal(e).dest.x=portal(f).from.x and portal(e).dest.y=portal(f).from.y and portal(e).dest.m=portal(f).from.m then movepoint(portal(e).from,5)
'                if portal(e).dest.x=portal(f).dest.x and portal(e).dest.y=portal(f).dest.y and portal(e).dest.m=portal(f).dest.m then movepoint(portal(e).from,5)
'            endif
'        next
'    next
    return 0
end function

function deleteportal(f as short=0, d as short=0) as short
    dim a as short
    for a=1 to lastportal
        if portal(a).from.m=f or portal(a).from.m=d then
            portal(a)=portal(lastportal)
            lastportal-=1
        endif
    next
    return 0
end function


function makesettlement(p as _cords,slot as short, typ as short) as short
    if typ=0 then
        if p.x>55 then p.x=55
        if p.y>15 then p.y=15
        planetmap(p.x+2,p.y,slot)=-228
        planetmap(p.x+2,p.y+1,slot)=-31
        planetmap(p.x,p.y+2,slot)=-228
        planetmap(p.x+1,p.y+2,slot)=-32
        planetmap(p.x+2,p.y+2,slot)=-229
        planetmap(p.x+3,p.y+2,slot)=-228
        planetmap(p.x+4,p.y+2,slot)=-32
        planetmap(p.x+5,p.y+2,slot)=-228
        planetmap(p.x+2,p.y+3,slot)=-31
        planetmap(p.x+2,p.y+4,slot)=-31
        planetmap(p.x+2,p.y+5,slot)=-228
    endif
    if typ=1 then
        if p.x>53 then p.x=53
        if p.y>13 then p.y=13
        planetmap(p.x+2,p.y-2,slot)=-228
        planetmap(p.x+2,p.y-1,slot)=-31
        planetmap(p.x+2,p.y,slot)=-228
        planetmap(p.x+2,p.y+1,slot)=-31
        planetmap(p.x,p.y+2,slot)=-228
        planetmap(p.x+1,p.y+2,slot)=-32
        planetmap(p.x+2,p.y+2,slot)=-229
        planetmap(p.x+3,p.y+2,slot)=-32
        planetmap(p.x+4,p.y+2,slot)=-32
        planetmap(p.x+5,p.y+2,slot)=-228
        planetmap(p.x+6,p.y+2,slot)=-32
        planetmap(p.x+7,p.y+2,slot)=-228
        planetmap(p.x+2,p.y+3,slot)=-31
        planetmap(p.x+2,p.y+4,slot)=-31
        planetmap(p.x+2,p.y+5,slot)=-228
    endif
    if typ=2 then
        if p.y>58 then p.y=58
        planetmap(p.x,p.y,slot)=-228
        planetmap(p.x,p.y+1,slot)=-31
        planetmap(p.x,p.y+2,slot)=-228
    endif
    if typ=3 then
        if p.x>53 then p.x=53
        if p.y>13 then p.y=13
        planetmap(p.x,p.y,slot)=-228
        planetmap(p.x,p.y+1,slot)=-31
        planetmap(p.x,p.y+2,slot)=-229
        planetmap(p.x+1,p.y,slot)=-32
        planetmap(p.x+2,p.y,slot)=-228
    endif
        
    return 0
end function

function makeroad(byval s as _cords,byval e as _cords, a as short) as short
    dim as short x,y
    do
        if s.x>e.x then s.x=s.x-1
        if s.x<e.x then s.x=s.x+1
        planetmap(s.x,s.y,a)=-31
        if s.y>e.y then s.y=s.y-1
        if s.y<e.y then s.y=s.y+1
        planetmap(s.x,s.y,a)=-32
    loop until s.x=e.x and s.y=e.y
    for x=1 to 59
            for y=1 to 19
                if planetmap(x,y,a)<-30 and planetmap(x,y,a)>-42 then
                    if (planetmap(x-1,y,a)<-30 and planetmap(x-1,y,a)>-42) or (planetmap(x+1,y,a)<-30 and planetmap(x+1,y,a)>-42) then planetmap(x,y,a)=-32
                    if (planetmap(x,y-1,a)<-30 and planetmap(x,y-1,a)>-42) or (planetmap(x,y+1,a)<-30 and planetmap(x,y+1,a)>-42) then planetmap(x,y,a)=-31
                    
                    if planetmap(x-1,y,a)<-30 and planetmap(x,y+1,a)<-30 and planetmap(x-1,y,a)>-42 and planetmap(x,y+1,a)>-42 then 'bow down
                        planetmap(x,y,a)=-34
                    endif
                    if planetmap(x-1,y,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x-1,y,a)>-42 and planetmap(x,y-1,a)>-42 then 'bow up
                        planetmap(x,y,a)=-35
                    endif
                    if planetmap(x+1,y,a)<-30 and planetmap(x,y+1,a)<-30 and planetmap(x+1,y,a)>-42 and planetmap(x,y+1,a)>-42 then 'bow down
                        planetmap(x,y,a)=-36
                    endif
                    if planetmap(x+1,y,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x+1,y,a)>-42 and planetmap(x,y-1,a)>-42 then 'bow up
                        planetmap(x,y,a)=-37
                    endif
                    
                    
                    if planetmap(x-1,y,a)<-30 and planetmap(x,y+1,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x,y+1,a)>-42 and planetmap(x,y-1,a)>-42 and planetmap(x-1,y,a)>-42 then 'bow down
                        planetmap(x,y,a)=-38
                    endif
                    if planetmap(x,y+1,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x+1,y,a)<-30 and planetmap(x,y+1,a)>-42 and planetmap(x,y-1,a)>-42 and planetmap(x+1,y,a)>-42  then 'bow up
                        planetmap(x,y,a)=-39
                    endif
                    if planetmap(x+1,y,a)<-30 and planetmap(x,y+1,a)<-30 and planetmap(x-1,y,a)<-30 and planetmap(x+1,y,a)>-42 and planetmap(x,y+1,a)>-42 and planetmap(x-1,y,a)>-42 then 'bow down
                        planetmap(x,y,a)=-40
                    endif
                    if planetmap(x+1,y,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x-1,y,a)<-30 and planetmap(x+1,y,a)>-42 and planetmap(x,y-1,a)>-42 and planetmap(x-1,y,a)>-42 then 'bow up
                        planetmap(x,y,a)=-41
                    endif
                    
                    if planetmap(x-1,y,a)<-30 and planetmap(x+1,y,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x,y+1,a)<-30 then
                        planetmap(x,y,a)=-33
                    endif
                endif
            next
        next
        
    return 0
end function


function findsmartest(slot as short) as short
    dim as short a,in,m
    for a=0 to 16
        if planets(slot).mon_template(a).intel>m then
            in=a
            m=planets(slot).mon_template(a).intel
        endif
    next
    return in
end function

function invisiblelabyrinth(tmap() as _tile,xoff as short ,yoff as short, _x as short=11, _y as short=11) as short
    dim map(_x,_y) as short
    dim as short x,y,a,b,c,count
    dim p as _cords
    dim p2 as _cords
    dim border as short   
    dim t as integer
    
    t=timer
    for x=0 to _x
        for y=0  to _y
            map(x,y)=1
            
        next
    next
    
    map(rnd_range(1,_x-1),rnd_range(1,_y-1))=0
    
    do
        count=count+1
        p.x=rnd_range(1,_x-1)
        p.y=rnd_range(1,_y-1)
        if map(p.x,p.y)=1 then
            if map(p.x-1,p.y)=0 or map(p.x,p.y+1)=0 or map(p.x+1,p.y)=0 or map(p.x,p.y-1)=0 then
                if map(p.x,p.y-1)=1 and map(p.x,p.y+1)=1 and map(p.x-1,p.y)=1 and map(p.x-1,p.y-1)=1 and map(p.x-1,p.y+1)=1 then map(p.x,p.y)=0
                if map(p.x,p.y-1)=1 and map(p.x,p.y+1)=1 and map(p.x+1,p.y)=1 and map(p.x+1,p.y-1)=1 and map(p.x+1,p.y+1)=1 then map(p.x,p.y)=0
                if map(p.x-1,p.y)=1 and map(p.x+1,p.y)=1 and map(p.x-1,p.y-1)=1 and map(p.x,p.y-1)=1 and map(p.x+1,p.y-1)=1 then map(p.x,p.y)=0
                if map(p.x-1,p.y+1)=1 and map(p.x,p.y+1)=1 and map(p.x-1,p.y)=1 and map(p.x+1,p.y)=1 and  map(p.x+1,p.y+1)=1 then map(p.x,p.y)=0
            endif
            if map(p.x,p.y)=0 then
                c=0
                for x=0 to _x
                    for y=0  to _y
                        if map(x,y)=0 then c=c+1
                    next
                next
            endif
        endif
    loop until c+rnd_range(1,20)>_x*_y*.6 or timer>t+15    

    for x=0 to 10
        for y=0 to 10
            if map(x,y)=0 then
                tmap(x+xoff,y+yoff).walktru=5
                tmap(x+xoff,y+yoff).desc="an invisible wall"
            else
                tmap(x+xoff,y+yoff).walktru=0
            endif
        next
    next
    tmap(30,10).walktru=0
    return 0
end function

function station_event(m as short) as short
    DimDebug(0)
    dim p as _cords
    dim as short c,s,i,j,r,r2

    for i=10 to 1 step -1
        if planets(m).mon_template(i).made=0 and s=0 then s=i
    next
    planets_flavortext(m)="Something is going on here today."
    r=rnd_range(1,100)
    r2=rnd_range(1,100)

#if __FB_DEBUG__
    if debug=1501 then 
        r=60
        r2=50
    endif
#endif
    
    assert(pMakemonster<>null)
    
    select case r
    case is<35 'Good stuff
        select case r2
            case 0 to 25
                planets(m).mon_template(s)=pMakemonster(98,m)
                planets(m).mon_noamin(s)=1
                planets(m).mon_noamax(s)=1
            case 26 to 50
                planets(m).flags(26)=7
                planetmap(39,1,m)=-268
                planetmap(38,1,m)=-267
                planetmap(40,1,m)=-267
                planetmap(40,2,m)=-267
                planetmap(38,2,m)=-267
            case 51 to 75
                planetmap(46,17,m)=-215
                planetmap(44,18,m)=-216
                planets(m).flags(26)=8
                planets(m).flags(12)=rnd_range(2,6)
                planets(m).flags(13)=rnd_range(2,6)
            case else
                planets(m).flags(26)=9 'Fuel shortage
                planets(m).flags(27)=0 
        end select
    case is>55 'Bad Stuff
        select case r2
            case 0 to 20
                planets(m).flags(26)=1 'Standard Critter loose
                planets(m).mon_template(s)=pMakemonster(1,m)
                planets(m).mon_noamin(s)=1
                planets(m).mon_noamax(s)=1
            case 21 to 40
                planets(m).flags(26)=4 'Crawling Shrooms loose
                planets(m).mon_template(s)=pMakemonster(34,m)
                planets(m).mon_noamin(s)=1
                planets(m).mon_noamax(s)=1
            case 41 to 60
                planets(m).flags(26)=5 'Pirate band attacking
                planets(m).mon_template(s)=pMakemonster(3,m)
                planets(m).mon_noamin(s)=1
                planets(m).mon_noamax(s)=3
                p=rnd_point(m,,203)
                planetmap(p.x,p.y,m)=-67
            case 61 to 80 'Tribble infestation
                planets(m).flags(26)=12
                planets(m).mon_template(s)=pMakemonster(80,m)
                planets(m).mon_noamin(s)=1
                planets(m).mon_noamax(s)=1
            case else
                planets(m).flags(26)=6 'Leak
                p=rnd_point(m,,243)
                planetmap(p.x,p.y,m)=-4
                'planets(m).atmos=1
        end select
    case else 'Neutral Stuff
        c=rnd_range(0,1)
        planets(m).flags(26)=10
        planets(m).mon_template(s)=civ(c).spec
        planets(m).mon_noamin(s)=1
        planets(m).mon_noamax(s)=3
        p=rnd_point(m,,203)
        
        planetmap(p.x,p.y,m)=-(272+c)
    end select
    'Clear cache
    
    for i=1 to 15 'Look for saved status on this planet
        if savefrom(i).map=m then
            for j=i to 14
                savefrom(j)=savefrom(j+1)
            next
            savefrom(15)=savefrom(0)
        endif
    next
    'CLEAN UP ROUTINE!!!!
    return 0
end function

function clean_station_event() as short
    dim as short a,m,x,y
    for a=1 to 3
        m=drifting(a).m
        planets(m).mon_noamin(2)=0
        planets(m).mon_noamax(2)=0
        if planets(m).flags(26)<>9 then 
            planets(m).flags(26)=0
            planets(m).flags(27)=0
            planets(m).atmos=5
            planets_flavortext(m)="A cheerful sign welcomes you to the station"
        endif
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,m)=268 then planetmap(x,y,m)=202 
                if planetmap(x,y,m)=-268 then planetmap(x,y,m)=-202 
                if planetmap(x,y,m)=267 then planetmap(x,y,m)=202 
                if planetmap(x,y,m)=-267 then planetmap(x,y,m)=-202 
                if planetmap(x,y,m)=215 then planetmap(x,y,m)=202 
                if planetmap(x,y,m)=-215 then planetmap(x,y,m)=-202 
                if planetmap(x,y,m)=216 then planetmap(x,y,m)=202 
                if planetmap(x,y,m)=-216 then planetmap(x,y,m)=-202 
                if planetmap(x,y,m)=67 then planetmap(x,y,m)=203
                if planetmap(x,y,m)=-67 then planetmap(x,y,m)=-203
                if planetmap(x,y,m)=4 then planetmap(x,y,m)=243
                if planetmap(x,y,m)=-4 then planetmap(x,y,m)=-243 
            next
        next
    next
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


function makeoutpost (slot as short,x1 as short=0, y1 as short=0) as short
    dim as short x,y,a,w,h
    if x1=0 then x1=rnd_range(1,59)
    if y1=0 then y1=rnd_range(1,19)
    h=rnd_range(4,7)
    w=rnd_range(4,7)
    if x1+w>57 then x1=57-w
    if y1+h>17 then y1=17-h
    for x=x1 to x1+w
        for y=y1 to y1+h
            if rnd_range(1,100)<88 then planetmap(x,y,slot)=-16
            if rnd_range(1,100)<18 then planetmap(x,y,slot)=-68
            
        next
    next
    for w=0 to 5
        x=rnd_range(x1-1,x1+w+1)
        y=rnd_range(y1-1,y1+h+1)
        if rnd_range(1,100)<9 then planetmap(x,y,slot)=-69-w
    next        
    y=rnd_range(y1+1,y1+h-2)
    for x=x1 to x1+w
        planetmap(x,y,slot)=-32
    next
    
    x=rnd_range(x1+1,x1+w-2)
    for y=y1 to y1+h
        if planetmap(x,y,slot)<>-32 then
        planetmap(x,y,slot)=-31
    else
        planetmap(x,y,slot)=-33
        endif
    next
    if faction(0).war(2)<50 then
        for x=x1 to x1+w
            for y=y1 to y1+h
                planetmap(x,y,slot)=-planetmap(x,y,slot)
            next
        next
    endif
    return 0
end function


function make_drifter(d as _driftingship, bg as short=0,broken as short=0,f2 as short=0) as short
    DimDebugL(0)
    dim as short a,m,roll,x,y,f,ti,xs,ys,x2,y2,addweap,addcarg,ff,fc,wc,i,j,l
    dim as byte retirementshop,antiques,oneway,lockermap(60,20)
    dim as short randomshop(8),lastrandomshop
    dim s as _ship
    dim pods(6,5,1) as short
    dim as _cords p,p2
    dim crates(254) as _cords
    dim from as _cords
    dim dest as _cords
    dim lastcrate as short
    
    randomshop(1)=262 'Mudds
    randomshop(2)=270 'Retirement
    randomshop(3)=261 'Hospital
    randomshop(4)=294 'Antiques
    randomshop(5)=109 'Bot-Bin
    randomshop(6)=98 'Black Market
    lastrandomshop=6 '
    
#if __FB_DEBUG__
    if debug=18 then d.s=18
#endif
    
    if bg=0 then
        m=d.m
    else
        lastplanet+=1
        m=lastplanet
        from.x=d.x
        from.y=d.y
        from.m=d.m
        d.m=m
    endif
    d.g_tile.x=rnd_range(1,8)
    if d.g_tile.x>=5 then d.g_tile.x+=1
    d.g_tile.y=d.s+51
    if d.s=19 then d.g_tile.y=49
    if d.s=18 then d.g_tile.y=68
    if d.s=17 then d.g_tile.y=48 'Generation Ship
    if d.s=20 then d.g_tile.y=47 'Small station
    load_map(d.s,lastplanet) 
    planets(m).flags(1)=d.s
    d.start.x=d.x
    d.start.y=d.y
    f=freefile
    open "data/pods.dat" for binary as #f
    for a=0 to 1
        for y=0 to 5
            for x=0 to 6
                get #f,,pods(x,y,a)
            next
        next
    next
    close #f
    if f2>0 then 
        print #f2,"Getting hullspecs"&d.s
    endif
    s=gethullspecs(d.s,"data/ships.csv")
    if bg=0 then
        addweap=s.h_maxweaponslot*10
        addcarg=s.h_maxcargo*10
        for a=6 to 6+s.h_maxweaponslot
            if rnd_range(1,100)<66 then planets(m).flags(a)=rnd_range(1,6)
            if rnd_range(1,100)<16+addweap then planets(m).flags(a)=planets(m).flags(a)+rnd_range(0,4)
            if rnd_range(1,100)<25 then planets(m).flags(a)=-rnd_range(1,2)
            if planets(m).flags(a)=-1 then addcarg=addcarg+10
            if planets(m).flags(a)=-2 then s.h_maxcrew=s.h_maxcrew+3
        next
        for a=6 to 6+s.h_maxweaponslot
            if planets(m).flags(a)>0 and planets(m).flags(a)<=10 then
                planets(m).weapon(a-6)=make_weapon(planets(m).flags(a))
            endif
        next
    endif
    for x=0 to 60
        for y=0 to 20
            ti=abs(planetmap(x,y,m))
            if ti>=209 and ti<=214 then
                ti=ti-203
                if planets(m).flags(ti)<0 then
                    if y<10 then a=1
                    if y>9 then a=0
                    xs=x-3
                    if a=1 then
                        ys=y-5
                    else
                        ys=y
                    endif
                    if xs<0 then xs=0
                    if ys<0 then ys=0
                    if xs+6>60 then xs=54
                    if ys+5>20 then ys=15
                    for x2=xs to xs+6
                        for y2=ys to ys+5
                            if pods(x2-xs,y2-ys,a)<>-200 then planetmap(x2,y2,m)=pods(x2-xs,y2-ys,a)
                            if planets(m).flags(ti)=-1 and x2<>xs+3 and planetmap(x2,y2,m)=-202 and rnd_range(1,100)<33 then planetmap(x2,y2,m)=-223 
                            if planets(m).flags(ti)=-2 and x2<>xs+3 and planetmap(x2,y2,m)=-202 and rnd_range(1,100)<33 then planetmap(x2,y2,m)=-224
                            if planets(m).flags(ti)=-3 and x2<>xs+3 and planetmap(x2,y2,m)=-202 and rnd_range(1,100)<33 then planetmap(x2,y2,m)=-221
                        next
                    next
                endif
            endif
            if ti=202 then 'floor then
                fc=0
                wc=0
                for x2=x-1 to x+1
                    for y2=y-1 to y+1
                        if x2>=0 and x2<=60 and y2>=0 and y2<=20 then
                            if planetmap(x2,y2,m)=-202 then fc+=1
                            if planetmap(x2,y2,m)=-201 then wc+=1
                        endif
                    next
                next
                if fc>3 and wc>=3 and wc<>6 then lockermap(x,y)=1
                if fc=2 and wc=8 then lockermap(x,y)=1
                if fc=5 and wc=4 then lockermap(x,y)=0
            endif
            if ti=999 then
                planetmap(x,y,m)=-202
                if rnd_range(1,100)<66 then 'Random Shops
                    ti=rnd_range(1,lastrandomshop)
                    planetmap(x,y,m)=-randomshop(ti)
                    randomshop(ti)=randomshop(lastrandomshop)
                    lastrandomshop-=1
                endif
            endif
        next
    next
    
    
    if d.s=18 and bg=0 then 'Drifting alien ship
        for i=1 to rnd_range(4,10)+rnd_range(4,10)            
            p=rnd_point
            select case rnd_range(1,9)
            case 1
                p.x=0
                a=6
                l=15
            case 2
                p.x=60
                a=4
                l=15
            case 3 to 6
                p.y=0
                a=rnd_range(1,3)
                l=5
            case 7 to 9
                p.y=20
                a=rnd_range(7,9)
                l=5
            end select
            for j=1 to rnd_range(1+l,5+l)
                p2=p
                if (abs(planetmap(p.x,p.y,m))=201 or planetmap(p.x,p.y,m)) and rnd_range(1,100)<50 then planetmap(p.x,p.y,m)=-199
                if abs(planetmap(p.x,p.y,m))<>203 and abs(planetmap(p.x,p.y,m))<>199 then planetmap(p.x,p.y,m)=-200
                if rnd_range(1,100)<25 then
                    p=movepoint(p2,4)
                    if (abs(planetmap(p.x,p.y,m))=201 or planetmap(p.x,p.y,m)) and rnd_range(1,100)<50 then planetmap(p.x,p.y,m)=-199
                    if abs(planetmap(p.x,p.y,m))<>203 and abs(planetmap(p.x,p.y,m))<>199 then planetmap(p.x,p.y,m)=-200
                    p=movepoint(p2,6)
                    if (abs(planetmap(p.x,p.y,m))=201 or planetmap(p.x,p.y,m)) and rnd_range(1,100)<50 then planetmap(p.x,p.y,m)=-199
                    if abs(planetmap(p.x,p.y,m))<>203 and abs(planetmap(p.x,p.y,m))<>199 then planetmap(p.x,p.y,m)=-200
                    p=movepoint(p2,2)
                    if (abs(planetmap(p.x,p.y,m))=201 or planetmap(p.x,p.y,m)) and rnd_range(1,100)<50 then planetmap(p.x,p.y,m)=-199
                    if abs(planetmap(p.x,p.y,m))<>203 and abs(planetmap(p.x,p.y,m))<>199 then planetmap(p.x,p.y,m)=-200
                    p=movepoint(p2,8)
                    if (abs(planetmap(p.x,p.y,m))=201 or planetmap(p.x,p.y,m)) and rnd_range(1,100)<50 then planetmap(p.x,p.y,m)=-199
                    if abs(planetmap(p.x,p.y,m))<>203 and abs(planetmap(p.x,p.y,m))<>199 then planetmap(p.x,p.y,m)=-200
                endif
                if rnd_range(1,100)<50 then
                    p=movepoint(p2,a)
                else
                    p=movepoint(p2,5)
                endif
            next
        next
    endif
    
    
    for x=1 to 59
        for y=1 to 19
            ti=abs(planetmap(x,y,m))
            if ti=204 or ti=205 then
                lockermap(x-1,y)=0
                lockermap(x+1,y)=0
                lockermap(x,y+1)=0
                lockermap(x,y-1)=0
            endif    
            if ti=203 or tiles(ti).gives<>0 then
                for x2=x-1 to x+1
                    for y2=y-1 to y+1
                        lockermap(x2,y2)=0
                    next
                next
            endif
        next
    next
    
    for x=0 to 60
        for y=0 to 20
            'if lockermap(x,y)=1 then planetmap(x,y,m)=-221
            if abs(planetmap(x,y,m))=204 and rnd_range(1,100)<66 then planetmap(x,y,m)=-205
            if abs(planetmap(x,y,m))=202 and rnd_range(1,100)<8 and (d.s<=19) then 
                if lockermap(x,y)=1 then 
                    planetmap(x,y,m)=-221
                    if rnd_range(1,100)<66 then planetmap(x,y,m)=-222
                    for a=0 to rnd_range(0,1)
                        if bg=0 then placeitem(rnd_item(RI_StrandedShip),x,y,m)
                    next
                    if lockermap(x-1,y)=0 then lockermap(x+1,y)=2
                    if lockermap(x+1,y)=0 then lockermap(x-1,y)=2
                    if lockermap(x,y-1)=0 then lockermap(x,y+1)=2
                    if lockermap(x,y+1)=0 then lockermap(x,y-1)=2
                endif
            endif
            if abs(planetmap(x,y,m))=223 then
                lastcrate=lastcrate+1
                crates(lastcrate).x=x
                crates(lastcrate).y=y
            endif
        next
    next
    
    for x=0 to 60
        for y=0 to 20
            if abs(planetmap(x,y,m))=200 and bg<>0 then planetmap(x,y,m)=-bg
        next
    next
    if bg=0 then
        if s.h_maxcargo>5 then s.h_maxcargo=5
        for a=1 to s.h_maxcargo
            if rnd_range(1,100)>25+addcarg then
                p=crates(rnd_range(1,lastcrate))
                planetmap(p.x,p.y,m)=-214-a
                planets(m).flags(10+a)=rnd_range(2,6)
            endif
        next
    endif
    for x=1 to 59
        for y=1 to 19
            if abs(planetmap(x,y,m))=201 then 
                if abs(planetmap(x-1,y,m))=200 or abs(planetmap(x+1,y,m))=200 or abs(planetmap(x,y+1,m))=200 or abs(planetmap(x,y-1,m))=200 then planetmap(x,y,m)=-243
                if abs(planetmap(x-1,y-1,m))=200 or abs(planetmap(x+1,y+1,m))=200 or abs(planetmap(x-1,y+1,m))=200 or abs(planetmap(x+1,y-1,m))=200 then planetmap(x,y,m)=-243
            endif
        next
    next
    
    for x=0 to 60
        for y=0 to 20
            if (x=0 or y=0 or x=60 or y=20) and abs(planetmap(x,y,m))=201 then planetmap(x,y,m)=-243
        next
    next
    
    assert(pMakemonster<>null)
        
    planets(m).depth=1
    if bg=0 then
        
        roll=rnd_range(1,100)
        select case roll
        case 0 to 39
            planets(m).darkness=0
            planets(m).depth=1
            planets(m).atmos=4
            
            planets(m).mon_template(0)=pMakemonster(32,m)
            planets(m).mon_noamin(0)=s.h_maxcrew-1
            planets(m).mon_noamax(0)=s.h_maxcrew
            
            planets(m).mon_template(1)=pMakemonster(33,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            
            planets_flavortext(m)="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        case 40 to 50
            planets(m).darkness=5
            planets(m).depth=1
            planets(m).atmos=1
            planets(m).mon_template(0)=pMakemonster(33,m)
            planets(m).mon_noamin(0)=minimum(1,s.h_maxcrew-3)
            planets(m).mon_noamax(0)=s.h_maxcrew
            
            planets(m).mon_template(1)=pMakemonster(33,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            planets_flavortext(m)="It is dark as you enter the " &shiptypes(d.s)&". A thin layer of ice covers everything. The air is gone. You feel like defiling a grave."
        
        case 50 to 60
            planets(m).darkness=5
            planets(m).depth=1
            planets(m).atmos=1
            planets(m).mon_template(0)=pMakemonster(31,m)
            planets(m).mon_noamin(0)=minimum(1,s.h_maxcrew-3)
            planets(m).mon_noamax(0)=s.h_maxcrew
            
            planets(m).mon_template(1)=pMakemonster(33,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            
            planets_flavortext(m)="It is dark as you enter the " &shiptypes(d.s)&". A thin layer of ice covers everything. The air is gone. No sound reaches you through the vacuum but you see red alert lights still flashing."
        case 60 to 70
            planets(m).darkness=0
            planets(m).depth=1
            planets(m).atmos=4
            planets(m).mon_template(0)=pMakemonster(34,m)
            planets(m).mon_noamin(0)=d.s+10
            planets(m).mon_noamax(0)=d.s+15
            
            planets_flavortext(m)="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale. An alert klaxon is the only sound you hear."
        
        
        case 70 to 80
            planets(m).darkness=0
            planets(m).depth=1
            planets(m).atmos=4
            planets(m).mon_template(0)=pMakemonster(3,m)
            planets(m).mon_noamin(0)=1
            planets(m).mon_noamax(0)=2
            planets_flavortext(m)="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        case 80 to 85
            planets(m).darkness=0
            planets(m).depth=1
            planets(m).atmos=4
            planets(m).mon_template(0)=pMakemonster(18,m)
            planets(m).mon_noamin(0)=1
            planets(m).mon_noamax(0)=2
            
            planets(m).mon_template(1)=pMakemonster(18,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            
            planets_flavortext(m)="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        case 85 to 90
            planets(m).darkness=0
            planets(m).depth=1
            planets(m).atmos=4
            
            planets(m).mon_template(0)=pMakemonster(19,m)
            planets(m).mon_noamin(0)=1
            planets(m).mon_noamax(0)=2
            planets_flavortext(m)="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        
        case 90 to 95
            planets(m).darkness=0
            planets(m).depth=1
            planets(m).atmos=4
            planets(m).mon_template(0)=pMakemonster(35,m)
            planets(m).mon_noamin(0)=1
            planets(m).mon_noamax(0)=2
            
            planets(m).mon_template(1)=pMakemonster(35,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            
            planets_flavortext(m)="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        case 90 to 98
        
        
            planets(m).darkness=0
            planets(m).depth=1
            planets(m).atmos=4
            planets(m).mon_template(0)=pMakemonster(65,m)
            planets(m).mon_noamin(0)=minimum(1,s.h_maxcrew-3)
            planets(m).mon_noamax(0)=s.h_maxcrew
            
            planets(m).mon_template(1)=pMakemonster(29,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            
            planets_flavortext(m)="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale. An alert klaxon is the only sound you hear."
        
        
        case else
            planets(m).darkness=5
            planets(m).depth=1
            planets(m).atmos=4
            
            planets(m).mon_template(0)=pMakemonster(38,m)
            planets(m).mon_noamin(0)=1
            planets(m).mon_noamax(0)=1
            
            planets(m).mon_template(1)=pMakemonster(47,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=1
            
            planets_flavortext(m)="As you enter this " &shiptypes(d.s)& " you hear a squeaking noise almost like a jiggle. You feel uneasy. Something is here, and it is not friendly." 
        end select

    else
        'On planets surface
        oneway=0
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,m))=203 then 'Add portals from airlocks to planet surfaces
                    dest.x=x
                    dest.y=y
                    dest.m=lastplanet
                    addportal(dest,from,1,asc("@"),"airlock",11)
                    
                endif
            next
        next
        addportal(from,dest,1,asc("@"),"Abandoned ship",11)
        addportal(dest,from,2,asc(" "),"",11)
        for x=0 to 60
            for y=0 to 20
                if broken=1 and abs(planetmap(x,y,m))=220 then planetmap(x,y,m)=-202
            next
        next
        if d.s=18 and broken=0 then planetmap(30,20,m)=-220
        m=dest.m
        planets(m).atmos=planets(from.m).atmos
        planets(m).grav=planets(from.m).grav
    endif
    
    if planets(m).atmos>0 then planets(m).temp=20+rnd_range(1,20)/10
    
    planets(m).flags(0)=0
    planets(m).flags(1)=d.s
    planets(m).flags(2)=rnd_range(1,s.h_maxhull)
    planets(m).flags(3)=rnd_range(1,s.h_maxengine)
    planets(m).flags(4)=rnd_range(1,s.h_maxsensors)
    planets(m).flags(5)=rnd_range(0,s.h_maxshield)
    select case d.s
    case 20
        planets(m).wallset=rnd_range(7,9)
    case 18
        planets(m).wallset=rnd_range(10,11)
    case 17,19
        planets(m).wallset=rnd_range(12,13)
    case else
        planets(m).wallset=rnd_range(0,7)
    end select
    
#if __FB_DEBUG__
    if debug=18 then
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,m)=abs(planetmap(x,y,m))
            next
        next
    endif
#endif
    
    if d.s=20 and debug=2412 then
        planets(m).mon_template(3)=pMakemonster(34,m)
        planets(m).mon_noamin(3)=5
        planets(m).mon_noamax(3)=5
    endif
    
    if d.s=20 and (rnd_range(1,100)<10 or debug>0) then
        from.x=38
        from.y=1
        from.m=lastplanet
        lastplanet+=1
        dest=from
        dest.m=lastplanet
        load_map(d.s,lastplanet)
        addportal(from,dest,1,asc(">"),"Stairs going down.",9)
        addportal(dest,from,1,asc(">"),"Stairs going up.",9)
        a=0
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,lastplanet)=-999 then planetmap(x,y,lastplanet)=-202
                if planetmap(x,y,lastplanet)=-203 then planetmap(x,y,lastplanet)=-201 
                if tiles(abs(planetmap(x,y,lastplanet))).gives>0 then planetmap(x,y,lastplanet)=-202 
                if planetmap(x,y,lastplanet)=-202 and rnd_range(1,100)<50-a*10 and a<5 then 
                    planetmap(x,y,lastplanet)=-1*(215+a)
                    a+=1
                endif
                if planetmap(x,y,lastplanet)=-202 and rnd_range(1,100)<15 then
                    planetmap(x,y,lastplanet)=-222
                    p.x=x
                    p.y=y
                    if rnd_range(1,100)<15 then
                        for a=0 to rnd_range(0,2)
                            if rnd_range(1,100)<50 then
                                placeitem(rnd_item(RI_weakstuff),x,y,lastplanet)
                            else
                                placeitem(rnd_item(RI_weakweapons),x,y,lastplanet)
                            endif
                        next
                    endif
                endif
            next
        next
        
        planets(dest.m)=planets(from.m)
        planets(dest.m).atmos=4
        deletemonsters(dest.m)
        
        for a=12 to 16
            if rnd_range(1,100)<15 then planets(dest.m).flags(a)=rnd_range(2,3)
        next
        
        if rnd_range(1,100)<10 then
            planets(dest.m).mon_template(0)=pMakemonster(1,dest.m)
            planets(dest.m).mon_template(0).aggr=0
            planets(dest.m).mon_noamin(0)=1
            planets(dest.m).mon_noamax(0)=5
        endif
        
        if rnd_range(1,100)<50 or debug>0 then
            planets(dest.m).mon_template(1)=pMakemonster(104,dest.m)
            planets(dest.m).mon_noamin(1)=1
            planets(dest.m).mon_noamax(1)=5
        endif
    endif
    return 0
end function




function is_drifter(m as short) as short
    dim a as short
    for a=1 to lastdrifting
        if m=drifting(a).m then return -1
    next
    return 0
end function


function make_aliencolony(slot as short,map as short, popu as short) as short
    dim as short a,x,y,xw,yw,sh
    dim as _cords p,p2,ps(20)
    if civ(slot).phil=1 then
        for a=0 to popu*10
            p=rnd_point
            planetmap(p.x,p.y,map)=-274-slot
        next
        for a=0 to popu*3
            p=rnd_point
            planetmap(p.x,p.y,map)=-68
            if rnd_range(1,100)<civ(slot).tech*10 then planetmap(p.x,p.y,map)=-272-slot
        next
    endif
    if civ(slot).phil=2 then
        for a=0 to popu*10
            if a<=20 then ps(a)=rnd_point
        next
        for a=0 to popu*10-1 step 2 
            if a<=19 then makeroad(ps(a),ps(a+1),map)
        next
        for a=0 to popu*10
            if a<=20 then 
                p=ps(a)
            else
                p=rnd_point
            endif
            if p.x<1 then p.x=1
            if p.x>59 then p.x=59
            if p.y<1 then p.y=1
            if p.y>19 then p.y=19
            planetmap(p.x,p.y,map)=-274-slot
            planetmap(p.x,p.y-1,map)=-274-slot
            planetmap(p.x,p.y+1,map)=-274-slot
            planetmap(p.x+1,p.y,map)=-274-slot
            planetmap(p.x-1,p.y,map)=-274-slot
        next
        for a=1 to rnd_range(1,3)
            p=rnd_point
            xw=rnd_range(2,4)
            yw=rnd_range(2,4)
            for x=p.x to p.x+xw
                for y=p.y to p.y+yw
                    if x>=0 and x<=60 and y>=0 and y<=20 then
                        planetmap(x,y,map)=-68
                        if rnd_range(1,100)<civ(slot).tech*10 then planetmap(x,y,map)=-272-slot
                    endif
                next
            next
        next
    endif
    if civ(slot).phil=3 then
        p=rnd_point
        for x=p.x-10 to p.x+10
            for y=p.y-10 to p.y+10
                if x>=0 and x<=60 and y>=0 and y<=20 then
                    p2.x=x
                    p2.y=y
                    if distance(p2,p)<popu+2 then planetmap(x,y,map)=-68
                    if rnd_range(1,100)<civ(slot).tech*10 then planetmap(p.x,p.y,map)=-272-slot
                    if distance(p2,p)<popu then planetmap(x,y,map)=-274-slot
                endif
            next
        next
        planetmap(p.x,p.y,map)=-68
    endif
    if civ(slot).inte=2 then
        sh=3
    else
        sh=1
    endif
    for a=0 to sh
        if rnd_range(1,100)<(popu+sh)*5 then
            p=rnd_point(map,0)
            planetmap(p.x,p.y,map)=-280-slot
        endif
    next
    return 0
end function




function addpyramid(p as _cords, slot as short) as short
    dim as _cords from,dest
    dim as short i,vt
    dim as integer x,y
    dim as _rect r
    p=movepoint(p,5)
    from.x=p.x
    from.y=p.y
    from.m=slot
    lastplanet=lastplanet+1
    makelabyrinth(lastplanet)
    planets(lastplanet).depth=1

	assert(pMakemonster<>null)
    planets(lastplanet).mon_template(0)=pMakemonster(21,lastplanet)
    planets(lastplanet).mon_noamin(0)=10
    planets(lastplanet).mon_noamax(0)=20
    planets(lastplanet).atmos=planets(slot).atmos
    for i=0 to rnd_range(2,6)+rnd_range(1,6)+rnd_range(2,6)
        p=rnd_point(lastplanet,0)
        if i<6 then placeitem(make_item(96,-2,-3),p.x,p.y,lastplanet)
        if i>6 then placeitem(make_item(94),p.x,p.y,lastplanet)
    next                 
    for i=0 to rnd_range(1,6)+rnd_range(1,6)
        p=rnd_point(lastplanet,0)
        placeitem(make_item(96,-2,-3),p.x,p.y,lastplanet)
    next
    
    if rnd_range(1,100)<5 then
        p=rnd_point(lastplanet,0)
        planetmap(p.x,p.y,lastplanet)=225
        placeitem(make_item(97),p.x,p.y,lastplanet)
        placeitem(make_item(98),p.x,p.y,lastplanet)
    endif
    
    if rnd_range(1,100)<55 or addpyramids=1 then
        vt=rnd_range(1,6)
        p=rnd_point
        x=rnd_range(6,9)+rnd_range(0,3)
        y=rnd_range(5,7)+rnd_range(0,2)
        if p.x+x>=59 then p.x=58-x
        if p.y+y>=19 then p.y=18-y
        if p.x=0 then p.x=1
        if p.y=0 then p.y=1
        if p.x+x>=59 then x=59-p.x
        if p.y+y>=19 then y=19-p.y
        r.x=p.x
        r.y=p.y
        r.w=x
        r.h=y
        for x=r.x to r.x+r.w
            for y=r.y to r.y+r.h
                planetmap(x,y,lastplanet)=-4
                if x=r.x or x=r.x+r.w or y=r.y or y=r.y+r.h then
                    planetmap(x,y,lastplanet)=-51
                    if vt=5 then 
                        planetmap(x,y,lastplanet)=-50
                        placeitem(make_item(96,-2,-3),x,y,lastplanet)
                        placeitem(make_item(96,-2,-3),x,y,lastplanet)
                    endif
                    if rnd_range(1,100)<33 then
                        if planetmap(x-1,y,lastplanet)=-4 then planetmap(x,y,lastplanet)=-151
                        if planetmap(x+1,y,lastplanet)=-4 then planetmap(x,y,lastplanet)=-151
                        if planetmap(x,y-1,lastplanet)=-4 then planetmap(x,y,lastplanet)=-151
                        if planetmap(x,y+1,lastplanet)=-4 then planetmap(x,y,lastplanet)=-151
                    endif
                else
                    if vt=2 then planetmap(x,y,lastplanet)=-154
                endif
            next
        next
        if vt<5 then
            for i=0 to rnd_range(1,6)+rnd_range(1,6)+vt
                p.x=rnd_range(r.x+1,r.x+r.w-2)
                p.y=rnd_range(r.y+1,r.y+r.h-2)
                placeitem(make_item(96,-2,-3),p.x,p.y,lastplanet)
                p.x=rnd_range(r.x+1,r.x+r.w-2)
                p.y=rnd_range(r.y+1,r.y+r.h-2)
                placeitem(make_item(94),p.x,p.y,lastplanet)
            next
        endif
        if vt=3 or vt=5 then
            planets(lastplanet).vault(0)=r
            planets(lastplanet).vault(0).wd(5)=2
            planets(lastplanet).vault(0).wd(6)=rnd_range(66,68)
        endif
        if vt=4 then
            planets(lastplanet).vault(0)=r
            planets(lastplanet).vault(0).wd(5)=2
            planets(lastplanet).vault(0).wd(6)=rnd_range(16,18)
        endif
        if vt=6 then
            planets(lastplanet).vault(0)=r
            planets(lastplanet).vault(0).wd(5)=2
            planets(lastplanet).vault(0).wd(6)=rnd_range(16,18)
            for x=r.x to r.x+r.w
                for y=r.y to r.y+r.h
                    if x=r.x+1 or x=r.x+r.w-1 or y=r.y+1 or y=r.y+r.h-1 then planetmap(x,y,lastplanet)=-225
                    if x=r.x+r.w/2 and y=r.x+r.h/2 then planetmap(x,y,lastplanet)=-225
                next
            next
        endif
    endif
        
    p=rnd_point(slot,0)
    
    do
        p=rnd_point(lastplanet,0)
    loop until not (p.x>r.x and p.x<r.x+r.w and p.y>r.y and p.y<r.y+r.h)
    dest.x=p.x
    dest.y=p.y
    dest.m=lastplanet
    if addpyramids=1 then rlprint "Pyramid at "&from.x &":"& from.y
    addportal(from,dest,1,asc("^"),"A pyramid with an entry.",14)
    addportal(dest,from,1,asc("o"),"The exit.",7)
    
    return 0
end function


function remove_doors(map() as short) as short
    dim as short x,y,last,a,c
    dim as _cords ps(1200)
    for x=0 to 60
        for y=0 to 20
            if map(x,y)=3 then
                last+=1
                ps(last).x=x
                ps(last).y=y
            endif
        next
    next
    if last>0 then
        for a=1 to last
            c=0
            map(ps(a).x,ps(a).y)=1
            floodfill4(map(),1,1)
            for x=0 to 60
                for y=0 to 20
                    if map(x,y)=2 or map(x,y)=0 then c+=1
                    if map(x,y)>9 then map(x,y)=map(x,y)-10
                next
            next
            if c>0 then map(ps(a).x,ps(a).y)=3
        next
    endif
    return 0
end function


function add_door2(map() as short) as short
    dim ps(1200) as _cords
    dim pc(1200) as short
    dim as short last,x,y,a,c
    dim as _cords p
    for x=1 to 59
        for y=1 to 19
            if map(x,y)=1 or map(x,y)=2 then
                if map(x-1,y)=2 and map(x+1,y)=2 then
                    if map(x,y+1)=1 and map(x,y-1)=1 then
                        last+=1
                        ps(last).x=x
                        ps(last).y=y
                    endif
                endif
                if map(x,y-1)=2 and map(x,y+1)=2 then
                    if map(x-1,y)=1 and map(x+1,y)=1 then
                        last+=1
                        ps(last).x=x
                        ps(last).y=y
                    endif
                endif
            endif
        next
    next
    for a=1 to last
        pc(a)=20
        x=ps(a).x
        y=ps(a).y
        c=0
        if map(x-1,y-1)=1 then c+=1
        if map(x+1,y-1)=1 then c+=1
        if map(x-1,y+1)=1 then c+=1
        if map(x+1,y+1)=1 then c+=1
        if c=1 then pc(a)+=10
        if c=2 then pc(a)+=30
        if c=3 then pc(a)+=20
        if c=4 then pc(a)-=10
    next
    c=rnd_range(1,last)
    if rnd_range(1,100)<pc(c) then map(ps(c).x,ps(c).y)=3
    return 0
end function


function add_door(map() as short) as short
    dim ps(1200) as _cords
    dim as short last,x,y
    dim as _cords p
    for x=1 to 59
        for y=1 to 19
            p.x=x
            p.y=y
            if map(p.x,p.y)=1 and map(p.x-1,p.y)=1 and map(p.x+1,p.y)=1 then
                if (map(p.x,p.y-1)=2 and map(p.x,p.y+1)>9) or (map(p.x,p.y-1)>9 and map(p.x,p.y+1)=2) then  
                    last+=1
                    ps(last)=p
                endif
            endif
            if map(p.x,p.y)=1 and map(p.x,p.y-1)=1 and map(p.x,p.y+1)=1 then
                if (map(p.x-1,p.y)=2 and map(p.x+1,p.y)>9) or (map(p.x-1,p.y)>9 and map(p.x+1,p.y)=2) then
                    last+=1
                    ps(last)=p
                endif
            endif
        next
    next
    if last>0 then
        p=ps(rnd_range(1,last))
        map(p.x,p.y)=3
    else
        for x=1 to 59
            for y=1 to 19
                p.x=x
                p.y=y
                if map(p.x,p.y)=1 and map(p.x-1,p.y)=1 and map(p.x+1,p.y)=1 then
                    if map(p.x,p.y-1)<>1 and map(p.x,p.y+1)<>1 then  
                        last+=1
                        ps(last)=p
                    endif
                endif
                if map(p.x,p.y)=1 and map(p.x,p.y-1)=1 and map(p.x,p.y+1)=1 then
                    if (map(p.x-1,p.y)<>1 and map(p.x+1,p.y)<>1) then
                        last+=1
                        ps(last)=p
                    endif
                endif
            next
        next
        if last>0 then
            p=ps(rnd_range(1,last))
            map(p.x,p.y)=3
        endif    
    endif
    return 0
end function


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

function dominant_terrain(x as short,y as short,m as short) as short
    dim as short x2,y2,i,in,set,dom,t1
    dim t(9) as short
    dim c(9) as short
    in=1
    for x2=x-1 to x+1
        for y2=y-1 to y+1
            if x2>=0 and x2<=60 and y2>=0 and y2<=20 then
                for i=1 to 9
                    set=0
                    if t(i)=abs(planetmap(x2,y2,m)) then
                        c(i)+=1
                        set+=1
                    endif
                next
                if set=0 then 
                    t(in)=abs(planetmap(x2,y2,m))
                    in+=1
                endif
            endif
        next
    next
    for i=1 to in-1
        if c(i)>dom then 
            dom=c(i)
            t1=t(i)
        endif
    next
    return t1
end function


function countasteroidfields(sys as short) as short
    dim as short a,b
    if sys<0 then return 0
    for a=1 to 9
        if map(sys).planets(a)<0 and isgasgiant(map(sys).planets(a))=0 then b=b+1
    next
    return b
end function


function countgasgiants(sys as short) as short
    dim as short a,b
    if sys<0 then return 0
    for a=1 to 9
        if isgasgiant(map(sys).planets(a))>0 then b=b+1
    next
    return b
end function

function checkcomplex(map as short,fl as short) as integer
    dim result as integer
    dim maps(36) as short
    dim flags(lastplanet) as byte
    dim as short nextmap,lastmap,foundport,a,b,done
    maps(0)=map
    do
    ' Suche portal auf maps(lastmap)
        lastmap=nextmap
        nextmap+=1
        for a=1 to lastportal
            if portal(a).from.m=maps(lastmap) and flags(portal(a).dest.m)=0 then 
                maps(nextmap)=portal(a).dest.m
                flags(portal(a).dest.m)=1
            endif
        next
    loop until maps(nextmap)=0 or nextmap>35
    
    for a=1 to lastmap
        if maps(a)>0 and planets(maps(a)).genozide=0 then result+=1
    next
    return result
end function

function get_random_system(unique as short=0,gascloud as short=0,disweight as short=0,hasgarden as short=0) as short 'Returns a random system. If unique=1 then specialplanets are possible
    DimDebug(0)'1
    dim as short a,b,c,p,u,ad,cc,f
    dim pot(laststar*100) as short
    
#if __FB_DEBUG__
    if debug=1 then
        f=freefile
        open "getrandsystem.csv" for append as #f
    endif
#endif
    
    for a=0 to laststar
        if map(a).discovered=0 and map(a).spec<8 then
            ad=0
            if unique=0 then
                for p=1 to 9
                    for u=0 to lastspecial
                        if map(a).planets(p)=specialplanet(u) then ad=1
                    next
                next
            endif
            if hasgarden=1 then
                ad=1
                for p=1 to 9
                    if isgardenworld(map(a).planets(p)) then ad=0
                next
            endif
            if spacemap(map(a).c.x,map(a).c.y)<>0 then cc+=1
            if gascloud=1 and (spacemap(map(a).c.x,map(a).c.y)=0 or abs(spacemap(map(a).c.x,map(a).c.y))>6) then ad=1
            if gascloud=2 and abs(spacemap(map(a).c.x,map(a).c.y))<2 then ad=0
            if ad=0 then
                if disweight=1 then 'Weigh for distance
                    cc=1+disnbase(map(a).c)*disnbase(map(a).c)/10
                else
                    cc=1
                endif
#if __FB_DEBUG__
                if debug=1 then print #f,a &";"& cc &";"& disnbase(map(a).c)
#endif
                for p=1 to cc
                    if b<laststar*100 then
                        b=b+1
                        pot(b)=a
                    endif
                    'print "B";b;":";
                next
            endif
        endif
    next
#if __FB_DEBUG__
    if debug=1 then
        print #f,"+++++"
        close #f
    endif
#endif
        
    if b>0 then 
        c=pot(rnd_range(1,b))
    else 
        c=-1
    endif
    return c
end function 


function getrandomplanet(s as short) as short
    dim pot(10) as short
    dim as short a,b,c
    if s>=0 and s<=laststar then
        for a=1 to 9
            if map(s).planets(a)>0 then
                b=b+1
                pot(b)=map(s).planets(a)
                
            endif
        next
        if b<=0 then 
            c=-1
        else 
            c=pot(rnd_range(1,b))
        endif
    else
        c=-1
    endif
    return c
end function

function get_system() as short  'returns the number of the system the player is in
    dim a as short
    dim b as short
    b=-1
    for a=0 to laststar
        if player.c.x=map(a).c.x and player.c.y=map(a).c.y then b=a
    next
    return b
end function


function fillmap(map() as short,tile as short) as short
    dim x as short
    dim y as short
    for x=0 to 60
        for y=0 to 20
            map(x,y)=tile
        next
    next
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
    
    assert(pMakemonster<>null)

    for b=0 to planets(a).life
#if __FB_DEBUG__
        if debug=99 then 
			DbgPrint("chance:" & b & "." & (planets(a).life+1)*3 )
        EndIf
#endif
        if rnd_range(1,100)<(planets(a).life+1)*3 then 
            planets(a).mon_template(b)=pMakemonster(1,a)
            planets(a).mon_noamin(b)=cint((rnd_range(1,planets(a).life)*planets(a).mon_template(b).diet)/2)
            planets(a).mon_noamax(b)=cint((rnd_range(1,planets(a).life)*2*planets(a).mon_template(b).diet)/2)
            if planets(a).mon_noamin(b)>planets(a).mon_noamax(b) then swap planets(a).mon_noamin(b),planets(a).mon_noamax(b)
        endif
    next
    
    if rnd_range(1,100)<(planets(a).life+1)*3 then
        planets(a).mon_noamin(11)=1
        planets(a).mon_noamax(11)=1
        planets(a).mon_template(11)=pMakemonster(2,a)
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
    assert(pMakespecialplanet<>null)
    pMakespecialplanet(a)
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
    'if planets(a).temp=0 and planets(a).grav=0 then rlprint "Made a 0 planet,#"&a,c_red
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



#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tMakeplanet -=-=-=-=-=-=-=-
	tModule.register("tMakeplanet",@tMakeplanet.init()) ',@tMakeplanet.load(),@tMakeplanet.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tMakeplanet -=-=-=-=-=-=-=-
#endif'test
