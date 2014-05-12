'tGraphics

Enum backgrounds
    bg_title
    bg_noflip
    bg_ship
    bg_shiptxt
    bg_shipstars
    bg_shipstarstxt
    bg_awayteam
    bg_awayteamtxt
    bg_logbook
    bg_randompic
    bg_randompictxt
    bg_stock
    bg_roulette
    bg_trading
End Enum


function background(fn as string) as short
    static last as string
    static firstcall as byte
    Dim As Integer filenum, bmpwidth, bmpheight,x,y
    static As Any Ptr img
    cls
    fn="graphics/"&fn
    '' open BMP file
    filenum = FreeFile()
    If tFile.Openbinary(fn,filenum ) =0 Then Return 0
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

#Macro draw_string(ds_x,ds_y,ds_text,ds_font,ds_col)
	Draw String(ds_x,ds_y),ds_text,,ds_font,custom,@ds_col
#EndMacro

'

Dim Shared As Byte _mwx=30

function calcosx(x as short,wrap as byte) as short 'Caculates Ofset X for windows less than 60 tiles wide
    dim osx as short
    osx=x-_mwx/2
    if wrap>0 then
        if osx<0 then osx=0
        if osx>60-_mwx then osx=60-_mwx
    endif
    if _mwx=60 then osx=0
    return osx
end function


function screenshot(a as short) as short
    savepng( tFile.screenshot_nextfilename("summary/" + tVersion.Gamedesig, ".png", 0), 0, 1) 'player.desig
    return 0
end function
