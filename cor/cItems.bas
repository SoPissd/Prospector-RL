'tItems.
'


'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(types) or defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#undef both
#define types
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tItems -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test


#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

Const show_allitems=0

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

dim shared itemindex as _index

Dim Shared item(25000) As _items
Dim Shared lastitem As Integer=-1
Dim Shared shopitem(20,30) As _items

Dim Shared reward(11) As Single

Const lastartifact=25
Dim Shared artflag(lastartifact) As Short

Dim Shared baseprice(9) As Short
Dim Shared avgprice(9) As Single

type tMakeitem as function(a as short, mod1 as short=0,mod2 as short=0,prefmin as short=0,nomod as byte=0) as _items
dim Shared pMakeitem as tMakeitem

#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tItems -=-=-=-=-=-=-=-

declare function calc_resrev() as short
declare function findbest(t as short,p as short=0, m as short=0,id as short=0) as short
declare function make_locallist(slot as short) as short
declare function sort_items(list() as _items) as short
declare function destroyitem(b as short) as short     
declare function destroy_all_items_at(ty as short, wh as short) as short
declare function placeitem(i as _items,x as short=0,y as short=0, m as short=0, p as short=0, s as short=0) as short
declare function removeequip() as short
declare function better_item(i1 as _items,i2 as _items) as short
declare function count_items(i as _items) as short
declare function lowest_by_id(id as short) as short

'declare function make_shipequip(a as short) as _items
'declare function item_filter() as short
'declare function next_item(c as integer) as integer
'declare function getrnditem(fr as short,ty as short) as short
'declare function findbest_jetpack() as short
'declare function findworst(t as short,p as short=0, m as short=0) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tItems -=-=-=-=-=-=-=-

namespace tItems
function init(iAction as integer) as integer
	return 0
end function
end namespace'tItems

	
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
'    if m>0 and s<0 then rlprint "m:"&m &"s:"&s &"lp:"&lastplanet
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
'    rlprint "ITEM PLACEMENT ERROR!(lastitem="&lastitem &")",14
end function


'function item_filter() as short
'    dim a as short
'    a=textmenu(bg_parent,"Item type:/Transport/Ranged weapons/Armor/Close combat weapons/Medical supplies/Grenades/Artwork/Resources/Equipment/Ship equipment/All Other/None/Exit","",20,2)
'    if a>11 then a=0
'    if a<0 then a=0
'    return a
'end function


function removeequip() as short
    dim a as short
    for a=0 to lastitem
        if item(a).w.s<0 then item(a).w.s=-1
    next
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


#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tItems -=-=-=-=-=-=-=-
	tModule.register("tItems",@tItems.init()) ',@tItems.load(),@tItems.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tItems -=-=-=-=-=-=-=-
#endif'test
