'tUtils
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
'            DbgPrint(word(i))
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
End function

function stripFileExtension(text as string, delim as string=".") As String 
	dim as Integer i = Instrrev(text,delim)
	if i=0 then return text
	return left(text,i-1)
End function

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


function credits(cr As Integer) As String
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
End function


function lev_minimum( a As Integer, b As Integer, c As Integer ) As Integer
	var i = a
	If (b<i) Then i = b
	If (c<i) Then i = c
	Return i
End function

function fuzzymatch( s As String, t As String ) As single
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
End function


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


public function Texttofile(text as string) as string
	
    dim a as short
    dim iHead as short
    dim outtext as string
    outtext="<p>"
    for a=0 to len(text)
        if mid(text,a,1)="|" or mid(text,a,1)="{" then
            if mid(text,a,1)="|" then
                if iHead=1 then
                    outtext=outtext &"</b>"
                    iHead=2
                endif
                if iHead=0 then
                    outtext=outtext &"<b>"
                    iHead=1
                endif
                outtext=outtext &"<br>"'chr(13)& chr(10)
            endif
            if mid(text,a,1)="{" then a=a+3
        else
            outtext=outtext &mid(text,a,1)
        endif
    next
    outtext=outtext &"</p>"
    return outtext
end function


'

function screenshot_nextfilename(fname as String, ext as String, force as short) as String
	' use numbered screenshots after the first one
	if force or not fileexists(fname+ext) then return fname+ext
	dim as short i=0
	dim as String a,b
	b="000"
	do
		i +=1
		a = ""&i
		a = left(b,len(b)-len(a))+a
		a = fname + "-" + a + ext
	Loop until not fileexists(a)
	return a
End function


function screenshot(a as short) as short
    savepng( screenshot_nextfilename("summary/" + tVersion.Gamedesig, ".png", 0), 0, 1) 'player.desig
    return 0
end function

