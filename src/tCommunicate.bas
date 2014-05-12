'tCommunicate.
'
'defines:
'rndsentence=0, dirdesc=0, get_item=1, talk_culture=0, foreignpolicy=2,
', communicate=4
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
'     -=-=-=-=-=-=-=- TEST: tCommunicate -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tCommunicate -=-=-=-=-=-=-=-

declare function get_item(ty as short=0,ty2 as short=0,byref num as short=0,noequ as short=0) as short
declare function foreignpolicy(c as short, i as byte) as short
declare function communicate(e as _monster,mapslot as short,monslot as short) as short

'private function rndsentence(e as _monster) as short
'private function dirdesc(f as _cords,t as _cords) as string
'private function talk_culture(c as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tCommunicate -=-=-=-=-=-=-=-

namespace tCommunicate
function init() as Integer
	return 0
end function
end namespace'tCommunicate


function rndsentence(e as _monster) as short
    dim as short aggr,intel
    dim s as string
    dim r as short
    aggr=e.aggr
    intel=e.intel
    if aggr=0 then
    r=rnd_range(1,8)
        if r=1 then rlprint "It says: 'Die monster from another world!'"
        if r=2 then rlprint "It says: 'You look tasty!'"
        if r=3 then rlprint "It says: 'The metal gods of old demand your death!'"
        if r=4 then rlprint "It says: 'Intruder! Flee or be destroyed'"
        if r=5 then rlprint "It says: 'Your magic is powerfull but my arms are strong!'"
        if r=6 then rlprint "It says: 'The time for talking is over!'"
        if r=7 then rlprint "It says: 'I am going to kill you!'"
        if r=8 then rlprint "It says: 'Resistance is useless!'"
    endif
    if aggr=1 then
    r=rnd_range(1,11)
        if r=1 then do_dialog(902,e,0)
        if r=2 then rlprint "It says: 'You are not from around, are you?'"
        if r=3 then rlprint "It says: 'Do you have a gift for me?'"
        if r=4 then rlprint "It says: 'I always wondered if there were other beings out there.'"
        if r=5 then rlprint "It says: 'You can't be from another world! Faster than light travel is impossible!'"
        if r=6 then rlprint "It says: 'I haven't seen a creature like you before!'"
        if r=7 then rlprint "It says: 'Are you here for the festival?'"
        if r=8 then rlprint "It says: 'You can have my food if you want.'"
        if r=9 then rlprint "It says: 'I always wondered if there were other beings like us up there.'"
        if r=10 then 
            if askyn("It says: 'I pay you 5000 zrongs if you tell me all your technological secrets.' Do you agree? (y/n)") then
                placeitem(make_item(88),0,0,0,0,-1)
                s="it hands you a bag of local currency while you"
                if skill_test(player.science(location),st_hard-e.intel,"Science:") then
                    r=rnd_range(1,6)
                    if r=1 then s=s &" teach it some basic newtonian physics."
                    if r=2 then s=s &" teach it some basic chemistry."
                    if r=3 then s=s &" teach it some basic biology."
                    if r=4 then s=s &" teach it some basic astronomy."
                    if r=5 then s=s &" teach it some how to make fire."
                    if r=6 then s=s &" teach it some how to make wheels."
                else 
                    s=s &" fail to teach it anything because you just can't find the terms it would understand."
                endif
                rlprint s
            endif
        endif
        if r=11 then do_dialog(901,e,0)
    endif
    if aggr=2 then
    r=rnd_range(1,7)
        if r=1 then rlprint "It says: 'Help! Help! It's an alien invasion!'"
        if r=2 then rlprint "It says: 'Don't kill me!'"
        if r=3 then rlprint "It says: 'Don't point those things at me!'"
        if r=4 then rlprint "It says: 'Don't eat me!'"
        if r=5 then rlprint "It says: 'I surrender!'"
        if r=6 then rlprint "It says: 'Have mercy!'"
        if r=7 then rlprint "It says: 'Gods! Save me from the evil aliens!'"
    endif
    return 0
end function


function dirdesc(f as _cords,t as _cords) as string
    dim d as string
    dim as single dx,dy
    dx=(f.x-t.x)
    dy=(f.y-t.y)
    if dy<-2 then d=d &"south"
    if dy>2 then d=d &"north"
    if dx<-2 then d=d &"east"
    if dx>2 then d=d &"west"
    if d="" then 
        d="nearby"
    else
        d=d &" from here."
    endif
    return d
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
        key=keyin(key_north &key_south)
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


function talk_culture(c as short) as short
    dim as short a,nwh,b,d
    dim as _cords p
    dim as string t(6,6)
    d=999
    if c=0 then p=map(sysfrommap(specialplanet(7))).c
    if c=1 then p=map(sysfrommap(specialplanet(46))).c
    for a=laststar+1 to laststar+wormhole
        if distance(map(a).c,p)<d then
            nwh=a
            d=distance(map(a).c,p)
        endif
    next
    
    t(0,0)="Reproduction works remarkably similiar to your species here."
    t(0,1)="Our young are born in batches of 6 to 10. They immediately start fighting each other. Rarely more than 2 survive until adulthood."
    t(0,2)="Twin births are the norm for our species. Each parent adopts one, and contact in later life between the twins is discouraged."
    t(0,3)="The females of our species lay eggs, in common hatcheries. The children get raised by the community. Usually nobody takes a particular interest into who's kid is who's"
    t(0,4)="The males of our species are barely sentient, and have only one function. Raising children is done by the female, with help from society"
    t(0,5)="Our species has 3 sexes. Male, Female, and a sterile 'incubator'. In more primitive times their main job was to defend the young. Now they make up our military and police force."
    t(0,6)="After pregnancy our females change gender."
    
    t(1,0)="Our families and education of the young is actually pretty similiar to yours"
    t(1,1)="Our young mature very fast, and have an urge to leave their parents as soon as possible"
    t(1,2)="In our families there is always a constant power struggle. Young like to challenge the leader"
    t(1,3)="Our young need to go through a rite of passage before they are accepted among society"
    t(1,4)="Our society is based on extended families and clans. You are who you are related to"
    t(1,5)="Educating our young in as many fields as possisble is one of the main goals of our society. We pool resources to accomplish that."
    t(1,6)="We have come to the conclusion that the education of the young is too important to be left to the whims of indiviuals. Young are educated by experts, as soon as they no longer require their parents for survival."
    
    t(2,0)="Our concept of art is very similiar to yours. Maybe we could engage in trade on the matter."
    t(2,1)="We value art as a form of individual expression. There are no 'professionals' or an 'industry'"
    t(2,2)="Art is a waste of resources. Growing civilisations need it. We have outgrown that phase centuries ago."
    t(2,3)="We base the value of art on its educational value."
    t(2,4)="Our language will be rather hard for you to learn:' - the alien presents a little blue bug - 'Part of the meaning is conveyed by this animal changing it's set__color(. Its a chameleon, and trained to react to the users touches."
    t(2,5)="We are most impressed with feats of the body. Our most import areas of art are sport, dance, and general acrobatics. We get very little out of a film, picture or books other than for education"
    t(2,6)="The value of Art is its contribution to the survival of the species. It can do so by reminding individuals that they are nothing without the group."
    
    t(3,0)="Some of us follow a monotheistic religion. Most of us think its just ancient superstition"
    t(3,1)="There are many religions among us. Most are a form of ancestor worship. But it is all superstition, and  tradition."
    t(3,2)="Our species worshipped the ancient civilisation that once lived here. Imagine our shock, when we started to explore the stars and found out that god is real!"
    t(3,3)="This concept of God is foreign to us. We believe in a force, that inhabits all living things. It gets released upon death. Sentient beings can control this force. They can also hinder it in having unwanted effects on society."
    t(3,4)="We have discovered that our species has a genetic flaw, which can cause a sudden failure of the circulatory system. We now have the technology to repair it, but earlier this sudden dropping dead was the main focus of our religious practices. It was held that god considers your job complete, and takes you back."
    t(3,5)="On our homeworld there was an ancient robot factory. Most religious rituals have evolved around it."
    t(3,6)="Our species evolved from a primitive form that migrated between two different habitats. Our religions are mainly about 'finding ones way', propably for that reason. Many of us still have 2 houses, in different parts of the planet, and live in each for half a year. Poor people try to do it too, by swapping homes."
    
    t(4,0)="Much like you we try only to interfere with free markets if they fail at allocating goods efficiently"
    t(4,1)="You could call our economic system industrial feudalism: The power of individuals is measured in their wealth. There is no authority regulating them."
    t(4,2)="There is a legend about a leader of our people. He perished 2000 years ago, taking the symbol of his power with him."
    t(4,3)="We had a very agressive colonisation phase in our past. Some laws still survive from that day, concerning the conquest of undiscovered land. It has led to many of us trying to make independent expeditions to the stars. Discovering a planet means you own it."
    t(4,4)="There is a semi intelligent species on our world. We feed and clothe them, in exchange for their labor."
    t(4,5)="The thing we are most proud of, you will have noticed upon landing: we have built a space lift. A space station in geostationary orbit, connected by a tether to the ground. It was constructed during the beginning of our exploration of our system, and is still useful."
    t(4,6)="Central government decides, and distributes goods according to their needs."
   
    t(5,0)="The most usual ways to dispose of our dead is to bury them. Incineration is also popular."
    t(5,1)="They say 'the sun made us, the sun will take us away' thats why we used to burn our dead. These days we shoot them into the sun."
    t(5,2)="Our tradition is to eat those that have died. Usually only the closest family gets a piece though."
    t(5,3)="The dead are mummified, and put into the walls of the house to watch over the living."
    t(5,4)="All of us have a plant symbiote or parasite. We could remove it, but it has several beneficial effects. Natural death triggers its growth into a treelike plant. It uses the body of the dead as first nourishment. Family members usually nurture it. It is only displaced when the death occured at a very inconvenient spot. Most citizens try to avoid that."
    t(5,5)="Our dead are returned to the circle of life: there is a special profession who cuts them into tiny pieces and feeds them to scavenging animals."
    t(5,6)="We used to set our dead adrift at sea, later we used space. Since the discovery of the wormhole at " &map(nwh).c.x &":"&map(nwh).c.y &" that is where their last journey starts."
    
    t(6,0)="Our expeditions have found a city of the ancients at "& map(sysfrommap(specialplanet(3))).c.x &":"& map(sysfrommap(specialplanet(3))).c.y &". No ship that has landed there has so far returned"
    t(6,1)="Our expeditions have found a city of the ancients at "& map(sysfrommap(specialplanet(3))).c.x &":"& map(sysfrommap(specialplanet(3))).c.y &". No ship that has landed there has so far returned"
    t(6,2)="We have found a friendly race of highly intelligent centipedes at "& map(sysfrommap(specialplanet(16))).c.x &":"& map(sysfrommap(specialplanet(16))).c.y &"."
    t(6,3)="We have found a living planet at "& map(sysfrommap(specialplanet(27))).c.x &":"& map(sysfrommap(specialplanet(27))).c.y &" It is very dangerous, especially if you land there."
    t(6,4)="We have discovered a wormhole at " &map(nwh).c.x &":"&map(nwh).c.y &"."
    t(6,5)="Our expeditions have found a city of the ancients at "& map(sysfrommap(specialplanet(2))).c.x &":"& map(sysfrommap(specialplanet(2))).c.y &". No ship that has landed there has so far returned"
    t(6,6)="Our expeditions have found a city of the ancients at "& map(sysfrommap(specialplanet(4))).c.x &":"& map(sysfrommap(specialplanet(4))).c.y &". No ship that has landed there has so far returned"
    a=rnd_range(1,6)
    rlprint t(a,civ(c).culture(a))
    return 0
end function



function foreignpolicy(c as short, i as byte) as short
    dim as byte o,l,a,b,f,ad,roll,art
    dim t as string
    t="Who/Merchants/Pirates"
    if c=0 then
        o=1
    else
        o=0
    endif
    if i=0 then
        if civ(c).phil=1 then ad=5
        if civ(c).phil=2 then ad=3
        if civ(c).phil=3 then ad=1
    else
        if civ(c).phil=1 then ad=1
        if civ(c).phil=2 then ad=3
        if civ(c).phil=3 then ad=5
    endif
    if civ(o).contact=1 then 
        t=t &"/" & civ(o).n    
        l=4
    else
        l=3
    endif
    if findbest(23,-1,,205)>0 and civ(c).culture(4)=2 then 
        art=1
        ad=ad+6/civ(c).phil
    endif
    t=t & "/Exit"
    a=menu(bg_parent,t)
    if a<l then
        b=menu(bg_parent,"What/Status/Declare war/Initiate peace talks/Exit")
        if a=1 then f=1
        if a=2 then f=2
        if a=3 then f=6+o
        if art>0 then rlprint "The "&civ(c).n &" are obviously impressed by you bearing their artifact."
        roll=rnd_range(1,6)+ rnd_range(1,6)+civ(o).contact+ad
        if b=1 then
            select case faction(c+6).war(f)>=90 
            case is >90
                rlprint "We are currently at war with them"
            case 50 to 90
                rlprint "There are serious tensions with them"
            case else
                rlprint "There are no problems between us and them"
            end select
        endif
        if b=2 then
            rlprint "You try to convince the "&civ(c).n &" to declare war"
            if faction(c+6).war(f)>50 then roll=roll+1
            if roll>9 then 
                factionadd(c+6,f,5)
                rlprint "They seem to consider your arguments"
            endif
            if roll<4 then
                factionadd(c+6,0,3)
                rlprint "They dont think that you are in a position to tell them that."
            endif
            if roll>=4 and roll<=9 then rlprint "Your argument falls on deaf ears"
        endif
        if b=3 then
            rlprint "You try to convince the "&civ(c).n &" to initiate peace talks"
            if faction(c+6).war(f)<30 then roll=roll-1
            if roll>9 then 
                factionadd(c+6,f,-5)
                rlprint "They seem to consider your arguments"
            endif
            if roll<4 then
                factionadd(c+6,0,3)
                rlprint "They dont think that you are in a position to tell them that."
            endif
            if roll>=4 and roll<=9 then rlprint "Your argument falls on deaf ears"
        endif
            
    endif
    return 0
end function


function communicate(e as _monster,mapslot as short,monslot as short) as short
    dim as short roll,a,b
    dim as byte c,o
    dim as string t
    dim it as _items
    dim p as _cords
    
    if e.lang<0 then
        if skill_test(player.science(location)+e.intel+add_talent(4,14,2),st_average,"Science Officer:") then
            rlprint "You have established communication with the " & e.sdesc &"."
            e.lang=-e.lang
            e.cmmod=e.cmmod+1
            if e.lang=30 then e.aggr=0
            if e.lang=31 then e.aggr=0
        else
            if player.science(0)<>captainskill or crew(4).onship=0 then
                rlprint "Your science officer cant make any sense out of the " &e.sdesc &"s sounds and actions."
                e.cmmod=e.cmmod-1
            else
                rlprint "No science officer in the team."
            endif
        endif
    endif
    if e.lang=1 then
        select case e.intel
        case is>4
            if e.aggr=0 then rndsentence(e)
            if e.aggr=1 then
                if findbest(23,1)<>-1 and rnd_range(1,6)+ rnd_range(1,6)<2*e.intel then
                    if item(findbest(23,-1)).v1=3 then 
                        rlprint "It says 'That doesn't belong to you, give it back!'"
                        e.cmmod=e.cmmod-rnd_range(1,4)
                    else
                        rlprint "It says 'You have pretty things!'"
                        e.cmmod=e.cmmod+1
                    endif
                endif
                if rnd_range(1,100)>(e.intel-add_talent(4,14,1))*6 then
                    rndsentence(e)
                else
                    select case rnd_range(1,100)
                    case is<22
                        'Tell about caves
                        roll=-1
                        for a=0 to lastportal
                            if portal(a).from.m=mapslot then roll=a
                        next
                        
                        if roll=-1 then
                            rlprint "It says 'I dont know of any tunnels'"
                        else
                            p.x=portal(roll).from.x
                            p.y=portal(roll).from.y
                            rlprint "It says 'There is a tunnel  "&dirdesc(e.c,p) &"'"
                        endif
                    case 22  to 44
                        'Tell about item
                        if itemindex.vlast>0 then
                            roll=rnd_range(1,itemindex.vlast)
                            if item(itemindex.value(roll)).w.s=0 and item(itemindex.value(roll)).w.p=0 then
                                p.x=item(itemindex.value(roll)).w.x
                                p.y=item(itemindex.value(roll)).w.y
                                if item(itemindex.value(roll)).ty=15 then
                                    rlprint "It says 'There are sparkling stones at "& dirdesc(e.c,p) &"'"
                                else
                                    rlprint "It says 'There is something strange at "& dirdesc(e.c,p) &"'"
                                endif
                            else
                                rlprint "It says 'An animal here owns someting shiny'"
                            endif
                        else
                            rlprint "It says 'this is a boring place'"
                        endif
                    case 45 to 55
                        if askyn("It says 'do you want to trade?'(y/n)") then
                            rlprint "What do you want to offer to the "&e.sdesc &"?"
                            b=get_item
                            if b>0 then
                                item(b).w.s=0
                                item(b).w.p=monslot
                                reward(2)=reward(2)-item(b).v5
                                it=make_item(94)
                                placeitem(it,0,0,0,0,-1)
                                rlprint "It takes the "&item(b).desig &" and hands you "&it.desig &"."   
                                e.cmmod=e.cmmod+2
                            else
                                rlprint "It seems dissapointed."
                                e.cmmod=e.cmmod-1
                            endif
                        else
                            rlprint("It seems dissapointed.")
                            e.cmmod=e.cmmod-1
                        endif
                    case 56 to 66
                        if askyn("It says 'do you want to play with me?'(y/n)") then
                            rlprint "You play with the alien."
                            e.cmmod+=2
                            if rnd_range(1,100)<66 then
                                rlprint "it says 'That was fun! Here take this gift!'"
                                it=make_item(94)
                                placeitem(it,0,0,0,0,-1)
                                rlprint "It hands you "&it.desig &"."   
                            else
                                if rnd_range(1,100)<55 then
                                    b=getrnditem(-2,rnd_range(2,13))
                                    if b>0 then
                                        if item(b).ty<>3 then
                                            rlprint "It suddenly has your "&item(b).desig &" and starts running away!"
                                            e.aggr=2
                                            item(b).w.s=0
                                            item(b).w.p=monslot
                                            if item(b).ty=15 then reward(2)=reward(2)-item(b).v5
                                        endif
                                    endif
                                endif
                            endif
                        else
                            rlprint "It asks incredulous 'You dont enjoy to play?"
                        endif
                    
                    case else
                        rlprint "It says 'You are not from around here'"
                    end select
                    
                endif
            endif
            if e.aggr=2 then 
                if rnd_range(1,100)>e.intel*9 then 
                    rndsentence(e)
                else
                    rlprint "It says 'take this, and let me live!"
                    e.aggr=1
                    if rnd_range(1,100)<66 then
                        it=make_item(94)
                    else
                        it=make_item(96,-3,-3)
                        reward(2)=reward(2)+it.v5
                    endif
                    placeitem(it,0,0,0,0,-1)
                    rlprint "It hands you "&it.desig &"."   
                
                        
                endif  
            endif
        case else 
            if e.aggr=0 then rlprint "The "&e.sdesc &" says: 'You food!'"
            if e.aggr=1 then
                b=findbest(13,-1)
                if b>0 then 
                    if askyn("The "&e.sdesc &" says: 'Got food?'. Do you want to give it a an anastaethic?") then
                        rlprint "The "&e.sdesc &" eats the "& item(b).desig
                        e.sleeping=e.sleeping+item(b).v1
                        if e.sleeping>0 then rlprint "And falls asleep!"
                        destroyitem(b)
                    endif
                else
                    rlprint "The "&e.sdesc &" says: 'Got food?'"
                endif
            endif
            if e.aggr=2 then rlprint "The "&e.sdesc &" says: 'Me not food!'"
        end select
    endif
    if e.lang=2 then
        if e.aggr=0 then rlprint "He growls:'Get off our world warmonger!"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then rlprint "The Citizen welcomes you to the colony"
            if a=2 then rlprint "The Citizen says: 'You have chosen the right time of the year to visit our colony!'"
            if a=3 then rlprint "The Citizen says: 'You are an offworlder, aren't you? You should visit Mr. Grey, he collects native art.'"
            if a=4 then rlprint "The Citizen says: 'We are independent and neutral. Has served us good in the past years.' "
            if a=5 then rlprint "The Citizen says: 'When we settled here we found alien ruins. In an underground vault was a cache with weapons and armor. we don't need it. We sell it.' "
            if a=6 then rlprint "The Citizen says: 'I used to do spaceship security. But that's a really dangerous job! Life is a lot safer here.' "
        endif
        if e.aggr=2 then rlprint "He sobs: 'Why did you do this? We only wanted to live in peace!"
    endif
    if e.lang=3 then 
        rlprint "The Robot says 'Annihilate alien invaders!'"
    endif
    if e.lang=4 then
        if (e.aggr=0 or e.aggr=2) and rnd_range(1,100)<50 then
            rlprint "Apollo thunders 'Worship me!'"
        else
            do_dialog(2,e,0)
        endif
    endif
    if e.lang=5 then
        if e.aggr=0 then rlprint "The "&e.sdesc &" says: 'Surrender or be destroyed!'"
        if e.aggr=1 then rlprint "The "&e.sdesc &" says: 'Found any good ore deposits on this planet?'"
        if e.aggr=2 then rlprint "The "&e.sdesc &" says: 'The company will hear about this attack!'"
    endif
    if e.lang=6 then
        if e.aggr=0 then rlprint "The "&e.sdesc &" says: 'Die red-helmet-friend!"
        if e.aggr=1 then do_dialog(6,e,0)
        if e.aggr=2 then rlprint "The "&e.sdesc &" says: 'I surrender!" 
    endif
    if e.lang=7 then
        if e.aggr=0 then rlprint "The "&e.sdesc &" says: 'Die blue-helmet-friend!"
        if e.aggr=1 then do_dialog(7,e,0)
        if e.aggr=2 then rlprint "The "&e.sdesc &" says: 'I surrender!"
    endif 
    if e.lang=8 then
        if e.aggr=0 or e.aggr=2 then rlprint "It says: 'We haven't harmed you, yet you wish to destroy us?'"
        if e.aggr=1 then do_dialog(8,e,0)
    endif
    if e.lang=9 then
        if e.aggr=0 then rlprint "They snarl and growl."
        if e.aggr=1 then 
            a=rnd_range(1,5)
            if a=1 then rlprint "They ask if you got good booty lately."
            if a=2 then rlprint "They ask if you know of any merchant routes."
            if a=3 then rlprint "They ask if you know of any good bars here."
            if a=4 then rlprint "They ask if you read the review of the new Plasma rifle."
            if a=5 then rlprint "They ask if you know how the drinks in space stations are."
            if a=6 then rlprint "'Have you already visited the base at "&map(piratebase(rnd_range(0,_NoPB))).c.x &":"&map(piratebase(rnd_range(0,_NoPB))).c.y &"?'"
        endif
        if e.aggr=2 then rlprint "They yell 'We are going to get you!' as they retreat."
    endif
    if e.lang=10 then
        if e.aggr=0 then rlprint "It says: 'Die alien!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then rlprint "It says: 'We are using the best technology that we can use'"
            if a=2 then rlprint "It says: 'Have you found our space probe?'"
            if a=3 then rlprint "It says: 'Has your kind solved the technological problems our species is facing?'"
            if a=4 then rlprint "It says: 'Do you always have to turn around when you want to see what is behind you?'"
            if a=5 then rlprint "It says: 'I think our only hope is to find exploitable resources on other planets.'"
            if a=6 then rlprint "It says: 'Our leaders would be very interested in trading for advanced power sources and production methods'"
        endif        
        if e.aggr=2 then rlprint "It says: 'I surrender.'"
    endif
    if e.lang=11 then
        if e.aggr=0 then rlprint "It says: 'Warriors fight!'"
        if e.aggr=1 then
            a=rnd_range(1,8)
            if a=1 then rlprint "It says: 'Workers work, warriors fight and scientists research. Breeders breed.'"
            if a=2 then rlprint "It says: 'Does your species have warriors too?'"
            if a=3 then rlprint "It says: 'Does your species have workers too?'"
            if a=4 then rlprint "It says: 'Does your species have scientists too?'"
            if a=5 then rlprint "It says: 'Does your species have breeders too?'"
            if a=6 then rlprint "It says: 'We are working on our first faster than light ship. It is called 'feeler'"
            if a=7 then rlprint "It says: 'We are looking forward to trade with your kind'"
            if a=8 then rlprint "It says: 'We are looking forward to exchange knowledge with your kind'"
        endif        
        if e.aggr=2 then rlprint "It says: 'We will work and fight and research for you!'"
    endif
    if e.lang=12 then
        if e.aggr=0 then rlprint "It says: 'The time for negotiations is over!'"
        if e.aggr=2 then rlprint "It says: 'We surrender for now.'"
        if e.aggr=1 then
            rlprint "It says: 'I am a warrior. I would be interested in joining your crew to learn about your kind and other worlds'"
            if askyn("Do you want to let the insect warrior join your crew?(y/n)") then
                if max_security>0 then
                    e.hp=0
                    e.hpmax=0
                    add_member(9,0)
                else
                    rlprint "You don't have enough room for the insect warrior"
                endif
            else
                rlprint "It seems dissapointed but says it understands."
            endif
        endif
    endif
    if e.lang=13 then
        if e.aggr=0 then rlprint "It says: 'We may not be warriors but we do know how to defend ourselfs!'"
        if e.aggr=2 then rlprint "It says: 'We are no warriors! Cease hostilities!'"
        if e.aggr=1 then
            a=rnd_range(1,8)
            if a=1 then rlprint "It says: 'Do you like our research station?'"
            if a=2 then rlprint "It says: 'We do pick up signals from 3 gigantic artificial structures in space. Are they yours?'"
            if a=3 then rlprint "It says: 'You should visit our main world. It's in the third orbit of this system.'"
            if a=4 then rlprint "It says: 'FTL technology is still very new for our kind. We hope you come in peace and we can learn a lot from you'"
            if a=5 then rlprint "It says: 'This is a research station. There are no warriors here."
            if a=6 then rlprint "It says: 'Some of my colleagues thought the answer to the xixrit paradox would be that we were the first to advance this far in technology. I knew they were wrong! Ha!'"
            if a=7 then rlprint "It says: 'How far away is your home planet?'"
            if a=8 then rlprint "It says: 'Economics isn't my specialty but i am certain we can work out a way to trade goods & services with your species.'"
        endif
    endif
    if e.lang=14 then
        if specialflag(20)=0 then
            if e.aggr=0 then rlprint "He says with a monotone voice: 'Leave now or be destroyed!'"
            if e.aggr=2 then rlprint "He says with a monotone voice: 'Don't kill me!'"
            if e.aggr=1 then
                a=rnd_range(1,8)
                if a=1 then rlprint "The colonist says: 'We need to buy supplies. our powerplant is broken.'"
                if a=2 then rlprint "The colonist looks at you with a puzzled expression on his face. 'Have you been to the cave?'"
                if a=3 then rlprint "The colonist just stares at you."
                if a=4 then rlprint "The colonist just stares at you."
                if a=5 then rlprint "The colonist looks as if what you just said made no sense."
                if a=6 then rlprint "The colonist asks: 'Are you bringing supplies?.'"
                if a=7 then rlprint "The colonist in a monotone voice: 'Unload your cargo and then leave. Everything is alright here.'"
                if a=8 then rlprint "The colonist in a monotone voice: 'Everything is alright here. We don't need your help.'"
            endif
        else
            if e.aggr=0 then rlprint "He screams: 'THE VOICES ARE GONE! DID YOU MAKE THE VOICES GO??'"
            if e.aggr=2 then rlprint "The colonists runs away crying."
            if e.aggr=1 then
                a=rnd_range(1,7)
                if a=1 then rlprint "The colonist says: 'It started slow, and when we realized what was happening it was too late'"
                if a=2 then rlprint "The colonist says: 'Thank you for freeing us from this influence!'"
                if a=3 then rlprint "The colonist says: 'Now we can start developing our colony again! Thank you!'."
                if a=4 then rlprint "The colonist says: 'If you want to know what the crystals goals were: no idea.'"
                if a=5 then rlprint "The colonist says: 'I wonder if there are other beings like that out there'."
                if a=6 then rlprint "The colonist says: 'Thank you! You guys are heroes!'"
                if a=7 then rlprint "The colonist says: 'A lot of hard work ahead for us now.'"
            endif
        endif
    endif
    if e.lang=15 then rlprint "You hear a voice in your head: 'Subjugate or be annihilated.'"
    if e.lang=16 then
        if e.aggr=0 then rlprint "The crewmember yells: 'Repell the intruders!'"
        if e.aggr=2 then rlprint "The crewmember yells: 'Help! Help!'"
        if e.aggr=1 then
            if planets(mapslot).flags(0)=0 then
            if askyn("The crewmember says: 'are you willing to sell us enough fuel to return to the nearest station?' (y/n)") then
                factionadd(0,2,(rnd_range(1,4)+rnd_range(1,4))*-1)
                If player.fuel>=2*disnbase(player.c) then
                    rlprint "How much do you want to charge per ton of fuel?"
                    a=getnumber(0,99,0)
                    if a>0 then
                        if rnd_range(10,50)+rnd_range(5,50)>a-awayteam.hp then
                            player.fuel=player.fuel-disnbase(player.c)
                            addmoney(cint(disnbase(player.c)*a),mt_trading)
                            rlprint "You sell fuel for "&cint(disnbase(player.c)*a) &" credits."
                            planets(mapslot).flags(0)=1
                        else
                            rlprint "They decide to rather take what they want by force than pay this outragous price."
                            e.aggr=0
                            e.target=awayteam.c
                        endif
                    endif
                elseif player.fuel>=disnbase(player.c) then
                    rlprint "You don't have enough fuel for both yourself and the other ship."
                else
                    rlprint "You don't have enough fuel yourself... that's actually quite alarming."
                endif
            else
                rlprint "you have doomed us!"
            endif
            endif
            if planets(mapslot).flags(0)=1 then
                rlprint "The crewmember is busy starting the ship up again. 'Thank you so much for saving our lives!'"
            endif
        endif
    endif 
    if e.lang=17 then
        if e.aggr=0 then rlprint "It says: 'We may not be warriors but we do know how to defend ourselfs!'"
        if e.aggr=2 then rlprint "It says: 'We are no warriors! Cease hostilities!'"
        if e.aggr=1 then
            a=rnd_range(1,7)
            if a=1 then rlprint "It says: 'Warriors fight, breeders breed, sientists research.'"
            if a=2 then rlprint "It says: 'We left our home 500 timeunits ago. It will take us 800 more timeunits to reach our goal.'"
            if a=3 then rlprint "It says: 'We hope conditions for a colony are favourable at our destination.'"
            if a=4 then rlprint "It says: '12 breeders have died since we left home.'"
            if a=5 then rlprint "It says: 'I am proud to be one of the few of our species to go on this great adventure! though i will not see the end of it.'"
            if a=6 or a=7 then rlprint "It says: 'The system we want to colonize is at "&map(sysfrommap(specialplanet(0))).c.x &":"&map(sysfrommap(specialplanet(0))).c.y &"'"
        endif
    endif    
    
    if e.lang=18 then
        if e.aggr=0 then rlprint "He growls:'Get off our world warmonger!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then rlprint "The Citizen welcomes you to the colony"
            if a=2 then rlprint "The Citizen says: 'You have chosen the right time of the year to visit our colony!'"
            if a=3 then rlprint "The Citizen says: 'You are an offworlder, aren't you? We don't get visitors often'"
            if a=4 then rlprint "The Citizen says: 'We only settled here recently.' "
            if a=5 then rlprint "The Citizen says: 'Did you bring supplies?' "
            if a=6 then rlprint "The Citizen says: 'I used to do spaceship security. But that's a really dangerous job! Life is a lot safer here.' "
        endif
        if e.aggr=2 then rlprint "He sobs: 'Why did you do this? We only wanted to live in peace!"
    endif
    
    if e.lang=19 then
        if e.aggr=0 then rlprint "He growls:'Flee or be shredded!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then rlprint "It says: 'Is there a lot of water on your world?'"
            if a=2 then rlprint "It says 'You have a very low number of arms, maybe we should lend you some'"
            if a=3 then rlprint "It says: 'Traveling among the stars, must be exciting!'"
            if a=4 then rlprint "It says: 'Our religious leaders have a creation myth. It states that we were made by gods for the purpose of exploring dangerous places for them."
            if a=5 then 
                b=findbest(103,-1)
                if b>0 then
                    if askyn("It says: 'Oh! you have a ceremonial robe? I would be interested in a trade'(y/n)") then
                        it=make_item(94)
                        if askyn("Do you want to swap your "&item(b).desig &" for "&add_a_or_an(it.desig,0) &"?(y/n)") then
                            placeitem(it,0,0,0,0,-1)
                            rlprint "Thank you very much! We don't know how to make these."
                            item(b).w.s=0
                            item(b).w.p=monslot
                        endif
                        
                    else
                        rlprint "I understand. If I had one I too wouldn't want to part with it."
                    endif
                    
                else
                    rlprint "It says: 'If you find any ceremonial robes, I am willing to buy them!"
                endif
            endif
            if a>5 then 
                rlprint "It says: 'I can help you! I would love to travel with you! May I?'"
                if askyn("Do you want to let the cephalopod join your crew?(y/n)") then
                    if max_security>0 then
                        e.hp=0
                        e.hpmax=0
                        add_member(10,0)
                    else
                        rlprint "You don't have enough room for the cephalopod"
                    endif
                else
                    rlprint "It seems dissapointed but says it understands."
                endif
            endif
        endif
        if e.aggr=2 then rlprint "He sobs: 'Take whatever you want! Just leave us in peace!"
    endif
    
    if e.lang=20 then
        if e.aggr=0 then rlprint "He growls:'Get off our world war monger!"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if player.questflag(12)=0 or player.questflag(12)=1 then 
                rlprint "We love mushrooms. The best mushrooms grow in the caves. But there is a monster there."
                player.questflag(12)=1
            endif
            if player.questflag(12)=2 then 
                rlprint "'Thank you very much for killing the monster! Take this as a reward!' It hands you a huge heap of random art pieces."
                player.questflag(12)=3
                for a=0 to rnd_range(1,6)+ rnd_range(1,6)+ rnd_range(1,6)+3
                    placeitem(make_item(93),0,0,0,0,-1)
                next
            endif
            if player.questflag(12)=3 then rlprint "Thank you very much for killing the monster!"
        endif
        if e.aggr=2 then rlprint "He sobs: 'Why did you do this? We only wanted to live in peace!"
    endif
    
    if e.lang=21 then
        if e.aggr=0 then rlprint "It howls: 'We will defeat you!"
        if e.aggr=1 then
            a=rnd_range(1,8)
            if a=1 then rlprint "It says: 'Interesting! Talking bipeds! They seem to rely on other producers much like the primitve life on our world does.'"
            if a=2 then rlprint "It says: 'We had a discussion about experimenting with fire, but we deemed it too dangerous.'" 
            if a=3 then 
                if askyn("It says: 'Do you want to exchange scientific knowledge?(y/n)'") then
                    rlprint "These creatures seem to be incredibly smart! While they have gaps in the practical application they seem to be at least comparable to humanitys science. You find nothing you could teach them."
                else
                    rlprint "it seems dissapointed"
                endif
            endif
            if a=4 then rlprint "It says: 'A lot of our knowledge was never tested. It's origins are lost in the mists of time.'"
            if a=5 then rlprint "It says: 'There is a legend that our kind was artificially created as pets for a species that has dissapeared.'"
            if a>=6 then 
                if askyn("It says: 'I'd love to see other worlds! I would volunteer to serve as a science officer for you.' Do you accept(y/n)") then
                    add_member(14,0)
                    e.hp=0
                    e.hpmax=0
                else
                    rlprint "It seems dissapointed."
                endif
            endif
        endif
        if e.aggr=2 then rlprint "It sobs: 'We don't want a war with your kind!"
    endif
    
    if e.lang=22 then
        if e.aggr=0 then rlprint "Ted Rofes, the shipsdoctor doesn't want to chat with you anymore"
        if e.aggr=2 then rlprint "Ted Rofes, the shipsdoctor doesn't want to chat with you anymore"
        if e.aggr=1 then
            a=rnd_range(1,12)
            if a=1 then rlprint "Ted Rofes, the shipsdoctor tells how he crashlanded on this planet."
            if a=2 then rlprint "Ted Rofes, the shipsdoctor explains that the tree creatures are very smart. 'I have learned a lot on this planet.'"
            if a=3 then rlprint "Ted Rofes, the shipsdoctor says 'The rest of the crew wanted to 'defend' themselves against the tree creatures. I warned them but they didn't hear.'"
            if a=4 then rlprint "Ted Rofes, the shipsdoctor explains that he would be dead without the aid of the tree creatures."
            if a=5 then rlprint "Ted Rofes, the shipsdoctor explains that the tree creatures seem to be connected to the ancient alien ruins somehow."
            if a=6 then rlprint "Ted Rofes, the shipsdoctor says 'The tree creatures assume the ancient aliens are their creators.'"
            if a=7 then rlprint "Ted Rofes, the shipsdoctor says 'The tree creatures assume the ancient aliens have had a very complex nerval system, with several nodes distributed about their body, making them very suspectible to telepathy.'"
            if a=8 then rlprint "Ted Rofes, the shipsdoctor says 'There is a cave here that leads to an underground complex of the ancient aliens. I haven't fully explored it. When I found it an ancient robot almost killed me.'"
            if a=9 then rlprint "Ted Rofes, the shipsdoctor says 'Staying here was interesting, but I would like to get back on a ship. I am a doctor, not a tourist.'"
            if a>9 then
                if askyn("Ted Rofes asks if you would let him join your crew 'you seem more reasonable than my old captain' (y/n)") then
                    add_member(15,0)
                    e.hp=0
                    e.hpmax=0
                endif        
            endif
        endif
    endif
    
    
    if e.lang=23 then
        if e.aggr=0 then rlprint "He growls:'Get off our world war monger!'"
        if e.aggr=1 then
            a=rnd_range(1,9)
            if a=1 then rlprint "The Citizen welcomes you to the colony"
            if a=2 then rlprint "The Citizen says: 'The soil, the weather, the plants, everything on this world is perfect for growing crops! As if someone made it for that!'"
            if a=3 then rlprint "The Citizen says: 'The only problem we have are the burrowers: Huge insects that hide in the soil and eat whatever comes their way.'"
            if a=4 then rlprint "The Citizen says: 'Burrowers aside, this world is a paradise.' "
            if a=5 then rlprint "The Citizen says: 'We have got more food than we could ever need' "
            if a=6 then rlprint "The Citizen says: 'There is a bounty of 10 Cr. per dead burrower' "
            if a=7 then rlprint "The Citizen says: 'Pssst... I am hunting burrowers! Its a bounty of 10 Cr. per dead burrower' "
            if a=8 then rlprint "The Citizen says: 'The crops are great this year, but they are always great here.' "
            if a=9 then rlprint "The Citizen says: 'If you killed a burrower you can get your bounty at the town hall.' "
        endif
        if e.aggr=2 then rlprint "He sobs: 'Why did you do this? We only wanted to live in peace!"
    endif
    
    if e.lang=24 then
        if e.aggr=0 then rlprint "They say 'ARRRRRRRGHHHHHHHH!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then rlprint "They say 'Can you show me some sort of ID?'"
            if a=2 then rlprint "They say 'What are you doing here?'"
            if a=3 then rlprint "They say 'I don't think you are supposed to be here.'"
            if a=4 then rlprint "They say 'This planet belongs to eridiani explorations.'"
            if a=5 then rlprint "They say 'This planet belongs to eridiani explorations.'"
            if a=6 then rlprint "They say 'They look at you suspicously'"
        endif
        if e.aggr=2 then rlprint "They say 'I surrender!'"
    endif
    
    
    if e.lang=25 then
        if e.aggr=0 then rlprint "They say 'ARRRRRRRGHHHHHHHH!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then rlprint "They say 'Can you show me some sort of ID?'"
            if a=2 then rlprint "They say 'What are you doing here?'"
            if a=3 then rlprint "They say 'I don't think you are supposed to be here.'"
            if a=4 then rlprint "They say 'This is Smith Heavy Industries property.'"
            if a=5 then rlprint "They say 'This planet belongs to Smith Heavy Industries.'"
            if a=6 then rlprint "They say 'They look at you suspicously'"
        endif
        if e.aggr=2 then rlprint "They say 'I surrender!"
    endif
    
    
    if e.lang=26 then
        if e.aggr=0 then rlprint "They say 'ARRRRRRRGHHHHHHHH!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then rlprint "They say 'Can you show me some sort of ID?'"
            if a=2 then rlprint "They say 'What are you doing here?'"
            if a=3 then rlprint "They say 'I don't think you are supposed to be here.'"
            if a=4 then rlprint "They say 'This Ship belongs to Triax Traders.'"
            if a=5 then rlprint "They say 'You need a Triax Traders authorization.'"
            if a=6 then rlprint "They say 'They look at you suspicously"
        endif
        if e.aggr=2 then rlprint "They say 'I surrender!'"
    endif
    
    
    if e.lang=27 then
        if e.aggr=0 then rlprint "They say 'ARRRRRRRGHHHHHHHH!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then rlprint "They say 'Can you show me some sort of ID?'"
            if a=2 then rlprint "They say 'What are you doing here?'"
            if a=3 then rlprint "They say 'I don't think you are supposed to be here.'"
            if a=4 then rlprint "They say 'This planet belongs to Omega Bionegineering.'"
            if a=5 then rlprint "They say 'This planet belongs to Omega Bionegineering.'"
            if a=6 then rlprint "They look at you suspicously"
        endif
        if e.aggr=2 then rlprint "They say 'I surrender!'"
    endif
    
    
    if e.lang=28 then
        if e.aggr=0 then rlprint "ARRRRRRRGHHHHHHHH!"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then rlprint "He says in a sarcastic tone 'You sure you want to talk to a hardened criminal like me?'"
            if a=2 then rlprint "He says 'We are being held here against our will'"
            if a=3 then rlprint "He says 'The food is bad, the work is worse, and sometimes the guards take out their frustration on us.'"
            if a=4 then rlprint "He says 'This can't be legal! Forcing us to live like this!'"
            if a=5 then rlprint "He says 'I know, i made a mistake, but I don't think they can treat us like this!'."
            if a=6 then rlprint "He says 'Don't owe SHI money, or you'll end up here too!'"
        endif
        if e.aggr=2 then rlprint "I surrender!"
    endif
    
    if e.lang=29 then
        if e.aggr=0 then rlprint "ARRRRRRRGHHHHHHHH!"
        if e.aggr=1 then
            a=rnd_range(1,5)
            if a=1 then rlprint "He says 'The possibilites are remarkable for a scientist here.'"
            if a=2 then rlprint "He says 'You wouldn't understand what we are doing here, or why'"
            if a=3 then rlprint "He says 'This will change exploration and warfare forever!'"
            if a=4 then rlprint "He says 'You are not an industrial spy, are you?'"
            if a=5 then rlprint "He says 'Can't make an omlette without breaking a few eggs'"
            'if a=3 then rlprint "He says 'The food is bad, the work is worse, and sometimes the guards take out their frustration on us.'"
            'if a=4 then rlprint "He says 'This can't be legal! Forcing us to live like this!'"
            'if a=5 then rlprint "He says 'I know, i made a mistake, but I don't think they can treat us like this!'."
            'if a=6 then rlprint "He says 'Don't owe SHI money, or you'll end up here too!'"
        endif
        if e.aggr=2 then rlprint "I surrender!"
    endif
    
    if e.lang=30 then
        if e.aggr=0 then rlprint "It signals with its feelers that it wants to eat you."
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then rlprint "It signals with its feelers that it's just a warrior, ordered to repel the invading bipeds."
            if a=2 then rlprint "It signals with its feelers you are the first who is trying to talk to it."
            if a=3 then rlprint "It signals with its feelers that it's just a warrior, ordered to repel the invading bipeds."
            if a=4 then rlprint "It signals with its feelers if you want to talk peace, you better talk to one of the mothers. It's just a warrior."
            if a=5 then rlprint "It signals with its feelers that it's just a warrior, ordered to repel the invading bipeds."
            if a=6 then rlprint "It signals with its feelers that it doesn't like eating bipeds, they taste funny."
        endif
        if e.aggr=2 then rlprint "It signals with its feelers that it would rather go away."
    endif
        
    if e.lang=31 then
        if e.aggr=0 then rlprint "It signals with its feelers that it wants to eat you."
        if e.aggr=1 then
            a=rnd_range(1,4)
            if a=1 then rlprint "It signals with its feelers that it's a mother, and has ordered her children to repel the invading bipeds."
            if a=2 then rlprint "It signals with its feelers you are the first who is trying to talk to it."
            if a=3 then rlprint "It signals with its feelers that it's a mother, and has ordered her children to repel the invading bipeds."
            if a=4 then 
                if player.questflag(25)=0 then
                    if askyn("Do you want to try and negotiate peace between the burrowers and the settlers? (y/n)") then
                        player.questflag(25)=1
                        rlprint "It signals it's terms with its feelers: No underground construction, and humans have to ask the mothers if they want to build a new farm."
                    endif
                else
                    rlprint "It signals with its feelers cooperating with the bipeds is working out ok."
                endif
            endif
        endif
        if e.aggr=2 then rlprint "It signals with its feelers that it would rather go away."
    endif
    
    if e.lang=32 or e.lang=33 then
        if e.lang=32 then
            c=0
            o=1
        else
            c=1
            o=0
        endif
        if e.aggr=0 then rlprint "Your invasion will not be successful"
        if e.aggr=2 then rlprint "Please let us live in peace!"
        civ(c).contact=1
        if e.aggr=1 then
            b=findbest(23,-1,,205)
            if b>0 and civ(c).culture(4)=2 then
                if askyn("I will pay you 10000 Cr. for the symbol of our ancient leader! Do you accept(y/n)") then
                    addmoney(10000,mt_quest)
                    item(b).w.s=0
                    item(b).w.p=monslot
                else
                    rlprint "It is dissapointed."
                endif
            endif
            rlprint "Do you want to talk about (t)hem, (o)ther species, (f)oreign politics or (n)othing ?(t/o/f/n)"
            t=ucase(keyin("tofnTOFN"))
            if t="N" then return 0
            if t="T" then
                if rnd_range(1,100)<66 then
                    a=rnd_range(1,6)
                    if a=1 then rlprint "It says: 'We call ourselves the "&civ(c).n &"'"
                    if a=2 then 
                        if civ(c).inte=1 then rlprint "It says' A new space faring species! I hope you brought many scientific secrets!"
                        if civ(c).inte=2 then 
                            if civ(c).aggr=1 then rlprint "It says' A new space faring species! I wonder if you have interesting things for us to buy!"
                            if civ(c).aggr=2 then rlprint "It says' A new space faring species! May we enter fruitfull trading relations soon!"
                            if civ(c).aggr=3 then rlprint "It says' A new space faring species! We have many interesting things to sell! You sure will find something!"
                        endif
                        if civ(c).inte=3 then
                            if civ(c).aggr=1 then rlprint "It says 'Beware! We will defend our territory!"
                            if civ(c).aggr=2 then rlprint "It says 'I hope your species does not plan to interfere with our plans of expansion."
                            if civ(c).aggr=3 then rlprint "It says 'Since the ancients passed on we, the "&civ(0).n &", have been dominant in this part of space.'"
                        endif
                    endif
                    if a=3 then rlprint "It says 'We, the "&civ(c).n &", have invented FTL travel "&civ(c).tech*100 &" cycles ago. How long have you known the secret?"
                    if a=4 then
                        if civ(c).phil=1 then rlprint "It says 'I believe strongly in the right of the individual. How about you?"
                        if civ(c).phil=2 then rlprint "It says 'We, the "&civ(c).n &", strive for a balance between common good and individual freedom. How about your species?"
                        if civ(c).phil=3 then rlprint "It says 'We, the "&civ(c).n &", think the foremost reason for existence is for the species to survive and prosper. How about your species?"
                    endif
                    if a=5 then 
                        if civ(c).inte=1 then rlprint "It says' A new space faring species! I hope you brought many scientific secrets!"
                        if civ(c).inte=2 then 
                            if civ(c).aggr=1 then rlprint "It says' A new space faring species! I wonder if you have interesting things for us to buy!"
                            if civ(c).aggr=2 then rlprint "It says' A new space faring species! May we enter fruitfull trading relations soon!"
                            if civ(c).aggr=3 then rlprint "It says' A new space faring species! We have many interesting things to sell! You sure will find something!"
                        endif
                        if civ(c).inte=3 then
                            if civ(c).aggr=1 then rlprint "It says 'Beware! We will defend our territory!"
                            if civ(c).aggr=2 then rlprint "It says 'I hope your species does not plan to interfere with our plans of expansion."
                            if civ(c).aggr=3 then rlprint "It says 'Since the ancients passed on we, the "&civ(0).n &", have been dominant in this part of space.'"
                        endif
                    endif
                    if a=6 then 
                        if civ(c).aggr=1 then rlprint "It says 'our population is "&civ(c).popu &" billion "&civ(c).n &"s and stable.'"
                        if civ(c).aggr=2 then rlprint "It says 'our population is "&civ(c).popu &" billion "&civ(c).n &"s and stable.'"
                        if civ(c).aggr=3 then rlprint "It says 'our population is "&civ(c).popu &" billion "&civ(c).n &"s and increasing.'"
                    endif
                else
                    talk_culture(c)
                endif
            endif
            if t="O" then
                a=rnd_range(1,6)
                if a=1 then
                    if civ(o).phil=civ(c).phil then 
                        rlprint "There is another space faring civilisation in this sector. The "&civ(o).n &" have a similiar outlook to us concerning life."
                    else
                        if civ(o).phil>civ(c).phil then
                            rlprint "There is another space faring civilisation in this sector. The "&civ(o).n &" don't value freedom like we do."
                        else
                            rlprint "There is another space faring civilisation in this sector. The "&civ(o).n &" aren't very well organized."
                        endif
                    endif
                endif
                if a=2 then
                    if civ(o).tech=civ(c).tech then 
                        rlprint "There is another space faring civilisation in this sector. The "&civ(o).n &" are on the same level technlogically as we are."
                    else
                        if civ(o).tech>civ(c).tech then
                            rlprint "There is another space faring civilisation in this sector. The "&civ(o).n &" know secrets we do not know yet."
                        else
                            rlprint "There is another space faring civilisation in this sector. The "&civ(o).n &" are more primitive than us."
                        endif
                    endif
                endif
                if a=3 then
                    if civ(o).aggr=1 then rlprint "There is another space faring civilisation in this sector. The "&civ(o).n & " like to keep close to home."
                    if civ(o).aggr=2 then rlprint "There is another space faring civilisation in this sector. The "&civ(o).n & " are interested in exploring new systems"
                    if civ(o).aggr=3 then rlprint "There is another space faring civilisation in this sector. The "&civ(o).n & " are very expansionist"
                endif
                if a=4 then
                    if civ(o).inte=1 then rlprint "There is another space faring civilisation in this sector. The "&civ(o).n & " are prolific merchants."
                    if civ(o).inte=2 then rlprint "There is another space faring civilisation in this sector. The "&civ(o).n & " very interested in science"
                    if civ(o).inte=3 then rlprint "There is another space faring civilisation in this sector. The "&civ(o).n & " are very warlike"
                endif
                if a=5 then rlprint "There is another space faring civilisation in this sector, the "&civ(o).n &"."
            endif
            if t="F" then
                foreignpolicy(c,1)
            endif
        endif
        if e.lang=34 then
            if e.aggr=0 or e.aggr=2 then
                rlprint "It says 'You are evil, you hurt the masters'"
            else
                rlprint "It says 'I like the masters, do you like the masters too?'"
            endif
            
        endif
    endif
    
    
    if e.lang=34 then
        if e.aggr=0 then rlprint "ARRRRRRRGHHHHHHHH!"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then rlprint "He says 'Welcome to our station!'"
            if a=2 then rlprint "He says 'Feels good to stretch your legs a little, doesn't it?'"
            if a=3 then rlprint "He says 'Remember to visit the bar!'"
            if a=4 then rlprint "He says 'We cater to transport ships mainly. They come by here quite often'"
            if a=5 then rlprint "He says 'I make some money flying in fuel from a nearby gas giant'"
            if a=6 then rlprint "He says 'I hope you enjoy your stay here.'"
        endif
        if e.aggr=2 then rlprint "I surrender!"
    endif
    
    if e.lang=35 then
        if e.aggr=0 then rlprint "To think that I went through all this just to have to fight this rabble."
        if e.aggr=1 then
            if rnd_range(1,100)<10 then
                rlprint "Hey, I was once just like you, and now I am off to retire! Good luck out there! Here, have a few credits if you ever get into a rough spot."
                player.money+=rnd_range(10,100)
            else
                a=rnd_range(1,6)
                if a=1 then rlprint "He pats your back, saying he is sure that you will make it too."
                if a=2 then rlprint "He pats your back, advises you to be carefull when dealing with aliens."
                if a=3 then rlprint "He pats your back, saying you should stay out of trouble."
                if a>=4 then
                    b=specialplanet(rnd_range(0,lastspecial))
                    rlprint "He tells you that there is an interesting world at " &map(sysfrommap(b)).c.x &":"& map(sysfrommap(b)).c.y & "."
                endif
            endif
        endif
        if e.aggr=2 then rlprint "I surrender!"
    endif
    
    if e.lang=36 then
        if e.aggr=0 then rlprint "The Scientist says: 'I am not going to deal with you, criminal!'"
        if e.aggr=1 then
            if askyn("I have some information on nearby star systems to sell. Do you want to buy it for 50 Cr.?(y/n)") then
                if paystuff(50) then
                    rlprint "He hands you a data crystal"
                    for a=0 to laststar
                        if map(a).discovered=-1 then map(a).discovered=1
                    next
                endif
            endif
        endif
        if e.aggr=2 then rlprint "I surrender!"
    endif
    
    if e.lang=37 then
        if e.aggr=0 then rlprint "I am not going to deal with you!"
        if e.aggr=2 then rlprint "I surrender!"
        if e.aggr=1 then
            if askyn("If you got problem with the megacorps, i could take a look at your record, and see what I can do. (y/n)") then
                if faction(0).war(1)+faction(0).war(3)>0 then
                    if askyn("Ok, I could do something there for "& (faction(0).war(1)+faction(0).war(3))*75 &" Cr. (y/n)") then
                        if paystuff(faction(0).war(1)+faction(0).war(3))*75 then
                            faction(0).war(1)=0
                            faction(0).war(3)=0
                            rlprint "All right, they shouldn't bother you anymore."
                        endif
                    endif
                else
                    rlprint "I don't think you have any problems."
                endif
            else
                rlprint "Ok, feel free to see me anytime"
            endif
        endif
    endif
    
    if e.lang=38 then
        if e.aggr=0 then rlprint "Drop your weapons and surrender!"
        if e.aggr=2 then rlprint "Help!"
        if e.aggr=1 then 
            select case rnd_range(1,5)
            case 1
                rlprint "Just protecting the station sir."
            case 2
                rlprint "I hope you are enjoying a safe and secure stay."
            case 3
                rlprint "If I can help you with anything let me know."
            case 4
                rlprint "I can tell you, this job beats ship security hands down."
            case 5
                rlprint "Make sure to visit our numerous shops!"
            end select
        end if
    end if
    
    if e.lang=39 then
        if e.aggr=0 then rlprint "Drop your weapons and surrender!"
        if e.aggr=2 then rlprint "Help!"
        if e.aggr=1 then 
            select case rnd_range(1,5)
            case 1
                rlprint "Just protecting the company office sir."
            case 2
                rlprint "I hope you are enjoying a safe and secure stay."
            case 3
                rlprint "Please use our offices in an orderly manner."
            case 4
                rlprint "Company security. What is your business?"
            case 5
                rlprint "Company security coming through. Step aside!"
            end select
        end if
    end if
    
    if e.lang=40 then
        if e.aggr=0 or e.aggr=2 then rlprint "Leave me alone!"
        if e.aggr=1 then
            select case rnd_range(1,7)
            case 1 to 3
                rlprint "I've had some tough luck. Reduced to squatting in the bowels of this station."
            case 5 to 6
                rlprint "Thing's haven't worked out like i hoped they would."
            case else
                rlprint "Do you have a credit to spare?"
                a=menu(bg_awayteamtxt,"Response:/Offer credit/Offer job/Offer advice/Offer nothing")
                select case a
                case 1
                    if player.money>=1 then
                        player.money-=1
                        rlprint "Thank you very much!"
                    else
                        rlprint "You realize that you don't have a credit to spare!"
                    endif
                case 2
                    rlprint "I won't dissapoint you, I promise!"
                    if max_security>0 then
                        e.hp=0
                        e.hpmax=0
                        add_member(19,0)
                    else
                        rlprint "You don't have enough room."
                    endif
                    
                case else
                    rlprint "Well... I'd like to be in your shoes rather than mine as well."
                end select
            end select
        endif
    endif
            
    return 0
end function


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tCommunicate -=-=-=-=-=-=-=-
	tModule.register("tCommunicate",@tCommunicate.init()) ',@tCommunicate.load(),@tCommunicate.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tCommunicate -=-=-=-=-=-=-=-
#endif'test
