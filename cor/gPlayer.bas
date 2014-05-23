'tPlayer.
'
'defines:
'addmoney=106, randomname=0, settactics=1, weapon_string=2
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
'     -=-=-=-=-=-=-=- TEST: tPlayer -=-=-=-=-=-=-=-
#undef intest
#define test
#endif'test

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-    

Enum moneytype
    mt_startcash
    mt_bonus
    mt_quest
    mt_pirates
    mt_ress
    mt_bio
    mt_map
    mt_ano
    mt_trading
    mt_towed
    mt_escorting
    mt_artifacts
    mt_blackmail
    mt_piracy
    mt_gambling
    mt_quest2
    mt_last
End Enum

Dim Shared tacdes(6) As String
Dim Shared income(mt_last) As Integer
Dim Shared lastenemy As Short

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


Enum locat
    lc_awayteam
    lc_onship
End Enum

Dim Shared location As Byte
Dim Shared wage As Byte = 10
Dim Shared captainskill As Byte = -5
Dim Shared bonesflag As Short


#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tPlayer -=-=-=-=-=-=-=-

declare function addmoney(amount as integer,mt as byte) as short
declare function getfreecargo() as short
declare function settactics() as short
declare function weapon_string() as string
declare function randomname() as string

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tPlayer -=-=-=-=-=-=-=-

namespace tPlayer
function init(iAction as integer) as integer
	wage=10
	captainskill=-5
    tacdes(1)="reckless" 	'-2
    tacdes(2)="agressive" 	'-1
    tacdes(3)="neutral" 	' 0
    tacdes(4)="cautious" 	'+1
    tacdes(5)="defensive" 	'+2
    tacdes(6)="nonlethal" 	'+3

    disease(1).no=1
    disease(1).desig="gets a light cough"
    disease(1).ldesc="a light cough"
    disease(1).incubation=2
    disease(1).duration=3
    disease(1).contagio=5
    disease(1).cause="bacteria"
    disease(1).fatality=5
    disease(1).att=-1
    
    disease(2).no=2
    disease(2).desig="gets a heavy cough"
    disease(2).ldesc="a heavy cough"
    disease(2).incubation=3
    disease(2).duration=4
    disease(2).contagio=5
    disease(2).cause="viri"
    disease(2).fatality=5
    
    disease(3).no=3
    disease(3).desig="gets a fever and a light cough"
    disease(3).ldesc="a light cough and fever"
    disease(3).incubation=3
    disease(3).duration=5
    disease(3).contagio=10
    disease(3).cause="bacteria"
    disease(3).fatality=8
    
    
    disease(4).no=4
    disease(4).desig="gets a heavy fever and a light cough"
    disease(4).ldesc="a heavy cough and fever"
    disease(4).incubation=3
    disease(4).duration=6
    disease(4).contagio=10
    disease(4).cause="bacteria"
    disease(4).fatality=12
    
    disease(5).no=5
    disease(5).desig="gets a fever and starts shivering"
    disease(5).ldesc="a light fever and shivering"
    disease(5).incubation=3
    disease(5).duration=15
    disease(5).contagio=5
    disease(5).cause="viri"
    disease(5).fatality=15
    
    disease(6).no=6
    disease(6).desig="suddenly gets shivering and boils"
    disease(6).ldesc="shivering and boils"
    disease(6).incubation=1
    disease(6).duration=15
    disease(6).contagio=15
    disease(6).cause="microscopic parasitic lifeforms"
    disease(6).fatality=25
    
    disease(7).no=7
    disease(7).desig="gets muscle cramps"
    disease(7).ldesc="shivering and muscle cramps"
    disease(7).incubation=3
    disease(7).duration=15
    disease(7).contagio=15
    disease(7).cause="viri"
    disease(7).fatality=25
    disease(7).att=-4
    disease(7).oxy=4
    
    disease(8).no=8
    disease(8).desig="starts vomiting and coughing blood"
    disease(8).ldesc="vomiting and coughing of blood"
    disease(8).incubation=5
    disease(8).duration=15
    disease(8).contagio=15
    disease(8).cause="bacteria"
    disease(8).fatality=25
    
    disease(9).no=9
    disease(9).desig="suddenly turns blind"
    disease(9).ldesc="blindness"
    disease(9).incubation=5
    disease(9).duration=15
    disease(9).contagio=15
    disease(9).cause="bacteria"
    disease(9).fatality=5
    disease(9).bli=55
    
    disease(10).no=10
    disease(10).desig="has fever and suicidal thoughts"
    disease(10).ldesc="a strong fever, shivering and boils"
    disease(10).incubation=1
    disease(10).duration=15
    disease(10).contagio=15
    disease(10).cause="mircroscopic parasitic lifeforms"
    disease(10).fatality=5
    
    disease(11).no=11
    disease(11).desig="has a strong fever and balance impairment"
    disease(11).ldesc="a strong fever and balance impairment"
    disease(11).incubation=5
    disease(11).duration=15
    disease(11).contagio=15
    disease(11).cause="viri"
    disease(11).fatality=5
    disease(11).att=-7
    
    disease(12).no=12
    disease(12).desig="gets a rash"
    disease(12).ldesc="a rash caused"
    disease(12).incubation=2
    disease(12).duration=25
    disease(12).contagio=35
    disease(12).cause="bacteria"
    disease(12).fatality=5
    
    disease(13).no=13
    disease(13).desig="suffers from hallucinations"
    disease(13).ldesc="severe hallucinations"
    disease(13).incubation=1
    disease(13).duration=25
    disease(13).duration=45
    disease(13).cause="mircroscopic parasitic lifeforms"
    disease(13).fatality=5
    disease(13).hal=25
    
    disease(14).no=14
    disease(14).desig="starts falling asleep randomly"
    disease(14).ldesc="narcolepsy"
    disease(14).incubation=5
    disease(14).duration=255
    disease(14).contagio=25
    disease(14).cause="viri"
    disease(14).fatality=45
    disease(14).nac=45
    
    disease(15).no=15
    disease(15).desig="suddenly starts bleeding from eye sockets and mouth."
    disease(15).ldesc="bleeding from eye sockets, mouth, nose, ears and fingernails"
    disease(15).incubation=1
    disease(15).duration=3
    disease(15).contagio=40
    disease(15).cause="agressive bacteria"
    disease(15).fatality=65
    
    disease(16).no=16
    disease(16).desig="suffers from radiation sickness"
    disease(16).ldesc="radiation sickness"
    disease(16).incubation=0
    disease(16).duration=255
    disease(16).contagio=0
    disease(16).cause="radiation"
    disease(16).fatality=55
    
    disease(17).no=17
    disease(17).desig="gets a bland expression"
    disease(17).ldesc="a wierd brain disease"
    disease(17).incubation=5
    disease(17).duration=15
    disease(17).contagio=75
    disease(17).fatality=85
      
   	return 0
end function
end namespace'tPlayer



function getfreecargo() as short
    dim re as short
    dim a as short
    for a=1 to 10
        if player.cargo(a).x=1 then re=re+1
    next
    return re
end function

function addmoney(amount as integer,mt as byte) as short
    player.money+=amount
    income(mt)+=amount
    return 0
end function

function randomname() as string
    dim f as integer
    dim d as integer
    dim count as integer
    dim ra as integer
    dim mask as string
    dim fname as string
    dim lines(128) as string
    dim desig as string="NNC - "
    dim suf as string
    f=freefile
    if (open ("register" for input as f))=0 then
        while not(eof(f))
            input #f,lines(count)
            if lines(count)<>"" then count=count+1
        wend
        close f
    endif
    d=val(lines(0))
    mask=lines(1)
    if lines(2)<>"" then
        fname=lines(2)
    else
        fname=mask
    endif
    if mask<>"" then
        ra=instr(mask,"####")
        desig=left(mask,ra-1)
        if len(mask)>ra+4 then suf=right(mask,ra+1)
    endif
    count=0
    f=freefile
    if (open (fname for input as f))=0 then
        do
            input #f,lines(count)
            lines(128)="savegames/" & lines(count)&".sav"
            if not(fileexists(lines(128))) then count=count+1

        loop until eof(f) or count>127
        ra=rnd_range(0,count)
        'print count;" ";ra;" ";lines(ra)
        'sleep

    endif

    d=d+1
    if d=0 then d=1
    if d>9999 then d=1
    desig= Pad(4,desig,"0") &d &suf  'add trailing zeroes, #, suffix
	    'if d<10 then desig=desig & "0"
	    'if d<100 then desig=desig & "0"
	    'if d<1000 then desig=desig & "0"
	    'desig=desig &d &suf

    if lines(ra)<>"" and count>0 then desig=lines(ra)
    f=freefile

    open "register" for output as f
    print #f,d
    print #f,mask
    print #f,fname

    close f
    return desig

end function



function settactics() as short
    dim as short a
    dim text as string
    screenshot(1)
    text="Tactics:/"
    for a=1 to 6
        if a=player.tactic+3 then
            text=text &" *"&tacdes(a)&"   "
        else
            text=text &"  "&tacdes(a)&"   "
        endif
        text=text &"/"
    next
    text=text &"Exit"
    a=textmenu(bg_awayteam,text,,,,1)
    if a<7 then
        player.tactic=a-3
    endif
    screenshot(2)
    return 0
end function



function weapon_string() as string
    dim as string t,weaponstring
    dim as short a,turrets
    weaponstring="{15}Weapons:|"
    for a=1 to player.h_maxweaponslot
        if player.weapons(a).desig<>"" then
            weaponstring=weaponstring &weapon_text(player.weapons(a)) &"|"
        else
            turrets+=1
        endif
    next

    if turrets=1 then weaponstring=weaponstring &"1 empty turret"
    if turrets>1 then weaponstring=weaponstring &turrets &" empty turrets"
    return weaponstring
end function




#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tPlayer -=-=-=-=-=-=-=-
	tModule.register("tPlayer",@tPlayer.init()) ',@tPlayer.load(),@tPlayer.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tPlayer -=-=-=-=-=-=-=-
#endif'test
