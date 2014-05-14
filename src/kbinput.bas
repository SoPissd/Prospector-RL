'kbinput.
'
'defines:
'keyplus=8, keyminus=8, keyinput=0, Pressanykey=4
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: kbinput -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: kbinput -=-=-=-=-=-=-=-

declare function keyplus(key as string) as short
declare function keyminus(key as string) as short
declare function keyinput(allowed as string="") as string

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: kbinput -=-=-=-=-=-=-=-

namespace tKbinput
	
function init() as Integer
	return 0
end function
end namespace'tKbinput



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

'

#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: kbinput -=-=-=-=-=-=-=-
	tModule.register("tKbinput",@tKbinput.init()) ',@kbinput.load(),@kbinput.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: kbinput -=-=-=-=-=-=-=-
#endif'test
