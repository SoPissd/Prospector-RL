'tFonts.
'
'defines:
'load_font=1, load_fonts=1, draw_border=5
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
'     -=-=-=-=-=-=-=- TEST: tFonts -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Type FONTTYPE
  As Integer w
  As Any Ptr dataptr
End Type

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tFonts -=-=-=-=-=-=-=-

declare function load_font(fontdir as string,byref fh as ubyte) as ubyte ptr
declare function load_fonts() as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tFonts -=-=-=-=-=-=-=-

namespace tFonts
function init(iAction as integer) as integer
	'load_fonts() 
	return 0
end function
end namespace'tFonts


function load_font(fontdir as string,byref fh as ubyte) as ubyte ptr
    Dim as ubyte ptr img
    dim font as ubyte ptr
    Dim As Integer imgwidth,imgheight,i,ff
    ff=FreeFile
    Open "graphics/font"&fontdir &".bmp" For Binary As ff
    Get #ff, 19, imgwidth
    Get #ff, 23, imgheight
    Close ff
    fh=imgheight
    img=ImageCreate(imgwidth,imgheight) 'Zwischenpuffer f?r bmp
    If img Then
      BLoad ("graphics/font"&fontdir &".bmp",img)
      font=ImageCreate(imgwidth,imgheight+1) 'eigentlicher Font
      If font Then
        ff=FreeFile
        Open "graphics/"&fontdir &"header" For Binary As ff  'Buchstabenbreite dazuladen
        i=0
        Do Until EOF(ff)
          Get #ff,, font[SizeOf(FB.Image)+i]
          i=i+1
        Loop
        Close ff
        Put font,(0,1),img,(0,0)-(imgwidth-1,imgheight-1),PSet  'Zwischenpuffer in Font kopieren
      End If
      ImageDestroy (img)    'Zwischenpuffer l?schen
    else
        set__color( 14,0)
        print "Loading font graphics/"&fontdir &".bmp failed."
        sleep 600
    endif
    return font
end function


function load_fonts() as short
    'DimDebugL(0)'1
    dim as short a,f
    dim as integer depth
    dim as integer debug
    
    if not tScreen.isGraphic then
    	tError.Errorhandler(Errorloc+"> why it failed")
    	return false
    EndIf

#if __FB_DEBUG__
    if debug=1 then
        f=freefile
        open "fontlog.txt" for append as #f
    endif
#endif
    if ((not fileexists("graphics/font"&_fohi1 &".bmp")) or (not fileexists("graphics/font"&_fohi2 &".bmp"))) then
        if configflag(con_customfonts)=0 then
            if not fileexists("graphics/ships.bmp") then configflag(con_tiles)=1
            configflag(con_customfonts)=1
            _fw1=8
            _tix=8
            _mwx=60
            color 14,0
            print "Couldn't find fonts. Switching to built in font."
            sleep 1500
        else

        endif
    endif
'    if _lines<25 then _lines=25
    if configflag(con_tiles)=0 then
        '_fohi2=10
        _fohi1=26
    endif
    if _fohi1=9 then _fohi1=10
    if _fohi1=11 then _fohi1=12
    if _fohi1=13 then _fohi1=14
    if _fohi1=15 then _fohi1=16
    if _fohi1=17 then _fohi1=18
    if _fohi1=19 then _fohi1=20
    if _fohi1=21 then _fohi1=22
    if _fohi1=23 then _fohi1=24
    if _fohi1=25 then _fohi1=26
    if _fohi2=9 then _fohi2=10
    if _fohi2=11 then _fohi2=12
    if _fohi2=13 then _fohi2=14
    if _fohi2=15 then _fohi2=16
    if _fohi2=17 then _fohi2=18
    if _fohi2=19 then _fohi2=20
    if _fohi2=21 then _fohi2=22
    if _fohi2=23 then _fohi2=24
    if _fohi2=25 then _fohi2=26
    if _fohi1<8 or _fohi1>24 then _fohi1=12
    if _fohi2<8 or _fohi2>24 then _fohi2=12
    if _fohi2>_fohi1 then _fohi2=_fohi1
    'Extern fb_mode Alias "fb_mode" As Uinteger Ptr
    _FH1=_fohi1
    _FH2=_fohi2
    _FW1=_FH1/2+2
    _FW2=_FH2/2+2
    if configflag(con_tiles)=0 then
        _Fw1=_tix
        _Fh1=_tiy
    endif

'    if tScreen.y<>_lines*_fh1 then tScreen.y=_lines*_fh1
'    _textlines=fix((22*_fh1)/_fh2)+fix((tScreen.y-_fh1*22)/_fh2)-1

'    tScreen.x=_mwx*_fw1+25*_fw2
'    tScreen.res()
'    tScreen.set()

    
    Print "Loading Fonts"
    'gfx.font.loadttf("graphics/Nouveau_IBM.ttf", FONT1, 32, 448, _fh1)
    'gfx.font.loadttf("graphics/Nouveau_IBM.ttf", FONT2, 32, 448, _fh2)
    set__color(11,0)

    if configflag(con_customfonts)=0 then

        print "loading font 1"
        font1=load_font(""&_fohi1,_FH1)

        print "loading font 2"
        font2=load_font(""&_fohi2,_FH2)

        titlefont=load_font("26",26)
    else

'        tScreen.x=1024
'        tScreen.y=768
'        tScreen.res()
'        tScreen.size(tScreen.x/8,tScreen.y/16) 'width
        'font1=load_font("FH1.bmp",16)
        'font2=load_font("FH1.bmp",16)
        
        Font1 = ImageCreate((254-1) * 8, 17,rgba(0,0,0,0),16)
        Font2 = ImageCreate((254-1) * 8, 17,rgba(0,0,0,0),16)

        dim as ubyte ptr p
        if ImageInfo( Font1, , ,depth , , p )=1 then
        	LogWarning("Invalid Image")
        EndIf
        p[0] = 0
        p[1] = 24
        p[2] = 254
        For a = 24 To 254
            p[3 + a - 24] = 8
            Draw String Font1, ((a - 24) * 8, 1), Chr(a),rgba(255,255,255,255)
        Next
        
        _fh1=16
        _fh2=16
'        bsave "data/F1.bmp",Font1
        font2=font1
    endif

    _FW1=_FH1/2+2
    _FW2=_FH2/2+2
    
    if configflag(con_tiles)=0 then
        _Fw1=_tix
        _Fh1=_tiy
    endif

'    if tScreen.y<>_lines*_fh1 then tScreen.y=_lines*_fh1
'    
'    tScreen.x=_mwx*_fw1+25*_fw2
'    tScreen.res(tScreen.GFX_WINDOWED OR tScreen.GFX_ALWAYS_ON_TOP)
'    tScreen.res()
    
    sidebar=(_mwx+1)*_fw1+_fw2

    return true
end function


'function font_load_bmp(ByRef _filename As String) As UByte Ptr
'    Dim As UInteger w,h,f=FreeFile
'    Dim As UShort bpp
'    If (Open(_filename, For Binary, Access Read, As #f)<>0)Then
'        Print "Font " + _filename+" not loaded!"
'        Return 0
'    EndIf
'    Get #f,19,w
'    Get #f,23,h
'    Get #f,29,bpp
'    Close #f
'
'    Dim As UByte Ptr font
'    font=ImageCreate(w,h)
'    BLoad(_filename,font)
'    Dim As UByte Ptr fontheader=Cast(UByte Ptr,font+SizeOf(FB.image))
'
'    Select Case As Const fontheader[0]
'        Case 0 'standard draw string font buffer
'            fontheader[0]=Point(0,0,font)
'            fontheader[1]=Point(1,0,font)
'            fontheader[2]=Point(2,0,font)
'            For x As Integer=0 To (fontheader[2]-fontheader[1])+1
'                fontheader[3+x]=Point(3+x,0,font)
'            Next x
'        Case 5 'unicode draw string font buffer
'            fontheader[0]=Point(0,0,font)
'            fontheader[1]=Point(1,0,font)
'            fontheader[2]=Point(2,0,font)
'            fontheader[3]=Point(3,0,font)
'            fontheader[4]=Point(4,0,font)
'            Dim As UShort first,last
'            first=((fontheader[1] Shl 4)) Or (fontheader[2])
'            last=((fontheader[3] Shl 4)) Or (fontheader[4])
'            For x As Integer=0 To last-first+1
'                fontheader[5+x]=Point(5+x,0,font)
'            Next x
'    End Select
'
'    Return font
'End function




#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tFonts -=-=-=-=-=-=-=-
	tModule.register("tFonts",@tFonts.init()) ',@tFonts.load(),@tFonts.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tFonts -=-=-=-=-=-=-=-
#endif'test
