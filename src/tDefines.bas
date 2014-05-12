'tDefines.
'
'namespace: tDefines

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
'     -=-=-=-=-=-=-=- TEST: tDefines -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tDefines -=-=-=-=-=-=-=-


'Define True/False values.
#Ifndef FALSE
	#Define FALSE 0
	#Define TRUE (Not FALSE)
#EndIf

'Create a NULL value.
#Ifndef NULL
    #Define NULL 0
#EndIf


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tDefines -=-=-=-=-=-=-=-

namespace tDefines
function init() as Integer
	return 0
end function
end namespace'tDefines

#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tDefines -=-=-=-=-=-=-=-
	tModule.register("tDefines",@tDefines.init()) ',@tDefines.load(),@tDefines.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tDefines -=-=-=-=-=-=-=-
#endif'test
