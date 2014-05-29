'tMath.
#include once "uDefines.bi"
DeclareDependencies()
#include "fbGfx.bi"
#include "uUtils.bas"
#include "uDebug.bas"
#include "uRng.bas"
#include "uiScreen.bas"
#include "uiColor.bas"
#include "uiConsole.bas"
#include "adtCoords.bas"
#define test 
#endif'DeclareDependencies()
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
'Const Pi As Double = 3.141592653589793
'Const Eu As Double = 2.718281828459045

'Type vector
'        x As Integer
'        y As Integer
'        Declare Constructor(x As Integer, y As Integer)
'End Type
'
'Type _sym_matrix
'        xm As Integer
'        vmax As Integer
'        vmin As Integer
'        item As Integer Ptr
'
'        Declare function get_ind(x As Integer,y As Integer) As Integer
'        Declare function set_val(x As Integer,y As Integer, v As Integer) As Integer
'        Declare function get_val(x As Integer,y As Integer) As Integer
'        Declare Property Val(xy As vector) As Integer
'        Declare Property Val(xy As vector,v As Integer)
'
'        Declare Constructor (ByVal size As Integer)
'        Declare Destructor ()
'End Type

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tMath -=-=-=-=-=-=-=-

declare function urn(sMin as short, sMax as short,mult as short,bonus as short) as short  
declare function round_nr(i as single,c as short) as single
declare function round_str(i As Double,c As Short) As String

declare function find_high(list() as short,last as short, start as short=1) as short
declare function find_low(list() as short,last as short,start as short=1) as short

declare function maximum(a as double,b as double) as double
declare function minimum(a as double,b as double) as double

declare function C_to_F(c as single) as single

declare function sub0(a as single,b as single) as single

'declare function getany(possible() as short) as short
'declare function nextpoint(byval start as _cords, byval target as _cords) as _cords

declare function line_in_points(b as _cords,c as _cords,p() as _cords) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tMath -=-=-=-=-=-=-=-

namespace tMath
function init(iAction as integer) as integer
	return 0
end function
end namespace'tMath

''
'
'Constructor vector (x As Integer, y As Integer)
'        this.x = x
'        this.y = y
'End Constructor
'
''
'
'Constructor _sym_matrix (ByVal size As Integer)
'        xm = size
'        item = New Integer[size * size]
'End Constructor
'
'Destructor _sym_matrix
'        Delete[] item
'End Destructor
'
'function _sym_matrix.get_ind(x As Integer, y As Integer) As Integer
'        Dim i As Integer
'        With This
'                x+=1
'                y+=1
'                If x>xm Then x=xm
'                If y>xm Then y=xm
'                If x<1 Then x=1
'                If y<1 Then y=1
'                If x>y Then Swap x,y
'                i=x+y*(y-1)/2
'        End With
'        Return i
'End function
'
'function _sym_matrix.set_val(x As Integer,y As Integer,v As Integer) As Integer
'        Dim i As Integer
'        i=this.get_ind(x,y)
'        If v>this.vmax And this.vmax<>0 Then v=this.vmax
'        If v<this.vmin Then v=this.vmin
'        this.item[i]=v
'        Return 0
'End function
'
'function _sym_matrix.get_val(x As Integer,y As Integer) As Integer
'        Dim i As Integer
'        i=this.get_ind(x,y)
'        Return this.item[i]
'End function
'
'Property _sym_matrix.Val(xy As vector) As Integer
'        Return this.get_val(xy.x,xy.y)
'End Property
'
'Property _sym_matrix.Val(xy As vector,v As Integer)
'        this.set_val(xy.x,xy.y,v)
'End Property


function urn(sMin as short, sMax as short, mult as short, bonus as short) as short 
	'returns a weighted random value. sMin is rare, sMax is abs(sMax-sMin) times more common!
    dim as short st,i,j,e,f,r
    r= abs(sMax-sMin)+1 				'get the range, e.g -10,-1 ==10
    r= (r+1) *r \2						'precompute number of elements
    dim as short values(r)				'and make room for them

    if sMin>sMax then st=-1 else st=1	'pick a direction    
    for i=sMin to sMax step st			'1 entry for sMin
        e+=1							'2 entries for the next
        for j=1 to e					'3 entries .. .. 
            f+=1						' .. the most entries for sMax. at the end of the array.
            values(f)=i
        next
    next

 	'for i = 1 to f:	? i,values(i): Next
    
    i=rnd_range(1,f)+bonus				'shift a random of that range towards sMax/the end value.
    if i>f then i=f						'keep it bounded 
    if i<1 then i=1
    return values(i)					'and return the chosen value
end function

'
    
function round_nr(i as single,c as short) as single
    i=i*(10^c)
    i=int(i)
    i=i/(10^c)
    return i
end function

function C_to_F(c as single) as single
    return round_nr(c*1.8+32,1)
end function

function round_str(i As Double,c As Short) As String
    Dim As String t
    Dim As Single j
    Dim As Short digits
    t=""&round_nr(i,c)
    If Instr(t,".")>0 Then 
        digits=Len(t)-Instr(t,".")
    Else
        t=t &"."
    EndIf
    If digits<c Then t &= String(c-digits,"0")
    Return t
End function

'

function find_high(list() as short,last as short, start as short=1) as short
    dim as short i,m,r
    assert(start>=lbound(list))
    assert(last<=ubound(list))
    r=start
    m=list(r) 
    for i=start+1 to last
        if list(i)>m then
            r=i
            m=list(i)
        endif
    next
    return r
end function

function find_low(list() as short,last as short,start as short=1) as short
    dim as short i,m,r
    assert(start>=lbound(list))
    assert(last<=ubound(list))
    r=start
    m=list(r) 
    for i=start+1 to last
        if list(i)<m then
            r=i
            m=list(i)
        endif
    next
    return r
end function

function sub0(a as single,b as single) as single
    dim c as single= a-b
    if c<0 then return 0 else return c
end function

function maximum(a as double,b as double) as double
    if a>=b then return a else return b
end function

function minimum(a as double,b as double) as double
    if a<=b then return a else return b
end function


'function getany(possible() as short) as short
'    dim r as short
'    dim mat1(3,3) as short
'    dim sam(9) as short
'    dim a as short
'    dim x as short
'    dim y as short
'
'    mat1(1,1)=7
'    mat1(1,2)=8
'    mat1(1,3)=9
'    
'    mat1(2,1)=4
'    mat1(2,2)=0
'    mat1(2,3)=6
'    
'    mat1(3,1)=1
'    mat1(3,2)=2
'    mat1(3,3)=3
'
'    for x=1 to 3
'        for y=1 to 3
'            if possible(x,y)=0 then
'                a=a+1
'                sam(a)=mat1(x,y)
'            endif
'        next
'    next
'
'    if a>0 then return sam(rnd_range(1,a))
'    return 0
'end function


'function nextpoint(byval start as _cords, byval target as _cords) as _cords
'    dim as short dx,dy,d,x1,x2,y1,y2 
'    x1=start.x
'    y1=start.y
'    d=abs(x1-x2)
'    if abs(y1-y2)>d then d=abs(y1-y2)
'    start.x=x1+(x2-x1)/d
'    start.y=y1+(y2-y1)/d
'    return start
'end function


function line_in_points(b as _cords,c as _cords,p() as _cords) as short
    dim last as short
    dim as single px,py
    dim deltax as single
    dim deltay as single
    dim numtiles as single
    dim l as single
    dim  as short result
    dim text as string
    dim as short co,i
    Dim As Integer d, dinc1, dinc2
    Dim As Integer x, xinc1, xinc2
    Dim As Integer y, yinc1, yinc2
    
    deltax = Abs(c.x - b.x)
    deltay = Abs(c.y - b.y)
    If deltax >= deltay Then
        numtiles = deltax + 1
        d = (2 * deltay) - deltax
        dinc1 = deltay Shl 1
        dinc2 = (deltay - deltax) Shl 1
        xinc1 = 1
        xinc2 = 1
        yinc1 = 0
        yinc2 = 1
    Else
        numtiles = deltay + 1
        d = (2 * deltax) - deltay
        dinc1 = deltax Shl 1
        dinc2 = (deltax - deltay) Shl 1
        xinc1 = 0
        xinc2 = 1
        yinc1 = 1
        yinc2 = 1
    End If

    If c.x > b.x Then
        xinc1 = - xinc1
        xinc2 = - xinc2
    End If
   
    If c.y > b.y Then
        yinc1 = - yinc1
        yinc2 = - yinc2
    End If

    x = c.x
    y = c.y
    result=-1
    For i = 1 To numtiles
        
        If d < 0 Then
          d = d + dinc1
          x = x + xinc1
          y = y + yinc1
        Else
          d = d + dinc2
          x = x + xinc2
          y = y + yinc2
        End If
        last+=1
        p(last).x=x
        p(last).y=y
    next
    
    return last
end function


#endif'main
#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tMath -=-=-=-=-=-=-=-
	tModule.register("tMath",@tMath.init()) ',@tMath.load(),@tMath.save())
#endif'main
#if (defined(test) or defined(registerTests))
#print -=-=-=-=-=-=-=- TEST:  -=-=-=-=-=-=-=-

	namespace tMath

	sub Mathtest()
		? "urn(sMin as short, sMax as short, mult as short, bonus as short) as short"
		? "urn(sMinFewest as short, sMaxMost as short, , malus as short) as short"
'		? "urn(1,10,0,0) = "& urn(1,10,0,0)
		? "urn(10,1,0,0) = "& urn(1,-2,0,0)
	End Sub

	end namespace'tMath
	
	#ifdef test
		tMath.Mathtest()
		'? "sleep": sleep
	#else
		tModule.registertest("uMath",@tMath.Mathtest())
	#endif'test
#endif'test
