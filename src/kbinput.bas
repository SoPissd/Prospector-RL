'kbInput

'function keyin(byref allowed as string="" , blocked as short=0)as string

Dim Shared As UByte _FH1,_FH2,_FW1,_FW2,_TFH

Const key__esc = 	Chr(27)
Const key__enter =	Chr(13)
Const key__space =	Chr(32)

Const xk=Chr(255)
Const key__up = 	xk & "H"
Const key__dn = 	xk & "P"
Const key__rt= 		xk & "M"
Const key__lt = 	xk & "K"

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


function Pressanykey(aCol as short=0,aFg as short=0,aBg as short=0) as Integer
	if aFg>0 then
		set__color( aFg,aBg )
	EndIf
	if aCol>0 then
		Locate csrlin,aCol
	EndIf
	Print "Press any key to exit"
	do while inkey<>"": loop
	Sleep
	return 0
End function
