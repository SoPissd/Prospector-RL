'tStars.
'
'defines:
'is_special=11, UpdateMapSize=2, sysfrommap=68, orbitfrommap=2
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
'     -=-=-=-=-=-=-=- TEST: tStars -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Type _stars
    c As _cords
    spec As Byte
    ti_no As UInteger
    discovered As Byte
    planets(1 To 9) As Short
    desig As String*12
    comment As String*60
End Type


Dim Shared map(laststar+wormhole+1) As _stars

Const lastspecial=46

Dim Shared specialplanet(lastspecial) As Short
Dim Shared specialplanettext(lastspecial,1) As String
Dim Shared spdescr(lastspecial) As String
Dim Shared specialflag(lastspecial) As Byte

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tStars -=-=-=-=-=-=-=-

declare function is_special(m as short) as short
declare function isgasgiant(m as short) as short

declare function UpdateMapSize(size as short) as Short
declare function sysfrommap(a as short)as short
declare function orbitfrommap(a as short) as short
declare function count_gas_giants_area(c as _cords,r as short) as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tStars -=-=-=-=-=-=-=-

namespace tStars
function init(iAction as integer) as integer
	'
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
	'
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
	'
	return 0
end function
end namespace'tStars


function is_special(m as short) as short
    dim a as short
    for a=0 to lastspecial
        if m=specialplanet(a) then return true
    next
    return false
end function    


function UpdateMapSize(size as short) as Short
    redim map(laststar+wormhole+1)
    return 0
End function    


function sysfrommap(a as short)as short
    ' returns the systems number of a planet
    dim as short b,c,d
    for b=0 to laststar
        for c=1 to 9
            if map(b).planets(c)=a then return b
        next
    next
    return -1
end function


function orbitfrommap(a as short) as short
    dim as short orbit,sys,b
    sys=sysfrommap(a)
    if sys>=0 then
        for b=1 to 9
            if map(sys).planets(b)=a then return b
        next
    endif
    return -1
end function

function isgasgiant(m as short) as short
    if m<-20000 then return 1
    if m=specialplanet(21) then return 21
    if m=specialplanet(22) then return 22
    if m=specialplanet(23) then return 23
    if m=specialplanet(24) then return 24
    if m=specialplanet(25) then return 25
    if m=specialplanet(43) then return 43
    return 0
end function

function count_gas_giants_area(c as _cords,r as short) as short
    dim as short cc,i,j
    for i=0 to laststar
        if distance(c,map(i).c)<r then
            for j=1 to 9
                if isgasgiant(map(i).planets(j)) then cc+=1
                if map(i).planets(j)=specialplanet(21) then cc+=5
                if map(i).planets(j)=specialplanet(22) then cc+=5
                if map(i).planets(j)=specialplanet(23) then cc+=5
                if map(i).planets(j)=specialplanet(24) then cc+=5
                if map(i).planets(j)=specialplanet(25) then cc+=5
            next
        endif
    next    
    return cc
end function




#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tStars -=-=-=-=-=-=-=-
	tModule.register("tStars",@tStars.init()) ',@tStars.load(),@tStars.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tStars -=-=-=-=-=-=-=-
#endif'test
