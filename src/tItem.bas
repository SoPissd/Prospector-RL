'tItem

function uid_pos(uid as uinteger) as integer
    dim i as integer
    for i=0 to lastitem
        if item(i).uid=uid then return i
    next
    return 0
end function


function check_item_filter(t as short,f as short) as short
    dim as short r,reverse
    reverse=11
    if f=0 then return 1
    if f<=4 or f=reverse then
        if t=f or (f=reverse and t<=4) then
            r=1
        endif
    endif
    if f=3 and t=103 then r=1 'Squidsuit
    if f=5 or f=reverse then
        if t=11 or t=19 or t=13 then
            r=1
        endif
    endif
    if f=6 or f=reverse then
        if t=7 then
            r=1
        endif
    endif
    if f=7 or f=reverse then
        if t=23 then
            r=1
        endif
    endif
    if f=8 or f=reverse then
        if t=15 then
            r=1
        endif
    endif
    if f=11 or f=reverse then
        if t=51 or t=52 or t=53 or t=21 or t=36 or t=40 or t=41 or t=25 then r=1
    endif
    if f=9 or f=reverse then
        if t=77 or t=50 or t=49 or t=48 or t=42 or t=41 or t=27 or t=18 or t=17 or t=16 or t=14 or t=12 or t=10 or t=9 or t=8 or t=5 then r=1
    endif
    if f=reverse then
        if r=0 then
            r=1
        else
            r=0
        endif
    endif
    
    return r
end function




function caged_monster_text() as string
    dim i as short
    dim as string t
    t="Captured lifeforms: "&lastcagedmonster &"|"
    for i=1 to lastcagedmonster
        t=t &"|"&cagedmonster(i).sdesc
        if i<lastcagedmonster and cagedmonster(i).c.s<>cagedmonster(i+1).c.s or i=lastcagedmonster then t=t &" in a "&item(cagedmonster(i).c.s).desig &"."
    next
    return t
end function



