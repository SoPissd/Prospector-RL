'gUtils.
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

declare function add_a_or_an(t as string,beginning as short) as string
declare function credits(cr As Integer) As String
declare function screenshot(a as short) as short
declare function play_sound(iSound As Short,iRepeats As Short=1,iDelay As Short=0) as short

declare function textmenu overload (bg as short,te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1,loca as short=1) as short
declare function textmenu overload (            te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1,loca as short=1) as short

'private function Texttofile(text as string) as string
'private function lev_minimum( a As Integer, b As Integer, c As Integer ) As Integer
'private function fuzzymatch( s As String, t As String ) As single
'private function screenshot_nextfilename(fname as String, ext as String, force as short) as String

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tUtils -=-=-=-=-=-=-=-

namespace gUtils
function init(iAction as integer) as integer
	return 0
end function
end namespace'tUtils


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


function play_sound(iSound As Short,iRepeats As Short=1,iDelay As Short=0) as short
	#IfNDef _sound
		return 0
	#else
		If (configflag(con_sound)<>0 and configflag(con_sound)<>2) then 
			return 0
		else
			return uSound.play(iSound,iRepeats,iDelay)
		EndIf
	#EndIf
End function


function textmenu overload (bg as short,te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1,loca as short=0) as short
	dim aMenu as tMainmenu
	return aMenu.go(bg,te,he,x,y,blocked,markesc,st,loca) 	          
end function

function textmenu overload (te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1,loca as short=0) as short
	dim aMenu as tMainmenu
	return aMenu.go(0,te,he,x,y,blocked,markesc,st,loca) 	          
end function


#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tUtils -=-=-=-=-=-=-=-
	tModule.register("gUtils",@gUtils.init()) ',@tUtils.load(),@tUtils.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tUtils -=-=-=-=-=-=-=-
#endif'test
