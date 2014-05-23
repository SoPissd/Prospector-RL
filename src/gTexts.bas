'tTexts.
'
'defines:
'html_color=43, text_to_html=4
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
'     -=-=-=-=-=-=-=- TEST: tTexts -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tTexts -=-=-=-=-=-=-=-



#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tTexts -=-=-=-=-=-=-=-

namespace tTexts
function init(iAction as integer) as integer
	return 0
end function
end namespace'tTexts


#define cut2top



#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tTexts -=-=-=-=-=-=-=-
	tModule.register("tTexts",@tTexts.init()) ',@tTexts.load(),@tTexts.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tTexts -=-=-=-=-=-=-=-
#endif'test
