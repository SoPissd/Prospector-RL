'tColor.
'
'namespace: tColor

'
'
'defines:
'_tcol=33, _col=442, _icol=0, Init=6, argb=0, set=611, set__color=537,
', prt=0, test=41
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
'     -=-=-=-=-=-=-=- TEST: tColor -=-=-=-=-=-=-=-
#print "tColor test"
#include "tModule.bas"
#include "tDefines.bas"
#include "tScreen.bas"

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tColor -=-=-=-=-=-=-=-

declare function _col( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
declare function _icol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
declare function _tcol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger

namespace tColor
declare function set(fg As Short,bg As Short=0,visible As Byte=1) As Short	
End Namespace

declare function set__color(fg As Short,bg As Short=0,visible As Byte=1) As Short

'private function tColor
'private function argb(c as short) As String
'private function prt(imax as integer=15) as integer
'declare function test() as integer

#endif'head


#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tColor -=-=-=-=-=-=-=-

Dim Shared _fgcolor_ As UInteger
Dim Shared _bgcolor_ As UInteger

function _tcol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    Dim c As UInteger
    c=Color
    If src=0 Then
        Return dest
    Else
        Return _fgcolor_
    EndIf
End function


function _col( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    If src=0 Then
        Return _bgcolor_
    Else
        Return _fgcolor_
    EndIf
End function

function _icol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    'Itemcolor
    If src=0 Then
        Return Hiword(Color)
    Else
        Return Loword(Color)
    EndIf
End function

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

end namespace


function set__color(fg As Short,bg As Short=0,visible As Byte=1) As Short
	return tColor.set(fg,bg,visible)
End Function

#ifndef head
	tModule.Register("tColor",@tColor.Init())
#endif		

#if not (defined(types) or defined(head) or defined(main)) 'test

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

#endif


#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tColor -=-=-=-=-=-=-=-
	tModule.register("tColor",@tColor.init()) ',@tColor.load(),@tColor.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tColor -=-=-=-=-=-=-=-
#endif'test
