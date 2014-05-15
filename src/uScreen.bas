'tScreen.
'
'namespace: tScreen

'
'
'defines:
'mode=24, set=613, loc=199, res=105, size=25, col=315, rgbcol=0
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
'     -=-=-=-=-=-=-=- TEST: tScreen -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test

namespace tScreen

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tScreen -=-=-=-=-=-=-=-

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
declare function loc(iRow As Short=0,iCol As Short=0,aText as string="") As Short
declare function xy(iCol As Short=0,iRow As Short=0,aText as string="") As Short
declare function res(flags as integer= GFX_WINDOWED ) As Short
declare function size(irows As Short=25,icols As Short=80) As Short
declare function col(fg As Short,bg As Short=0) As Short
declare sub pushpos()
declare sub poppos()

'private function rgbcol(r As Short,g As Short,b As Short) As integer

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tScreen -=-=-=-=-=-=-=-

function init(iAction as integer) as integer
	return 0
end function

Dim Shared as UShort isGraphic=0
Dim Shared as UShort LastCol=0
Dim Shared as UShort LastRow=0

Dim Shared As UShort x=800
Dim Shared As UShort y=600

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

function col(fg As Short,bg As Short=0) As Short
    if isGraphic<>0 then color fg,bg	
	return 0
End Function

function rgbcol(r As Short,g As Short,b As Short) As integer
    if isGraphic= 0 then return 0 
	dim i as Integer
	i=(r shl 16)+(g shl 8)+(b)
	color i,0	
	return i
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

end namespace
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tScreen -=-=-=-=-=-=-=-
	tModule.register("tScreen",@tScreen.init()) ',@tScreen.load(),@tScreen.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tScreen -=-=-=-=-=-=-=-
#endif'test
