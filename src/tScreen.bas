'tScreen

namespace tScreen

#ifndef GFX_WINDOWED
const as integer GFX_WINDOWED				= &h00
const as integer GFX_FULLSCREEN				= &h01
const as integer GFX_OPENGL					= &h02
const as integer GFX_NO_SWITCH				= &h04
const as integer GFX_NO_FRAME				= &h08
const as integer GFX_SHAPED_WINDOW			= &h10
const as integer GFX_ALWAYS_ON_TOP			= &h20
#endif

Dim Shared as UShort Enabled=0
Dim Shared as UShort LastCol=0
Dim Shared as UShort LastRow=0

Dim Shared As UShort x=800
Dim Shared As UShort y=600

function mode(iMode as integer=0) As Short
    Enabled= iMode<>0
    Screen iMode
	return 0
End Function

function set(fg As Short=1,bg As Short=1) As Short
    if Enabled<>0 then Screenset fg,bg
	return 0
End Function

function loc(iRow As Short=0,iCol As Short=0) As Short
	if iCol=0 and (Enabled>0) then iCol=LastCol else LastCol=iCol
	if iRow=0 then iRow=CsrLin
	LastRow=iRow
	Locate iRow,iCol
	return 0
End Function

function res(flags as integer= GFX_WINDOWED ) As Short
    screenres x,y,16,2,flags
	Enabled=1
	return 0
End Function

function size(irows As Short=25,icols As Short=80) As Short
	width irows,icols
	return 0
End Function

function col(fg As Short,bg As Short=0) As Short
    if Enabled<>0 then color fg,bg	
	return 0
End Function

function rgbcol(r As Short,g As Short,b As Short) As integer
    if Enabled= 0 then return 0 
	dim i as Integer
	i=(r shl 16)+(g shl 8)+(b)
	color i,0	
	return i
End Function

end namespace
