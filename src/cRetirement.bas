'tRetirement.
'
'namespace: tRetirement

'
'
'defines:
'buytitle=0, retirement=3, hasassets=0, sellassetts =0, es_living=0,
', es_title=0, es_part1=0
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
'     -=-=-=-=-=-=-=- TEST: tRetirement -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tRetirement -=-=-=-=-=-=-=-


'private function tRetirement
'private function tRetirement
'private function hasassets() as short
'private function sellassetts () as string
'private function es_living(byref pmoney as single) as string
'private function es_title(byref pmoney as single) as string
'private function es_part1() as string

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tRetirement -=-=-=-=-=-=-=-

namespace tRetirement
	
function init() as Integer
	return 0
end function

Dim Shared assets(16) As UByte

public function buytitle() as short
    dim as short a,b
    dim as integer price
    dim as string title
    dim sameorbetter as byte
    a=textmenu(bg_parent,"Buy title /Lord - 1,000 Cr./Baron - 5,000 Cr./Viscount - 10,000 Cr./Count 25,000 Cr./Marquees - 50,000 Cr./Duke - 100,000 Cr./Exit")
    if a>0 and a<7 then
        if a=1 then
            title="Lord"
            price=1000
        endif
        if a=2 then
            title="Baron"
            price=5000
        endif
        if a=3 then
            title="Viscount"
            price=10000
        endif    
        if a=4 then
            title="Count"
            price=25000
        endif
        if a=5 then
            title="Marquese"
            price=50000
        endif
        if a=6 then
            title="Duke"
            price=100000
        endif
        for b=1 to 6
            if assets(b+8)=1 and a<b then sameorbetter=1
        next
        if assets(a+8)=0 and sameorbetter=0 then
            if paystuff(price) then
                assets(a+8)=1
            endif
        else
            rlprint "You already have a better title."
        endif
    endif
    
    return 0
end function



public function Retirement() as short
    dim as short a,b
    dim price(9) as integer
    dim asset(9) as string
    dim desc(9) as string
    dim as string mtext,htext
    asset(1)="Muds store franchise"
    desc(1)="A permit to operate a store under the well known 'Mud's' brand name. The opportunity to make a living by buying at insanely low prices, at negligable risk!"
    price(1)=500
    asset(2)="life insurance"
    desc(2)="A small rent to be paid until your death, from your 60th birthday onwards."
    price(2)=1000
    asset(3)="country manor"
    desc(3)="A nice estate in the country on a civilized World. Perfect to spend the autumn years of life."
    price(3)=2500
    asset(4)="small asteroid"
    desc(4)="A small asteroid in a colonized star system. Several rooms with lifesupport already carved out."
    price(4)=5000
    asset(5)="hollowed asteroid base"
    desc(5)="A small asteroid, hollowed out, with a small self sufficient ecosystem. Enough room in the shell to house a small towns population."
    price(5)=50000
    asset(6)="big terraformed asteroid"
    desc(6)="A large asteroid, big enough to hold a thin atmosphere, terraformed, self sufficient, and yet uninhabited."
    price(6)=100000
    asset(7)="small planet"
    desc(7)="A small, arid planet. Thin oxygen atmosphere. Further terraforming possible"
    price(7)= 250000
    asset(8)="planet"
    desc(8)="A medium sized planet with an oxygen atmosphere. It's habitable, if further terraforming would be a good investment"
    price(8)=500000
    asset(9)="Earthlike planet"
    desc(9)="A planet with an oxygen atmosphere, oceans and continents. Lifeforms are present, but nothing dangerous."
    price(9)=1000000
    mtext="Assets/"
    htext="/"
    for a=1 to 9
        mtext=mtext &asset(a) &space(_swidth-len(asset(a))-len(credits(price(a))))&credits(price(a))& "Cr./"
        htext=htext &desc(a) &"/"
    next
    mtext=mtext &"back"
    htext=htext &"/"
    do
        a=textmenu(bg_parent,"tRetirement/ retire now/ buy assets/back")
        if a=1 then
            if askyn("Do you really want to retire now? (y/n)") then
                if askyn("Are you sure? (y/n)") then 
                    player.dead=98
                endif
            endif
        endif
        if a=2 then
            do
                b=textmenu(bg_parent,mtext,htext)
                
                if b>0 and b<10 then
                    if assets(b-1)=0 or b=2 or b=1 then
                        if paystuff(price(b)) then
                            rlprint "You buy "&add_a_or_an(asset(b),0) &"." 
                
                            if assets(b-1)<255 then assets(b-1)+=1
                        endif
                    else
                        rlprint "You already have that"
                    endif
                endif
            loop until b=-1 or b=10
        endif
    loop until player.dead<>0 or a=3
    return 0
end function



function hasassets() as short
    dim a as short
    for a=2 to 8
        if assets(a)>0 then return 1
    next
    return 0
end function

function sellassetts () as string
    dim t as string
    if assets(2)>0 then
        player.money+=500
        assets(2)=0
        return "You have to sell your country manor"
    endif

    if assets(3)>0 then
        player.money+=1000
        assets(4)=0
        return "You have to sell your small asteroid base"
    endif

    if assets(4)>0 then
        player.money+=2500
        assets(4)=0
        return "You have to sell your asteroid base"
    endif

    if assets(5)>0 then
        player.money+=5000
        assets(5)=0
        return "You have to sell your terraformed asteroid"
    endif

    if assets(6)>0 then
        player.money+=125000
        assets(6)=0
        return "You have to sell your small planet"
    endif

    if assets(7)>0 then
        player.money+=250000
        assets(7)=0
        return "You have to sell your planet"
    endif

    if assets(2)>0 then
        player.money+=500000
        assets(2)=0
        return "You have to sell your earthlike planet"
    endif
    return t
end function


function es_living(byref pmoney as single) as string
    dim as string t
    if assets(9)>0 then
        t=t &" |You finally settle down on your very own planet!"
        if pmoney<100 then t=t &" You have to sell some ground to Settlers make ends meet."
        if pmoney>500 then t=t &" Soon you build a nice house on it."
        if pmoney>1000 then t=t &" You are able to equip it with every luxury you could ever dream of."
        if pmoney>1200 then t=t &" You also can hire servants for whatever task you do not want to do yourself."
        if pmoney>10000 then t=t &" |There is even enough money to terraform one of it's moons, providing a nice place for weekend vacations."
        return t
    endif

    if assets(8)>0 then
        t=t &" |You finally settle down on your very own planet! It's a bit barren, but it's yours!"
        if pmoney<100 then t=t &" You have to sell some ground to Settlers make ends meet."
        if pmoney>500 then t=t &" Soon you build a nice house on it."
        if pmoney>1000 then t=t &" You are able to equip it with every luxury you could ever dream of."
        if pmoney>1200 then t=t &" You also can hire servants for whatever task you do not want to do yourself."
        if pmoney>=2500 then t=t &" The place gets a lot nicer after some minor terraforming!"
        return t
    endif
    if assets(7)>0 then
        t=t &" |You finally settle down on your very own - well, dessert, but still - planet!"
        if pmoney<100 then t=t &" You have to sell some ground to Settlers make ends meet."
        if pmoney>500 then t=t &" Soon you build a nice house on it."
        if pmoney>1000 then t=t &" You are able to equip it with every luxury you could ever dream of."
        if pmoney>1200 then t=t &" You also can hire servants for whatever task you do not want to do yourself."
        if pmoney>2500 and pmoney<5000 then t=t &" Within a few years you have built a domed settlement on it."
        if pmoney>=5000 then t=t &" The place gets a lot nicer after the terraforming company has done their job!"
        return t
    endif
    if assets(6)>0 then
        t=t &" |You finally settle down on your little planet"
        if pmoney<100 then t=t &" You have to sell some ground to Settlers make ends meet."
        if pmoney>500 then t=t &" Soon you build a nice house on it."
        if pmoney>1000 then t=t &" You are able to equip it with every luxury you could ever dream of."
        if pmoney>1200 then t=t &" You also can hire servants for whatever task you do not want to do yourself."
        if pmoney>2500 and pmoney<5000 then t=t &" Within a few years you have built a domed settlement on it."
        if pmoney>=5000 then t=t &" The place gets a lot nicer after the terraforming company has done their job!"
        return t
    endif
    if assets(5)>0 then
        t=t &" |You retire to your terraformed asteroid"
        if pmoney<100 then t=t &" You have to sell some ground to asteroid miners to make ends meet."
        if pmoney>500 then t=t &" Soon you build a nice house on it."
        if pmoney>1000 then t=t &" You are able to equip it with every luxury you could ever dream of."
        if pmoney>1200 then t=t &" You also can hire servants for whatever task you do not want to do yourself."
        return t
    endif
    if assets(4)>0 then
        t=t &" |The asteroid base you bought serves you well as a home."
        if pmoney<100 then t=t &" You have to rent some space to asteroid miners to make ends meet."
        if pmoney>1000 then t=t &" You are able to equip it with every luxury you could ever dream of."
        return t'
    endif
    if assets(3)>0 then
        t=t &" |The small asteroid you bought serves as your home." 'Small Asteroid
        if pmoney<100 then t=t &" You have to rent some space to asteroid miners to make ends meet."
        if pmoney>1000 then t=t &" You are able to equip it with every luxury you could ever dream of."
        return t
    endif
    if assets(2)>0 then
        t=t &" |You spend the autumn years of your life in your Country Manor"
        if pmoney<50 then t=t &" You have to rent some rooms to students to make ends meet."
        if pmoney>1000 then t=t &" You are able to equip it with every luxury you could ever dream of."
        return t
    endif
end function


function es_title(byref pmoney as single) as string
    dim t as string
    dim landless as short
    dim as short a
    for a=2 to 8
        if assets(a)>0 then landless=landless+a
    next
    if assets(14)>0 then
        t=t &""
        if landless=0 then t=t &" |You soon find out the title of a Duke is worth quite a bit even without any assets to go with it. People pay you to show up at their events and give speeches, and want to elect you to high local government positions. "
        if landless>0 and landless<5 then t=t &"|You have power, you have prestige. You are a bit poor for a duke, but few can oppose you."
        if landless>=5 then t=t &"|You are a rich, powerful duke. What you say is law in your community. And that community is pretty large. Nobody can oppose you politically or economically"
        pmoney=pmoney+5000*(landless+1)
        return t
    endif
    if assets(13)>0 then
        t=t &""
        if landless=0 then t=t &" |You soon find out the title of a Marquese is worth quite a bit even without any assets to go with it. People pay you to show up at their events and give speeches. "
        if landless>0 and landless<5 then t=t &"|Your title of Marquese offers a lot of prestige and power. You cant always back it up with economic might, but you are a political heavyweight in your community"
        if landless>=5 then t=t &"|Only few in your communitiy are more powerfull than you are. You demand taxes, run a policeforce, and have influence on the legeslative process"
        pmoney=pmoney+2500*(landless+1)
    endif
    if assets(12)>0 then
        t=t &""
        if landless=0 then t=t &" |You soon find out the title of a Count is worth a bit even without any assets to go with it. It opens doors in politics"
        if landless>0 and landless<5 then t=t &"|You aren't exactly rich for a Count, but still can demand tax money from quite a few people and add your voice to policy making."
        if landless>=5 then t=t &"|You are an important person with considerable fame and wealth. Not a lot goes past you concerning local politics or business."
        pmoney=pmoney+1000*landless+100
    endif
    if assets(11)>0 then
        t=t &""
        if landless=0 then t=t &" |You soon find out the title of a viscount isn't worth much without any assets to go with it. But it opens doors in politics"
        if landless>0 and landless<5 then t=t &"|Your title of viscount opens doors, and your considerable land keeps them open. You make quite a bit of money with taxes"
        if landless>=5 then t=t &"|What you can't do with your title, you can do with your assets. You can collect enough tax money to help building local infrastructure."
        pmoney=pmoney+500*landless+100
        return t
    endif

    if assets(10)>0 then
        t=t &""
        if landless=0 then t=t &" |You soon find out the title of a Baron isn't worth much without any assets to go with it."
        if landless>0 and landless<5 then t=t &"|Your title of Baron combined with your meager holdings of real estate allows for a nice additional tax and tarif income."
        if landless>=5 then t=t &"| You are a Baron, you have impressive holdings. You can add tax income to your already impressive assets!"
        pmoney=pmoney+250*landless
    endif
    if assets(9)>0 then
        t=t &""'adel
        if landless=0 then t=t &" |You soon find out the title of a Lord isn't worth much without any assets to go with it."
        if landless>0 and landless<5 then t=t &"|Your title of Lord and meager holdings allow a tiny tax income."
        if landless>=5 then t=t &"|You are a Lord, you have more than enough land. You are now low nobility, and make a decent penny by taxing."
        pmoney=pmoney+100*landless
    endif
end function


function es_part1() as string
    dim t as string
    dim as single mpy,pmoney
    dim as short i,allsum,rent

    for i=1 to 7
        allsum+=alliance(i)
    next

    select case player.money
        case is<=0
            t="You retire with a debt of "&credits(player.money) &" Cr."
        case else
            t="You retire with "&credits(player.money) &" Cr. to your name."
    end select

    t = t &" Your ship doesn't have the range to get back to civilization, you need to book a passage on a long range transport ship for that.|"

    if player.money<500 then
        t=t & " To get a flight back to civilization you sell your ship."
        player.money=player.money+player.h_price/5
        if player.money<500 and assets(0)<>0 then
            t=t &" You sell your Mudds store Franchise License."
            assets(0)=0
            player.money=player.money+250
        endif
        if player.money<500 and assets(1)<>0 then
            t=t &" You even sell your life insurance!"
            assets(1)-=1
            player.money=player.money+250
        endif
    endif
    if player.money<500 then
        t=t &" yet still you don't have enough money to return home."
        if rnd_range(1,6)<=2 then
            t=t &" To make matters worse you are unable to find a job at the station. "
            if rnd_range(1,6)<=2 then
                t=t &" Finally a colonist takes you in as a farm hand."
            else
                t=t &" You have no other choice but to sign on as security on another freelancer ship."
                if rnd_range(1,6)<3 then
                    t = t &" Your exprience in planet exploration soon shows, and you survive long enough to make enough money for a ticket back home."
                    player.money=player.money+500
                else
                    t=t &" After several expeditions you finally find yourself were most redshirts end up. On the wrong end of a hungry alien"
                    return t
                endif
            endif
        else
            select case rnd_range(1,6)
            case is =1
                t=t &" You find a job as a janitor."
            case is =2
                t=t &" You find a job as a waiter."
            case is =3
                t=t &" You find a job as a cook."
            case is =4
                t=t &" You find a job as station security."
            case is =5
                t=t &" You find a job as a station shop assistant."
            case is =6
                t=t &" You find a job as a traders assistant."
            end select
            select case rnd_range(1,6)
            case is =1
                t=t &" Unfortunately your employer goes broke before you get your first wage."
                player.money=player.money+0
            case is =2
                t=t &" Unfortunately your employer doesn't pay well and rarely on time."
                player.money=player.money+50
            case is =3
                t=t &" You get an average wage for your position."
                player.money=player.money+100
            case is =4
                t=t &" You get an average wage for your position"
                player.money=player.money+125
            case is =5
                t=t &" Luckily you get paid rather well."
                player.money=player.money+250
            case is =6
                t=t &" Payment is extraordinary and you wonder why you ever decided to become a freelancer."
                player.money=player.money+500
            end select
        endif
    endif
    if player.money>=500 then
        player.money=player.money-500
        t=t &"|You board the next ship back to civilization, and arrive back home with "&credits(player.money) &" Credits."
    else
        t=t &"|You make enough money to live, but not enough to ever get back to civilization."

        t=t &"|"
        if rnd_range(1,100)<33 then
            t=t & "You never find a partner to share your life with. Looks like the only love of a captain is his ship."
        else
            if rnd_range(1,100)<33 then
                t=t & "You have several relationships but nothing serious. Looks like you are not made for lasting romance."
            else
                t=t & "One day you find the love of your life."
                if rnd_range(1,100)<33 then
                    t=t &" You don't have children. "
                else
                    if rnd_range(1,100)<33 then
                        t=t &" You have children. "
                    else
                        t=t &" You have a child."
                    endif
                endif
            endif
        endif
        t=t & "|"
        return t
    endif

    t=t &"||"

    mpy=player.money/(20+rnd_range(1,6))
    if mpy<120 and assets(6)=0 and assets(7)=0 and assets(8)=0  then
        if assets(0)>0 then
            t=t &"|You soon realize that you need to open a shop with your mud's store license to make a comfortable living."
            mpy=mpy+rnd_range(200,1000)
        else
            t=t &"|Soon all your money is gone and you start looking for a job."
            select case rnd_range(1,6)
            case is =1
                t=t &" Your second carreer after being an explorer turns out to be that of a shop assistant."
                mpy=mpy+120
            case is =2
                t=t &" Your second carreer after being an explorer turns out to be that of an accountant."
                mpy+=240
            case is =3
                t=t &" Your second carreer after being an explorer turns out to be with the military."
                mpy+=200
            case is =4
                t=t &" Your second carreer after being an explorer turns out to be that of a industrial designer."
                mpy+=480
            case is =5
                t=t &" Your second carreer after being an explorer turns out to be in middle management."
                mpy+=960
            case is =6
                t=t &" Your second carreer after being an explorer turns out to be that of a freighter captain."
                mpy+=240
            end select

        endif
    endif

    t=t &"|"
    if rnd_range(1,100+mpy)<33 then
        t=t & "You never find a partner to share your life with. Looks like the only love of a captain is his ship."
    else
        if rnd_range(1,100)<33 then
            t=t & "You have several relationships but nothing serious. Looks like you are not made for lasting romance."
        else
            t=t & "One day you find the love of your life."
            if rnd_range(1,100)<33 then
                t=t &" You don't have children. "
            else
                if rnd_range(1,100)<33 then
                    t=t &" You have children. "
                else
                    t=t &" You have a child."
                endif
            endif
        endif
    endif
    t=t & "|"
    t=t &"|After several years of work it's finally time to retire!|"
    if hasassets>0 then
        pmoney=(player.money+assets(0)*500)/rnd_range(33,44)+assets(1)*250
        if assets(0)>0 then
            if assets(0)=1 then t=t &" |You sell your well going Mud's store and franchise." 'Muds Store
            if assets(0)>1 then t=t &" |You sell your well going Mud's store and franchises." 'Muds Store
        endif
        if assets(1)>0 then
            if assets(1)=1 then t=t &" |Your life insurance finally pays out." 'Life insurance
            if assets(1)>1 then t=t &" |Your life insurances finally pays out." 'Life insurance
        endif

        t=t &es_living(pmoney)
        t=t &es_title(pmoney)

        if assets(8)>0 then pmoney=pmoney+1000 'Taxing your planet
        mpy=(mpy+pmoney)/2
    endif

    if mpy<120 then t=t &" You lead a modest life, with nothing but a small pension and little assets."

    if mpy>=120 and mpy<500 then
        t=t &" You lead a life of leasure, you rarely if ever need to take on a job to get through a tight spot."
    endif

    if mpy>=500 and mpy<1200 then
        t=t &" You lead a life of leasure, and only work when you want to."
    endif

    if mpy>=1200 and mpy<2400 then
        t=t &" You lead a life of leasure and modest luxury."
    endif

    if mpy>=2400 and mpy<4800 then
        t=t &" You have enough money to spend the rest of your life in luxury."
    endif

    if mpy>=4800 then t=t &" You have more money than you could ever spend."

    if player.questflag(3)=2 then
        t=t &" ||During all this time the use of the recovered alien scout ships helps humanity to further reach for the stars. You are near the end of your life as human influence has reached almost every corner of the milkyway galaxy. Finally there are news of a civilization discovered in the magellanic clouds who can equal human prowess in most areas, and even surpass their scientific knowledge in some."
        if rnd_range(1,100)<66-allsum*10 then
            t=t &" ||  Unfortunately the diplomats can't work out a lasting peace. When you lie on your Deathbed the war for the galaxy still rages on, and propably will for many more centuries to come."
        else
            t=t &" ||  Peacefull relations are established quickly, and a joint project is founded: Launching an expedtition to Andromeda! "
            if rnd_range(1,100)<66 then
                t=t &"|| As you lie on your deathbed you wish you were young enough to join the adventure. But you have led a life, more exciting than most can claim, and the next adventure for you, won't be in space."
            else
                t=t &"|| One day you are approached by the head of the andromeda fleet construction team, and offered a unique position: They want to extract your conciousness, to use in a new sort of bio-electronic computer. Your task will be to guide a ship across the intergalactic void, and command the exploration and colonization efforts."
                if rnd_range(1,100)<66 then
                    t=t & " Immortality is tempting, but you have led a long, and exciting life, and you decide that your next adventure will be your last, and one you will never return from."
                else
                    t=t & " You accept. ||"
                    if rnd_range(1,100)<66 then
                        t=t &" Unfortunately something goes wrong in the extraction process. ||Fortunately you will never know."
                    else
                        t=t &" The next thing you know you take a stroll across the Solar System. You amuse yourself for a second counting the electrons in Saturns lightning storms, take a minute to look for future comets in the Kuiper belt. |Finally you take up your cargo of fragile little human beings, watch every single one of them go into cryo sleep, send your farewells to humanity, aim for Andromeda, and start running! |It is going to be a long time running, but you will occupy yourself by counting the stars in your target, and deciding on which to explore first."
                    endif
                endif
            endif
        endif
    else
        if allsum>0 then
            if rnd_range(1,100)<allsum*20 then
                t=t &" The alliance you brokered holds and is successful at keeping the robot ships in check.|"
            else
                t=t &" The alliance you helped form just isn't big enough to keep the robot ships in check.|"
            endif
        endif
        if rnd_range(1,100)<66 then
            t=t &" | During all this, there are more and more reports of mysterious robot ships"_
            &" attacking explorers, settlers and traders in the sector of space you helped to"_
            &" explore. |Finally the stations are abandoned. "_
            &"|Mankind seems to come to the conclusion that the exploration of space is too "_
            &"dangerous. New expeditions are cancelled, the current holds of humanity fortified. "_
            &"After taking a bloody nose, humans decide to hole up, in case something dangerous is out there."
        else
            t=t &" | You pay little attention to news that come out of the sector where you earned your riches. "_
            &" That changes when SHI announces that they managed to control a type of automated alien scoutships, that was a threat to exploration and commerce in the sector before."_
            &" Automated exploration becomes standard, and much safer for humans, but you are too old to be part of this new adventure."
        endif
        t=t &" ||And you finally pass on to the next adventure, one you will never return from."
    endif
    t=t &" ||| "&space(tScreen.x/(_fw2*2)-15)&" T H E  E N D ||"
    return t
end function

End Namespace
#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: retirement -=-=-=-=-=-=-=-
	tModule.register("tRetirement",@tRetirement.init()) ',@tRetirement.load(),@tRetirement.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tRetirement -=-=-=-=-=-=-=-
#endif'test
