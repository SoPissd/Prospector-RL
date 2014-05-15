'tWeapon.
'
'defines:
'make_weapon=0, count_and_make_weapons=0, make_weap_helptext=1,
', starting_turret=0, weapon_text=2
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(types) or defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tWeapon -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Type _weap
    desig As String*30
    dam As Short
    range As Single
    ammo As Short
    ammomax As Short
    ROF As Byte
    ECMmod As Byte
    p As Short
    made As Byte
    col As Byte
    heat As Short
    heatadd As Byte
    heatsink As Byte
    reload As Byte
    reloading As Byte
    shutdown As Byte
End Type

Dim Shared As _weap wsinv(20) 

Dim Shared ammotypename(4) As String
#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tWeapon -=-=-=-=-=-=-=-

declare function make_weapon(a as short) as _weap
declare function weapon_text(w as _weap) as string
declare function make_weap_helptext(w as _weap) as string

'private function count_and_make_weapons(st as short) as short
'private function starting_turret() as _weap

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tWeapon -=-=-=-=-=-=-=-

namespace tWeapon
function init() as Integer
	return 0
end function
end namespace'tWeapon


#define cut2top

'Type _ammotype
'    made As Byte
'    desig As String*32
'    tohit As Byte
'    todam As Byte
'    toran As Byte
'    toheat As Byte
'    price As Byte
'    size As Byte
'End Type


function make_weapon(a as short) as _weap
    'w.made &";"&w.desig &";" &w.range &";"& w.ammo &";"&w.ammomax &";"& w.ecmmod &";"& w.p &";"
    '& w.col &";"& w.heat &";"& w.heatsink &";"& w.heatadd

    dim as _weap w,w2
    dim as string l
    dim as string word(15)
    dim as short f,i,t,j,dam
    f=freefile
    open "data/weapons.csv" for input as #f
    do
        w=w2
        line input #f,l
        j=0
        for t=0 to len(l)
            if mid(l,t,1)=";" then
                j+=1
            else
                word(j)=word(j) &mid(l,t,1)
            endif
        next
        w.made=val(word(0))
        w.desig=trim(word(1))
        dam=val(word(2))
        w.range=val(word(3))
        w.ammo=val(word(4))
        w.ammomax=val(word(5))
        w.ROF=val(word(6))
        w.ecmmod=val(word(7))
        w.p=val(word(8))
        w.col=val(word(9))
        w.heat=val(word(10))
        w.heatsink=val(word(11))
        w.heatadd=val(word(12))
        w.reload=val(word(13))
        for t=0 to 13
            word(t)=""
        next
    loop until w.made=a or eof(f)
    close #f
    if a=w.made then
        if a>=6 and a<=10 then
            w.dam=urn(dam+2,dam-1,1,2-(tVersion.gameturn/50000))
            if w.dam<1 then w.dam=1
            if w.dam>5 then w.dam=5
            w.desig=w.dam &"0 GJ "&w.desig
            w.p=(w.dam*250+((w.dam-1)*250))*(1+w.range/5)
        else
            w.dam=dam
        endif
        if rnd_range(1,100)-(w.dam-dam)*3<minimum(25,tVersion.gameturn/50000) and w.reload>0 then '10 % have lower reload rate
            w.desig="IR "&w.desig
            w.reload=w.reload/2
            w.p=w.p*1.2
        endif
        if rnd_range(1,100)-(w.dam-dam)*3<minimum(25,tVersion.gameturn/50000) and w.reload>0 then
            w.desig="IC "&w.desig
            w.heatsink=w.heatsink+2
        endif
        w.p=w.p+w.heatsink*250
        return w
    else 
        return w2 'return empty weapon instead of last if not found
    endif
end function


function count_and_make_weapons(st as short) as short
    dim as short a,b,flag
    
    b=0
    for a=1 to 20
        if makew(a,st)<>0 then 
            b+=1
            wsinv(b)=make_weapon(makew(a,st))
        endif
    next
    
    do
        flag=0
        for a=1 to b-1
            if (wsinv(a).made>wsinv(a+1).made) or (wsinv(a).made=wsinv(a+1).made and wsinv(a).dam>wsinv(a+1).dam) then
                flag=1
                swap wsinv(a),wsinv(a+1)
            endif
        next
    loop until flag=0
    
    return b
end function


function make_weap_helptext(w as _weap) as string
    dim help as string
    help=help &"{15}"&w.desig &"{11} | | "
    if w.made=1 then help=help &"Little more than an airlock to throw your ammo in the general direction of your target. "
    if w.made=2 then help=help &"A chemical explosion propels your warhead towards the enemy. "
    if w.made=3 then help=help &"A bigger version of the popular hand weapon: Your rounds are accelerated to high speeds using electric fields. "
    if w.made=4 then help=help &"Small rockets are used to propel your ammunition towards the opposing force. "
    if w.made=5 then help=help &"Similiar to a gauss gun, but instead of using seperate coils it uses continous current.  "
    if w.made=6 then help=help &"Ionized hydrogen. Low impact damage, low penetration. A targetable ships drive basically"
    if w.made=7 then help=help &"Lasers burn through the enemys ships armor"
    if w.made=8 then help=help &"Higher energy per particle increases the damage of a Laser"
    if w.made=9 then help=help &"Bremsstrahlung wreaks havoc inside the target even if the particles don't penetrate the hull."
    if w.made=10 then help=help &"Heavy particles accelerated to near light speeds penetrate and rip apart the enemys armor."
    if w.made=11 then help=help &"Two light ship guns combined into a battery. "
    if w.made=12 then help=help &"Three light gauss guns combined into a battery "
    if w.made=13 then help=help &"Four light rocket launchers combined into a battery "
    if w.made=14 then help=help &"Three rail guns combined into a battery. There are 2 rounds in each "
    if w.made=84 then help=help &"A weapons turret modified to store and feed ammunition to other weapons on the ship. Holds 25 additional projectiles. Any insurance policy for your life or your ship you hold is void if you install this."
    if w.made=85 then help=help &"Collects fuel from interstellar gas clouds and improves the amount of fuel gained from scooping gas giants "
    if w.made=86 then help=help &"Collects fuel from interstellar gas clouds and improves the amount of fuel gained from scooping gas giants "
    if w.made=87 then help=help &"Sacrifices a weapon turret to install additional armor | | +5 to HP"
    if w.made=88 then help=help &"expandable radiating surfaces, to dissipate weapons heat | | 4 points of heat dissipation"
    if w.made=89 then help=help &"expandable radiating surfaces, to dissipate weapons heat | | 8 points of heat dissipation"
    if w.made=90 then help=help &"An auxillary powerplant dedicated to the shield generator, improving their recharging rate. | | Shields recharge at 2 pts per round"
    if w.made=91 then help=help &"A small auxillary powerplant feeding energy weapons. | | +1 to energy weapons damage"
    if w.made=92 then help=help &"A large auxillary powerplant feeding energy weapons. | | +2 to energy weapons damage."
    if w.made=93 then help=help &"A second sensor array directly linked to weapons control | | +1 to hit in space combat"
    if w.made=94 then help=help &"A powerfull additional sensor array directly linked to weapons control | | +2 to hit in space combat"
    if w.made=95 then help=help &"An improved tractor beam weapon that can attract and repel mass. Essential for salvage missions and practical for other purposes. It is more powerfull and sturdier than the normal Tractor beam."
    if w.made=96 then help=help &"A beam weapon that can attract and repel mass. Essential for salvage missions and practical for other purposes."
    if w.made=97 then help=help &"A weapons turret modified to provide lving space. Holds up to 10 additional crewmembers"
    if w.made=98 then help=help &"Not the safest way to store fuel. It holds 50 tons"
    if w.made=99 then help=help &"A weapons turret modified to hold an additional ton of cargo."

    select case w.made
    case 6 to 10
        help=help &" | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    case 1 to 5 , 11 to 14
        help=help &" | | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    end select
    if w.rof>1 then help &="| Rate of Fire: "&w.rof
    if w.ammomax>0 then help=help &" | Ammuniton: "&w.ammomax
    if w.heatadd>0 or w.heatsink>0 then help=help &"| Heat:"&w.heat &"\"&w.heatadd &" Heatsinks: "& w.heatsink
    return help
end function


function starting_turret() as _weap
    dim as string m,help
    dim weapon(12) as _weap
    dim as short i,ws(12)
    ws(1)=1
    ws(2)=6
    ws(3)=84
    ws(4)=85
    ws(5)=87
    ws(6)=88
    ws(7)=90
    ws(8)=93
    ws(9)=96
    ws(10)=98
    ws(11)=99
    '1,6,84,85,87,88,90,93,96-99
    m="Choose turret:/"
    for i=1 to 11
        weapon(i)=make_weapon(ws(i))
        m=m &weapon(i).desig &"/"
        help=help &make_weap_helptext(weapon(i))
    next
    m=m &"Cancel"
    i=textmenu(bg_parent,m,help,20,2)
    if i<0 or i=12 then return weapon(0)
    return weapon(i)
end function


function weapon_text(w as _weap) as string
    dim text as string

    if w.desig="" then
        text=""
    else
        text="{15}"
        if w.dam>0 then
            if w.reloading>0 then text="{7}"
            if w.shutdown>0 then text="{14}"
            text=text &w.desig &"|"
            if w.reloading=0 and w.shutdown=0 then text=text &"{11}"

            if w.ammomax=0 then
                text=text &" D:"&w.dam
            endif
            if w.reloading=0 then
                text=text &" R:"&w.range &"/"&w.range*2 &"/"&w.range*3
                if w.ammomax>0 then text=text &" A:"&w.ammomax &"/"&w.ammo
            else
                if w.ammomax>0 then
                    text=text &" Reloading"
                else
                    text=text &" Recharging"
                endif
            endif
            text=text &"{11} "
            if w.heat>0 then text=text & "|Heat: "
            if w.heat>50 then text=text &"{14}"
            if w.heat>100 then text=text &"{12}"
            if w.heat>0 then text=text & round_nr(w.heat/25,1)
            if w.shutdown>0 then text=text &"- Shutdown"
        else
            text=w.desig
            if w.ammomax>0 then text=text &"| A:"&w.ammomax &"/"&w.ammo
        endif
    endif
    return text
end function


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tWeapon -=-=-=-=-=-=-=-
	tModule.register("tWeapon",@tWeapon.init()) ',@tWeapon.load(),@tWeapon.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tWeapon -=-=-=-=-=-=-=-
#endif'test
