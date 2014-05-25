
	'needs [head|main|both] defined,
	' builds in test mode otherwise:
	'     -=-=-=-=-=-=-=- TEST: uWindows -=-=-=-=-=-=-=-

#macro DeclareDependenciesBasic()
	#if not (defined(types) or defined(head) or defined(main))
		#define intest
		#define both
	#endif'test
	#if defined(both)
		#undef both
		#define types
		#define head
		#define main
	#endif'both
	#ifdef intest
		#undef intest
#EndMacro

#macro DeclareDependenciesDone()
		#define test
	#endif'test
#EndMacro

#macro DeclareDependencies()
	DeclareDependenciesBasic()
	#include "uDefines.bas"
	#include "uModule.bas"
#EndMacro


