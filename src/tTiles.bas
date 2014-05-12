'tTiles.
'
'defines:
'load_tiles_msg=0, load_tiles=1, plant_name=1
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tTiles -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tTiles -=-=-=-=-=-=-=-

Type _tile
    no As Short

    tile As Short
    ti_no As UInteger
    bgcol As Short
    col As Short

    desc As String*512
    stopwalking As Byte
    oxyuse As Byte
    locked As Byte
    movecost As UByte
    seetru As Short
    walktru As Short
    firetru As Short
    shootable As Short 'shooting at it will damage it
    dr As Short 'damage reduction
    hp As Short
    dam As Short
    range As Short
    tohit As Short
    hitt As String*512
    misst As String*512
    deadt As String*512
    turnsinto As Short
    succt As String*512
    failt As String*512
    killt As String*512
    spawnson As Short
    spawnswhat As Short
    spawnsmax As Short
    spawnblock As Short '=0 spawns forever, >0 each spawn =-3, <0 spawning blocked
    spawntext As String*512
    survivors As Short
    resources As Short
    gives As Short
    vege As Byte
    disease As Byte
    turnsoninspect As Short
    turnroll As Byte
    turntext As String*512
    causeaeon As Byte
    aetype As Byte
    hides As Byte
    repairable As Byte
    onclose As Short
    onopen As Short
    turnsonleave As Short
    turnsonleavetext As String*512
End Type

declare function load_tiles() as short
declare function plant_name(ti as _tile) as string

'private function load_tiles_msg() as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tTiles -=-=-=-=-=-=-=-

namespace tTiles
function init() as Integer
	return 0
end function
end namespace'tTiles


#define cut2top


Dim Shared tiles(512) As _tile
dim as uinteger a
for a=1 to 512
    tiles(a).movecost=1
next

Dim Shared tmap(60,20) As _tile


function load_tiles_msg() as short
    tScreen.set(1)
    locate 1,1
    print "Loading tiles:.."
    tScreen.set(0)    
    cls
    return 0
end function

function load_tiles() as short
    dim as short x,y,a,n,sx,sy,showtiles
    '
   	If (configflag(con_tiles)<>0) and (configflag(con_sysmaptiles)<>0) then
		return 0
	EndIf
    '
	load_tiles_msg()
    
	showtiles=0
	
    for a=0 to 4096
        gt_no(a)=2048
    next
	
    if not fileexists("graphics/ships.bmp") then
        color rgb(255,255,0)
        print "Couldn't find graphic tiles, switching to ASCII"
        configflag(con_tiles)=1
        configflag(con_sysmaptiles)=1
        sleep 1500
        return 0
    endif

    bload "graphics/ships.bmp"
    for y=0 to _tiy*16 step _tiy
        sx=1
        sy+=1
        for x=0 to _tix*8 step _tix
            stiles(sx,sy)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
            sx+=1
        next
        draw string (24*9,y),""&sy
    next
    
	load_tiles_msg()
    bload "graphics/ships2.bmp"
    for y=0 to _tiy*16 step _tiy
        sx=1
        sy+=1
        for x=0 to _tix*8 step _tix
            stiles(sx,sy)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
            sx+=1
        next
        draw string (24*9,y),""&sy
    next

	load_tiles_msg()
    bload "graphics/ships3.bmp"
    for y=0 to _tiy*16 step _tiy
        sx=1
        sy+=1
        for x=0 to _tix*8 step _tix
            stiles(sx,sy)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
            sx+=1
        next
        draw string (24*10,y),""&sy
    next

	load_tiles_msg()
    bload "graphics/drifting.bmp"
    for y=0 to _tiy*16 step _tiy
        sx=1
        sy+=1
        for x=0 to _tix*8 step _tix
            stiles(sx,sy)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
            sx+=1
        next
        draw string (24*10,y),""&sy
    next

	load_tiles_msg()
    bload "graphics/shield.bmp"
    for x=0 to 7
        for y=0 to 4
            shtiles(x,y)=imagecreate(16,16)
            get (x*16,y*16)-((x+1)*16-1,(y+1)*16-1),shtiles(x,y)
        next
    next
    
    'Clear tile
    gtiles(0)=imagecreate(_tix,_tiy,rgba(0,0,0,255))
    
	load_tiles_msg()
    a=1
    n=1
    bload "graphics/space.bmp"
    for y=0 to _tiy*6 step _tiy
        for x=0 to _tix*15 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
    next
    
	load_tiles_msg()
    n=75
    bload "graphics/weapons.bmp"
    y=0
    for x=0 to _tix*2 step _tix
        gtiles(a)=imagecreate(_tix,_tiy)
        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
        gt_no(n)=a
        a+=1
        n+=1
    next
    y=_tiy
    for x=0 to _tix*8 step _tix
        gtiles(a)=imagecreate(_tix,_tiy)
        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
        gt_no(n)=a
        a+=1
        n+=1
    next
    y=_tiy*2
    for x=0 to _tix*2 step _tix
        gtiles(a)=imagecreate(_tix,_tiy)
        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
        gt_no(n)=a
        a+=1
        n+=1
    next

    
	load_tiles_msg()
    n=101
    bload "graphics/land.bmp"
    for y=0 to _tiy*16 step _tiy
        for x=0 to _tix*19 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
    next

	load_tiles_msg()
    n=750
    bload "graphics/critters3.bmp"
    for y=0 to _tiy*10 step _tiy
        x=0
        gtiles(a)=imagecreate(_tix,_tiy)
        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
        gt_no(n)=a
        a+=1
        n+=1
    next

	load_tiles_msg()
    n=800
    bload "graphics/critters2.bmp"
    for y=0 to _tiy*10 step _tiy
        for x=0 to _tix*12 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
        draw string (x,y),""&n-1
    next
    if showtiles=1 then sleep

	load_tiles_msg()
    n=990
    bload "graphics/player.bmp"
    for y=0 to _tiy*2 step _tiy
        for x=0 to _tix*2 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
    next


	load_tiles_msg()
    n=1000
    bload "graphics/critters.bmp"
    for y=0 to _tiy*4 step _tiy
        for x=0 to _tix*19 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
    next

	load_tiles_msg()
    n=1500
    bload "graphics/characters.bmp"
    for y=0 to _tiy*1 step _tiy
        for x=0 to _tix*7 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
    next

    n=1600
    'Space tiles
    cls
    bload "graphics/planetmap.bmp"
	load_tiles_msg()
    
    for y=0 to _tiy*4 step _tiy
        for x=0 to _tix*5 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
    next


	load_tiles_msg()
    n=1750
    bload "graphics/spacestations.bmp"
    for x=0 to _tix*11 step _tix
        gtiles(a)=imagecreate(_tix,_tiy)
        get (x,0)-(x+_tix-1,_tiy-1),gtiles(a)
        gt_no(n)=a
        a+=1
        n+=1
    next

	load_tiles_msg()
    n=2001
    bload "graphics/items.bmp"
    for y=0 to _tiy*6 step _tiy
        for x=0 to _tix*19 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
    next

	load_tiles_msg()
    n=2500
    bload "graphics/walls.bmp"
    for y=0 to _tiy*13 step _tiy
        for x=0 to _tix*9 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
    next


	load_tiles_msg()
    n=3001
    bload "graphics/portals.bmp"
    y=0
    for x=0 to _tix*8 step _tix
        gtiles(a)=imagecreate(_tix,_tiy)
        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
        gt_no(n)=a
        a+=1
        n+=1
    next

    bload "graphics/missing.bmp"
    gtiles(2048)=imagecreate(_tix,_tiy)
    get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(2048)

	load_tiles_msg()    
    return 0
end function



function plant_name(ti as _tile) as string
    dim s as string
    dim a as byte
    dim pname(7) as string
    dim colors(12) as string
    dim num(5) as string

    num(1)="Some"
    num(2)="A few"
    num(3)="Few"
    num(4)="Numerous"
    num(5)="Many"

    colors(1)="black"
    colors(2)="white"
    colors(3)="red"
    colors(4)="green"
    colors(5)="blue"
    colors(6)="yellow"
    colors(7)="violet"
    colors(8)="purple"
    colors(9)="orange"

    pname(1)="mosses"
    pname(2)="ferns"
    pname(3)="conifers"
    pname(4)="cycads"
    pname(5)="gnetophytes"
    pname(6)="flowering plants"
    pname(7)="mushrooms"

    s=num(rnd_range(1,5))&" interesting " &colors(rnd_range(1,9))&" "&pname(rnd_range(1,7))
    return s
end function





'function load_tiles() as short
'    dim as short x,y,a,n,sx,sy,showtiles
'    dim as any ptr img,img2
'    showtiles=0
'    for a=0 to 4096
'        gt_no(a)=2048
'    next
'    cls
'    img=bmp_load( "graphics/ships.bmp")
'    for y=0 to _tiy*16 step _tiy
'        sx=1
'        sy+=1
'        for x=0 to _tix*8 step _tix
'            stiles(sx,sy)=imagecreate(_tix,_tiy)
'            get img,(x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
'            sx+=1
'        next
'        draw string (24*9,y),""&sy
'    next
'    imagedestroy(img)
'    cls
'    img=bmp_load( "graphics/ships2.bmp")
'    for y=0 to _tiy*16 step _tiy
'        sx=1
'        sy+=1
'        for x=0 to _tix*8 step _tix
'            stiles(sx,sy)=imagecreate(_tix,_tiy)
'            get img,(x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
'            sx+=1
'        next
'        draw string (24*9,y),""&sy
'    next
'    imagedestroy(img)
'
'
'    cls
'    img=bmp_load( "graphics/ships3.bmp")
'    for y=0 to _tiy*16 step _tiy
'        sx=1
'        sy+=1
'        for x=0 to _tix*8 step _tix
'            stiles(sx,sy)=imagecreate(_tix,_tiy)
'            get img,(x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
'            sx+=1
'        next
'        draw string (24*10,y),""&sy
'    next
'    imagedestroy(img)
'
'
'    a=1
'    n=1
'    cls
'    bload("graphics/space.bmp")
'
'    for y=0 to _tiy*6 step _tiy
'        for x=0 to _tix*15 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'
'    n=75
'    cls
'    bload "graphics/weapons.bmp"
'    y=0
'    for x=0 to _tix*2 step _tix
'        gtiles(a)=imagecreate(_tix,_tiy)
'        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'        gt_no(n)=a
'        a+=1
'        n+=1
'    next
'    y=_tiy
'    for x=0 to _tix*8 step _tix
'        gtiles(a)=imagecreate(_tix,_tiy)
'        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'        gt_no(n)=a
'        a+=1
'        n+=1
'    next
'
'    n=101
'    imagedestroy(img)
'    img=0
'    cls
'    img=bmp_load( "graphics/land.bmp")
'    for y=0 to _tiy*16 step _tiy
'        for x=0 to _tix*19 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get img,(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'
'    n=750
'    cls
'    bload "graphics/critters3.bmp"
'    for y=0 to _tiy*10 step _tiy
'        x=0
'        gtiles(a)=imagecreate(_tix,_tiy)
'        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'        gt_no(n)=a
'        a+=1
'        n+=1
'    next
'
'
'    n=800
'    cls
'    bload "graphics/critters2.bmp"
'    for y=0 to _tiy*10 step _tiy
'        for x=0 to _tix*12 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'        draw string (x,y),""&n-1
'    next
'    if showtiles=1 then sleep
'
'    n=1000
'    cls
'    bload "graphics/critters.bmp"
'    for y=0 to _tiy*4 step _tiy
'        for x=0 to _tix*19 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'    n=2001
'    cls
'    bload "graphics/items.bmp"
'    for y=0 to _tiy*5 step _tiy
'        for x=0 to _tix*19 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'
'    n=3001
'    cls
'    bload "graphics/portals.bmp"
'    y=0
'    for x=0 to _tix*8 step _tix
'        gtiles(a)=imagecreate(_tix,_tiy)
'        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'        gt_no(n)=a
'        a+=1
'        n+=1
'    next
'
'    bload "graphics/missing.bmp"
'    gtiles(2048)=imagecreate(_tix,_tiy)
'    get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(2048)
'    cls
'    print "loaded "& a &" sprites."
'    return 0
'end function
'
'
'
'function load_tiles() as short
'    dim as short x,y,a,n,sx,sy,showtiles
'    dim image(12) as any ptr
'    showtiles=0
'    for a=0 to 4096
'        gt_no(a)=2048
'    next
'    print "Loading sprites .";
'    image(0)=bmp_load( "graphics/ships.bmp")
'    image(1)=bmp_load( "graphics/ships2.bmp")
'    image(2)=bmp_load( "graphics/ships3.bmp")
'    image(3)=bmp_load( "graphics/space.bmp")
'
'    put (0,0),image(3)
'    sleep
'
'    for y=0 to _tiy*16 step _tiy
'        sx=1
'        sy+=1
'        for x=0 to _tix*8 step _tix
'            stiles(sx,sy)=imagecreate(_tix,_tiy)
'            get image(0),(x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
'            sx+=1
'        next
'        draw string (24*9,y),""&sy
'    next
'    print ".";
'    for y=0 to _tiy*16 step _tiy
'        sx=1
'        sy+=1
'        for x=0 to _tix*8 step _tix
'            stiles(sx,sy)=imagecreate(_tix,_tiy)
'            get image(1),(x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
'            sx+=1
'        next
'        draw string (24*9,y),""&sy
'    next
'
'    print ".";
'    for y=0 to _tiy*16 step _tiy
'        sx=1
'        sy+=1
'        for x=0 to _tix*8 step _tix
'            stiles(sx,sy)=imagecreate(_tix,_tiy)
'            get image(2),(x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
'            sx+=1
'        next
'        draw string (24*10,y),""&sy
'    next
'
'
'    n=75
'    print ".";
'    image(4)=bmp_load( "graphics/weapons.bmp")
'    y=0
'    for x=0 to _tix*2 step _tix
'        gtiles(a)=imagecreate(_tix,_tiy)
'        get image(4),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'        gt_no(n)=a
'        a+=1
'        n+=1
'    next
'    y=_tiy
'    for x=0 to _tix*8 step _tix
'        gtiles(a)=imagecreate(_tix,_tiy)
'        get image(4),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'        gt_no(n)=a
'        a+=1
'        n+=1
'    next
'
'
'    a=1
'    n=1
'    print ".";
'    for y=0 to _tiy*6 step _tiy
'        for x=0 to _tix*15 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get image(3),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'    n=101
'    print ".";
'    image(5)=bmp_load( "graphics/land.bmp")
'    for y=0 to _tiy*16 step _tiy
'        for x=0 to _tix*19 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get image(5),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'
'    n=750
'    print ".";
'    image(6)=bmp_load( "graphics/critters3.bmp")
'    for y=0 to _tiy*10 step _tiy
'        x=0
'        gtiles(a)=imagecreate(_tix,_tiy)
'        get image(6),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'        gt_no(n)=a
'        a+=1
'        n+=1
'    next
'
'
'    n=800
'    print ".";
'    image(7)=bmp_load( "graphics/critters2.bmp")
'    for y=0 to _tiy*10 step _tiy
'        for x=0 to _tix*12 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get image(7),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'        draw string (x,y),""&n-1
'    next
'    if showtiles=1 then sleep
'
'    n=1000
'    print ".";
'    image(8)=bmp_load( "graphics/critters.bmp")
'    for y=0 to _tiy*4 step _tiy
'        for x=0 to _tix*19 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get image(8),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'
'    print ".";
'    image(9)=bmp_load( "graphics/planetmap.bmp")
'
'    n=1500
'    for y=0 to _tiy*3 step _tiy
'        for x=0 to _tix*11 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get image(9),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'    n=2001
'    print ".";
'    image(10)=bmp_load( "graphics/items.bmp")
'    for y=0 to _tiy*5 step _tiy
'        for x=0 to _tix*19 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get image(10),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'
'    n=3001
'    print ".";
'    image(11)=bmp_load( "graphics/portals.bmp")
'    y=0
'    for x=0 to _tix*8 step _tix
'        gtiles(a)=imagecreate(_tix,_tiy)
'        get image(11),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'        gt_no(n)=a
'        a+=1
'        n+=1
'    next
'
'    image(12)=bmp_load( "graphics/missing.bmp")
'    gtiles(2048)=imagecreate(_tix,_tiy)
'    get image(12),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(2048)
'    print ".";
'    print " loaded "& a &" sprites."
'    sleep
'    return 0
'end function
'

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tTiles -=-=-=-=-=-=-=-
	tModule.register("tTiles",@tTiles.init()) ',@tTiles.load(),@tTiles.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tTiles -=-=-=-=-=-=-=-
#endif'test
