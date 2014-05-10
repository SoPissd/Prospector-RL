'tFleet

declare function rnd_point(m as short=-1,w as short=-1,t as short=-1,vege as short=-1)as _cords

type _fleet
    ty As Short 'Type: 1=patrol 2=merchant 3=pirate
    e As _energycounter
    c As _cords'Coordinates
    t As Short 'Number of coordinates of target in targetlist
    fuel As Integer
    del As Short
    flag As Short
    fighting As Short
    Declare function speed() As Short
    Declare function count() As Short
    Declare function add_move_cost() As Short
    con(15) As Short ' Old ship storage con(0)=Nicety of pirates con(1)=Escorting,con(2)=lastbattle
    mem(15) As _ship 'Actual ship storage
End Type

Dim Shared fleet(255) As _fleet

Dim Shared empty_fleet As _fleet
empty_fleet.del=1



function _fleet.add_move_cost() As Short
    e.add_action(10-speed)
    Return 0
End function

function _fleet.speed() As Short
    Dim As Short i,v
    v=9
    For i=1 To 15
        If mem(i).hull>0 And mem(i).movepoints(0)<v Then v=mem(i).movepoints(0)
    Next
    If v<=0 Then v=1
    Return v
End function


function _fleet.count() As Short
    Dim As Short i,c
    For i=1 To 15
        If mem(i).hull>0 Then c+=1
    Next
    Return c
End function

'
'

function merc_dis(fl as short,byref goal as short) as short
    dim as short i,j,dis
    for i=fleet(fl).t to lastwaypoint
        dis+=1
        for j=0 to 2
            if targetlist(i).x=basis(j).c.x and targetlist(i).y=basis(j).c.y then
                goal=j
                return dis
            end if
        next
    next
    
    for i=0 to lastwaypoint
        dis+=1
        for j=0 to 2
            if targetlist(i).x=basis(j).c.x and targetlist(i).y=basis(j).c.y then
                goal=j
                return dis
            end if
        next
    next
    return -1
end function


function random_pirate_system() as short
    dim pot(_NoPB+2) as short
    dim as short i,l
    for i=0 to _NoPB
        if piratebase(i)>0 then
            l+=1
            pot(l)=sysfrommap(piratebase(i))
            if i=0 then
                l+=1
                pot(l)=sysfrommap(piratebase(i))
            endif
        endif
    next
    if l=0 then
        return -1
    else
        return pot(rnd_range(1,l))
    endif
end function


function makequestfleet(a as short) as _fleet
    dim f as _fleet
    dim as short b,c,i,e
    dim as _cords p1
    b=random_pirate_system
    if b<0 then
        p1.x=rnd_range(0,sm_x)
        p1.y=rnd_range(0,sm_y)
    else
        p1=map(b).c
    endif
    f.c=p1
    if a=5 then
        f.ty=4
        f.t=0 'All pirates start with target 9 (random point)
        f.mem(1)=make_ship(8)
        f.flag=15'the infamous anne bonny
    endif
    if a=4 then
        f.ty=4
        f.t=0 'All pirates start with target 9 (random point)
        f.mem(1)=make_ship(10) 'the infamous black corsair
        f.mem(2)=make_ship(2)
        f.mem(3)=make_ship(2)
        f.flag=16
    endif
    if a=3 then
        f.ty=4
        f.t=0 'All pirates start with target 9 (random point)
        f.mem(1)=make_ship(30) 'the infamous anne bonny
        f.mem(2)=make_ship(2)
        f.mem(3)=make_ship(2)
        f.flag=17
    endif
    if a=2 then
        f.ty=4
        f.t=0 'All pirates start with target 9 (random point)
        f.mem(1)=make_ship(31) 'the infamous anne bonny
        f.mem(2)=make_ship(2)
        f.mem(3)=make_ship(2)
        f.mem(4)=make_ship(2)
        f.flag=18
    endif
    if a=1 then
        f.ty=4
        f.t=0 'All pirates start with target 9 (random point)
        f.mem(1)=make_ship(32) 'the infamous anne bonny
        f.mem(2)=make_ship(2)
        f.mem(3)=make_ship(2)
        f.flag=19
    endif
    'Company ships
    if a=6 then
        f.ty=2
        f.t=0
        f.mem(1)=make_ship(34)
        f.c=basis(rnd_range(0,2)).c
    endif    
    if a=7 then
        f.ty=2
        f.t=0
        f.mem(1)=make_ship(35)
        f.c=basis(rnd_range(0,2)).c
    endif
    if a=8 then
        f.ty=2
        f.t=0
        f.mem(1)=make_ship(36)
        f.mem(2)=make_ship(12)
        f.mem(3)=make_ship(12)
        f.c=basis(rnd_range(0,2)).c
    endif
    if a=9 then
        f.ty=2
        f.t=0
        f.mem(1)=make_ship(37)
        f.mem(2)=make_ship(7)
        f.mem(3)=make_ship(7)
        f.c=basis(rnd_range(0,2)).c
    endif
    if a=10 then
        f.ty=2
        f.t=0
        f.mem(1)=make_ship(38)
        f.mem(2)=make_ship(7)
        f.mem(3)=make_ship(7)
        f.mem(4)=make_ship(12)
        f.mem(5)=make_ship(12)
        f.c=basis(rnd_range(0,2)).c
    endif
    e=0
    for i=1 to 15
        if f.mem(i).engine/f.mem(i).hull<e then e=f.mem(i).engine/f.mem(i).hull
    next
    f.mem(0).engine=e
    if f.mem(0).engine<1 then f.mem(0).engine=1
    return f
end function

'

function makemerchantfleet() as _fleet
    dim f as _fleet
    dim text as string
    dim as short a,b
    
    f.ty=1
    a=rnd_range(1,3)
    for b=1 to a
        f.mem(b)=make_ship(6) 'merchantmen
        text=text &f.mem(b).icon
    next
    if rnd_range(1,100)>80-makepat*2 then
        for b=a+1 to a+2
            if rnd_range(1,100)<45+makepat then
                f.mem(b)=make_ship(7) 'escorts
                text=text &f.mem(b).icon
            else
                f.mem(b)=make_ship(12)
            endif
        next
    endif
    f.c=targetlist(firstwaypoint)
    f.t=firstwaypoint+1
    if show_NPCs=1 then rlprint ""&a &":"& b &":"& text
    return f
end function 

'

function makepiratefleet(modifier as short=0) as _fleet
    dim f as _fleet
    dim as short maxroll,r,a
    
    dim as short b,c
    b=random_pirate_system
    f.ty=2
    f.con(15)=rnd_range(1,15)-rnd_range(1,10)-gameturn/10000 'Friendlyness
    f.t=0 'All pirates start with target 9 (random point)
    f.c=map(b).c
    maxroll=gameturn/15000'!
    if maxroll>60 then maxroll=60
    for a=1 to rnd_range(0,1)+cint(maxroll/20)    
        r=rnd_range(1,maxroll)+modifier
        f.mem(a)=make_ship(2)
        if r>15 then f.mem(a)=make_ship(3)
        if r>35 then f.mem(a)=make_ship(4)
        if r>45 then f.mem(a)=make_ship(5)
   next a
    return f
end function

function makealienfleet() as _fleet
    dim f as _fleet
    dim as short i,e,sys
    f.ty=5
    f.mem(1)=make_ship(11)
    sys=sysfrommap(specialplanet(29))
    if sys<0 then sys=sysfrommap(specialplanet(30))
    if sys<0 then sys=rnd_range(0,laststar)
    f.c=map(sys).c
    
    for i=1 to 15
        if f.mem(i).engine/f.mem(i).hull<e then e=f.mem(i).engine/f.mem(i).hull
    next
    f.mem(0).engine=e
    if f.mem(0).engine<1 then f.mem(0).engine=1
    return f
end function

function makecivfleet(slot as short) as _fleet
    dim f as _fleet
    dim as short s,p,i,e
    f.ty=6+slot
    s=civ(slot).phil
    if civ(slot).phil=2 and rnd_range(1,100)<50 then s=s+rnd_range(1,2)
    if civ(slot).phil=3 and rnd_range(1,100)<33 then s=s+rnd_range(2,8)
    if s<1 then s=1
    for p=1 to s
        if rnd_range(0,100)<55-civ(slot).phil*5 then
            f.mem(p)=civ(slot).ship(0)
        else
            f.mem(p)=civ(slot).ship(1)
        endif
        f.mem(p).c=rnd_point
    next
    f.c=civ(slot).home
    f.t=3+(slot*4)
    
    for i=1 to 15
        if f.mem(i).engine/f.mem(i).hull<e then e=f.mem(i).engine/f.mem(i).hull
    next
    f.mem(0).engine=e
    if f.mem(0).engine<1 then f.mem(0).engine=1
    return f
end function

function civfleetdescription(f as _fleet) as string
    dim t as string
    dim as short slot,nos,a
    slot=f.ty-6
    if slot<0 or slot>1 then return ""
    for a=1 to 15
        if f.mem(a).hull>0 then nos+=1
    next
    if nos=1 then t="a single "
    if nos>1 and nos<4 then t="a small group of "
    if nos>=4 and nos<8 then t="a group of "
    if nos>=8 then t="a fleet of "
    't=t &"("&slot &")"
    if f.mem(1).hull<=2 then t=t &" tiny "
    if f.mem(1).hull>2 and f.mem(1).hull<5 then t=t &" small "
    if f.mem(1).hull>10 and f.mem(1).hull<15 then t=t &" big "
    if f.mem(1).hull>15 then t=t &" huge "
    if nos=1 then
        t=t &" ship "
    else
        t=t &" ships "
    endif
    if civ(slot).contact=1 then
        if nos=1 then
            t=t &" It's configuration is "&civ(slot).n &"."
        else
            t=t &" They are "&civ(slot).n &"."
        endif
    else
        if nos=1 then
            t=t &"It's configuration is alien, but it seems to be "
            if civ(slot).inte=1 then t=t &"an explorer."
            if civ(slot).inte=2 then t=t &"a trader."
            if civ(slot).inte=3 then t=t &"a warship."
        else
            t=t &"their configuration is alien but they seem to be "
            if civ(slot).inte=1 then t=t &"explorers."
            if civ(slot).inte=2 then t=t &"traders."
            if civ(slot).inte=3 then t=t &"warships."
        endif
    endif
    if show_NPCs then t=t &slot
    return t
end function

function makepatrol() as _fleet
    dim f as _fleet
    f.ty=3
    f.mem(1)=make_ship(9)
    f.mem(2)=make_ship(7)
    f.mem(3)=make_ship(7)'one company battleship
    if rnd_range(1,100+gameturn/10000)>75 then f.mem(4)=make_ship(9)
    if rnd_range(1,100+gameturn/10000)>45 then f.mem(5)=make_ship(7)
    f.c=targetlist(firstwaypoint)
    f.t=firstwaypoint+1
    return f
end function

'

function add_fleets(byref target as _fleet,byref source as _fleet) as _fleet
    dim as short a,b
    dim text as string
    ' Find last ship of target
    do
        a=a+1
        text=text & target.mem(a).icon
    loop until target.mem(a).hull=0 or a>14
    if a<15 then
        do 
            b=b+1
            target.mem(a)=source.mem(b)
            text=text & target.mem(a).icon
 
            a=a+1
        loop until a>14 or b>14
        source=empty_fleet
    endif
    'if target.ty=2 then target=piratecrunch(target)
    
    if show_NPCs=1 then rlprint text
    return target
end function


function bestpilotinfleet(f as _fleet) as short
    dim as short a,r
    for a=1 to 15
        if f.mem(a).pilot(0)>r then r=f.mem(a).pilot(0)
    next
    return r
end function


function countfleet(ty as short) as short
    dim as short a,r
    for a=3 to lastfleet
        if fleet(a).ty=ty then r=r+1
    next
    return r
end function


function make_fleet() as _fleet
    DimDebugL(0)
    dim as short roll,i,e
    dim as _fleet f

    roll=rnd_range(1,6)
    if (countfleet(1)<countfleet(2) or faction(0).war(1)>faction(0).war(2)) or (debug=1) then 
        f=makemerchantfleet
    else
        if configflag(con_easy)=1 or gameturn>25000 then 
            if random_pirate_system>0 then f=makepiratefleet
        else
            f=makepatrol
        endif
    endif
#if __FB_DEBUG__
    if roll+patrolmod>10 and debug=0 then 
        if show_npcs=1 then rlprint roll &":" &patrolmod
        f=makepatrol
        patrolmod=0
        makepat=makepat+1
    endif
#endif
    e=999
    for i=1 to 15
        if f.mem(i).movepoints(0)<e and f.mem(i).movepoints(0)>0 then e=f.mem(i).movepoints(0)
    next
    f.mem(0).engine=e
    if f.mem(0).engine<1 then f.mem(0).engine=1
    return f 
end function

'
'

function disnbase(c as _cords,weight as short=2) as single
    dim r as single
    dim a as short
    r=65
    for a=0 to 2
        if distance(c,basis(a).c)<r then r=distance(c,basis(a).c)
    next
    for a=1 to 3
        if distance(c,fleet(a).c)*weight<r then r=distance(c,fleet(a).c)*2
    next
    return r
end function

