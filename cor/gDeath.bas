'dDeath.
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
'     -=-=-=-=-=-=-=- TEST: dDeath -=-=-=-=-=-=-=-
#undef intest
#define test
#endif'test


#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

Dim Shared endstory As String

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: dDeath -=-=-=-=-=-=-=-

declare function messages() as short
declare function death_message(iShowMS as integer=0) as short

'declare function get_death() as string
'declare function death_text() as string

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: dDeath -=-=-=-=-=-=-=-

namespace dDeath
function init(iAction as integer) as integer
	return 0
end function
end namespace'dDeath

    
function messages() as short
    dim as short a,ll
    'screenshot(1)
    ll=tScreen.gth  '_lines*_fh1/_fh2
    set__color( 15,0)
    cls
    tScreen.drawfx(0,_fh2)
    for a=1 to ll
        locate a,1
        set__color( dtextcol(a),0)
        tScreen.draw2c(0,a,displaytext(a))
    next
    tScreen.drawfx(0,_fh2)
    no_key=uConsole.keyinput()
'    no_key=keyin(,1)
    'cls
    'screenshot(2)
    return 0
end function


function get_death() as string
    dim as string death,key 
    dim as short a,st
    if player.dead=1 then death="Captain forgot to refuel his spaceship"    
    if player.dead=2 then death="Captain became a cook after running out of money"
    if player.dead=3 or player.dead=25 then 
        key=left(player.killedby,1)
        player.killedby=add_a_or_an(player.killedby,0)
        if player.dead=3 then
            if player.landed.s>0 then 
                player.killedby=player.killedby & " under "
            else
                player.killedby=player.killedby & " on "
            endif
        endif
        if player.dead=25 then
            for a=1 to lastdrifting
                if player.landed.s=drifting(a).m then st=drifting(a).s
            next
            death="Captain got killed by "&player.killedby &" on "&add_a_or_an(shiptypes(st),0)
        else
            death="Captain got killed by " &player.killedby &"an unknown world"
        endif
    endif
    if player.dead=4 then death="Captain started his own Colony"
    if player.dead=5 then death="Got blasted into atoms by spacepirates"
    if player.dead=6 then death="Got sucked into a wierd Q-particle Wormhole"
    if player.dead=7 then death="Got killed in a valiant attempt to take out the pirates"
    if player.dead=8 then death="Got eaten by a plant monster"
    if player.dead=9 then death="Started the new following of apollo"
    if player.dead=10 then death="Ended as a red spot on a wall in an ancient city"
    if player.dead=11 then death="Got ripped apart by ravenous Sandworms"
    if player.dead=12 then death="Ship lost due to navigational error in gascloud"
    if player.dead=13 or player.dead=18 then death="Got blasted into atoms while trying to be a pirate"
    if player.dead=14 then death="Died of asphyxication while exploring too far"
    if player.dead=15 then death="Lost his ship while exploring a planet"
    if player.dead=16 then death="Got fried extra crispy while bathing in lava"
    if player.dead=17 then death="Dove into a sun on a doomed planet"
    if player.dead=19 then death="Underestimated the dangers of asteroid mining"
    if player.dead=20 then death="Got gobbled up by a space monster"
    if player.dead=21 then death="Got destroyed by an alien scoutship"
    if player.dead=22 then death="Suffered an accident while refueling at a gas giant"
    if player.dead=23 then death="Got eaten by gas giant inhabitants"
    if player.dead=24 then death="Lost in a worm hole"
    'player dead 25 is taken
    if player.dead=26 then death="Lost a duel against the infamous Anne Bonny"
    if player.dead=27 then death="Attempted to land on a gas giant without his spaceship"
    if player.dead=28 then death="Underestimated the risks of surgical body augmentation"
    if player.dead=29 then death="Got caught in a huge explosion"
    if player.dead=30 then death="Lost while exploring an anomaly"
    if player.dead=31 then death="Destroyed battling an ancient alien ship"
#ifdef civ
    if player.dead=32 then death="Died in battle with the "&civ(0).n 
    if player.dead=33 then death="Died in battle with the "&civ(1).n
#else
#print "dDeath.bas: compiled without access to civ()"
    if player.dead=32 then death="Died in battle with the <civ(0).n>" 
    if player.dead=33 then death="Died in battle with the <civ(1).n>"
#endif    
    if player.dead=34 then death="Surfed to his death on a chunk of ice"
    if player.dead=35 then death="Flew into his own engine exaust"
    if player.dead=98 then death="Captain got filthy rich as a prospector"
    death=death &" after "&display_time(tVersion.gameturn,2) &"."
    return death
end function


function death_text() as string
    dim text as string
    if player.dead<>99 and player.fuel<=0 then player.dead=1
    
    if player.dead=1 then text="You ran out of fuel. Slowly your life support fails while you wait for your end beneath the eternal stars"
    if player.dead=2 then text="The station impounds your ship for outstanding depts. You start a new career as cook at the stations bistro"
    if player.dead=3 then text="Your awayteam was obliterated. your Bones are being picked clean by alien scavengers under a strange sun"
    if player.dead=4 then text="After a few months stranded on an alien world you decide to stop sending distress signals, and try to start a colony with your crew. All works really well untill one day that really big animal shows up..."
    if player.dead=5 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by pirates"
    if player.dead=6 then text="Farewell Captain!"
    if player.dead=7 then text="You didn't think the pirates base would be the size of a city, much less a whole planet. The last thing you see is the muzzle of a pirate gaussgun pointed at you."
    'if player.dead=8 then text= "You think you can see a malicious grin beneath the leaves as the prehensile vines snap your neck"
    if player.dead=9 then text="Apollo convinces you with bare fists and lightningbolts that he in fact is a god"
    if player.dead=10 then text="The robots defending the city are old, but still very well armed and armored. Their long gone masters would have been pleased to learn how easily they repelled the intruders."
    if player.dead=11 then text="The Sandworm swallows the last of your awayteam with one gulp"
    if player.dead=12 then text="Explosions start rocking your ship as the interstellar gas starts ripping holes into the hull. You try to make a quick run out but you aren't fast enough."
    if player.dead=13 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by the merchants escort ships"
    if player.dead=14 then text="You run out of oxygen on an airless world. Your death comes quick"
    if player.dead=15 then text="With horror you watch as the ground cracks open beneath the " &player.desig &" and your ship disappears in a sea of molten lava"
    if player.dead=16 then text="Trying to cross the lava field proved to be too much for your crew"
    if player.dead=17 then text="The world around you dissolves into an orgy of flying rock, bright light and fire. Then all is black."
    if player.dead=18 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed while trying to "&space(41)&"ignore the station commanders wishes"
    if player.dead=19 then text="Your pilot crashes the ship into the asteroid. You feel very alone as you drift in your spacesuit among the debris, hoping for someone to pick up your weak distress signal."
    if player.dead=20 then text="When the monster destroys your ship your only hope is to leave the wreck in your spacesuit. With dread you watch it gobble up the debris while totally ignoring the people it just doomed to freezing among the asteroids."
    if player.dead=21 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by an ancient alien ship"
    if player.dead=22 then text="A creaking hull shows that your pilot underestimated the pressure and gravity of this gas giant. Heat rises as you fall deeper and deeper into the atmosphere with ground to hit below. Your ship gets crushed. You are long dead when it eventually gets torn apart by winds and evaporated by the rising heat."
    if player.dead=23 then text="The creatures living here tore your ship to pieces. The winds will do the same with you floating through the storms of the gas giant like a leaf in a hurricane."
    if player.dead=24 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by the" &space(41)& "strange forces inside the wormhole"
    if player.dead=25 then text="The inhabitants of the ship overpower you. Now two ships will drift through the void till the end of time."
    if player.dead=26 then text="The weapons of the Anne Bonny fire one last time before your proud ship gets turned into a cloud of hot gas."
    if player.dead=27 then text="Within seconds the refueling platform and your ship are high above you. Jetpacks won't suffice to fight against the gas giants gravity. You plunge into your fiery death."
    if player.dead=28 then text="The last thing you remember is the doctor giving you an injection. Your corpse will be disposed of."
    if player.dead=29 then text="A huge wall of light and fire appears on the horizon. Within the blink of an eye it rushes over you, dispersing your ashes in the wind."
    if player.dead=30 then text="High gravity shakes your ship. Suddenly an energy discharge out of nowhere evaporates your ship!"
    if player.dead=31 then text="Hardly damaged the unknown vessel continues it's way across the stars, ignoring the burning wreckage of your ship."
    if player.dead=32 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by an alien vessel"
    if player.dead=33 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by an alien vessel"
    if player.dead=34 then text="Too late you realize that your ride on the icechunk has brought you too deep into the gas giants atmosphere. Rising pressure squashes you, as the iceblock disintegrates around you."
    if player.dead=35 then text="The dangers of spacecombat are manifold. Flying into your own engine exhaust is one of them."
    if player.dead=98 then
        endstory=tRetirement.es_part1
        textbox (endstory,2,2,tScreen.x/_fw2-5)
        text=endstory
    endif
    if player.dead=99 then text="Till next time!"
    return text
end function


function death_message(iShowMS as integer=0) as short
    dim as string text,text2
    dim as short b,a,wx,tx
    text=""
    
    if player.dead<99 then
    	if not fileexists("summary/"&player.desig &".png") then screenshot(3)
    EndIf 
    
    text=death_text()
    text2=text
    b=0
    cls
    set__color( 12,0)
    if text<>"" and player.dead<>98 then
	    if tScreen.isGraphic then
		    tGraphics.background()
	        set__color( 11,0)
	        tx=tScreen.x/_fw1-10
		    tScreen.drawfx(_fw1,_fh1)
	        while len(text)>tx
	            a=40
	            do 
	                a=a-1
	            loop until mid(text,a,1)=" "        
	            tScreen.drawtt(5,tScreen.gth/2-4+b,left(text,a))
	'            tScreen.drawtt(5,_lines/2-4+b*(tScreen.y/15),left(text,a))
	            text=mid(text,a,(len(text)-a+1))
	            b=b+1
	        wend
	        'draw_string (5*_fw1,(_lines*_fh1)/2-(4*_fh1)+b*(tScreen.y/15),text,TITLEFONT,_tcol)
	        tScreen.drawtt(5,tScreen.gth/2-4+b,text)
	'        tScreen.drawtt(5*_fw1,(_lines*_fh1)/2-(4*_fh1)+b*(tScreen.y/15),text)',TITLEFONT,_tcol)
		    tScreen.drawfx()        
	    else
	        tx=tScreen.x/_fw1-10
	        while len(text)>tx
	            a=40
	            do 
	                a=a-1
	            loop until mid(text,a,1)=" "        
	            tScreen.xy(5,tScreen.gth/2-4+b,left(text,a))
	            text=mid(text,a,(len(text)-a+1))
	            b=b+1
	        wend
			tScreen.xy(5,tScreen.gth/2-4+b,text)
	    endif
    EndIf
    
	no_key=uConsole.aGetKey(iShowMS)

    if player.dead<99 then 
        if askyn("Do you want to see the last messages again?(y/n)") then rlmessages()
        high_score(text2)
    endif

    return 0
end function

#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: dDeath -=-=-=-=-=-=-=-
	tModule.register("dDeath",@dDeath.init()) ',@dDeath.load(),@dDeath.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: dDeath -=-=-=-=-=-=-=-
#endif'test
