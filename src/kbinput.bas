'kbInput

declare Function Cursor(target As _cords,map As Short, osx As Short,osy As Short=0,radius As Short=0) As String

'function keyin(byref allowed as string="" , blocked as short=0)as string

Dim Shared As UByte _FH1,_FH2,_FW1,_FW2,_TFH

Const xk=Chr(255)
Const key__up = xk & "H"
Const key__dn = xk & "P"
Const key__rt= xk & "M"
Const key__lt = xk & "K"
Const key__esc = Chr(27)
Const key__enter = Chr(13)
Const key__space = Chr(32)

Dim Shared As String*3 key_nw="7"
Dim Shared As String*3 key_north="8"
Dim Shared As String*3 key_ne="9"
Dim Shared As String*3 key_west="4"
Dim Shared As String*3 key_east="6"
Dim Shared As String*3 key_sw="1"
Dim Shared As String*3 key_south="2"
Dim Shared As String*3 key_se="3"

function keyplus(key as string) as short
    dim r as short
    if key=key__up or key=key__lt or key=key_south or key="+" then r=-1
    return r
end function

function keyminus(key as string) as short
    dim r as short
    if key=key__dn or key=key__rt or key=key_north or key="-" then r=-1
    return r
end function


function locEOL() as _cords
    'puts cursor at end of last displayline
    dim as short y,x,a,winh,firstline
    dim as _cords p
    winh=fix((_screeny-_fh1*22)/_fh2)-1
    do
        firstline+=1
    loop until firstline*_fh2>=22*_fh1

    y=firstline+winh
    for a=firstline+winh to firstline step -1
        if displaytext(a+1)="" then y=a
    next
    x=len(displaytext(y))+1
    p.x=x
    p.y=y
    return p
end function


