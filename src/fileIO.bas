'
' File Input/output routines
'

declare function keyin(byref allowed as string="" , blocked as short=0)as string
'
'

function viewfile(filename as string) as short
    dim as integer f,offset,c,a,lastspace
    dim lines(512) as string
    dim col(512) as short
    dim as string key,text
    'dim evkey as EVENT
    'screenshot(1)
    set__color( 15,0)
    cls
    f=freefile
    if (open (filename for input as #f))=0 then
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
        close #f
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
    while inkey<>""
    wend
    'screenshot(2)
    return 0
end function



function assertpath(folder as string) as short
    if chdir(folder)=-1 then
        print "Creating folder " +folder
        return mkdir(folder) '-1 on failure
    else
        return chdir("..")
    endif
end function

function file_size(filename as string) as integer
	Dim as Integer f, size
	f = FreeFile
	if Open(filename, For Binary, As #f)=0 then
		size= LOF(f)
		Close #f
		return size
	EndIf
	return -1
end function

function count_lines(file as string) as short
    dim as short f,n
    dim dummy as string
    f=freefile
    open file for input as #f
    do
        line input #f,dummy
        if len(dummy)>0 then n+=1
    loop until eof(f)
    close #f
    return n
end function

function open_file(filename as string) as short
    dim f as short
    f=freefile
    if fileexists(filename) then
        open filename for input as #f
        return f
    else
        color rgb(255,255,0)
        print "Couldn't find "&filename &"."
        sleep
        end
    endif
end function


function texttofile(text as string) as string
    dim a as short
    dim head as short
    dim outtext as string
    outtext="<p>"
    for a=0 to len(text)
        if mid(text,a,1)="|" or mid(text,a,1)="{" then
            if mid(text,a,1)="|" then
                if head=1 then
                    outtext=outtext &"</b>"
                    head=2
                endif
                if head=0 then
                    outtext=outtext &"<b>"
                    head=1
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

