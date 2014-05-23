'gUtils.
'
'defines:
'string_towords=5, numfromstr=1, lastword=2, stripFileExtension=2,
', first_lc=1, first_uc=1, add_a_or_an=56, credits=134, lev_minimum=0,
', fuzzymatch=0, roman=5, Texttofile=0, screenshot_nextfilename=0,
', screenshot=12
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
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
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: gMenu -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: gMenu -=-=-=-=-=-=-=-

declare function textmenu overload (bg as short,te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1,loca as short=1) as short
declare function textmenu overload (            te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1,loca as short=1) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: gMenu -=-=-=-=-=-=-=-

namespace gMenu
function init(iAction as integer) as integer
	return 0
end function
end namespace'gMenu


function textmenu overload (bg as short,te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1,loca as short=0) as short
	dim aMenu as tMainmenu
	return aMenu.go(te,he,x,y,blocked,markesc,st,loca) 	          
end function

function textmenu overload (te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1,loca as short=0) as short
	dim aMenu as tMainmenu
	return aMenu.go(te,he,x,y,blocked,markesc,st,loca) 	          
end function


#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: gMenu -=-=-=-=-=-=-=-
	tModule.register("gMenu",@gMenu.init()) ',@gMenu.load(),@gMenu.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: gMenu -=-=-=-=-=-=-=-
#endif'test
