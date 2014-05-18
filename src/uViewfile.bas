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
#include "file.bi"
#include "uFile.bas"
#include "uColor.bas"
#include "uConsole.bas"
#include "uVersion.bas"
#include "uUtils.bas"
#include "uError.bas"

#define test
#endif'test

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tViewfile -=-=-=-=-=-=-=-
declare function ViewArray(lines() as string,nlines as integer) as integer
declare function Viewfile(filename as string,nlines as integer=2048) as integer

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tViewfile -=-=-=-=-=-=-=-

namespace tViewfile
function init(iAction as integer) as integer
	return 0
end function
end namespace'tViewfile

function ViewArray(lines() as string,nlines as integer) as integer
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
   
    for i=1 to nlines
        col(i)=11
        if left(lines(i),2)="==" then
            col(i)=7
            col(i-1)=14
        endif
        'if left(lines(a),1)="*" then col(a)=14
    next
    
    xwidth=(width() and &hFFFF)	' width is easy.
    height=(width() shr (4*4))	' gives screen/console height
    if (tScreen.isGraphic=0) and (height>25) then height=25	' limit console height to 25 (at least on windows)
   	pheight=height-1			' take off 1 line for instructions and we get the viewport
    if pheight>nlines then		' viewport-height is more than lines of text to show 
   		pheight=nlines
    EndIf
    
    'set__color( 15,0)
    do
        cls
        set__color( 11,0)
        for i=0 to pheight-1
        	if i+offset>ubound(col) then exit for
            locate i+1,1
            set__color( col(i+offset),0)
            text= lines(i+offset)
            iwid=len(text)
            if iwid>longest then
            	longest=iwid
            EndIf
            text= mid(text,offsetx+1,xwidth)
            print text;
        next
        '
        set__color( 14,0)
        key="Use Arrows and +/- to browse " & nlines & " lines. Enter to close: "
        locate height,(xwidth-len(key))\2+1
        print key; 
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
	        if offset>=nlines-height then offset=nlines-height
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


function Viewfile(filename as string,nlines as integer=2048) as integer
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
    ViewArray(Lines(),c)
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
	Viewfile(tVersion.ErrorlogFilename())	
#endif'test
