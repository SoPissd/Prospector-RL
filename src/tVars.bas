'tVars

'Dim Key As String

Dim Shared pixelsize As Integer


Dim Shared bonesflag As Short
Dim Shared farthestexpedition As Integer
Dim Shared lastenemy As Short


Dim Shared As UInteger _fgcolor_,_bgcolor_

Dim Shared As Byte someonemoved
Dim Shared As Byte _tix=24
Dim Shared As Byte _tiy=24


Dim Shared As Byte _NoPB=2
Dim Shared As Short countpatrol,makepat,unattendedtribbles

Dim Shared As Byte _teamcolor=15
Dim Shared As Byte _shipcolor=14
Dim Shared As Byte _showspacemap=1

Dim Shared As Byte _hpdisplay=1


Dim Shared As Byte _autoinspect=1

Dim Shared As Byte _resolution=2
Dim Shared As Byte _lines=25
Dim Shared As Byte _textlines
Dim Shared As Byte _narrowscreen=0
Dim Shared As Byte gt_mwx=40
Dim Shared As Byte _showrolls=0
Dim Shared As Byte captainskill=-5
Dim Shared As Byte wage=10

Dim Shared As Byte com_cheat=0
Dim Shared As Short sidebar
dim shared as byte optoxy
Dim Shared As UInteger uid
Dim Shared As Short ranoutoffuel
Dim Shared As Short walking

Dim Shared As String itemcat(11) 
Dim Shared As String shopname(4)

Dim Shared As String goodsname(9)

Dim Shared goods_prices(9,12,12) As Single


Dim Shared bg_parent As Byte
Dim Shared location As Byte

Dim Shared battleslost(8,8) As Integer

Dim Shared adislastenemy As Short, adisdeadcounter As Short,adisloctime As Short,adisloctemp As Single


Dim Shared standardphrase(sp_last-1,2) As String
Dim Shared talent_desc(29) As String

Dim Shared palette_(255) As UInteger
Dim Shared _swidth As Byte=35'Length of line in a shop
Dim Shared lastapwp As Short
Dim Shared currapwp As Short
Dim Shared apdiff As Short

Dim Shared talent_desig(29) As String
Dim Shared evkey As FB.Event
'dim shared video as SDL_Surface ptr
Dim Shared ano_money As Short

Dim Shared baseprice(9) As Short
Dim Shared avgprice(9) As Single

Dim Shared spectraltype(10) As Short
Dim Shared spectralname(10) As String
Dim Shared scount(10) As Short
Dim Shared spectralshrt(10) As String




Dim Shared x As Short
Dim Shared y As Short

Dim Shared flag(20) As Short
Dim Shared zeit As Integer
Dim Shared stationroll As Short
Dim Shared companyname(5) As String
Dim Shared companynameshort(5) As String
Dim Shared shares(2048) As _share
Dim Shared lastshare As Short
Dim Shared combatmap(60,20) As Byte


Dim Shared _last_title_pic As Byte=14

Dim Shared makew(20,5) As Byte

Dim Shared gtiles(2048) As Any Ptr
Dim Shared stiles(9,68) As Any Ptr
Dim Shared shtiles(7,4) As Any Ptr
Dim Shared gt_no(4096) As Integer
Dim Shared scr As Any Ptr

Dim Shared rlprintline As Byte
Dim Shared bestaltdir(9,1) As Byte
Dim Shared piratebase(_NoPB) As Short 'Mapnumber of piratebase
Dim Shared atmdes(16) As String
Dim Shared displaytext(255) As String
Dim Shared dtextcol(255) As Short

Dim Shared patrolmod As Short

Dim Shared shiptypes(20) As String
Dim Shared disease(17) As _disease
Dim Shared awayteamcomp(4) As Byte

Dim Shared coms(255) As _comment
Dim Shared portal(1024) As _transfer
Dim Shared lastportal As Short
Dim Shared lastplanet As Short
Dim Shared lastcom As Short
Dim Shared As Byte pf_stp=1
Dim Shared lastwaypoint As Short
Dim Shared firstwaypoint As Short
Dim Shared firststationw As Short
Dim Shared lastfleet As Short
Dim Shared alienattacks As Integer
Dim Shared lastdrifting As Short=16
Dim Shared liplanet As Short 'last input planet
Dim Shared whtravelled As Short
Dim Shared whplanet As Short
Dim Shared vacuum(60,20) As Byte

Dim Shared tacdes(6) As String
Dim Shared shop_order(2) As Short
Dim Shared lastprobe As Short

Dim Shared endstory As String
Dim Shared crew_desig(16) As String
Dim Shared combon(9) As _company_bonus

Dim Shared ammotypename(4) As String

Dim Shared As String bountyquestreason(6)

Dim Shared As Short just_run


