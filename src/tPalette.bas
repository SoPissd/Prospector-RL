'tPalette


function load_palette() as short
    dim as short f,i,j,k
    dim as string l,w(3)
    if not(fileexists("p.pal")) then
        color rgb(255,255,0),0
        print "p.pal not found - can't start the game"
        sleep
        end
    endif
    f=freefile
    open "p.pal" for input as #f
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
        palette_(i)=RGB(val(w(1)),val(w(2)),val(w(3)))
        DbgPrint( i &": " &l &" -> " +w(1) +":" +w(2) +":" +w(3) +" -> " &palette_(i))
        i+=1
    loop until eof(f)
    close #f
    return 0
end function

