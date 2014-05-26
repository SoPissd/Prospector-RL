'tCivilisation.
'
'defines:
'show_standing=1
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
'     -=-=-=-=-=-=-=- TEST: tCivilisation -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test


#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Type _civilisation
    n As String*16
    home As _cords
    ship(1) As _ship
    item(1) As _items
    spec As _monster
    knownstations(2) As Byte
    contact As Byte
    popu As Byte
    aggr As Byte
    inte As Byte
    tech As Byte
    phil As Byte
    wars(2) As Short '0 other civ, 1 pirates, 2 Merchants
    prefweap As Byte
    culture(6) As Byte '0 birth 1 Childhood 2 Adult 3 Death 4 Religion 5 Art 6 story about a unique
    declare function philforeignpolicy(i as short) as short	
    declare function fleetdescription(nos as short) as string
    declare function make_alienship(slot as short,t as short) as short
End Type

Dim Shared civ(3) As _civilisation


#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tCivilisation -=-=-=-=-=-=-=-

declare function civ_adapt_tiles(slot as short) as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tCivilisation -=-=-=-=-=-=-=-

namespace tCivilisation
function init(iAction as integer) as integer
	return 0
end function
end namespace'tCivilisation

function _civilisation.philforeignpolicy(i as short) as short
	if i=0 then
		if phil=1 then return 5
		if phil=2 then return 3
		if phil=3 then return 1
	else
		if phil=1 then return 1
		if phil=2 then return 3
		if phil=3 then return 5
	endif
	assert(1)'should not be here
	return 0	
End Function

function _civilisation.fleetdescription(nos as short) as String
	dim t as string
    if contact=1 then
        if nos=1 then
            t=t &" It's configuration is "&n &"."
        else
            t=t &" They are "&n &"."
        endif
    else
        if nos=1 then
            t=t &"It's configuration is alien, but it seems to be "
            if inte=1 then t=t &"an explorer."
            if inte=2 then t=t &"a trader."
            if inte=3 then t=t &"a warship."
        else
            t=t &"their configuration is alien but they seem to be "
            if inte=1 then t=t &"explorers."
            if inte=2 then t=t &"traders."
            if inte=3 then t=t &"warships."
        endif
    endif
	return t	
End Function



function _civilisation.make_alienship(slot as short,t as short) as short
	' slot used for tile
	' t ..
	
    dim as short c,wc,cc,roll
    dim chance(3) as short '3 chance for weapon 2 chance for cargo 1 chance for sensors

    if inte=1 then
        chance(1)=20
    else
        chance(1)=10
    endif
    
    if inte=2 then
        chance(2)=20
    else
        chance(2)=10
    endif
    
    if inte=3 then
        chance(3)=30
    else
        chance(3)=10
    endif
    
    
    ship(t).hull=5+rnd_range(1,tech)*5*(t+1)-rnd_range(1,phil)*3*(t+1)
    if ship(t).hull<1 then ship(t).hull=1
    ship(t).shieldmax=rnd_range(1,tech)-2
    if ship(t).shieldmax<0 then ship(t).shieldmax=0
    ship(t).sensors=rnd_range(1,tech)
    ship(t).col=spec.col
    ship(t).engine=1
    ship(t).pipilot=3
    ship(t).pigunner=3
    ship(t).ti_no=25+slot
    wc=2
    cc=1
    ship(t).weapons(1)=make_weapon(rnd_range(1,tech)+prefweap)
    for c=0 to ship(t).hull step 5
        if rnd_range(1,100)<75 then
            ship(t).engine+=1
        else
            ship(t).engine-=1
        endif
        if rnd_range(1,100)<50 then
            ship(t).pipilot+=1
        else
            ship(t).pipilot-=1
        endif
        if rnd_range(1,100)<50 then
            ship(t).pigunner+=1
        else
            ship(t).pigunner-=1
        endif
            
        roll=rnd_range(1,100)
        select case roll
        case 0 to chance(1)
            ship(t).weapons(wc)=make_weapon(rnd_range(1,tech)+prefweap)
            wc+=1
        case chance(1)+1 to chance(1)+chance(2)
            ship(t).cargo(cc).x=1
            cc+=1
        case chance(1)+chance(2)+1 to chance(1)+chance(2)+chance(3)
            ship(t).sensors+=1
        case else
            if inte=1 then
                ship(t).sensors+=1
            endif
            if inte=2 then
                ship(t).cargo(cc).x=1
                cc+=1
            endif
            if inte=3 then
                ship(t).weapons(wc)=make_weapon(rnd_range(1,tech)+prefweap)
                wc+=1
            endif
        end select

    next
    ship(t).turnrate=1
    if ship(t).engine>3 then ship(t).turnrate+=1
    ship(t).c.x=rnd_range(1,60)
    ship(t).c.y=rnd_range(1,20)
    if ship(t).engine<1 then ship(t).engine=1
    if ship(t).pigunner<1 then ship(t).pigunner=1
    if ship(t).pipilot<1 then ship(t).pipilot=1
    ship(t).h_maxweaponslot=wc-1
    ship(t).h_maxhull=ship(t).hull
    if t=0 then ship(t).icon=left(n,1)
    if t=1 then ship(t).icon=lcase(left(n,1))
    if inte=1 then
        if t=0 then ship(t).desig=n &" explorer"
        if t=1 then ship(t).desig=n &" scout"
    endif
    if inte=2 then 
        if t=0 then ship(t).desig=n &" merchantman"
        if t=1 then ship(t).desig=n &" transporter"
    endif
    if inte=3 then 
        if t=0 then ship(t).desig=n &" warship"
        if t=1 then ship(t).desig=n &" fighter"
    endif
    return 0
end function


function civ_adapt_tiles(slot as short) as short
        
    tiles(272+slot).no=272+slot
    tiles(272+slot).tile=64 
    tiles(272+slot).col=civ(slot).spec.col
    tiles(272+slot).bgcol=0
    tiles(272+slot).desc=add_a_or_an(civ(slot).n,1) &" spaceship."
    tiles(272+slot).seetru=1
    tiles(272+slot).hides=2
    
    if rnd_range(1,100)<55 then
        tiles(274+slot).tile=asc("#") 
        tiles(274+slot).col=17
    else
        tiles(274+slot).tile=asc("O") 
        tiles(274+slot).col=137
    endif
    tiles(274+slot).bgcol=0
    tiles(274+slot).desc=add_a_or_an(civ(slot).n,1) &" building."
    tiles(274+slot).seetru=1
    tiles(274+slot).hides=2
    
    tiles(276+slot).tile=tiles(274+slot).tile
    tiles(276+slot).col=tiles(274+slot).col+2
    tiles(276+slot).seetru=1
    tiles(276+slot).gives=301+slot
    tiles(276+slot).hides=2
    tiles(276+slot).turnsinto=276+slot
    
    tiles(278+slot).tile=tiles(274+slot).tile
    tiles(278+slot).col=tiles(274+slot).col+3
    tiles(278+slot).seetru=1
    tiles(278+slot).gives=311+slot
    tiles(278+slot).hides=2
    tiles(278+slot).turnsinto=278+slot
    
    tiles(280+slot).tile=tiles(274+slot).tile
    tiles(280+slot).col=tiles(274+slot).col+3
    tiles(280+slot).seetru=1
    tiles(280+slot).gives=321+slot
    tiles(280+slot).hides=2
    tiles(280+slot).turnsinto=280+slot
    
    tiles(282)=tiles(280)
    tiles(282).gives=330
    tiles(282).turnsinto=282
    
    
    tiles(283+slot).tile=64 
    tiles(283+slot).col=civ(slot).spec.col
    tiles(283+slot).bgcol=0
    tiles(283+slot).desc="An alien scoutship"
    tiles(283+slot).seetru=1
    tiles(283+slot).walktru=0
    tiles(283+slot).firetru=1
    tiles(283+slot).shootable=1
    tiles(283+slot).locked=3
    tiles(283+slot).spawnson=100
    tiles(283+slot).spawnswhat=81+slot
    tiles(283+slot).spawnsmax=1
    tiles(283+slot).spawnblock=1
    tiles(283+slot).turnsinto=62
    tiles(283+slot).dr=2
    tiles(283+slot).hp=25
    tiles(283+slot).succt="It is slightly dented now"
    tiles(283+slot).failt="Your handwapons arent powerful enough to damage a spaceship"
    tiles(283+slot).killt="That will teach them a lesson!"
    tiles(283+slot).hides=2
    
    if slot=0 then
        if civ(slot).phil=1 then specialplanettext(7,0)="A planet with many small, modern structures dotting the landscape"
        if civ(slot).phil=2 then specialplanettext(7,0)="A planet with several medium to large cities distributed on the surface"
        if civ(slot).phil=3 then specialplanettext(7,0)="A planet with a huge, dominating megacity"
        specialplanettext(7,1)="The homeworld of the "&civ(slot).n
        if civ(slot).culture(4)=5 then 
            specialplanettext(7,0)=specialplanettext(7,0) &". In its orbit you discover a spacestation, connected to the ground by a gargantuan cable. A space lift!"
            specialplanettext(7,1)=specialplanettext(7,1) &". In its orbit you discover a spacestation, connected to the ground by a gargantuan cable. A space lift!"
        endif
    endif
    if slot=1 then
        if civ(slot).phil=1 then specialplanettext(46,0)="A planet with many small, modern structures dotting the landscape"
        if civ(slot).phil=2 then specialplanettext(46,0)="A planet with several medium to large cities distributed on the surface"
        if civ(slot).phil=3 then specialplanettext(46,0)="A planet with a huge, dominating megacity"
        specialplanettext(46,1)="The homeworld of the "&civ(slot).n
        if civ(slot).culture(4)=5 then 
            specialplanettext(46,0)=specialplanettext(46,0) &". In its orbit you discover a spacestation, connected to the ground by a gargantuan cable. A space lift!" 
            specialplanettext(46,1)=specialplanettext(46,1) &". In its orbit you discover a spacestation, connected to the ground by a gargantuan cable. A space lift!" 
        endif
    endif
    return 0
end function


#endif'main
#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tCivilisation -=-=-=-=-=-=-=-
	tModule.register("tCivilisation",@tCivilisation.init()) ',@tCivilisation.load(),@tCivilisation.save())
#endif'main
#ifdef test
#print -=-=-=-=-=-=-=- TEST: tCivilisation -=-=-=-=-=-=-=-
#endif'test
