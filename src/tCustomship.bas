'tCustomship

function delete_custom(pir as short) as short
    dim s as _ship
    dim as short n,f,c,last,i,flag
    dim as string lines(22),men,des
    do
        last=0
        n=count_lines("data/customs.csv")-1
        f=freefile
        open "data/customs.csv" for input as #f
        for i=0 to n
            line input #f,lines(i)
        next
        close #f
        men="Delete Ship Design/"
        des="/"
        for i=1 to n
            s=gethullspecs(i,"data/customs.csv")
            men=men & s.h_desig & "/"
            des=des &makehullbox(i,"data/customs.csv") &"/"
            last=last+1
        next
        last+=1
        men=men &"Exit"
        c=menu(bg_parent,men,des)
        if c>0 and c<last then
            if askyn("do you really want to delete this ship design? (y/n)") then
                lines(c)=lines(n)
                lines(n)=""
                n-=1
                open "data/customs.csv" for output as #f
                for i=0 to n
                    print #f,lines(i)
                next
                close #f
            endif
        endif
    loop until c=last or c=-1
    if flag=1 then
    endif
    return 0
end function


