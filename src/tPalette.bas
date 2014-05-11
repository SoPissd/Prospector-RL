'tPalette

#if not (defined(head) or defined(main)) 'test
#print "tPalette test"
#define main
#include "file.bi"
#include "tDefines.bas"
#include "tModule.bas"
#include "tScreen.bas"
#include "tColor.bas"
#include "kbinput.bas"
'#include "tUtils.bas"
#undef main
# define gen_include
#ifdef gen_include
dim shared fout as integer
#endif 
#endif


function load_palette(filename as string="p.pal") as short
    dim as integer f
    dim as short i,j,k
    dim as string l,w(3)
    if not(fileexists(filename)) then
        color rgb(255,255,0),0
        print filename + " not found!"
        sleep
        end
    endif
    f=freefile
    open filename for input as #f
    line input #f,l
    line input #f,l
    line input #f,l 'First do not need to be checked
    do
        line input #f,l
        k=1
        w(1)=""
        w(2)=""
        w(3)=""
        for j=1 to len(l)
            w(k)=w(k)&mid(l,j,1)
            if mid(l,j,1)=" " then k+=1
        next
        tColor.palete(i)=RGB(val(w(1)),val(w(2)),val(w(3)))
'        DbgPrint( i &": " &l &" -> " +w(1) +":" +w(2) +":" +w(3) +" -> " &tColor.palete(i))
#ifdef gen_include
		'Print( i &": " &l &" -> " +w(1) +":" +w(2) +":" +w(3) +" -> " &tColor.palete(i))
		dim as String a= "DATA " +w(1) +"," +w(2) +"," +w(3) +"' " &i
		dim as integer f=fout
		Print a
		print #f, chr(9)+a ' &" -> " &tColor.palete(i))
#endif		
        i+=1
    loop until eof(f)
    close #f
    return 0
end function

'#if ( define(all) or define(head) or define(main) )
'#else
#ifdef gen_include
chdir exepath
chdir ".."
fout=freefile
open "tPalette.bi" for output as #fout
load_palette
close #fout
dim i as Integer
for i = 1 to 255 
Next
Pressanykey
#else
'load_palette()
#endif		
'#endif

