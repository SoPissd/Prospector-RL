'tAstar.
#include once "uDefines.bi"
DeclareDependencies()
#include "fbGfx.bi"
#include "uUtils.bas"
#include "uDebug.bas"
#include "uRng.bas"
#include "uScreen.bas"
#include "uColor.bas"
#include "uConsole.bas"
#include "uCoords.bas"
#define test 
#endif'DeclareDependencies()
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tAstar -=-=-=-=-=-=-=-

'declare function manhattan(a as _cords,b as _cords) as single
'declare function addneighbours(node() as _node, curr as _cords,mx as short,my as short,rollover as byte=0) as short
'declare function findlowerneighbour(node() as _node, curr as _cords,mx as short,my as short,rollover as byte=0) as short

declare function a_star(path() as _cords, start as _cords,goal as _cords,map() as short,mx as short,my as short,echo as short=0,rollover as byte=0) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tAstar -=-=-=-=-=-=-=-

namespace tAstar
function init(iAction as integer) as integer
	return 0
end function
end namespace'tAstar


type _node
    opclo as byte
    g as single
    h as single
    cost as single
    parent as _cords
end type


function manhattan(a as _cords,b as _cords) as single
    return abs(a.x-b.x)+abs(a.y-b.y)
end function


function addneighbours(node() as _node, curr as _cords,mx as short,my as short,rollover as byte=0) as short
    dim as short x,y
    dim as single ng
    dim p as _cords
    for x=curr.x-1 to curr.x+1
        for y=curr.y-1 to curr.y+1
            if (y>=0 andalso y<=my) then

                if (rollover=1) orelse ((x>=0) andalso (y>=0) andalso (x<=mx) andalso (y<=my)) then
                    p.x=x
                    p.y=y
                        
                    if rollover=1 then
                        if p.x<0 then p.x=mx
                        if p.x>mx then p.x=0
                        if p.y<0 then p.y=0
                        if p.y>my then p.y=my
                    endif
                    if node(p.x,p.y).opclo=0  then 
                        node(p.x,p.y).opclo=1
                        node(p.x,p.y).parent.x=curr.x
                        node(p.x,p.y).parent.y=curr.y
                        node(p.x,p.y).g=node(curr.x,curr.y).g+distance(p,curr,1)+node(p.x,p.y).cost
                    endif
                endif
            endif
        next
    next
    return 0
end function

function findlowerneighbour(node() as _node, curr as _cords,mx as short,my as short,rollover as byte=0) as short
    dim as short x,y,xr,yr
    dim as _cords p
    dim value as single
    value=node(node(curr.x,curr.y).parent.x,node(curr.x,curr.y).parent.y).g
    for x=curr.x-1 to curr.x+1
        for y=curr.y-1 to curr.y+1
            if rollover=0 then
                if (x>=0) andalso (y>=0) andalso (x<=mx) andalso (y<=my) then
                    if (node(x,y).opclo=1) andalso (node(x,y).g<value) then
                        
                        p.x=x
                        p.y=y
                        node(curr.x,curr.y).parent.x=x
                        node(curr.x,curr.y).parent.y=y
                        node(curr.x,curr.y).g=node(x,y).g+node(curr.x,curr.y).cost+distance(p,curr)
                        value=node(x,y).g
                    endif
                endif
            else
                xr=x
                yr=y
                if xr<0 then xr=mx
                if xr>mx then xr=0
                if yr>=0 and yr<=20 then 
                    if node(xr,yr).opclo=1 andalso node(xr,yr).g<value then
                        
                        p.x=xr
                        p.y=yr
                        node(curr.x,curr.y).parent.x=xr
                        node(curr.x,curr.y).parent.y=yr
                        node(curr.x,curr.y).g=node(xr,yr).g+node(curr.x,curr.y).cost+distance(p,curr)
                        value=node(xr,yr).g
                    endif
                endif
            endif
        next
    next
    return 0
end function


function a_star(path() as _cords, start as _cords,goal as _cords,map() as short,mx as short,my as short,echo as short=0,rollover as byte=0) as short
    
    dim node(mx,my) as _node
    dim as integer lastopen,lastclosed,lastnode,x,y,i,j
    dim as integer ccc
    dim as _cords curr,p,best
    dim as single d,d1,d2
    
#if __FB_DEBUG__
    dim as byte debug
    debug=0
    
    if debug=1 then
        locate my+2,1
        print start.x;":";start.y;"-";goal.x;":";goal.y
    endif
#endif

    curr=start
    for x=0 to mx
        for y=0 to my
            node(x,y).cost=abs(map(x,y))
        next
    next
    
    do
        ccc+=1
        if (echo=1) andalso (ccc mod 10=0) then print ".";
        
        node(curr.x,curr.y).opclo=1 'Node on Open list
        addneighbours(node(),curr,mx,my,rollover)
        node(curr.x,curr.y).opclo=2 'Add node to closed List
        findlowerneighbour(node(),curr,mx,my)
        
        d=9999999
        best.x=-1
        best.y=-1
        if (curr.x<>goal.x) orelse (curr.y<>goal.y) then
            for x=0 to mx
                for y=0 to my                    
                    p.x=x
                    p.y=y
                    
                    if (curr.x<>goal.x) orelse (curr.y<>goal.y) then
                        if node(x,y).opclo=1 then
                        	
                            d1= distance(p,goal,rollover)                            
                                node(x,y).h = d1 
                            d2= node(x,y).h + node(x,y).g
                            
                            if (d2<d) orelse (manhattan(p,goal)=0) then
                            	'clear candidate list and add this one
                                best.x=x
                                best.y=y
                                
                                if d1>0 then 
                                    d=d2
                                else
                                    d=0
                                endif
                            elseif (d2=d) then
                            	'same distance? add to candidates.
                            endif
                        endif
                    endif
                    
                next
            next
#if __FB_DEBUG__
            if debug=1 then sleep 100
#endif
			'
			' pick a best from the candidate list.
			'
            if (best.x>=0) andalso (best.y>=0) andalso (not ((curr.x=goal.x) andalso (curr.y=goal.y))) then
                node(best.x,best.y).opclo=2
                curr=best
            endif
        endif
    loop until ((curr.x=goal.x) andalso (curr.y=goal.y)) orelse (ccc<0)
    
#if __FB_DEBUG__
    if debug=5 then
        for x=0 to mx
            for y=0 to my
                locate y*3,x*5
                print "g";int(node(x,y).g)
                locate (y*3)+1,x*5
                print "c";int(node(x,y).cost)
            next
        next
    end if
#endif
    
	if echo=1 then print
	
    if ccc>0 then
        i=0
        do
            path(i).x=curr.x
            path(i).y=curr.y
            curr=node(curr.x,curr.y).parent
            i+=1
           
        loop until (i=ubound(path)) orelse ((curr.x=start.x) andalso (curr.y=start.y))  
        path(i).x=curr.x
        path(i).y=curr.y
         
        'i-=1
        if echo=1 then print "Found path with "&i &" Waypoints."
        return i
    else
        if echo=1 then print "No path found"
    endif
    return -1
end function

#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tAstar -=-=-=-=-=-=-=-
	tModule.register("tAstar",@tAstar.init()) ',@tAstar.load(),@tAstar.save())
#endif'main



#if (defined(test) or defined(registerTests))
#print -=-=-=-=-=-=-=- TEST:  -=-=-=-=-=-=-=-

	namespace tAstar

	sub Astartest()
	End Sub

	end namespace'tAstar
	
	#ifdef test
		tAstar.Astartest()
		'? "sleep": sleep
	#else
		tModule.registertest("uAstar",@tAstar.Astartest())
	#endif'test
#endif'test
