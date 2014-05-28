'tCoords.
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
'     -=-=-=-=-=-=-=- TEST: tCoords -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

Dim Shared apwaypoints(1024) As _cords
Dim Shared usedship(8) As _cords
Dim Shared targetlist(4068) As _cords

Dim Shared pwa(1024) As _cords 'Points working array

Type _driftingship extends _cords
    g_tile As _cords
    start As _cords
End Type

Dim Shared lastdrifting As Short=16
Dim Shared drifting(128) As _driftingship
#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tCoords -=-=-=-=-=-=-=-

declare function movepoint(byval c as _cords, a as short, eo as short=0, border as short=0) as _cords
declare function explored_percentage_string() as string

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tCoords -=-=-=-=-=-=-=-

namespace nsCoords
function init(iAction as integer) as integer
	return 0
end function
end namespace'tCoords


sub shiftpoint(byref c as _cords, iDir as integer)
	with c
		select case iDir
			case 1 
	        .x-=1
	        .y+=1
			case 2
	        .y+=1
			case 3
	        .x+=1
	        .y+=1
			case 4
	        .x-=1
			case 6
	        .x+=1
			case 7
	        .x-=1
	        .y-=1
			case 8
	        .y-=1
			case 9
	        .x+=1
	        .y-=1
		end select
	end with
end sub

function movepoint(byval c as _cords, a as short, eo as short=0, border as short=0) as _cords
    dim p as _cords
    dim as short x,y
    dim f as integer

    if border=0 then				'figure which limit to use
        x=60
        y=20
    else
        x=sm_x
        y=sm_y
    endif
        
    if a=5 then						'shift into a random direction
        a=rnd_range(1,8)
        if a=5 then a=9
    endif
	
    p=c								'keep original
	shiftpoint(c,a)
	
	with c
	    select case eo
	    	case 0 							'limit to 0..x, 0..y
	        if .x<0 then .x=0 else if .x>x then .x=x
	        if .y<0 then .y=0 else if .y>y then .y=y
	    	case 1							'wrap within limit 0..x, 0..y
	        if .x<0 then .x=x else if .x>x then .x=0
	        if .y<0 then .y=y else if .y>y then .y=0
	    	case 2							'don't accept anything that would violate boundary
	        if .x<0 orelse .x>x orelse .y<0 orelse .y>y then 
			  return p
	        endif
	    	case 3							'x-wrap and keep y within limit
	        if .x<0 then .x=x else if .x>x then .x=0
	        if .y<0 then .y=0 else if .y>y then .y=y
	    	case 4							'x-wrap and keep y within hard limit 0..20
	        if .x<0 then .x=x else if .x>x then .x=0
	        if .y<0 then .y=0 else if .y>20 then .y=20
	    end select
	end with
    return c
end function


function explored_percentage_string() as string
    dim as short x,y,ex
    for x=0 to sm_x
        for y=0 to sm_y
            if spacemap(x,y)>0 then ex+=1
        next
    next
    if ex<(sm_x*sm_y) then
        return "Explored {15}"&ex &"{11} parsec ({15}"& int(ex/(sm_x*sm_y)*100) &" %{11} of the sector)"
    else
        return "Explored the complete sector of {15}"&ex &"{11} parsecs."
    endif
end function


#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tCoords -=-=-=-=-=-=-=-
	tModule.register("nsCoords",@nsCoords.init()) ',@tCoords.load(),@tCoords.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tCoords -=-=-=-=-=-=-=-
#endif'test
