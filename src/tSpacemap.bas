'tSpacemap.
'
'defines:
'nearest_base=5, dispbase=0, make_vismask=7, vis_test=0, distributepoints=0
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tSpacemap -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tSpacemap -=-=-=-=-=-=-=-

declare function nearest_base(c as _cords) as short
declare function make_vismask(c as _cords, sight as short,m as short,ad as short=0) as short

'private function dispbase(c as _cords) as single
'private function vis_test(a as _cords,p as _cords,test as short) as short
'private function distributepoints(result() as _cords, ps() as _cords, last as short) as single

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tSpacemap -=-=-=-=-=-=-=-

namespace tSpacemap
function init() as Integer
	return 0
end function
end namespace'tSpacemap


Dim Shared basis(12) As _basis
'basis


function nearest_base(c as _cords) as short
    dim r as single
    dim a as short
    dim b as short
    r=650
    for a=0 to 2
        if distance(c,basis(a).c)<r then 
            r=distance(c,basis(a).c)
            b=a
        endif
    next
    return b
end function

function dispbase(c as _cords) as single
    dim as single r,r2
    dim a as short
    r=65
    for a=0 to _NoPB
        if piratebase(a)>0 then
            r2=distance(c,map(piratebase(a)).c)
        endif
    next
    return r2
end function 



function make_vismask(c as _cords, sight as short,m as short,ad as short=0) as short
    dim as short illu
    dim as short x,y,x1,y1,x2,y2,mx,my,i,d,grr
    dim as byte mask
    dim as _cords p,pts(128)
    x1=c.x
    y1=c.y
    if m>0 then
        mx=60
        my=20
    else
        mx=sm_x
        my=sm_y
    endif
    if ad=0 then
        for x=0 to mx
            for y=0 to my
                vismask(x,y)=-1
            next
        next
    endif
    
    for x=c.x-12 to c.x+12 
        for y=c.y-12 to c.y+12 
            if x=c.x-12 or x=c.x+12 or y=c.y-12 or y=c.y+12 then
                mask=1
                p.x=x
                p.y=y
                d=line_in_points(p,c,pts())
                for i=1 to d
                    if distance(c,pts(i))<=sight then
                        if m>0 then
                            if pts(i).x>60 then pts(i).x-=61
                            if pts(i).x<0 then pts(i).x+=61
                            if pts(i).y>=0 and pts(i).y<=20 then
                                vismask(pts(i).x,pts(i).y)=mask
                                if tmap(pts(i).x,pts(i).y).seetru>0 or (tmap(pts(i).x,pts(i).y).seetru>0 and tmap(pts(i).x,pts(i).y).dr>grr) then mask=0    
                            endif
                        else
                            if pts(i).x>=0 and pts(i).x<=mx and pts(i).y>=0 and pts(i).y<=my then
                                vismask(pts(i).x,pts(i).y)=mask
                                if spacemap(pts(i).x,pts(i).y)>1 then mask=0
                            endif
                        endif
                    endif
                next
                
            endif
        next
    next
    vismask(c.x,c.y)=1
#if __FB_DEBUG__
'   if _debug=2508 then
'       for x=0 to 60
'           for y=0 to 20
'               if vismask(x,y)>0 then pset(x,y)
'           next
'       next
'   endif
#endif
'            if (y>=0 and x>=0 and y<=my and x<=mx) or m>0 then
'                p.x=x
'                p.y=y
'                if p.x<0 then p.x=60-x
'                if p.x>60 then p.x=x-60
'                if vismask(p.x,p.y)=-1 then
'                    mask=1
'                    x2=x
'                    y2=y
'                    x1=a.c.x
'                    y1=a.c.y
'                    if distance(p,a.c)<=a.sight then
'                        d=abs(x1-x2)
'                        if abs(y1-y2)>d then d=abs(y1-y2)
'                        for i=0 to d*2
'                            p.x=x1
'                            p.y=y1
'                            if x1>=0 and x1<=mx and y1>=0 and y1<=my and (x1<>a.c.x or y1<>a.c.y) then
'                                if m>0 then
'                                    if tmap(x1,y1).seetru>0 or (tmap(x1,y1).seetru>0 and tmap(x1,y1).dr>grr) then mask=0
'                                else
'                                    If abs(spacemap(x1,y1))>1 Then mask=0
'                                endif
'                            endif
'                            x1=x1+(x2-x1)*i/(d*2)
'                            y1=y1+(y2-y1)*i/(d*2)
'                        next
'                        vismask(x,y)=mask
'                    endif
'                endif
'            endif
'        next
'    next
'
'    for x2=a.c.x-1 to a.c.x+1
'        for y2=a.c.y-1 to a.c.y+1
'            if x2>=0 and y2>=0 and x2<=mx and y2<=my then vismask(x2,y2)=1
'        next
'    next
'    
'    for x=0 to a.c.x
'        for y=0 to a.c.y
'            vistest(a,m,mx,my,x,y,vismask())
'        next
'    next
'    
'    
'    for x=mx to a.c.x step -1
'        for y=0 to a.c.y
'            vistest(a,m,mx,my,x,y,vismask())
'        next
'    next
'    
'    for x=0 to a.c.x 
'        for y=my to a.c.y step -1
'            vistest(a,m,mx,my,x,y,vismask())
'        next
'    next
'    
'    for x=mx to a.c.x step -1
'        for y=my to a.c.y step -1
'            vistest(a,m,mx,my,x,y,vismask())
'        next
'    next
'            
'    flood_fill2(a.c.x,a.c.y,mx,my,vismask())
'    for x=0 to mx
'        for y=0 to my
'            if vismask(x,y)=1 then vismask(x,y)=0
'            if vismask(x,y)=2 then vismask(x,y)=1
'        next
'    next
    return 0
end function

function vis_test(a as _cords,p as _cords,tst as short) as short
    dim as short x1,x2
    x1=a.x-_mwx/2
    x2=a.x+_mwx/2
    if tst=0 then 'Surface, can Wrap
        if x1<0 or x2>60 then 'Wraps
            if x1<0 then x1+=61
            if x2>60 then x2-=61
            'rlprint "X1:"&x1 &"X2:"& x2 &":"& p.x
            if p.x>=x1 then return -1
            'rlprint "not p.x>=x1" &p.x &":"&x1
            if p.x<=x2 then return -1
            'rlprint "not p.x<=x2"&p.x &":"&x2
            return 0
        else 'Doesn't Wrap
            if p.x>=x1 and p.x<=x2 then return -1
            return 0
        endif
    else 'Below Surface, doesn't wrap
        if x1<0 then x1=0
        if x2>60 then x2=60
        if p.x>=x1 and p.x<=x2 then return -1
        return 0
    endif
end function


function distributepoints(result() as _cords, ps() as _cords, last as short) as single
    dim re as single
    dim a as short
    dim b as short
    dim doubl(last) as short
    dim countr as short
    
    do 
        countr=0
        for a=0 to last
            doubl(a)=0
        next
        for a=0 to last
            for b=0 to last
                if a<>b then
                    if ps(a).x=ps(b).x and ps(a).y=ps(b).y then
                        doubl(a)=1
                        countr=countr+1
                    endif
                endif
            next
        next
        for a=0 to last
            if doubl(a)=1 then
                ps(a)=movepoint(ps(a),5,,1)
            endif
        next
    loop until countr=0
    for a=0 to last
        result(a)=ps(a)
    next
    return re
end function



#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tSpacemap -=-=-=-=-=-=-=-
	tModule.register("tSpacemap",@tSpacemap.init()) ',@tSpacemap.load(),@tSpacemap.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tSpacemap -=-=-=-=-=-=-=-
#endif'test
