'tItems

declare function skill_test(bonus as short,targetnumber as short,echo as string="") as short
	
	
Type _items
    id As UInteger
    ti_no As UShort
    uid As UInteger
    w As _cords
    ICON As String*1
    col As Short
    bgcol As Short
    discovered As Short
    scanmod As Single
    desig As String*64
    desigp As String*64
    ldesc As String*255
    price As Integer
    declare function describe() as string
    ty As Short
    v1 As Single
    v2 As Single
    v3 As Single
    v4 As Single
    v5 As Single 'Only for rewards
    v6 As Single 'Rover mapdata
    vt As _cords'rover target
    res As UByte
End Type

Dim Shared item(25000) As _items
Dim Shared lastitem As Integer=-1
Dim Shared shopitem(20,30) As _items

Declare function placeitem(i As _items,x As Short=0,y As Short=0,m As Short=0,p As Short=0,s As Short=0) As Short
Declare function make_item(a As Short,mod1 As Short=0,mod2 As Short=0,prefmin As Short=0,nomod As Byte=0) As _items
Declare function rnd_item(t As Short) As _items

'

Dim Shared reward(11) As Single

function calc_resrev() as short
    dim as short i
    static v as integer
    static called as byte
    if called=0 or called mod 10=0 then
        v=0
        for i=0 to lastitem
            if item(i).ty=15 and item(i).w.s<0 then v=v+item(i).v5
        next
    endif
    if called=10 then called=0
    called+=1
    if v>reward(0) then 
        reward(0)=v
    endif
    return 0
end function

'

function findbest(t as short,p as short=0, m as short=0,id as short=0) as short
    dim as single a,b,r,v
    r=-1
    if awayteam.optoxy=1 and t=3 then b=999
    for a=1 to lastitem
        if p<>0 then
            if (item(a).w.s=p and item(a).ty=t) then
                if t<>3 or awayteam.optoxy=0 then
                    if item(a).v1>b then
                        r=a
                        b=item(a).v1
                    endif
                endif
                if id<>0 and item(a).ty=id then return a
                if t=3 then 
                    if awayteam.optoxy=1 then
                        v=item(a).v3*0.9*item(a).v1^2*2+item(a).v1/2
                        if v<b then
                            r=a
                            b=v
                        endif
                    endif
                    if awayteam.optoxy=2 then
                        if item(a).v3>b then
                            r=a
                            b=item(a).v3
                        endif
                    endif
                endif
            endif
        endif
        
        if m<>0 then
            if item(a).w.m=m and item(a).w.s=0 and item(a).w.p=0 and item(a).ty=t then
                if item(a).v1>b then
                    r=a
                    b=item(a).v1
                endif
            endif
        endif
    next
    if id<>0 and r>0 then
        if item(r).id<>id then r=-1
    endif
    return r
end function



function _items.describe() as string
    dim t as string
    select case ty
    case 1
        return ldesc &"||Capacity:"&v2 &" passengers."
    case 2,4
        t=ldesc &"|"
        if v1>0 then t=t & "|Damage: "&v1
        if v3>0 then t=t & "|Accuracy: "&v3
        if v2>0 then t=t & "|Range: "&v2
        return t
    case 3,103
        t=ldesc
        if v4>0 then t=t &"| !This suit is damaged! |"
        t=t &"||Armor: "&v1 &"|Oxygen: "&v3
        if v2>0 then t=t &"|Camo rating "&v2
        return t
    case 18
        t=ldesc
        t=t &"||Sensor range: "&v1 &"|Speed: "&v4
        return t
    case 56
        t=ldesc &"||HP:"&v1 &"|Volume:"&v3
    case else
        return ldesc
    end select
end function




function make_locallist(slot as short) as short
    dim as short i,x,y,r
    dim p as _cords
    itemindex.del
    for i=1 to lastitem
        if item(i).w.m=slot and item(i).w.s=0 and item(i).w.p=0 then
            if itemindex.add(i,item(i).w)=-1 then
                item(i).w=movepoint(item(i).w,5)
                i-=1
            endif
        endif
    next
    
    portalindex.del
    for i=0 to lastportal
        if portal(i).dest.m=slot  and portal(i).oneway=0 then portalindex.add(i,portal(i).dest)
        if portal(i).from.m=slot then portalindex.add(i,portal(i).from)
        if portal(i).oneway=2 and portal(i).from.m=slot or portal(i).dest.m=slot then
            for x=0 to 60
                for y=0 to 20
                    p.x=x
                    p.y=y
                    if x=0 or y=0 or x=20 or y=20 then portalindex.add(i,p)
                next
            next
        endif
    next
        
    return 0
end function


function rnd_item(t as short) as _items
    dim i as _items
    dim as short r
    dim items(25) as short

    if t=RI_Lamps then 
        if rnd_range(1,100)<66 then
            i=make_item(28)
        else
            i=make_item(29)
        endif
    endif
    
    if t=RI_SPACEBOTS then
        select case rnd_range(1,100)
        case 1 to 33
            i=rnd_item(RI_Drones)
        case 34 to 66
            i=rnd_item(RI_probes)
        case else
            i=rnd_item(RI_Gasprobes)
        end select
    end if
    
    if t=RI_Cage then
        select case rnd_range(1,100)
        case 1 to 50
            i=make_item(62)
        case 51 to 80
            i=make_item(63)
        case else
            i=make_item(64)
        end select
    endif
    
    if t=RI_Tanks then 
        if rnd_range(1,100)<50 then
            i=make_item(21)'Air filter
        else
            if rnd_range(1,100)<66 then
                i=make_item(38)'Aux tank Air
            else
                i=make_item(49)'Aux tank JJ
            endif
        endif
    endif
    
    if t=RI_Artefact then
        select case rnd_range(1,100)
        case 1 to 20
            i=make_item(97)
        case 21 to 40
            i=make_item(98)
        case 41 to 50
            i=make_item(95)
        case 51 to 55
            i=make_item(301)
        case 55 to 60
            i=make_item(302)
        case 60 to 89
            i=make_item(123)
        case else
            i=make_item(rnd_range(95,98))
        end select
    endif
        
    if t=RI_ALLDRONESPROBES then
        select case rnd_range(1,100)
        case 1 to 40
            i=rnd_item(RI_Drones)
        case 41 to 80
            i=rnd_item(RI_Probes)
        case else
            i=rnd_item(RI_Gasprobes)
        end select
    endif
    
    if t=RI_StandardShop then 
        select case rnd_range(1,100)
        case 1 to 50
            i=rnd_item(RI_WeaponsArmor)
        case 51 to 60
            i=rnd_item(RI_ALLDRONESPROBES)
        case 61 to 70
            i=rnd_item(RI_Medpacks)
        case 71 to 80
            i=rnd_item(RI_Mining)
        case 81 to 90
            i=rnd_item(RI_ROBOTS)
        case else
            i=make_item(30)
        end select
    endif
    
    if t=RI_Strandedship then 
        select case Rnd_range(1,100)
        case 1 to 40
            i=rnd_item(RI_WeaponsArmor)
        case 41 to 50
            i=rnd_item(RI_Transport)
        case 51 to 60
            i=rnd_item(RI_Lamps)
        case 61 to 70
            i=rnd_item(RI_Tanks)
        case 71 to 80
            i=rnd_item(RI_Mining)
        case else
            i=rnd_item(RI_Shipequipment)
        end select
        
    endif
    
    
    if t=RI_Transport then i=make_item(rnd_range(1,2)) 'transport
    if t=RI_RangedWeapon then i=make_item(urn(0,8,2,gameturn/5000)+3) 'ranged weapons
    if t=RI_CCWeapon then i=make_item(urn(0,7,2,gameturn/5000)+40) 'close weapons
    if t=RI_Armor then 'Space suits 
        if rnd_range(1,100)<30-gameturn/5000 then
            i=make_item(320)
        else
            i=make_item(urn(0,8,2,gameturn/5000)+12) 'Armor
        endif
    endif
    if t=RI_ShopAliens then 
        if rnd_range(1,100)<10 then 
            if rnd_range(1,100)<50 then
                i=make_item(rnd_range(78,80))
            else
                i=make_item(rnd_range(82,84))
            endif
        else
            i=make_item(rnd_range(21,39)) 'misc
        endif
    endif
    
    if t=RI_Mining then 'misc2 mining
        if rnd_range(1,100)<50 then
            if rnd_range(1,100)<70 then
                i=make_item(22) 'Drill
            else
                i=make_item(23) 'Laser drill
            endif
        else
            i=make_item(152) 'Mining Explosives
        endif
        if rnd_range(1,100)<15 then i=make_item(rnd_range(41,43))
    endif
    
    if t=RI_KOdrops then i=make_item(rnd_range(36,37)) 'Anaesthetics
    
    if t=RI_Medpacks then 
        if rnd_range(1,100)<50 then
            i=make_item(rnd_range(56,58)) 'meds2
        else
            i=make_item(rnd_range(31,33))
        endif
    endif
    if t=RI_WEAPONS then 'weapons
        if rnd_range(1,100)<50 then
            i=make_item(rnd_range(3,11)) 'Ranged weapons
        else
            i=make_item(rnd_range(40,47)) 'CC Weapons
        endif
    endif
    
    if t=RI_Rovers then i=make_item(rnd_range(50,52))'fs
    
    if t=RI_Allbutweapons then 'all but weapons
        select case rnd_range(1,100)
            case 1 to 20
                i=make_item(rnd_range(1,2))
            case 21 to 40
                i=make_item(rnd_range(15,33))
            case 41 to 60
                i=make_item(rnd_range(50,58))
            case 61 to 80
                i=make_item(rnd_range(21,30))
            case 80 to 100
                i=make_item(rnd_range(70,71))
            case else
                i=make_item(77)
        end select 
    endif
    
    if t=RI_Infirmary then
        i=make_item(rnd_range(67,69))
    endif
    
    if t=RI_ROBOTS then
        if rnd_range(1,100)<50 then
            i=make_item(RI_Rovers)
        else
            i=make_item(RI_Miningbots)
        endif
    endif
    
    if t=RI_LandingGear then i=make_item(rnd_range(75,76))
    
    if t=RI_Probes then i=make_item(rnd_range(101,102))
    
    if t=RI_Drones then i=make_item(rnd_range(110,112))
    
    if t=RI_GasProbes then i=make_item(rnd_range(104,105))
    
    if t=RI_Mining then
        select case rnd_range(1,100)
        case 1 to 55
            i=make_item(152)
        case 55 to 85
            i=make_item(22)
        case else
            i=make_item(23)
        end select
    endif
    
    if t=RI_Miningbots then
        select case rnd_range(1,100)
        case 1 to 50
            i=make_item(53)
        case 50 to 80
            i=make_item(54)
        case else
            i=make_item(55)
        end select
    endif
        
    if t=RI_ShopSpace or t=RI_Shipequipment then
        r=rnd_range(1,11)
        if r=1 then i=make_item(30)'Comsat
        if r=2 then i=rnd_item(RI_Robots)
        if r=3 then i=rnd_item(RI_Infirmary)
        if r=4 then i=make_item(rnd_range(70,71))'Emergency Beacon
        if r=4 then i=rnd_item(RI_LandingGear)
        if r=5 then i=rnd_item(RI_Probes)
        if r=6 then i=rnd_item(RI_GasProbes)
        if r=7 then i=rnd_item(RI_Drones)
        if r=8 then i=rnd_item(RI_Medpacks)
        if r=9 then i=rnd_item(RI_Mining)
        if r=10 then i=rnd_item(RI_Lamps)
        if r=11 then i=rnd_item(RI_tanks)
    endif
        
    
    if t=RI_AllButWeaponsAndMeds then 'All but weapons and meds
        r=rnd_range(1,32)
        if r=1 then i=make_item(1)
        if r=2 then i=make_item(2)
        if r=3 then i=make_item(21)
        if r=4 then i=make_item(22)
        if r=5 then i=make_item(23)
        if r=6 then i=make_item(24)
        if r=7 then i=make_item(25)
        if r=8 then i=make_item(26)
        if r=9 then i=make_item(27)
        if r=10 then i=make_item(28)
        if r=11 then i=make_item(29)
        if r=12 then i=make_item(30)
        if r=13 then i=make_item(38)
        if r=14 then i=make_item(39)
        if r=15 then i=make_item(48)
        if r=16 then i=make_item(49)
        if r=17 then i=make_item(50)
        if r=18 then i=make_item(51)
        if r=19 then i=make_item(52)
        if r=20 then i=make_item(53)
        if r=21 then i=make_item(54)
        if r=22 then i=make_item(55)
        if r=23 then i=make_item(59)
        if r=24 then i=make_item(60)
        if r=25 then i=make_item(70)
        if r=26 then i=make_item(71)
        if r=27 then i=make_item(72)
        if r=28 then i=make_item(73)
        if r=29 then i=make_item(77)
        if r=30 then i=make_item(100)
        if r=31 then i=make_item(101)
        if r=32 then i=make_item(102)
    endif
    
    if t=RI_ShopExplorationGear then 'specialty shop exploration gear
        r=rnd_range(1,40)
        if r=1 then i=make_item(49)
        if r=2 then i=make_item(50)
        if r=3 then i=make_item(51)
        if r=4 then i=make_item(52)
        if r=5 then i=make_item(53)
        if r=6 then i=make_item(54)
        if r=7 then i=make_item(55)
        if r=8 then i=make_item(75)
        if r=9 then i=make_item(76)
        if r=10 then i=make_item(77)
        if r=11 then i=make_item(78)
        if r=12 then i=make_item(79)
        if r=13 then i=make_item(80)
        if r=14 then i=make_item(83)
        if r=15 then i=make_item(84)
        if r=16 then i=make_item(85)
        if r=18 then i=make_item(100)
        if r=19 then i=make_item(101)
        if r=20 then i=make_item(102)
        if r=21 then i=make_item(103)
        if r=17 then i=make_item(104)
        if r=22 then i=make_item(22)
        if r=23 then i=make_item(23)
        if r=24 then i=make_item(62)
        if r=25 then i=make_item(63)
        if r=26 then i=make_item(162)
        if r=27 then i=make_item(163)
        if r=28 then i=make_item(38)
        if r=29 then i=make_item(30)'Comsat
        if r>=30 and r<=37 then i=make_item(1)
        if r>=38 and r<=40 then i=make_item(2)
    endif
    
    if t=RI_Kits then
        select case rnd_range(1,100)
        case 1 to 33
            i=make_item(82)'Autopsy Kit
        case 34 to 66
            i=make_item(83)'Botany Kit
        case else
            i=make_item(84)'Ship Repair
        end select
    endif
    
    if t=RI_ShopWeapons then 'Weapons
        select case rnd_range(1,100)
            case is<33 
                i=make_item(rnd_range(3,20)) 'Guns and Armor
            case is>90 
                if rnd_range(1,100)<50 then
                    if rnd_range(1,100)<66 then
                        i=make_item(rnd_range(106,107))' Small Grenades
                    else
                        i=make_item(rnd_range(24,25))'grenades
                    endif
                else
                    i=make_item(rnd_range(59,61))'Mines
                endif
            case else
                if rnd_range(1,100)<90 then
                    i=make_item(rnd_range(40,47))'CC weapons
                else
                    i=make_item(48)'Grenade launcher
                endif
        end select
    endif
    
    if t=RI_WeaponsArmor then 'Weapons or armor
        select case rnd_range(1,100)
        case is<33
            i=make_item(rnd_range(3,11))
        case is>66
            i=make_item(rnd_range(40,47))
        case else
            i=make_item(rnd_range(12,20))
        end select        
    endif
    
    if t=RI_WeakStuff then 'Starting equipment Weak stuff
        select case rnd_range(1,78)
        case 1 to 5 
            i=make_item(21,,,,1)'1 Airfilters
        case 5 to 9 
            i=make_item(24,,,,1)'2 Grenade
        case 10 to 20 
            i=make_item(26,,,,1)'3 Binocs
        case 21 to 30 
            i=make_item(28,,,,1)'4 Lamp
        case 31 to 38 
            i=make_item(31,,,,1)'5 Medpack
        case 39 to 42 
            i=make_item(34,,,,1)'6 Lockpicks
        case 43 to 47 
            i=make_item(36,,,,1)'7 Anaesthtics
        case 48 to 53 
            i=make_item(38,,,,1)'8 Ox tank
        case 54 to 55 
            i=make_item(56,,,,1)'9 Disease Kit
        case 56 to 58 
            i=make_item(70,,,,1)'10 em beacon
        case 59 to 65 
            i=make_item(78,,,,1)'11 Flash grenade
        case 65 to 69
            select case rnd_range(1,3)
            case is=1
                i=make_item(82,,,,1)'12 Autopsy kit
            case is=2
                i=make_item(83,,,,1)'13 Botany Kit
            case is=3
                i=make_item(84,,,,1)'14 SR Kit
            end select
        case 70 to 72
            i=make_item(31,,,,1)'5 Medpack
        case 72 to 74
            i=make_item(106,,,,1)'15 Grenade
        case 75 to 78
            i=make_item(152,,,,1)'Mining explosives
        end select
        
    endif
    
    
    if t=RI_WeakWeapons then 'weak weapons and armor
        select case rnd_range(1,100)
        case 1 to 30
            i=make_item(urn(0,4,1,0)+3,,,,1)
        case 31 to 50
            i=make_item(urn(0,4,1,0)+40,,,,1)
        case 51 to 80
            i=make_item(urn(0,2,1,0)+12,,,,1)
        case else
            i=make_item(320)
        end select
    end if
    
    return i
end function



function sort_items(list() as _items) as short
    dim as short l,i,flag
    l=ubound(list)
    do
    flag=0
    for i=1 to l-1
        if list(i).ty>0 and list(i).ty=list(i+1).ty then
            if list(i).v1>list(i+1).v1 then 
                swap list(i),list(i+1) 
                flag=1
            endif
        endif
    next
    loop until flag=0
    return 0
end function

function make_shipequip(a as short) as _items
    dim i as _items
    i.id=a+9000
    select case a
    case 1 to 5
        i.ty=150
        i.desig="Sensors "&roman(a)
        i.v1=a
        if a=1 then
            i.price=200
        else
            i.price=800*(a-1)
        endif
    case 6 to 10
        i.ty=151
        i.desig="Engine "&roman(a-5)
        i.v1=a-5
        i.price=(2^(i.v1-1))*300
    case 11 to 14
        i.ty=152
        i.desig="Shield "&roman(a-10)
        i.v1=a-10
        i.price=(2^(i.v1-1))*500
    case 15
        i.desig="ship detection system"
        i.desigp="ship detection systems"
        i.price=1500
        i.id=1001
        i.ty=153
        i.v1=1
        i.ldesc="Filters out ship signatures out of longrange sensor noise."
    case 16
        i.desig="imp. ship detection sys."
        i.desigp="imp. ship detection sys."
        i.price=3000
        i.id=1002
        i.ty=153
        i.v1=2
        i.ldesc="Filters out ship signatures, and friend-foe signals out of longrange sensor noise."
    case 21
        i.desig="navigational computer"
        i.desigp="navigational computers"
        i.price=350
        i.id=1003
        i.ty=154
        i.v1=1
        i.ldesc="A system keeping track of sensor input. Shows you where you are and allows you to see where you have already been." 
    case 18
        i.desig="ECM I system"
        i.desigp="ECM I systems"
        i.price=3000
        i.ty=155
        i.id=1004
        i.v1=1
        i.ldesc="Designed to prevent sensor locks, especially effective against missiles"
    case 19    
        i.desig="ECM II system"
        i.desigp="ECM II systems"
        i.price=9000
        i.ty=155
        i.id=1005
        i.v1=2
        i.ldesc="Designed to prevent sensor locks, and decrease sensor echo. especially effective against missiles"
    case 20
        i.desig="Cargo bay shielding"
        i.price=500
        i.ty=156
        i.id=1006
        i.v1=30
        i.ldesc="Special shielding for cargo bays, making it harder to scan them."
    case 17
        i.desig="Cargo bay shielding MKII"
        i.price=1500
        i.ty=156
        i.id=1007
        i.v1=45
        i.ldesc="Special shielding for cargo bays, making it harder to scan them."
    case 22
        i.desig="Fuel System I"
        i.price=500
        i.ty=157
        i.v1=1
        i.ldesc="Saves fuel by reducing leakage."
    case 23
        i.desig="Fuel System II"
        i.price=750
        i.ty=157
        i.v1=2
        i.ldesc="Saves fuel by reducing leakage and improved engine control."
    end select
    return i
end function


function destroyitem(b as short) as short     
    if b>=0 and b<=lastitem then
        item(b)=item(lastitem)
        lastitem=lastitem-1
        return 0
    else
        if b>lastitem then
            lastitem=lastitem+1
            item(b)=item(lastitem)
            lastitem=lastitem-1
            'rlprint "ERROR: attempted to destroy nonexistent item "& b,14
        endif
        return -1
    endif
end function

    
function destroy_all_items_at(ty as short, wh as short) as short
    dim as short i,d,c
'    do
'        if item(i).ty=ty and item(i).w.s=wh then
'            item(i)=item(lastitem)
'            lastitem-=1
'            d+=1
'        else
'            i+=1
'        endif
'        c+=1
'    loop until i>lastitem or c>lastitem
    do
    d=0
    for i=0 to lastitem
        if item(i).ty=ty and item(i).w.s=wh then 
            item(i)=item(lastitem)
            lastitem-=1
            d+=1
        endif
    next
    loop until d=0
    return d
end function


function placeitem(i as _items,x as short=0,y as short=0, m as short=0, p as short=0, s as short=0) as short
    if m>0 and s<0 then rlprint "m:"&m &"s:"&s &"lp:"&lastplanet
    i.w.x=x
    i.w.y=y
    i.w.m=m
    i.w.p=p
    i.w.s=s
    i.discovered=show_allitems
    dim a as short
    if lastitem<25000 then 'Noch platz f�r neues
        lastitem=lastitem+1
        item(lastitem)=i
        item(lastitem).uid=lastitem
        return lastitem
    else
        for a=0 to lastitem '�berschreibe erstes item das nicht im schiff und keine mm
            item(a).uid=a
            if item(a).w.s>=0 and item(a).ty<>15 then
                item(a)=i
                return a
            endif
        next
    endif
    rlprint "ITEM PLACEMENT ERROR!(lastitem="&lastitem &")",14
end function


function item_filter() as short
    dim a as short
    a=menu(bg_parent,"Item type:/Transport/Ranged weapons/Armor/Close combat weapons/Medical supplies/Grenades/Artwork/Resources/Equipment/Ship equipment/All Other/None/Exit","",20,2)
    if a>11 then a=0
    if a<0 then a=0
    return a
end function


function removeequip() as short
    dim a as short
    for a=0 to lastitem
        if item(a).w.s<0 then item(a).w.s=-1
    next
    return 0
end function


function display_item_list(inv() as _items, invn() as short, marked as short, l as short,x as short,y as short) as short
    dim as short last,i,longest,ll,wh
    static offset as short
    screenset 0,1
    last=ubound(inv)
    
    for i=1 to l
        if len(trim(inv(i).desig))>longest then longest=len(trim(inv(i).desig))
        if len(trim(inv(i).desigp))>longest then longest=len(trim(inv(i).desigp))
    next
    for i=1 to last
        if invn(i)<>0 then ll+=1
    next
    if ll>20 then
        wh=20
    else
        wh=ll
    endif
    longest=longest+5
    'Format: invn=1 1 piece, invn>1 plural invn<1 Headline, text color white
    if marked+offset>wh then offset=wh-marked
    if marked+offset<1 then offset=1-marked
    if marked+offset=1 and invn(marked-1)<0 then offset+=1
    for i=1 to wh
        if i-offset>=0 and i-offset<=last then
            set__color(1,1)
            draw string(x*_fw2,(y+i)*_fh2),space(longest),,font2,custom,@_col
            if marked=i-offset then 
                set__color(15,5)
            else
                set__color(11,1)
            endif
            select case invn(i-offset)
            case 1
                draw string(x*_fw2,(y+i)*_fh2),"  "&trim(inv(i-offset).desig),,font2,custom,@_col
            case is>1
                draw string(x*_fw2,(y+i)*_fh2),"  "&invn(i-offset) &" "&trim(inv(i-offset).desigp),,font2,custom,@_col
                
            case is<1
                set__color(15,1)
                draw string(x*_fw2,(y+i)*_fh2)," "&trim(inv(i-offset).desig),,font2,custom,@_col
            end select
        endif
        if ll>wh then scroll_bar(-offset,ll,wh,wh-1,(x+longest)*_fw2,y*_fh2+_fh2,11)
    next
    flip
    return 0
end function


function next_item(c as integer) as integer
    dim i as short
    for i=0 to lastitem
        if i<>c then
            if item(i).w.s<0 and item(i).id=item(c).id and item(i).ty=item(c).ty and item(c).ty<>15 then
                return i
            endif
        endif
    next
    return -1
end function


function getrnditem(fr as short,ty as short) as short
    dim as short a,i,lst
    dim list(1048) as short
    for a=0 to lastitem
        if item(a).w.s=fr then
            if (ty>0 and item(a).ty=ty) or ty=0 then
                lst=lst+1
                if lst>1048 then lst=rnd_range(1,1048)
                list(lst)=a
            endif
        endif
    next
    if lst>1048 then lst=1048
    if lst>0 then
        i=list(rnd_range(1,lst))
    else 
        i=-1
    endif
    return i
end function


function findbest_jetpack() as short
    dim as short r,i
    dim as single v3
    r=-1
    v3=20
    for i=0 to lastitem
        if item(i).ty=1 and item(i).v1=2 and item(i).w.s=-1 then
            if item(i).v3<v3 then 
                v3=item(i).v3
                r=i
            endif
        endif
    next
    return r
end function


function findworst(t as short,p as short=0, m as short=0) as short
    dim as single a,b,r
    r=-1
    b=100
    for a=0 to lastitem
        if p<>0 then
            if item(a).w.s=p and item(a).ty=t then
                if item(a).v1<b then
                    r=a
                    b=item(a).v1
                endif
            endif
        endif
        
        if m<>0 then
            if item(a).w.m=m and item(a).w.p=0 and item(a).ty=t then
                if item(a).v1<b then
                    r=a
                    b=item(a).v1
                endif
            endif
        endif
    next
    return r
end function


function lowest_by_id(id as short) as short
    dim as short i,best
    dim as single v,cur
    best=-1
    v=99
    for i=0 to lastitem
        if item(i).w.s<0 and item(i).id=id then
            cur=item(i).v1+item(i).v2+item(i).v3
            if cur<v then 
                best=i
                v=cur
            endif
        endif
    next
    return best
end function


function count_items(i as _items) as short
    dim as short j,r
    for j=0 to lastitem
        if item(j).w.s<0 and item(j).id=i.id and item(j).v1=i.v1 and item(j).v2=i.v2 and item(j).v3=i.v3 then r+=1
    next
    return r
end function


function better_item(i1 as _items,i2 as _items) as short
    dim as short i,l
'    if len(i1.desig)>len(i2.Desig) then 
'        l=len(i1.desig)
'    else
'        l=len(i2.desig)
'    endif
'    for i=1 to l-1
'        if asc(mid(i1.desig,i,1))>asc(mid(i2.desig,i,1)) then return 1
'    next
    if i1.v1+i1.v2+i1.v3+i1.v4+i1.v5>i2.v1+i2.v2+i2.v3+i2.v4+i2.v5 then return 1
    return 0
end function
