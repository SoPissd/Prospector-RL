'experiments/duplicate the inc's
 
#ifdef justpoker
inc("gUtils.bas",				"game utils")
inc("vInput.bas",				"gettext & getnumber")
inc("cCasino.bas",				"")
inc("cSlotmachine.bas",			"")
inc("dCards.bas",				"Playing card rendering")
inc("cPoker.bas",				"")
#endif


inc("xConsts.bas",				"")
inc("xTypes.bas",				"")
inc("xEnums.bas",				"")
inc("xVars.bas",				"")

inc("dCards.bas",				"Playing card rendering")
inc("cCasino.bas",				"")
inc("cPoker.bas",				"")
inc("cSlotmachine.bas",			"")

inc("vKeys.bas",				"save, load, configure keys")
inc("vConfig.bas",				"")
inc("vFonts.bas",				"compute/load fonts/graphics-mode")
inc("vDebug2.bas",				"disabled csv printing")
inc("dDeath.bas",				"")
inc("dHighscore.bas",			"")
inc("vGame.bas",				"game menu. gives about 1/3rd the units a workout without anything on top")

inc("cRumors.bas",				"get_rumor")
inc("cStockmarket.bas",			"just a template")

inc("cFuel.bas",				"")
inc("dCockpit.bas",				"")
inc("dLogbook.bas",				"")
inc("dParty.bas",				"")
inc("dSpacecombatmap.bas",		"")
inc("dSummary.bas",				"")
inc("pAttack.bas",				"")
inc("pAutoexplore.bas",			"")
inc("pAwayteam.bas",			"")
inc("pExploreplanet.bas",		"")
inc("pLanding.bas",				"")
inc("pRadio.bas",				"")
inc("pRover.bas",				"")
inc("gExplore.bas",				"")
inc("gWaypoints.bas",			"")
inc("sAutopilot.bas",			"")
inc("sExplorespace.bas",		"")
inc("sProbes.bas",				"")
inc("sSpace.bas",				"")
inc("sSpacecombat.bas",			"")
inc("sSpacecombatfunctions.bas","")
inc("wBones.bas",				"")
inc("wColony.bas",				"")
inc("wPlaneteffect.bas",		"")
inc("wWorldgen.bas",			"")
inc("vSavegame.bas",			"universe and player ... via compression")
inc("vGameinit.bas",			"final initialization coordination")
inc("vGamekeys.bas",			"'legacy' action-wiring")

'inc("vMenu.bas",				"menu with graphics as before, for reference. should wind up with an override maybe")






' for real - unique inc's

'
'basics
'
#ifdef gbasics2
#ifndef useLibTileData
inc("vTiledata.bas",			"data about each tile")
#endif
'inc("dCards.bas",				"Playing card rendering")
inc("vSettings.bas",			"Saved settings and keys assembled here for early save/load inclusion")
inc("sStars.bas",				"Stellar map, resized based on save/load")
inc("vInput.bas",				"gettext & getnumber")
inc("vKeys.bas",				"save, load, configure keys")
inc("vConfig.bas",				"save, load, configure settings")
inc("vFonts.bas",				"compute/load fonts/graphics-mode")
inc("vDebug2.bas",				"disabled csv printing")
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




#ifdef gbasics0
#ifndef useLibTileData
inc("vTiledata.bas",			"data about each tile")
#endif
inc("cCredits.bas",				"")
inc("gBasis.bas",				"")
inc("gUtils.bas",				"")
inc("vTiles.bas",				"")
inc("vSettings.bas",			"")
inc("sStars.bas",				"")
inc("gEnergycounter.bas",		"")
inc("gWeapon.bas",				"")
inc("pMonster.bas",				"")
inc("sCoords.bas",				"")
inc("sPortal.bas",				"")
inc("cItems.bas",				"")
inc("cItem.bas",				"")
inc("gShip.bas",				"")
inc("gMenu.bas",				"")
inc("vPlayer.bas",				"")
inc("wMakeship.bas",			"")
inc("cRetirement.bas",			"")
inc("vInput.bas",				"")
inc("gFaction.bas",				"")
inc("gCivilisation.bas",		"")
inc("pPlanet.bas",				"")
inc("gCommandstring.bas",		"")
inc("cCargo.bas",				"")
inc("dSpacemap.bas",			"")
inc("gFleet.bas",				"")
inc("dPlanetmap.bas",			"")
inc("cModifyitem.bas",			"")
inc("wMakeitem.bas",			"")
inc("wMakeplanet.bas",			"")
inc("wSpecialplanet.bas",		"")
inc("cShops.bas",				"")
inc("cShipyard.bas",			"")
inc("cArtifacts.bas",			"")
inc("cQuest.bas",				"")
inc("cPeople.bas",				"")
inc("wMakemonster.bas",			"")
inc("gCrewfunctions.bas",		"")
inc("gCommunicate.bas",			"")
inc("cCargotrade.bas",			"")
inc("gCompany.bas",				"")
inc("pDialog.bas",				"")
inc("cTrading.bas",				"")
inc("gPirates.bas",				"")
inc("cQuests.bas",				"")
inc("gCrew.bas",				"")
#endif






