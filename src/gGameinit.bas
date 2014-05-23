'tGameinit.
'
'defines:
'clear_gamestate=2, setglobals=0, check_filestructure=0, Initgame=1
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
'     -=-=-=-=-=-=-=- TEST: tGameinit -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tGameinit -=-=-=-=-=-=-=-

declare function Reset_game(iAction as integer) as Integer
declare function clear_gamestate() As Short

declare function Initgame() as integer

'declare function setglobals() as short
'declare function check_filestructure() as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tGameinit -=-=-=-=-=-=-=-


function Reset_game(iAction as integer) as Integer
    tVersion.gamerunning= false
	player.dead=false
    clear_gamestate()
    loadgame()
	return 0
End Function


namespace tGameinit
function init(iAction as integer) as integer
	tGame.pReset_game= @Reset_game
	return 0
end function
end namespace'tGameinit


function clear_gamestate() As Short
    Dim As Short a,x,y
    Dim d_crew As _crewmember
    Dim d_planet As _planet
    Dim d_ship As _ship
    Dim d_map As _stars
    Dim d_item As _items
    Dim d_fleet As _fleet
    Dim d_basis As _basis
    Dim d_drifter As _driftingship
    Dim d_portal As _transfer
    
    set__color(15,0)
    Draw String(tScreen.x/2-7*_fw1,tScreen.y/2),"Resetting game",,font2,custom,@_col

    player=d_ship

    For a=0 To 255
        crew(a)=d_crew
    Next

    For a=0 To laststar+wormhole
        map(a)=d_map
    Next
    wormhole=8

    For a=0 To max_maps
        planets(a)=d_planet
        For x=0 To 60
            For y=0 To 20
                planetmap(x,y,a)=0
            Next
        Next
    Next
    lastplanet=0

    For a=0 To lastspecial
        specialplanet(a)=0
    Next

    For a=0 To lastfleet
        fleet(a)=d_fleet
    Next
    lastfleet=0

    For a=1 To lastdrifting
        drifting(a)=d_drifter
    Next
    lastdrifting=16


    For a=0 To 25000
        item(a)=d_item
    Next
    lastitem=-1


    basis(0)=d_basis
    basis(0).c.x=50
    basis(0).c.y=20
    basis(0).discovered=1
    basis(0)=makecorp(0)

    basis(1)=d_basis
    basis(1).c.x=10
    basis(1).c.y=25
    basis(1).discovered=1
    basis(1)=makecorp(0)

    basis(2)=d_basis
    basis(2).c.x=75
    basis(2).c.y=10
    basis(2).discovered=1
    basis(2)=makecorp(0)

    basis(3)=d_basis
    basis(3).c.x=-1
    basis(3).c.y=-1
    basis(3).discovered=0

    baseprice(1)=50
    baseprice(2)=200
    baseprice(3)=500
    baseprice(4)=1000
    baseprice(5)=2500

    For a=0 To 5
        avgprice(a)=0
    Next
    For a=0 To 20
        flag(a)=0
    Next

    For a=0 To lastflag
        artflag(a)=0
    Next


    For a=0 To 255
        portal(a)=d_portal
    Next


    Return 0
End function


function setglobals() as short
    dim as short a,b,c,d,f        
    dim as string text
    dim iAction as integer
    '
    ' Variables
    '
    iAction=tCompany.init(0)
    
    shopname(1) ="Explorers Gear"
    shopname(2) ="Cheap Chunks"
    shopname(3) ="Space'n'Stuff"
    shopname(4) ="YeOlde Weapons Locker"
    
	iAction=tShipyard.init(0)
	    
    ammotypename(0)="Kinetic projectile"
    ammotypename(1)="Explosive shell"
    ammotypename(2)="Fission Warhead"
    ammotypename(3)="Fusion Warhead"
    ammotypename(4)="Quantum Warhead"
    
    awayteamcomp(0)=1
    awayteamcomp(1)=1
    awayteamcomp(2)=1
    awayteamcomp(3)=1
    awayteamcomp(4)=1
    
    piratenames(ST_PFighter)="pirate fighter"                  
    piratenames(ST_PCruiser)="pirate cruiser"                  
    piratenames(ST_PDestroyer)="pirate destroyer" 
    piratenames(ST_PBattleship)="pirate battleship"
    piratenames(ST_lighttransport)="light transport"                 
    piratenames(ST_heavytransport)="heavy transport"                 
    piratenames(ST_merchantman)="merchantman"                 
    piratenames(ST_armedmerchant)="armed merchantman"                 
    piratenames(ST_CFighter)="company fighter"                         
    piratenames(ST_CEscort)="company escort"                          
    piratenames(ST_Cbattleship)="company battleship"                         
    piratenames(ST_AnneBonny)="Anne Bonny"                      
    piratenames(ST_BlackCorsair)="Black Corsair"                   
    piratenames(st_hussar)="Hussar"
    piratenames(st_blackwidow)="Black Widow"
    piratenames(st_adder)="Adder"
    piratenames(ST_AlienScoutShip)="ancient alien scoutship"              
    piratenames(ST_spacespider)="space spider"                  
    piratenames(ST_livingsphere)="living sphere"                   
    piratenames(ST_hydrogenworm)="hydrogen worm"   
    piratenames(ST_livingplasma)="living plasma"
    piratenames(ST_starjellyfish)="star jellyfish"        
    piratenames(ST_cloudshark)="cloudshark"         
    piratenames(ST_Gasbubble)="gas bubble"
    piratenames(ST_cloud)="symbiotic cloud"
    piratenames(ST_Floater)="floater"
    piratenames(st_spacestation)="space station"
    
    questguyjob(1)="Station Commander"
    questguyjob(2)="Freelancer"
    questguyjob(3)="Security"
    questguyjob(4)="Science Officer"
    questguyjob(5)="Gunner"
    questguyjob(6)="Doctor"
    questguyjob(7)="Merchant"
    questguyjob(8)="Colonist"
    questguyjob(9)="Tourist"
    questguyjob(10)="Megacorp rep for EE"
    questguyjob(11)="Megacorp rep for SHI"
    questguyjob(12)="Megacorp rep for TT"
    questguyjob(13)="Megacorp rep for OBE"
    questguyjob(14)="Entertainer"
    questguyjob(15)="Xenobiologist"
    questguyjob(16)="Astrophysicist"
    questguyjob(17)="Engineer"
'    qt_EI'1
'    qt_autograph'3
'    qt_outloan'4
'    qt_stationimp'5
'    qt_drug'6
'    qt_souvenir'7
'    qt_tools'8
'    qt_showconcept'9
'    qt_stationsensor'10
'    qt_alibi'11
'    qt_message'12
'    qt_locofpirates'!3
'    qt_locofspecial'14
'    qt_locofgarden'15
'    qt_locofperson'16
'    qt_goodpaying'17
'    qt_research'18
'    qt_megacorp'19
'    qt_biodata'20
'    qt_anomaly'21
'    qt_juryrig'22
'    
   
    crew_desig(1)="Captain"
    crew_desig(2)="Pilot"
    crew_desig(3)="Gunner"
    crew_desig(4)="Science"
    crew_desig(5)="Doctor"
    crew_desig(6)="Green"
    crew_desig(7)="Veteran"
    crew_desig(8)="Elite"
    crew_desig(9)="Insect Warrior"
    crew_desig(10)="Cephalopod"
    crew_desig(11)="Neodog"
    crew_desig(12)="Neoape"
    crew_desig(13)="Robot"
    crew_desig(14)="Squad Leader"
    crew_desig(15)="Sniper"
    crew_desig(16)="Paramedic"
    
    specialplanettext(1,0)="I got some strange sensor readings here sir. can't make any sense of it."
    specialplanettext(1,1)="The readings are gone. must have been that temple."
    specialplanettext(2,0)="There is a ruin of an anient city here, but I get no signs of life. Some high energy readings though."
    specialplanettext(2,1)="With the planetary defense systems disabled it is safe to land here."
    specialplanettext(3,0)="Ruins of buildings cover the whole planet, but I get no readings on life forms"
    specialplanettext(4,0)="Ruins of buildings cover the whole planet, but I get no readings on life forms"
    specialplanettext(5,0)="Readings indicate almost no water, and extremly high winds. Also very strong readings for lifeforms"
    specialplanettext(6,0)="The atmosphere of this planet is very peculiar. It only lets light in the UV range to the surface"
    specialplanettext(8,0)="Extremly high winds and severe lightning storms on this planet"
    specialplanettext(10,0)="There is a settlement on this planet. Humans."
    specialplanettext(10,1)="The colony sends us greetings."
    specialplanettext(11,0)="There is a ship here sending a distress signal."
    specialplanettext(11,1)="They are still sending a distress signal"
    specialplanettext(12,0)="I got some very strange sensor readings here sir. can't make any sense of it. They seem to come from a structure at the equator."
    specialplanettext(12,1)="The readings are gone. must have been that temple."
    specialplanettext(13,0)="There is a modified emergency beacon on this planet. It broadcasts this message: 'Visit Murchesons Ditch, best Entertainment this side of the coal sack nebula'"
    specialplanettext(14,0)="A human settlement dominates this planet. There is a big shipyard too."
    specialplanettext(15,0)="I am getting a high concentration of valuable ore here, but it seems to be underground. i can not pinpoint it."
    specialplanettext(15,1)="Nothing special about this  world."
    specialplanettext(16,0)="Mild climate, dense vegetation, atmosphere composition almost exactly like earth, gravity slightly lower. Shall we call this planet 'eden'?"
    specialplanettext(17,0)="There are signs of civilization on this planet. Technology seems to be similiar to mid 20th century earth. There are lots of factories with higly toxic emissions. The planet also seems to start suffering from a runaway greenhouse effect."
    specialplanettext(17,1)="It will still take several decades before the climate on this planet normalizes again."
    specialplanettext(18,0)="There are several big building complexes on this planet. I also get the signatures of advanced energy sources."
    specialplanettext(19,0)="There are buildings on this planet and a big sensor array. Advanced technology, propably FTL capable." 
    specialplanettext(20,0)="There is a human colony on this planet."
    specialplanettext(20,1)="There is a human colony on this planet. Also some signs of beginning construction since we were last here."
    specialplanettext(26,0)="No water, but the mountains on this planet are high rising spires of crystal and quartz. This place is lifeless, but beautiful!"
    specialplanettext(27,0)="This small planet has no atmosphere. A huge and unusually deep crater dominates its surface."
    specialplanettext(27,1)="The Planetmonster is dead."
    specialplanettext(28,0)="Ruins of buildings cover the whole planet, but i get no readings on life forms"
    specialplanettext(29,0)="This is the most boring piece of rock I ever saw. Just a featureless plain of stone."
    specialplanettext(30,0)="I don't know why, but this planet has a temperate climate now. There are signs of life and a huge structure on the western hemishpere."
    specialplanettext(30,1)="I don't know why, but this planet has a temperate climate now. There are signs of life and a huge structure on the western hemishpere."
    specialplanettext(31,0)="There is a perfectly spherical large asteroid here. 2km diameter it shows no signs of any impact craters and readings indicate a very high metal content"
    specialplanettext(32,0)="There is a huge asteroid here. It has a very low mass though. I am also getting faint energy signatures."
    specialplanettext(33,0)="There is a huge asteroid here. It has a very low mass though. I am also getting faint energy signatures. There are ships on the surface"
    specialplanettext(34,0)="I am getting very, very high radiaton readings for this planet. Landing here might be dangerous."
    specialplanettext(35,0)="This planets surface is covered completely in liquid."
    specialplanettext(37,0)="There is a huge lutetium deposit here."
    specialplanettext(39,0)="A beautiful world with a mild climate. Huge areas of cultivated land are visible, even from orbit, along with some small buildings."
    specialplanettext(40,0)="A beautiful world with a mild climate. There is one big artificial structure."
    specialplanettext(41,0)="There is a big asteroid with a landing pad and some buildings here."
    
    spdescr(0)="The destination of a generation ship"
    spdescr(1)="The home of an alien claiming to be a god"
    spdescr(2)="An alien city with working defense systems"
    spdescr(3)="An ancient city"
    spdescr(4)="Another ancient city"
    spdescr(5)="A world without water and huge sandworms"
    spdescr(6)="A world with invisible beasts"
    spdescr(8)="A world with very violent weather"
    spdescr(9)="An alien base still in good condition"
    spdescr(10)="An independent colony"
    spdescr(11)="A casino trying to cheat"
    spdescr(12)="The prison of an ancient entity"
    spdescr(13)="Murchesons Ditch"
    spdescr(14)="The blackmarket"
    spdescr(15)="A pirate gunrunner operation" 
    spdescr(16)="A planet with immortal beings" 
    spdescr(17)="A civilization upon entering the space age"
    spdescr(18)="The home planet of a civilization about to explore the stars"
    spdescr(19)="The outpost of an advanced civilization"
    spdescr(20)="A creepy colony"
    spdescr(21)="An ancient refueling platform"
    spdescr(22)="An ancient refueling platform"
    spdescr(23)="An ancient refueling platform"
    spdescr(24)="An ancient refueling platform"
    spdescr(25)="An ancient refueling platform"
    spdescr(26)="A crystal planet"
    spdescr(27)="A living planet"
    spdescr(28)="An ancient city with an intact spaceport"
    spdescr(29)="A very boring planet"
    spdescr(30)="The last outpost of an ancient race"
    spdescr(31)="An asteroid base of an ancient race"
    spdescr(32)="An asteroid base"
    spdescr(33)="Another asteroid base"
    spdescr(34)="A world devastated by war"
    spdescr(35)="A world populated by peaceful cephalopods"
    spdescr(36)="A tribe of small green people in trouble"
    spdescr(37)="An invisible labyrinth"
    spdescr(39)="A very fertile world plagued by burrowing monsters"
    spdescr(40)="A world under control of Eridiani Explorations"
    spdescr(41)="A world under control of Smith Heavy Industries"
    spdescr(42)="A world under control of Triax Traders"
    spdescr(43)="A world under control of Omega Bioengineering"
    spdescr(44)="The ruins of an ancient war"
  

    foundsomething=0
    
    '0=right,1=left
    
    bestaltdir(1,0)=4
    bestaltdir(1,1)=2
    
    bestaltdir(2,0)=1
    bestaltdir(2,1)=3
    
    bestaltdir(3,0)=2
    bestaltdir(3,1)=6
    
    bestaltdir(4,0)=7
    bestaltdir(4,1)=1
    
    bestaltdir(6,0)=3
    bestaltdir(6,1)=9
    
    bestaltdir(7,0)=8
    bestaltdir(7,1)=4
    
    bestaltdir(8,0)=9
    bestaltdir(8,1)=7
    
    bestaltdir(9,0)=6
    bestaltdir(9,1)=8
    
    basis(0)=makecorp(0)
    basis(0).c.x=sm_x/2
    basis(0).c.y=sm_y/2
    basis(0).discovered=1
    
    basis(1)=makecorp(0)
    basis(1).c.x=10
    basis(1).c.y=sm_y-10
    basis(1).discovered=1
    
    basis(2)=makecorp(0)
    basis(2).c.x=sm_x-10
    basis(2).c.y=10
    basis(2).discovered=1
    
    basis(3)=makecorp(0)
    basis(3).c.x=-1
    basis(3).c.y=-1
    basis(3).discovered=0
    
    baseprice(1)=100
    baseprice(2)=250
    baseprice(3)=500
    baseprice(4)=750
    baseprice(5)=1000
    baseprice(6)=500
    baseprice(7)=500
    baseprice(8)=500
    baseprice(9)=30
    
    for a=1 to 5
        avgprice(a)=baseprice(a)
    next
    
    for a=0 to 12
        basis(a).inv(1).v=rnd_range(1,6)+4
        basis(a).inv(1).p=baseprice(1)
        
        basis(a).inv(2).v=rnd_range(1,7)+3
        basis(a).inv(2).p=baseprice(2)
        
        basis(a).inv(3).v=rnd_range(1,8)+2
        basis(a).inv(3).p=baseprice(3)
        
        basis(a).inv(4).v=rnd_range(1,8)+1
        basis(a).inv(4).p=baseprice(4)
        
        basis(a).inv(5).v=rnd_range(1,8)
        basis(a).inv(5).p=baseprice(5)
        
        basis(a).inv(6).p=baseprice(6)
        if  basis(a).company=4 then
            basis(a).inv(6).v=rnd_range(1,8)
        else
            basis(a).inv(6).v=0
        endif
        
        basis(a).inv(7).p=baseprice(7)
        if  basis(a).company=2 then
            basis(a).inv(7).v=rnd_range(1,8)
        else
            basis(a).inv(7).v=0
        endif
        
        basis(a).inv(8).p=baseprice(8)
        if  basis(a).company=1 then
            basis(a).inv(8).v=rnd_range(1,8)
        else
            basis(a).inv(8).v=0
        endif
        
        basis(a).inv(9).p=baseprice(9)
        basis(a).inv(9).v=5
    next
    
    for a=0 to 1024
        portal(a).ti_no=3001
    next
    
    if fileexists("data/ships.csv") then
        f=freefile
        open "data/ships.csv" for input as #f
        b=1
        c=0
        for c=0 to 16
            line input #f,text
            shiptypes(c)=""
            do
                shiptypes(c)=shiptypes(c)&mid(text,b,1)
                b=b+1
            loop until mid(text,b,1)=";"
            b=1
        next
        close #f
        shiptypes(17)="alien vessel"
        shiptypes(18)="ancient alien scoutship. It's hull covered in tiny impact craters"
        shiptypes(19)="primitve alien spaceprobe, hundreds of years old travelling sublight through the void"
        shiptypes(20)="small space station"
    else
        set__color( 14,0)
        print "ships.csv not found. Can't start game"
        sleep
        end
    endif


    load_dialog_quests
    
    for a=1 to 512
        tiles(a).no=a
        tiles(a).ti_no=100+a
    next
    
    tiles(243).ti_no=2500
    tiles(201).ti_no=2505
    tiles(202).ti_no=2501
    tiles(203).ti_no=2502
    tiles(204).ti_no=2503
    tiles(205).ti_no=2504
    tiles(199).ti_no=2509
    tiles(199).ti_no=2509
    tiles(199).ti_no=2509
    for a=1 to max_maps
        planets(a)=planets(0)
        planets(a).grav=1
    next
    for a=0 to 255
        dtextcol(a)=11
    next
    for a=0 to fix((22*_fh1)/_fh2)
        displaytext(a)=" "
    next
    
    player.desig=""
    tVersion.gamedesig=player.desig
    
    return 0
end function


function Initgame() as integer
	load_config()
	tColor.load_palette()
   	load_fonts()
	check_filestructure()
	load_keyset()
	uSound.load()
	load_tiles()
	'
	DbgScreeninfo
	register()
	setglobals
	'DbgWeapdumpCSV
    'DbgTilesCSV
    return 0   
End function
#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tGameinit -=-=-=-=-=-=-=-
	tModule.register("tGameinit",@tGameinit.init()) ',@tGameinit.load(),@tGameinit.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tGameinit -=-=-=-=-=-=-=-
#endif'test
