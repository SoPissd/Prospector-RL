'tConfig.
'
'defines:
'explored_percentage_string=1, save_config=1, load_config=1,
', configuration=7
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
'     -=-=-=-=-=-=-=- TEST: tConfig -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tConfig -=-=-=-=-=-=-=-

declare function save_config(oldtiles as short) as short
declare function load_config() as short
declare function configuration() as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tConfig -=-=-=-=-=-=-=-

namespace tConfig
function init(iAction as integer) as integer
	configflag(con_restart)=1
	return 0
end function
end namespace'tConfig


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
'    print #f,"lines:"&_lines
    print #f,"volume:"&_volume
    close #f
    return 0
end function


function load_config() as short
    dim as short f,i,j,iLine
    dim as string text,rhs,lhs

    if fileexists("config.txt") then
        f=freefile
        open "config.txt" for input as #f
        print "loading config";
        do
        	iLine +=1
            if (iLine= (iLine\4)*4) then print ".";
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
'                if instr(text,"lines")>0 then _lines=numfromstr(text)
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
'        _lines=26
        _volume=1
		if save_config(configflag(con_tiles))=0 then 
			load_config()
		endif
    endif

	print
	
    if configflag(con_tiles)=0 then
        _mwx=gt_mwx
    else
        _mwx=60
    endif
	uSound.set(_volume)
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
'    screenshot(1)

    do
        if configflag(con_customfonts)=1 then
            res="tiles:"&_fohi1 &" text:"& _fohi2 '&" lines:"&_lines
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
        c=textmenu(text,,,,1)
  		'DbgPrint(c)
		'sleep
        select case c
        case con_end,-1,-27 'Exit, do nothing
		case con_sound,con_captainsprite
            configflag(c)+=1
            if configflag(c)>2 then configflag(c)=0
        case con_sound
            configflag(con_sound)=configflag(con_sound)+1
            if configflag(con_sound)=3 then configflag(con_sound)=0
        case con_volume
            rlprint "Select volume (0-4)"
            _volume=getnumber(0,4,_volume)
            uSound.set(_volume)
        case con_res
            d=textmenu(bg_randompic,"Resolution/Tiles/Text/Lines/Classic look: "& onoff(configflag(con_customfonts))&" (overrides if on)/Exit")
            if d=1 then
                rlprint "Set graphic font height:(8-28)"
                _fohi1=Getnumber(8,28,_fohi1)
            endif
            if d=2 then
                rlprint "Set text font height:(8-28)"
                _fohi2=Getnumber(8,28,_fohi2)
            endif
            if d=3 then
'                rlprint "Number of display lines:"
'                _lines=Getnumber(22,33,_lines)
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

        case else
            select case configflag(c)
            case 1
                configflag(c)=0
            case 0
                configflag(c)=1
            end select
        end select

    loop until (uConsole.Closing) or c=con_end or c=-1 or c=-27
'fail    if tVersion.gamerunning=1 then SetCaptainsprite(configflag(con_captainsprite))
'    screenshot(2)
    return save_config(oldtiles)
end function

#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tConfig -=-=-=-=-=-=-=-
	tModule.register("tConfig",@tConfig.init()) ',@tConfig.load(),@tConfig.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tConfig -=-=-=-=-=-=-=-
#endif'test
