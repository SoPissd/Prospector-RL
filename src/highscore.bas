'highscore.
'
'defines:
'income_expenses_html=0, income_expenses=1, space_mapbmp=0, get_death=0,
', death_text=0, explper=0, exploration_text=0, ship_table=0,
', planet_artifacts_table=0, crew_table=0, score=5,
', exploration_text_html=0, acomp_table=0, postmort_html=0,
', post_mortemII=0, high_score=1, death_message=1
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
'     -=-=-=-=-=-=-=- TEST: highscore -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: highscore -=-=-=-=-=-=-=-

declare function income_expenses() as string
declare function score() as integer
declare function high_score(text as string) as short
declare function death_message() as short

'private function income_expenses_html() as string
'private function space_mapbmp() as short
'private function get_death() as string
'private function death_text() as string
'private function explper() as short
'private function exploration_text() as string
'private function ship_table() as string
'private function planet_artifacts_table() as string
'private function crew_table() as string
'private function exploration_text_html() as string
'private function acomp_table() as string
'private function postmort_html(text as string) as short
'private function post_mortemII(text as string) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: highscore -=-=-=-=-=-=-=-

namespace tHighscore
function init() as Integer
	return 0
end function
end namespace'tHighscore


Type _table
    points As Integer
    desig As String *80
    death As String *80
End Type

'
' Calculate and display Highscore and post-mortem
'

function income_expenses_html() as string
    dim t as string
    dim as string desig(mt_last)
    dim as short per(mt_last),l
    dim as integer i,ex
    desig(mt_startcash)="Cash:"
    desig(mt_bonus)="Corp boni:"
    desig(mt_quest)="Corp contracts:"
    desig(mt_pirates)="Pirate bounties:"
    desig(mt_ress)="Resources:"
    desig(mt_bio)="Biodata:"
    desig(mt_map)="Mapping:"
    desig(mt_ano)="Anomalies:"
    desig(mt_trading)="Trading:"
    desig(mt_towed)="Towing:"
    desig(mt_escorting)="Escorting:"
    desig(mt_artifacts)="Artifacts:"
    desig(mt_blackmail)="Blackmail:"
    desig(mt_piracy)="Piracy:"
    desig(mt_gambling)="Gambling:"
    desig(mt_quest2)="Errands:"
    desig(mt_last)="Total:"
    income(mt_last)=0
    for i=0 to mt_last-1
        income(mt_last)+=income(i)
    next
    income(mt_last)+=tCompany.shares_value()
    for i=0 to mt_last-1
        per(i)=int((income(i)/income(mt_last))*100)
        if len(desig(i)&credits(income(i)))>l then l=len(desig(i)&credits(income(i)))
    next
    per(mt_last)=int(tCompany.shares_value()/income(mt_last)*100)
    l=l+7
    t="<table><tbody><tr><td>"& html_color("#ffffff") &"Income:</span></td><td></td></tr>"
    i=0

    if income(i)>0 then t=t &"<tr><td>"& html_color("#ffffff") &desig(i) &"</span></td><td align=right>" & html_color("#00ff00")&credits(income(i))&" Cr.</span></td><td>"& html_color("#00ff00")&"(" &per(i)& "%)</span></div></td></tr>"
    if tCompany.shares_value()>0 then t=t &"<tr><td>"& html_color("#ffffff") &"Stock:</span></td><td align=right>" & html_color("#00ff00")&credits(tCompany.shares_value())&" Cr.</span></td><td>"& html_color("#00ff00")&"(" &per(mt_last)& "%)</span></div></td></tr>"

    for i=1 to mt_last-1
        if income(i)>0 then t=t &"<tr><td>"& html_color("#ffffff") &desig(i) &"</span></td><td align=right>" & html_color("#00ff00")&credits(income(i))&" Cr.</span></td><td>"& html_color("#00ff00")&"(" &per(i)& "%)</span></div></td></tr>"
    next
    t=t &"<tr><td><br>"& html_color("#ffffff") &desig(i) &"</span></td><td align=right><br>" & html_color("#00ff00")&credits(income(i))&" Cr.</div></td></tr>"

    ex=player.money-income(mt_last)
    t=t &"<tr><td><br>" & html_color("#ffffff") & "Expenses:</span> </td><td align=right><br>"& html_color("#ff0000") & credits(ex)& " Cr.</span></td></td><td></tr>"
    t=t &"<tr><td><br>" & html_color("#ffffff") & "Revenue:</span></td><td align=right><br>" & html_color("#00ff00")&credits(player.money) &" Cr.</span></td></td><td></tr>"
    t=t &"</tbody></table><br>Equipment value: "& html_color("#00ff00")&credits(equipment_value)&" Cr.</span>"

    return t
end function


function income_expenses() as string
    dim text as string
    dim as string desig(mt_last)
    dim as short per(mt_last),l
    dim as integer i,ex
    desig(mt_startcash)="Cash:"
    desig(mt_bonus)="Corp boni:"
    desig(mt_quest)="Corp contracts:"
    desig(mt_pirates)="Pirate bounties:"
    desig(mt_ress)="Resources:"
    desig(mt_bio)="Biodata:"
    desig(mt_map)="Mapping:"
    desig(mt_ano)="Anomalies:"
    desig(mt_trading)="Trading:"
    desig(mt_towed)="Towing:"
    desig(mt_escorting)="Escorting:"
    desig(mt_artifacts)="Artifacts:"
    desig(mt_blackmail)="Blackmail:"
    desig(mt_piracy)="Piracy:"
    desig(mt_gambling)="Gambling:"
    desig(mt_quest2)="Errands:"
    desig(mt_last)="Total:"
    income(mt_last)=0
    for i=0 to mt_last-1
        income(mt_last)+=income(i)
    next
    income(mt_last)+= tCompany.shares_value()
    for i=0 to mt_last
        per(i)=int((income(i)/income(mt_last))*100)
        if len(desig(i)&credits(income(i)))>l then l=len(desig(i)&credits(income(i)))
    next
    per(mt_last)=int(tCompany.shares_value/income(mt_last)*100)
    l=l+7
    text="{15}Income:|"
    if tCompany.shares_value()>0 then text=text &"  {11}"&"Stock" &space(l-len(credits(tCompany.shares_value()))-len("Stock"))_
    		&"{" & c_gre &  "}"&credits(tCompany.shares_value()) & " Cr. (" &per(mt_last)& "%)|"

    for i=0 to mt_last-1
        if income(i)>0 then text=text &"  {11}"&desig(i) &space(l-len(desig(i))-len(credits(income(i))))&"{" & c_gre &  "}"&credits(income(i)) & " Cr. (" &per(i)& "%)|"
    next
    text=text &"|  {11}"&desig(mt_last) &space(l-len(desig(mt_last))-len(credits(income(mt_last))))&"{" & c_gre &  "}"&credits(income(i)) & " Cr.|"
    ex=player.money-income(mt_last)
    text=text &"|{15}Expenses:|  {"&c_red & "}" & space(l-len(credits(ex)))&credits(ex)&_
    " Cr.|{15}Revenue:|  "&space(l-len(credits(player.money))) &"{11}"&credits(player.money) &" Cr."

    return text
end function


function space_mapbmp() as short
    dim as any ptr img
    dim as short x,y,a,n,ti_no,minx,maxx,miny,maxy
    dim as byte debug=1
    DbgPrint("configflag(con_tiles)"&configflag(con_tiles))
    minx=-1
    miny=-1
    maxx=-1
    maxy=-1
    for x=0 to sm_x
        for y=0 to sm_y
#if __FB_DEBUG__ 'huh
            spacemap(x,y)=abs(spacemap(x,y))
#endif
            if spacemap(x,y)>0 then
                if minx=-1 or minx>x then minx=x
                if miny=-1 or miny>y then miny=y
                if maxx=-1 or maxx<x then maxx=x
                if maxy=-1 or maxy<y then maxy=y
            endif
        next
    next
    
    for a=1 to laststar+wormhole
        if map(a).discovered>0 then
            x=map(a).c.x
            y=map(a).c.y
            if minx=-1 or minx>x then minx=x
            if miny=-1 or miny>y then miny=y
            if maxx=-1 or maxx<x then maxx=x
            if maxy=-1 or maxy<y then maxy=y
        endif
    next
    
    for a=1 to lastdrifting
        if drifting(a).p=1 then
            x=drifting(a).x
            y=drifting(a).y
            if minx=-1 or minx>x then minx=x
            if miny=-1 or miny>y then miny=y
            if maxx=-1 or maxx<x then maxx=x
            if maxy=-1 or maxy<y then maxy=y
        endif
    next
    if maxx-minx<25 then
        maxx+=12
        minx-=12
        if minx<0 then minx=0
        if maxx>sm_x then maxx=sm_x
    endif
    
    img=imagecreate((maxx-minx+1)*_fw1,(maxy-miny+1)*_fh1,rgba(0,0,77,0))
    
    for x=0 to sm_x
        for y=0 to sm_y
            if spacemap(x,y)>0 then
                if configflag(con_tiles)=0 then
                    if spacemap(x,y)=1 then put img,((x-minx)*_tix,(y-miny)*_tiy),gtiles(50),pset
                    if spacemap(x,y)>=2 and spacemap(x,y)<=20 then
                        if spacemap(x,y)>10 then 
                            ti_no=spacemap(x,y)-10
                        else
                            ti_no=spacemap(x,y)
                        endif
                        put img,((x-minx)*_tix,(y-miny)*_tiy),gtiles(ti_no+49),trans
                    endif
                else
                    set__color(1,0)
                    if spacemap(x,y)=1 then draw string img,((x-minx)*_fw1,(y-miny)*_fh1),".",,Font1,custom,@_col
                    
                    if spacemap(x,y)>=2 and spacemap(x,y)<=5 then
                        set__color( rnd_range(48,59),1)
                        if spacemap(x,y)=2 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(48,59),1)
                        if spacemap(x,y)=3 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(96,107),1)
                        if spacemap(x,y)=4 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(144,155),1)
                        if spacemap(x,y)=5 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(192,203),1)
                        draw string img,((x-minx)*_fw1,(y-miny)*_fh1),chr(176),,Font1,custom,@_col
                    endif
                    if spacemap(x,y)>5 then
                        if spacemap(x,y)>10 then
                            ti_no=spacemap(x,y)-10
                        else
                            ti_no=spacemap(x,y)
                        endif
                        if ti_no=6 then set__color( 2,0)
                        if ti_no=7 then set__color( 10,0)
                        if ti_no=8 then set__color( 4,0)
                        if ti_no=9 then set__color( 12,0)
                        if ti_no=10 then set__color( 3,0)
                        draw string img,((x-minx)*_fw1,(y-miny)*_fh1),":",,Font1,custom,@_col
                    endif
                endif
            endif
        next
    next
    for a=1 to lastdrifting
#if __FB_DEBUG__
'        if drifting(a).p=1 or (debug=1  and _debug=1) then
#endif
        if drifting(a).p=1 or (debug=1) then
            if configflag(con_tiles)=0 then
                if drifting(a).g_tile.x=0 or drifting(a).g_tile.x=5 or drifting(a).g_tile.x>9 then drifting(a).g_tile.x=rnd_range(1,4)
                put img,((drifting(a).x-minx)*_fw1,(drifting(a).y-miny)*_fh1),stiles(drifting(a).g_tile.x,drifting(a).g_tile.y),trans
            else
                set__color(7,0)
                draw string img,((drifting(a).x-minx)*_fw1,(drifting(a).y-miny)*_fh1),"s",,Font1,custom,@_col
            endif
        endif
    next
    for a=0 to laststar+wormhole
#if __FB_DEBUG__
'        if map(a).discovered>0  or (debug=1 and _debug=1) then
#endif
        if map(a).discovered>0  or (debug=1) then
            if configflag(con_tiles)=0 then
                put img,((map(a).c.x-minx)*_fw1,(map(a).c.y-miny)*_fh1),gtiles(map(a).ti_no),trans
            else
                set__color( spectraltype(map(a).spec),0)
                if map(a).spec<8 then draw string img,((map(a).c.x-minx)*_fw1,(map(a).c.y-miny)*_fh1),"*",,Font1,custom,@_tcol
                if map(a).spec=8 then     
                    set__color( 7,0)
                    draw string img,((map(a).c.x-minx)*_fw1,(map(a).c.y-miny)*_fh1),"o",,Font1,custom,@_tcol
                endif
                if map(a).spec=9 then 
                    n=distance(map(a).c,map(map(a).planets(1)).c)/5
                    if n<1 then n=1
                    if n>6 then n=6
                    set__color( 179+n,0)
                    draw string img,((map(a).c.x-minx)*_fw1,(map(a).c.y-miny)*_fh1),"o",,Font1,custom,@_tcol
                endif
                if map(a).spec=10 then
                    set__color(63,0)
                    draw string img,((map(a).c.x-minx)*_fw1,(map(a).c.y-miny)*_fh1),"O",,Font1,custom,@_col
                endif
            endif
        endif
    next
    for a=0 to 2
        if basis(a).c.x>=minx and basis(a).c.y>=miny and basis(a).c.x<=maxx and basis(a).c.y<=maxy then
            if configflag(con_tiles)=1 then
                set__color(15,0)
                draw string img,((basis(a).c.x-minx)*_fw1,(basis(a).c.y-miny)*_fh1),"S",,Font1,custom,@_col
            else
                put img,((basis(a).c.x-minx)*_tix,(basis(a).c.y-miny)*_tiy),gtiles(44),trans
            endif
        endif
    next
    if configflag(con_tiles)=0 then
        put img,((player.c.x-minx)*_tix-(_tiy-_tix)/2,(player.c.y-miny)*_tiy),stiles(player.di,player.ti_no),trans
    else
        set__color( _shipcolor,0)
        draw string img,((player.c.x-minx)*_fw1,(player.c.y-miny)*_fh1),"@",,Font1,custom,@_col
    endif
#if __FB_DEBUG__
    if debug=1 then
        set__color(15,0)
        for a=11 to lastwaypoint
            x=targetlist(a).x
            y=targetlist(a).y
            if x>=minx and x<=maxx and y>=miny and y<=maxx then
                draw string img,((targetlist(a).x-minx)*_tix,(targetlist(a).y-miny)*_tiy),"*",,font1,custom,@_col
            endif
        next
    endif
#endif
    savepng( "summary/" &player.desig &"-map.png", img, 1)
    imagedestroy img
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
    if player.dead=32 then death="Died in battle with the "&civ(0).n 
    if player.dead=33 then death="Died in battle with the "&civ(1).n
    if player.dead=34 then death="Surfed to his death on a chunk of ice"
    if player.dead=35 then death="Flew into his own engine exaust"
    if player.dead=98 then death="Captain got filthy rich as a prospector"
    death=death &" after "&display_time(tVersion.gameturn,2) &"."
    return death
end function


function death_text() as string
    dim text as string
    if player.fuel<=0 then player.dead=1
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


function explper() as short
    dim as single per
    dim as integer a,b,tp,xx,yy,exl, exps,expp,total
    for a=0 to laststar
        if map(a).discovered>0 then
            exps=exps+1
            for b=1 to 9
                if map(a).planets(b)>0 then
                    tp+=1
                    if planets(map(a).planets(b)).mapstat<>0 then expp=expp+1
                    for xx=0 to 60
                        for yy=0 to 20
                            if planetmap(xx,yy,map(a).planets(b))>0 then exl=exl+1
                            total=total+1
                        next
                    next
                endif
            next
        endif
    next
    if exl>0 and total>0 then
        per=((exl/total)*100)
        if per>100 then per=100
    endif
    return int(per)
end function


function exploration_text() as string
    dim text as string
    dim as short a,b,c,xx,yy,exps,expp,exl,tp,total,per,visited,docked,alldockings,wormdis,wormtra
    dim discovered(lastspecial) as short

    for a=0 to laststar
        if map(a).discovered>0 then exps=exps+1
        for b=1 to 9
            if map(a).planets(b)>0 then
                tp+=1
                if planets(map(a).planets(b)).mapstat<>0 then expp=expp+1
                for xx=0 to 60
                    for yy=0 to 20
                        if planetmap(xx,yy,map(a).planets(b))>0 then exl=exl+1
                        total=total+1
                    next
                next
                if planets(map(a).planets(b)).visited>0 then visited+=1
            endif
        next
    next
    for c=0 to lastspecial
        if specialplanet(c)>=0 and specialplanet(c)<=lastplanet then
            if planets(specialplanet(c)).visited<>0 then discovered(c)=1
        endif
    next
    for c=laststar+1 to laststar+wormhole
        if map(c).discovered>0 then wormdis+=1
        if map(c).planets(2)>0 and map(c).planets(3)=0 then
            wormtra+=1
            map(map(c).planets(1)).planets(3)=-1 'Dont count twice
        endif
    next

    text="{15}Exploration log:{11}|"& explored_percentage_string
    if exps=0 then text=text &"|Discovered no systems and mapped "
    if exps=1 then text=text &"|Discovered {15}" & exps & "{11} system ({15}" &int((exps/laststar)*100) & "%{11}) and mapped "
    if exps>1 and exps<laststar then text=text &"|Discovered {15}" & exps & "{11} systems ({15}" &int((exps/laststar)*100) & "%{11}) and mapped "
    if exps=laststar then text=text &"|Discovered all systems and mapped "

    if expp=0 then  text = text & "{15}none{11} of " &tp &" planets. ({15}" &explper &"{11} %) "
    if expp=1 then  text = text &"{15}"& expp & "{11} of " &tp &" planets. ({15}" &explper &" %{11}) "
    if expp>1 and expp<tp then  text = text &"{15}"& expp & "{11} of " &tp &" planets. ({15}" &explper &" %{11}) "
    if expp=tp then  text = text & expp & "{15}all{11} of " &tp &" planets. ({15}" &explper &" %{11}) "

    if wormdis=0 then text=text &"|Didn't discover any wormholes"
    if wormdis=1 then text=text &"|Discovered {15}a{11} wormhole"
    if wormdis>1 and wormdis<wormhole then text=text &"|Discovered {15}" & wormdis & "{11} wormholes"
    if wormdis=wormhole then text=text &"|Discovered {15}all{11} wormholes"
    if wormtra=0 then text = text &"."
    if wormdis=1 and wormtra=1 then text=text &" and travelled through {15}it{11}."
    if wormdis>1 and wormtra=1 then text=text &" and travelled through {15}one{11} of them."
    if wormdis>1 and wormtra>1 and wormtra<wormhole/2 then text=text &" and travelled through {15}" & wormtra & "{11} of them."
    if wormdis=wormhole and wormtra=wormhole/2 then text =text &" and travelled through {15}all{11} of them."
    text=text &"|The farthest expedition took the "&player.desig &" {15}"&farthestexpedition &"{11} parsec out from the nearest spacestation."
    for c=0 to 3
        if basis(c).docked>0 then docked+=1
        alldockings+=basis(c).docked
    next

    if alldockings=0 then text=text &"|Never docked at a major space station"
    if docked=4 then text=text &"|Docked at all major space stations and helped establish a new one"
    if docked=3 then text=text &"|Docked at all major space stations"
    if docked>1 and docked<3 then text=text &"|Docked at "&docked &" major space stations"
    if docked=1 then text=text &"|Docked at a major space station"
    if alldockings=1 then text=text &" once."
    if alldockings>1 then text=text &" for a total of {15}"&alldockings &"{11} times."
    if ranoutoffuel=0 then text=text &"|Always had a full tank."
    if ranoutoffuel=1 then text=text &"|Forgot to fill up his spaceship that one time."
    if ranoutoffuel>1 then text=text &"|Ran out of fuel {15}" &ranoutoffuel & "{11} times."
    if visited=0 then text=text &"|Never set foot on an alien world."
    if visited=1 then text=text &"|Landed on {15}"&visited &"{11} planet."
    if visited>1 and visited<tp then text=text &"|Landed on {15}"&visited &"{11} planets."
    if visited=tp then text=text &"|Landed on every planet in the sector."

    b=0
    for a=0 to 25
        if discovered(a)=1 then b=b+1
    next
    if b=0 then
        text=text & "|No remarkable planets discovered."
    endif
    if b>0 then
        if b=1 then
            text=text & "|One remarkable planet discovered."
        else
            text=text & "|{15}"& b &"{11} remarkable planets discovered."
        endif
    endif

    text=text & " |Defeated "
    if player.alienkills=0 then text =text & "no aliens"
    if player.alienkills=1 then text =text & "{15}"&player.alienkills &"{11} alien."
    if player.alienkills>1 then text =text & "{15}"&player.alienkills &"{11} aliens."

    if player.deadredshirts=0 and player.dead=98 then text=text & " |Set new safety standards for space exploration by not losing a single crewmember."
    if player.deadredshirts=1 then text=text & " |{12}One{11} casualty among the crew."
    if player.deadredshirts>1 then text=text & " |{12}"& player.deadredshirts &"{11} casualties among the crew."
    return text
end function

'

function ship_table() as string
    dim as string t,weaponstring
    dim as short a,turrets
    weaponstring=weapon_string
    t="<table width=" &chr(34) &"80%"&chr(34)& " align=" &chr(34) &"center"&chr(34)& "><tbody><tr><td  width=" &chr(34) &"33%" &chr(34)& " valign=" &chr(34)& "top" &chr(34)& "><div>{15}Name: {11}"&player.desig &"{15} Type:{11}" &player.h_desig &"<br>"
    t=t & shipstatsblock &"</div></td><td valign=" &chr(34)& "top" &chr(34)& " width=" &chr(34) &"33%" &chr(34)& "><div>" & weaponstring &"</div></td><td valign=" &chr(34)& "top" &chr(34)& " width=" &chr(34) &"33%" &chr(34)& "><div>" & cargo_text &"</div></td></tr></tbody></table><br>"
    t=text_to_html(t)
    return t
end function


function planet_artifacts_table() as string
    dim t as string
    dim as byte unflags(lastspecial)
    make_unflags(unflags())
    t="<table width=" &chr(34) &"80%"&chr(34)& " align=" &chr(34) &"center"&chr(34)& "><tbody><tr><td valign=" &chr(34)& "top" &chr(34)& "><tbody><tr><td valign=" &chr(34)& "top" &chr(34)&">"
    t=t &"<div>" &uniques_html(unflags()) &"</div>"
    t=t &"</td><td valign=" &chr(34)& "top" &chr(34)&">"
    t=t &"<div>" &artifacts_html(artflag()) &"</div>"
    t= t &"</td></tr><tbody></table>"
    return t
end function


function crew_table() as string
    dim as string t
    dim as short l,i,m
    l=count_crew(crew())
    if l mod 2=0 then
        m=cint(l/2)
    else
        m=cint(l/2)+1
    endif
    t="<table width=" &chr(34) &"80%"&chr(34)& " align=" &chr(34) &"center"&chr(34)& "><tbody><tr><td valign=" &chr(34)& "top" &chr(34)& ">"
    t=t &"<div>"
    for i=1 to m
        t=t &crew_html(crew(i))
    next
    t=t &"</div>"
    t=t &"</td><td valign=" &chr(34)& "top" &chr(34)& ">"
    t=t &"<div>"
    for i=m+1 to l
        t=t &crew_html(crew(i))
    next
    t=t &"</div>"
    t=t &"</td></tr></tbody></table>"
    return t
end function



function score() as integer
    dim s as integer
    dim a as short
    dim b as short
    dim c as short
    s=s+player.hull
    s=s+player.shieldmax
    s=s+player.money-income(mt_pirates)
    s=s+tVersion.gameturn
    s=s+player.pilot(1)*100
    s=s+player.gunner(1)*100
    s=s+player.science(1)*100
    s=s+player.doctor(1)*100
    s=s+player.sensors
    s=s+player.engine
    s=s+player.fuel
    s=s+income(mt_pirates)*1.5
    for a=0 to 5
        s=s+player.weapons(a).dam
        s=S+player.weapons(a).range
    next
    for a=0 to laststar
        if map(a).discovered=1 then s=s+100
    next
    for a=0 to 255
        if planetmap(0,0,a)<>0 then
            for b=0 to 60
                for c=0 to 20
                    if planetmap(b,c,a)>0 then s=s+1
                next
            next
        endif
    next
    for a=0 to lastitem
        if item(a).w.s<0 then s=s+item(a).price\100
    next
    if tRetirement.assets(1)>0 then s+=1000
    if tRetirement.assets(2)>0 then s+=2000
    if tRetirement.assets(3)>0 then s+=5000
    if tRetirement.assets(4)>0 then s+=10000
    if tRetirement.assets(5)>0 then s+=100000
    if tRetirement.assets(6)>0 then s+=200000
    if tRetirement.assets(7)>0 then s+=500000
    if tRetirement.assets(8)>0 then s+=1000000
    if tRetirement.assets(9)>0 then s+=2000000
    
    if tRetirement.assets(10)>0 then s+=2000
    if tRetirement.assets(11)>0 then s+=10000
    if tRetirement.assets(12)>0 then s+=20000
    if tRetirement.assets(13)>0 then s+=50000
    if tRetirement.assets(14)>0 then s+=100000
    if tRetirement.assets(15)>0 then s+=200000
    
    s=s-player.deadredshirts*100
    return s
end function


function exploration_text_html() as string
    return text_to_html(exploration_text())
end function

function acomp_table() as string
    return "<center>"&get_death & "<br>" & text_to_html(mission_type) &"</center><br><table width=" &chr(34) &"80%"&chr(34)& " align=" &chr(34) &"center"&chr(34)& "><tbody><tr><td valign=" &chr(34)& "top" &chr(34)& "><tbody><tr width=50%><td>"&exploration_text_html  & text_to_html(money_text) &"</td><td>" & income_expenses_html &"</td></tr></tbody></table>"
end function


function postmort_html(text as string) as short
    dim as short f,ll,i
    dim as string fname
    dim lines(255) as string
    space_mapbmp
    f=freefile
    open "data/template.html" for input as f
    ll=0
    while not eof(f)
        ll+=1
        line input #f,lines(ll)
    wend
    close f
    fname="summary/("&date_string &")" &player.desig &".html"
    rlprint "saving to "&fname &". Key to continue."
    f=freefile
    open fname for output as f
    for i=1 to ll
        lines(i)=trim(lines(i))
        if lines(i)="{title}" then lines(i)=player.desig &" mission summary"
        if lines(i)="{screenshots}" then 
            lines(i)="<div align=" &chr(34) &"middle"&chr(34)&"><img src="&chr(34) &player.desig &".png" &chr(34)&" width="&chr(34) &"80%"&chr(34) &" align="&chr(34)&"middle"&chr(34)&"></div><br>"
            lines(i)=lines(i)&"<div align=" &chr(34) &"middle"&chr(34)&"><img src="&chr(34) &player.desig &"-map.png" &chr(34)&" width="&chr(34) &"80%"&chr(34) &" align="&chr(34)&"middle"&chr(34)&"></div><br>"
        endif
        
        if lines(i)="{ship}" then lines(i)=ship_table
        if lines(i)="{crew}" then lines(i)=crew_table
        if lines(i)="{uniqueart}" then lines(i)=planet_artifacts_table
        if lines(i)="{achievements}" then lines(i)=acomp_table
        if lines(i)="{equipment}" then lines(i)=items_table
        if lines(i)="{endstory}" then lines(i)="<table width=" &chr(34) &"80%"&chr(34)& " align=" &chr(34) &"center"&chr(34)& "><tbody><tr><td>"&text_to_html(text) &"</td></tr><tbody></table>"
        print #f,lines(i)
    next
    no_key=keyin
    close #f
    return 0
end function


function post_mortemII(text as string) as short
    dim as short page,full,half,third,i,x,offset,crewn,bg
    dim as string key,header(4),crewtext,income
    dim as byte unflags(lastspecial)
    make_unflags(unflags())
    full=(tScreen.x-4*_fw1)/_fw2
    half=fix(full/2)
    third=fix(full/3)
    
    for i=1 to 128
        if crew(i).hpmax>0 then 
            crewn+=1
            crewtext=crewtext &"{15}"&i &") "&crew_text(crew(i))
        endif
    next
    
    header(0)="a) Achievements"
    header(1)="b) Discoveries"
    header(2)="c) Ship"
    header(3)="d) Crew ("&crewn &")"
    header(4)="e) Equipment"
    
    bg=rnd_range(1,_last_title_pic)
    income=mission_type &"|{15}" & get_death &"||"&income_expenses
    do
        set__color(11,0)
        tScreen.set(0)
        cls
        background(bg &".bmp")
    
        line (2*_fw1,4*_fh1)-(2*_fw1+full*_fw2,20*_fh1),rgb(0,0,128),BF
        select case page
        case 0 'Achievments
            textbox("|"&income,2,4,half,11,1,,,offset)
            textbox("|"&exploration_text() ,2+half*_fw2/_fw1,4,half,11,1,,,offset)
        case 1 'Uniques and artifacts
            textbox("|"&list_artifacts(artflag()),2,4,half,11,1,,,offset)
            textbox("|"&uniques(unflags()),2+half*_fw2/_fw1,4,half,11,1,,,offset)
        case 2 'Ship
            textbox("|"&shipstatsblock,2,4,third,11,1)
            textbox("|"&weapon_string,2+third*_fw2/_fw1,4,third,11,1)
            textbox("|"&cargo_text,2+2*(third*_fw2/_fw1),4,third,11,1)
        case 3 'Crew
            textbox("|"&crewtext,2,4,full,11,1,0,0,offset)
        case 4 'Equipment
            textbox("|"&list_inventory,2,4,full,11,1,0,0,offset)
        end select
        set__color(11,0)
        x=len("Mission Summary: "&player.desig)/2
        draw string(2*_fw1,_fh1),"Mission summary: "&player.h_desig &" "&player.desig,,titlefont,custom,@_tcol
        x=2*_fw1
        for i=0 to 4
            if i=page then
                set__color(15,1)
            else
                set__color(15,1,0)
            endif
            draw string(x,4*_fh1-_fh2),header(i),,font2,custom,@_col
            if i=page then draw string(x+1,4*_fh1-_fh2),header(i),,font2,custom,@_tcol
            x+=len(header(i))*_fw2+_fw1
        next
        rlprint ""
        flip
        key=keyin(,3)
        select case key
        case "1","a","A"
            page=0
            offset=0
        case "2","u","U","B","b"
            page=1
            offset=0
        case "3","C","c"
            page=2
            offset=0
        case "4","D","d"
            page=3
            offset=0
        case "5","E","e"
            page=4
            offset=0 
        case else
            if key=key__rt then
                offset=0
                page+=1
                if page>4 then page=0
            endif
            if key=key__lt then
                offset=0
                page-=1
                if page<0 then page=4
            endif
            if key="+" then offset+=5
            if key="-" then offset-=5
        end select    
            
    loop until key=key__esc
    
    if askyn("Do you want to save your mission summary to a file?(y/n)") then
        'configflag(con_tiles)=old_g
        
        postmort_html(text)
        'configflag(con_tiles)=1
    else
        kill player.desig &".bmp"
    endif
    'configflag(con_tiles)=old_g
    
    return 0
end function


function high_score(text as string) as short
    
    dim hScore(11) as _table
    dim in as integer=1
    dim key as string
    dim rank as integer
    dim offset as integer
    dim off2 as integer
    dim store as _table
    dim f as integer
    dim a as integer
    dim s as integer
    dim as short xo,yo,sp
    'open hScore table
    f=freefile
    open "highscore" for binary as f
    for a=1 to 10
        get #f,,hScore(a)
    next        
    close f
    'edit hScore table
    rank=1
    if player.desig<>"" then
        
        post_mortemII(text)
        
        if player.score=0 then 
            s=score()
        else
            s=player.score
        endif
        
        for a=1 to 10
            if hScore(a).points>s then rank=rank+1
        next
        if rank<10 then
            for a=9 to rank step -1
                hScore(a+1)=hScore(a)
            next
        endif
        if rank<11 then
            hScore(rank).points=s
            hScore(rank).desig=player.desig &" ("&date_string &"), "& ltrim(player.h_desig) &", " &credits(player.money) &" Cr."            
            hScore(rank).death=get_death
        endif
    else
        rank=-1
    endif
    'display hScore table
    offset=rank
    set__color( 11,0)

    cls
    
    background(rnd_range(1,_last_title_pic)&".bmp")
    yo=(tScreen.y-22*_fh2)/2
    xo=(tScreen.x-80*_fw2)/2
    set__color( 0,0)
    for a=yo/2-_fh2 to tScreen.y-yo/2+_fh2 step _fh2-1
        draw_string (xo,a,space(80),font2,_col)
    next
    set__color( 15,0)
    draw_string (2*_fw2+xo,yo/2,"10 MOST SUCCESSFUL MISSIONS",Titlefont,_col)
    
    for a=1 to 10
        if a=rank then 
            set__color( 15,0)
        else
            set__color( 11,0)
        endif
        sp=73-len(a &".)")-len(trim(hScore(a+off2).desig))-len(hScore(a+off2).points &" pts.")
        draw_string (2*_fw2+xo,yo+(a*2)*_fh2, a & ".) " & trim(hScore(a+off2).desig) & ", "  & space(sp)&credits( hScore(a+off2).points) &" pts." ,font2,_col)
        if a=rank then
            set__color( 14,0)
        else
            set__color( 7,0)
        endif
        draw_string (2*_fw2+xo,yo+(a*2+1)*_fh2, trim(hScore(a+off2).death),font2,_col)
    next
    set__color( 11,0)
    if rank>10 then draw_string (2*_fw2+xo,tScreen.y-yo, hScore(10).points &" Points required to enter highscore. you scored "&s &" Points",font2,_col)
    draw_string (2*_fw2+xo,tScreen.y-yo/2, "Esc to continue",font2,_col)
    no_key=keyin(key__esc)
    'save highscore table
    f=freefile
    
    
    'open highscore table
    in=1
    open "highscore" for binary as f
      for a=1 to 10  
        put #f,,hScore(a)
        
      next
    close f
    cls
    return 0
end function


function death_message() as short
    dim as string text,text2
    dim as short b,a,wx,tx
    text=""
    
    if not fileexists("summary/"&player.desig &".png") then screenshot(3)
    cls
    background(rnd_range(1,_last_title_pic)&".bmp")
    set__color( 12,0)
    text=death_text()
    text2=text
    if text<>"" and player.dead<>98 then
        set__color( 11,0)
        
        b=0
        tx=tScreen.x/_fw1-10
        while len(text)>tx
            a=40
            do 
                a=a-1
            loop until mid(text,a,1)=" "        
            draw_string (5*_fw1,(_lines*_fh1)/2-(4*_fh1)+b*(tScreen.y/15),left(text,a),TITLEFONT,_tcol)
            text=mid(text,a,(len(text)-a+1))
            b=b+1
        wend
        draw_string (5*_fw1,(_lines*_fh1)/2-(4*_fh1)+b*(tScreen.y/15),text,TITLEFONT,_tcol)
        
    endif
    
    no_key=""
    no_key=keyin
    if player.dead<99 then 
        if askyn("Do you want to see the last messages again?(y/n)") then messages
        high_score(text2)
    endif

    return 0
end function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: highscore -=-=-=-=-=-=-=-
	tModule.register("tHighscore",@tHighscore.init()) ',@highscore.load(),@highscore.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: highscore -=-=-=-=-=-=-=-
#endif'test
