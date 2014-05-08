'tConfig

Declare function UpdateMapSize(size as short) as Short
Declare function SetCaptainsprite(nr as byte) as short
Declare function set_volume(volume as Integer) as short
Declare function rlprint(t as string, col as short=11) as short
Declare function menu(bg as byte,te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0,st as short=-1) as short
Declare Function getnumber(a As Integer,b As Integer, e As Integer) As Integer

Dim Shared As UByte _fohi1, _fohi2
Dim Shared As Byte _volume=2

Dim Shared As UByte sm_x=75
Dim Shared As UByte sm_y=50

Dim Shared vismask(sm_x,sm_y) As Byte
Dim Shared spacemap(sm_x,sm_y) As Short

Dim shared as ubyte wormhole=8
dim shared as ubyte laststar=90

Enum config
    con_empty
    con_res
    con_tiles
    con_gtmwx
    con_classic
    con_showvis
    con_captainsprite
    con_transitem
    con_onbar
    con_sysmaptiles
    con_customfonts
    con_chosebest
    con_autosale
    con_showrolls
    con_sound
    con_warnings
    con_damscream
    con_volume
    con_anykeyno
    con_diagonals
    con_altnum
    con_easy
    con_minsafe
    con_startrandom
    con_autosave
    con_savescumming
    con_restart
    con_end
End Enum

Dim Shared As Byte configflag(con_end-1)

'

Dim Shared As String configname(con_end-1)
configname(con_tiles)="tiles"
configname(con_gtmwx)="gtmwx"
configname(con_classic)="classic"
configname(con_showvis)="showvis"
configname(con_transitem)="transitem"
configname(con_onbar)="onbar"
configname(con_captainsprite)="captainsprite"
configname(con_sysmaptiles)="sysmaptiles"
configname(con_customfonts)="customfonts"
configname(con_chosebest)="chosebest"
configname(con_autosale)="autosale"
configname(con_sound)="sound"
configname(con_showrolls)="rolls"
configname(con_warnings)="warnings"
configname(con_damscream)="damscream"
configname(con_volume)="volume"
configname(con_anykeyno)="anykeyno"
configname(con_diagonals)="digonals"
configname(con_altnum)="altnum"
configname(con_easy)="easy"
configname(con_minsafe)="minsafe"
configname(con_startrandom)="startrandom"
configname(con_autosave)="autosave"
configname(con_savescumming)="savescumming"
configname(con_restart)="restart"

'

Dim Shared As String configdesc(con_end-1)
configdesc(con_showrolls)="/ Show rolls:"
configdesc(con_chosebest)="/ Always chose best item:"
configdesc(con_sound)="/ Sound effects:"
configdesc(con_diagonals)="/ Automatically chose diagonal:"
configdesc(con_autosale)="/ Always sell all:"
configdesc(con_startrandom)="/ Start with random ship:"
configdesc(con_autosave)="/ Autosave on entering station:"
configdesc(con_minsafe)="/ Minimum safe distance to pirate planets:"
configdesc(con_anykeyno)="/ Any key counts as no on yes-no questions:"
configdesc(con_restart)="/ Return to start menu on death:"
configdesc(con_warnings)="/ Navigational Warnings(Gasclouds & 1HP landings):"
configdesc(con_tiles)="/ Graphic tiles:"
configdesc(con_easy)="/ Easy start:"
configdesc(con_volume)="/ Volume (0-4):"
configdesc(con_res)="/ Resolution:"
configdesc(con_showvis)="/ Underlay for visible tiles:"
configdesc(con_onbar)="/ Starmap on bar:"
configdesc(con_classic)="/ Classic look:"
configdesc(con_altnum)="/ Alternative Numberinput:"
configdesc(con_transitem)="/ Transparent Items:"
configdesc(con_gtmwx)="/ Main window width(tile mode):"
configdesc(con_savescumming)="/ Savescumming:"
configdesc(con_sysmaptiles)="/ Use tiles for system map:"
configdesc(con_customfonts)="/ Customfonts:"
configdesc(con_damscream)="/ Damage scream:"

'

function save_config(oldtiles as short) as short
    dim as short f,i
    f=freefile
    i=open("config.txt", for output, as #f)
    if i<>0 then
    	return i    
    EndIf
    print #f,"# 0 is on, 1 is off"
    for i=con_tiles to con_end-1
        print #f,configname(i)&":"&configflag(i)
    next
    print #f,""
    print #f,"spacemapx:"&sm_x
    print #f,"spacemapy:"&sm_y
    print #f,"laststar:"&laststar
    print #f,"wormholes:"&wormhole
    print #f,"gtmwx:"&gt_mwx
    print #f,"_tix:"&_tix
    print #f,"_tiy:"&_tiy
    print #f,"tilefont:"&_FoHi1
    print #f,"textfont:"&_FoHi2
    print #f,"lines:"&_lines
    print #f,"volume:"&_volume
    close #f
    return 0
end function

function load_config() as short
    dim as short f,i,j
    dim as string text,rhs,lhs

    if fileexists("config.txt") then
        f=freefile
        open "config.txt" for input as #f
        print "loading config";
        do
            print ".";
            line input #f,text
            if instr(text,"#")=0 and len(text)>1 then
                text=lcase(text)

                j=instr(text,":")
                rhs=right(text,len(text)-j)
                lhs=left(text,j-1)

                for i=con_tiles to con_end-1
                    if lhs=configname(i) then
                        if val(rhs)=0 or rhs="on" then configflag(i)=0
                        if val(rhs)=1 or rhs="off" then configflag(i)=1
                        'print i;":";lhs;":";rhs ;":";configflag(i)
                    endif
                next

                if lhs="captainsprite" then configflag(con_captainsprite)=val(rhs)
                if instr(text,"wormhole")>0 then wormhole=numfromstr(text)
                if instr(text,"laststar")>0 then laststar=numfromstr(text)
                if instr(text,"spacemapx")>0 then sm_x=numfromstr(text)
                if instr(text,"spacemapy")>0 then sm_y=numfromstr(text)
                if instr(text,"_tix")>0 then _tix=numfromstr(text)
                if instr(text,"_tiy")>0 then _tiy=numfromstr(text)
                if instr(text,"gtmwx")>0 then gt_mwx=numfromstr(text)
                if instr(text,"tilefont")>0 then _FoHi1=numfromstr(text)
                if instr(text,"textfont")>0 then _FoHi2=numfromstr(text)
                if instr(text,"lines")>0 then _lines=numfromstr(text)
                if instr(text,"shipcolor")>0 then _shipcolor=numfromstr(text)
                if instr(text,"teamcolor")>0 then _teamcolor=numfromstr(text)


                if instr(text,"soun")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then configflag(con_sound)=0
                    if instr(text,"1")>0 or instr(text,"of") then configflag(con_sound)=1
                    if instr(text,"2")>0 or instr(text,"high") then configflag(con_sound)=2
                endif

                if instr(text,"volume")>0 then
                    if instr(text,"0")>0 then _volume=0
                    if instr(text,"1")>0 then _volume=1
                    if instr(text,"2")>0 then _volume=2
                    if instr(text,"3")>0 then _volume=3
                    if instr(text,"4")>0 then _volume=4
                endif

                if instr(text,"rolls")>0 then
                    if instr(text,"0")>0 then configflag(con_showrolls)=0
                    if instr(text,"1")>0 then configflag(con_showrolls)=1
                    if instr(text,"2")>0 then configflag(con_showrolls)=2
                endif

            endif
        loop until eof(f)
        close #f
    else
        color 15,0
        print "No Config.txt. Using default configuration"
        configflag(con_tiles)=0
        configflag(con_gtmwx)=40
        configflag(con_classic)=1
        configflag(con_showvis)=0
        configflag(con_transitem)=0
        configflag(con_onbar)=1
        configflag(con_sysmaptiles)=0
        configflag(con_customfonts)=0
        configflag(con_chosebest)=0
        configflag(con_autosale)=0
        configflag(con_sound)=0
        configflag(con_warnings)=0
        configflag(con_damscream)=0
        configflag(con_volume)=2
        configflag(con_anykeyno)=0
        configflag(con_diagonals)=1
        configflag(con_altnum)=1
        configflag(con_easy)=0
        configflag(con_minsafe)=0
        configflag(con_startrandom)=1
        configflag(con_autosave)=0
        configflag(con_savescumming)=0
        configflag(con_restart)=1
        gt_mwx=40
        _tix=24
        _tiy=24
        _Fohi1=18
        _Fohi2=16
        _lines=26
        _volume=1
		if save_config(configflag(con_tiles))=0 then 
			load_config()
		endif
    endif

	print
	print
	
    if configflag(con_tiles)=0 then
        _mwx=gt_mwx
    else
        _mwx=60
    endif
	set_volume(_volume)
    if sm_x>200 then sm_x=200
    if sm_y>200 then sm_y=200
    redim spacemap(sm_x,sm_y)
    redim vismask(sm_x,sm_y)
    if wormhole mod 2<>0 then wormhole+=1
    UpdateMapSize(laststar+wormhole+1)
    return 0
end function

function configuration() as short
    dim text as string
    dim onoff(1) as string
    dim offon(1) as string
    dim warn(2) as string
    dim sprite(2) as string
    dim res as string
    dim as short c,d,f,i
    dim oldtiles as byte
    oldtiles=configflag(con_tiles)
    onoff(0)=" On "
    onoff(1)=" Off"
    warn(0)="On  "
    warn(1)="Off "
    warn(2)="High"
    offon(0)=" Off"
    offon(1)=" On "
    sprite(0)="Brown"
    sprite(1)="White"
    sprite(2)=" Red "
    screenshot(1)
    do
        if configflag(con_customfonts)=1 then
            res="tiles:"&_fohi1 &" text:"& _fohi2 &" lines:"&_lines
        else
            res="classic"
        endif
        text="Prospector "&__VERSION__ &" Configuration"
        for i=1 to con_end-1
            select case i
            case con_volume
                text=text &"/ Volume (0-4):" & _volume
            case con_res
                text=text &"/ Resolution: "&res
            case con_gtmwx
                text=text &"/ Main window width(tile mode): "& gt_mwx
            case con_sound
                text=text &"/ Sound effects :"& warn(configflag(con_sound))
            case con_captainsprite
                text=text &"/ Captains sprite:"&sprite(configflag(con_captainsprite))
            case else
                text=text & configdesc(i) & onoff(configflag(i))
            end select
        next
        text=text &"/Exit"
        c=menu(bg_randompic,text,,,,1)
        select case c
        case con_sound,con_captainsprite
            configflag(c)+=1
            if configflag(c)>2 then configflag(c)=0
        case con_sound
            configflag(con_sound)=configflag(con_sound)+1
            if configflag(con_sound)=3 then configflag(con_sound)=0
        case con_volume
            rlprint "Select volume (0-4)"
            _volume=getnumber(0,4,_volume)
            set_volume(_volume)
        case con_res
            d=menu(bg_randompic,"Resolution/Tiles/Text/Lines/Classic look: "& onoff(configflag(con_customfonts))&" (overrides if on)/Exit")
            if d=1 then
                rlprint "Set graphic font height:(8-28)"
                _fohi1=Getnumber(8,28,_fohi1)
            endif
            if d=2 then
                rlprint "Set text font height:(8-28)"
                _fohi2=Getnumber(8,28,_fohi2)
            endif
            if d=3 then
                rlprint "Number of display lines:"
                _lines=Getnumber(22,33,_lines)
            endif
            if d=4 then
                select case configflag(con_customfonts)
                case is=1
                    configflag(con_customfonts)=0
                case is=0
                    configflag(con_customfonts)=1
                end select
            endif
            if _fohi2>_fohi1 then _fohi2=_fohi1
            rlprint "Resolution will be changed next time you start prospector."
        case con_gtmwx
            gt_mwx=getnumber(20,60,30)
            rlprint "Will be changed next time you start prospector."
        case con_end,-1 'Exit, do nothing
        case else
            select case configflag(c)
            case 1
                configflag(c)=0
            case 0
                configflag(c)=1
            end select
        end select

    loop until c=con_end or c=-1
    if gamerunning=1 then SetCaptainsprite(configflag(con_captainsprite))
    screenshot(2)
    return save_config(oldtiles)
end function

