'tItems

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

Declare Function placeitem(i As _items,x As Short=0,y As Short=0,m As Short=0,p As Short=0,s As Short=0) As Short
Declare Function make_item(a As Short,mod1 As Short=0,mod2 As Short=0,prefmin As Short=0,nomod As Byte=0) As _items
Declare Function rnd_item(t As Short) As _items

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
