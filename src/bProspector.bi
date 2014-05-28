#ifdef justpoker

inc("cCasino.bas",				"")
inc("cSlotmachine.bas",			"")
inc("cCards.bas",				"Playing card rendering")
inc("cPoker.bas",				"")
#endif


inc("gSpace.bas",				"")
inc("gWorldgen.bas",			"")
inc("gStartnewgame.bas",		"")

inc("cCards.bas",				"Playing card rendering")
inc("cCasino.bas",				"")
inc("cPoker.bas",				"")
inc("cSlotmachine.bas",			"")


inc("gFuel.bas",				"")
inc("gCockpit.bas",				"")
inc("gLogbook.bas",				"")
inc("gParty.bas",				"")
inc("gSpacecombatmap.bas",		"")
inc("gSummary.bas",				"")
inc("gAttack.bas",				"")
inc("gAutoexplore.bas",			"")
inc("gAwayteam.bas",			"")
inc("gMonstermove.bas",			"")
inc("gExploreplanet.bas",		"")
inc("gLanding.bas",				"")
inc("gRadio.bas",				"")
inc("gRover.bas",				"")
inc("gExplore.bas",				"")
inc("gWaypoints.bas",			"")
inc("gAutopilot.bas",			"")
inc("gExplorespace.bas",		"")
inc("gProbes.bas",				"")
inc("gSpacecombat.bas",			"")
inc("gSpacecombatfunctions.bas","")
inc("gColony.bas",				"")
inc("gPlanetmenu.bas",			"")
inc("gPlaneteffect.bas",		"")
'
inc("gGamekeys.bas",			"'legacy' action-wiring")
'inc("vMenu.bas",				"menu with graphics as before, for reference. should wind up with an override maybe")

#if false

#endif






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






