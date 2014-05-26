'gGameinit.
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


	tItems.init(0)    
	tBasis.init(0)

    baseprice(1)=50
    baseprice(2)=200
    baseprice(3)=500
    baseprice(4)=1000
    baseprice(5)=2500

    For a=0 To 5
        avgprice(a)=0
    Next
    For a=0 To lastflag'20
        flag(a)=0
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
   	iAction=tShipyard.init(0)
   	iAction=tBasis.init(0)
	      
  
    
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
