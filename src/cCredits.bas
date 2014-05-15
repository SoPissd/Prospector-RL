'tCredits.
'
'defines:
'mission_type=1, money_text=1
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
'     -=-=-=-=-=-=-=- TEST: tCredits -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tCredits -=-=-=-=-=-=-=-

declare function mission_type() as string
declare function money_text() as string


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tCredits -=-=-=-=-=-=-=-

namespace tCredits
function init() as Integer
	return 0
end function
end namespace'tCredits


#define cut2top

'declare function shares_value() as short


function mission_type() as string
    dim text as string
    dim per(4) as uinteger
    dim as uinteger i,h,highest

    per(0)=income(mt_ress)+income(mt_bio)+income(mt_map)+income(mt_ano)+income(mt_artifacts)
    per(1)=income(mt_trading)+income(mt_quest)+income(mt_bonus)+income(mt_escorting)+income(mt_towed)
    per(2)=income(mt_pirates)
    per(3)=income(mt_piracy)+income(mt_gambling)+income(mt_blackmail)
    per(4)=income(mt_quest)+income(mt_quest2)+income(mt_escorting)
    text= "{15}Mission type: {11}"
    for i=0 to 4
        if per(i)>highest then
            highest=per(i)
            h=i
        endif
    next
    if h=0 then text &="Explorer|"
    if h=1 then text &="Merchant|"
    if h=2 then text &="Pirate hunter|"
    if h=3 then text &="Pirate|"
    if h=4 then text &="Errand boy|"

    return text
end function




function money_text() as string
    dim text as string
    dim as short b,a

    text=text & " | "
    for a=1 to st_last-1
        piratekills(0)+=piratekills(a)
    next
    if piratekills(0)=0 then
        text=text &"Did not win any space battles"
    else
        text=text &"Fought "&piratekills(0) &" space battles:|"
        for a=1 to st_last-1
            if piratekills(a)=1 then text=text & "Won a battle against "&add_a_or_an(piratenames(a),0) &"s|"
            if piratekills(a)>1 then text=text & "Won " &piratekills(a)& " battles against "&piratenames(a) &"s|"
        next
    endif
'    if player.piratekills>0 then
'    if player.piratekills>0 then
'        if player.piratekills>0 and player.money>0 then per(2)=100*(player.piratekills/player.money)
'        if per(2)>100 then per(2)=100
'        text=text &" {10}"& credits(player.piratekills) & " {11} Credits were from bountys for destroyed pirate ships (" &per(2) &")"
'    else
'        text=Text & "No Pirate ships were destroyed"
'    endif

    text=text & " | "

    if piratebase(0)=-1 then
        text =text & "Destroyed the Pirates base of operation! |"
    endif
    b=0
    for a=1 to _NoPB
        if piratebase(a)=-1 then b=b+1
    next
    if b=1 then
        text=text & " Destroyed a pirate outpost. |"
    endif
    if b>1 then
        text=text & " Destroyed " & b &" pirate outposts. |"
    endif

        'if faction(0).war(1)<=0 then text=text & "Made all money with honest hard work"
        'if player.merchant_agr>0 and player.pirate_agr<50 then text = text & "Found piracy not to be worth the hassle"
        'if player.pirate_agr<=0 and player.merchant_agr>50 then text = text & "Made a name as a bloodthirsty pirate"
    text=text &" |"
    return text
end function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tCredits -=-=-=-=-=-=-=-
	tModule.register("tCredits",@tCredits.init()) ',@tCredits.load(),@tCredits.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tCredits -=-=-=-=-=-=-=-
#endif'test
