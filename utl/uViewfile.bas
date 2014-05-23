'tViewfile.
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
'     -=-=-=-=-=-=-=- TEST: tViewfile -=-=-=-=-=-=-=-
#undef intest

#include "uDefines.bas"
#include "uModule.bas"
#include "uDefines.bas"
#include "uScreen.bas"
#include "uDebug.bas"
#include "file.bi"
#include "uFile.bas"
#include "uColor.bas"
#include "uConsole.bas"
#include "uVersion.bas"
#include "uUtils.bas"
#include "uError.bas"
#include "uWindows.bas"
#include "uTextbox.bas"

#define test
#endif'test

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tViewfile -=-=-=-=-=-=-=-
declare function ViewArray(lines() as string,nlines as integer,bAutoColor as integer=false) as integer
declare function Viewfile(filename as string,nlines as integer=2048,bAutoColor as integer=false) as integer

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tViewfile -=-=-=-=-=-=-=-

namespace tViewfile
function init(iAction as integer) as integer
	return 0
end function
end namespace'tViewfile

function ViewArray(lines() as string,nlines as integer,bAutoColor as integer=false) as integer
	'dbgprint(offset)
	'dbgprint(nlines)
	'dbgprint(height)
	'dbgprint(tScreen.isGraphic)
	'uconsole.pressanykey
    dim as Integer height, pheight, xwidth, i, di
    dim as Integer offset, offsetx 
    dim as Integer iwid, longest 
    dim col(nlines) as short
    dim as string text
    dim as string key

   	if bAutoColor then 
	    for i=0 to nlines-1
	        col(i)=11
	        if left(lines(i),2)="==" then
	            col(i)=7
	            col(i-1)=14
	        elseif left(lines(i),1)="*" then 
	        	col(i)=14
	        endif
	    next
	endif

	if tScreen.isGraphic then tScreen.drawfx(8,8)
	'DbgPrint("dsx:"&tScreen.dsx &" dsy:"& tScreen.dsy)
	'DbgPrint("erw:"&tScreen.erw &" erh:"& tScreen.erh)

    if tScreen.isGraphic then
    	xWidth= tScreen.gtw -1
    	height= tScreen.gth -1
    else
	    xwidth=(width() and &hFFFF)		' width is easy.
		'xwidth -= 1						' print to col 1+ (0 to xwidth) 
	    height=(width() shr (4*4))		' gives screen/console height
	    if (height>25) then height=25	' limit console height to 25 (at least on windows)    	
    EndIf

   	pheight=height-1			' take off 1 line for instructions and we get the viewport
    if pheight>nlines then		' viewport-height is more than lines of text to show 
   		pheight=nlines
    EndIf

	'DbgPrint("width:"&xWidth &" height:"& height)
	'DbgPrint("offset:"& offset)
    

'	if tScreen.isGraphic then tScreen.drawfx(_fw1,_fh1)
    'set__color( 15,0)
    do
        cls
        set__color( 11,0)
        for i=0 to pheight-1
        	if i+offset>ubound(col) then exit for
            text= lines(i+offset)
            iwid=len(text)
            if iwid>longest then
            	longest=iwid
            EndIf
            text= mid(text,offsetx+1,xwidth)
            '
            if bAutoColor then set__color( col(i+offset),0)
            '
			if tScreen.isGraphic then
			    tScreen.draw2c(0,i,text)
			else
	            locate i+1,1
	            print text;
			endif
        next

	scroll_bar( offset, nlines, pheight, height, xwidth, 0, 14) 
	if tScreen.isGraphic then tScreen.drawfx(8,8)

        '
        key="Use Arrows and +/- to browse " & nlines & " lines. Enter to close: "

        set__color( 14,0)
        dim x as integer = (xwidth-len(key))\2+1
		if tScreen.isGraphic then
		    tScreen.draw2c(x,height,key)
			'DbgPrint("dsx:"&tScreen.dsx &" dsy:"& tScreen.dsy)
			'DbgPrint(""&x &" "& height &" "& key)
		else
	        locate height,x
        	print key; 
		endif
			
		'
		while true
	        key=uConsole.keyinput() '("12346789 ")'            key=keyin("12346789 ",1)
			i=0
			di=uConsole.getdirection(key)
	        if 	   di=7 then
	        	offset=0
	        	offsetx=0
	        	i=1
	        elseif di=1 then
	        	offset=nlines-pheight
	        	offsetx=0
	        	i=1
	        elseif di=2 then
	        	offset=offset+1
	        	i=1
	        elseif di=8 then
	        	offset=offset-1
	        	i=1
	        elseif di=4 then
	        	offsetx=offsetx-1
	        	i=1
	        elseif di=6 then
	        	offsetx=offsetx+1
	        	i=1
	        elseif uConsole.keyaccept(key,keyl_menup) then 
	        	offset=offset-(height-1)
	        	i=1
	        elseif uConsole.keyaccept(key,keyl_mendn) then 
	        	offset=offset+(height-1)
	        	i=1
	        elseif key=key__Ins then 
	        	offsetx=offsetx-(xwidth\2)
	        	i=1
	        elseif key=key__Del then 
	        	offsetx=offsetx+(xwidth\2)
	        	i=1
	        endif
			'
			'if offset>nlines then offset=nlines
	        if offset>nlines-height+1 then offset=nlines-height+1
	        if offset<0 then offset=0
	        if offsetx>longest-xwidth then offsetx=longest-xwidth
	        if (offsetx<0) or (xwidth>=longest) then offsetx=0
			'
			if (i>0) or uConsole.Closing<>0 or uConsole.keyonwards(key) then
				exit while
			EndIf
		wend
    loop until uConsole.Closing<>0 or uConsole.keyonwards(key)
    return 0
End Function


function Viewfile(filename as string,nlines as integer=2048,bAutoColor as integer=false) as integer
    dim as integer f
    dim as Integer c,lastspace
    dim lines(nlines) as string
    dim as string text
    '
    if tFile.Openinput(filename,f)>0 then
	    do
	        line input #f,lines(c)
	        c=c+1
	    loop until eof(f) or c>=nlines
	    tFile.Closefile(f)
    else 
    	tError.log("Viewfile:"+tFile.FileError)
    EndIf
    '
    ViewArray(Lines(),c,bAutoColor)
    return 0
end function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tViewfile -=-=-=-=-=-=-=-
	tModule.register("tViewfile",@tViewfile.init()) ',@tViewfile.load(),@tViewfile.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tViewfile -=-=-=-=-=-=-=-
#undef test
	#include "file.bi"

	ReplaceConsole(0)
	chdir exepath
	chdir ".."
	
	if not fileexists(tVersion.ErrorlogFilename()) then
		dim as Integer f,i
		assert(tFile.OpenLogfile(tVersion.ErrorlogFilename(),f)>0)
		for i = 1 to 30 
			print #f, pad(30," ") &i
		Next
		tFile.Closefile(f)
	EndIf
	
	Viewfile(tVersion.ErrorlogFilename())
	cls
	tScreen.y=50
	tScreen.res	
	Viewfile(tVersion.ErrorlogFilename())
		
#endif'test
