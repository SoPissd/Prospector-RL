'tEnergycounter.

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
'     -=-=-=-=-=-=-=- TEST: tEnergycounter -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tEnergycounter -=-=-=-=-=-=-=-

Type _energycounter
    e As Integer
    Declare function add_action(v As Integer) As Integer
    Declare function tick() As Integer
End Type


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tEnergycounter -=-=-=-=-=-=-=-

namespace tEnergycounter
function init() as Integer
	return 0
end function
end namespace'tEnergycounter


#define cut2top

function _energycounter.add_action(v As Integer) As Integer
    e+=v
    Return 0
End function

function _energycounter.tick() As Integer
    If e>0 Then
        e-=1
        Return 0
    Else
        e=0
        Return -1
    End If
End function


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tEnergycounter -=-=-=-=-=-=-=-
	tModule.register("tEnergycounter",@tEnergycounter.init()) ',@tEnergycounter.load(),@tEnergycounter.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tEnergycounter -=-=-=-=-=-=-=-
#endif'test
