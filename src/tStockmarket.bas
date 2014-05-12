'tStockmarket.

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
'     -=-=-=-=-=-=-=- TEST: tStockmarket -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tStockmarket -=-=-=-=-=-=-=-



#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tStockmarket -=-=-=-=-=-=-=-

namespace tStockmarket
function init() as Integer
	return 0
end function
end namespace'tStockmarket


#define cut2top



#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tStockmarket -=-=-=-=-=-=-=-
	tModule.register("tStockmarket",@tStockmarket.init()) ',@tStockmarket.load(),@tStockmarket.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tStockmarket -=-=-=-=-=-=-=-
#endif'test
