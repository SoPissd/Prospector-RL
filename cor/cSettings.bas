'vSettings.
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
'     -=-=-=-=-=-=-=- TEST: vSettings -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
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


Dim Shared As UByte sm_x=75
Dim Shared As UByte sm_y=50
'''

Dim Shared As UByte _fohi1
Dim Shared As UByte _fohi2

Dim shared as ubyte wormhole=8
dim shared as ubyte laststar=90

Dim Shared vismask(sm_x,sm_y) As Byte
Dim Shared spacemap(sm_x,sm_y) As Short

Dim Shared As Byte _swidth=35'Length of line in a shop
Dim Shared As Short sidebar

'''
Dim Shared As Byte _volume=2

Dim Shared As Byte _tix=24
Dim Shared As Byte _tiy=24

Dim Shared As Byte gt_mwx=40

Dim Shared As Byte _teamcolor=15
Dim Shared As Byte _shipcolor=14

Dim Shared As Byte configflag(con_end-1)
Dim Shared As String configname(con_end-1)
Dim Shared As String configdesc(con_end-1)


Dim Shared As String*3 key_testspacecombat="\Cy"
Dim Shared As String*3 key_manual="?"
Dim Shared As String*3 key_messages="m"
Dim Shared As String*3 key_configuration="="
Dim Shared As String*3 key_autoinspect="I"
Dim Shared As String*3 key_autopickup="P"
Dim Shared As String*3 key_shipstatus="@"
Dim Shared As String*3 key_equipment="E"
Dim Shared As String*3 key_tactics="T"
Dim Shared As String*3 key_awayteam="A"
Dim Shared As String*3 key_quest="Q"
Dim Shared As String*3 key_tow="t"
Dim Shared As String*3 key_autoexplore="#"
Dim Shared As String*3 key_standing="\Cs"

Dim Shared As String*3 key_la="l"
Dim Shared As String*3 key_tala="\Cl"
Dim Shared As String*3 key_sc="s"
Dim Shared As String*3 key_save="S"
Dim Shared As String*3 key_quit="q"
'dim shared as string*3 key_D="D"
'dim shared as string*3 key_G="G"
Dim Shared As String*3 key_report="R"
Dim Shared As String*3 key_rename="C\r"
Dim Shared As String*3 key_dock="d"
Dim Shared As String*3 key_comment="c"
Dim Shared As String*3 key_dropshield="s"
Dim Shared As String*3 key_inspect="i"
Dim Shared As String*3 key_ex="x"
Dim Shared As String*3 key_ra="r"
Dim Shared As String*3 key_te="t"
Dim Shared As String*3 key_ju="j"
Dim Shared As String*3 key_co="c"
Dim Shared As String*3 key_of="o"
Dim Shared As String*3 key_gr="g"
Dim Shared As String*3 key_fi="f"
Dim Shared As String*3 key_autofire="F"
Dim Shared As String*3 key_he="h"
Dim Shared As String*3 key_walk="w"
Dim Shared As String*3 key_pickup=","
Dim Shared As String*3 key_drop="D"
Dim Shared As String*3 key_oxy="O"
Dim Shared As String*3 key_close="C"
Dim Shared As String*3 key_ac="a"
Dim Shared As String*3 key_ru="R"

Dim Shared As String*3 key_wait="5"
Dim Shared As String*3 key_layfire="f"
Dim Shared As String*3 key_portal="<"
Dim Shared As String*3 key_logbook="L"
Dim Shared As String*3 key_togglehpdisplay="\Ch"
Dim Shared As String*3 key_yes="y"
Dim Shared As String*3 key_wormholemap="W"
Dim Shared As String*3 key_togglemanjets="M"
Dim Shared As String*3 key_cheat="?"
Dim Shared As String*3 key_pageup="?"
Dim Shared As String*3 key_pagedown="?"
Dim Shared As String*3 no_key
Dim Shared As String*3 key_mfile="?"
Dim Shared As String*3 key_filter="f"
Dim Shared As String*3 key_extended="#"
Dim Shared As String*3 key_accounting="\Ca"
dim shared as string*3 key_optequip="e"

Dim Shared As Byte _autoinspect=1
Dim Shared As Byte _autopickup=1

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: vSettings -=-=-=-=-=-=-=-
#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: vSettings -=-=-=-=-=-=-=-

namespace vSettings
function init(iAction as integer) as integer
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
	return 0
end function
end namespace'vSettings


#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: vSettings -=-=-=-=-=-=-=-
	tModule.register("vSettings",@vSettings.init()) ',@vSettings.load(),@vSettings.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: vSettings -=-=-=-=-=-=-=-
#endif'test
