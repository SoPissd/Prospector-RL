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
function init() as Integer
	return 0
end function
end namespace'tEnums


#define cut2top


Enum moduleshops
    ms_energy
    ms_projectile
    ms_modules
End Enum

Dim Shared moduleshopname(ms_modules) As String

Enum movetypes
    mt_walk
    mt_hover
    mt_fly
    mt_flyandhover
    mt_teleport
    mt_climb 'Can move across mountains, but not water (For spiders)
    mt_dig 'Can move through walls, but not water (For worms)
    mt_ethereal 'Can move through anything
    mt_fly2
End Enum


Enum locat
    lc_awayteam
    lc_onship
End Enum

Enum dockingdifficulty
    dd_station
    dd_smallstation
    dd_drifter
    dd_aliendrifter
    dd_comsat
    dd_asteroidmining
End Enum

Enum shops
    sh_shipyard
    sh_modules
    sh_equipment
    sh_used
    sh_mudds
    sh_bots
End Enum


Enum RndItem
    RI_transport'0
    RI_rangedweapon'1
    RI_ccweapon'2
    RI_armor'3
    RI_Medpacks'4
    RI_KODrops'5
    RI_WEAPONS'6
    RI_ALLBUTWEAPONS'7
    RI_Mining'8
    RI_Kits'9
    RI_ROBOTS'10
    RI_Rovers'11
    RI_Infirmary'12
    RI_LandingGear'13
    RI_ALLDRONESPROBES'14
    RI_StrandedShip'15
    RI_Artefact'16
    RI_SPACEBOTS
    RI_Probes'
    RI_Drones'18
    RI_GasProbes
    RI_Miningbots'20
    RI_Shipequipment
    RI_Lamps'22
    RI_Tanks
    RI_AllButWeaponsAndMeds'24
    RI_StandardShop
    RI_ShopAliens'26
    RI_ShopSpace
    RI_ShopExplorationGear'28
    RI_ShopWeapons
    RI_WeaponsArmor
    RI_Cage
    RI_WeakWeapons
    RI_WeakStuff

End Enum

Dim Shared questroll As Short
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

Enum QUEST
    Q_WANT
    Q_HAS
    Q_ANSWER
End Enum

Enum questtype
    qt_empty'0
    qt_EI'1
    qt_autograph'2
    qt_outloan'3
    qt_stationimp'4
    qt_drug'5
    qt_souvenir'6
    qt_tools'7
    qt_showconcept'8
    qt_stationsensor'9
    qt_travel'10 Needs Debugging
    qt_cargo'11 Needs Debugging
    qt_locofpirates'12
    qt_locofspecial'13
    qt_locofgarden'14
    qt_research'15
    qt_megacorp'16
    qt_biodata'17
    qt_anomaly'18
    qt_juryrig'19
    qt_cursedship'20
End Enum


Enum stphrase
    sp_greetfriendly
    sp_greetneutral
    sp_greethostile
    sp_gotalibi
    sp_gotmoney
    sp_cantpayback
    sp_notenoughmoney
    sp_gotreport
    sp_last
End Enum

Enum slse
    slse_arena
    slse_zoo
    slse_slaves
End Enum

Enum rwrd
    rwrd_mapdata
    rwrd_biodata
    rwrd_resources
    rwrd_pirates
    rwrd_artifacts
    rwrd_5
    rwrd_piratebase
    rwrd_6
    rwrd_pirateoutpost
    rwrd_tasty
    rwrd_pretty
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
