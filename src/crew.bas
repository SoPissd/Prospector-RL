declare function showteam(from as short, r as short=0,text as string="") as short



function skill_test(bonus as short,targetnumber as short,echo as string="") as short
    dim as short roll
    roll=rnd_range(1,20)
    if roll+bonus>=targetnumber then
            if echo<>"" and configflag(con_showrolls)=0 then 
                if bonus>0 then rlprint echo &" needed "& targetnumber &", rolled "&roll &"+"& bonus &": Success.",c_gre
                if bonus=0 then rlprint echo &" needed "& targetnumber &", rolled "&roll &": Success.",c_gre
                if bonus<0 then rlprint echo &" needed "& targetnumber &", rolled "&roll & bonus &": Success.",c_gre
            endif
        return -1
    else
        if echo<>"" and configflag(con_showrolls)=0 then 
            if bonus>0 then rlprint echo &" needed "& targetnumber &", rolled "&roll &"+"& bonus &": Failure.",c_red
            if bonus<0 then rlprint echo &" needed "& targetnumber &", rolled "&roll & bonus &": Failure.",c_red
            if bonus=0 then rlprint echo &" needed "& targetnumber &", rolled "&roll &": Failure.",c_red
        endif
        return 0
    end if
end function



function can_learn_skill(ci as short,si as short) as short
    if (crew(ci).typ<=8 or crew(ci).typ>=14) and si>16 and si<=26 then return -1
    select case crew(ci).typ
    	case is=1 'Captain
        if si>=1 and si<=6 then return -1
    case is=2 'Gunny
        if si>6 and si<=9 then return -1
    case is=3 'Pilot
        if si>9 and si<=13 then return -1
    case is=4 'SO
        if si>13 and si<=16 then return -1
    case is=5 'Doctor
        if si>16 and si<=19 then return -1
    end select
    return 0
end function


function best_crew(skill as short, no as short) as short
    dim as short i,j,result,last
    dim skillvals(128) as short
    for i=0 to 128
        if crew(i).baseskill(skill)>0 and crew(i).hp>0 and (crew(i).onship=location or location=lc_onship) then
            j+=1
            skillvals(j)=crew(i).baseskill(skill)
        endif
    next
    last=j
    if last=0 then return crew(1).baseskill(skill) 'Captain takes place if nobody else does
    do
        j=0
        for i=1 to last
            if skillvals(i)<skillvals(i+1) then
                j=1
                swap skillvals(i),skillvals(i+1)
            endif
        next
    loop until j=0
    if no>last then no=last
    for i=1 to no
        result=result+skillvals(i)/i
    next

    return result
end function



function findartifact(v5 as short) as short
            dim c as short
            rlprint "After examining closely, your science officer has found an alien artifact."
            
            if all_resources_are=0 then
                if v5=0 then
                    c=rnd_range(1,25)
                    if c=2 or c=5 then
                        c=rnd_range(1,10)
                        if c=2 or c=5 then artflag(c)=1
                    endif
                else
                    c=v5
                endif
            else
                c=all_resources_are
            endif
            if c<0 or c>22 then c=rnd_range(1,25)
            if (skill_test(player.science(1),st_veryhard,"Examining artifact") and artflag(c)=0 and c<>2 and c<>5) or all_resources_are>0 then
                artflag(c)=1                
                artifact(c)
            else
                rlprint "Science officer can't figure out what it is.",14
                reward(4)=reward(4)+1
            endif
            return 0
end function


function max_security() as short
    dim as short b,total
    total=2*(player.h_maxcrew-5)+2*player.crewpod+player.cryo
    for b=6 to 128
        if crew(b).hp>0 then total-=1
    next
    return total
end function


function total_bunks() as short
    return player.h_maxcrew+player.crewpod+player.cryo-5
end function


'function add_talent(cr as short, ta as short, value as single) as single
'    dim total as short
'    if cr>=0 then
'        if crew(cr).hp>0 and crew(cr).talents(ta)>0 and ta=10 then
'            if player.tactic>0 then return crew(cr).talents(ta)
'            if player.tactic<0 then return -crew(cr).talents(ta)
'            return 0
'        endif
'        if crew(cr).hp>0 and crew(cr).talents(ta)>0 then return value*crew(cr).talents(ta)
'    else
'        value=0
'        for cr=1 to 128
'            if crew(cr).hp>0 and crew(cr).onship=0 then
'                total+=1
'                value=value+crew(cr).talents(ta)
'                if ta=24 then value=value+crew(cr).augment(4) 'Speed
'            endif
'        next
'        if total=0 then return 0
'        value=value/total
'        return value
'    endif
'    return 0
'end function



function check_passenger(st as short) as short
    dim as short b,t,price
    dim as _crewmember cr
    dim as string heshe(1)
    heshe(0)="She"
    heshe(1)="He"
    for b=2 to 255
        if crew(b).target<>0 then
            if crew(b).target=st+1 then
                if crew(b).typ>30 then 
                    questguy(crew(b).typ-30).location=st
                    if questguy(crew(b).typ-30).has.type=qt_travel then questguy(crew(b).typ-30).has.given=1 
                    if questguy(crew(b).typ-30).want.type=qt_travel then questguy(crew(b).typ-30).want.given=1 
                endif
                t=(crew(b).time-tVersion.gameturn)/(60*24)
                price=crew(b).price+crew(b).bonus*t
                if price<0 then price=10
                if t>0 then rlprint crew(b).n &" is very happy that " &lcase(heshe(crew(b).story(10)))& " arrived early.",c_gre
                if t=0 then rlprint crew(b).n &" is happy to have arrived on time."
                if t<0 then rlprint crew(b).n &" isn't happy at all that " &lcase(heshe(crew(b).story(10)))& " arrived too late.",c_yel
                addmoney(price,mt_quest2)
                rlprint heshe(crew(b).story(10)) &" pays you "&credits(price) &" Cr.",c_gre
                crew(b)=cr
            else
                crew(b).morale-=10
                t=crew(b).time-tVersion.gameturn
                if t<0 then crew(b).morale+=t
                if rnd_range(1,100)<10 then
                    if t<0 then rlprint crew(b).n &" reminds you that " &lcase(heshe(crew(b).story(10)))& " should have been at station "&crew(b).target & " by "&display_time(crew(b).time) &"."
                    if t>0 then rlprint crew(b).n &" reminds you that " &lcase(heshe(crew(b).story(10)))& " should be at station "&crew(b).target & " by turn "&display_time(crew(b).time) &"."
                endif
            endif
        endif
    next
    return 0
end function


function gain_talent(slot as short,talent as short=0) as string
    dim text as string
    dim roll as short
    ' roll for talent
    if talent=0 then
        roll=rnd_range(1,25)
    else
        roll=talent
    endif
    ' check if can have it
    if can_learn_skill(slot,roll) then
        if crew(slot).talents(roll)<3 then
            crew(slot).talents(roll)+=1
            text=text &crew(slot).n &" is now "& talent_desig(roll) &"("&crew(slot).talents(roll)&"). "
            if roll=20 then
                crew(slot).hpmax+=1
                crew(slot).hp+=1
            endif
        endif
    endif
    return text
end function


function find_crew_type(t as short) as short
    dim a as short
    for a=1 to 127
        if crew(a).typ=t then return a
    next
    return 1
end function


function levelup(p as _ship,from as short) as _ship
    dim a as short
    dim text as string
    dim roll as short
    dim secret as short
    dim target as short
    dim _del as _crewmember
    dim rolls(128) as short
    dim lev(128) as byte
    dim ret(46) as byte
    dim conret(46) as byte
    dim levt(46) as byte
    dim debug as byte=0
    if from=1 then rlprint "Entering training."
    for a=0 to 16
        levt(a)=0
        ret(a)=0
    next
    for a=1 to 128
        lev(a)=0
        if _showrolls=1 or debug=1 then crew(a).xp+=10
        if crew(a).hp>0 and (crew(a).typ>0 and crew(a).typ<8) or (crew(a).typ>=14 and crew(a).typ<=16) then
            roll=rnd_range(1,crew(a).xp)
            if crew(a).xp>0 and (roll+crew(a).augment(10)*2>5+crew(a).hp^2 or debug=1) then
                lev(a)+=1
                rolls(a)=crew(a).augment(10)*2+roll
            endif
            if from=0 then
                if a>1 then
                    if crew(a).hp>0 and crew(a).augment(11)=0 then
                        roll=rnd_range(1,100)
                        if roll>10+crew(a).morale+add_talent(1,4,10) then
                            ret(crew(a).typ)+=1
                            crew(a)=_del
                            lev(a)=0
                        endif
                        if roll>crew(a).morale+add_talent(1,4,10) and roll<=10+crew(a).morale+add_talent(1,4,10) then
                            conret(crew(a).typ)+=1
                        endif
                    endif
                endif
            endif
        endif
    next

    for a=1 to 46
        if ret(a)=1 then rlprint crew_desig(a)&" "&crew(a).n &" retired. ",12
        if ret(a)>1 then rlprint ret(a) &" "&crew_desig(a)&"s retired. ",12
        if conret(a)=1 then rlprint crew_desig(a)&" "&crew(a).n &" considered retiring but had a change of mind. ",14
        if conret(a)>1 then rlprint ret(a) &" "&crew_desig(a)&"s considered retiring but changed their minds. ",14
        if ret(a)=1 and a>=30 then rlprint "Your passenger " &crew(a).n & "decided to find another ship."
        if ret(a)>1 and a>=30 then rlprint a &" of your passengers decided to find another ship."
    next
    for a=1 to 128
        if _showrolls=1 then text=text &crew(a).n &"Rolled "&rolls(a) &", needed"& 5+crew(a).hp^2

        if crew(a).hp>0 and lev(a)=1 then
            levt(crew(a).typ)+=1
            select case crew(a).typ
            case 2 to 5
                crew(a).baseskill(crew(a).typ-2)+=1
            case 6,7
                crew(a).typ+=1
                if rnd_range(1,100)<crew(a).xp*3 then text=text &gain_talent(a)
            end select
            crew(a).hpmax+=1
            crew(a).hp=crew(a).hpmax
            crew(a).xp=0

        endif
    next
    for a=1 to 16
        if levt(a)=1 then text=text &crew_desig(a)&" "&crew(find_crew_type(a)).n &" got promoted. "
        if levt(a)>1 then text=text & levt(a) &" "&crew_desig(a)&"s got promoted. "
    next
    if text<>"" then rlprint text,10
    if text="" and from=1 then rlprint "Nobody got a promotion."
    display_ship()
    return p
end function


function remove_no_spacesuit(who() as short,last as short) as short
    dim as short i
    for i=1 to last
        crew(who(i)).oldonship=crew(who(i)).onship
        crew(who(i)).onship=4
    next
    return 0
end function

function remove_member(n as short, f as short) as short
    dim as short a,s,todo

    if f=0 then s=6
    if f=1 then s=2
    for a=128 to s step-1
        if crew(a).hp>0 and todo<n then
            crew(a).hp=0
            todo+=1
        endif
    next
    return 0
end function

function get_freecrewslot() as short
    dim as short b,slot

    DbgPrint(""&player.h_maxcrew &":"&player.crewpod &":"&player.cryo)
    for b=1 to (player.h_maxcrew+player.crewpod)*player.bunking+player.cryo
        if crew(b).hp<=0 then return b
    next
    if player.bunking=1 then
        if askyn("No room on the ship. Do you want to doublebunk?(y/n)") then
            player.bunking=2
            return get_freecrewslot()
        endif
    endif
    return -1
end function


function change_captain_appearance(x as short,y as short) as short
    dim as short a,n
    dim as string text,mf(1)
    mf(0)="Female"
    mf(1)="Male"
    do
        't="Age:"& 18+crew(i).story(6) &" Size: 1."& 60+crew(i).story(7)*4 &"m Weight:" &50+crew(i).story(8)*4+crew(i).story(7) &"kg. ||"

        text="Captain:/Name: "&crew(1).n &"/"
#if __FB_DEBUG__
        text=text &" s10:"&crew(1).story(10)
#endif
        text &= "Gender: "&mf(crew(1).story(10))&"/"
        text &= "Age: "&18+crew(1).story(6) &"/"
        text &= "Height: 1."&60+crew(1).story(7) &"/"
        text &= "Weight: "&50+crew(1).story(8)*4+crew(1).story(7) &"/"
        text &= "Change outfit/"
        if awayteam.helmet=0 then
            text &="close helmet/"
        else
            text &="open helmet/"
        endif
        text &= "Exit"
        put (x*_fw1-2-_tix,y*_fh1),gtiles(captain_sprite),trans
        a=menu(bg_noflip,text,"",x,y)
        select case a
        case 1
            rlprint ""
            crew(1).n=gettext(LocEOL.x,LocEOL.y,16,crew(1).n)
            rlprint "Are you male or female?(m/f)"
            no_key=keyin
            if lcase(no_key)="m" then
                crew(1).story(10)=0
            else
                crew(1).story(10)=1
            endif
        case 2
            crew(1).story(10)+=1
            if crew(1).story(10)>1 then crew(1).story(10)=0
        case 3
            rlprint "Age: "
            crew(1).story(6)=getnumber(18,120,20)-18
            'age
        case 4
            rlprint "Height in cm: "
            n=getnumber(100,300,180)
            n=n-160
            crew(1).story(7)=n
            'height
        case 5
            rlprint "Weight in kg: "
            n=getnumber(50,500,100)
            n=(n-50-crew(1).story(7))/4
            crew(1).story(8)=n
            'weight
        case 6
            crew(1).story(3)+=1
            if crew(1).story(3)>2 then crew(1).story(3)=0
        case 7
            if awayteam.helmet=1 then
                awayteam.helmet=0
            else
                awayteam.helmet=1
            endif
        end select
    loop until a=8 or a=-1
    return 0
end function



function sort_crew() as short
    dim as short a,f
    do
        f=0
        for a=player.h_maxcrew to 1  step -1
            if crew(a).hp<=0 and crew(a+1).hp>0 then
                f=1 
                swap crew(a),crew(a+1)
            endif
        next
    loop until f=0
    
    do
        f=0
        for a=player.h_maxcrew to 1 step -1
            if crew(a).hp>0 then
                if crew(a).typ>crew(a+1).typ and crew(a+1).hp>0 then
                    f=1
                    swap crew(a),crew(a+1)
                endif
            endif
        next
    loop until f=0
    do
        f=0
        for a=0 to 127
            if crew(a).talents(27)>crew(a+1).talents(27) and crew(a).hp>0 and crew(a+1).hp>0 then
                f=1
                swap crew(a),crew(a+1)
            endif
        next
    loop until f=0
    do
        f=0
        for a=0 to 127
            if crew(a).talents(28)>crew(a+1).talents(28) and crew(a).hp>0 and crew(a+1).hp>0 then
                f=1
                swap crew(a),crew(a+1)
            endif
        next
    loop until f=0
    do
        f=0
        for a=0 to 127
            if crew(a).talents(29)>crew(a+1).talents(29) and crew(a).hp>0 and crew(a+1).hp>0 then
                f=1
                swap crew(a),crew(a+1)
            endif
        next
    loop until f=0

    return 0
end function


function add_member(a as short,skill as short) as short
    dim as short slot,b,f,c,cc,nameno,i,cat,j,turret,rask,changeap
    dim as string text,help
    dim _del as _crewmember
    dim as string n(200,1)
    dim as short ln(1)
    
    f=freefile
    open "data/crewnames.txt" for input as #f
    do
        ln(cc)+=1
        line input #f,n(ln(cc),cc)
        if n(ln(cc),cc)="####" then
            ln(0)-=1
            cc=1
        endif

    loop until eof(f) or ln(0)>=199 or ln(1)>=199
    close #f
    'find empty slot
    slot=get_freecrewslot
    if slot<0 then
        if askyn("No room on the ship, do you want to replace someone?(y/n)") then
            slot=showteam(0,1,"Replace who?")
        endif
    endif
    DbgPrint(""&slot)
    if slot<0 then return -1
    if slot>=0 then

        crew(slot)=_del
        crew(slot).baseskill(0)=-5
        crew(slot).baseskill(1)=-5
        crew(slot).baseskill(2)=-5
        crew(slot).baseskill(3)=-5
        for b=0 to 10
            crew(slot).story(b)=rnd_range(1,10)
        next
        'crew(slot).story(9)=rnd_range(1,3)
        crew(slot).story(3)=configflag(con_captainsprite)
        crew(slot).story(10)=rnd_range(0,1)
        crew(slot).n=character_name(crew(slot).story(10)) '0 female 1 male
'        nameno=(rnd_range(1,ln(1)))
'        if nameno<=23 then
'            'female
'            crew(slot).story(10)=0
'        else
'            'male
'            crew(slot).story(10)=1
'        endif
'
'        if rnd_range(1,100)<80 then
'            crew(slot).n=n(nameno,1)&" "&n((rnd_range(1,ln(0))),0)
'        else
'            crew(slot).n=n(nameno,1)&" "&CHR(rnd_range(65,87))&". "&n((rnd_range(1,ln(0))),0)
'        endif
        crew(slot).morale=100+(Wage-10)^3*(5/100)
        'crew(slot).talents(rnd_range(1,25))=1
        'crew(slot).talents(rnd_range(1,25))=1
        'crew(slot).talents(rnd_range(1,25))=1
        'crew(slot).disease=rnd_range(1,17)

        if a=1 then 'captain

            crew(slot).hpmax=6
            crew(slot).hp=6
            crew(slot).icon="C"
            crew(slot).typ=1
            crew(slot).baseskill(0)=captainskill
            crew(slot).baseskill(1)=captainskill
            crew(slot).baseskill(2)=captainskill
            crew(slot).baseskill(3)=captainskill
            crew(slot).atcost=6
            cat=2
            if equipment_value<1150 then cat+=1
            if player.h_no=2 then cat+=1
            do
                help=""
                if cat>1 then
                    text="Captain("& player.h_sdesc &") "&crew(slot).n & "s talents (" &cat &")"
                else
                    text="Captain("& player.h_sdesc &") " &crew(slot).n & "s talent (" &cat &")"
                endif
                text=text &"/No talent, +100 Cr."
                help=help &"/Start with "& player.money+100 &" Cr. instead of 500||" &list_inventory
                text=text &"/Additional talent, -100 Cr."
                help=help &"/Start with "& player.money-100 &" Cr. instead of 500. Choose one more starting talent||"&list_inventory
                text=text &"/2 Spacesuits"
                help=help &"/Start with 2 standard issue spacesuits||"&list_inventory
                text=text &"/Tribble"
                help=help &"/Start with a pet tribble||"&list_inventory
                text=text &"/Additional random items"
                help=help &"/Start with two more random items||"&list_inventory
                text=text &"/Energy weapon"
                if startingweapon=1 then text=text &"(x)"
                help=help &"/Start with an energy weapon for your ship.|(If you change your mind just select this option again)||"&list_inventory
                if startingweapon=1 then help=help &"|currently selected"
                text=text &"/Missile weapon"
                if startingweapon=2 then text=text &"(x)"
                if startingweapon=2 then help=help &"|currently selected"
                help=help &"/Start with a missile weapon for your ship.|(If you change your mind just select this option again)||"&list_inventory
                if player.cursed=0 then
                    text=text &"/Junk ship"
                    help=help &"/Your starting ship is in need of an overhaul. +1 points"
                else
                    text=text &"/Decent ship"
                    help=help &"/Your starting ship is in good condition."
                endif
                for i=1 to 6
                    text=text &"/"&talent_desig(i)&"("&crew(slot).talents(i)&")"
                    help=help &"/"&talent_desc(i)&"|(2 pts.)||"&list_inventory
                    'help=help &"Ship:"&player.h_sdesc

                next
                for i=20 to 26
                    text=text &"/"&talent_desig(i)&"("&crew(slot).talents(i)&")"
                    help=help &"/"&talent_desc(i)&"|(2 pts.)||"&list_inventory
                    'help=help &"Ship:"&player.h_sdesc
                next
                turret=-2
                rask=22
                changeap=23
                if player.h_no=2 then
                    turret=22
                    rask=23
                    changeap=24                    
                    text=text &"/Additional module(3 pts.)"
                    help=help &"/Pay 3 pts for a module for your fighter ship."
                endif
                text=text &"/Random"
                help=help &"/Choose one talent at random (1 pt.)"
                text=text &"/Change captain details"
                help=help &"/Change the appearance and bio details of your captain"
                
                i=menu(bg_randompictxt,text,help)
                if i=rask then
                    do
                        i=rnd_range(8,rask-1)
                        j=i-7
                        if j>6 then j+=13
                    loop until crew(1).talents(j)<=3
                    cat+=1
                endif
                select case i
                case 1,-1
                    addmoney(100,mt_startcash)
                    cat-=1
                    rlprint "Additional money: +100 Cr."
                case 2
                    if player.money>=100 then
                        addmoney(-100,mt_startcash)
                        cat+=1
                        rlprint "Less money: -100 Cr."
                    endif
                case 3
                    cat-=1
                    for j=1 to 2
                        placeitem(make_item(320),0,0,0,0,-1)
                    next
                    rlprint "Item: 2 Spacesuits"
                case 4
                    placeitem(make_item(250),0,0,0,0,-1)
                    cat-=1
                    rlprint "Item: A tribble"
                case 5
                    for j=1 to 2
                        if rnd_range(1,100)<50 then
                            item(lastitem+1)=rnd_item(RI_WeakStuff)
                        else
                            item(lastitem+1)=rnd_item(RI_WeakWeapons)
                        endif

                        rlprint "Item: "&add_a_or_an(item(lastitem+1).desig,1)
                        placeitem(item(lastitem+1),0,0,0,0,-1)
                        item(lastitem+1)=item(lastitem+2)
                    next
                    cat-=1
                case 6
                    select case startingweapon
                    case 0
                        startingweapon=1
                        cat-=1
                    case 1
                        startingweapon=0
                        cat+=1
                    case 2
                        startingweapon=1
                    end select
                    rlprint "Guaranteed energy weapon"
                case 7
                    select case startingweapon
                    case 0
                        startingweapon=2
                        cat-=1
                    case 1
                        startingweapon=2
                    case 2
                        startingweapon=0
                        cat+=1
                    end select
                    rlprint "Guaranteed missile weapon"
                case 8
                    if player.cursed=1 then
                        cat-=1
                        player.cursed=0
                        rlprint "Your ship is in decent condition"
                    else
                        cat+=1
                        player.cursed=1
                        rlprint "Your ship is in need of repair and servicing"
                    endif
                case turret
                    
                    if cat>=3 then
                        player.weapons(2)=starting_turret
                        if player.weapons(2).made<>0 then cat-=3
                    endif
                case changeap
                    change_captain_appearance(20,2)
                case else
                    if cat>=2 then 
                        j=i-8
    
                        if j>6 then j+=13
                        if crew(slot).talents(j)<3 then
                            rlprint gain_talent(slot,j)
                            cat-=2
                        endif
                    endif
                end select

            loop until cat=0


        endif
        if a=2 then 'Pilot
            crew(slot).hpmax=skill+1
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="P"
            crew(slot).typ=2
            crew(slot).paymod=skill^2*10
            crew(slot).baseskill(0)=skill
            crew(slot).atcost=8-skill
        endif
        if a=3 then 'Gunner
            crew(slot).hpmax=skill+1
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="G"
            crew(slot).typ=3
            crew(slot).paymod=skill^2*10
            crew(slot).baseskill(1)=skill
            crew(slot).atcost=5-skill
        endif
        if a=4 then 'SO
            crew(slot).hpmax=skill+1
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="S"
            crew(slot).typ=4
            crew(slot).paymod=skill^2*10
            crew(slot).baseskill(2)=skill
            crew(slot).atcost=8-skill
        endif

        if a=5 then 'doctor
            crew(slot).hpmax=skill+1
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="D"
            crew(slot).typ=5
            crew(slot).paymod=skill^2*10
            crew(slot).baseskill(3)=skill
            crew(slot).atcost=8-skill
        endif

        if a=6 then 'green
            crew(slot).hpmax=2
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="@"
            crew(slot).typ=6
            crew(slot).paymod=10
            crew(slot).atcost=7
            'crew(slot).disease=rnd_range(1,16)
        endif

        if a=7 then 'vet
            crew(slot).hpmax=3
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="@"
            crew(slot).typ=7
            crew(slot).paymod=10
            crew(slot).atcost=6
        endif

        if a=8 then 'elite
            crew(slot).hpmax=4
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="@"
            crew(slot).typ=8
            crew(slot).paymod=10
            crew(slot).atcost=5
        endif

        if a=9 then 'insect warrior
            crew(slot).hpmax=5
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="I"
            crew(slot).typ=9
            crew(slot).paymod=10
            crew(slot).n=ucase(chr(rnd_range(97,122)))
            crew(slot).xp=-1
            for c=0 to rnd_range(1,6)+3
                crew(slot).n=crew(slot).n &chr(rnd_range(97,122))
            next
            crew(slot).morale=25000
            crew(slot).story(10)=2
            crew(slot).atcost=4
        endif

        if a=10 then 'cephalopod
            crew(slot).hpmax=6
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="Q"
            crew(slot).typ=10
            crew(slot).paymod=0
            crew(slot).xp=-1
            crew(slot).n=alienname(2)
            crew(slot).morale=25000
            crew(slot).augment(7)=1
            crew(slot).story(10)=2
            crew(slot).equips=2'Can use weapons and squidsuit
            if rnd_range(1,100)<15 then placeitem(make_item(123),0,0,0,0,-1)
            crew(slot).atcost=5
        endif

        if a=11 then
            crew(slot).equips=1
            crew(slot).hpmax=2
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="d"
            crew(slot).typ=11
            crew(slot).paymod=0
            crew(slot).n="Neodog"
            crew(slot).xp=-1
            crew(slot).morale=25000
            crew(slot).story(10)=2
            crew(slot).atcost=5
        endif

        if a=12 then
            crew(slot).equips=0
            crew(slot).hpmax=3
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="a"
            crew(slot).typ=12
            crew(slot).paymod=0
            crew(slot).n="Neoape"
            crew(slot).xp=-1
            crew(slot).morale=25000
            crew(slot).story(10)=2
            crew(slot).atcost=4
        endif

        if a=13 then
            crew(slot).equips=1
            crew(slot).hpmax=6
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="R"
            crew(slot).typ=13
            crew(slot).paymod=0
            crew(slot).n="Robot"
            crew(slot).xp=-1
            crew(slot).morale=25000
            crew(slot).augment(8)=1
            crew(slot).story(10)=2
            crew(slot).atcost=3
        endif

        if a=14 then 'SO
            crew(slot).hpmax=4
            crew(slot).hp=4
            crew(slot).hp=crew(4).hpmax
            crew(slot).icon="T"
            crew(slot).typ=4
            crew(slot).paymod=0
            crew(slot).n=alienname(1)
            crew(slot).xp=0
            crew(slot).disease=0
            crew(slot).baseskill(2)=3
            crew(slot).story(10)=2
            crew(slot).atcost=9
        endif

        if a=15 then
            crew(slot).typ=5
            crew(slot).icon="D"
            crew(slot).paymod=1
            crew(slot).hpmax=7
            crew(slot).hp=7
            crew(slot).n="Ted Rofes"
            crew(slot).xp=0
            crew(slot).baseskill(3)=6
            crew(slot).story(10)=1
            crew(slot).atcost=20
        endif


        if a=16 then 'green
            crew(slot).hpmax=2
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="L"
            crew(slot).typ=14
            crew(slot).talents(27)=1
            crew(slot).paymod=25
            crew(slot).atcost=4
        endif

        if a=17 then 'green
            crew(slot).hpmax=2
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="N"
            crew(slot).typ=15
            crew(slot).talents(28)=1
            crew(slot).paymod=25
            crew(slot).atcost=12
        endif

        if a=18 then 'green
            crew(slot).hpmax=2
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="M"
            crew(slot).typ=16
            crew(slot).talents(29)=1
            crew(slot).paymod=20
            crew(slot).atcost=6
        endif
        
        
        if a=19 then 'squatter
            crew(slot).hpmax=1   
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="@"
            crew(slot).typ=6
            crew(slot).paymod=5
            crew(slot).atcost=8
            crew(slot).morale=150
            'crew(slot).disease=rnd_range(1,16)
        endif
        
        crew(slot).hp=crew(slot).hpmax
        if crew(slot).story(10)<2 then 'Is human
            crew(slot).story(9)=-1
            if slot>1 and rnd_range(1,100)<15 then crew(slot).story(9)=rnd_range(1,3) 'Girfriend
        endif
        'crew(slot).morale=rnd_range(1,5)
        if slot>1 and rnd_range(1,100)<=33 then n(200,1)=gain_talent(slot)
        'if slot=1 and rnd_range(1,100)<=50 then n(200,1)=gaintalent(slot)
        if crew(slot).atcost<=0 then crew(slot).atcost=1
    endif
    sort_crew()
    return 0
end function


function girlfriends(st as short) as short
    dim hisher(1) as string
    dim as short a,gf,whogf,mr,whomr
    hisher(0)=" her "
    hisher(1)=" his "
    for a=0 to 128
        if crew(a).hp>0 and crew(a).story(10)<2 then
            'if crew(a).story(9)>0 and crew(a).story(9)<>st+1 and crew(a).story(9)<>st+3 then crew(a).morale-=1
            if crew(a).story(9)=st+1 then
                gf+=1
                whogf=a
                crew(a).morale+=2
            endif
            if crew(a).story(9)=st+3 then
                mr+=1
                whomr=a
                crew(a).morale+=5
            endif
            if crew(a).story(9)=0 then
                if rnd_range(1,100)<15 then crew(a).story(9)=st+1
            else
                if rnd_range(1,100)<5 then crew(a).story(9)=0
                if rnd_range(1,100)<5 and crew(a).story(9)<=3 then crew(a).story(9)+=3
            endif
        endif
    next
    if gf=1 then rlprint crew(whogf).n &" is very happy to see" & hisher(crew(whogf).story(10)) & "girlfriend/boyfriend"
    if gf>1 then rlprint gf &" crewmebers are very happy to see their girlfriends/boyfriends"
    if mr=1 then rlprint crew(whomr).n &" is very happy to see" & hisher(crew(whomr).story(10)) & "wife/husband"
    if mr>1 then rlprint mr &" crewmebers are very happy to see their wifes/husbands"
    return 0
end function


function hiring(st as short,byref hiringpool as short,hp as short) as short
    dim as short b,c,d,e,officers,maxsec,neodog,robots,w,skill
    dim as integer f,g,meni(18),ex,cwage(18)
    dim as string text,help,cname(18)
    
    tScreen.set(1)

    cname(2)="Pilot"
    cname(3)="Gunner"
    cname(4)="Science Officer"
    cname(5)="Doctor"

    cname(6)="Security"

    cname(11)="Neodog"
    cwage(11)=50
    cname(12)="Neoape"
    cwage(12)=75
    cname(13)="Robot"
    cwage(13)=150

    cname(16)="Squadleader"
    cname(17)="Sniper"
    cname(18)="Paramedic"

    cwage(6)=wage
    cwage(16)=wage*2
    cwage(17)=wage*2
    cwage(18)=wage*2

    meni(1)=2
    meni(2)=3
    meni(3)=4
    meni(4)=5
    meni(5)=6
    meni(6)=16
    meni(7)=17
    meni(8)=18

    ex=8
    text="Hiring/ Pilot/ Gunner/ Science Officer/ Ships Doctor/ Security/ Squad Leader/ Sniper/ Paramedic/"
    help="Nil/Responsible for steering your ship/Fires your weapons and coordinates security team attacks/Operates sensors and collects biodata/Heals injuries and sickness/Your basic grunt/Coordinates the attacks of up to 5 security team members/An excellent marksman/Not worth much in combat, but assists the ships doctor"
    if basis(st).repname="Omega Bioengineering" and player.questflag(1)=3 then neodog=1
    if basis(st).repname="Smith Heavy Industries" and player.questflag(9)=3 then robots=1
    if neodog=1 then
        ex+=1
        meni(ex)=11
        ex+=1
        meni(ex)=12
        text=text & " Neodog/ Neoape/"
        help=help &"/A genetically engeniered lifeform with the basis of a dog/A genetically engeniered lifeform with the basis of a ape"

    endif
    if robots=1 then
        ex+=1
        meni(ex)=13
        text=text & " Robot/"
        help=help &"/Smith Heavy Industries managed to rebuild the robots of the old ones. They aren't as tough as the originals, but formidable killing machines nonetheless"
    endif
    ex+=1
    meni(ex)=101
    ex+=1
    meni(ex)=102
    ex+=1
    meni(ex)=103
    ex+=1

    text=text & " Set Wage/Fire/Train/Exit"
    help=help & " /Set base wage for your crew/Let a crew member go/Try for another promotion"
    cls

    do
        b=menu(bg_shiptxt,text,help)
        if b>0 and b<ex then
            if meni(b)<=5 then 'hire Officer
                select case rnd_range(1,150)
                case is <=50
                    skill=1
                case 51 to 90
                    skill=2
                case 91 to 120
                    skill=3
                case 121 to 140
                    skill=4
                case 141 to 150
                    skill=5
                end select
                if askyn(cname(meni(b))&", Skill:" & skill &" Wage per mission: " & skill*skill*Wage &") hire? (y/n)") then
                    if paystuff(skill*skill*Wage) then
                        hiringpool+=add_member(meni(b),skill)
                    endif
                endif
            endif

            if meni(b)>5 and meni(b)<=18 then 'Hire Crewmember
                maxsec=total_bunks()
                if max_security>0 then
                    rlprint "No. of " &cname(meni(b))& " to hire. (Max: "& minimum(maxsec,fix(player.money/cwage(meni(b))))&","&max_security & " with double bunking)"
                    c=getnumber(0,maxsec*2,0)
                    if c>0 then
                        if paystuff(c*cwage(meni(b))) then
                            for d=1 to c
                                hiringpool-=1
                                if add_member(meni(b),0)<>0 then exit for
                            next
                        endif
                    endif
                else
                    rlprint "You don't have enough room to hire additional crew.",c_yel
                endif
            endif

            if meni(b)=101 then
                rlprint "Set standard wage from "&Wage &" to:"
                w=getnumber(1,20,Wage)
                if w>0 then Wage=w
                f=0
                for g=2 to 128
                    if Crew(g).paymod>0 and crew(g).hpmax>0 and crew(g).hp>0 then f=f+Wage*Crew(g).paymod
                next
                cwage(6)=wage
                cwage(16)=wage*2
                cwage(17)=wage*2
                cwage(18)=wage*2

                rlprint "Set to " &Wage &"Cr. Your crew now gets a total of "&f &" Cr. in wages"
            endif

            if meni(b)=102 then
                'fire
                g=showteam(0,1,"Who do you want to dismiss?")
                if g>1 then
                    if askyn("Do you really want to dismiss "&crew(g).n &"?(y/n)") then
                        for f=g to 127
                            crew(f)=crew(f+1)
                        next
                        crew(128)=crew(0)
                    endif
                endif
            endif

            if meni(b)=103 then
                'Training
                f=0
                for g=2 to 128
                    if Crew(g).paymod>0 and crew(g).hpmax>0 and crew(g).hp>0 then f=f+Wage*Crew(g).paymod
                next
                f=f/2
                if askyn("Training will cost "&f &" credits.(y/n)") then
                    if paystuff(f) then
                        player=levelup(player,1)
                    endif
                endif
            endif

        endif
    loop until b=ex or b=-1


'        do
'            officers=1
'            if player.pilot(0)>0 then officers=officers+1
'            if player.gunner(0)>0 then officers=officers+1
'            if player.science(0)>0 then officers=officers+1
'            if player.doctor(0)>0 then officers=officers+1
'
'            displayship()
'            b=menu(text,help)
'
'            d=rnd_range(1,100)
'            c=5
'            if d<90 then c=4
'            if d<75 then c=3
'            if d<60 then c=2
'            if d<40 then c=1
'            if c<1 then c=1
'            e=((player.pilot(0)+player.gunner(0)+player.science(0)+player.doctor(0))/4)+1
'            if e<=0 then e=2
'            if c>e then c=e+rnd_range(0,2)-1
'            if c<=0 then c=2
'            if b<5 and hiringpool>0 then
'                if b=1 then
'                    if askyn("Pilot, Skill:" & c &" Wage per mission: "& c*c*Wage &" (Current skill:"&player.pilot(0) &") hire? (y/n)") then
'                        if player.money>=c*c*Wage then
'                            player.money=player.money-c*c*Wage
'                            if addmember(2,c)<>0 then exit for
'                        else
'                            rlprint "Not enough money for first wage."
'                        endif
'                    endif
'                endif
'                if b=2 then
'                    if askyn("Gunner, Skill:" & c &" Wage per mission: " & c*c*Wage & " (Current skill:"&player.gunner(0) &") hire? (y/n)") then
'                        if player.money>=c*c*Wage then
'                            player.money=player.money-c*c*Wage
'                            if addmember(3,c)<>0 then exit for
'                        else
'                            rlprint "Not enough money for first wage."
'                        endif
'                    endif
'                endif
'                if b=3 then
'                    if askyn("Science officer, Skill:" & c &" Wage per mission: " &c*c*Wage &" (Current skill:"&player.science(0) &") hire? (y/n)") then
'                        if player.money>=c*c*Wage then
'                            player.money=player.money-c*c*Wage
'                            if addmember(4,c)<>0 then exit for
'                        else
'                           rlprint "Not enough money for first wage."
'                        endif
'                    endif
'                endif
'                if b=4 then
'                    if askyn("Ships doctor, Skill:" & c &" Wage per mission: " &c*c*Wage &" (Current skill:"&player.doctor(0) &") hire? (y/n)") then
'                        if player.money>=c*c*Wage then
'                            player.money=player.money-c*c*Wage
'                            if addmember(5,c)<>0 then exit for
'                        else
'                           rlprint "Not enough money for first wage."
'                        endif
'                    endif
'                endif
'                hiringpool=hiringpool-1
'            else
'                if b<5 then rlprint "Nobody availiable for the position. try again later."
'            endif
'            if b=5 then
'                maxsec=maxsecurity()
'                rlprint "No. of security personel to hire. (Max: "& minimum(maxsec,fix(player.money/wage))&")"
'                c=getnumber(0,maxsec*2,0)
'                if c>0 then
'                if player.money<c*Wage then
'                    rlprint "Not enough money for first wage."
'                else
'                    for d=1 to c
'                        if addmember(6,0)<>0 then exit for
'                    next
'                    player.money=player.money-c*Wage
'                endif
'                endif
'            endif
'
'            if b=6 then 'Squad leader
'                maxsec=maxsecurity()
'                rlprint "No. of squad leaders to hire. (Max: "& minimum(maxsec,fix(player.money/wage))&")"
'                c=getnumber(0,maxsec*2,0)
'                if maxsec>0 then
'                    if player.money<wage*2*c then
'                        rlprint "Not enough money for first wage."
'                    else
'                        for d=1 to c
'                            player.money-=wage*2
'                            if addmember(16,0)<>0 then exit for
'                        next
'                    endif
'                endif
'            endif
'
'            if b=7 then 'Sniper
'                maxsec=maxsecurity()
'                rlprint "No. of snipers to hire. (Max: "& minimum(maxsec,fix(player.money/wage))&")"
'                c=getnumber(0,maxsec*2,0)
'                if maxsec>0 then
'                    if player.money<wage*2*c then
'                        rlprint "Not enough money for first wage."
'                    else
'                        for d=1 to c
'                            hiringpool-=1
'                            player.money-=wage*2
'                            if addmember(17,0)<>0 then exit for
'                        next
'                    endif
'                endif
'            endif
'
'            if b=8 then 'Paramedic
'                maxsec=maxsecurity()
'                rlprint "No. of paramedics to hire. (Max: "& minimum(maxsec,fix(player.money/wage))&")"
'                c=getnumber(0,maxsec*2,0)
'                if maxsec>0 then
'                    if player.money<wage*2*c then
'                        rlprint "Not enough money for first wage."
'                    else
'                        for d=1 to c
'                            player.money-=wage*2
'                            if addmember(18,0)<>0 then exit for
'                        next
'                    endif
'                endif
'            endif
'
'
'            if neodog=1 then
'                if b=9 then
'                    maxsec=maxsecurity()
'                    rlprint "How many Neodogs do you want to buy? (Max: "& minimum(maxsec,fix(player.money/50))&")"
'                    c=getnumber(0,maxsec*2,0)
'                    if c>0 then
'                        if player.money<c*50 then
'                            rlprint "Not enough Credits."
'                        else
'                            rlprint "you buy "&c &" Neodogs."
'                            for d=1 to c
'                                if addmember(11,0)<>0 then exit for
'                            next
'                            player.money=player.money-c*50
'                        endif
'                    endif
'                endif
'
'                if b=10 then
'                    maxsec=maxsecurity()
'                    rlprint "How many Neoapes do you want to buy? (Max: "& minimum(maxsec,fix(player.money/75))&")"
'                    c=getnumber(0,maxsec*2,0)
'                    if c>0 then
'                        if player.money<c*75 then
'                            rlprint "Not enough Credits."
'                        else
'                            rlprint "you buy "&c &" Neoapes."
'                            for d=1 to c
'                                if addmember(12,0)<>0 then exit for
'                            next
'                            player.money=player.money-c*75
'                        endif
'                    endif
'                endif
'            endif
'
'            if b=9 and robots=1 then
'                maxsec=maxsecurity()
'                rlprint "How many Robots do you want to buy? (Max: "& minimum(maxsec,fix(player.money/150))&")"
'                c=getnumber(0,maxsec*2,0)
'                if c>0 then
'                    if player.money<c*150 then
'                        rlprint "Not enough Credits."
'                    else
'                        rlprint "you buy "&c &" Robots."
'                        for d=1 to c
'                            if addmember(13,0)<>0 then exit for
'                        next
'                        player.money=player.money-c*150
'                    endif
'                endif
'            endif
'
'            if (neodog=0 and robots=0 and b=9) or (neodog=1 and b=11) or (robots=1 and b=10) then
'                rlprint "Set standard wage from "&Wage &" to:"
'                w=getnumber(1,20,Wage)
'                if w>0 then Wage=w
'                f=0
'                for g=2 to 128
'                    if Crew(g).paymod>0 and crew(g).hpmax>0 and crew(g).hp>0 then f=f+Wage*Crew(g).paymod
'                next
'                rlprint "Set to " &Wage &"Cr. Your crew now gets a total of "&f &" Cr. in wages"
'            endif
'            if (neodog=0 and robots=0 and b=10) or (neodog=1 and b=12) or (robots=1 and b=11) then
'                'fire
'                g=showteam(0,1,"Who do you want to dismiss?")
'                if g>1 then
'                    if askyn("Do you really want to dismiss "&crew(g).n &".") then
'                        for f=g to 127
'                            crew(f)=crew(f+1)
'                        next
'                        crew(128)=crew(0)
'                    endif
'                endif
'
'            endif
'            if (neodog=0 and robots=0 and b=11) or (neodog=1 and b=13) or (robots=1 and b=12) then
'                'Training
'                f=0
'                for g=2 to 128
'                    if Crew(g).paymod>0 and crew(g).hpmax>0 and crew(g).hp>0 then f=f+Wage*Crew(g).paymod
'                next
'                f=f/2
'                if askyn("Training will cost "&f &" credits.(y/n)") then
'                    if player.money>=f then
'                        player.money-=f
'                        player=levelup(player,1)
'                    endif
'                endif
'
'            endif
'
'        loop until (neodog=0 and robots=0 and b=12) or (neodog=1 and b=14) or (robots=1 and b=13)
    return 0
end function



