'wStartnewgame.

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
'     -=-=-=-=-=-=-=- TEST: wStartnewgame -=-=-=-=-=-=-=-
#undef intest
#define test
#endif'test

namespace wStartnewgame

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: wStartnewgame -=-=-=-=-=-=-=-
'function gotslotforsavegame(iBg as short) As integer 
#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: wStartnewgame -=-=-=-=-=-=-=-
Declare function start_new_game(iAction as integer) As integer	' only declared to get hooked
Declare function play_game(iAction as integer) as integer

function init(iAction as integer) as integer
	tGame.pStart_new_game = @start_new_game
	tGame.pPlay_game = @play_game
	return 0
end function

Private function gotslotforsavegame(iAction as integer) As integer 
    Dim As String aText
    If count_savegames()>20 Then       
        rlprint "Too many Savegames, choose one to overwrite",14
        aText=getfilename(iBg)
        If aText<>"" Then
            If askyn("Are you sure you want to delete "&aText &"(y/n)") Then
                Kill("savegames/"&aText)
                return 1
            EndIf
        EndIf
		return 0 'nope    	
    else
		return 1    	
    EndIf    
End Function


function start_new_game(iAction as integer) As integer
    DimDebugL(0)'1'127
    Dim _debug As Byte	' needs renaming/removing still    

    Dim As String text
    Dim As integer a,b,c,f,d
    Dim doubleitem(4555) As Byte
    Dim i As _items

	If gotslotforsavegame(iBg)=0 Then return -1
    
    make_spacemap(iBg)
    DbgPlanetTempCSV

    text="/"&makehullbox(1,"data/ships.csv") &"|Comes with 3 Probes MKI/"&makehullbox(2,"data/ships.csv")&"|Comes with 2 combat drones and fully armored|You get one more choice at a talent if you take this ship/"&makehullbox(3,"data/ships.csv") &"|Comes with paid for cargo to collect on delivery/"&makehullbox(4,"data/ships.csv") &"|Comes with 5 veteran security team members/"&makehullbox(6,"data/ships.csv")&"|You will start as a pirate if you choose this option"
    If configflag(con_startrandom)=1 Then
        b=textMenu(iBg,"Choose ship/Scout/Long Range Fighter/Light Transport/Troop Transport/Pirate Cruiser/Random",text)
    Else
        b=rnd_range(1,4)
    EndIf
    player=make_ship(1)
    If b=6 Then b=rnd_range(1,4)
    c=b
    If b=5 Then c=6
    upgradehull(c,player)
    player.hull=player.h_maxhull
    rlprint "Your ship: "&player.h_desig
    d=0
    Do
        d+=1
        i=rnd_item(RI_WeakWeapons)
        doubleitem(i.id)+=1
        placeitem(i,0,0,0,0,-1) 'Weapons and armor
    Loop Until equipment_value>750 Or d>5 'No more than 6 w&as
    d=0
    Do
        d+=1
        Do
            i=rnd_item(RI_WeakStuff)
        Loop Until doubleitem(i.id)=0
        doubleitem(i.id)+=1
        placeitem(i,0,0,0,0,-1) 'Other stuff
    Loop Until equipment_value>1000 And d>2 'At least 3 other stuffs

    If _debug=707 Then
        placeitem(make_item(48),0,0,0,0,-1)
        placeitem(make_item(52),0,0,0,0,-1)
        For c=1 To 10
            placeitem(make_item(24),0,0,0,0,-1)
            placeitem(make_item(26),0,0,0,0,-1)
        Next
    EndIf

    If b=1 Then
        placeitem(make_item(100),0,0,0,0,-1)
        placeitem(make_item(100),0,0,0,0,-1)
        placeitem(make_item(100),0,0,0,0,-1)
        If _debug>0 Then placeitem(make_item(50),,,,,-1)
        If _debug>0 Then placeitem(make_item(50),,,,,-1)
        If _debug>0 Then placeitem(make_item(50),,,,,-1)
        If _debug>0 Then placeitem(make_item(51),,,,,-1)
        If _debug>0 Then placeitem(make_item(51),,,,,-1)
        If _debug>0 Then placeitem(make_item(52),,,,,-1)
        If _debug>0 Then placeitem(make_item(52),,,,,-1)
        If _debug=1 Then placeitem(make_item(65),,,,,-1)
        If _debug=1 Then placeitem(make_item(66),,,,,-1)
        If _debug=1 Then placeitem(make_item(301),,,,,-1)
        If _debug=1 Then placeitem(make_item(105),,,,,-1)
        If _debug=1 Then placeitem(make_item(64),,,,,-1)
        If _debug=999 Then placeitem(make_item(301),,,,,-1)
        If _debug=2411 Then placeitem(make_item(301),,,,,-1)
        If _debug=1211 Then placeitem(make_item(30),,,,,-1)
        If _debug>0 Then player.weapons(2)=make_weapon(95)
'        placeitem(make_item(250),0,0,0,0,-1)
'        placeitem(make_item(162),0,0,0,0,-1)
'        placeitem(make_item(162),0,0,0,0,-1)
'        placeitem(make_item(163),0,0,0,0,-1)
        If _debug=1 Then placeitem(make_item(23),0,0,0,0,-1)
        'player.cargo(1).x=10
'        placeitem(make_item(52),0,0,0,0,-1)
'        placeitem(make_item(52),0,0,0,0,-1)
'        placeitem(make_item(52),0,0,0,0,-1)
'        for a=0 to 1000
'        i=make_item(96)
'        placeitem(i,0,0,0,0,-1)
'        reward(2)+=i.v1
'        next
        'player.pilot=3
        'placeitem(make_item(85),0,0,0,0,-1)
        'placeitem(make_item(85),0,0,0,0,-1)
    EndIf

    If b=2 Then
        player.equipment(se_shipdetection)=1
        placeitem(make_item(110),0,0,0,0,-1)
        placeitem(make_item(110),0,0,0,0,-1)
    EndIf

    If b=3 Then
        player.cargo(1).x=11
        player.cargo(2).x=rnd_range(1,3)
        player.cargo(1).y=nearest_base(player.c)
        player.cargo(2).y=rnd_range(1,5)*player.cargo(2).x
    EndIf


    add_member(1,0)
    add_member(2,1)
    add_member(3,1)
    add_member(4,1)
    add_member(5,1)
    If debug=3 And _debug=1 Then player.questflag(22)=1


    If b=4 Then
        player.security=5
        For c=6 To 10
            add_member(7,0)
        Next
    EndIf

    Select Case startingweapon
    Case 1
        player.weapons(1)=make_weapon(rnd_range(6,7))
    Case 2
        player.weapons(1)=make_weapon(rnd_range(1,2))
    Case Else
        If rnd_range(1,100)<51 Then
            player.weapons(1)=make_weapon(rnd_range(6,7))
        Else
            player.weapons(1)=make_weapon(rnd_range(1,2))
        EndIf
    End Select
    If b=5 Then
        player.weapons(2)=make_weapon(99)
        player.weapons(3)=make_weapon(99)
        pirateupgrade
        recalcshipsbays()
        player.engine=2
        player.hull=10
        faction(0).war(2)=-100
        faction(0).war(1)=100
        makeplanetmap(piratebase(0),3,map(sysfrommap(piratebase(0))).spec)
        planets(piratebase(0)).mapstat=1
        player.c=map(sysfrommap(piratebase(0))).c
#if __FB_DEBUG__
        player.c.x=drifting(1).x
        player.c.y=drifting(1).y
#endif
    EndIf
    tVersion.gameturn=0
    If start_teleport=1 Then artflag(9)=1
    set__color(11,0)
    Cls
    set__color( 11,0)

    If b<5 Then
        c=2+textbox("An unexplored sector of the galaxy. You are a private Prospector. You can earn money by mapping planets and finding resources. Your goal is to make sure you can live out your life in comfort in your retirement. || But beware of alien lifeforms and pirates. You start your career with a nice little "&player.h_desig &".",5,5,50,11,0)
        draw_string(5*_fw1,5*_fh1+c*_fh2, "You christen the beauty (Enter to autoname):",font2,_col)
        faction(0).war(1)=0
        faction(0).war(2)=100
        faction(0).war(3)=0
        faction(0).war(4)=100
        faction(0).war(5)=100
    Else
        c=2+textbox("A life of danger and adventure awaits you, harassing the local shipping lanes as a pirate. It won't be easy but if you manage to avoid the company patrols, and get good loot, it will be very profitable! You will be able to spend the rest of your life in luxury. You start your career with a nice little "&player.h_desig &".",5,5,50,11,0)
        draw_string(5*_fw1,5*_fh1+c*_fh2, "You christen the beauty (Enter to autoname):",font2,_col)
        faction(0).war(1)=100
        faction(0).war(2)=0
        faction(0).war(3)=100
        faction(0).war(4)=0
        faction(0).war(5)=100
    EndIf
    faction(1).war(2)=100
    faction(1).war(4)=100
    faction(2).war(1)=100
    faction(2).war(3)=100
    faction(3).war(2)=100
    faction(3).war(4)=100
    faction(4).war(1)=100
    faction(4).war(3)=100

    player.desig=gettext((5*_fw1+44*_fw2),(5*_fh1+c*_fh2),32,"",1)
    If player.desig="" Then player.desig=randomname()
    tVersion.gamedesig=player.desig
    
    If tFile.Openinput("savegames/"&player.desig &".sav",a)>0 Then
        tFile.Closefile(a)
        Do
            draw_string (50,10*_fh2, "That ship is already registered.",font2,_col)
            draw_string(50,9*_fh2, "You christen the beauty:" &Space(25),font2,_col)
            player.desig=gettext((5*_fw1+25*_fw2)/_fw2,(5*_fh1+c*_fh2)/_fh2,13,"")
            If player.desig="" Then player.desig=randomname()
            tVersion.gamedesig=player.desig
        Loop Until fileexists("savegames/"&player.desig &".sav")=0
    EndIf
    If (debug=3 Or debug=99) And _debug=1 Then
        fleet(lastfleet+1)=makealienfleet
        fleet(lastfleet+1).c=basis(0).c
        fleet(lastfleet+2)=makealienfleet
        fleet(lastfleet+2).c=basis(1).c
        fleet(lastfleet+3)=makealienfleet
        fleet(lastfleet+3).c=basis(2).c
        rlprint "fleettypes"& fleet(lastfleet+1).ty &":" & fleet(lastfleet+2).ty &":"& fleet(lastfleet+3).ty
        lastfleet+=3
    EndIf
    If (debug=127 And _debug>0) Then
        upgradehull(18,player,0)
        player.hull=10
        player.engine=3
        player.sensors=6
        player.shieldmax=5
        player.weapons(1)=make_weapon(66)
        player.weapons(2)=make_weapon(66)
        For a=1 To 45
            add_member(8,0)
            placeitem(make_item(97),0,0,0,0,-1)
            placeitem(make_item(98),0,0,0,0,-1)
        Next
        player.money+=10000
        artflag(16)=1

    EndIf

    If debug=126 And _debug>0 Then
        upgradehull(9,player,0)
        player.hull=player.h_maxhull
        player.engine=3
        player.sensors=3
        player.shieldmax=2
        player.weapons(1)=make_weapon(4)
        player.weapons(1)=make_weapon(3)
        For a=1 To 15
            add_member(8,0)
            placeitem(rnd_item(RI_WEAPONS),0,0,0,0,-1)
            placeitem(rnd_item(RI_Armor),0,0,0,0,-1)
        Next
        player.money+=6000
    EndIf
    If _debug>0 Then player.money=10000000
    If debug=2 And _debug=1 Then rlprint disnbase(map(sysfrommap(specialplanet(7))).c) &":"& disnbase(map(sysfrommap(specialplanet(46))).c)
    If _debug=1 Then player.cursed=1
    just_run=run_until
    If show_specials>0 Then
        player.c=map(sysfrommap(specialplanet(show_specials))).c
    EndIf
    set__color(11,0)
    If _debug=2411 Then tVersion.gameturn=500000
    If debug=125 And _debug>0 Then player.money=3000
    update_world(2)
    If _debug=1501 Then
        For a=1 To 3
            station_event(drifting(a).m)
        Next
    EndIf
    Cls
    Return 1' iAction==startnewgame
End function


function play_game(iAction as integer) as integer
    if iAction=7 then
    	player.dead=99
		death_message(iBg,2600)
		player.dead=0
    	return 0	    	
    elseif (Key="1" Or Key="2") And (iAction=0) And (player.dead=0) Then
        tVersion.gamerunning=1
        display_stars(1)
        display_ship(1)
        explore_space
    EndIf
    If (player.dead>0) and not (configflag(con_restart)=1 or player.dead=99) Then
	  death_message(iBg)
    EndIf
	player.dead=0
    'set__color(15,0)
	If configflag(con_restart)=0 Then
        load_game("empty.sav")
        clear_gamestate
        tVersion.gamerunning=0
	EndIf
	return 0 ' iAction= do nothing. go back to menu
End function


#endif'main
end namespace'wStartnewgame

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: wStartnewgame -=-=-=-=-=-=-=-
	tModule.register("wStartnewgame",@wStartnewgame.init()) ',@wStartnewgame.load(),@wStartnewgame.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: wStartnewgame -=-=-=-=-=-=-=-
#endif'test
