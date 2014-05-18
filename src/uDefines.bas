'tDefines.
'Define rudiments

#if not (defined(types) or defined(head) or defined(main))
#define intest
#endif
'
#ifdef intest
#print -=-=-=-=-=-=-=- TEST: tDefines -=-=-=-=-=-=-=-

#ifdef types 
	#print "types"
#else
	#print "no types"
#endif

#ifdef head 
	#print "head"
#else
	#print "no head"
#endif

#ifdef main 
	#print "main"
#else
	#print "no main"
#endif

#undef intest
#define test
#endif'test


#ifndef tErrorMethod							'declare if not found'
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

#endif'tErrorMethod


#ifdef tModule									'register if possible'

namespace tDefines
function init(iAction as integer) as integer
	return 0
end function
end namespace'tDefines

tModule.register("tDefines",@tDefines.init()) ',@tDefines.load(),@tDefines.save())

#endif'tModule

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tDefines -=-=-=-=-=-=-=-
? "TRUE", TRUE
? "FALSE", FALSE
? "NULL", NULL
?
sleep
#endif'test
