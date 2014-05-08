'tCoords

Type _cords
    s As Short '
    p As Short '
    m As Short
    x As Short
    y As Short
    z As Short
    'function set(x as short=0,y as short=0,z as short=0,m as short=0, p as short=0, s as short=0) as short
End Type


Type _driftingship extends _cords
    g_tile As _cords
    start As _cords
End Type

Dim Shared apwaypoints(1024) As _cords
Dim Shared usedship(8) As _cords
Dim Shared targetlist(4068) As _cords
Dim Shared probe(100) As _cords 'm=Item,

Dim Shared pwa(1024) As _cords 'Points working array

Dim Shared drifting(128) As _driftingship


Function cords(c As _cords) As String
    Return "("&c.x &":"& c.y &")"
End Function


'declare function _cords.set(x as short=0,y as short=0,z as short=0,m as short=0, p as short=0, s as short=0) as short
'    if x<>0 then this.x=x
'    if y<>0 then this.y=y
'    if z<>0 then this.z=z
'    if m<>0 then this.s=s
'    if p<>0 then this.p=p
'    if s<>0 then this.m=m
'    return 0
'end function
'


function distance(first as _cords, last as _cords,rollover as byte=0) as single
    dim as single dis,dx,dy,dx2
    dx=first.x-last.x
    dy=first.y-last.y
    if rollover<>0 then
        if first.x<last.x then
            dx2=60-last.x+first.x
        else
            dx2=60-first.x+last.x
        endif
        if abs(dx)>abs(dx2) then dx=dx2
    endif
    dis=sqr(dx*dx+dy*dy)
    return dis
end function

function sort_by_distance(c as _cords,p() as _cords,l() as short,last as short) as short
    dim as short sort,i

    do
        sort=0
        for i=1 to last-1
            if distance(c,p(i))>distance(c,P(i+1)) then
                sort=1
                swap p(i),p(i+1)
                swap l(i),l(i+1)
            endif
        next
    loop until sort=0
    
#if __FB_DEBUG__
    for i=1 to last
        DbgPrint(i &":"&int(distance(c,p(i))))
    next
#endif    
    return 0
end function

function furthest(list() as _cords,last as short, a as _cords,b as _cords) as short
    dim as single dis
    dim as short i,res
    for i=1 to last
        if distance(list(i),a)+distance(list(i),b)>dis then
            dis=distance(list(i),a)+distance(list(i),b)
            res=i
        endif
    next
    return res
end function

'

