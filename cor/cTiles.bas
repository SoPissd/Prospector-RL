'tTiles.
'
'defines:
''=0, load_tiles=1, plant_name=1
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
'     -=-=-=-=-=-=-=- TEST: tTiles -=-=-=-=-=-=-=-
#undef intest
#define test
#endif'test

#ifdef types

Dim Shared tiles(dimTiles) As _tile

Dim Shared stiles(9,68) As Any Ptr
Dim Shared shtiles(7,4) As Any Ptr
Dim Shared bestaltdir(9,1) As Byte


Dim Shared gtiles(2048) As Any Ptr
Dim Shared gt_no(4096) As Integer

Dim Shared tmap(60,20) As _tile
#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tTiles -=-=-=-=-=-=-=-

declare function plant_name(ti as _tile) as string

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tTiles -=-=-=-=-=-=-=-

namespace tTiles
function init(iAction as integer) as integer
	init_tiles(tiles())
	set_movecost(tiles(),1)
	return 0
end function
end namespace'tTiles




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