'
' File Input/output routines
'

'
'
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

