'tPlayer

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

Dim Shared income(mt_last) As Integer


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
    if d<10 then desig=desig & "0"
    if d<100 then desig=desig & "0"
    if d<1000 then desig=desig & "0"

    desig=desig &d &suf
    if lines(ra)<>"" and count>0 then desig=lines(ra)

    f=freefile

    open "register" for output as f
    print #f,d
    print #f,mask
    print #f,fname

    close f
    return desig

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


Function _monster.add_move_cost() As Short
    Dim As Short cost
    cost=(20-speed)*planets(player.map).grav
    cost+=tmap(c.x,c.y).movecost
    If made=0 And player.tactic=2 Then cost-=1 '
    If cost<=0 Then cost=1
    e.add_action(cost)
    Return 0
End Function


