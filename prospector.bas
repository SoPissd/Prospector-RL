'prospector.

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (define(head) or define(main))
#define test
#define both
#endif'test
#if define(both)
#define head
#define main
#endif'both
#ifdef test
'     -=-=-=-=-=-=-=- TEST: prospector -=-=-=-=-=-=-=-

#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: prospector -=-=-=-=-=-=-=-



#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: prospector -=-=-=-=-=-=-=-

namespace prospector
public function init()
	return 0
end function
end namespace'prospector


#define cut2top
#DEFINE _FBSOUND 
'#DEFINE _FMODSOUND

#include once "src/main.bas"#define cut2bottom
#endif'main

#ifdef main
'      -=-=-=-=-=-=-=- MAIN: prospector -=-=-=-=-=-=-=-
	tModule.register("prospector",@prospector.init())
#endif'main
#ifdef test
#print -=-=-=-=-=-=-=- TEST: prospector -=-=-=-=-=-=-=-
#endif'test
