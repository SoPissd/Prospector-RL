'#print "udefines.bas"
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
	#print "got types"
#else
	#print "no types"
#endif

#ifdef head 
	#print "got head"
#else
	#print "no head"
#endif

#ifdef main 
	#print "got main"
#else
	#print "no main"
#endif

#ifndef __FILE_BI__
#print no __FILE_BI__
#else
#print got __FILE_BI__
#endif

#ifndef __FBGFX_BI__
#print no __FBGFX_BI__
#else
#print got __FBGFX_BI__
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

#DEFINE _WindowsConsoleAutoClose 1 	' <--

type tSub As Sub()
type tErrorMethod As Function(ErrWhere as String="") As integer
type tActionmethod As Function(iAction as integer) As Integer
type tTextmethod As Function(aText as string) As Integer
type tTextIntegermethod As Function(aText as string,iAction as integer) As Integer

namespace tDefines
function init(iAction as integer) as integer
	return 0
end function
end namespace'tDefines

#endif'tErrorMethod

'#ifdef tModule									'register if possible'

'tModule.register("uDefines",@tDefines.init()) ',@tDefines.load(),@tDefines.save())

#if (defined(test) or defined(testload))
#print -=-=-=-=-=-=-=- TEST: tDefines -=-=-=-=-=-=-=-

	namespace tDefines

	sub definestest()
		? "TRUE", TRUE
		? "FALSE", FALSE
		? "NULL", NULL
		?
	End Sub

	end namespace'tDefines
	
	#ifdef test
		tDefines.definestest()
		sleep
	#else
		'tModule.registertest("uDefines",@tDefines.definestest())
	#endif'test
#endif'test
'#endif'tModule
