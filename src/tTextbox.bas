'tTextbox

function scroll_bar(offset as short,linetot as short,lineshow as short,winhigh as short, x as short,y as short,col as short) as short
    dim as single part,i,balkenh,offset2,oneline
    oneline=winhigh/(linetot-1)
    balkenh=cint(lineshow*oneline)
    offset2=cint(offset*oneline)
    for i=0 to winhigh
        if i>=offset2 and i<=offset2+balkenh then
            set__color(col,0)
        else
            set__color(0,0)
        end if

        draw string(x,y+(i)*_fh2),chr(178),,font2,custom,@_col
    next
    return 0
end function


function textbox(text as string,x as short,y as short,w as short,_
    fg as short=11, bg as short=0,pixel as byte=0,byref op as short=0,byref offset as short=0) as short
    'op=1 only count lines, don't print
    dim as short lastspace,tlen,p,wcount,lcount,xw,a,longestline,linecount,maxlines,blocks
    dim words(6023) as string
    dim addt as string
    addt=text

    if pixel=0 then
        x=x*_fw1
        y=y*_fh1
    endif
    maxlines=(20*_fh1-y)/_fh2
    'if len(text)<=w then addt(0)=text
    for p=0 to len(text)
        if mid(text,p,1)="{" or mid(text,p,1)="|" then wcount+=1
        words(wcount)=words(wcount)&mid(text,p,1)
        if mid(text,p,1)=" " or mid(text,p,1)="|" or  mid(text,p,1)="}" then wcount+=1
    next
    if words(wcount)<>"|" and bg<>0 and pixel=0 then
        wcount+=1
        words(wcount)="|"
    endif
    set__color( fg,bg)
    'Count lines
    for p=0 to wcount
        if words(p)="|" then
            linecount+=1
            xw=0
        else
            if xw+len(words(p))>w then
                linecount+=1
                xw=0
            endif
            xw=xw+len(words(p))
        endif
    next
    xw=0
    if offset>0 and linecount-offset<maxlines-1 then offset=linecount-maxlines-1
    if offset<0 then offset=0

    for p=0 to wcount

        if words(p)="|" then 'New line
            if op=0 and lcount-offset>=0  and (lcount-offset)<=maxlines then draw string((x)+xw*_fw2,y+(lcount-offset)*_fh2),space(w-xw),,font2,custom,@_col
            lcount=lcount+1
            xw=0
        endif

        if Left(trim(words(p)),1)="{" and Right(trim(words(p)),1)="}" then 'Color
            set__color( numfromstr(words(p)),bg)
        endif

        if words(p)<>"|" and not(Left(trim(words(p)),1)="{" and Right(trim(words(p)),1)="}") then 'Print word
            if xw+len(words(p))>w then 'Newline
                if op=0 and lcount-offset>=0 and (lcount-offset)<=maxlines then draw string((x)+xw*_fw2,y+(lcount-offset)*_fh2),space(w-xw),,font2,custom,@_col
                lcount=lcount+1
                xw=0
            endif
            if op=0 and lcount-offset>=0 and (lcount-offset)<=maxlines then draw string((x)+xw*_fw2,y+(lcount-offset)*_fh2),words(p),,font2,custom,@_col
            xw=xw+len(words(p))
            if xw>longestline then longestline=xw
        endif

        if (lcount-offset)>maxlines then 'Too long
            if op<>0 then
                op=longestline
                return lcount
            endif
            set__color( fg,bg)
        endif
    next
    if linecount>maxlines then
        if offset>0 then
            set__color(14,0)
        else
            set__color(14,0,0)
        endif
        draw string(x+w*_fw2-_fw2,y),chr(24),,font2,custom,@_col
        draw string(x+w*_fw2-_fw2,y+_fh2),"-",,font2,custom,@_col
        if offset+maxlines<linecount-1 then
            set__color(14,0)
        else
            set__color(14,0,0)
        endif
        draw string(x+w*_fw2-_fw2,y+maxlines*_fh2-_fh2),"+",,font2,custom,@_col
        draw string(x+w*_fw2-_fw2,y+maxlines*_fh2),chr(25),,font2,custom,@_col

        DbgPrint("LC:" &linecount &"ML:"&maxlines)
        scroll_bar(offset,linecount,maxlines,maxlines-4,x+w*_fw2-_fw2,y+2*_fh2,14)
    endif
    text=addt
    set__color(11,0)
    op=longestline
    return lcount
end function

