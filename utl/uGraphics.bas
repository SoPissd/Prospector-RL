'tGraphics.
#include once "uDefines.bi"
DeclareDependencies()
#include "fbGfx.bi"
#include "uiScreen.bas"
#include "file.bi"
#include "uFile.bas"
#include "uiColor.bas"
#include "uiConsole.bas"
#include "uRNG.bas"
'#include "adtCoords.bas"
'#include "uiPrint.bas"
#include "uUtils.bas"
#define test 
#endif'DeclareDependencies()

namespace tGraphics

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

dim shared as any ptr logo				'in memory image
dim shared as string  logosource		'filename

dim shared backgrounds as integer= 14
dim shared iBg as integer= 0

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tGraphics -=-=-=-=-=-=-=-
declare function LoadLogo(filename as string="") as Integer
declare function PutLogo(x as integer, y as integer) as Integer

declare function Randombackground() as integer
declare function bmp_load( ByRef filename As String ) As Any Ptr

declare function background overload (bg as integer=0) as integer
declare function background overload (fn as string) as integer

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tGraphics -=-=-=-=-=-=-=-


function init(iAction as integer) as integer
	return 0
end function


function LoadLogo(filename as string="") as Integer
	if LogoSource<>filename then
	    if Logo <> 0 then ImageDestroy(Logo)
	    if filename="" then
	    	Logo= 0
	    else
			Logo= bmp_load(filename)
	    endif
	    if Logo <> 0 then LogoSource= filename
	endif
	return LogoSource<>""
    '        if logo<>NULL then
    '            put (39,69),logo,trans
    '        else
    '            draw string(26,26),"PROSPECTOR",,titlefont,custom,@_col
    '        endif
End Function

function PutLogo(x as integer, y as integer) as Integer
	if logo<>NULL then
    	put (x,y),logo,trans
    	return true
	endif
	return false
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
    If not fileexists(fn) or tFile.Openbinary(fn,filenum ) =0 Then Return -1
    'If Openbinaryread '( fn For Binary Access Read As #filenum ) <> 0 Then Return 0
?fn
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
	If not fileexists(filename) or tFile.Openbinary(filename,filenum) =0 Then return null
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
#include "uWindows.bas" 'auto-close
#define test
#endif'test


#if (defined(test) or defined(registerTests))
#print -=-=-=-=-=-=-=- TEST:  -=-=-=-=-=-=-=-

	namespace tGraphics

	sub Graphicstest()

		cls
		chdir exepath
		chdir ".."
		? curdir
		
		
		while not uConsole.Closing
			tscreen.res
			? tGraphics.LoadLogo("graphics/prospector.bmp")
		
			tGraphics.Randombackground()		    	    
			tGraphics.background(0)
			if not tGraphics.putlogo(39,69) then
		    	draw string(26,26),"PROSPECTOR"',,titlefont,custom,@_col
			endif
			tScreen.xy(10,22, "this is image: "&tGraphics.iBg)
			tScreen.xy(10,24)
			if uConsole.keyaccept(uConsole.pressanykey(0),keyl_onwards) then exit while
			tScreen.xy(10,22, pad(25,""))
		wend
		
	End Sub

	end namespace'tGraphics
	
	#ifdef test
		tGraphics.Graphicstest()
		'? "sleep": sleep
	#else
		tModule.registertest("uGraphics",@tGraphics.Graphicstest())
	#endif'test
#endif'test
