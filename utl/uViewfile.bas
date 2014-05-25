#print "tViewfile"
'tViewfile.
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
#include "uWindows.bas"
#include "uTextbox.bas"
DeclareDependenciesDone()
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tViewfile -=-=-=-=-=-=-=-
declare function ViewArray(lines() as string,nlines as integer,bScrollbar as integer=true,bAutoColor as integer=false) as integer
declare function Viewfile(filename as string,nlines as integer=2048,bScrollbar as integer=true,bAutoColor as integer=false) as integer

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tViewfile -=-=-=-=-=-=-=-

namespace tViewfile
function init(iAction as integer) as integer
	return 0
end function
end namespace'tViewfile

function ViewArray(lines() as string,nlines as integer,bScrollbar as integer=true,bAutoColor as integer=false) as integer
	'dbgprint(offset)
	'dbgprint(nlines)
	'dbgprint(height)
	'dbgprint(tScreen.isGraphic)
	'uconsole.pressanykey
	dim a as tScroller
    dim as Integer i, di
    dim as Integer iwid 
    dim as short  col(nlines)
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

	'DbgPrint("dsx:"&tScreen.dsx &" dsy:"& tScreen.dsy)
	'DbgPrint("erw:"&tScreen.erw &" erh:"& tScreen.erh)

	a.init(nlines,bScrollbar)


	'DbgPrint("width:"&xWidth &" height:"& height)
	'DbgPrint("offset:"& offset)    

    'set__color( 15,0)
    	
    do
        cls
        set__color( 11,0)
        for i=0 to a.pheight-1
        	if i+a.offset>ubound(col) then exit for
            text= lines(i+a.offset)
            iwid=len(text)
            if iwid>a.longestline then
            	a.longestline=iwid
            EndIf
            text= mid(text,a.offsetx+1,a.xwidth)
            '
            if bAutoColor then set__color( col(i+a.offset),0)
            '
			if tScreen.isGraphic then
			    tScreen.draw2c(1,i+1,text)
			else
				tScreen.xy(1,i+1,text)
			endif
        next

		if bScrollbar then scroll_bar( a.offset, a.nlines, a.pheight, a.height, a.xwidth, 1, 14)		

        '
        key="Use Arrows and +/- to browse " & nlines & " lines. Enter to close: "

        set__color( 14,0)
        dim x as integer = (a.xwidth-len(key))\2+1
        if x<1 then x=1
		if tScreen.isGraphic then
		    tScreen.draw2c(x,a.height,key)
			'DbgPrint("dsx:"&tScreen.dsx &" dsy:"& tScreen.dsy)
			'DbgPrint(""&x &" "& height &" "& key)
		else
			tScreen.xy(x,a.height,key) 
		endif
		
    loop until uConsole.Closing<>0 or uConsole.keyonwards(a.GetKey())
    return 0
End Function
			


function Viewfile(filename as string,nlines as integer=2048,bScrollbar as integer=true,bAutoColor as integer=false) as integer
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
    ViewArray(Lines(),c,bScrollbar,bAutoColor)
    return 0
end function


#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tViewfile -=-=-=-=-=-=-=-
	tModule.register("tViewfile",@tViewfile.init()) ',@tViewfile.load(),@tViewfile.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tViewfile -=-=-=-=-=-=-=-
	#undef test
	#include "file.bi"
	#define test
#endif'test

#if (defined(test) or defined(testload))
#print -=-=-=-=-=-=-=- TEST:  -=-=-=-=-=-=-=-

	namespace tViewfile

	sub Viewfiletest()
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
		tScreen.x=200
		tScreen.y=50
		tScreen.res()
		'
		DbgPrint("dsx:"&tScreen.dsx &" dsy:"& tScreen.dsy)
		
		Viewfile(tVersion.ErrorlogFilename())
	End Sub

	end namespace'tViewfile
	
	#ifdef test
		tViewfile.Viewfiletest()
		'? "sleep": sleep
	#else
		tModule.registertest("tViewfile",@tViewfile.Viewfiletest())
	#endif'test
#endif'test