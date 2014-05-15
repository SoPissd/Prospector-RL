'tAutopilot.
'
'defines:
'ap_astar=0, auto_pilot=1
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
'     -=-=-=-=-=-=-=- TEST: tAutopilot -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tAutopilot -=-=-=-=-=-=-=-

declare function auto_pilot(start as _cords, ende as _cords, diff as short) as short
declare function ap_astar(start as _cords,ende as _cords,diff as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tAutopilot -=-=-=-=-=-=-=-

namespace tAutopilot
function init() as Integer
	return 0
end function
end namespace'tAutopilot


#define cut2top


function ap_astar(start as _cords,ende as _cords,diff as short) as short
    DimDebug(0)
    dim map(sm_x,sm_y) as short
    dim as short x,y
    
#if __FB_DEBUG__
    if debug=2 then rlprint ""&diff
#endif

    for x=0 to sm_x 
        for y=0 to sm_y
            map(x,y)=0
            if spacemap(x,y)>0 then 
                map(x,y)=spacemap(x,y)*200*diff^2
                if map(x,y)<0 then map(x,y)=32000
            else
                map(x,y)=100*diff
            endif
#if __FB_DEBUG__
            if debug=1 then
                set__color( map(x,y),0)
                pset(x,y)
            endif
#endif
        next
    next
    lastapwp=a_star(apwaypoints(),ende,start,map(),sm_x,sm_y,0)
    return lastapwp
end function


function auto_pilot(start as _cords, ende as _cords, diff as short) as short
    lastapwp=ap_astar(start,ende,diff)
    if lastapwp>0 then
        show_dotmap(ende.x,ende.y) 
        if askyn( "Route calculated with "&lastapwp &" parsecs. Use it? (y/n)") then
            walking=10
            currapwp=0
            apdiff=diff
            return 1
        endif
    endif
    return 0
end function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tAutopilot -=-=-=-=-=-=-=-
	tModule.register("tAutopilot",@tAutopilot.init()) ',@tAutopilot.load(),@tAutopilot.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tAutopilot -=-=-=-=-=-=-=-
#endif'test
