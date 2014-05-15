'tDefines.
'
'namespace: tDefines

'
'
'defines:
'init=16
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
'     -=-=-=-=-=-=-=- TEST: tDefines -=-=-=-=-=-=-=-
#undef intest
#define test
#endif'test
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

'Define True/False values.
#Ifndef FALSE
	#Define FALSE 0
	#Define TRUE (Not FALSE)
#EndIf

'Create a NULL value.
#Ifndef NULL
    #Define NULL 0
#EndIf

type tErrorMethod As Function() As Integer
type tActionmethod As Function(iAction as integer) As Integer
type tTextmethod As Function(aText as string) As Integer
type tTextIntegermethod As Function(aText as string,iAction as integer) As Integer

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tDefines -=-=-=-=-=-=-=-
#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tDefines -=-=-=-=-=-=-=-

namespace tDefines
function init(iAction as integer) as integer
	return 0
end function
end namespace'tDefines

#endif'main

#if defined(main)
'      -=-=-=-=-=-=-=- INIT: tDefines -=-=-=-=-=-=-=-
	tModule.register("tDefines",@tDefines.init()) ',@tDefines.load(),@tDefines.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tDefines -=-=-=-=-=-=-=-
#endif'test
