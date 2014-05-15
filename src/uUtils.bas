'tUtils.
'
'defines:
'string_towords=5, numfromstr=1, lastword=2, stripFileExtension=2,
', first_lc=1, first_uc=1, add_a_or_an=56, credits=134, lev_minimum=0,
', fuzzymatch=0, roman=5, Texttofile=0, screenshot_nextfilename=0,
', screenshot=12
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
'     -=-=-=-=-=-=-=- TEST: tUtils -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tUtils -=-=-=-=-=-=-=-

declare function string_towords(word() as string, s as string, break as string, punct as short=0) as short
declare function numfromstr(t as string) as short
declare function lastword(text as string, delim as string, capacity as short=29) As String
declare function stripFileExtension(text as string, delim as string=".") As String 
declare function first_lc(t as string) as string
declare function first_uc(t as string) as string
declare function roman(i as integer) as string

declare function html_color(c as string, indent as short=0, wid as short=0) as string
declare function text_to_html(text as string) as string

'private function Texttofile(text as string) as string
'private function lev_minimum( a As Integer, b As Integer, c As Integer ) As Integer
'private function fuzzymatch( s As String, t As String ) As single

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tUtils -=-=-=-=-=-=-=-

namespace tUtils
function init(iAction as integer) as integer
	return 0
end function
end namespace'tUtils


#define cut2top

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
    dim sHead as short
    dim outtext as string
    outtext="<p>"
    for a=0 to len(text)
        if mid(text,a,1)="|" or mid(text,a,1)="{" then
            if mid(text,a,1)="|" then
                if sHead=1 then
                    outtext=outtext &"</b>"
                    sHead=2
                endif
                if sHead=0 then
                    outtext=outtext &"<b>"
                    sHead=1
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


function html_color(c as string, indent as short=0, wid as short=0) as string
    dim t as string
    t= "<span style="&chr(34) &" COLOR:"& c &"; font-family:arial;position:relative"
    if indent>0 then t=t &"; left:"&indent &"px"
    if wid>0 then t=t & ";display:inline-block; width:"&wid &"px"
    t=t & chr(34)& ">"
    return t
end function


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


#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tUtils -=-=-=-=-=-=-=-
	tModule.register("tUtils",@tUtils.init()) ',@tUtils.load(),@tUtils.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tUtils -=-=-=-=-=-=-=-
#endif'test
