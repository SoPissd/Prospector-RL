'tKbinput.
'
'defines:
'keyplus=8, keyminus=8, keyinput=0, Pressanykey=4
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(types) or defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tKbinput -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tKbinput -=-=-=-=-=-=-=-

Const key__esc = 	Chr(27)
Const key__enter =	Chr(13)
Const key__space =	Chr(32)

Const xk= Chr(255)
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


declare function keyplus(key as string) as short
declare function keyminus(key as string) as short
declare function keyinput(allowed as string="") as string
declare function getdirection(key as string) as short

declare function isKeyYes(aKey as string) as short
declare function isKeyNo(aKey as string) as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tKbinput -=-=-=-=-=-=-=-

namespace tKbinput
function init(iAction as integer) as integer
	return 0
end function
end namespace'tKbinput


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


function getdirection(key as string) as short
    dim d as short
    if key=key_sw then return 1
    if key=key_south then return 2
    if key=key_se then return 3
    if key=key_west then return 4
    if key=key_east then return 6
    if key=key_nw then return 7
    if key=key_north then return 8
    if key=key_ne then return 9
    '
    if key=key__dn then return 2
    if key=key__lt then return 4
    if key=key__rt then return 6
    if key=key__up then return 8
    return 0
end function


function isKeyYes(aKey as string) as short
	return aKey=" "  or aKey=key__enter or aKey="Y" or aKey="y"' key_yes	
End Function

function isKeyNo(aKey as string) as short
	return aKey="N" or aKey="n" or aKey=key__esc	
End Function

'

#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tKbinput -=-=-=-=-=-=-=-
	tModule.register("tKbinput",@tKbinput.init()) ',@tKbinput.load(),@tKbinput.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tKbinput -=-=-=-=-=-=-=-
#endif'test
