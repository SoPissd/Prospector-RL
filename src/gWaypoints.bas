'tWaypoints.
'
'defines:
'check=43, add_p=7, checkandadd=0, nearlowest=0, gen_waypoints=0
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
'     -=-=-=-=-=-=-=- TEST: tWaypoints -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Dim Shared As Byte pf_stp=1

Type _pfcords
    x As Short
    y As Short
    c As UInteger
    i As Byte
End Type

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tWaypoints -=-=-=-=-=-=-=-

declare function check(queue() as _pfcords, p as _pfcords) as short
declare function add_p(queue() as _pfcords,p as _pfcords) as short

'declare function checkandadd(queue() as _pfcords,map() as byte ,in as short) as short
'declare function nearlowest(p as _pfcords,queue() as _pfcords) as _pfcords
'declare function gen_waypoints(queue() as _pfcords,start as _pfcords,goal as _pfcords,map() as byte) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tWaypoints -=-=-=-=-=-=-=-

namespace tWaypoints
function init(iAction as integer) as integer
	return 0
end function
end namespace'tWaypoints


function check(queue() as _pfcords, p as _pfcords) as short
    dim as integer i
    for i=0 to 40680
        if queue(i).i<>0 then
            if (queue(i).x=p.x and queue(i).y=p.y) and queue(i).c<=p.c then
                return -1
            endif
        endif
    next
    return 0
end function
    

function add_p(queue() as _pfcords,p as _pfcords) as short
    dim i as integer
    for i=0 to 40680
        if queue(i).i=0 then
            queue(i).x=p.x
            queue(i).y=p.y
            queue(i).c=p.c
            queue(i).i=1
            return 1
        endif
    next
    print "Ran out of nodes"
    return 0
end function
    

function checkandadd(queue() as _pfcords,map() as byte ,in as short) as short
    dim p as _pfcords
    dim a as short
    p.x=queue(in).x+pf_stp
    p.y=queue(in).y
    p.c=queue(in).c+1
    if p.x>=0 and p.y>=0 and p.y<=sm_y and p.x<=sm_x  then
        'if map(p.x,p.y)=2 then p.c+=1
        if map(p.x,p.y)<>2 and check(queue(),p)=0 then a+=add_p(queue(),p)
    endif
    p.x=queue(in).x-pf_stp
    p.y=queue(in).y
    p.c=queue(in).c+1
    if p.x>=0 and p.y>=0 and p.y<=sm_y and p.x<=sm_x  then
        'if map(p.x,p.y)=2 then p.c+=1
        if map(p.x,p.y)<>2 and check(queue(),p)=0 then a+=add_p(queue(),p)
    endif
    p.x=queue(in).x
    p.y=queue(in).y+pf_stp
    p.c=queue(in).c+1
    if p.x>=0 and p.y>=0 and p.y<=sm_y and p.x<=sm_x  then
        'if map(p.x,p.y)=2 then p.c+=1
        if map(p.x,p.y)<>2 and check(queue(),p)=0 then a+=add_p(queue(),p)
    endif
    p.x=queue(in).x
    p.y=queue(in).y-pf_stp
    p.c=queue(in).c+1
    if p.x>=0 and p.y>=0 and p.y<=sm_y and p.x<=sm_x  then
        'if map(p.x,p.y)=2 then p.c+=1
        if map(p.x,p.y)<>2 and check(queue(),p)=0 then a+=add_p(queue(),p)
    endif
    
'    p.x=queue(in).x+1
'    p.y=queue(in).y+1
'    p.c=queue(in).c+1
'    if p.x>=0 and p.y>=0 and p.y<=sm_y and p.x<=sm_x  then
'        'if map(p.x,p.y)=2 then p.c+=1
'        if map(p.x,p.y)<>2 and check(queue(),p)=0 then a+=add_p(queue(),p)
'    endif
'    p.x=queue(in).x-1
'    p.y=queue(in).y+1
'    p.c=queue(in).c+1
'    if p.x>=0 and p.y>=0 and p.y<=sm_y and p.x<=sm_x  then
'        'if map(p.x,p.y)=2 then p.c+=1
'        if map(p.x,p.y)<>2 and check(queue(),p)=0 then a+=add_p(queue(),p)
'    endif
'    p.x=queue(in).x-1
'    p.y=queue(in).y-1
'    p.c=queue(in).c+1
'    if p.x>=0 and p.y>=0 and p.y<=sm_y and p.x<=sm_x  then
'        'if map(p.x,p.y)=2 then p.c+=1
'        if map(p.x,p.y)<>2 and check(queue(),p)=0 then a+=add_p(queue(),p)
'    endif
'    p.x=queue(in).x+1
'    p.y=queue(in).y-1
'    p.c=queue(in).c+1
'    if p.x>=0 and p.y>=0 and p.y<=sm_y and p.x<=sm_x  then
'        'if map(p.x,p.y)=2 then p.c+=1
'        if map(p.x,p.y)<>2 and check(queue(),p)=0 then a+=add_p(queue(),p)
'    endif
'    
    if show_NPCs=1 then
        locate 16,0
        locate queue(in).y+1,queue(in).x+1
        print "*";
    endif
    'if a>0 then print a &" nodes added from "&queue(in).x &":"&queue(in).y &" value "&queue(in).c
    return a
end function


function nearlowest(p as _pfcords,queue() as _pfcords) as _pfcords
    dim in as integer
    dim pot(20) as _pfcords
    dim pot2(20) as _pfcords
    dim as short b,c,a,v,lo
    dim in2 as short
    for in=0 to 40680
        if abs(p.x-queue(in).x)<=pf_stp and abs(p.y-queue(in).y)<=pf_stp  and queue(in).i<>0 and c<20 then
            c+=1
            pot(c)=queue(in)
        endif
    next
    v=p.c
    if c=0 then
        print "NO LEGAL NODES"
        sleep
    endif
        
    for a=1 to c
        if pot(a).c<v then
            v=pot(a).c
        endif
    next
    for a=1 to c
        if pot(a).c=v then
            b+=1
            pot2(b)=pot(a)
        endif
    next
    if b=0 then
        print "No lower node"
        sleep
    endif
        
    if b>1 then
        return pot2(rnd_range(1,b))
    else
        return pot2(b)
    endif
end function


function gen_waypoints(queue() as _pfcords,start as _pfcords,goal as _pfcords,map() as byte) as short
    dim as integer s,count,nono,x,y,f
    dim in as integer
    dim path(40680) as _pfcords
    queue(0).x=start.x
    queue(0).y=start.y
    queue(0).i=1
    queue(0).c=1
    if show_NPCs=1 then
        cls
        for x=0 to sm_x
            for y=0 to sm_y
                if map(x,y)>0 then
                    locate y+1,x+1
                    print "#"
                endif
            next
        next
    endif
    do
        nono=0
        for in=0 to 40680
            if queue(in).i=1 then
                nono+=1
                'if queue(in).x=goal.x and queue(in).y=goal.y then 
                if abs(queue(in).x-goal.x)<=pf_stp-1 and abs(queue(in).y-goal.y)<=pf_stp-1 then 
                    queue(in).x=goal.x
                    queue(in).y=goal.y
                    s=in
                    exit for
                endif
                f=checkandadd(queue(),map(),in)
                'if f=0 then exit for
            endif
            if frac(in/100)=0 then print ".";
        next
        count+=1
    loop until s<>0 or count>50
    
    if s=0 then
        print "unable to find path from "&start.x &":"&start.y &" to "&goal.x &":"&goal.y &" in "& count &" attempts"
        queue(0)=start
        queue(1)=goal
        in=1
        return in
    else
        in=0
        path(in)=queue(s)
        do
            path(in+1)=nearlowest(path(in),queue())
            in+=1
        loop until path(in).x=queue(0).x and path(in).y=queue(0).y or in>40680
        for s=0 to in
            queue(s)=path(s)
        next
        for s=in+1 to 40680
            queue(s).i=0
            queue(s).c=0
            queue(s).x=0
            queue(s).y=0
        next
        print "found path with "&in &" waypoints. ";
    endif
    return in
end function


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tWaypoints -=-=-=-=-=-=-=-
	tModule.register("tWaypoints",@tWaypoints.init()) ',@tWaypoints.load(),@tWaypoints.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tWaypoints -=-=-=-=-=-=-=-
#endif'test
