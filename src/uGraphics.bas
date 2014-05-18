'tGraphics.
'
'defines:
'background=10, bmp_load=2, calcosx=0
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(types) or defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#undef both
#define types
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tGraphics -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test

namespace tGraphics

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

dim shared backgrounds as integer= 14
dim shared iBg as integer= 0

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tGraphics -=-=-=-=-=-=-=-
declare function Randombackground() as integer
declare function bmp_load( ByRef filename As String ) As Any Ptr

declare function background overload (bg as integer=0) as integer
declare function background overload (fn as string) as integer
'private function calcosx(x as short,wrap as byte) as short 'Caculates Ofset X for windows less than 60 tiles wide

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tGraphics -=-=-=-=-=-=-=-


function init(iAction as integer) as integer
	return 0
end function


function Randombackground() as integer
	iBg=rnd_range(1,backgrounds)
	return iBg
end function

function background overload (bg as integer=0) as integer
	if bg<=0 then 
    	return background(iBg &".bmp")
    else
    	return background(bg &".bmp")
	endif
end function


function background overload (fn as string) as integer
    static last as string
    static firstcall as byte
    Dim As Integer filenum, bmpwidth, bmpheight,x,y
    static As Any Ptr img
    cls
    if fn="" then
    	Randombackground
    	return background(iBg)    	
    EndIf
    fn="graphics/"&fn
    '' open BMP file
    filenum = FreeFile()
    If tFile.Openbinary(fn,filenum ) =0 Then Return -1
    'If Openbinaryread '( fn For Binary Access Read As #filenum ) <> 0 Then Return 0

        '' retrieve BMP dimensions
        Get #filenum, 19, bmpwidth
        Get #filenum, 23, bmpheight

    tFile.Closefile(filenum)
    if fn<>last then
        '' create image with BMP dimensions
        if firstcall<>0 then imagedestroy(img)
        img = ImageCreate( bmpwidth, Abs(bmpheight) )
        If img = 0 Then Return 0
        'dst=imagecreate(tScreen.x,tScreen.y)
        '' load BMP file into image buffer
        BLoad( fn, img )
        last=fn
    endif
    x=(tScreen.x-bmpwidth)/2
    y=(tScreen.y-bmpheight)/2
    put (x,y),img,pset
    firstcall=1
    Return 0
end function


'' A function that creates an image buffer with the same
'' dimensions as a BMP image, and loads a file into it.
'' Code by counting_pine
function bmp_load( ByRef filename As String ) As Any Ptr
	Dim As Integer filenum,bmpwidth,bmpheight
  	Dim As Any Ptr img

	'' open BMP file
	If tFile.Openbinary(filename,filenum) =0 Then return null
   	'' retrieve BMP dimensions
    Get #filenum, 19, bmpwidth
    Get #filenum, 23, bmpheight
    tFile.Closefile(filenum)
	
   	'' create image with BMP dimensions
    img = ImageCreate( bmpwidth, Abs(bmpheight) )
   	If img = NULL Then 
        color rgb(255,255,255),rgb(0,0,0)
        print "Error imagecreate"
   		Return NULL
   	Else
   		'' load BMP file into image buffer
   		If BLoad( filename, img ) <> 0 Then 
    			color rgb(255,255,255),rgb(0,0,0)
                print BLoad( filename, img )
                ImageDestroy( img )
    			print "Error loading image"
                Return NULL
    		Else
    			Return img
    		EndIf
   	EndIf
End function


'
#endif'main
end namespace'tGraphics

#ifdef main
'#print -=-=-=-=-=-=-=- MAIN: tGraphics -=-=-=-=-=-=-=-
#Macro draw_string(ds_x,ds_y,ds_text,ds_font,ds_col)
	Draw String(ds_x,ds_y),ds_text,,ds_font,custom,@ds_col
#EndMacro
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tGraphics -=-=-=-=-=-=-=-
	tModule.register("tGraphics",@tGraphics.init()) ',@tGraphics.load(),@tGraphics.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tGraphics -=-=-=-=-=-=-=-
#undef test
#endif'test
