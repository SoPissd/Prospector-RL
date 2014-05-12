'tArtifacts.
'
'defines:
'artifacts_html=1, list_artifacts=3, artifact=13
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
'     -=-=-=-=-=-=-=- TEST: tArtifacts -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tArtifacts -=-=-=-=-=-=-=-

declare function artifacts_html(artflags() as short) as string
declare function list_artifacts(artflags() as short) as string
declare function artifact(c as short) as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tArtifacts -=-=-=-=-=-=-=-

namespace tArtifacts
function init() as Integer
	return 0
end function
end namespace'tArtifacts

Const lastartifact=25
Dim Shared artflag(lastartifact) As Short


function artifacts_html(artflags() as short) as string
    dim as short a,c
    dim flagst(22) as string
    dim as short hd,sd,ar,ss,bombs,cd
    flagst(1)="Fuel System"
    flagst(2)=" hand disintegrator"
    flagst(3)="Scanner"
    flagst(4)=" ship disintegrator"
    flagst(5)="Bodyarmor"
    flagst(6)="Engine"
    flagst(7)="Sensors"
    flagst(8)=" cryochamber"
    flagst(9)="Teleportation device"
    flagst(10)="Air recycler"
    flagst(11)="Data crystal(s)"
    flagst(12)="Cloaking device"
    flagst(13)="Wormhole shield"
    '14 Ancient bomb
    '15 Cloaking device
    flagst(16)="Wormhole navigation device"
    flagst(17)="Piloting AI"
    flagst(18)="Gunner AI"
    flagst(19)="Science AI"
    flagst(20)="Medical AI"
    flagst(21)="Neutronium armor"
    flagst(22)="Quantum warhead"
    set__color( 15,0)
    for a=0 to 5
        if instr(player.weapons(a).desig,"Disintegrator")>0 then sd+=1
    next
    for a=0 to lastitem
        if item(a).w.s=-1 then
            if (item(a).id=97 or item(a).id=197 or item(a).id=198 or item(a).id=199 or item(a).id=200) then hd+=1
            if (item(a).id=98 or item(a).id=298 or item(a).id=299) then ar+=1
            if item(a).id=523 or item(a).id=623 or item(a).id=624 then ss+=1
            if item(a).id=301 then bombs+=1
            if item(a).id=87 then CD+=1
        endif
    next
    flagst(0)=html_color("#ffffff") &"Artifacts:</span><br>"& html_color("#00ffff")
    for a=1 to 22
        if artflag(a)>0 then
            if a=2 or a=4 or a=8 or a=14 or a=15 or a=5 then

                if a=8 then
                    if player.cryo=1 then flagst(0)=flagst(0) & player.cryo & flagst(a)&"<br>"
                    if player.cryo>1 then flagst(0)=flagst(0) & player.cryo & flagst(a)&"<br>"
                endif
            else
                c=c+1
                flagst(0)=flagst(0) &flagst(a) &"<br>"
            endif
        endif
    next
    if c=0 and sd=0 and hd=0 and ar=0 and ss=0 and bombs=0 and CD=0 and player.cryo=0 then
        flagst(0)=flagst(0) & html_color("#ffff00")&"None</span><br>"
    endif

    if sd>1 then flagst(0)=flagst(0) &sd &" ship disintegrators<br>"
    if sd=1 then flagst(0)=flagst(0) &sd &" ship disintegrator<br>"
    if hd>1 then flagst(0)=flagst(0) & hd &" portable disintegrators<br>"
    if hd=1 then flagst(0)=flagst(0) & hd &" portable disintegrator<br>"
    if ar=1 then flagst(0)=flagst(0) & ar &" adaptive bodyarmor<br>"
    if ar>1 then flagst(0)=flagst(0) & ar &" adaptive bodyarmors<br>"
    if ss=1 then flagst(0)=flagst(0) & ss &" squid-suit<br>"
    if ss>1 then flagst(0)=flagst(0) & ss &" squid-suits<br>"
    if bombs=1 then flagst(0)=flagst(0) & bombs &" ancient bomb<br>"
    if bombs>1 then flagst(0)=flagst(0) & bombs &" ancient bombs<br>"
    if CD>0 then flagst(0)=flagst(0) &"Cloaking device<br>"
    if reward(4)>0 then flagst(0)=flagst(0) & reward(4) &" unidentified artifacts<br></span>."
    return flagst(0)
end function

function list_artifacts(artflags() as short) as string
    dim as short a,c
    dim flagst(25) as string
    dim as short hd,sd,ar,ss,bombs,cd
    flagst(1)="Fuel System"
    flagst(2)=" hand disintegrator"
    flagst(3)="Scanner"
    flagst(4)=" ship disintegrator"
    flagst(5)="Bodyarmor"
    flagst(6)="Engine"
    flagst(7)="Sensors"
    flagst(8)=" cryochamber"
    flagst(9)="Teleportation device"
    flagst(10)="Air recycler"
    flagst(11)="Data crystal(s)"
    flagst(12)="Cloaking device"
    flagst(13)="Wormhole shield"
    '14 Ancient bomb
    '15 Cloaking device
    flagst(16)="Wormhole navigation device"
    flagst(17)="Piloting AI"
    flagst(18)="Gunner AI"
    flagst(19)="Science AI"
    flagst(20)="Medical AI"
    flagst(21)="Neutronium armor"
    flagst(22)="Quantum warhead"
    flagst(23)="Repair-nanobots"
    flagst(24)="Ammo teleportation device"
    flagst(25)="Wormhole generator"
    set__color( 15,0)
    for a=0 to 5
        if instr(player.weapons(a).desig,"Disintegrator")>0 then sd+=1
    next
    for a=0 to lastitem
        if item(a).w.s=-1 then
            if (item(a).id=97 or item(a).id=197 or item(a).id=198 or item(a).id=199 or item(a).id=200) then hd+=1
            if (item(a).id=98 or item(a).id=298 or item(a).id=299) then ar+=1
            if item(a).id=523 or item(a).id=623 or item(a).id=624 then ss+=1
            if item(a).id=301 then bombs+=1
            if item(a).id=87 then CD+=1
        endif
    next
    for a=1 to 22
        if artflag(a)>0 then
            if a=2 or a=4 or a=8 or a=14 or a=15 or a=5 then

                if a=8 then
                    if player.cryo=1 then flagst(0)=flagst(0) & player.cryo & flagst(a)&"|"
                    if player.cryo>1 then flagst(0)=flagst(0) & player.cryo & flagst(a)&"s|"
                endif
            else
                c=c+1
                flagst(0)=flagst(0) &flagst(a) &"|"
            endif
        endif
    next
    if c=0 and sd=0 and hd=0 and ar=0 and ss=0 and bombs=0 and CD=0 and player.cryo=0 then
        flagst(0)=flagst(0) &"      {14} None |"
    endif

    flagst(0)="{15}Alien Artifacts {11}|"&flagst(0)
    if sd>1 then flagst(0)=flagst(0) &sd &" ship disintegrators|"
    if sd=1 then flagst(0)=flagst(0) &sd &" ship disintegrator|"
    if hd>1 then flagst(0)=flagst(0) & hd &" portable disintegrators|"
    if hd=1 then flagst(0)=flagst(0) & hd &" portable disintegrator|"
    if ar=1 then flagst(0)=flagst(0) & ar &" adaptive bodyarmor|"
    if ar>1 then flagst(0)=flagst(0) & ar &" sets of adaptive bodyarmor|"
    if ss=1 then flagst(0)=flagst(0) & ss &" squid-suit|"
    if ss>1 then flagst(0)=flagst(0) & ss &" squid-suits|"
    if bombs=1 then flagst(0)=flagst(0) & bombs &" ancient bomb|"
    if bombs>1 then flagst(0)=flagst(0) & bombs &" ancient bombs|"
    if CD>0 then flagst(0)=flagst(0) &"Cloaking device|"
    if reward(4)>0 then flagst(0)=flagst(0) & reward(4) &" unidentified artifacts."
    return flagst(0)
end function


function artifact(c as short) as short
    dim as short a,b,d,e,f
    dim text as string
    if c=1 then
        rlprint "It is an improved fuel system!"
        player.equipment(se_fuelsystem)=5
        player.fueluse=0.5
    endif
    
    
    if c=3 then
        rlprint "It is a very powerful portable scanner!"
        player.stuff(3)=2
    endif
    
    if c=4 then
        rlprint "It is a disintegrator cannon!"
        artflag(4)=0                
        d=player.h_maxweaponslot
        text="Weapon Slots:/"
        for e=1 to d
            if player.weapons(e).desig="" then
                text=text & "-Empty-/"
            else
                text=text & player.weapons(e).desig & "/"
            endif
        next
        text=text+"exit"
        d=d+1
        do 
        f=menu(bg_awayteam,text)
            if player.weapons(f).desig<>"" then 
                if askyn("do you want to replace that weapon? (y/n)") then 
                    player.weapons(f)=make_weapon(66)
                    f=d
                endif
            else
                player.weapons(f)=make_weapon(66)
                f=d
            endif
        loop until f=d
        recalcshipsbays
        cls
    endif
    
    if c=6 then 
        rlprint "It is an Improved ships engine!"
        player.engine=6
    endif
    if c=7 then 
        rlprint "It is a powerful ships sensor array!"
        player.sensors=6
    endif
    if c=8 then
        rlprint "These are cryogenic chambers. They are empty, but still working. You can easily install them on your ship."
        player.cryo=player.cryo+rnd_range(1,6)
        artflag(8)=0
    endif
    if c=9 then
        rlprint "This is a portable Teleportation Device!"
        reward(5)=5
    endif
    if c=10 then
        rlprint "It is a portable air recycling system!"
        player.stuff(4)=2
    endif
    if c=11 then
        artflag(11)=0
        rlprint "its a data crystal containing info on one of the systems in this sector"
        d=rnd_range(1,laststar)
        for e=1 to 9
            if map(d).planets(e)>0 then f=f+1
        next
        if map(d).discovered>=1 then
            rlprint "But you have already discovered that that system."
        else
            rlprint "It is at "&cords(map(d).c) &". It is "&add_a_or_an(spectralname(map(d).spec),0)&" with " & f & " planets."  
            map(d).discovered=1
        endif
    endif 
    if c=12 then
        rlprint "It's a ships cloaking device!"
        placeitem(make_item(87),0,0,0,-1)
        
    endif
    
    if c=13 then
        rlprint "It's a special shield to protect ships from wormholes!"
    endif
    
    if c=14 then
        rlprint "It's a powerful ancient bomb!"
        placeitem(make_item(301),0,0,0,0,-1)
        artflag(14)=0
    endif
    
    if c=15 then
        rlprint "It's a portable cloaking device!"
        placeitem(make_item(302),0,0,0,0,-1)
    endif
    
    if c=16 then
        rlprint "It's a device that allows to navigate wormholes!"
    endif
    
    if c=17 then
        rlprint "It's a sophisticated piloting AI"
        player.pipilot=7
    endif
    
    if c=18 then
        rlprint "It's a sophisticated gunner AI"
        player.pigunner=7
    endif
    
    if c=19 then
        rlprint "It's a sophisticated science AI"
        player.piscience=7
    endif
    
    if c=20 then
        rlprint "It's a sophisticated medical AI"
        player.pidoctor=8
    endif
    
    if c=21 then
        rlprint "It's technical specifications on neutronium-production!"
    endif
    if c=22 then
        rlprint "It's technical specifications how to build quantum-warheads!"
    endif
    
    if c=23 then
        rlprint "It's a batch of hull repairing nanobots!"
    endif
    
    if c=24 then
        rlprint "It's an ammo teleportation system!"
        player.reloading=1
    endif
    
    if c=25 then
        rlprint "It's a wormhole generator!"
    endif
    
    return 0
end function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tArtifacts -=-=-=-=-=-=-=-
	tModule.register("tArtifacts",@tArtifacts.init()) ',@tArtifacts.load(),@tArtifacts.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tArtifacts -=-=-=-=-=-=-=-
#endif'test
