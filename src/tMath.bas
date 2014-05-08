Type vector
        x As Integer
        y As Integer
        Declare Constructor(x As Integer, y As Integer)
End Type

Constructor vector (x As Integer, y As Integer)
        this.x = x
        this.y = y
End Constructor

Type _sym_matrix

        xm As Integer
        vmax As Integer
        vmin As Integer
        item As Integer Ptr

        Declare Function get_ind(x As Integer,y As Integer) As Integer
        Declare Function set_val(x As Integer,y As Integer, v As Integer) As Integer
        Declare Function get_val(x As Integer,y As Integer) As Integer
        Declare Property Val(xy As vector) As Integer
        Declare Property Val(xy As vector,v As Integer)

        Declare Constructor (ByVal size As Integer)
        Declare Destructor ()
End Type

Constructor _sym_matrix (ByVal size As Integer)
        xm = size
        item = New Integer[size * size]
End Constructor

Destructor _sym_matrix
        Delete[] item
End Destructor

Function _sym_matrix.get_ind(x As Integer, y As Integer) As Integer
        Dim i As Integer
        With This
                x+=1
                y+=1
                If x>xm Then x=xm
                If y>xm Then y=xm
                If x<1 Then x=1
                If y<1 Then y=1
                If x>y Then Swap x,y
                i=x+y*(y-1)/2
        End With
        Return i
End Function

Function _sym_matrix.set_val(x As Integer,y As Integer,v As Integer) As Integer
        Dim i As Integer
        i=this.get_ind(x,y)
        If v>this.vmax And this.vmax<>0 Then v=this.vmax
        If v<this.vmin Then v=this.vmin
        this.item[i]=v
        Return 0
End Function

Function _sym_matrix.get_val(x As Integer,y As Integer) As Integer
        Dim i As Integer
        i=this.get_ind(x,y)
        Return this.item[i]
End Function

Property _sym_matrix.Val(xy As vector) As Integer
        Return this.get_val(xy.x,xy.y)
End Property

Property _sym_matrix.Val(xy As vector,v As Integer)
        this.set_val(xy.x,xy.y,v)
End Property


function urn(min as short, max as short,mult as short,bonus as short) as short 
    dim as short values(1024),v,st,i,j,e,f,r
    if min>max then 
        st=-1
    else
        st=1
    endif
    for i=min to max step st
        e+=1
        for j=1 to e
            f+=1
            values(f)=i
        next
    next
    r=rnd_range(1,f)+bonus
    if r>f then r=f
    if r<1 then r=1
    return values(r)
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

Function round_str(i As Double,c As Short) As String
    Dim As String t
    Dim As Single j
    Dim As Short digits
    t=""&round_nr(i,c)
    If Instr(t,".")>0 Then 
        digits=Len(t)-Instr(t,".")
    Else
        t=t &"."
    EndIf
    If digits<c Then t= t &String(c-digits,"0")
    Return t
End Function

'



function find_high(list() as short,last as short, start as short=1) as short
    dim as short i,m,r
    for i=1 to last
        if list(i)>m then
            r=i
            m=list(i)
        endif
    next
    return r
end function

function find_low(list() as short,last as short,start as short=1) as short
    dim as short i,m,r
    m=32767
    for i=start to last
        if list(i)<m then
            r=i
            m=list(i)
        endif
    next
    return r
end function

function sub0(a as single,b as single) as single
    dim c as single
    c=a-b
    if c<0 then c=0
    return c
end function

function content(r as _rect,tile as short,map()as short) as integer
    dim as short con,x,y
    for x=r.x to r.x+r.w
      for y=r.y to r.y+r.h
          if map(x,y)<>tile then con=con+1
      next
    next
    return con
end function

function findrect(tile as short,map() as short,er as short=10,fi as short=60) as _rect
    dim as _rect best,current
    dim as short x,y,x2,y2,com,dx,dy,u,besta
    
    ' er = fehlerrate, up to er sqares may be something else
    ' fi = stop looking if one is larger than fi
    
    besta=15
    for x=0 to 60
        for y=0 to 20
            for x2=x+3 to 60
                for y2=y+3 to 20
                    current.x=x
                    current.y=y
                    current.w=x2-x
                    current.h=y2-y
                    if current.w*current.h>besta then
                        if map(current.x,current.y)=tile and  map(current.x+current.w,current.y)=tile and  map(current.x,current.y+current.h)=tile and  map(current.x+current.w,current.y+current.h)=tile then
                            if content(current,tile,map())<=er then 
                                best=current
                                besta=best.h*best.w
                                if besta>fi then exit for,for,for,for
                            endif
                        endif
                    endif
                next
            next
        next
    next
    return best
end function

function maximum(a as double,b as double) as double
    if a>b then return a
    if b>a then return b
    if a=b then return a
end function

function minimum(a as double,b as double) as double
    if a<b then return a
    if b<a then return b
    if a=b then return a
end function


function getany(possible() as short) as short
    dim r as short
    dim mat1(3,3) as short
    dim sam(9) as short
    dim a as short
    dim x as short
    dim y as short
    mat1(1,1)=7
    mat1(1,2)=8
    mat1(1,3)=9
    
    mat1(2,1)=4
    mat1(2,2)=0
    mat1(2,3)=6
    
    mat1(3,1)=1
    mat1(3,2)=2
    mat1(3,3)=3
    for x=1 to 3
        for y=1 to 3
            if possible(x,y)=0 then
                a=a+1
                sam(a)=mat1(x,y)
            endif
        next
    next
    if a>0 then
        r=sam(rnd_range(1,a))
    else
        r=0
    endif
    return r
end function




function nextpoint(byval start as _cords, byval target as _cords) as _cords
    dim as short dx,dy,d,x1,x2,y1,y2 
    x1=start.x
    y1=start.y
    d=abs(x1-x2)
    if abs(y1-y2)>d then d=abs(y1-y2)
    start.x=x1+(x2-x1)/d
    start.y=y1+(y2-y1)/d
    return start
end function


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


function nearest(byval c as _cords, byval b as _cords,rollover as byte=0) as single
    ' Moves B towards C, or C away from B
    dim direction as short
    if rollover=1 then
        if abs(c.x-b.x)>30 then swap c,b
    endif
    if c.x>b.x and c.y>b.y then direction=3
    if c.x>b.x and c.y=b.y then direction=6
    if c.x>b.x and c.y<b.y then direction=9
    
    if c.x=b.x and c.y>b.y then direction=2
    if c.x=b.x and c.y<b.y then direction=8
    
    if c.x<b.x and c.y=b.y then direction=4
    if c.x<b.x and c.y<b.y then direction=7
    if c.x<b.x and c.y>b.y then direction=1
            
    return direction
end function


function farthest(c as _cords, b as _cords) as single
    dim direction as short
    if c.x>b.x and c.y>b.y then direction=3
    if c.x>b.x and c.y=b.y then direction=6
    if c.x>b.x and c.y<b.y then direction=9
    
    if c.x=b.x and c.y>b.y then direction=8
    if c.x=b.x and c.y<b.y then direction=2
    
    if c.x<b.x and c.y=b.y then direction=4
    if c.x<b.x and c.y<b.y then direction=7
    if c.x<b.x and c.y>b.y then direction=1
    return direction
end function


function fill_rect(r as _rect,wall as short, floor as short,map() as short) as short
    dim as short x,y 
    for x=r.x to r.x+r.w
        for y=r.y to r.y+r.h
            
            if x=r.x or y=r.y or x=r.x+r.w or y=r.y+r.h then
                map(x,y)=wall
            else 
                map(x,y)=floor
            endif
        next
    next
    return 0
end function

function rndrectwall(r as _rect,d as short=5) as _cords
    dim p as _cords
    if d=5 then 
        do
            d=rnd_range(1,8)
            if d=4 then d=d+1
        loop until frac(d/2)=0
    endif
    if d=1 then
        p.x=r.x
        p.y=r.y+r.h
    endif
    if d=2 then 
        p.y=r.y+r.h
        p.x=rnd_range(r.x+1,r.x+r.w-2)
    endif 
    if d=3 then
        p.x=r.x+r.h
        p.y=r.y+r.h
    endif
    if d=4 then
        p.x=r.x
        p.y=rnd_range(r.y+1,r.y+r.h-2)
    endif
    if d=6 then
        p.x=r.x+r.w
        p.y=rnd_range(r.y+1,r.y+r.h-2)
    endif
    if d=7 then
        p.x=r.x
        p.y=r.y
    endif
    if d=8 then
        p.x=rnd_range(r.x+1,r.x+r.w-2)
        p.y=r.y
    endif
    if d=9 then
        p.x=r.x+r.w
        p.y=r.y+r.h
    endif
    return p
end function

