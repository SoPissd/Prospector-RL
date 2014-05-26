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

Const show_dangerous=0
Const Show_all_specials=0	'38 'special planets already discovered
Const Show_pirates=0 		'pirate system already discovered
Const show_space=0
Const alien_scanner=0
Const start_teleport=0		'player has alien scanner
Const show_critters=0
Const enable_donplanet=0 	'D key on planet tirggers displayplanetmap
Const show_eventp=0 		'Show eventplanets
Const show_mapnr=0
Const show_mnr=0
Const show_wormholes=0
Const rev_map=0
Const no_enemys=0
Const more_mets=0
Const all_drifters_are=0
Const show_civs=0
Const toggling_filter=0
Const fuel_usage=0
Const run_until=0
Const show_eq=0 			'Show earthquakes
Const dbshow_factionstatus=0
Const lstcomty=20 			'Last common item
Const com_log=0
Const _spawnoff=0
Const show_moral=0
Const makemoodlog=0
Const _clearmap=0
Const _testspacecombat=0




Const _debug_bones=0
Const _test_disease=0
#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tConsts -=-=-=-=-=-=-=-
	tModule.register("tConsts",@tConsts.init()) ',@tConsts.load(),@tConsts.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tConsts -=-=-=-=-=-=-=-
#endif'test
