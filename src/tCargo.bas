'tCargo

function cargo_text() as string
    dim text as string
    dim cargo(12) as string
    dim cc(12) as short
    dim as short a
    cargo(1)="empty bay"
    cargo(2)="Food"
    cargo(3)="Basic goods"
    cargo(4)="Tech goods"
    cargo(5)="Luxury goods"
    cargo(6)="Weapons"
    cargo(7)="Narcotics"
    cargo(8)="Hightech"
    cargo(9)="Computers"
    cargo(10)="Fuel"
    cargo(11)="Mysterious box"
    cargo(12)="Contract Cargo"
    text="{15}Cargo:|{11}"
    for a=1 to 10
        if player.cargo(a).x>0 and player.cargo(a).x<11 then
            cc(player.cargo(a).x)+=1
        endif
    next
    for a=2 to 12
        select case cc(a)
        case 1
            text=text &cc(a) &" ton of "&lcase(cargo(a)) &"|"
        case is>1
            text=text &cc(a) &" tons of "&lcase(cargo(a)) &"|"
        end select
    next

    for a=1 to 10
        if player.cargo(a).x=11 or player.cargo(a).x=12 then
            text=text &cargo(player.cargo(a).x)& " for station "&player.cargo(a).y+1 &"|"
        endif
    next
    if cc(1)=1 then text=text &cc(1) &" "& cargo(1)
    if cc(1)>1 then text=text &cc(1) &" "& cargo(1)&"s"
    if cc(1)=0 then text=text &"No free bays."
    return text
end function
