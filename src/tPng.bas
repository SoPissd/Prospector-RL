'tPng.
'
'defines:
'bswap=0, savepng=2
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
'     -=-=-=-=-=-=-=- TEST: tPng -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tPng -=-=-=-=-=-=-=-

declare function savepng( _
    byref filename as string = "screenshot.png", _
    byval image as any ptr = 0, _
    byval save_alpha as integer = 0) as integer

'private function bswap(byval n as uinteger) as uinteger

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tPng -=-=-=-=-=-=-=-

namespace tPng
function init() as Integer
	return 0
end function
end namespace'tPng


#define cut2top

'	ByRef filename As String = "screenshot.png", _
'	ByVal image As Any Ptr = 0, _
'	ByVal save_alpha As Integer = 0) As Integer

Const PNG_HEADER As String = !"\137PNG\r\n\26\n"
Const IHDR_CRC0 As UInteger = &ha8a1ae0a 'crc32(0, @"IHDR", 4)
Const PLTE_CRC0 As UInteger = &h4ba88955 'crc32(0, @"PLTE", 4)
Const IDAT_CRC0 As UInteger = &h35af061e 'crc32(0, @"IDAT", 4)
Const IEND_CRC0 As UInteger = &hae426082 'crc32(0, @"IEND", 4)

Type struct_ihdr Field = 1
    Width As UInteger
    height As UInteger
    bitdepth As UByte
    colortype As UByte
    compression As UByte
    filter As UByte
    interlace As UByte
End Type

Const IHDR_SIZE As UInteger = Sizeof( struct_ihdr )

'

function bswap(byval n as uinteger) as uinteger

    return (n and &h000000ff) shl 24 or _
    (n and &h0000ff00) shl 8  or _
    (n and &h00ff0000) shr 8  or _
    (n and &hff000000) shr 24

end function


'savepng create by counting_pine on the freebasic.net forum
'works as a drop in replacement for bsave
' usage savepng( filename, picture data, 1 for alpha 0 for no alpha)

function savepng( _
    byref filename as string = "screenshot.png", _
    byval image as any ptr = 0, _
    byval save_alpha as integer = 0) as integer


    dim as uinteger w, h, depth
    dim as integer f = freefile()
    dim as integer e

    if image <> 0 then
        if imageinfo( image, w, h, depth ) < 0 then return -1
        depth *= 8
    else
        if screenptr = 0 then return -1
        screeninfo( w, h, depth )
    end if

    if depth <> 32 then save_alpha = 0

    select case as const depth

    case 1 to 8

        scope

            dim ihdr as struct_ihdr = (bswap(w), bswap(h), 8, 3, 0, 0, 0)
            dim as uinteger ihdr_crc32 = crc32(IHDR_CRC0, cptr(ubyte ptr, @ihdr), sizeof(ihdr))

            dim palsize as uinteger = 1 shl depth
            dim pltesize as uinteger = palsize * 3
            dim plte(0 to 767) as ubyte
            dim plte_crc32 as uinteger

            dim as uinteger l = w + 1
            dim as uinteger imgsize = l * h
            dim as uinteger idatsize = imgsize + 11 + 5 * (imgsize \ 16383)
            dim imgdata(0 to imgsize - 1) as ubyte
            dim idat(0 to idatsize - 1) as ubyte
            dim as uinteger idat_crc32
            dim as uinteger x, y, col, r, g, b
            dim as uinteger index

            index = 0
            for col = 0 to palsize - 1
                palette get col, r, g, b
                plte(index) = r : index += 1
                plte(index) = g : index += 1
                plte(index) = b : index += 1
            next col

            plte_crc32 = crc32(PLTE_CRC0, @plte(0), pltesize)

            index = 0

            if image <> 0 then
                for y = 0 to h - 1
                    imgdata(index) = 0 : index += 1
                    for x = 0 to w - 1
                        col = point(x, y, image)
                        imgdata(index) = col : index += 1
                    next x
                next y
            else
                screenlock
                for y = 0 to h - 1
                    imgdata(index) = 0 : index += 1
                    for x = 0 to w - 1
                        col = point(x, y)
                        imgdata(index) = col : index += 1
                    next x
                next y
                screenunlock
            end if

            if compress2(@idat(0), @idatsize, @imgdata(0), imgsize, 9) then return -1
            idat_crc32 = crc32(IDAT_CRC0, @idat(0), idatsize)

            if open (filename for output as #f) then return -1

            e = put( #f, 1, PNG_HEADER )

            e orelse= put( #f, , bswap(IHDR_SIZE) )
            e orelse= put( #f, , "IHDR" )
            e orelse= put( #f, , ihdr )
            e orelse= put( #f, , bswap(ihdr_crc32) )

            e orelse= put( #f, , bswap(pltesize) )
            e orelse= put( #f, , "PLTE" )
            e orelse= put( #f, , plte(0), 3 * (1 shl depth) )
            e orelse= put( #f, , bswap(plte_crc32) )

            e orelse= put( #f, , bswap(idatsize) )
            e orelse= put( #f, , "IDAT" )
            e orelse= put( #f, , idat(0), idatsize )
            e orelse= put( #f, , bswap(idat_crc32) )

            e orelse= put( #f, , bswap(0) )
            e orelse= put( #f, , "IEND" )
            e orelse= put( #f, , bswap(IEND_CRC0) )

            close #f

            return e

        end scope

    case 9 to 32

        scope

            dim ihdr as struct_ihdr = (bswap(w), bswap(h), 8, iif( save_alpha, 6, 2), 0, 0, 0)
            dim as uinteger ihdr_crc32 = crc32(IHDR_CRC0, cptr(ubyte ptr, @ihdr), sizeof(ihdr))

            dim as uinteger l = iif(save_alpha, (w * 4) + 1, (w * 3) + 1)
            dim as uinteger imgsize = l * h
            dim as uinteger idatsize = imgsize + 11 + 5 * (imgsize \ 16383)
            dim imgdata(0 to imgsize - 1) as ubyte
            dim idat(0 to idatsize - 1) as ubyte
            dim as uinteger idat_crc32
            dim as uinteger x, y, col, r, g, b, a
            dim as uinteger index
            dim as integer ret

            index = 0

            if image <> 0 then
                for y = 0 to h - 1
                    imgdata(index) = 0 : index += 1
                    for x = 0 to w - 1
                        col = point(x, y, image)
                        r = col shr 16 and 255
                        g = col shr 8 and 255
                        b = col and 255
                        imgdata(index) = r : index += 1
                        imgdata(index) = g : index += 1
                        imgdata(index) = b : index += 1
                        if save_alpha then
                            a = col shr 24
                            imgdata(index) = a : index += 1
                        end if
                    next x
                next y
            else
                screenlock
                for y = 0 to h - 1
                    imgdata(index) = 0 : index += 1
                    for x = 0 to w - 1
                        col = point(x, y)
                        r = col shr 16 and 255
                        g = col shr 8 and 255
                        b = col and 255
                        imgdata(index) = r : index += 1
                        imgdata(index) = g : index += 1
                        imgdata(index) = b : index += 1
                        if save_alpha then
                            a = col shr 24
                            imgdata(index) = a : index += 1
                        end if
                    next x
                next y
                screenunlock
            end if

            if compress2(@idat(0), @idatsize, @imgdata(0), imgsize, 9) then return -1
            idat_crc32 = crc32(IDAT_CRC0, @idat(0), idatsize)

            if open (filename for output as #f) then return -1

            e = put( #f, 1, PNG_HEADER )

            e orelse= put( #f, , bswap(IHDR_SIZE) )
            e orelse= put( #f, , "IHDR" )
            e orelse= put( #f, , ihdr )
            e orelse= put( #f, , bswap(ihdr_crc32) )

            e orelse= put( #f, , bswap(idatsize) )
            e orelse= put( #f, , "IDAT" )
            e orelse= put( #f, , idat(0), idatsize )
            e orelse= put( #f, , bswap(idat_crc32) )

            e orelse= put( #f, , bswap(0) )
            e orelse= put( #f, , "IEND" )
            e orelse= put( #f, , bswap(IEND_CRC0) )

            close #f

            return e

        end scope

    case else

        return -1

    end select

end function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tPng -=-=-=-=-=-=-=-
	tModule.register("tPng",@tPng.init()) ',@tPng.load(),@tPng.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tPng -=-=-=-=-=-=-=-
#endif'test
