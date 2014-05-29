'tTime.
#include once "uDefines.bi"
DeclareDependencies()
#include "uUtils.bas"
#include "uiScreen.bas"
#include "uiColor.bas"
#define test 
#endif'DeclareDependencies()
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tTime -=-=-=-=-=-=-=-

declare function display_time(t As UInteger,form As Byte=0) As String
declare function date_string() as string


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tTime -=-=-=-=-=-=-=-

namespace tTime
function init(iAction as integer) as integer
	return 0
end function
end namespace'tTime


#define cut2top


function display_time(t As UInteger,form As Byte=0) As String
    Dim As UInteger d,h,m
    Dim As String ms,hs
    h=Fix(t/60)
    d=Fix(h/24)
    h=h-d*24
    m=t-h*60-d*24*60
    hs=LeadingZero(2,h)
    ms=LeadingZero(2,m)
    Select Case form
    Case 0
        If d>0 Then
            Return "Day "&d &", "& hs &":"&ms 
        Else
            Return  hs &":"&ms
        EndIf
    Case 1
        Return d &" days, "& h &" hours and "& m &" minutes"
    Case 2
        If d>0 Then
            Return d &" days"
        Else
            Return  hs &":"&ms
        EndIf
    End Select
End function


function date_string() as string
    dim as string t,w(3)
    dim as short i,j
    t=date
    for i=1 to len(t)
        if mid(t,i,1)="-" then
            j+=1
        else
            w(j)=w(j)&mid(t,i,1)
        endif
    next
    i=val(w(0))
    select case as const i
    	case 01: w(0)="JAN"
    	case 02: w(0)="FEB"
    	case 03: w(0)="MAR"
    	case 04: w(0)="APR"
    	case 05: w(0)="MAY"
    	case 06: w(0)="JUN"
    	case 07: w(0)="JUL"
    	case 08: w(0)="AUG"
    	case 09: w(0)="SEP"
    	case 10: w(0)="OCT"
    	case 11: w(0)="NOV"
    	case 12: w(0)="DEZ"
    	case else: w(0)="WTF"
    End Select
    return w(1)&"-"&w(0)&"-"&w(2)
end function
#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tTime -=-=-=-=-=-=-=-
	tModule.register("tTime",@tTime.init()) ',@tTime.load(),@tTime.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tTime -=-=-=-=-=-=-=-
#undef test
#define test
#endif'test

#if (defined(test) or defined(registerTests))
#print -=-=-=-=-=-=-=- TEST: tTime -=-=-=-=-=-=-=-

	namespace tTime

	sub Timetest()
	End Sub

	end namespace'tTime
	
	#ifdef test
		tTime.Timetest()
		'? "sleep": sleep
	#else
		tModule.registertest("uTime",@tTime.Timetest())
	#endif'test
#endif'test