'tDefines.
'Define rudiments
'note: at first this code was structured to require includes to define and register itself in two steps 
'now you can simply include it before and after uModule and it will check defined() to link itself in
'since there is no init/load/save happening here, the 2nd inclusion only serves to make a complete run-
'time module list available should it be needed elsewhere. (e.g. include uDefines once b4 uModules is enough)

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

type tErrorMethod As Function(ErrWhere as String="") As integer
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
#undef test

? "TRUE", TRUE
? "FALSE", FALSE
? "NULL", NULL
?
sleep
#endif'test
