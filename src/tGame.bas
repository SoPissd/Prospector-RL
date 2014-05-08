'tGame

'Declare function cursor(target as _cords,map as short,osx as short,osy as short=0,radius as short=0) as string

Function start_new_game() As Short
    DimDebugL(0)'1'127
    Dim _debug As Byte	' needs renaming/removing still    

    Dim As String text
    Dim As Short a,b,c,f,d
    Dim doubleitem(4555) As Byte
    Dim i As _items
    
    make_spacemap()
    DbgPlanetTempCSV

    text="/"&makehullbox(1,"data/ships.csv") &"|Comes with 3 Probes MKI/"&makehullbox(2,"data/ships.csv")&"|Comes with 2 combat drones and fully armored|You get one more choice at a talent if you take this ship/"&makehullbox(3,"data/ships.csv") &"|Comes with paid for cargo to collect on delivery/"&makehullbox(4,"data/ships.csv") &"|Comes with 5 veteran security team members/"&makehullbox(6,"data/ships.csv")&"|You will start as a pirate if you choose this option"
    If configflag(con_startrandom)=1 Then
        b=Menu(bg_randompic,"Choose ship/Scout/Long Range Fighter/Light Transport/Troop Transport/Pirate Cruiser/Random",text)
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
    gameturn=0
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
    gamedesig=player.desig
    
    a=Freefile
    If Open ("savegames/"&player.desig &".sav" For Input As a)=0 Then
        Close a
        Do
            draw_string (50,10*_fh2, "That ship is already registered.",font2,_col)
            draw_string(50,9*_fh2, "You christen the beauty:" &Space(25),font2,_col)
            player.desig=gettext((5*_fw1+25*_fw2)/_fw2,(5*_fh1+c*_fh2)/_fh2,13,"")
            If player.desig="" Then player.desig=randomname()
            gamedesig=player.desig
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
    If _debug=2411 Then gameturn=500000
    If debug=125 And _debug>0 Then player.money=3000
    update_world(2)
    If _debug=1501 Then
        For a=1 To 3
            station_event(drifting(a).m)
        Next
    EndIf
    Cls
    Return 0
End Function



function keyin(byref allowed as string="" , blocked as short=0)as string
    DimDebugL(0)'1
    dim key as string
    dim as string text
    static as byte recording
    static as byte seq
    static as string*3 comseq
    static as string*3 lastkey
    dim as short a,b,i,tog1,tog2,tog3,tog4,ctr,f,it
    dim as string control

    if walking<>0 then sleep 50
    flip
    if _test_disease=1 and allowed<>"" then allowed="#"&allowed
    if gamerunning and allowed<>"" then allowed=allowed &" " ' gamerunning == player.dead>0
    do 
        control=""
        do        
            If (ScreenEvent(@evkey)) Then
'                
'if evkey.ascii=0 and evkey.scancode=23 or evkey.ascii=asc(key_extended) then
'                    if evkey.type=EVENT_KEY_PRESS or evkey.type=EVENT_KEY_REPEAT THEN
'                        if evkey.scancode=23 then control="\C"
'                        if evkey.ascii=asc(key_extended) then control=key_extended
'                    else
'                        control=""
'                    endif
'                endif
                Select Case evkey.type
               	case FB.EVENT_KEY_REPEAT
                        while screenevent(@evkey)
                        wend
                        key=lastkey
                	Case (FB.EVENT_KEY_PRESS)
                        if debug =1 then
                            locate 1,1
                            print evkey.scancode &":"& evkey.ascii &":"&FB.EVENT_KEY_PRESS &":"&FB.EVENT_KEY_REPEAT
                        endif
                        select case evkey.scancode
									case FB.sc_down
                            key = key_south
                        	case FB.sc_up
                            key = key_north
                        	case FB.sc_left
                            key = key_west
                        	case FB.sc_right
                            key = key_east
                        	case FB.sc_home
                            key = key_nw
                        	case FB.sc_pageup
                            key = key_ne
                        	case FB.sc_end
                            key = key_sw
                        	case FB.sc_pagedown
                            key = key_se
                        	case FB.sc_escape
                            key=key__esc
                        	case FB.sc_enter
                            key=key__enter
                       		case FB.sc_pageup
                            key=key_pageup
                        	case FB.sc_pagedown
                            key=key_pagedown
                        	'case sc_control
                        	' control="\C"
                        	case else
                            if evkey.ascii<=26 then
                                key="\C"&chr(evkey.ascii+96)
                            else
                                if len(chr(evkey.ascii))>0 then key = chr(evkey.ascii)
                            endif
                        end select
                    
                    end select
                endif            
            sleep 1
        loop until key<>"" or walking<>0 or (allowed="" and gamerunning) or just_run<>0 'gamerunning==player.dead<>0
        lastkey=key    
        comstr.nextpage
        if key<>"" then walking=0 
'        if _test_disease=1 and key="#" then
'            a=getnumber(0,255,0)
'            b=Getnumber(0,255,0)
'            crew(a).disease=b
'            crew(a).duration=disease(b).duration
'            crew(a).incubation=disease(b).incubation
'            if b>player.disease then player.disease=b
'            rlprint a &":" & b
'            a=0
'            b=0
'            key=""
'        endif
        
        if blocked>=97 then
            if (asc(key)>=97 and asc(key)<=blocked) then return key
        endif
        if blocked=0 or blocked>=97 then
                        
#if __FB_DEBUG__
            if debug>0 and key="\Ci" then
            	DbgItemDump
            endif
            
            if debug=-1 and key="�" then
                for x=0 to 60
                    for y=0 to 20
                        planetmap(x,y,player.map)=abs(planetmap(x,y,player.map))
                    next
                next
            endif
            
            if debug>0 and key="�" then
            	DbgFleetsDump
            endif
                
            
            if debug>0 and key=key_testspacecombat then
                spacecombat(fleet(rnd_range(6,lastfleet)),9)
            endif
#endif
            
            if key=key_awayteam then
                if location=lc_onship then
                    showteam(0)
                else
                    showteam(1)
                endif
                return ""
            endif
            
            if key=key_accounting then
                textbox(income_expenses,2,2,45,11,1)
                no_key=keyin
                return ""
            endif
            
            if key=key_manual then
                a=menu(bg_parent,"Help/Manual/Keybindings/Configuration/Exit","",2,2)
                if a=1 then viewfile("readme.txt")
                if a=2 then keybindings
                if a=3 then configuration
                return ""
            endif
            
            if key=key_messages then 
                messages
                return ""
            endif
            
            if key=key_configuration then
                configuration
                return ""
            endif
            
            if key=key_tactics then
                settactics
                return ""
            endif
            
            if key=key_shipstatus then         
                shipstatus()
                return ""
            endif
            
            if key=key_logbook then
                logbook()
                return ""
            endif

            if key=key_equipment then
                a=get_item()
                if a>0 then rlprint item(a).ldesc
                key=keyin()
                return ""
            endif
            
            if key=key_standing then
                show_standing()
                
                return ""
            endif
            
            if key=key_quest then
                show_quests
                return ""
            endif
            
            if key=key_quit then 
                if askyn("Do you really want to quit? (y/n)") then player.dead=6
            endif
            
        endif
        if key=key_autoinspect then
            screenset 1,1
            select case _autoinspect
                case is =0
                    _autoinspect=1
                    rlprint "Autoinspect Off"
                case is =1
                    _autoinspect=0
                    rlprint "Autoinspect On"                
            end select
            key=""     
        endif
        if key=key_autopickup then
            screenset 1,1
            select case _autopickup
                case is =0
                    _autopickup=1
                    rlprint "Autopickup Off"
                case is =1
                    _autopickup=0
                    rlprint "Autopickup On"                
            end select
            key=""     
        endif       
        if key=key_togglehpdisplay then
            screenset 1,1
            select case _HPdisplay
                case is =0
                    _HPdisplay=1
                    rlprint "Hp display now displays icons"
                case is =1
                    _HPdisplay=0
                    rlprint "Hp display now displays HPs"
            end select
            key=""
        endif
        if key="$" and dbshow_factionstatus=1 then
            
            for a=0 to 7
                text="Faction "&a
                for b=0 to 7
                    text=text &":"&faction(a).war(b)
                next
                rlprint text
            next
        endif
        if len(allowed)>0 and key<>key__esc and key<>key__enter and getdirection(key)=0 then
            if instr(allowed,key)=0 and walking=0 then 
                'keybindings(allowed)
                key=""
            endif
        endif
    loop until key<>"" or walking <>0 or just_run<>0
    if just_run<>0 then 
        if just_run>0 then just_run-=1
        if key=key__esc then just_run=0
    endif
    comstr.reset
    return key
end function


Function from_savegame(Key As String) As String
    Dim As Short c
    c=count_savegames
    set__color(11,0)
    Cls
    If c=0 Then
        rlprint "No Saved Games"
        no_key=keyin 
        Key=""
    Else
        load_game(getfilename())
        If player.desig="" Then 
            Key=""
        else
            player.dead=0
            civ_adapt_tiles(0)
            civ_adapt_tiles(1)
            If savefrom(0).map>0 Then
                landing(0)
            EndIf
        endif
    EndIf
    set__color(11,0)
    Cls
    Return Key
End Function



function mainmenu() as string
	dim a as integer
	dim key as string
	dim text as string
    Do        
        a=Menu(bg_title,__VERSION__ &"/Start new game/Load game/Highscore/Manual/Configuration/Keybindings/Quit",,40,_lines-10*_fh2/_fh1)
        If a=1 Then
            Key="1"
            If count_savegames()>20 Then
                Key=""
                rlprint "Too many Savegames, choose one to overwrite",14
                text=getfilename()
                If text<>"" Then
                    If askyn("Are you sure you want to delete "&text &"(y/n)") Then
                        Kill("savegames/"&text)
                        Key="1"
                    EndIf
                EndIf
            EndIf
        EndIf
        If a=2 Then Key=from_savegame("2")
        If a=3 Then high_score("")
        If a=4 Then viewfile("readme.txt")
        If a=5 Then configuration
        If a=6 Then keybindings

'		if key="8" then
'			DbgItemsCSV()
'		endif
'		dodialog(1,dummy,0)
'		for b=1 to 1000
'           make_spacemap
'           clear_gamestate
'		next

#if __FB_DEBUG__
        If Key="t" Then
            Screenset 1,1
            BLoad "graphics\spacestations.bmp"
            a=getnumber(0,10000,0)
            Put(30,0),gtiles(gt_no(a)),Pset
            no_key=keyin
            Sleep
        EndIf
        If Key="8" Then
          	DbgMonsterCSV
           	DbgTilesCSV
        End If
        If Key="9" Then
            Cls
            set__color(15,0)
            For a=1 To 10
                reroll_shops
                print a
            Next
        EndIf
        If a=8 Then
			DbgPricesCSV
        EndIf
#endif
    Loop Until Key="1" Or Key="2" Or a=7
    return key
End function


function Prospector() as Integer
	Do
	    setglobals
	    DbgTilesCSV   
	    set__color(11,0)
		dim key as string
	    key= mainmenu()
	    Cls
	    If Key="1" Then start_new_game
	    If Key="1" Or Key="2" Or Key="a" Or Key="b" And player.dead=0 Then
	        Key=""
	        gamerunning=1
	        display_stars(1)
	        display_ship(1)
	        explore_space
	    EndIf
	    If Key="7" Or Key="g" Then 
	    	return 0
	    EndIf
	    If player.dead>0 Then death_message()
	    set__color( 15,0)
    	If configflag(con_restart)=0 Then
	        load_game("empty.sav")
	        clear_gamestate
	        gamerunning=0
	    EndIf
	Loop Until configflag(con_restart)=1
	return 0
end function
