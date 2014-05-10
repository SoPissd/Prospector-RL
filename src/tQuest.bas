'tQuest


Type _bountyquest
    status As Byte '1 given, 2 ship destroyed by player, 3 ship destroyed by other, 4 reward given
    employer As Byte
    ship As Short
    reward As Short
    desig As String *32
    reason As Byte
    lastseen As _cords
End Type

Dim Shared As Short lastbountyquest=16
Dim Shared bountyquest(lastbountyquest) As _bountyquest

Type _patrolquest
    status As Byte
    employer As Byte
    Enum emp
        corporate
        pirate
    End Enum
    cord(12) As _cords
    lastcord As Byte
    Declare function generate(p As Short,maxdis As Short,danger As Short) As Short
    Declare function check() As Short
    Declare function reward() As Short
    Declare function show() As String
    Declare function pay() As Short
End Type

Dim Shared patrolquest(16) As _patrolquest


function bounty_quest_text() as string
    dim t as string
    dim i as short
    for i=1 to lastbountyquest
        if bountyquest(i).status=1 then t=t &"Destroy the "& bountyquest(i).desig &", last seen at "&cords(bountyquest(i).lastseen) &".|"
    next
    return t
end function

function show_quests() as short
    dim as short a,b,c,d,sys,p
    dim dest(10) as short
    dim as string txt,addtxt
    set__color( 15,0)
    cls
    txt="{15}Missions: |{11}"
    set__color( 11,0)
    for a=1 to 10
        if player.cargo(a).x=11 or player.cargo(a).x=12 then
            b+=1
            dest(b)=player.cargo(a).y+1
        endif
    next
    if b>0 then
        set__color( 15,0)
        txt=txt & "Cargo:|"
        for a=1 to b
            set__color( 11,0)
            txt=txt & "  Cargo for Station-"&dest(a) &"|"
        next
    endif
    if player.questflag(8)>0 and player.towed<0 then print " Deliver "&add_a_or_an(shiptypes(-player.towed),0) &" hull to Station "&player.questflag(8)+1

    if player.questflag(7)>0 then
        sys=sysfrommap(player.questflag(7))
        for d=1 to 9
            if map(sys).planets(d)=player.questflag(7) then p=d
        next
        txt=txt & "  Map planet in orbit "&p &" in the system at "&map(sys).c.x &":"&map(sys).c.y &"|"
    endif
    if player.questflag(9)=1 then txt=txt & "  Find a working robot factory"&"|"
    if player.questflag(10)>0 then txt=txt & "  Find a planet without life and "&add_a_or_an(atmdes(player.questflag(10)),0)&" atmosphere."&"|"
    if player.questflag(11)=1 then txt=txt & "  Find a missing company battleship"&"|"
    if player.questflag(2)=1 then txt=txt & "  Rescue a company executive from pirates"&"|"
    if player.questflag(12)=1 then txt=txt & "  A small green alien told you about a monster in their mushroom caves."
    if player.questflag(26)>0 then
        sys=sysfrommap(player.questflag(26))
        txt=txt & "  Find out what happened to an expedition last reported from "&cords( map(sys).c)&"."&"|"
    endif
    set__color( 15,0)
    txt=txt & "|{15}Headhunting:{11}"&"|"
    set__color( 11,0)
    txt=txt & bounty_quest_text
    if player.questflag(5)=1 then txt=txt & "  Bring down an unknown alien ship"&"|"
    if player.questflag(6)=1 then txt=txt & "  Bring down an unknown alien ship"&"|"

    txt=txt &"|{15}Escorting:{11}|"
    for a=6 to lastfleet
        if fleet(a).con(1)=1 then
            txt=txt &"  Escort merchant fleet "&a &" to station "&fleet(a).con(3)+1 &"."&"|"
        endif
    next
    txt=txt &"|{15}Patrol:{11}|"
    for a=0 to 12
#if __FB_DEBUG__ ' _debug=1111 
		txt &= patrolquest(a).status &" " 
#endif
        if patrolquest(a).status=1 then txt=txt &"  " &patrolquest(a).show &"|"
    next
    txt=txt &"|{15}Other:{11}|"
    for a=1 to lastquestguy
        if questguy(a).talkedto=2 then
        txt=txt &questguy(a).n &", last seen at "
        if questguy(a).location<0 then
            txt=txt &"a small station,"
        else
            txt=txt &"station-"&questguy(a).location+1 &","
        endif
        select case questguy(a).want.type
        case qt_EI'1
            txt=txt &" wants " &add_a_or_an(questguy(a).want.it.ldesc,0) &".|"
        case qt_autograph'3
            txt=txt &" wants to have an autograph from "&questguy(questguy(a).flag(1)).n &".|"
        case qt_outloan'4
            txt=txt &" wants money back from "&questguy(questguy(a).flag(1)).n &".|"
        case qt_stationimp'5
            txt=txt &" is looking for good engineers.|"
        case qt_drug'6
            txt=txt &" wants " &questguy(a).want.it.desig &".|"
        case qt_souvenir'7
            txt=txt &" wants to have a souvenir.|"
        case qt_tools'8
            txt=txt &" wants to have tools.|"
        case qt_showconcept'9
            txt=txt &" wants a showconcept.|"
        case qt_stationsensor'10
            txt=txt &" wants to have access to station sensors.|"
        case qt_locofpirates'13
            txt=txt &" wants to know the location of pirates.|"
        case qt_locofspecial'14
            txt=txt &" wants to know the location of a special planet.|"
        case qt_locofgarden'15
            txt=txt &" wants to know the location of an earthlike planet.|"
        case qt_research'18
            txt=txt &" is interested in "&questguy(questguy(a).flag(1)).n &"s research.|"
        case qt_megacorp'19
            txt=txt &" is lookin for information on "&companyname(questguy(a).flag(6)) &".|"
        case qt_biodata'20
            txt=txt &" buys biodata.|"
        case qt_anomaly'21
            txt=txt &" buys anomaly data.|"
        case qt_juryrig'22
            txt=txt &" buys plans for improvised repairs.|"
            'qt_cargo
        end select

        endif
    next

    textbox(txt,2,2,_mwx*_fw1/_fw2-4,,1)
    display_ship(0)
    no_key=keyin
    return 0
end function

