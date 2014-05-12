'tViewfile.
'
'defines:
'Viewfile=0
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
function init() as Integer
	return 0
end function
end namespace'tViewfile


#define cut2top



public function Viewfile(filename as string,nlines as integer=4096) as short
    dim as integer f
    dim as Integer offset,c,a,lastspace,height
    dim lines(nlines) as string
    dim col(512) as short
    dim as string key,text
    cls
    set__color( 15,0)
    
    if tFile.Openinput(filename,f)>0 then
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

        loop until eof(f) or c>nlines
        tFile.Closefile(f)
        for a=1 to c
            col(a)=11
            if left(lines(a),2)="==" then
                col(a)=7
                col(a-1)=14
            endif
            'if left(lines(a),1)="*" then col(a)=14
        next
        height=(width() shr (4*4))        
        if c-height<0 then
        	height=c
        EndIf
        do
            cls
            set__color( 11,0)
            for a=1 to height
                locate a,1
                set__color( col(a+offset),0)
                print lines(a+offset);
            next
            ?
            locate height+1,15
            set__color( 14,0)
            print "Arrow down and up to browse, esc to exit";
            key=keyinput("12346789 ")
'            key=keyin("12346789 ",1)
            if key="8"  then offset=offset+1
            if key="2"  then offset=offset-1
            if keyplus(key)  then offset=offset-22
            if keyminus(key)  then offset=offset+22
            if offset<0 then offset=0
            if offset>c-height then offset=c-height
        loop until key=key__esc or key=" "
    else
        locate 10,10
        print #iErrConsole, "Couldnt open " + filename
        print "Couldnt open " + filename
    endif
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
