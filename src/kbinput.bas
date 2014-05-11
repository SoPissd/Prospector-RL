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


function keyinput(allowed as string="") as string
'    DimDebugL(0)'1
    dim as UInteger key
	do while inkey<>"": loop
    do        
		key=GetKey()
'		? chr(key and 255),chr(key shr 8)
    loop until key>0 or allowed="" or (instr(allowed,chr(key))>0) 
    return chr(key and 255)
end function


function Pressanykey(aRow as Integer=2,aCol as Integer=0,aFg as Integer=0,aBg as Integer=0) as Integer
	dim key as integer
	if (aFg>0) then
		tColor.set(aFg,aBg)
	EndIf
	while aRow>0
		?
		aRow -=1
	Wend
	tScreen.loc(aRow,aCol)
	Print "Press any key to exit";
	do while inkey<>"": loop
	key=GetKey()
	?
	return key
End function
