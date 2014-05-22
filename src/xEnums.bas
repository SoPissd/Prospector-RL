'tEnums.

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
'     -=-=-=-=-=-=-=- TEST: tEnums -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tEnums -=-=-=-=-=-=-=-



#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tEnums -=-=-=-=-=-=-=-

namespace tEnums
function init(iAction as integer) as integer
	return 0
end function
end namespace'tEnums


#define cut2top



Enum dockingdifficulty
    dd_station
    dd_smallstation
    dd_drifter
    dd_aliendrifter
    dd_comsat
    dd_asteroidmining
End Enum


Enum SHIELDDIR
    sd_front
    sd_frontright
    sd_right
    sd_rearright
    sd_rear
    sd_rearleft
    sd_left
    sd_frontleft
End Enum




#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tEnums -=-=-=-=-=-=-=-
	tModule.register("tEnums",@tEnums.init()) ',@tEnums.load(),@tEnums.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tEnums -=-=-=-=-=-=-=-
#endif'test
