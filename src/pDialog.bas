'tDialog.
'
'defines:
'load_dialog_quests=1, load_dialog=1, update_questguy_dialog=0,
', questguy_message=0, adapt_nodetext=0, add_passenger=2, dialog_effekt=0,
', node_menu=0, do_dialog=14
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
'     -=-=-=-=-=-=-=- TEST: tDialog -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Type _dialogoption
    no As UShort
    answer As String
End Type

Type _dialognode
    no As UShort
    statement As String
    effekt As String
    param(5) As Short
    Option(16) As _dialogoption
End Type
#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tDialog -=-=-=-=-=-=-=-

declare function questguy_dialog(i as short) as short

declare function load_dialog_quests() as short
declare function load_dialog(fn as string, n() as _dialognode) as short
declare function add_passenger(n as string,typ as short, price as short, bonus as short, target as short, sTime as short, gender as short) as short
declare function do_dialog(no as short,e as _monster, fl as short) as short

'private function update_questguy_dialog(i as short,node() as _dialognode,iteration as short) as short
'private function questguy_message(c as short) as short
'private function adapt_nodetext(t as string, e as _monster,fl as short,qgindex as short=0) as string
'private function dialog_effekt(effekt as string,p() as short,e as _monster, fl as short) as short
'private function node_menu(no as short,node() as _dialognode,e as _monster, fl as short,qgindex as short=0) as short
'private function questguy_dialog(i as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tDialog -=-=-=-=-=-=-=-

namespace tDialog
function init() as Integer
	return 0
end function
end namespace'tDialog


function load_dialog_quests() as short
    dim as integer f
    dim as short i,j,g
    dim as string l,w(3)

    if tFile.Openinput("data/dialogquests.csv",f)>0 then 
	    do
	        i+=1
	        for j=0 to 2
	            for g=0 to 3
	                w(g)=""
	            next
	            line input #f,l
	            string_towords(w(),l,";")
	
	            questguydialog(i,j,Q_WANT)=w(1)
	            questguydialog(i,j,Q_HAS)=w(2)
	            questguydialog(i,j,Q_ANSWER)=w(3)
	        next
	
	    loop until eof(f)
	    tFile.Closefile(f)
    EndIf
    
    if tFile.Openinput("data/dialogquests2.csv",f)>0 then 
	    i=0
	    do
	        w(0)=""
	        w(1)=""
	        w(2)=""
	        line input #f,l
	        string_towords(w(),l,";")
	        i+=1
	        questguyquestion(i,Q_WANT)=w(0)
	        questguyquestion(i,Q_HAS)=w(1)
	    loop until eof(f)
	    tFile.Closefile(f)
    EndIf
    return 0
end function


function load_dialog(fn as string, n() as _dialognode) as short
    dim as short f,i,j,g,node,answer
    dim l(1028) as string
    dim w(9) as string
    f=freefile
    open fn for input as #f
    while not eof(f)
        i+=1
        line input #f,l(i)
    wend
    close #f
    for j=1 to i
        for g=0 to 9
            w(g)=""
        next
        g=string_towords(w(),l(j),";")
        if w(0)<>"" then
            node=val(w(0))
            n(node).no=node
            n(node).statement=w(1)
            n(node).effekt=w(3)
            n(node).param(1)=val(w(4))
            n(node).param(2)=val(w(5))
            n(node).param(3)=val(w(6))
            n(node).param(4)=val(w(7))
            n(node).param(5)=val(w(8))
            answer=0
        else
            answer+=1
            n(node).option(answer).answer=w(1)
            n(node).option(answer).no=val(w(2))
        endif
    next
    return node
end function


function update_questguy_dialog(i as short,node() as _dialognode,iteration as short) as short
    DimDebug(0)'2
    dim as short j,jj,o
    dim as string himher(1),heshe(1)
    dim deletenode as _dialognode

    himher(1)="him"
    himher(0)="her"
    heshe(1)="he"
    heshe(0)="she"
    for j=1 to 64
        node(j).no=0
        node(j).statement=""
        for jj=0 to 5
            node(j).param(jj)=0
        next
        for jj=0 to 16
            node(j).option(jj).no=0
            node(j).option(jj).answer=""
        next
    next
    
    if questguy(i).talkedto=0 then questguy(i).talkedto=1
    
    if questguy(i).friendly(0)<0 then questguy(i).friendly(0)=0
    if questguy(i).friendly(0)>2 then questguy(i).friendly(0)=2
    node(1).statement=""
    if iteration=1 then
    select case questguy(i).friendly(0)
        case is=0
            node(1).statement=standardphrase(sp_greethostile,rnd_range(0,2))
        case is=1
            node(1).statement=standardphrase(sp_greetneutral,rnd_range(0,2))
        case is=2
            node(1).statement=standardphrase(sp_greetfriendly,rnd_range(0,2))
        end select
    endif
    
    o+=1
    node(1).option(o).answer="Who are you?"
    node(1).option(o).no=2
    
    if questguy(i).want.given=0 and questguy(i).want.type<>0 then
        o+=1
        node(1).option(o).answer="CODB"
        node(1).option(o).no=3
        if questguy(i).want.type=qt_outloan then 
            if has_questguy_want(i,j)>0  then
                select case questguy(i).want.type 
                case qt_outloan
                    node(1).option(o).answer=standardphrase(sp_gotmoney,rnd_range(0,2))
                    node(1).option(o).no=18
                    node(18).statement="Great! Thank you! Here are your "&questguy(i).want.motivation+1 &"0%."
                    node(18).effekt="ABGEBEN"
                    node(18).param(0)=j'Gets destroyed
                    node(18).param(1)=i
                case else
                    node(1).option(o).answer=questguyquestion(questguy(i).want.type,Q_WANT)
                end select
            else
                node(1).option(o).answer=questguyquestion(questguy(i).want.type,Q_WANT)
            endif
        else
            node(1).option(o).answer=questguyquestion(questguy(i).want.type,Q_WANT)
        endif
    endif
    
    if questguy(i).has.given=0 and questguy(i).has.type<>0 then
        o+=1
        node(1).option(o).answer=questguyquestion(questguy(i).has.type,Q_HAS)
        node(1).option(o).no=4
    endif
    
    o+=1
    node(1).option(o).answer="Do you know ...?"
    node(1).option(o).no=8
    
    
    if questguy(i).job=1 or (questguy(i).job>=4 and questguy(i).job<=6)_
        or (questguy(i).job>=10 and questguy(i).job<=13  and questguy(i).has.type<>qt_megacorp)_
        or questguy(i).job=14 then
        o+=1
        if questguy(i).job=1 then node(1).option(o).answer="Can I get access to the stations sensors?"
        if questguy(i).job=14 then node(1).option(o).answer="Can I have an autograph?"
        if questguy(i).job>=4 and questguy(i).job<=6 then node(1).option(o).answer="Do you want to compare notes with our " & questguyjob(questguy(i).job) & "?"
        if questguy(i).job>=10 and questguy(i).job<=13 then node(1).option(o).answer="Do you have any info on your company?"
        node(1).option(o).no=6
        node(6).effekt="GIVEJOBHAS"
        node(6).param(0)=i
    endif
    
    if  questguy(i).flag(7)=0 and (questguy(i).want.type=qt_drug or questguy(i).want.type=qt_anomaly or questguy(i).want.type=qt_biodata) and questguy(i).want.given=1 then
        o+=1
        node(1).option(o).answer="Have you gotten results with your research yet?"
        node(1).option(o).no=23
        node(23).effekt="SELLOTHER"
        node(23).param(1)=1010
        node(23).param(2)=i
        node(23).param(3)=0
        node(23).param(4)=1
    endif
        
    for j=1 to lastquestguy
'        if questguy(j).want.type=qt_heirloom and i=questguy(j).want.whohasit and questguy(j).talkedto>0 then
'            o+=1
'            node(1).option(o).answer="Do you have something for "&questguy(j).n &"?"
'            node(1).option(o).no=14
'            node(14).statement="yes, i do have "&questguy(j).want.it.desig
'            node(14).option(1).answer="Can I have it?"
'            node(14).option(1).no=15
'            node(14).option(2).answer="Is there something you want that I can swap for it?"
'            node(14).option(2).no=16
'            node(15).effekt="SELLOTHER"
'            node(15).param(0)=j
'            node(15).param(1)=questguy(j).want.motivation+1
'        endif
        if i=questguy(j).flag(1) and questguy(j).talkedto=2 then
            select case questguy(j).want.type
            case qt_outloan 
                o+=1
                node(1).option(o).answer=questguy(j).n &" says you owe "& himher(questguy(j).gender) &" money"
                node(1).option(o).no=30+o
                if questguy(i).money>=questguy(i).loan then
                    if questguy(i).loan>0 then
                        node(30+o).statement="Yes, I know. I just didn't find the time to give to " & himher(questguy(j).gender) & ". Can you give it to "& himher(questguy(j).gender) &"?"
                        node(30+o).effekt="EINTREIBEN"
                        node(30+o).param(0)=j
                        node(30+o).option(1).no=1
                    else
                        node(30+o).statement="I already paid that back in full!"
                        node(30+o).option(1).no=1
                    endif
                else
                    node(17).statement="Yes, I know, but I can't afford to pay back right now."
                endif
            case qt_research
                if questguy(i).has.type<>qt_research and (questguy(i).want.type<>qt_drug and questguy(i).want.type<>qt_biodata and questguy(i).want.type<>qt_anomaly) then 'Doesn't have a research paper
                    o+=1
                    node(1).option(o).answer=questguy(j).n &" says " & heshe(questguy(j).gender)& " could use your help for <HISHERS> research."
                    node(1).option(o).no=30+o
                    node(30+o).statement="I do have some notes on that subject."
                    node(30+o).effekt="SELLOTHER"
                    node(30+o).param(0)=i
                    node(30+o).param(1)=1010 'Make and sell Item 1010
                    node(30+o).param(2)=i 'Make and sell Item 1010
                    node(30+o).param(3)=0 'Make and sell Item 1010
                endif

            end select
            
        endif
    next
    
    if questguy(i).want.type<>0 and questguy(i).has.type<>0 and questguy(i).want.given=0 and questguy(i).has.given=0 then
        o+=1
        node(1).option(o).answer="Maybe we can do a trade?"
        node(1).option(o).no=18
        node(18).param(0)=i
        node(18).effekt="QGTRADE"
    endif
        
    if findbest(89,-1)>0 then
        o+=1
        node(1).option(o).answer="I have this crystal. Do you want to take a look at it?"
        node(1).option(o).no=22
    endif
    
    if questguy(i).job=14 then 'Entertainer
        o+=1
        node(1).option(o).answer="Maybe you could perform for my crew?"
        node(1).option(o).no=40
        if questguy(i).want.type=qt_showconcept and questguy(i).want.given=0 then 'Show concept
            node(40).statement="I would, but I have nothing new to perform. Nobody would enjoy it."
            node(40).option(1).no=1
        else
            node(40).effekt="CONCERT"
            node(40).param(0)=i
            node(40).param(1)=100-10*questguy(i).friendly(0)
        endif
    endif
    
    if questguy(i).flag(10)>0 then
        o+=1
        node(1).option(o).answer="Do you know anything about "&talent_desig(questguy(i).flag(10))&"?"
        node(1).option(o).no=41
        node(41).effekt="TEACHTALENT"
        node(41).param(0)=i
        if questguy(i).friendly(0)=2 then node(41).param(1)=200*haggle_("DOWN")
        if questguy(i).friendly(0)=1 then node(41).param(1)=500*haggle_("DOWN")
    endif
    
    o+=1
    node(1).option(o).answer="Let's have a drink."
    node(1).option(o).no=21
    o+=1
    if is_passenger(i) then
        node(1).option(o).answer="Let's get you to your destination." 
    else
        node(1).option(o).answer="Bye" 
    endif
#if __FB_DEBUG__
    node(1).option(o).answer &= o
#endif
    node(1).option(o).no=0
    
    node(2).statement="I am "&questguy(i).n &", "&add_a_or_an(questguyjob(questguy(i).job),0) &"."
    node(2).option(1).no=1
    node(2).effekt="FRIENDLYCHANGE"
    node(2).param(0)=10
    node(2).param(1)=i
    
    'Want side
    if questguy(i).want.given=0 then
        node(3).statement=questguydialog(questguy(i).want.type,questguy(i).want.motivation,Q_WANT)
        node(3).effekt="SELLWANT"
        node(3).param(0)=i
        node(3).param(1)=questguy(i).want.motivation+1
        node(3).option(1).no=1
        select case questguy(i).want.type
        case qt_megacorp
            node(3).param(2)=(questguy(i).want.motivation+1)*5
        case qt_stationsensor 
            node(3).param(2)=10*(questguy(i).want.motivation+1)
        case qt_autograph 
            node(24).effekt="KNOWOTHER"
            node(24).param(2)=questguy(i).flag(1)
            node(24).param(3)=50*(questguy(i).want.motivation+1)
            node(3).option(1).answer="Do you know where "&questguy(questguy(i).flag(1)).n &" is?"
            node(3).option(1).no=24
            node(3).option(2).answer="I see what I can do."
            node(3).option(2).no=1
        case qt_outloan
            node(24).effekt="KNOWOTHER"
            node(24).param(2)=questguy(i).flag(1)
            node(3).option(1).answer="Do you know where "&questguy(questguy(i).flag(1)).n &" is?"
            node(3).option(1).no=24
            node(3).option(2).answer="I see what I can do."
            node(3).option(2).no=1
        case qt_travel
            node(3).effekt="PASSENGER"
            questguy(i).flag(15)=(tVersion.gameturn+(rnd_range(45,65))*distance(player.c,basis(questguy(i).flag(2)).c))
        case qt_biodata 
            if reward(1)>0 then
                node(3).effekt="BUYBIODATA" 
                node(3).param(0)=i
                node(3).param(1)=1+questguy(i).want.motivation
            endif
        case qt_anomaly
            if ano_money>0 then
                node(3).effekt="BUYANOMALY"
                node(3).param(0)=i
                node(3).param(1)=1+questguy(i).want.motivation
            endif
        end select
    endif
    'Has side
    
    if questguy(i).has.given=0 then
        node(4).statement=questguydialog(questguy(i).has.type,questguy(i).has.motivation,Q_HAS)
        node(4).option(1).no=1
        if node(4).statement="" then node(4).statement= questguy(i).has.type &":"& questguy(i).has.motivation
        if questguy(i).has.type=qt_research or questguy(i).has.type=qt_juryrig or _
        questguy(i).has.type=qt_EI or questguy(i).has.type=qt_drug or _ 
        questguy(i).has.type=qt_souvenir or questguy(i).has.type=qt_tools or _
        questguy(i).has.type=qt_showconcept or questguy(i).has.type=qt_stationsensor then
            node(4).effekt="SELLHAS"
            node(4).param(0)=i
            node(4).param(1)=1+questguy(i).has.motivation
            node(4).option(1).no=1
        endif
        if questguy(i).has.type=qt_cargo then
            node(4).statement=questguydialog(questguy(i).has.type,questguy(i).has.motivation,Q_HAS)
            node(4).effekt="GIVECARGO"
            node(4).param(0)=i
            node(4).param(1)=100-10*questguy(i).friendly(0)
        endif
        
        if questguy(i).has.type=qt_travel then
            node(4).effekt="PASSENGER"
            node(4).param(0)=i
            questguy(i).flag(15)=(tVersion.gameturn+(rnd_range(45,65))*distance(player.c,basis(questguy(i).flag(2)).c))
            node(4).statement=questguydialog(questguy(i).has.type,questguy(i).has.motivation,Q_HAS)

        endif
        if questguy(i).has.type=qt_drug then
            node(4).effekt="SELLHAS"
            node(4).option(1).no=1
        endif
        if questguy(i).has.type=qt_tools then
            node(4).effekt="SELLHAS"
            node(4).param(0)=i
            node(4).option(1).no=1
        endif
        if questguy(i).has.type=qt_ei then
            node(4).effekt="SELLHAS"
            node(4).param(0)=i
            node(4).option(1).no=1
        endif
        if questguy(i).has.type=qt_megacorp then
            node(4).effekt="GIVEJOBHAS"
            node(4).param(0)=i
            node(4).option(1).no=1
        endif
        
        if questguy(i).has.type=qt_cursedship then
            node(4).effekt="BUYSHIP"
            node(4).param(0)=i
            node(4).param(1)=questguy(i).flag(9) 'Hulltype
            node(4).param(2)=questguy(i).has.motivation+2-(2-questguy(i).friendly(0))
        endif
        if questguy(i).has.type=qt_locofgarden or questguy(i).has.type=qt_locofspecial or questguy(i).has.type=qt_locofpirates then
            node(4).effekt="PAYWALL"
            
            if questguy(i).flag(3)=0 and questguy(i).has.type=qt_locofgarden then questguy(i).flag(3)=get_random_system(0,0,0,1)
            node(4).param(0)=questguy(i).flag(3)
            select case questguy(i).has.type
            case is=qt_locofgarden
                node(4).param(1)=6-questguy(i).friendly(0)*3
            case is=qt_locofspecial
                node(4).param(1)=100-questguy(i).friendly(0)*25
            case is=qt_locofpirates
                node(4).param(1)=50-questguy(i).friendly(0)*15
            end select
                
        endif
    endif
    
    'Do you know ....
    node(8).option(1).answer="Never mind"  'We must make the lastseen list nonrandom but factual.
    node(8).option(1).no=1
    jj=1
    for j=1 to lastquestguy
        if j<>i then 'He will always know himself
            if questguy(j).talkedto<>0 then
                jj+=1
                node(8).option(jj).answer=questguy(j).n
                if questguy(i).location=questguy(j).location then 
                    node(8).option(jj).no=14 
                else
                    if questguy(i).knows(j)<>0 then
                        if questguy(i).knows(j)>0 then
                            node(8).option(jj).no=10+questguy(i).knows(j)
                        else
                            node(8).option(jj).no=10
                        endif
                    else
                        node(8).option(jj).no=9
                    endif
                endif
            endif
        endif
    next
    node(9).statement="Sorry, don't know who that is."
    node(9).option(1).no=8
    node(10).statement="Last I saw that person on one of the small space stations."
    node(10).option(1).no=8
    node(11).statement="Last I saw that person on station 1"
    node(11).option(1).no=8
    node(12).statement="Last I saw that person on station 2"
    node(12).option(1).no=8
    node(13).statement="Last I saw that person on station 3"
    node(13).option(1).no=8
    node(14).statement="That person must be around here somewhere."
    node(14).option(1).no=8
    
    node(21).statement="Oh, thanks!"
    node(21).effekt="HAVEDRINK"
    node(21).param(0)=i
    node(21).option(1).no=1
    
    select case questguy(i).job
    case is=13 'Omega
        node(22).statement="Where did you get that from???"
        node(22).option(1).answer="Just found it"
        node(22).option(1).no=23
        node(22).option(2).answer="Tell the whole story"
        node(22).option(2).no=24
    case 4 or 15 'SO or Xenobiologist
        node(22).statement="Interesting, may I look at it?"
        node(22).option(1).answer="Yes"
        node(22).option(1).no=25
        node(25).statement="It seems to still have some of those properties that effect your perception. It's working like an illusion-filter!"
        node(25).option(1).no=1
        node(22).option(2).answer="No"
        node(22).option(2).no=1
    case else
        node(22).statement="Oh, that's pretty! But I don't know what to do with it."
        node(22).option(1).no=1
    end select
    if questguy(i).knows(questguy(i).flag(1))>0 then
        select case questguy(i).knows(questguy(i).flag(1))
        case 1,2,3
            select case rnd_range(1,100)
            case 1 to 33
                node(24).statement="Last I saw that person on Station "&questguy(i).knows(questguy(i).flag(1))&"."
            case 34 to 66
                node(24).statement="I think " & heshe(questguy(questguy(i).flag(1)).gender)& " is on Station "&questguy(i).knows(questguy(i).flag(1))&"."
            case else
                node(24).statement="I met " & questguy(questguy(i).flag(1)).n & " on Station "&questguy(i).knows(questguy(i).flag(1))&" recently."
            end select
        case else
            node(10).statement="Last I saw that person on one of the small space stations."
        end select
    else
        select case rnd_range(1,100)
        case 1 to 33
            node(24).statement="I honestly  don't know."
        case 34 to 66
            node(24).statement="I have no idea."
        case else
            node(24).statement="Sorry I can't help you with that."
        end select
    endif
    node(24).option(1).no=1
    return 0
end function


function questguy_message(c as short) as short
    dim as short i,d
    for i=0 to lastitem
        if item(i).ty=58 and item(i).w.s=-1 and item(i).v2=c then
            if askyn("Do you want to deliver the message?(y/n)") then
                d=rnd_range(1,6)*(1+questguy(item(i).v2).want.motivation)*haggle_("UP")
                rlprint "You get a "& d &" Cr. tip"
                addmoney(d,mt_quest2)
                destroyitem(i)
            endif
        endif
    next
    return 0
end function


function adapt_nodetext(t as string, e as _monster,fl as short,qgindex as short=0) as string
    dim word(128) as string
    dim stword(128) as string
    dim r as string
    dim as string himher(1),hishers(1),heshe(1),relative(8)
    relative(0)="brother"
    relative(1)="sister"
    relative(2)="father"
    relative(3)="mother"
    relative(4)="uncle"
    relative(5)="aunt"
    relative(6)="grandmother"
    relative(7)="grandfather"
    himher(0)="her"
    himher(1)="him"
    hishers(0)="hers"
    hishers(1)="his"
    heshe(0)="she"
    heshe(1)="he"
    dim as short l,i,j
    l=string_towords(stword(),t," ",0)
    for i=0 to l
        if instr(stword(i),">")>0 and instr(stword(i),">")<len(stword(i)) then
            word(j)=left(stword(i),instr(stword(i),">"))
            j+=1
            word(j)=right(stword(i),len(stword(i))-instr(stword(i),">"))
            j+=1
        else
            
            word(j)=stword(i)
            j+=1
        endif
    next
    j-=1
    for i=0 to j
        if word(i)="<SPLANET>" then word(i)=lcase(left(spdescr(questguy(qgindex).flag(4)),1))&right(spdescr(questguy(qgindex).flag(4)),len(spdescr(questguy(qgindex).flag(4)))-1)
        if word(i)="<OHIMHER>" then word(i)=himher(questguy(questguy(qgindex).flag(1)).gender)
        if word(i)="<8HIMHER>" then word(i)=himher(questguy(questguy(qgindex).flag(8)).gender)
        if word(i)="<OHESHE>" then word(i)=heshe(questguy(questguy(qgindex).flag(1)).gender)
        if word(i)="<OHISHERS>" then word(i)=hishers(questguy(questguy(qgindex).flag(1)).gender)
        if right(word(i),len(word(i))-1)="<CHAR>" then word(i)=questguy(questguy(qgindex).flag(val(word(i)))).n
        if word(i)="<OCHAR>" then word(i)=questguy(questguy(qgindex).flag(5)).n
        if word(i)="<GOAL>" then word(i)="station-"&fleet(fl).con(3)+1
        if word(i)="<FLEET>" then word(i)=""&abs(fl)
        if word(i)="<PLAYER>" then word(i)="captain "&crew(1).n &" of the "&player.desig
        if word(i)="<COORDS>" then 
            if fl>0 then 
                word(i)=fleet(fl).c.x &":"& fleet(fl).c.y
            else
                word(i)=drifting(abs(fl)).x &":"& drifting(abs(fl)).y
            endif
        endif
        if word(i)="<PCORDS>" then word(i)=cords(map(questguy(qgindex).flag(3)).c)&", orbit "& orbitfrommap(questguy(qgindex).flag(4))
        if word(i)="<#FL>" then word(i)=""&abs(fl)
        if word(i)="I-<#FL>" then word(i)="IS-"&abs(fl)
        if word(i)="<ITEMWDESC>" and qgindex>0 then word(i)=questguy(qgindex).want.it.ldesc
        if word(i)="<ITEMW>" and qgindex>0 then word(i)=questguy(qgindex).want.it.desig
        if word(i)="<ITEMH>" and qgindex>0 then word(i)=questguy(qgindex).has.it.desig
        if word(i)="<CHARACTER>" and qgindex>0 then word(i)=questguy(questguy(qgindex).flag(1)).n 
        if word(i)="<HESHE>" and qgindex>0 then word(i)=heshe(questguy(questguy(qgindex).flag(1)).gender)
        if word(i)="<HIMHER>" and qgindex>0 then word(i)=himher(questguy(questguy(qgindex).flag(1)).gender)
        if word(i)="<HISHERS>" and qgindex>0 then word(i)=hishers(questguy(questguy(qgindex).flag(1)).gender)
        if word(i)="<MONEY>" and qgindex>0 then word(i)=credits(questguy(questguy(qgindex).flag(1)).loan)
        if word(i)="<DRUG>" and qgindex>0 then
        endif
        if word(i)="<RELATIVE>" and qgindex>0 then word(i)=relative(questguy(qgindex).flag(2))
        if word(i)="<CORP>" and qgindex>0 then 
            if questguy(qgindex).flag(6)=0 then
                if questguy(qgindex).job-9>0 and questguy(qgindex).job-9<=4 then word(i)=companyname(questguy(qgindex).job-9) 
            else
                word(i)=companyname(questguy(qgindex).flag(6))
            endif
        endif
        if word(i)="<TONS>" and qgindex>0 then word(i)=""&questguy(qgindex).flag(1)
        if word(i)="<DEST>" and qgindex>0 then word(i)=""&questguy(qgindex).flag(12)+1
        if word(i)="<TIME>" and qgindex>0 then word(i)=""&display_time(questguy(qgindex).flag(15))
        if word(i)="<PAY>" and qgindex>0 then word(i)=""&questguy(qgindex).flag(13)
        
        r=r &word(i)
        if len(word(i+1))>1 or ucase(word(i+1))="A" or ucase(word(i+1))="I" then r=r &" "
        
    next
    return r
end function


function add_passenger(n as string,typ as short, price as short, bonus as short, target as short, sTime as short, gender as short) as short
    dim c as short
    c=get_freecrewslot
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



function dialog_effekt(effekt as string,p() as short,e as _monster, fl as short) as short
    dim as short f,a,i,t,ph,dh,dis,goal,answer,h,hc,c
    dim as integer rew,price
    dim as _items it
    dim as single fuelprice,fuelsell
    dim as string text
    dim as _ship sh
    if effekt="CHANGEMOOD" then e.aggr=p(1)
    
    if effekt="FRIENDLYCHANGE"  then 
        if rnd_range(1,100)<p(0) and questguy(p(1)).friendly(0)<2 then questguy(p(1)).friendly(0)+=1
    endif
    
    if effekt="PASSENGER" then
        if askyn("Do you want to transport "&questguy(p(0)).n &" to station "&questguy(p(0)).flag(12)+1 &" by " &display_time(questguy(p(0)).flag(15)) &" for " &credits(questguy(p(0)).flag(13))& " Cr.? (y/n)") then
            add_passenger(questguy(p(0)).n,30+p(0),questguy(p(0)).flag(13),questguy(p(0)).flag(14),questguy(p(0)).flag(12)+1,questguy(p(0)).flag(15),questguy(p(0)).gender)
            questguy(p(0)).location=-3
        endif
    endif
    
    if effekt="BUYSHIP" then
        sh=gethullspecs(p(1),"data/ships.csv")
        price=sh.h_price*haggle_("down")*((90-p(2)*5)/100)
        textbox(makehullbox(p(1),"data/ships.csv"),2,2,35,11,1)
        
        if askyn("Do you want to buy the "& sh.h_desig &" for "&credits(price)&" Cr.?(y/n)") then
	            if buy_ship(p(1),sh.h_desig,price)=-1 then player.cursed=rnd_range(1,p(2))
        endif
    endif
    
    if effekt="CONCERT" then
        if askyn(questguy(p(0)).n &" wants "&credits(p(1))&" to perform for your crew. Do you agree? (y/n)") then
            if paystuff(p(1)) then
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
            endif
        endif
    endif
    
    if effekt="BUYFUEL" then
        if askyn("Do you want to buy fuel for "&p(0) &" Cr. (y/n)") then
            rlprint "How much fuel do you want to buy"
            f=getnumber(0,player.fuelmax-player.fuel,0)
            if f*p(0)>player.money then f=fix(player.money/p(0))
            if f+player.fuel>player.fuelmax then f=player.fuelmax-player.fuel
            player.fuel=player.fuel+f
            if f>0 then rlprint "You buy "&f &" tons of fuel for "& credits(f*p(0)) &" Cr."
        endif
    endif
    
    if effekt="SETTARGET" then
        fleet(fl).t=lastwaypoint+1
        if p(0)=2 then
            rlprint "X Coordinate:"
            targetlist(fleet(fl).t).x=getnumber(0,sm_x,0)
            rlprint "Y Coordinate:"
            targetlist(fleet(fl).t).y=getnumber(0,sm_y,0)
        else
            targetlist(fleet(fl).t).x=player.lastpirate.x
            targetlist(fleet(fl).t).y=player.lastpirate.y
        endif
    endif
    
    if effekt="SELL" then
        if p(0)=1 then
            a=get_item
            if a>0 then
                if item(a).ty=2 or item(a).ty=7 or item(a).ty=4 then
                    item(a).w.p=e.no
                    item(a).w.s=0
                    it=make_item(96,-1,-3)
                    placeitem(it,0,0,0,0,-1)
                    reward(2)=reward(2)+it.v5
                    rlprint "The reptile gladly accepts the weapon 'This will help us in eradicating the other side' and hands you some "&it.desig
                endif
            endif
        endif
        if p(0)=2 then 'Questitem
            rlprint "You sell your "&item(p(1)).desig &" for "& credits(item(p(1)).price*p(2)*(1+crew(1).talents(2)/10)) &" Cr."
            addmoney(item(p(1)).price*p(2)*(1+crew(1).talents(2)/10),mt_trading)
            
            item(p(1))=item(lastitem)
            lastitem-=1
            
        endif
    endif
    
    if effekt="GIVEHAS" then
        placeitem(questguy(p(0)).has.it,0,0,0,0,-1)
        questguy(p(0)).has.given+=1
        rlprint questguy(p(0)).n &" gives you "& add_a_or_an( questguy(p(0)).has.it.desig,0) &"."
    endif
    
    if effekt="TEACHTALENT" then
        if (questguy(p(0)).friendly(0)>=1 or questguy(p(0)).want.given>0) and questguy(p(0)).flag(10)>0 then
        'if (questguy(p(0)).friendly(0)>=1 or questguy(p(0)).want.given>0 or _debug=2020) and questguy(p(0)).flag(10)>0 then
            rlprint "I think I could teach you a thing or two about that."
            if askyn("Do you want to learn "&talent_desig(questguy(p(0)).flag(10))&" for " &p(1)& " Cr.?(y/n)") then
                if paystuff(p(1)) then
                    if questguy(p(0)).flag(10)<=6 then
                         a=1
                    else
                         a=showteam(0,1,talent_desig(questguy(p(0)).flag(10)))
                    endif
                    if a>0 and can_learn_skill(a,questguy(p(0)).flag(10)) then
                        rlprint "You train long and hard. "& gain_talent(a,questguy(p(0)).flag(10))
                        questguy(p(0)).flag(10)=0
                        questguy(p(0)).money+=p(1)
                    else
                        if a>0 then rlprint crew(a).n &" cant learn "&talent_desig(questguy(p(0)).flag(10)) &"."
                        player.money+=p(1)
                    endif
                endif
            endif
        else
            rlprint "I don't think i can teach you anything."
        endif
    endif
    
    if effekt="GIVEJOBHAS" then
        select case questguy(p(0)).job
        case is=1
            it=make_item(1009,questguy(p(0)).location)
            if questguy(p(0)).friendly(0)>1 or questguy(p(0)).want.given>0 then
                it.price=0
            else
                it.price=25
            endif
        case is=14
            it=make_item(1002,p(0))
            if questguy(p(0)).friendly(0)>0 or questguy(p(0)).want.given>0 then
                it.price=10
            else
                it.price=0
            endif
        case 4 to 6
            if (questguy(p(0)).friendly(0)=2 or questguy(p(0)).want.given>0) and questguy(p(0)).flag(0)=0 then
                rlprint "Of course!"
                if questguy(p(0)).job=4 then rlprint gainxp(4,urn(0,3,1,0)),c_gre
                if questguy(p(0)).job=5 then rlprint gainxp(3,urn(0,3,1,0)),c_gre
                if questguy(p(0)).job=6 then rlprint gainxp(5,urn(0,3,1,0)),c_gre
                questguy(p(0)).flag(0)=1
                return 0
            else
                rlprint "I don't have anything interesting to share."
                return 0
            endif
        case else 'Company report
            rlprint standardphrase(sp_gotreport,rnd_range(0,2))
            it=make_item(1006,questguy(p(0)).job-9,questguy(p(0)).friendly(0))
            it.price=50*questguy(p(0)).friendly(0)
        end select
        it.price=it.price*(1-crew(1).talents(2)/10)
        if it.price=0 and it.desig<>"" then
            rlprint "Of course! "&questguy(p(0)).n &" hands you "&add_a_or_an(it.desig,0) &"."
            placeitem(it,0,0,0,0,-1)
        else
            if askyn("Do you want to pay "&credits(it.price) &" Cr. for the "&it.desig &"?(y/n)") then
                if paystuff(it.price) then
                    rlprint "You buy "&add_a_or_an(it.desig,0) &"."
                    placeitem(it,0,0,0,0,-1) 
                endif
            endif
        endif
                    
    endif
    
    if effekt="SELLHAS" then
        it=questguy(p(0)).has.it
        p(1)=(questguy(p(0)).has.motivation+1)
        price=fix(it.price*p(1)/5)'*
        price=fix(it.price*((10-questguy(p(0)).friendly(0)-crew(1).talents(2))/10))
        if price>0 then
            answer=askyn("Do you want to buy "& add_a_or_an(it.desig,0) &" for "& credits(price) &" Cr.(y/n)")
        else
            answer=askyn("Do you want the "& it.desig &"?(y/n)")
        endif
        if answer then
            if paystuff(price) then
                placeitem(it,0,0,0,0,-1)
                rlprint questguy(p(0)).n &" gives you "& add_a_or_an( questguy(p(0)).has.it.desig,0) &"."
                questguy(p(0)).has.given+=1
            endif
        endif
    endif
    
    if effekt="SELLOTHER" then 'p0=who p1=what,p2=mod1,p3=mod2
        it=make_item(p(1),p(2),p(3))
        if p(1)=1012 then 'Alibi
            if questguy(p(0)).friendly(0)+questguy(p(0)).friendly(p(2))>=3 then
                price=0
            else
                price=100-questguy(p(0)).friendly(p(2))*25-questguy(p(0)).friendly(0)*10
            endif
            if price>0 then
                if questguy(p(0)).friendly(p(2))<2 then text="Yes, but I don't like that person very much. Why would I want to be help?" 
                if questguy(p(0)).friendly(0)<2 then text="Why would I want to be drawn into it?" 
                if questguy(p(0)).friendly(0)<2 and questguy(p(0)).friendly(p(2))<2 then text="Yes, but I neither like you nor the other person very much. Why would I want to be drawn into it?" 
                rlprint text,15
            endif
        else
            price=it.price*((10-questguy(p(0)).friendly(0))/10)
        endif
        
        if price>0 then
            answer=askyn("Do you want to buy "& add_a_or_an(it.desig,0) &" for "& credits(price) &" Cr?(y/n)")
        else
            answer=askyn("Do you want the "& it.desig &"?(y/n)")
        endif
        
        if answer then
            if paystuff(price) then
                placeitem(it,0,0,0,0,-1)
                rlprint questguy(p(0)).n &" gives you "& add_a_or_an( it.desig,0) &"."
                if p(4)=1 then questguy(p(0)).flag(7)=1
                return 1
            endif
        endif
    endif
    
    if effekt="KNOWOTHER" and p(2)>0 then 
        if questguy(p(2)).talkedto=0 then questguy(p(2)).talkedto=1
    endif
    
    if effekt="GIVECARGO" then
        f=questguy(p(0)).flag(1)
        goal=questguy(p(0)).flag(2)
        price=p(1)
        if price*f>player.money then f=player.money/price
        if f>getfreecargo then f=getfreecargo
        if f>0 then
            if askyn("Do you want to buy "&f &" tons of Cargo for station "&goal+1 &" for "&credits(price)&"Cr. ?(y/n)") then
                if paystuff(f*price) then
                    if f>0 then f=load_quest_cargo(12,f,goal)
                    questguy(p(0)).flag(1)=f
                endif
            endif
        endif
    endif
    
    if effekt="SELLWANT" Then
        questguy(p(0)).talkedto=2
        i=has_questguy_want(p(0),t)
        if i>0 then
            select case t
            case qt_stationimp
                if questguy(p(0)).want.given=0 then
                    if askyn("Do you want to tell him about "&questguy(i).n &"?(y/n)") then
                        questguy(p(0)).talkedto=3
                        addmoney(50*(questguy(p(0)).want.motivation+1),mt_quest2)
                        rlprint adapt_nodetext(questguydialog(questguy(p(0)).want.type,questguy(p(0)).want.motivation,Q_ANSWER),e,fl,p(0)),15  
                        if 50*(questguy(p(0)).want.motivation+1)>0 then rlprint "You get a "&credits(50*(questguy(p(0)).want.motivation+1)) &" Tip."
                        if t=qt_stationimp and questguy(p(0)).location>=0 then
                                fleet((questguy(p(0)).location+1)).mem(1).hull+=rnd_range(2,20) 'Improves infrastructure
                        endif
                        questguy(p(0)).want.given+=1
                        if rnd_range(1,100)<50 and questguy(p(0)).friendly(0)<2 then questguy(p(0)).friendly(0)+=1 
                    
                    endif
                endif
            case qt_locofpirates,qt_locofspecial,qt_locofgarden
                if askyn("Do you want to tell him about the system at "&map(sysfrommap(i)).c.x &":"& map(sysfrommap(t)).c.y &"?(y/n)") then
                    questguy(p(0)).talkedto=3
                    questguy(p(0)).systemsknown(sysfrommap(i))=1
                    if t=qt_locofpirates then
                        rew=50*(questguy(p(0)).want.motivation+1)*planets(i).discovered*haggle_("up")
                    else
                        rew=10*(questguy(p(0)).want.motivation+1)*planets(i).discovered*haggle_("up")
                    endif
                    rlprint adapt_nodetext(questguydialog(questguy(p(0)).want.type,questguy(p(0)).want.motivation,Q_ANSWER),e,fl,p(0)),15  
                    addmoney(rew,mt_quest2)
                    rlprint "You get "&rew &" Cr. for the information"
                    if rnd_range(1,100)<50 and questguy(p(0)).friendly(0)<2 then questguy(p(0)).friendly(0)+=1 
                    
                endif
            case qt_megacorp
                price=(10+item(i).price)*(item(i).v2+p(1)+p(2))*haggle_("up")
                if askyn("Do you want to sell your "&item(i).desig &" for "& price &" Cr.(y/n)?") then
                    questguy(p(0)).talkedto=3
                    rlprint adapt_nodetext(questguydialog(questguy(p(0)).want.type,questguy(p(0)).want.motivation,Q_ANSWER),e,fl,p(0)),15  
                    addmoney(price,mt_quest2)
                    destroyitem(i)
                    questguy(p(0)).want.given+=1
                    if rnd_range(1,100)<60 and questguy(p(0)).friendly(0)<2 then questguy(p(0)).friendly(0)+=1 
                endif
            case else
                price=item(i).price*((p(1)+p(2))/5)*haggle_("up")
                if askyn("Do you want to sell your "&item(i).desig &" for "& price &" Cr.(y/n)?") then
                    if price>questguy(p(0)).money*.6 then
                        if askyn("I only have "&credits(questguy(p(0)).money*.6) &" Cr. Would you accept that? (y/n)") then
                            questguy(p(0)).friendly(0)+=1
                            price=questguy(p(0)).money*.6
                        endif
                    endif
                    if price<questguy(p(0)).money then
                        questguy(p(0)).talkedto=3
                        questguy(p(0)).money-=price
                        rlprint adapt_nodetext(questguydialog(questguy(p(0)).want.type,questguy(p(0)).want.motivation,Q_ANSWER),e,fl,p(0)),15  
                        addmoney(price,mt_quest2)
                        destroyitem(i)
                        questguy(p(0)).want.given+=1
                        if rnd_range(1,100)<50 and questguy(p(0)).friendly(0)<2 then questguy(p(0)).friendly(0)+=1 
                        if t=qt_drug and questguy(p(0)).want.motivation>0 then questguy(p(0)).want.motivation-=1
                    endif
                else
                    if item(i).ty=57 or item(i).ty=64 then item(i).price=0
                
                endif
            end select
            return 1
        endif
        if i<-20 and t=qt_megacorp then
            i=abs(i)
            if askyn("Do you want to sell your information on "&companyname(i-21) &"?(y/n)") then
                questguy(p(0)).talkedto=3
                rlprint adapt_nodetext(questguydialog(questguy(p(0)).want.type,questguy(p(0)).want.motivation,Q_ANSWER),e,fl,p(0)),15  
                player.questflag(i)+=1
                addmoney(15000,mt_blackmail)
            endif
        endif
    endif
    
    if effekt="GIVEMESSAGE" then
        if askyn("Do you want to deliver the message?(y/n)") then placeitem(make_item(1003,p(0),questguy(p(0)).flag(1)),0,0,0,0,-1)
        'rlprint questguyquestion(questguy(p(0)).want.type,Q_ANSWER)  
    endif
    
    if effekt="GIVEAUTOGRAPH" then
        placeitem(make_item(1002,p(0)),0,0,0,0,-1)
    endif
    
    if effekt="GIVESACC" then
        placeitem(make_item(1009,p(0)),0,0,0,0,-1)
    endif
        
    if effekt="BUYBIODATA" then
        questguy(p(0)).talkedto=2
        if reward(1)>0 then
            if askyn("Do you want to sell your biodata for "& reward(1)*p(1) & " Cr.?(y/n)") then
                addmoney(reward(1)*p(1),mt_bio)
                questguy(p(0)).want.motivation-=1
                if questguy(p(0)).want.motivation=-1 then 
                    questguy(p(0)).want.motivation=0
                    questguy(p(0)).want.given=1
                    questguy(p(0)).talkedto=3
                endif
                reward(1)=0
                rlprint adapt_nodetext(questguydialog(questguy(p(0)).want.type,questguy(p(0)).want.motivation,Q_ANSWER),e,fl,p(0)),15  
            endif
        endif
    endif
    
    if effekt="BUYANOMALY" then
        questguy(p(0)).talkedto=2
        if ano_money>0 then
            if askyn("Do you want to sell your data on anomalies for "& ano_money*p(1) & " Cr.?(y/n)") then
                addmoney(ano_money*p(1),mt_ano)
                questguy(p(0)).want.motivation-=1
                if questguy(p(0)).want.motivation=-1 then 
                    questguy(p(0)).want.motivation=0
                    questguy(p(0)).want.given=1
                    questguy(p(0)).talkedto=3
                endif
                ano_money=0
                rlprint adapt_nodetext(questguydialog(questguy(p(0)).want.type,questguy(p(0)).want.motivation,Q_ANSWER),e,fl,p(0)),15  
            endif
        endif
    endif
    
    if effekt="BUYOTHERWANT" then
        it=questguy(p(0)).want.it
        price=it.price*(p(1)/10)*haggle_("down")
        if askyn("Do you want to buy the "&it.desig &" for "&credits(price) &"?(y/n)") then
            if paystuff(price) then placeitem(it,0,0,0,0,-1)
        endif
    endif
    
    if effekt="EINTREIBEN" then
        it=make_item(1007,p(0),questguy(questguy(p(0)).flag(1)).loan)
        rlprint questguy(p(0)).n &" hands you "&it.desig &"."
        placeitem(it,0,0,0,0,-1)
        questguy(p(0)).loan=0
    endif
    
    if effekt="ABGEBEN" then
        price=item(p(0)).v2*(questguy(p(1)).want.motivation+1)/10
        rlprint questguy(p(1)).n &" gives you "& credits(price) &" Cr.",c_gre
        addmoney(price,mt_quest2)
        destroyitem(p(0))
        questguy(p(1)).want.given=1
    endif
    
    if effekt="HAVEDRINK" then
        if paystuff(2) then
            p(1)+=1
            select case rnd_range(1,100)-questguy(p(0)).friendly(0)*5-p(1)
            case is<=10
                questguy(p(0)).friendly(0)+=1
                rlprint "You really hit it off with "&questguy(p(0)).n &"."
            case is>=90
                questguy(p(0)).friendly(0)-=1
                rlprint "The conversation devolves into an argument."
            case else
                rlprint "You have a little smalltalk, and enjoy the drink."
            end select
        endif
    endif
    
    if effekt="LEARNSKILL" then 'p0=price p1=skill
        
        if player.money>=p(0) then
            a=showteam(0,0,"Learn "&talent_desig(p(1)))
            if a>=0 then
                if can_learn_skill(a,p(1))=-1 then
                    crew(a).talents(p(1))+=1
                    paystuff(p(0))
                endif
            else
                rlprint crew(a).n &" can't learn " &talent_desig(p(1)),c_yel
            endif
        else
            rlprint "You don't have enough money",14
            
        endif
    endif
    
    if effekt="PIRATETHREAT" then
        for i=1 to 15
            dh+=fleet(fl).mem(i).hull
        next
        ph=player.hull
        if rnd_range(1,ph+dh)+dh>rnd_range(1,ph+dh)+ph then
            'defend
            rlprint "Ha! We are going to defend ourselves!"&ph,c_yel
            if rnd_range(1,100)>25+faction(0).war(1) then
                if askyn("Do you really want to attack?(y/n)") then 
                    i=1
                else
                    rlprint "Wannabe pirate scum.... Click"
                    i=0
                    factionadd(0,fleet(fl).ty,1)
                endif
            else
                i=1
            endif
            if i=1 then
                factionadd(0,fleet(fl).ty,3)
                playerfightfleet(fl)
            endif
        else
            'Drop cargo
            rlprint "Ok, we don't want any trouble.",c_gre
            factionadd(0,fleet(fl).ty,2)
            for i=1 to lastgood
                basis(10).inv(i).v=0
                basis(10).inv(i).p=0
            next
            fleet(fl)=tCompany.unload_f(fleet(fl),10)
            tCompany.trading(10)
            fleet(fl)=load_f(fleet(fl),10)
        endif
    endif
    
    if effekt="ESCORT" then
        if rnd_range(1,20)<5+patrolmod+fleet(a).con(4)+crew(1).talents(4) then
            factionadd(0,fleet(fl).ty,-1)
            price=3+player.h_maxweaponslot
            dis=merc_dis(fl,goal)
            fleet(fl).con(2)=cint(price*dis*(1+crew(1).talents(2)/10))
            if askyn("Of course a little extra protection would be nice. Our goal is Station-" &goal+1 & ". How about " & fleet(fl).con(2) & " Cr. Pirate bounties are yours too?(y/n)") then
                fleet(fl).con(1)=1
                fleet(fl).con(3)=goal
                if fleet(fl).con(4)>0 then rlprint "Glad to see you again, btw. Let's hope this goes as smoothly as the last time"
            else
                fleet(fl).con(2)=0
            endif
        else
            rlprint "No thanks."
            fleet(fl).con(4)-=1
        endif
    endif
    
    if effekt="FUELPRICE" then
        fl=abs(fl)
        fuelprice=round_nr(basis(nearest_base(player.c)).inv(9).p/30+disnbase(player.c)/15-count_gas_giants_area(player.c,3)/2,2)
        if fuelprice<1 then fuelprice=1
        if planets(drifting(fl).m).flags(26)=9 then fuelprice=fuelprice*3 
        fuelsell=fuelprice/2
        
        rlprint "We buy for " &credits(fuelsell) & " Cr. and sell for " & credits(fuelprice) & " Cr."
    endif
    
    if effekt="STATIONEVENT" then
        fl=abs(fl)
        fuelprice=round_nr(basis(nearest_base(player.c)).inv(9).p/30+disnbase(player.c)/15-count_gas_giants_area(player.c,3)/2,2)
        if fuelprice<1 then fuelprice=1
        if planets(drifting(fl).m).flags(26)=9 then fuelprice=fuelprice*3 
        fuelsell=fuelprice/2
        
        select case planets(drifting(fl).m).flags(26)
        
        case is=1
            rlprint "There is a alien lifeform lose on the station, and advises you to stay clear of dark corners."
        Case is=4
            rlprint "There is a mushroom infestation on the station! Please dock and help us! We will pay you if you can destroy them!"
        case is=5 
            rlprint "Please help us! The station is under attack from pirates!"
        case is=6
            rlprint "We got a little problem. The station has been hit by an asteroid and is currently leaking. Better wear your spacesuits if you come on board."
        case is=9 
            rlprint "There is a fuel shortage and the prices have been increased to "&fuelprice &" for buying and "&fuelsell & " a ton for selling"
        case is=10
            rlprint "There is a party of civilized aliens on board!"
        case is=12
            rlprint "There is a tribble infestation on the station!"
        case else
            rlprint "Business is going very well, thank you for asking!."
        end select
        
    endif
    
    if effekt="QGTRADE" then
        i=has_questguy_want(p(0),t)
        if i>0 then 
            if item(i).price>questguy(p(0)).has.price then
                if askyn("I would trade my "&questguy(p(0)).has.it.desig &" for your "&item(i).desig &".") then
                    placeitem(questguy(p(0)).has.it,,,,-1)
                    item(i)=item(lastitem)
                    lastitem-=1
                    questguy(p(0)).want.given+=1
                endif
            else
                rlprint "You find nothing to trade."
            endif
        else
            rlprint "You find nothing to trade."
        endif
    endif
    return 0
end function


function node_menu(no as short,node() as _dialognode,e as _monster, fl as short,qgindex as short=0) as short
    DimDebugL(0)'1
    dim as string text,rh,lh
    dim as short a,c,flag,effekt

    if node(no).effekt="PAYWALL" then        
        lh=left(node(no).statement,instr(node(no).statement,"<->")-1)
        rh=right(node(no).statement,len(node(no).statement)-2-instr(node(no).statement,"<->"))
        rlprint lh,11
        if node(no).param(1)>0 and questguy(qgindex).has.given=0 then
            If askyn("I will tell you for "&node(no).param(1)& " Cr. Do you want to pay?(y/n)") then
                if paystuff(node(no).param(2)) then
                    questguy(qgindex).has.given=1
                    if planets(questguy(qgindex).flag(4)).discovered=0 then planets(questguy(qgindex).flag(4)).discovered=1
                    questguy(qgindex).flag(3)=sysfrommap(questguy(qgindex).flag(4))
                    if map(questguy(qgindex).flag(3)).discovered=0 then 
                        map(questguy(qgindex).flag(3)).discovered=1
                        map(questguy(qgindex).flag(3)).desig=spectralshrt(map(questguy(qgindex).flag(3)).spec)&player.discovered(map(questguy(qgindex).flag(3)).spec)&"-"&int(disnbase(map(questguy(qgindex).flag(3)).c))&cords(map(questguy(qgindex).flag(3)).c) 
                    endif
                else
                    return 0 'Not enough moneys
                endif
            else
                return 0 'Doesnt pay
            endif
        else
            if map(questguy(qgindex).flag(3)).discovered=0 then 
                map(questguy(qgindex).flag(3)).discovered=1
                map(questguy(qgindex).flag(3)).desig=spectralshrt(map(questguy(qgindex).flag(3)).spec)&player.discovered(map(questguy(qgindex).flag(3)).spec)&"-"&int(disnbase(map(questguy(qgindex).flag(3)).c))&cords(map(questguy(qgindex).flag(3)).c)
            endif
            
        endif
    endif
    DbgPrint("debug!")
    if node(no).effekt="PAYWALL" then
        rlprint adapt_nodetext(rh,e,fl,qgindex),11
    else
        rlprint adapt_nodetext(node(no).statement,e,fl,qgindex),11
    endif
    if node(no).effekt<>"" then 
        effekt=dialog_effekt(node(no).effekt,node(no).param(),e,fl)
        if effekt=1 then return 1
        if node(no).param(5)>0 then return node(no).param(5)
    endif
    text="You say"
#if __FB_DEBUG__
    if qgindex>0 then text=text &questguy(qgindex).talkedto
#endif
    for a=1 to 16
        if node(no).option(a).answer<>"" then 
            text=text &"/"& adapt_nodetext(node(no).option(a).answer,e,fl,qgindex)
#if __FB_DEBUG__
            if debug=1 then text=text &"("& node(no).option(a).no &")"
#endif
            flag+=1
        endif
    next
    'if qgindex>0 then text=text &"/Bye."
    if flag>0 then
        do
            c=textmenu(bg_shiptxt,text,,0,20-flag,1)
        loop until c>=0
        rlprint adapt_nodetext(node(no).option(c).answer,e,fl,qgindex),15
        DbgPrint("you choose "&node(no).option(c).no &":"&c) ',11)
        return node(no).option(c).no
    else
        return node(no).option(1).no
    endif
end function


function questguy_dialog(i as short) as short
    dim node(64) as _dialognode
    dim as short no,l
    no=1
    'dim as short fl
    dim e as _monster
    
    questguy_message(i) 'Check if player has message for qg before entering dialogue
    
    do
        l+=1
        update_questguy_dialog(i,node(),l)
        no=node_menu(no,node(),e,0,i)
    loop until no=0
    return 0
end function



function do_dialog(no as short,e as _monster, fl as short) as short
    dim node(64) as _dialognode
    dim as short last
    last=load_dialog("data/dialog" &no & ".csv",node())
    no=1
    do
        display_ship(0)
        DbgPrint(node(no).effekt)
        no=node_menu(no,node(),e,fl)
        DbgPrint("Next node:"&no)
    loop until no=0
    return 0
end function


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tDialog -=-=-=-=-=-=-=-
	tModule.register("tDialog",@tDialog.init()) ',@tDialog.load(),@tDialog.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tDialog -=-=-=-=-=-=-=-
#endif'test
