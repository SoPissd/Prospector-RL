'tViewfile

public function Viewfile(filename as string) as short
    dim as integer f,offset,c,a,lastspace
    dim lines(512) as string
    dim col(512) as short
    dim as string key,text
    'dim evkey as EVENT
    'screenshot(1)
    set__color( 15,0)
    cls
    if OpenInput(filename,f)=0 then
        do
            line input #f,lines(c)
            while len(lines(c))>80
                text=lines(c)
                lastspace=80
                do
                    lastspace=lastspace-1
                loop until mid(text,lastspace,1)=" "
                lines(c)=left(text,lastspace)
                lines(c+1)=mid(text,lastspace+1,(len(text)-lastspace+1))
                c=c+1
            wend
            c=c+1

        loop until eof(f) or c>512
        Closefile(f)
        for a=1 to c
            col(a)=11
            if left(lines(a),2)="==" then
                col(a)=7
                col(a-1)=14
            endif
            'if left(lines(a),1)="*" then col(a)=14
        next
        do
            key=""
            cls
            set__color( 11,0)
            for a=1 to 24
                locate a,1
                set__color( col(a+offset),0)
                print lines(a+offset);
            next
            locate 25,15
            set__color( 14,0)
            print "Arrow down and up to browse, esc to exit";
            key=keyin("12346789 ",1)
            if keyplus(key)  then offset=offset-22
            if keyminus(key)  then offset=offset+22
            if offset<0 then offset=0
            if offset>488 then offset=488
        loop until key=key__esc or key=" "
    else
        locate 10,10
        print "Couldnt open " + filename
    endif
    cls
    while inkey<>"": wend
    'screenshot(2)
    return 0
end function

