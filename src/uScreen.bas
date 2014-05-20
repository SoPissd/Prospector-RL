'tScreen.
'
'namespace: tScreen


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
'     -=-=-=-=-=-=-=- TEST: tScreen -=-=-=-=-=-=-=-
#undef intest
#include "fbGfx.bi"
#include "uDefines.bas"
#include "uModule.bas"
#include "uDefines.bas"

#define test
#endif'test
#ifndef FB
#print uScreen.bas: late including fbGfx.bi
#include "fbGfx.bi"
#endif

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Dim Shared _fgcolor_ 	As UInteger	'active rgb fg color
Dim Shared _bgcolor_ 	As UInteger	'active rgb bg color

Dim Shared FONT1 		As Any Ptr	'fonts for draw screen
Dim Shared FONT2 		As Any Ptr
Dim Shared TITLEFONT	As Any Ptr

type DrawStringCustom as Function( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tScreen -=-=-=-=-=-=-=-
'declare function  _col( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
'declare function _icol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
'declare function _tcol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger

'these are defined here since their locations are needed in existing draw string code.
'using declare for the definitions here leads to parsing errors.

'type DrawStringCustomFunctions:
function _tcol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    Dim c As UInteger= Color
    If src=0 Then Return dest Else Return _fgcolor_
End function

function _col( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    If src=0 Then Return _bgcolor_ Else Return _fgcolor_
End function

function _icol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    'Itemcolor
    If src=0 Then Return Hiword(Color) Else Return Loword(Color)
End function

#if __FB_Debug__
	sub DbgScreeninfo
	dim as Integer w,h,depth,bpp,pitch,rate
	dim as String driver 
	Screeninfo w,h,depth,bpp,pitch,rate,driver
	print "Screeninfo:"
	print "w, h, depth, bpp, pitch, rate, driver"
	write w,h,depth,bpp,pitch,rate,driver
	dim as Integer cw,ch
    ch=(width() shr (4*4)) ' gives screen/console height
    cw=(width() and &hFFFF)
	print "Console: x,y: ";cw;",";ch
	End Sub	
#else
	#define DbgScreeninfo
#endif

#endif'head


namespace tScreen

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tScreen -=-=-=-=-=-=-=-
Dim Shared as integer isGraphic=0		'decide on print vs draw-string

Dim Shared As integer x=800
Dim Shared As integer y=600

dim shared as integer dsx=1				'draw-scale x,y used with tScreen.Draw..
dim shared as integer dsy=1				'1== pixel resolution. set to font h/w to get a draw char-coordinate grid 

dim shared as integer gtw				'graphics terminal width
dim shared as integer gth		 		'computed to rows and cols when you set dsx/dsy with drawfx 

dim shared as integer erw				'graphic fonts might not fit 100%. 
dim shared as integer erh		 		'these shifts the origin to keep an even border


#ifndef GFX_WINDOWED
const as integer GFX_WINDOWED				= &h00
const as integer GFX_FULLSCREEN				= &h01
const as integer GFX_OPENGL					= &h02
const as integer GFX_NO_SWITCH				= &h04
const as integer GFX_NO_FRAME				= &h08
const as integer GFX_SHAPED_WINDOW			= &h10
const as integer GFX_ALWAYS_ON_TOP			= &h20
#endif

declare function mode(iMode as integer=0) As Short
declare function set(fg As Short=1,bg As Short=1) As Short
declare function res(flags as integer= GFX_WINDOWED ) As Short
declare function size(irows As Short=25,icols As Short=80) As Short

declare function loc(iRow As Short=0,iCol As Short=0,aText as string="") As Short
declare function xy(iCol As Short=0,iRow As Short=0,aText as string="") As Short

declare function col(fg As UInteger,bg As UInteger=0) As UInteger
declare function rbgcolor(sr As Short=255,sg As Short=255,sb As Short=255) As UInteger 'sets fg to rgb, bg to 0

declare sub pushpos()		'remember and restore console cursor.  with plenty stack.
declare sub poppos()

declare sub drawfx(df_x as integer=0,df_y as integer=0)
declare sub draws(ds_x as integer,ds_y as integer,ds_text as string,ds_font as string="",aProc as DrawStringCustom=null)
declare sub draw1c(ds_x as integer,ds_y as integer,ds_text as string) ' font1 @_col 
declare sub draw2c(ds_x as integer,ds_y as integer,ds_text as string) ' font2 @_col 


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tScreen -=-=-=-=-=-=-=-

function init(iAction as integer) as integer
    #ifdef __FB_WIN32__
        'setting the driver to gdi makes the window appear on top as needed for windows.						
        ScreenControl FB.SET_DRIVER_NAME, "GDI"
    #endif
    drawfx() 'compute initial values    
	return 0
end function

Dim Shared as UShort LastCol=0		'console position tracker 
Dim Shared as UShort LastRow=0		'console position tracker

'	

function res(flags as integer= GFX_WINDOWED ) As Short
    screenres x,y,16,2,flags
	isGraphic=1
	return 0
End Function

function mode(iMode as integer=0) As Short
    isGraphic= iMode<>0
    Screen iMode
	return 0
End Function

function set(fg As Short=1,bg As Short=1) As Short
    if isGraphic<>0 then Screenset fg,bg
	return 0
End Function

function col(fg As UInteger,bg As UInteger=0) As UInteger
    if isGraphic=0 then return 0
	color fg,bg
	_fgcolor_= fg
	_bgcolor_= bg	
	return fg
End Function

function rbgcolor(sr As Short=255,sg As Short=255,sb As Short=255) As UInteger 'sets fg to rgb, bg to 0
    if isGraphic= 0 then return 0 
	return col((sr shl 16)+(sg shl 8)+(sb),0)
End Function

function update() As Short
    if isGraphic<>0 then flip	
	return 0
End Function

function size(irows As Short=25,icols As Short=80) As Short
	width irows,icols
	return 0
End Function

function loc(iRow As Short=0,iCol As Short=0,aText as string="") As Short
	if iCol=0 and (isGraphic>0) then iCol=LastCol else LastCol=iCol
	if iRow=0 then iRow=CsrLin
	LastRow=iRow
	Locate iRow,iCol
	if aText<>"" then ? aText;
	return 0
End Function

function xy(iCol As Short=0,iRow As Short=0,aText as string="") As Short
	return loc(iRow,iCol,aText)	
End Function

'

dim Shared rowcol(20) as uinteger 

sub pushpos()
	rowcol(0) +=1
	if rowcol(0)<=ubound(rowcol) then
		'dim a as string= "pushpos " &csrlin &"," &pos()
		rowcol(rowcol(0))= csrlin shl 16 + pos()
		'LogOut(a)
	EndIf
End Sub

sub poppos()
	if rowcol(0)>0 then
		'LogOut("poppos " & (rowcol(rowcol(0)) shr 16) & "," & (rowcol(rowcol(0)) and cast(LongInt,&hFFFF)))
		loc((rowcol(rowcol(0)) shr 16), (rowcol(rowcol(0)) and &hFFFF))
		rowcol(0) -=1
	EndIf
End Sub

'
'
'

	'Draw String(ds_x,ds_y),ds_text,,ds_font,custom,@ds_col
	'[buffer,] [STEP] (x, y), text [,color [, font [, method [, (alpha|blender) [, parameter] ] ] ] ]
	'(x, y), text [,color [, font [, method [, (alpha|blender) [, parameter] ] ] ] ]

sub drawfx(df_x as integer=0,df_y as integer=0)
	dsx= df_x: if dsx<1 then dsx=1
	dsy= df_y: if dsy<1 then dsy=1
	
	gtw=x\dsx			'we can fit this many chars integrally
	gth=y\dsy
	
	erw=x- gtw*dsx 		'yet there may remain a fractional space in our fix-char matrix
	erh=x- gtw*dsx 		'we'll keep track of it here and adjust below
	
	erw \= 2			'first though, lets half the error and distribute it all around 
	erh \= 2
	
End Sub

sub draws(ds_x as integer,ds_y as integer,ds_text as string,ds_font as string="",aProc as DrawStringCustom=null)
	'Draw String ( ds_x , ds_y ), ds_text
	if ds_font="" then
		Draw String (erw+ds_x*dsx,erh+ds_y*dsy),	ds_text
	else
		Draw String (erw+ds_x*dsx,erh+ds_y*dsy),	ds_text,,ds_font,custom,@aProc
	EndIf
End sub

sub draw1c(ds_x as integer,ds_y as integer,ds_text as string)
	if FONT2=null then
		Draw String (erw+ds_x*dsx,erh+ds_y*dsy),	ds_text
	else
		Draw String (erw+ds_x*dsx,erh+ds_y*dsy),	ds_text,,FONT2,custom,@_col
	EndIf
End sub

sub draw2c(ds_x as integer,ds_y as integer,ds_text as string)
	if FONT2=null then
		Draw String (erw+ds_x*dsx,erh+ds_y*dsy),	ds_text
	else
		Draw String (erw+ds_x*dsx,erh+ds_y*dsy),	ds_text,,FONT2,custom,@_col
	EndIf
End sub

sub drawtt(ds_x as integer,ds_y as integer,ds_text as string)	
	if TITLEFONT=null then
		Draw String (erw+ds_x*dsx,erh+ds_y*dsy),	ds_text
	else
		Draw String (erw+ds_x*dsx,erh+ds_y*dsy),	ds_text,,TITLEFONT,custom,@_tcol
	EndIf
End sub

end namespace
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tScreen -=-=-=-=-=-=-=-
	tModule.register("tScreen",@tScreen.init()) ',@tScreen.load(),@tScreen.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tScreen -=-=-=-=-=-=-=-
#undef test
#include "file.bi"
#include "uFile.bas"
#include "uColor.bas"
#include "uConsole.bas"
#include "uWindows.bas" 'auto-close

tScreen.res
DbgScreeninfo				
tScreen.drawfx( 10,10)
?
? tScreen.dsx,tScreen.dsy
? tScreen.gtw,tScreen.gth
? tScreen.erw,tScreen.erh

set__color(14,1):				tScreen.draws( 05,21,"yellow on light blue")
set__color(14,1):				tScreen.draws( 05,22, hex(_fgcolor_)+" "+hex(_bgcolor_))

Width 80, 25
Locate 1,1: Color 14, 9 : Print "yellow text on bg 9"
   ''  the color nightmare continues. no bg color is set


tScreen.rbgcolor(255,255,0):	tScreen.draws( 05,20,"OK!")
tScreen.rbgcolor(0,255,255):	tScreen.draws( 10,30,"OK!")
tScreen.rbgcolor(255,255,255):	tScreen.draws( 10,31,"OK!")
'tScreen.rbgcolor(255,0,255):	tScreen.draws( 15,100,"OK!")
'tScreen.rbgcolor(255,0,0):	tScreen.draws( 40,20,"OK!")
'tScreen.rbgcolor(0,255,0):	tScreen.draws( 50,60,"OK!")
'tScreen.rbgcolor(0,0,255):	tScreen.draws( 100,100,"OK!")
tScreen.xy(10,44)
uConsole.pressanykey

#endif'test
