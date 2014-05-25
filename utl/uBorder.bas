'tBorder.
#include once "uDefines.bi"
DeclareDependencies()

#include "uUtils.bas"
#include "uDebug.bas"
#include "uScreen.bas"
#include "file.bi"
#include "uFile.bas"
#include "uColor.bas"
#include "uConsole.bas"
#include "uVersion.bas"
#include "uError.bas"
#include "uRng.bas"
#include "uCoords.bas"
#include "uPrint.bas"
#include "uWindows.bas"

DeclareDependenciesDone()

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tBorder -=-=-=-=-=-=-=-

declare function draw_border overload (xoffset as short,yoffset as short,mwx as short,mhy as short) as short
declare function draw_border overload (xoffset as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tBorder -=-=-=-=-=-=-=-
namespace nsBorder
function init(iAction as integer) as integer
	return 0
end function
end namespace'nsBorder


function draw_border(xoffset as short) as short
    dim as short fh1,fw1,fw2,a
    set__color( 224,1)
    if xoffset>0 then draw string(xoffset*fw2,21*_fh1),chr(195),,Font1,Custom,@_col
    for a=(xoffset+1)*fw2 to (_mwx+1)*_fw1 step fw1
        draw string (a,21*_fh1),chr(196),,Font1,custom,@_col
    next
    for a=0 to tScreen.y-fh1 step fh1
        set__color( 224,1)
        'draw string ((_mwx+1)*_fw1,a),chr(179),,Font1,custom,@_col
        draw string ((_mwx+1)*_fw1,a),chr(179),,Font1,custom,@_col
        set__color(0,0)
        draw string ((_mwx+2)*_fw1,a),space(25),,font1,custom,@_col
    next
    set__color( 224,1)
    draw string ((_mwx+1)*_fw1,21*_fh1),chr(180),,Font1,custom,@_col
    set__color( 11,0)
    return 0
end function


function draw_border(xoffset as short,yoffset as short,mwx as short,mhy as short) as short
    dim as short a
    set__color( 224,1)

	if tScreen.isGraphic then
		if xoffset+mwx-1 > tScreen.gtw then mwx = tScreen.gtw-xoffset+1
		if yoffset+mhy-1 > tScreen.gth then mhy = tScreen.gth-yoffset+1
		
	    for a=1 to mwx-1
	        tScreen.draw1c(xoffset+a,yoffset,		chr(196))
	        tScreen.draw1c(xoffset+a,yoffset+mhy-1,	chr(196))
	    next
	    for a=yoffset to yoffset+mhy-1
	        'draw string ((_mwx+1)*_fw1,a),chr(179),,Font1,custom,@_col
	        tScreen.draw1c(xoffset,a,				chr(179))
	        tScreen.draw1c(xoffset+mwx-1,a,			chr(179))
	        'tScreen.draw1c(xoffset+mwx+2,a,space(25))
	    next
	    tScreen.draw1c(xoffset,			yoffset,		chr(218))
	    tScreen.draw1c(xoffset,			yoffset+mhy-1,	chr(192))
	    tScreen.draw1c(xoffset+mwx-1,	yoffset,		chr(191))
	    tScreen.draw1c(xoffset+mwx-1,	yoffset+mhy-1,	chr(217))
	else
		if xoffset+mwx-1 > uConsole.ttw then mwx = uConsole.ttw-xoffset+1
		if yoffset+mhy-1 > uConsole.tth then mhy = uConsole.tth-yoffset+1
		
	    for a=1 to mwx-1
	        tScreen.xy(xoffset+a,	yoffset,		chr(196))
	        tScreen.xy(xoffset+a,	yoffset+mhy-1,	chr(196))
	    next
	    for a=1 to mhy-1
	        tScreen.xy(xoffset,		yoffset+a,		chr(179))
	        tScreen.xy(xoffset+mwx-1,yoffset+a,		chr(179))
	    next
	    tScreen.xy(xoffset,			yoffset,		chr(218))
	    tScreen.xy(xoffset,			yoffset+mhy-1,	chr(192))
	    tScreen.xy(xoffset+mwx-1,	yoffset,		chr(191))
	    tScreen.xy(xoffset+mwx-1,	yoffset+mhy-1,	chr(217))
	endif
	
    set__color( 11,0)
    return mhy
end function


#endif'main


#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tBorder -=-=-=-=-=-=-=-
	tModule.register("nsBorder",@nsBorder.init()) ',@nsBorder.load(),@nsBorder.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tBorder -=-=-=-=-=-=-=-
#undef test
'#include "uWindows.bas" 'auto-close
ReplaceConsole()

#endif'test
