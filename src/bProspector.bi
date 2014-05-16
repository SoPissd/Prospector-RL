#ifdef phase1
	#define gbasics
	' these are all the units i could 'sneak' under vGame.bas without introducing more dependencies
	' some of the are essential, some of them are just containers to isolate something, even nothing
	' has all saving/loading/configuring/menuing/graphic/tiles. even retirement, highscore and more.
	' it could become a dll to rely on the foundation.
#endif
#ifdef phase2
	#define xvars		'leftover global vars and types
	#define ccommerce	'commerce
	#define ddisplay	'display
	#define pplanet		'planetside awayteam
	#define ggame		'game fundamentals
	#define sspace		'space travel and combat
	#define wworldgen	'universe and planet generation
	#define vapp		'-empty group-
	#define vfinal		'
#endif

#ifdef other
	#define gbasics
	#define ccommerce
	#define ddisplay
	#define pplanet
	#define ggame
	#define sspace
	#define wworldgen
	#define vapp
	#define vfinal
	#define xvars
	#define gbasics
#endif
'
'
'
#ifdef gbasics
'
'basics
'
inc("dCards.bas",				"Playing card rendering")
inc("vSettings.bas",			"Saved settings and keys assembled here for early save/load inclusion")
inc("sStars.bas",				"Stellar map, resized based on save/load")
inc("vInput.bas",				"gettext & getnumber")
inc("vKeys.bas",				"save, load, configure keys")
inc("vConfig.bas",				"save, load, configure settings")
inc("vFonts.bas",				"compute/load fonts/graphics-mode")
inc("vDebug2.bas",				"disabled csv printing")
inc("vTiledata.bas",			"data about each tile")
inc("vTiles.bas",				"tile rendering")
inc("dHighscore.bas",			"highscore display")
inc("gUtils.bas",				"game utils")
inc("gEnergycounter.bas",		"energycounter object")
inc("gWeapon.bas",				"weapon object")
inc("gShip.bas",				"ship/player object")
inc("sCoords.bas",				"movepoint, driftingship, explored%")
inc("cRetirement.bas",			"buy assets, produce text")
inc("dDeath.bas",				"death story and screens")
inc("cCargo.bas",				"strings for cargo")
inc("cCustomship.bas",			"delete_custom")
inc("cRumors.bas",				"get_rumor")
inc("cStockmarket.bas",			"just a template")
inc("vGame.bas",				"game menu. gives about 1/3rd the units a workout without anything on top")
#endif

#ifdef xvars
'
'leftover
'
inc("xConsts.bas",				"")
inc("xTypes.bas",				"")
inc("xEnums.bas",				"")
inc("xVars.bas",				"")
#endif

#ifdef ccommerce
'
'commerce
'
inc("cArtifacts.bas",			"")
'inc("cCargo.bas",				"")
inc("cCargotrade.bas",			"")
inc("cCasino.bas",				"")
inc("cCredits.bas"	,			"")
'inc("cCustomship.bas",			"")
inc("cFuel.bas",				"")
inc("cItem.bas",				"")
inc("cItems.bas",				"")
inc("wMakeitem.bas",			"")
inc("cModifyitem.bas",			"")
inc("cPeople.bas",				"")
inc("cPoker.bas",				"")
inc("cQuest.bas",				"")
inc("cQuests.bas",				"")
'inc("cRetirement.bas",			"")
'inc("cRumors.bas",				"")
inc("cShipyard.bas",			"")
inc("cShops.bas",				"")
inc("cSlotmachine.bas",			"")
'inc("cStockmarket.bas",		"")
inc("cTrading.bas",				"")
#endif

#ifdef ddisplay
'
'display
'
inc("dCockpit.bas",				"")
inc("dLogbook.bas",				"")
inc("dParty.bas",				"")
inc("dSpacecombatmap.bas",		"")
inc("dSpacemap.bas",			"")
inc("dSummary.bas",				"")
inc("dPlanetmap.bas",			"")
#endif

#ifdef pplanet
'
'planet
'
inc("pAttack.bas",				"")
inc("pAutoexplore.bas",			"")
inc("pAwayteam.bas",			"")
inc("pDialog.bas",				"")
inc("pExploreplanet.bas",		"")
inc("pLanding.bas",				"")
inc("pMonster.bas",				"")
inc("pMonstermove.bas",			"")
inc("pPlanet.bas",				"")
inc("pPlanetmenu.bas",			"")
inc("pRadio.bas",				"")
inc("pRover.bas",				"")
#endif

#ifdef ggame
'
'game
'
'inc("gShip.bas",				"")
inc("gBasis.bas",				"")
inc("gCivilisation.bas",		"")
inc("gCommandstring.bas",		"")
inc("gCommunicate.bas",			"")
inc("gCompany.bas",				"")
inc("gCrew.bas",				"")
inc("gCrewfunctions.bas",		"")
inc("gExplore.bas",				"")
inc("gFaction.bas",				"")
inc("gFleet.bas",				"")
inc("gPirates.bas",				"")
inc("gWaypoints.bas",			"")
#endif

#ifdef sspace
'
'space
'
inc("sAutopilot.bas",			"")
'inc("sCoords.bas",				"")
inc("sExplorespace.bas",		"")
inc("sProbes.bas",				"")
inc("sSpace.bas",				"")
inc("sSpacecombat.bas",			"")
inc("sSpacecombatfunctions.bas","")
'inc("sStars.bas",				"")
#endif

#ifdef wworldgen
'
'world-gen
'
inc("wBones.bas",				"")
inc("wColony.bas",				"")
inc("wMakemonster.bas",			"")
inc("wMakeplanet.bas",			"")
inc("wPlaneteffect.bas",		"")
inc("wSpecialPlanet.bas",		"")
inc("wWorldgen.bas",			"")
#endif

#ifdef vapp
'
'app
'
#endif

#ifdef vfinal
'
'overall
'
inc("vPlayer.bas",				"player functions. the type long ago declared as _ship in Ship.bas")
inc("vSavegame.bas",			"universe and player ... via compression")
inc("vGameinit.bas",			"final initialization coordination")
inc("vGamekeys.bas",			"'legacy' action-wiring")
'inc("vMenu.bas",				"menu with graphics as before, for reference. should wind up with an override maybe")
#endif

