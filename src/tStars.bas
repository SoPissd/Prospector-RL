'tStars

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

Dim Shared specialplanet(lastspecial) As Short
Dim Shared specialplanettext(lastspecial,1) As String
Dim Shared spdescr(lastspecial) As String
Dim Shared specialflag(lastspecial) As Byte


function is_special(m as short) as short
    dim a as short
    for a=0 to lastspecial
        if m=specialplanet(a) then return -1
    next
    return 0
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






