'tUtils

Function _tcol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    Dim c As UInteger
    c=Color
    If src=0 Then
        Return dest
    Else
        Return _fgcolor_
    EndIf
End Function

Declare Function _col( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger

Function _col( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    If src=0 Then
        Return _bgcolor_
    Else
        Return _fgcolor_
    EndIf
End Function

Declare Function _icol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger

Function _icol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    'Itemcolor
    If src=0 Then
        Return Hiword(Color)
    Else
        Return Loword(Color)
    EndIf
End Function

Declare Function factionadd(a As Short,b As Short, add As Short) As Short

#Define RGBA_R( c ) ( CUInt( c ) Shr 16 And 255 )
#Define RGBA_G( c ) ( CUInt( c ) Shr  8 And 255 )
#Define RGBA_B( c ) ( CUInt( c )        And 255 )

Function set__color(fg As Short,bg As Short,visible As Byte=1) As Short
    Dim As UInteger r,g,b
    If fg>255 Or bg>255 Or fg<0 Or bg<0 Then Return 0
    If visible=1 Then
        Color palette_(fg),palette_(bg)
    Else
        Color palette_(fg)/2,palette_(bg)/2
    EndIf
    _fgcolor_=palette_(fg)
    _bgcolor_=palette_(bg)
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
End Function



'
'

function string_towords(word() as string, s as string, break as string, punct as short=0) as short
    dim as short i,a
    'Starts with 0,
    for a=0 to ubound(word)
        word(a)=""
    next
    for a=1 to len(s)
        if i>ubound(word) then
            redim word(i)
        endif
        if mid(s,a,1)=break then
            DbgPrint(word(i))
            i+=1
        else
            if punct=1 and (mid(s,a,1)="." or mid(s,a,1)=",") then
                i+=1
                word(i)=word(i)&mid(s,a,1)
            else
                word(i)=word(i)&mid(s,a,1)
            endif
        endif
    next
    return i
end function


'

function numfromstr(t as string) as short
    dim as short a
    dim as string t2
    for a=1 to len(t)
        if val(mid(t,a,1))<>0 or (mid(t,a,1))="0" then t2=t2 &mid(t,a,1)
    next
    return val(t2)
end function

function lastword(text as string, delim as string, capacity as short=29) As String
	Dim As String w(capacity)
	return w(string_towords(w(),text,delim))
End Function

function stripFileExtension(text as string, delim as string=".") As String 
	dim as Integer i = Instrrev(text,delim)
	if i=0 then return text
	return left(text,i-1)
End Function

'



function first_lc(t as string) as string
    return lcase(left(t,1))&right(t,len(t)-1)
end function

function first_uc(t as string) as string
    return Ucase(left(t,1))&right(t,len(t)-1)
end function



function add_a_or_an(t as string,beginning as short) as string
    dim as short i
    dim as string t2,t3
    i=asc(t,1)
    t2=ucase(chr(i))
    if beginning=1 then
        if t2="A" or t2="I" or t2="E" or t2="O" or t2="U" then
            t3="An"
        else
            t3="A"
        endif
    else
        if t2="A" or t2="I" or t2="E" or t2="O" or t2="U" then
            t3="an"
        else
            t3="a"
        endif
    endif
    return t3 &" "&t
end function



Function credits(cr As Integer) As String
    Dim As String t,r,z(12)
    Dim As Single fra,tenmillion
    Dim  As Integer b=1000000
    Dim As Byte c,l,i
    For i=0 To 12
        
    Next
    t="" &Abs(Int(cr))

    For b=1 To Len(t)
        z(b)=Mid(t,b,1)
    Next
    l=Len(t)
    t=""
    For b=1 To l
        t=t &z(b)
        If l-b=3 Or l-b=6 Or l-b=9 Or l-b=12 Then 
            t=t &","
        EndIf
    Next
    If cr<0 Then t="-"&t
    Return t
End Function


Function lev_minimum( a As Integer, b As Integer, c As Integer ) As Integer
	var min = a
	If (b<min) Then min = b
	If (c<min) Then min = c
	Return min
End Function

Function fuzzymatch( s As String, t As String ) As single
	dim as string dic
	Dim As Integer k, i, j, n, m, cost
	dim as single dis
	Dim As Integer Ptr d
	dim as short  f
    f=freefile
    open "data/dictionary.txt" for input as #f
    while not eof(f)
        line input #f,dic
        if ucase(trim(t))=ucase(trim(dic)) then t=""
    wend
    close f
	s=trim(s)
	t=trim(t)
	n = Len(s)
	m = Len(t)
	If (n <> 0) And (m <> 0) Then
	d = allocate( sizeof(Integer) * (m+1) * (n+1) )
    m += 1
    n += 1
    k = 0
    While k < n
    	d[k]=k
        k += 1
    Wend

   k = 0
   While k < m
      d[k*n]=k
      k += 1
   Wend

   i = 1
   While i < n
      j = 1

      While j<m
         If (s[i-1] = t[j-1]) Then
            cost = 0

         Else
            cost = 1

         End If

         d[j*n+i] = lev_minimum(d[(j-1)*n+i]+1, d[j*n+i-1]+1, d[(j-1)*n+i-1]+cost)

         j += 1
      Wend

      i += 1
   Wend

   dis = d[n*m-1]
   deallocate (d)
    if n>m then 
        dis=dis/n
    else
        dis=dis/m
    endif
   Return dis
	Else
   Return -1
End If
End Function


function roman(i as integer) as string
    select case i
    case 1
        return "I"
    case 2
        return "II"
    case 3
        return "III"
    case 4
        return "IV"
    case 5
        return "V"
    case 6
        return "VI"
    end select
end function


