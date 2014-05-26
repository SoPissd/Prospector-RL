'tCrew.
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
'     -=-=-=-=-=-=-=- TEST: tCrew -=-=-=-=-=-=-=-
#undef intest

#include "file.bi"
#include "../utl/uDefines.bas"
#include "../utl/uModule.bas"
#include "../utl/uDefines.bas"
#include "../utl/uDebug.bas"
#include "../utl/uRng.bas"
#include "../utl/uCoords.bas"
#include "../utl/uIndex.bas"
#include "../utl/uMath.bas"
#include "../utl/uScreen.bas"
#include "../utl/uColor.bas"
#include "../utl/uUtils.bas"
#include "../utl/uTime.bas"
#include "../utl/uVersion.bas"
#include "../utl/uConsole.bas"
#include "../utl/uPrint.bas"
#include "../utl/uTextbox.bas"
#include "../utl/uFile.bas"
#include "../utl/uGraphics.bas"
#include "../utl/uMainmenu.bas"
#include "gUtils.bas"
#include "vTiledata.bas"
#include "vTiles.bas"
#include "vSettings.bas"
#include "sStars.bas"
#include "gEnergycounter.bas"
#include "gWeapon.bas"
#include "pMonster.bas"
#include "sCoords.bas"
#include "sPortal.bas"
#include "cItems.bas"
#include "cItem.bas"
#include "gShip.bas"
#include "gMenu.bas"
#include "vPlayer.bas"
#include "gBasis.bas"
#include "wMakeship.bas"
#include "cRetirement.bas"
#include "vInput.bas"
#include "gFaction.bas"
#include "gCivilisation.bas"
#include "pPlanet.bas"
#include "gCommandstring.bas"
#include "cCargo.bas"
#include "dSpacemap.bas"
#include "gFleet.bas"
#include "dPlanetmap.bas"
#include "cModifyitem.bas"
#include "wMakeitem.bas"
#include "wMakePlanet.bas"
#include "wSpecialPlanet.bas"
'#include "pRadio.bas"
#include "cShops.bas"
#include "cShipyard.bas"
#include "cArtifacts.bas"
#include "cQuest.bas"
#include "cPeople.bas"
#include "pDialog.bas"
#include "gCommunicate.bas"
#include "cTrading.bas"
#include "gPirates.bas"
#include "cQuests.bas"
#include "gFleet.bas"

'#include "pAwayteam.bas"

'#include "dParty.bas"


#define test
#endif'test


#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

Type _crewmember
    ICON As String*1
    n As String*20
    typ As Byte
    paymod As Byte
    hpmax As Byte
    hp As Byte
    disease As Byte
    incubation As UByte
    duration As UByte
    onship As Byte
    oldonship As Byte
    jp As Byte
    equips As Byte
    weap As Single
    blad As Single
    tohi As Single
    armo As Single
    atcost As Byte
    speed As Byte 'Unused as of now
    pref_ccweap As UInteger
    pref_lrweap As UInteger
    pref_armor As UInteger
    talents(29) As Byte
    augment(16) As Byte
    xp As Short
    morale As Short
    target As Short
    Time As Short
    bonus As Short
    price As Short
    baseskill(3) As Short
    story(10) As Byte
End Type

Dim Shared crew(255) As _crewmember
Dim Shared startingweapon As Byte 
Dim Shared crew_desig(16) As String

Dim Shared itemcat(11) As String  
Dim Shared unattendedtribbles As Short


#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tCrew -=-=-=-=-=-=-=-

declare function add_talent(cr as short, ta as short, value as single) as single
declare function tohit_gun(a as short) as short
declare function tohit_close(a as short) as short
declare function crew_bio(i as short) as string
declare function crew_html(c as _crewmember) as string
declare function crew_text(c as _crewmember) as string
declare function low_morale_message() as short
declare function countdeadofficers(sMax as short) as short
declare function equipment_value() as integer
declare function list_inventory() as string

declare function bunk_multi() as single
declare function changemoral(value as short, where as short) as short

declare function is_passenger(i as short) as short
declare function add_passenger(n as string,typ as short, price as short, bonus as short, target as short, sTime as short, gender as short) as short

declare function character_name(byref gender as byte) as string
declare function count_crew(crew() as _crewmember) as short

declare function get_item_list(invit() as _items, invnit()as short,ty as short=0,ty2 as short=0,ty3 as short=0,ty4 as short=0,noequip as short=0) as short
declare function get_item(ty as short=0,ty2 as short=0,byref num as short=0,noequ as short=0) as short
declare function items_table() as string

declare function skill_text(c as _crewmember) as string
declare function upgradehull(t as short,byref s as _ship,forced as short=0) as short
declare function buy_ship(st as short,ds as string,pr as short) as short
declare function used_ships() as short
declare function shipstatus(heading as short=0) as short
declare function recalcshipsbays() as short

declare function SetCaptainsprite(nr as Byte) as short
declare function captain_sprite() as short
declare function CaptainName() as string
declare function EnjoyConcert() as Integer
declare function Crewblock() as string

declare function haggle_(way as string) as single
declare function merchant() as single

declare function augment_text(c as _crewmember) as string
declare function infect(a as short,dis as short) as short

declare function rnd_crewmember(onship as short=0) as short
declare function eris_does() as short

'declare function item_assigned(i as short) as short
'declare function first_unused(i as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tCrew -=-=-=-=-=-=-=-

namespace tCrew
function init(iAction as integer) as integer
	pHaggle= @haggle_
	pMerchant= @merchant

	pCrewblock= @Crewblock
	pBuyShip= @buy_ship
	pIsPassenger= @is_passenger
	pAddpassenger= @add_passenger
	pCaptainName= @CaptainName
	pEnjoyConcert= @EnjoyConcert
	pGetitem= @get_item

    crew_desig(1)="Captain"
    crew_desig(2)="Pilot"
    crew_desig(3)="Gunner"
    crew_desig(4)="Science"
    crew_desig(5)="Doctor"
    crew_desig(6)="Green"
    crew_desig(7)="Veteran"
    crew_desig(8)="Elite"
    crew_desig(9)="Insect Warrior"
    crew_desig(10)="Cephalopod"
    crew_desig(11)="Neodog"
    crew_desig(12)="Neoape"
    crew_desig(13)="Robot"
    crew_desig(14)="Squad Leader"
    crew_desig(15)="Sniper"
    crew_desig(16)="Paramedic"

    itemcat(0)="None"
    itemcat(1)="Transport"
    itemcat(2)="Ranged Weapons"
    itemcat(3)="Armor"
    itemcat(4)="Close combat weapons"
    itemcat(5)="Medical supplies"
    itemcat(6)="Grenades"
    itemcat(7)="Artwork"
    itemcat(8)="Resources"
    itemcat(9)="Equipment"
    itemcat(10)="Space ship equipment"
    itemcat(11)="Miscellaneous"

 	return 0
end function
end namespace'tCrew


'Declare function best_crew(skill As Short,no As Short) As Short



function SetCaptainsprite(nr as Byte) as short
	crew(1).story(3)=nr
	return 0
End function
    	
function CaptainName() as string
	return crew(1).n
End function
    	

function rnd_crewmember(onship as short=0) as short
    dim pot(128) as short
    dim as short p,a
    for a=0 to 128
        if crew(a).hp>0 and crew(a).onship=onship then
            p+=1
            pot(p)=a
        endif
    next
    return pot(rnd_range(1,p))
end function

function UnAugmentRandomCrewmember() as string
	dim as integer a,b
    a=rnd_crewmember
    for b=1 to 12
        crew(a).augment(b)=0
    next
    return crew(a).n
end function     
    	

function EnjoyConcert() as Integer
	dim as integer a,h,hc	
    for a=2 to 128
        if crew(a).hp>0 and rnd_range(1,20)<12+add_talent(1,4,5) then 
            h=a
            hc+=1
            crew(a).morale+=rnd_range(1,4)+add_talent(1,4,1)
        endif
    next
    rlprint "You enjoy a show with your crew."
    if hc>1 then rlprint "Some in your crew seem to enjoy it.",c_gre
    if hc=1 then rlprint crew(h).n &" seems to enjoy it.",c_gre
    return hc	
End Function
    	

function character_name(byref gender as byte) as string
    dim as string n,fn(200),ln(200),st
    dim as short f,lastfn,lastln,fnn,lnn
    f=freefile
    open "data/crewnames.txt" for input as #f
    do
        ln(lastln)=st
        lastln+=1
        line input #f,st
    loop until st="####"
    st=""
    do
        fn(lastfn)=st
        lastfn+=1
        line input #f,st
    loop until eof(f)
    st=""
    close #f
    lastfn-=1
    lastln-=1
    lnn=rnd_range(1,lastln)
    fnn=rnd_range(1,lastfn)
    if rnd_range(1,100)<80 then
        n=fn(fnn) &" "&ln(lnn)
    else
        n=fn(fnn) &" "&CHR(rnd_range(65,87))&". " &ln(lnn)
    endif
    if fnn<=23 then
        gender=0 'Female
    else
        gender=1 'Male
    endif
    return n
end function


function add_talent(cr as short, ta as short, value as single) as single
    dim total as short
    if cr>=0 then
        if crew(cr).hp>0 and crew(cr).talents(ta)>0 and ta=10 then
            if player.tactic>0 then return crew(cr).talents(ta)
            if player.tactic<0 then return -crew(cr).talents(ta)
            return 0
        endif
        if crew(cr).hp>0 and crew(cr).talents(ta)>0 then return value*crew(cr).talents(ta)
    else
        value=0
        for cr=1 to 128
            if crew(cr).hp>0 and crew(cr).onship=0 then
                total+=1
                value=value+crew(cr).talents(ta)
                if ta=24 then value=value+crew(cr).augment(4) 'Speed
            endif
        next
        if total=0 then return 0
        value=value/total
        return value
    endif
    return 0
end function


function tohit_gun(a as short) as short
    return crew(a).augment(1)+crew(a).talents(28)*3-crew(a).talents(29)*7+add_talent(3,10,1)+add_talent(3,11,1)+add_talent(a,23,1)+maximum(0,player.gunner(1))
end function

function tohit_close(a as short) as short
    return add_talent(3,10,1)+crew(a).talents(28)*3+add_talent(a,21,1)+crew(a).hp-crew(a).talents(29)*7
end function


function crew_bio(i as short) as string
    DimDebugL(0)'1
    dim t as string
    dim as short a
    
    if crew(i).typ<=9 or (crew(i).typ>=14 and crew(i).typ<=16) then
        t="Age:"& 18+crew(i).story(6) &" Size: 1."& 60+crew(i).story(7)*4 &"m Weight:" &50+crew(i).story(8)*4+crew(i).story(7) &"kg. ||"
        select case crew(i).story(0)
        case is =1
            t=t &"Place of Birth: Spaceship in transit"
        case is =2
            t=t &"Place of Birth: Earth"
        case is =3
            t=t &"Place of Birth: Sol system colony"
        case is =4
            t=t &"Place of Birth: Space station"
        case else
            t=t &"Place of Birth: Colony"
        end select
        t=t &" |Education: " &4+fix(crew(i).story(1)/2) &" years. "
        t=t &" |Work experience: " &cint(crew(i).story(2)/3) &" years. |"
        t=t &" ||To hit gun:"&tohit_gun(i) &"|To hit cc:"&tohit_close(i) &"||"
        select case crew(i).morale
        case is >100
            t=t &"Morale :D"
        case 60 to 100
            t=t &"Morale :)"
        case 40 to 59
            t=t &"Morale :/"
        case is <40
            t=t &"Morale :("
        end select
        select case crew(i).story(9)
        case 1 to 3
            t=t &" |Has a girlfriend/boyfriend on station "&crew(i).story(9)
        case 4 to 6
            t=t &" |Has a wife/husband on station "&crew(i).story(9)-3
        end select

        for a=1 to 25
            if crew(i).talents(a)>0 then
                t=t &" | "
                exit for
            endif
        next

        for a=1 to 25
            if crew(i).talents(a)>0 then t=t &" |"& talent_desc(a)
        next
        
#if __FB_DEBUG__
        if debug=1 then
            if crew(i).story(10)=0 then
                t=t & "W"
            else
                t=t & "M"
            endif
        endif
#endif

    endif
    if crew(i).target<>0 then t="Passenger for station "&crew(i).target &"."
    return t
end function

function count_crew(crew() as _crewmember) as short
    dim as short b,last
    for b=1 to 128
        if crew(b).hpmax>0 then last+=1
    next
    return last
end function



function augment_text(c as _crewmember) as string
    dim augments as string

    if c.augment(1)=1 then augments=augments &"Targeting "
    if c.augment(1)=2 then augments=augments &"Targeting II "
    if c.augment(1)=3 then augments=augments &"Targeting III "
    if c.augment(2)=1 then augments=augments &"Muscle Enh. "
    if c.augment(2)=2 then augments=augments &"Muscle Enh. II "
    if c.augment(2)=3 then augments=augments &"Muscle Enh. III "
    if c.augment(3)>0 then augments=augments &"Imp. Lungs "
    if c.augment(4)>0 then augments=augments &"Speed Enh. "
    if c.augment(5)=1 then augments=augments &"Exoskeleton "
    if c.augment(5)=2 then augments=augments &"Exosceleton II "
    if c.augment(5)=3 then augments=augments &"Exosceleton III "
    if c.augment(6)=1 then augments=augments &"Improved Metabolism "
    if c.augment(6)=2 then augments=augments &"Improved Metabolism II "
    if c.augment(6)=3 then augments=augments &"Improved Metabolism III "
    if c.augment(7)>0 then augments=augments &"FloatLegs "
    if c.augment(8)>0 then augments=augments &"Jetpack "
    if c.augment(9)>0 then augments=augments &"Chameleon Skin "
    if c.augment(10)>0 then augments=augments &"Neural Computer "
    if c.augment(11)>0 then augments=augments &"Loyality Chip "
    if c.augment(12)>0 then augments=augments &"Synthetic Nerves "
    return augments
end function



function skill_text(c as _crewmember) as string
    dim skills as string
    dim a as short
    for a=1 to 26
        if c.talents(a)>0 then
            if skills<>"" then
                skills=skills &", "&talent_desig(a)&"("&c.talents(a)&")"
            else
                skills=talent_desig(a)&"("&c.talents(a)&")"
            endif
        endif
    next
    return skills
end function


function crew_html(c as _crewmember) as string
    dim as string t,cstring,augments,skills
    t="<div style="&chr(34) &"color:#FFFFFF; font-family:verdana" &chr(34)&">"
    if c.hp>0 then
        t=t & html_color("#ffffff",,80)
        if c.talents(27)>0 then t=t & "Squ.Ld "
        if c.talents(28)>0 then t=t & "Sniper "
        if c.talents(29)>0 then t=t & "Paramd "
        if c.typ=1 then t=t & "Captain "
        if c.typ=2 then t=t & "Pilot   "
        if c.typ=3 then t=t & "Gunner  "
        if c.typ=4 then t=t & "Science "
        if c.typ=5 then t=t & "Doctor  "
        if c.typ=6 then t=t & "Green   "
        if c.typ=7 then t=t & "Veteran "
        if c.typ=8 then t=t & "Elite   "
    else
        t=t & html_color("#FF0000",,80) &"X"
    endif
    t=t &"</span>"
    select case c.hp
    case is=c.hpmax
        cstring="#00FF00"
    case 1 to c.hpmax-1
        cstring="#FFFF00"
    case else
        cstring="#FF0000"
    end select
    t=t & html_color(cstring) &c.hpmax &"</span>"& html_color("#ffffff") &"/</span>"& html_color(cstring)&c.hp &"</span>"
    t=t &" "& html_color("#FFFFFF",,180)&" "& c.n  &"</span>"
    if c.hp<=0 then
        t=t & html_color ("#FF0000",,100) &" Dead"
    else
        if c.onship=0 then
            t=t & html_color("#00FF00",,100) &" Awayteam "
        else
            t=t & html_color("#FFFF00",,100) &" On Ship "
        endif
    endif

    t=t & "</span>" & html_color("#FFFFFF",,20) &"XP:"&c.xp &"</span><br> &nbsp;&nbsp;&nbsp;" '
    if c.armo>0 then
        t=t & html_color("#FFFFFF") &item(c.armo).desig &"</span>"
    else
        t=t & html_color("#FFFF00")&"None"&"</span>"
    endif
    t=t &", "
    if c.weap>0 then
        t=t & html_color("#FFFFFF") &item(c.weap).desig &"</span>"
    else
        t=t & html_color("#FFFF00")&"None"&"</span>"
    endif
    t=t &", "

    if c.blad>0 then
        t=t & html_color("#FFFFFF")&item(c.blad).desig &"</span>"
    else
        t=t & html_color("#FFFF00")&"None"&"</span>"
    endif
    t=t &"<br>"& html_color("#FFFFFF")
    augments=augment_text(c)
    skills=skill_text(c)
    if skills<>"" then t=t &skills &" "
    if augments<>"" then t=t &augments
    if skills<>"" or augments<>"" then t=t &"<br>"
    t=t &"</span></div><br>"
    return t
end function



function crew_text(c as _crewmember) as string
    dim as string t,cstring,augments,skills
    if c.hp>0 then
        t=t &"{15}"
        if c.talents(27)>0 then t=t & "Squ.Ld "
        if c.talents(28)>0 then t=t & "Sniper "
        if c.talents(29)>0 then t=t & "Paramd "
        if c.typ=1 then t=t & "Captain "
        if c.typ=2 then t=t & "Pilot   "
        if c.typ=3 then t=t & "Gunner  "
        if c.typ=4 then t=t & "Science "
        if c.typ=5 then t=t & "Doctor  "
        if c.typ=6 then t=t & "Green   "
        if c.typ=7 then t=t & "Veteran "
        if c.typ=8 then t=t & "Elite   "
    else
        t="{12}X "
    endif

    select case c.hp
    case is=c.hpmax
        cstring="{10}"
    case 1 to c.hpmax-1
        cstring="{14}"
    case else
        cstring="{12}"
    end select
    t=t & cstring &c.hpmax &"{15}" &"/"& cstring &c.hp
    t=t &" "& "{15}"&" "& space(45-len(t)-len(trim(c.n)))&c.n
    if c.hp<=0 then
        t=t &"{12} Dead "
    else
        if c.onship=0 then
            t=t & "{10} Awayteam "
        else
            t=t & "{14} On Ship "
        endif
    endif

    t=t & "{15}XP:"&c.xp &"|"
    if c.armo>0 then
        t=t & "{11}" &item(c.armo).desig
    else
        t=t & "{14}None"
    endif
    t=t &", "
    if c.weap>0 then
        t=t & "{11}" &item(c.weap).desig
    else
        t=t & "{14}None"
    endif

    t=t &", "

    if c.blad>0 then
        t=t & "{11}" &item(c.blad).desig
    else
        t=t & "{14}None"
    endif

    t=t &"|{15}"
    augments=augment_text(c)
    skills=skill_text(c)
    if skills<>"" then t=t &skills &" "
    if augments<>"" then t=t &augments
    if skills<>"" or augments<>"" then t=t &"|"
    t=t &"|"

    return t
end function


function low_morale_message() as short
    dim as short a,total,average,crewmembers,who,dead
    dim as string hesheit,hishersits,himselfherself
    for a=2 to 128
        if crew(a).hp>0 then
            total+=crew(a).morale+add_talent(1,4,10)
            crewmembers+=1
        else
            dead=a
        endif
    next
    average=total/crewmembers
    who=rnd_range(2,crewmembers)
    if crew(who).story(10)=0 then
        hesheit="she"
        hishersits="her"
        himselfherself="herself"
    endif
    if crew(who).story(10)=1 then
        hesheit="he"
        hishersits="his"
        himselfherself="himself"
    endif
    if crew(who).story(10)=2 then
        hesheit="it"
        hishersits="its"
        himselfherself="itself"
    endif
    if rnd_range(1,100)>10+average then return 0
    select case average
        case is<10
            select case rnd_range(1,10)
                case is=1
                    rlprint crew(who).n &" thinks aloud about 'retiring the captain by plasma rifle'"
                case is=2
                    rlprint "Somebody has painted a message on an airlock:'Crew to captain: Home is this way.'"
                case is=3
                    rlprint crew(who).n &" throws his food in your direction."
                case is=4
                    rlprint "You overhear a group of crewmen talking about mutiny"
                case is=5
                    rlprint crew(who).n &" has a nervous breakdown."
                case is=6
                    rlprint crew(who).n &" freaks out, certain that the whole crew is going to die horribly."
                case is=7
                    rlprint "You catch " &crew(who).n &" staring down the barrel of " & hishersits & " gun."
                case is=8
                    rlprint crew(who).n &" wonders aloud about whether " & hishersits & " uniform is strong enough to hang " & himselfherself & " with."
                case is=9
                    rlprint crew(who).n &" rants about how there's no adventure out here, only death and horror."
                case is=10
                    rlprint crew(who).n &" rants about how you're the worst captain ever, and that you couldn't command your way out of a wet paper bag."

            end select
        case 11 to 20
            select case rnd_range(1,16)
                case is=1
                    rlprint "A fight breaks out about the quality of the food."
                case is=2
                    rlprint "You hear "& crew(who).n &" mutter 'Why don't you do it yourself, my captain?' before following your order."
                case is=3
                    rlprint "Your speech on tardiness on duty is met with little interest."
                case is=4
                    rlprint "You learn that the crew has renamed the ship, and it is ... colorfull"
                case is=5
                    rlprint crew(who).n &" states that " & hesheit & " will quit the next time you dock, and that everybody who still has a full set of marbles should join him."
                case is=6
                    rlprint crew(who).n &" greets you with 'What suicide mission will it be today?'"
                case is=7
                    rlprint "A fight breaks out over the away team equipment."
                case is=8
                    rlprint "A fight breaks out over the quality of the crew quarters."
                case is=9
                    rlprint "A fight breaks out over which crew member has made the most mistakes so far."
                case is=10
                    rlprint "A fight breaks out over who *needs* cybernetic implants."
                case is=11
                    rlprint "A fight breaks out over who is getting the most pay."
                case is=12
                    rlprint "A fight breaks out over the set__color( of the ship's paint."
                case is=13
                    rlprint "You catch " &crew(who).n &" drinking at " & hishersits & " post."
                case is=14
                    rlprint crew(who).n &" wishes aloud that he had better equipment... or a better leader."
                case is=15
                    rlprint crew(who).n &" wonders aloud about whether any amount of money could be worth *this*."
                case is=16
                    rlprint crew(who).n &" obsessively reviews " & hishersits & " last will and testament."

            end select
        case 21 to 30
            select case rnd_range(1,10)
                case is=1
                    rlprint crew(who).n &" tells you that there is a rather mean joke going around about you."
                case is=2
                    rlprint crew(who).n &" asks if he can get a raise."
                case is=3
                    rlprint crew(who).n &" reassures you that everybody is 100% behind your decions, no matter what some may say."
                case is=4
                    rlprint crew(who).n &" reminds you that everybody makes mistakes, at least some of the time"
                case is=5
                    if dead<>0 then rlprint crew(who).n &" is certain that the death of "&crew(dead).n &" was unavoidable."
                case is=6
                    rlprint crew(who).n &" is certain that the pay he receives will be better as soon as the ships ventures are a little more successfull."
                case is=7
                    rlprint crew(who).n &" mutters something about how this kind of thing was a lot more fun as a holodeck simulation."
                case is=8
                    rlprint crew(who).n &" seems a little skittish... more so than when " & hesheit & " first signed on."
                case is=9
                    rlprint crew(who).n &" says 'Hey, buck up. We're not dead yet, right? ...Right?'"
                case is=10
                    rlprint crew(who).n &" complains about " & hishersits & " spacesuit not fitting right."
            end select
        case 110 to 120
            if rnd_range(1,100)<5 then
                select case rnd_range(1,11)
                    case is=1
                        rlprint crew(who).n &" starts whistling."
                    case is=2
                        rlprint crew(who).n &" tells everybody about the special paintjob " & hesheit & " plans to get for " & hishersits & " spacesuit."
                    case is=3
                        rlprint crew(who).n &" thinks this will be one of the more profitable hauls."
                    case is=4
                        rlprint crew(who).n &" bores everyone to tears by explaining in depth how " & hesheit & " will invest enough to get a retirement pension out of " & hishersits & " (great) wage."
                    case is=5
                        rlprint crew(who).n &" asks excitedly what everyone thinks what we are going to find next!"
                    case is=6
                        rlprint crew(who).n &" offers to put this really great series on the ships entertainment system."
                    case is=7
                        rlprint crew(who).n &" starts talking about this great book he just read."
                    case is=8
                        rlprint crew(who).n &" really liked what was for supper yesterday."
                    case is=9
                        rlprint crew(who).n &" points out that the doc did a really good job on that wound" & hesheit & " got that one time."
                    case is=10
                        rlprint crew(who).n &" tells a really funny joke."
                    case is=11
                        rlprint crew(who).n &" has no complaints."
                end select
            endif
        case is>120
            if rnd_range(1,100)<5 then
            select case rnd_range(1,4)
                case is=1
                    rlprint crew(who).n &" thinks this expedition is going great so far."
                case is=2
                    rlprint crew(who).n &" tells a funny joke."
                case is=3
                    rlprint crew(who).n &" thinks you are the best captain ever!"
                case is=4
                    rlprint crew(who).n &" explains that he never earned as much money as here."
                case is=5
                    rlprint crew(who).n &" is certain the next thing we are going to find is going to be an artifact or something else equally cool!"
            end select
            endif
    end select
    return 0
end function


function Crewblock() as string
    dim as short c1,c2,c3,c4,c5,c6,c7,c8,sick,a
    for a=6 to 128
       if crew(a).typ=6 then c1=c1+1
       if crew(a).typ=7 then c2=c2+1
       if crew(a).typ=8 then c3=c3+1
       if crew(a).typ=9 then c4=c4+1
       if crew(a).typ=10 then c5=c5+1
       if crew(a).typ=11 then c6=c6+1
       if crew(a).typ=12 then c7=c7+1
       if crew(a).typ=13 then c8=c8+1
       if crew(a).disease>0 then sick+=1
    next
    dim t as string
    t="{15}Crew Summary |"
    t=t & "{15} | Pilot   :{11}"
    if player.pilot(0)<=0 then
        t=t &"{12}-"
    else
        t=t &player.pilot(0)
    endif
    t=t & "{15} | Gunner  :{11}"
    if player.gunner(0)<=0 then
        t=t &"{12}-"
    else
        t=t &player.gunner(0)
    endif
    t=t & "{15} | Science :{11}"
    if player.science(0)<=0 then
        t=t &"{12}-"
    else
        t=t &player.science(0)
    endif
    t=t & "{15} | Doctor  :{11}"
    if player.doctor(0)<=0 then
        t=t &"{12}-"
    else
        t=t &player.doctor(0)
    endif
    t = t & "{15} || Total bunks:{11}"&player.h_maxcrew+player.crewpod
    if player.cryo>0 then t=t &"{15}| Cryo Chambers:{11}"&player.cryo
    t=t &"{15} || Security :{11}"&c1+c2+c3+c4+c5+c6+c7+c8
    t=t &"{15} | Green    :{11}"&c1
    t=t &"{15} | Veterans :{11}"&c2
    t=t &"{15} | Elite    :{11}"&c3
    if c4>0 then t=t &"{15} | Insectw  :{11}"&c4
    if c5>0 then t=t &"{15} | Cephalop.:{11}"&c5
    if c6>0 then t=t &"{15} | Neodog   :{11}"&c6
    if c7>0 then t=t &"{15} | Neoape   :{11}"&c7
    if c8>0 then t=t &"{15} | Robot    :{11}"&c8
    if sick>0 then t=t &"{14}|| Sick:"&sick
    return t
end function


function countdeadofficers(sMax as short) as short
    dim r as short
    dim all as short
    dim a as short
    dim o as short
    if crew(1).hp>0 then return 0
    for a=2 to 6
        if crew(a).hp<=0 and crew(1).onship=0 then o+=1
    next
    if sMax>=7 then
        for a=7 to sMax
            if crew(a).hp>0 and crew(1).onship=0 then r+=1
        next
    else
        r=-1
    endif
    if o=0 then
        return 0
    endif

    if r=-1 then 
        return 0
    else
        if crew(1).hp<=0 then 
            o=o+5
        else
            o-=1
        endif
        return r-o*10
    endif
        
    return r
end function



function get_item_list(invit() as _items, invnit()as short,ty as short=0,ty2 as short=0,ty3 as short=0,ty4 as short=0,noequip as short=0) as short
    DimDebug(0)
    dim as short b,a,set,lastinv,lastinv2,swapflag,tylabel,c,f,equipnum(1024),isequipment
    dim as _items inv(ubound(invit))
    dim as Short invn(ubound(invit))

    if noequip=1 then
        noequip=0
        for a=0 to 128
            if crew(a).blad>0 then
                noequip+=1
                equipnum(noequip)=crew(a).blad
            endif
            if crew(a).weap>0 then
                noequip+=1
                equipnum(noequip)=crew(a).weap
            endif
            if crew(a).armo>0 then
                noequip+=1
                equipnum(noequip)=crew(a).armo
            endif
            if crew(a).pref_lrweap>0 then
                noequip+=1
                equipnum(noequip)=uid_pos(crew(a).pref_lrweap)
            endif
            if crew(a).pref_ccweap>0 then
                noequip+=1
                equipnum(noequip)=uid_pos(crew(a).pref_ccweap)
            endif
            if crew(a).pref_armor>0 then
                noequip+=1
                equipnum(noequip)=uid_pos(crew(a).pref_armor)
            endif
        next
        for a=0 to lastitem
            if item(a).w.s=-2 then 
                noequip+=1
                equipnum(noequip)=a
            endif
        next
    endif
        
    for a=0 to lastitem
        
        if item(a).w.s<0 and ((ty=0 and ty2=0 and ty3=0 and ty4=0) or (item(a).ty=ty or item(a).ty=ty2 or item(a).ty=ty3 or item(a).ty=ty4)) then 'Item on ship
            
            if noequip>0 then
                for b=1 to noequip
                    if equipnum(b)=a then isequipment=1
                next
            endif
            if not(isequipment=1 and noequip=1) then 
                set=0
                if lastinv>0 then
                    for b=1 to lastinv
                        if a<>inv(b).w.s then
                            
                            if inv(b).id=item(a).id and inv(b).ty=item(a).ty and item(a).ty<>15 then
								invn(b)+=1
                               	set=1
#if __FB_DEBUG__
                                if debug=22 then inv(b).desigp &=a
                                if debug=22 then
                                	f=freefile
                                    open "itemadded.txt" for append as #f
                                    print #f,a &";"& b &";"& item(a).desig  &";"& item(a).id &"invn"&invn(b)&"?"& inv(b).desig
                                    close #f
                                endif
#endif
                            endif
                            if item(a).ty=15 then
                                if inv(b).ty=15 and inv(b).v2=item(a).v2 and inv(b).v1=item(a).v1 then
                                    
                                    invn(b)+=1
                                    set=1
                                endif
                            endif
                        endif
                    next
                endif
                if set=0 then                                   
                    lastinv+=1
                    inv(lastinv)=item(a)
                    inv(lastinv).w.s=a
                    invn(lastinv)=1                   
                endif
            endif
        endif
#if __FB_DEBUG__
        if debug=22 then
            f=freefile
            open "GILitems.txt" for append as #f
            print #f,"Turn "&a
            for c=1 to lastinv
                print #f,c &";"& inv(c).desig &";"&invn(c)
            next
            close #f
        endif
#endif
    next
#if __FB_DEBUG__
    if debug=22 then
		f=freefile
        open "itemadded.txt" for append as #f
        print #f,"####"
        for a=1 to lastinv
            print #f,a &";"& inv(a).desig  &";"& inv(a).id &"invn"&invn(a)
        next
        print #f,"####"
        close #f
    endif
#endif
        
    for a=1 to lastinv
        if inv(a).ty=2 then 
            inv(a).desig &=" [A:"&inv(a).v3 &" D:"&inv(a).v1 &" R:"&inv(a).v2 &"]"
            inv(a).desigp &=" [A:"&inv(a).v3 &" D:"&inv(a).v1 &" R:"&inv(a).v2 &"]"
        endif
        if inv(a).ty=4 then
            inv(a).desig &=" [A:"&inv(a).v3 &" D:"&inv(a).v1  &"]"
            inv(a).desigp &=" [A:"&inv(a).v3 &" D:"&inv(a).v1  &"]"
        endif
        if inv(a).ty=3 or inv(a).ty=103 then 
            inv(a).desig &=" [PV:"&inv(a).v1 &"]"
            inv(a).desigp &=" [PV:"&inv(a).v1 &"]"
        endif
        if inv(a).ty=15 then 
            inv(a).desig &=" ["&inv(a).v2*3 &" kg]"
            inv(a).desigp &=" ["&inv(a).v2*3 &" kg]"
        endif
    next
    
    for b=1 to 11
        swapflag=0
        for a=1 to lastinv
            if check_item_filter(inv(a).ty,b) then
                swapflag=1
            endif
        next
        if swapflag=1 then
            c+=1
            invit(c).desig=itemcat(b)
            invnit(c)=-1
            for a=1 to lastinv
                if check_item_filter(inv(a).ty,b) then
                    c+=1
                    invit(c)=inv(a)
                    invnit(c)=invn(a)
#if __FB_DEBUG__
                    if debug=22 then
                       f=freefile
                       open "itemadded.txt" for append as #f
                       print #f,c &";"& invit(c).desig  &"; invn"&invnit(c)
                       close #f
                    endif
#endif
                endif
            next
        endif
    next
    
'    do
'        swapflag=0
'        for b=0 to lastinv-1
'            if inv(b).ty>inv(b+1).ty or (inv(b).ty=inv(b+1).ty and better_item(inv(b),inv(b+1))=1) then 
'                swap inv(b),inv(b+1)
'                swap invn(b),invn(b+1)
'                if inv(b).ty<>inv(b+1).ty then swapflag=1
'            endif
'        next
'    loop until swapflag=0
'    do
'        tylabel+=1
'        for a=0 to lastinv
'            if check_item_filter(inv(a).ty,tylabel) then
'                'Push down one
'                lastinv+=1
'                for b=lastinv to a+1 step -1
'                    invn(b)=invn(b-1)
'                    inv(b)=inv(b-1)
'                next
'                invn(a)=-1
'                'insert label
'                if tylabel<11 then
'                    inv(a).desig=itemcat(tylabel)
'                    tylabel+=1
'                else
'                    tylabel=126
'                    inv(a).desig=itemcat(5)
'                endif
'            endif
'        next
'    loop until tylabel>125
    return c
end function



function get_item(ty as short=0,ty2 as short=0,byref num as short=0,noequ as short=0) as short
    dim as short last,i,c,j
    dim as _items inv(1024)
    dim as short invn(1024)
    dim as string key,helptext
    static as short marked=0
    
    i=1
    DbgPrint("Getting itemlist:ty:"&ty &"ty2"&ty2)
    last=get_item_list(inv(),invn(),,,,,noequ)
    if ty<>0 or ty2<>0 then
        marked=1
        do
            if invn(i)<0 then
                for j=i to last
                    invn(j)=invn(j+1)
                    inv(j)=inv(j+1)
                next
                c+=1
            endif
            if inv(i).ty<>ty and inv(i).ty<>ty2 and inv(i).ty<>0 then
                DbgPrint("Removing "&inv(i).desig)
                for j=i to last
                    invn(j)=invn(j+1)
                    inv(j)=inv(j+1)
                next
                c+=1
            else
                i+=1
            endif
        loop until i>last
        DbgPrint("removed "&c &" items" &last-c)
        last-=c
        if last=1 then return inv(last).w.s
        if last<=0 then return -1
    endif
    if marked=0 then
        do
            marked+=1
            if marked>last then marked=0
        loop until invn(marked)>0
    endif
    do
        display_item_list(inv(),invn(),marked,last,2,2)
        helptext=inv(marked).describe
        if inv(marked).ty=26 then helptext=helptext & caged_monster_text
        'helptext = ""&marked &" " &last
        c=textbox(helptext,22,2,25,11,1)
        key=uConsole.keyinput(key_north &key_south)
        for i=0 to c
            draw string (22*_fw1,2*_fh1+i*_fh2),space(25),,font2,custom,@_col
        next
        if key=key_north then
            do
                marked-=1
                if marked<1 then marked=last
            loop until invn(marked)>0
        endif
        if key=key_south then
            do
                marked+=1
                if marked>last then marked=1
            loop until invn(marked)>0
        endif
    loop until key=key__enter or key=key__esc
    if key=key__enter then
        
        num=invn(marked)
        return inv(marked).w.s
    else
        return -1
    endif
end function



function items_table() as string
    dim as string t
    dim as _items inv(1024)
    dim as short invn(1024),lastitem,i,d,c
    lastitem=get_item_list(inv(),invn())
    d=cint((lastitem+1)/3)

    t=t &"<table width=" &chr(34) &"80%"&chr(34)& " align=" &chr(34) &"center"&chr(34)& "><tbody><tr><td valign=" &chr(34)& "top" &chr(34)& ">"
    t=t &"<td valign=" &chr(34)& "top" &chr(34)&"><div>"& html_color("#00ffff")
    c=1
    for i=1 to lastitem
        if inv(i).desig<>"" then
            select case invn(i)
            case is>1
                t=t &"&nbsp;"&invn(i)&" "&inv(i).desigp &"<br>"
            case is=1
                t=t &"&nbsp;"&inv(i).desig &"<br>"
            case is<1
                t=t & html_color("#ffffff") &inv(i).desig &"</span>"& html_color("#00ffff")&"<br>"
            end select

            if c>=d and invn(i)>0 then
                d=c
                c=1
                t=t &"</div></td><td valign=" &chr(34)& "top" &chr(34)&"><div>"& html_color("#00ffff")
            else
                c+=1
            endif
        endif
    next
    t=t &"</span></div></tbody></table>"


    return t
end function


function equipment_value() as integer
    dim i as short
    dim as integer m
    for i=0 to lastitem
        if item(i).w.s<0 then m+=item(i).price
    next
    return m
end function


function list_inventory() as string
    dim as short i,c,b
    dim as _items inv(1024)
    dim as short invn(1024)
    dim text as string
    c=get_item_list(inv(),invn())
    text="{15}Equipment (Value "&Credits(equipment_value) &" Cr.):{11}"
    for i=1 to c
        select case invn(i)
        case is>1
            text=text &"| "&invn(i)&" "&inv(i).desigp
        case is=1
            text=text &"| "&inv(i).desig
        case is<1
            text=text &"|{15}"&inv(i).desig &"{11}"
        end select
    next
    return text
        b+=1
'        select case invn(i)
'        case is >9
'            draw string (tScreen.x-(len(trim(inv(i).desig))+3)*_fw2,tScreen.y-((c-b)*_fh2)),invn(i)&" "&inv(i).desigp,,font2,custom,@_col
'        case 2 to 9
'            draw string (tScreen.x-(len(trim(inv(i).desig))+3)*_fw2,tScreen.y-((c-b)*_fh2)),invn(i)&" "&inv(i).desigp,,font2,custom,@_col
'        case else
'            draw string (tScreen.x-len(trim(inv(i).desig))*_fw2,tScreen.y-((c-b)*_fh2)),inv(i).desig,,font2,custom,@_col
'
'        end select

end function


function captain_sprite() as short
    return gt_no(990+crew(1).story(3)+abs(awayteam.helmet-1)*3*crew(1).story(10)+6*awayteam.helmet)
end function


function item_assigned(i as short) as short
    dim as short j
    for j=0 to 128
        if crew(j).hp>0 then
            if item(i).ty=2 and crew(j).pref_lrweap=item(i).uid then return j+1
            if item(i).ty=4 and crew(j).pref_ccweap=item(i).uid then return j+1
            if item(i).ty=3 and crew(j).pref_armor=item(i).uid then return j+1
        endif
    next
    return 0
end function


function first_unused(i as short) as short
    DimDebugL(0)
    dim as short a
    
    if item_assigned(i)=0 then return i
    DbgPrint("Item "&i &"assigned, looking for alternative")
    for a=0 to lastitem
        if item(a).w.s<0 and a<>i then
            if item(a).desig=item(i).desig and item(a).v1=item(i).v1 and item(a).v2=item(i).v2 and item(a).v3=item(i).v3 then
#if __FB_DEBUG__
                if debug=1 and item_assigned(a)=0 then
					DbgPrint("Item " &a & "is alternative")
                EndIf
                if debug=1 and item_assigned(a)>0 then
                	DbgPrint("Item " &a & "is used by"&item_assigned(a)-1)
                EndIf 
#endif
                if item_assigned(a)=0 then return a
            endif
        endif
    next
    DbgPrint("No alt found")
    return i
end function


'

function haggle_(way as string) as single
    if lcase(way)="up" then return (1+crew(1).talents(2)/10)
    if lcase(way)="down" then return (1-crew(1).talents(2)/10)
end function


function bunk_multi() as single
    dim as short b,here,sMax
    sMax=(player.h_maxcrew+player.crewpod)+player.cryo
    for b=1 to 128
        if crew(b).hp>0 then here+=1
    next
    if here<=sMax then
        player.bunking=1
        return 1
    else
        return 1+here/(sMax*3)
    endif
end function


function changemoral(value as short, where as short) as short
    dim as short a,tribbles
    for a=0 to lastitem
        if item(a).ty=80 and item(a).w.s<0 then
            tribbles+=1
            if rnd_range(1,100)>=99 and rnd_range(1,100)>=99 then
                rlprint "Someone overfed a tribble."
                placeitem(make_item(250),,,,,-1)
            endif
        endif
    next
    if value<0 then value=value*bunk_multi
    if value>0 then value=value/bunk_multi
    for a=2 to 128
        if crew(a).hp>0 and crew(a).onship=where then
            crew(a).morale=crew(a).morale+value
            if tribbles>0 then
                tribbles-=1
                crew(a).morale+=1
            endif
        endif
    next
    if tribbles>0 then unattendedtribbles=tribbles
    return 0
end function


function is_passenger(i as short) as short
    dim as short j
    for j=2 to 255
        if crew(j).typ=i+30 then return -1
    next
    return 0
end function


function upgradehull(t as short,byref s as _ship,forced as short=0) as short
    dim as short f,flg,a,b,cargobays,weapons,tfrom,tto,m
    dim n as _ship
    dim d as _crewmember
    dim as string ques
    dim as string word(10)
    dim as string text
    if t<20 then
        n=gethullspecs(t,"data/ships.csv")
    else
        n=gethullspecs(t-22,"data/customs.csv")
    endif
    for a=1 to 10
        if s.cargo(a).x>0 then cargobays=cargobays+1
        if s.weapons(a).desig<>"" then weapons=weapons+1
    next

    'compare
    if s.h_maxhull>n.h_maxhull then ques=ques &"The new ship will have a lower maximum armor capacity than your current one. "
    if s.engine>n.h_maxengine and s.engine<6 then ques=ques &"You will need to downgrade your engine for the new hull. "
    if s.shieldmax>n.h_maxshield then ques=ques &"You will need to downgrade your shield generators for the new hull."
    if s.sensors>n.h_maxsensors and s.sensors<6 then ques=ques &"You will need to downgrade your sensors for the new hull."
    if cargobays>n.h_maxcargo then ques=ques &"The new ship will have less cargo space. "
    if s.h_maxcrew>n.h_maxcrew then ques=ques &"The new ship will have less space for crewmen. "
    if s.h_maxweaponslot>n.h_maxweaponslot then ques=ques &"The new ship will have fewer weapon turrets. "
    if s.h_maxfuel>n.h_maxfuel then ques=ques &"The new ship will have a lower fuel capacity than your current one."
    if forced=1 then
        ques=""
        flg=-1
    endif
    if ques<>"" then
        rlprint ques,14 
        if askyn("Do you really want to transfer to the new hull?") then 
            flg=-1
        else
            flg=0
        endif
    else
        flg=-1
    endif
    if flg=-1 then
        s.ti_no=n.h_no
        if s.ti_no=18 then s.ti_no=17 'ASCS is one step lower
        if s.ti_no>18 then s.ti_no=9
        s.h_no=n.h_no
        s.h_price=n.h_price
        s.h_desig=n.h_desig
        s.h_sdesc=n.h_sdesc
        s.h_maxhull=n.h_maxhull
        s.h_maxengine=n.h_maxengine
        s.h_maxsensors=n.h_maxsensors
        s.h_maxshield=n.h_maxshield
        s.h_maxcargo=n.h_maxcargo
        s.h_maxcrew=n.h_maxcrew
        if s.engine<6 and s.engine>s.h_maxengine then s.engine=s.h_maxengine
        if s.sensors<6 and s.sensors>s.h_maxsensors then s.sensors=s.h_maxsensors
        if s.shieldmax>s.h_maxshield then s.shieldmax=s.h_maxshield
        
        s.h_maxweaponslot=n.h_maxweaponslot
        s.h_maxfuel=n.h_maxfuel
        if s.hull=0 then s.hull=s.h_maxhull*0.8
        if s.hull>s.h_maxhull then s.hull=s.h_maxhull
        if s.fuel=0 or s.fuel>s.h_maxfuel then s.fuel=s.h_maxfuel
        if s.h_maxweaponslot<weapons then
            poolandtransferweapons(n,s)
'            do
'                tfrom=(s.h_maxweaponslot -tto)
'                text="Chose weapons to transfer ("&tfrom &"):"
'                b=1
'                for a=1 to 10
'                    if s.weapons(a).desig<>"" then 
'                        text=text &"/"&s.weapons(a).desig
'                        b=b+1
'                    endif
'                next
'                text=text &"/Exit"
'                a=menu(text)
'                if a<b then
'                    tto=tto+1
'                    n.weapons(tto)=s.weapons(a)
'                    rlprint "Transfering "&s.weapons(a).desig &" to slot "&tto
'                    weapons=weapons-1
'                endif
'                if a=b then
'                    if not(askyn("Do you really want to lose your remaining weapons(y/n)?")) then a=0
'                endif
'            loop until a=b or tto=s.h_maxweaponslot
'            for a=0 to 10
'                s.weapons(a)=n.weapons(a)
'            next
        endif
        
        recalcshipsbays
        
        if s.security>s.h_maxcrew+player.crewpod+player.cryo then
            s.security=s.h_maxcrew
            for a=s.h_maxcrew+player.crewpod+player.cryo to 255
                crew(a)=d
            next
        endif
        s.fuelmax=s.h_maxfuel+s.fuelpod
    endif
    return flg
end function


function buy_ship(st as short,ds as string,pr as short) as short

    if paystuff(pr) then
        if st<>player.h_no then
            if upgradehull(st,player)=-1 then
                rlprint "you buy "&add_a_or_an(ds,0)&" hull"
                return -1
            else
                player.money=player.money+pr'Just returning the money
            endif             
        else
            rlprint "You already have that hull."
            player.money=player.money+pr'Just returning the money
        endif
    endif
    return 0
end function


function used_ships() as short
    dim as short yourshipprice,i,a,yourshiphull,price(8),l
    dim s as _ship
    dim as single pmod
    dim as string mtext,htext,desig(8)
    do
        yourshiphull=player.h_no
        s=gethullspecs(yourshiphull,"data/ships.csv")
        yourshipprice=s.h_price*.1
        mtext="Used ships (" &credits(yourshipprice)& " Cr. for your ship.)/"
        htext="/"
        for i=1 to 8
            pmod=(80-usedship(i).y*3)/100
            s=gethullspecs(usedship(i).x,"data/ships.csv")
            l=len(trim(s.h_desig))+len(credits(s.h_price*pmod))
            mtext=mtext &s.h_desig &space(45-l)&credits(s.h_price*pmod) &" Cr./"
            price(i)=s.h_price*pmod-yourshipprice
            desig(i)=s.h_desig
            htext=htext &makehullbox(s.h_no,"data/ships.csv") &"/"
        next
        mtext=mtext &"Bargain bin/Sell equipment/Exit"
        a=textmenu(bg_shiptxt,mtext,htext,2,2)
        if a>=1 and a<=8 then
            if buy_ship(a,desig(a),price(a)) then
                usedship(a).x=yourshiphull
                player.cursed=usedship(a).y
                usedship(a).y=0
            endif
        endif
        if a=9 then shop(30,0.8,"Bargain bin")
        if a=10 then buysitems("","",0,.5)
    loop until a=11 or a=-1        
    return 0
end function


function shipstatus(heading as short=0) as short
'    dim as short c1,c2,c3,c4,c5,c6,c7,c8,sick,offset,mjs,filter
'    dim as short a,b,c,lastinv,set,tlen,cx,cy
'    dim as string text,key
'    dim inv(256) as _items
'    dim invn(256) as short
'    dim cargo(12) as string
'    dim cc(12) as short
    dim as short cw,turrets,a
    dim as integer offset
    set__color( 0,0)
    cls
    do
        cw=(tScreen.x-16*_fw2)/3.5
        cw=cw/_fw2
        if heading=0 then textbox("{15}Name: {11}"&player.desig &"{15} Type:{11}" &player.h_desig,1,0,40)

        textbox(shipstatsblock &"||" & weapon_string &"|" & cargo_text ,1,2,cw)

        textbox(Crewblock(),(2+cw)*_fw2/_fw1,2,16)

        textbox(list_artifacts(artflag()),(2+18+cw)*_fw2/_fw1,2,cw)

        if heading=0 then
            textbox(list_inventory,(2+18+2*cw)*_fw2/_fw1,2,cw,,,,,offset)

            no_key=uConsole.keyinput()
            if no_key="+" then offset+=1
            if no_key="-" then offset-=1
        endif
    loop until not(no_key="+" or no_key="-")
    cls
    return 0
end function


function recalcshipsbays() as short
    dim soll as short
    dim haben as short
    dim as short a,b,c
    dim del as _crewmember
    dim dif as short
    
    for c=0 to 9
        for b=1 to 9
            if player.weapons(b).desig="" then swap player.weapons(b),player.weapons(b+1) 
            'if player.cargo(b).x<player.cargo(b+1).x then swap player.cargo(b),player.cargo(b+1)
        next
    next
    player.fuelpod=0
    player.crewpod=0
    soll=player.h_maxcargo
    for a=1 to 10
        if a>player.h_maxweaponslot then player.weapons(a)=make_weapon(-1)
        if player.weapons(a).desig="Cargo Bay" then soll=soll+1
        if player.weapons(a).desig="Fuel Tank" then player.fuelpod=player.fuelpod+50
        if trim(player.weapons(a).desig)="Crew Quarters" then player.crewpod=player.crewpod+10
    next
    for a=1 to 25
        if player.cargo(a).x>0 then haben=haben+1
    next
    if soll>haben then
        dif=soll-haben
        do
        for a=1 to 25
            if player.cargo(a).x=0 and dif>0 then
                player.cargo(a).x=1
                dif=dif-1
            endif
        next
        loop until dif<=0
    endif
    if haben>soll then
        dif=haben-soll
        for b=1 to 5
            for a=1 to 25
                if player.cargo(a).x=b and dif>0 then
                    player.cargo(a).x=0 
                    dif=dif-1
                endif
            next
        next
    endif
    for c=1 to 9
        for b=1 to 9
          if player.cargo(b).x<player.cargo(b+1).x then swap player.cargo(b),player.cargo(b+1)
      next        
    next
    if player.fuel>player.fuelmax+player.fuelpod then player.fuel=player.fuelmax+player.fuelpod
    for c=6 to player.h_maxcrew+player.crewpod+player.cryo
        if crew(c).hp<>0 then player.security=c
    next
    for c=5+player.cryo+(player.h_maxcrew+player.crewpod-5)*2+1 to 255
        crew(c)=del
    next    
    player.addhull=0
    for a=1 to 5
        if player.weapons(a).made=87 then player.addhull=player.addhull+5
    next
    if player.hull>max_hull(player) then player.hull=max_hull(player)
    return 0
end function


function merchant() as single
    dim as single m
    m=(70+5*crew(1).talents(6))/100
    if m>0.9 then merchant=0.9
    return m
end function

function infect(a as short,dis as short) as short
    dim as short roll
    roll=rnd_range(1,6) +rnd_range(1,6)+player.doctor(location)
    if roll<maximum(3,dis) and crew(a).hp>0 and crew(a).hpmax>0 then
        crew(a).disease=dis
        crew(a).oldonship=crew(a).onship
        crew(a).duration=disease(dis).duration
        crew(a).incubation=disease(dis).incubation
        if dis>player.disease then player.disease=dis
    endif
    return 0
end function



function add_passenger(n as string,typ as short, price as short, bonus as short, target as short, sTime as short, gender as short) as short
    dim c as short
    assert(pFreecrewslot<>null)
    c=pFreecrewslot()
    if c>0 then
        crew(c).n=n
        crew(c).icon="p"
        crew(c).equips=1
        crew(c).hpmax=1
        crew(c).hp=1
        crew(c).typ=typ
        crew(c).target=target
        crew(c).time=sTime
        crew(c).price=price
        crew(c).bonus=bonus
        crew(c).onship=1
        crew(c).morale=150
        crew(c).story(10)=gender
        if rnd_range(1,100)<5 then
            infect(c,rnd_range(1,12))
        endif
    else
        rlprint "You don't have enough room"
    endif
    return 0
end function



function eris_does() as short
    dim as short roll,roll2,a,noa,b
    dim en as _fleet
    dim weap as _weap
    dim awayteam as _monster
    if rnd_range(1,100)<33 then
        if planets(specialplanet(1)).visited<>0 then
            if askyn("Eris asks: 'Do you know where apollo is?' Do you want to tell her (y/n)") then
                for a=3 to lastfleet
                    if fleet(a).ty=10 then
                        fleet(a).t=4068
                        b=sysfrommap(specialplanet(1))
                        targetlist(4068).x=map(b).c.x
                        targetlist(4068).y=map(b).c.y
                    endif
                next
                return 0
            endif
            roll=rnd_range(1,66)
            select case roll
                case roll<=33
                    rlprint "Eris decides to punish you for your insolence"
                case roll>=66 
                    rlprint "Eris decides to show you how she could reward you for the information"
                case else
                    rlprint "Eris doesn't seem to care"
            end select
            
        else
            roll=rnd_range(1,100)
        endif
        select case roll
        case roll<=33 'Eris does bad stuff
            select case rnd_range(1,100)
                case 0 to 10
                    select case rnd_range(1,100)
                    case 0 to 33
                        rlprint "Eris looks at your engine",15
                        if player.engine>1 then player.engine-=1
                    case 34 to 66
                        rlprint "Eris looks at your sensors",15
                        if player.engine>0 then player.sensors-=1
                    case else
                        rlprint "Eris looks at your shields",15
                        if player.shieldmax>0 then player.shieldmax-=1
                    end select
                case 11 to 20
                    rlprint "Eris examines your hull",15
                    if player.hull>0 then player.hull-=1
                    player.h_maxhull-=1
            	case 21 to 30
            		
				    rlprint  "Eris looks at "& pUnAugmentRandomCrewmember() &" 'Oh you are ugly!'",15
            	case 31 to 40
                    roll2=rnd_range(1,6)
                    rlprint "Eris yells 'Fight for my amusement'",15
                    no_key=uConsole.keyinput()
                    noa=1
                    if roll2=4 then noa=rnd_range(1,6) +rnd_range(1,6)
                    if roll2=5 then noa=rnd_range(1,3)
                    if roll2=6 then noa=rnd_range(1,2)
                    for a=1 to noa
                        en.ty=9
                        en.mem(a)=make_ship(23+roll)
                    next
                    assert(pSpacecombat<>null)
                    pSpacecombat(en,rnd_range(1,11))
                case 41 to 50
                    rlprint "Eris shows you that you have a fuel leak",15
                    player.fuel-=rnd_range(1,100)
                    if player.fuel<15 then player.fuel=15
                case 51 to 60
                    rlprint "Eris informs you that it is not nice to point guns at people",15
                    player.weapons(1)=weap
                case 61 to 70
                    rlprint "Eris asks 'Have you got some change?",15
                    player.money-=rnd_range(10,1000)
                    if player.money<0 then player.money=0
                case 71 to 80
                    rlprint "Eris takes a stroll through the cargo hold.",15
                    for a=1 to 5
                        if player.cargo(a).x>1 then player.cargo(a).x=1
                    next
                case 81 to 90
                    rlprint "Eris thinks your ship is too big",15
                    upgradehull(rnd_range(1,4),player,1)
                case 91 to 95
                    rlprint "Eris says 'You are buff!",15
                    a=rnd_crewmember
                    crew(a).hp-=1
                    crew(a).hpmax-=1
                case else
                    rlprint "Eris curses your ship!",15
                    player.cursed=1
            end select
        case roll>=66 'Eris does good stuff
            select case rnd_range(1,100)
                case 0 to 10
                    select case rnd_range(1,100)
                    case 0 to 33
                        rlprint "Eris looks at your engine",15
                        if player.engine<6 then player.engine+=1
                    case 34 to 66
                        rlprint "Eris looks at your sensors",15
                        if player.engine<6 then player.sensors+=1
                    case else
                        rlprint "Eris looks at your shields",15
                        if player.shieldmax<6 then player.shieldmax+=1
                    end select
                case 11 to 20
                    rlprint "Eris examines your hull",15
                    player.hull+=5
                    player.h_maxhull+=5
                case 21 to 30
                    rlprint "Eris takes a look at your cargo hold",15
                    player.h_maxcargo+=1
                    player.cargo(player.h_maxcargo).x=1
                case 31 to 40
                    a=rnd_crewmember
                    rlprint "Eris looks at "&crew(a).n &" 'my, my are you fragile!",15
                    crew(a).hp+=1
                    crew(a).hpmax+=1
                case 41 to 50
                    rlprint "Eris looks at "&crew(a).n &" and starts laughing",15
                    a=rnd_crewmember
                    rlprint gain_talent(a),c_gre
                case 51 to 60
                    rlprint "Eris looks at "&crew(a).n &" and starts laughing",15
                    a=rnd_crewmember
                    rlprint pGainxp(a),c_gre
                case 61 to 70
                    rlprint "Eris says 'Are you sure you have enough fuel to get home?",15
                    player.fuel+=200
                case 71 to 80
                    rlprint "I found this, can you use it?",15
                    findartifact(0)
                case 81 to 90
                    rlprint "Eris is worried that you might need money",15
                    player.money+=rnd_range(1,1000)
                case 91 to 95
                    rlprint "Eris takes a stroll through the cargo hold.",15
                    for a=1 to 5
                        if player.cargo(a).x=1 then player.cargo(a).x=rnd_range(2,6)
                    next
                case else
                    rlprint "Eris declares all curses lifted!",15
                    player.cursed=0
            end select
        case else 'Just does stuff
            select case rnd_range(1,100)
                case 0 to 10
                    rlprint "Eris says: 'I don't want to deal with you right now, why don't you just go over there?",15
                    select case rnd_range(1,100)
                    case 0 to 66
                        player.c=movepoint(player.c,5)
                    case 67 to 90
                        player.c=map(rnd_range(1,wormhole+laststar)).c
                    case else
                        player.c.x=rnd_range(0,sm_x)
                        player.c.y=rnd_range(0,sm_y)
                    end select
                case 11 to 20
                    rlprint "Eris says: 'You have very interesting diplomatic relations.",15
                    faction(0).war(rnd_range(1,5))+=10-rnd_range(1,20)
                case 21 to 30
                    rlprint "Eris asks: 'Where is Apollo?",15
                case 31 to 40
                    rlprint "Eris takes a stroll through the cargo hold.",15
                    for a=1 to 5
                        if player.cargo(a).x>1 then player.cargo(a).x=rnd_range(1,5)
                    next
                case 41 to 50
                    rlprint "Is that your space station, there?",15
                    basis(rnd_range(0,2)).c.x=rnd_range(0,sm_x)
                    basis(rnd_range(0,2)).c.y=rnd_range(0,sm_y)
                case 51 to 60
                    rlprint "Eris screws around with time",15
                    tVersion.gameturn=tVersion.gameturn+5-rnd_range(1,10)
                case 61 to 70
                    rlprint "Eris snaps with her fingers",15
                    drifting(rnd_range(1,lastdrifting)).x=player.c.x
                    drifting(rnd_range(1,lastdrifting)).y=player.c.y
                case 71 to 80
                    rlprint "Eris seems bored",15
                case 81 to 90
                    rlprint "Eris is looking at the stars",15
                    map(rnd_range(0,laststar)).c=rnd_point
                    map(rnd_range(0,laststar)).c=rnd_point
                case 91 to 100
                    eris_doesnt_like_your_ship
            end select
        end select
    else
        rlprint "Eris doesn't seem to be interested in you.",15
        if rnd_range(1,100)<66 then
            select case rnd_range(1,100)
            case 0 to 66
                player.c=movepoint(player.c,5)
            case 67 to 90
                player.c=map(rnd_range(1,wormhole+laststar)).c
            case else
                player.c.x=rnd_range(0,sm_x)
                player.c.y=rnd_range(0,sm_y)
            end select
        endif
    endif
    return 0
end function

    	

#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tCrew -=-=-=-=-=-=-=-
	tModule.register("tCrew",@tCrew.init()) ',@tCrew.load(),@tCrew.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tCrew -=-=-=-=-=-=-=-
#endif'test


