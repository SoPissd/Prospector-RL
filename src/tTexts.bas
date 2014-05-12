'tTexts.
'
'defines:
'html_color=43, text_to_html=4
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tTexts -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tTexts -=-=-=-=-=-=-=-

declare function html_color(c as string, indent as short=0, wid as short=0) as string
declare function text_to_html(text as string) as string


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tTexts -=-=-=-=-=-=-=-

namespace tTexts
function init() as Integer
	return 0
end function
end namespace'tTexts


#define cut2top


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



#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tTexts -=-=-=-=-=-=-=-
	tModule.register("tTexts",@tTexts.init()) ',@tTexts.load(),@tTexts.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tTexts -=-=-=-=-=-=-=-
#endif'test
