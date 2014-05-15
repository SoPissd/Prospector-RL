'tViewfile.
'
'defines:
'Viewfile=0
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
'     -=-=-=-=-=-=-=- TEST: tViewfile -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tViewfile -=-=-=-=-=-=-=-


'private function Viewfile(filename as string,nlines as integer=4096) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tViewfile -=-=-=-=-=-=-=-

namespace tViewfile
function init(iAction as integer) as integer
	return 0
end function
end namespace'tViewfile

'type tLines() as string   

function ViewArray(lines() as string,nlines as integer) as short
    dim as Integer height, pheight, xwidth, i
    dim as Integer offset, offsetx 
    dim as Integer iwid, longest 
    dim col(nlines) as short
    dim as string text
    dim as string key
   
    for i=1 to nlines
        col(i)=11
        if left(lines(i),2)="==" then
            col(i)=7
            col(i-1)=14
        endif
        'if left(lines(a),1)="*" then col(a)=14
    next
    
    height=(width() shr (4*4)) ' gives screen/console height
    xwidth=(width() and &hFFFF)
    if nlines-height<0 then
   		pheight=nlines
    else
    	pheight =height-1
    EndIf
    
    do
        cls
'ErrLog("height=" & height)
'?"pheight=" & pheight           
        set__color( 11,0)
        for i=0 to pheight-1
        	if i+offset>ubound(col) then exit for
            locate i+1,1
            set__color( col(i+offset),0)
            text= lines(i+offset)
            iwid=len(text)
            if iwid>longest then
            	longest=iwid
            EndIf
            text= mid(text,offsetx+1,xwidth)
            'print i+offset;" ";pheight;" ";text;
            print text;
        next
        ?
        set__color( 14,0)
        key="Use Arrows and +/- to browse " & nlines & " lines. Enter to close: "
        locate height,(xwidth-len(key))\2+1
        print key; 
        key=uConsole.keyinput() '("12346789 ")
'            key=keyin("12346789 ",1)
		'
        if key="2" or key=key__dn then 
	        offset=offset+1
        elseif key="8" or key=key__up then 
			offset=offset-1
        elseif key="4" or key=key__lt then 
			offsetx=offsetx-1
        elseif key="6" or key=key__rt then 
	        offsetx=offsetx+1
        elseif keyplus(key)  then 
            offset=offset+(height-1)
        elseif keyminus(key)  then 
            offset=offset-(height-1)
        EndIf
		'
        if offset<0 then 
			offset=0
        elseif offset>nlines then 
            offset=nlines
'        elseif offset>nlines-height then 
'            offset=nlines-height
        EndIf
		'
        if (offsetx<0) then 
			offsetx=0
        elseif xwidth>=longest then 
			offsetx=0
        elseif offsetx>longest-xwidth then 
            offsetx=longest-xwidth
        EndIf
		'
    loop until uConsole.Closing<>0 or key=key__esc or key=key__enter or key=" "
    return 0
End Function


function Viewfile(filename as string,nlines as integer=4096) as short
    dim as integer f
    dim as Integer c,lastspace
    dim lines(nlines) as string
    dim as string text
    cls
    set__color( 15,0)
    
    if tFile.Openinput(filename,f)>0 then
        do
            line input #f,lines(c)
            'while len(lines(c))>80
            '    text=lines(c)
            '    lastspace=80
            '    do
            '        lastspace=lastspace-1
            '    loop until mid(text,lastspace,1)=" "
            '    lines(c)=left(text,lastspace)
            '    lines(c+1)=mid(text,lastspace+1,(len(text)-lastspace+1))
            '    c=c+1
            'wend
            c=c+1

        loop until eof(f) or c>nlines
        
        tFile.Closefile(f)
        ViewArray(Lines(),c)
    else
        locate 10,10
ErrOut("Couldnt open " + filename)
        print "Couldnt open " + filename
    endif
	uConsole.ClearKeys()
    return 0
end function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tViewfile -=-=-=-=-=-=-=-
	tModule.register("tViewfile",@tViewfile.init()) ',@tViewfile.load(),@tViewfile.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tViewfile -=-=-=-=-=-=-=-
#endif'test
