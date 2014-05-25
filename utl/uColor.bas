'uColor.
#include once "uDefines.bi"
DeclareDependencies()
#print "tColor test"
#include "file.bi"
#include "uUtils.bas"
#include "uDebug.bas"
#include "uScreen.bas"
#include "uWindows.bas"
DeclareDependenciesDone()

#ifndef __FILE_BI__
#print uColor.bas: late including file.bi
#include once "file.bi"
#endif

' Below are the 16 colors QBASIC uses
'
'    00 = black			'    08 = dark gray
'    01 = dark blue		'    09 = light blue
'    02 = dark green	'    10 = light green
'    03 = dark cyan		'    11 = light cyan
'    04 = dark red		'    12 = light red
'    05 = dark purple	'    13 = magenta
'    06 = orange brown	'    14 = yellow
'    07 = gray			'    15 = bright white 
'

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tColor -=-=-=-=-=-=-=-

Const c_red=12
Const c_gre=10
Const c_yel=14


namespace tColor
declare function set(fg As Short,bg As Short=0,visible As Byte=1) As Short	
declare function load_palette(filename as string="p.pal") as short
End Namespace

declare function set__color(fg As Short,bg As Short=0,visible As Byte=1) As Short
declare function text_to_html(text as string) as string

'declare function tColor
'declare function argb(c as short) As String
'declare function prt(imax as integer=15) as integer
'declare function test() as integer

#endif'head


#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tColor -=-=-=-=-=-=-=-


#Define RGBA_R( c ) ( CUInt( c ) Shr 16 And 255 )
#Define RGBA_G( c ) ( CUInt( c ) Shr  8 And 255 )
#Define RGBA_B( c ) ( CUInt( c )        And 255 )

#include "uColor.bi"

namespace tColor

Dim Shared palete(255) As UInteger

public function Init(iAction as integer) as integer
	dim as integer i,r,g,b
	restore DefaultPallete
	for i= 0 to 255
		read r,g,b
		palete(i)= (r shl 16)+(g shl 8)+(b)
	Next
	return 0
End function

function argb(c as short) As String
	return 	  RGBA_R(palete(c)) _
		&"," &RGBA_G(palete(c)) _
		&"," &RGBA_B(palete(c))
End Function


function set(fg As Short,bg As Short=0,visible As Byte=1) As Short
    Dim As UInteger r,g,b
    If fg>255 Or bg>255 Or fg<0 Or bg<0 Then Return 0
    
    _fgcolor_ = palete(fg)
    _bgcolor_ = palete(bg)

    If visible=1 Then
        tScreen.col(_fgcolor_,_bgcolor_)
    Else
        tScreen.col(_fgcolor_/2,_bgcolor_/2)
    EndIf
       
    If visible=0 Then
        r=RGBA_R(_fgcolor_)
        g=RGBA_G(_fgcolor_)
        b=RGBA_B(_fgcolor_)
        _fgcolor_=Rgb(r/2,g/2,b/2)

        r=RGBA_R(_bgcolor_)
        g=RGBA_G(_bgcolor_)
        b=RGBA_B(_bgcolor_)
        _bgcolor_=Rgb(r/2,g/2,b/2)
    EndIf
    Return 0
End function


function load_palette(filename as string="p.pal") as short
    dim as integer f
    dim as short i,j,k
    dim as string l,w(3)
    if not(fileexists(filename)) then
        color rgb(255,255,0),0
        print filename + " not found!"
        sleep
        end
    endif
    f=freefile
    open filename for input as #f
    line input #f,l
    line input #f,l
    line input #f,l 'First do not need to be checked
    do
        line input #f,l
        k=1
        w(1)=""
        w(2)=""
        w(3)=""
        for j=1 to len(l)
            w(k)=w(k)&mid(l,j,1)
            if mid(l,j,1)=" " then k+=1
        next
        tColor.palete(i)=RGB(val(w(1)),val(w(2)),val(w(3)))
'        DbgPrint( i &": " &l &" -> " +w(1) +":" +w(2) +":" +w(3) +" -> " &tColor.palete(i))
#ifdef gen_include
		'Print( i &": " &l &" -> " +w(1) +":" +w(2) +":" +w(3) +" -> " &tColor.palete(i))
		dim as String a= "DATA " +w(1) +"," +w(2) +"," +w(3) +"' " &i
		dim as integer f=fout
		Print a
		print #f, chr(9)+a ' &" -> " &tColor.palete(i))
#endif		
        i+=1
    loop until eof(f)
    close #f
    return 0
end function


end namespace


function set__color(fg As Short,bg As Short=0,visible As Byte=1) As Short
	return tColor.set(fg,bg,visible)
End Function

function text_to_html(text as string) as string
    dim as string t,w(1024)
    dim as short wcount,i,first,c
    for i=0 to len(text)
        if mid(text,i,1)="{" or mid(text,i,1)="|" then wcount+=1
        w(wcount)=w(wcount)&mid(text,i,1)
        if mid(text,i,1)=" " or mid(text,i,1)="|" or  mid(text,i,1)="}" then wcount+=1
    next

    for i=0 to wcount
        if w(i)="|" then w(i)="<br>"
        if Left(trim(w(i)),1)="{" and Right(trim(w(i)),1)="}" then
            c=numfromstr(w(i))
            if first=1 then
                w(i)="</span>"
            else
                w(i)=""
            endif
            w(i) +=html_color("rgb(" & tColor.argb(c) & ")")
            first=1
        endif
    next
    for i=0 to wcount
        t=t &w(i)
    next

    return t
end function


#ifndef head
	tModule.Register("tColor",@tColor.Init())
#endif		

#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tColor -=-=-=-=-=-=-=-
	tModule.register("tColor",@tColor.init()) ',@tColor.load(),@tColor.save())
#endif'main

'#ifdef test
'#print -=-=-=-=-=-=-=- TEST: tPalette -=-=-=-=-=-=-=-
''#if ( define(all) or define(head) or define(main) )
''#else
'#ifdef gen_include
'chdir exepath
'chdir ".."
'fout=freefile
'open "tPalette.bi" for output as #fout
'load_palette
'close #fout
'dim i as Integer
'for i = 1 to 255 
'Next
'Pressanykey
'#else
''load_palette()
'#endif		
'#endif'test

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tColor -=-=-=-=-=-=-=-
#undef test

function prt(imax as integer=15) as integer
	dim fg as Integer
'	tColor.set(15)
'	for fg = 15 to 0 step -1
'		? fg, tColor.argb(fg)
'	Next
	for fg = imax to 0 step -1
		tColor.set(fg)
		? "set__color( " &fg &",0)", tColor.argb(fg)
	Next
	sleep	
	set__color(15)
	return 0
End Function

function test() as integer
	? "test()"
	prt()
	
	tScreen.res()
	? "tScreen.res()"
	prt(72)
	
	return 0
	
	tScreen.set(1)
	? "tScreen.set(1)"
	prt()
	
	tScreen.set(0)
	? "tScreen.set(0)"
	prt()
	
	tScreen.set(1)
	? "tScreen.set(1)"
	prt()
	
	return 0
End Function

? test()

#endif'test
