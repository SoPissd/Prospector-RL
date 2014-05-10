
'#Define NULL 0
'#Define FALSE 0
'#Define TRUE (Not FALSE)

Type _visit
    s As Short
    t As Integer
End Type

Type _transfer
    from As _cords
    dest As _cords
    tile As Short
    col As Short
    ti_no As UInteger
    oneway As Short
    discovered As Short
    desig As String*64
    tumod As Short 'the higher the more tunnels
    dimod As Short 'the higher the more digloops
    spmap As Short 'make specialmap if non0
    froti As Short 'from what tile
End Type

Dim Shared portal(1024) As _transfer
Dim Shared lastportal As Short



'Flag 28=techgoods delivered to star creatures
Type _ae
    c As _cords
    rad As Byte
    dam As Byte
    dur As Byte
    typ As Byte
End Type

Type _goods
    'n as string*16
    p As Single
    v As Single
    'test as single
    'test2 as single
End Type

Type _basis
    c As _cords
    discovered As Short
    inv(lastgood) As _goods
    'different companys for each station
    repname As String*32
    company As Byte
    spy As Byte
    shop(8) As Byte
    pricelevel As Single=1
    mapmod As Single
    biomod As Single
    resmod As Single
    pirmod As Single
    lastsighting As Short
    lastsightingdis As Short
    lastsightingturn As Short
    lastfight As Short
    docked As Short
End Type

Type _comment
    c As _cords
    t As String*32
    l As Short
End Type

Dim Shared coms(255) As _comment



Type _table
    points As Integer
    desig As String *80
    death As String *80
End Type


Type _disease
    no As UByte
    desig As String
    ldesc As String
    cause As String
    incubation As UByte
    duration As UByte
    fatality As UByte
    contagio As UByte
    causeknown As Byte
    cureknown As Byte
    att As Byte
    hal As Byte
    bli As Byte
    nac As Byte
    oxy As Byte
    wounds As Byte
End Type

Dim Shared disease(17) As _disease


Type _shipfire
    what As Short
    when As Short
    where As _cords
    tile As String*1
    stun As Byte
End Type


'type MODE
'  As Integer mode_num      '/* Current mode number */
'  As Byte Ptr ptr page      '/* Pages memory */
'  As Integer num_pages      '/* Number of requested pages */
'  As Integer work_page      '/* Current work page number */
'  As Byte Ptr framebuffer   '/* Our current visible framebuffer */
'  As Byte Ptr ptr Line      '/* Line pointers into current active framebuffer */
'  As Integer pitch      '/* Width of a framebuffer line in bytes */
'  As Integer target_pitch   '/* Width of current target buffer line in bytes */
'  As Any Ptr last_target   '/* Last target buffer set */
'  As Integer max_h      '/* Max registered height of target buffer */
'  As Integer bpp      '/* Bytes per pixel */
'  As Uinteger Ptr Palette   '/* Current RGB set__color( values for each palette index */
'  As Uinteger Ptr device_palette   '/* Current RGB set__color( values of visible device palette */
'  As Byte Ptr color_association   '/* Palette set__color( index associations for CGA/EGA emulation */
'  As Byte Ptr dirty               '/* Dirty lines buffer */
'  As Any Ptr driver      '/* Gfx driver in use */
'  As Integer w
'  As Integer h         '/* Current mode width and height */
'  As Integer depth      '/* Current mode depth */
'  As Integer color_mask      '/* set__color( bit mask for colordepth emulation */
'  As Any Ptr default_palette   '/* Default palette for current mode */
'  As Integer scanline_size   '/* Vertical size of a single scanline in pixels */
'  As Uinteger fg_color
'  As Uinteger bg_color      '/* Current foreground and background colors */
'  As Single last_x
'  As Single last_y      '/* Last pen position */
'  As Integer cursor_x
'  As Integer cursor_y      '/* Current graphical text cursor position (in chars, 0 based) */
'  As fonttype Ptr font      '/* Current font */
'  As Integer view_x
'  As Integer view_y
'  As Integer view_w
'  As Integer view_h      '/* VIEW coordinates */
'  As Single win_x
'  As Single win_y
'  As Single win_w
'  As Single win_h      '/* WINDOW coordinates */
'  As Integer text_w
'  As Integer text_h      '/* Graphical text console size in characters */
'  As Byte Ptr Key      '/* Keyboard states */
'  As Integer refresh_rate   '/* Driver refresh rate */
'  As Integer flags      '/* Status flags */
'End Type

'Extern fb_mode As MODE Ptr

'
'
'reward slots
'0 mapsinkm2
'1 Bio
'2 ressources
'3 Pirate ships
'4
'5 artifact transfer
'6 Pirate base
'7 mapsincredits
'8 Pirate outpost

