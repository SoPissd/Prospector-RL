'tConsts.

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
'     -=-=-=-=-=-=-=- TEST: tConsts -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tConsts -=-=-=-=-=-=-=-



#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tConsts -=-=-=-=-=-=-=-

namespace tConsts
function init(iAction as integer) as integer
	return 0
end function
end namespace'tConsts


#define cut2top

Const Show_pirates=0 		'pirate system already discovered
Const show_critters=0
Const enable_donplanet=0 	'D key on planet tirggers displayplanetmap
Const all_drifters_are=0
Const toggling_filter=0
Const fuel_usage=0
Const lstcomty=20 			'Last common item
Const com_log=0
Const show_moral=0
Const makemoodlog=0




#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tConsts -=-=-=-=-=-=-=-
	tModule.register("tConsts",@tConsts.init()) ',@tConsts.load(),@tConsts.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tConsts -=-=-=-=-=-=-=-
#endif'test
