'Credits
declare function shares_value() as short


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
    income(mt_last)+=shares_value
    for i=0 to mt_last-1
        per(i)=int((income(i)/income(mt_last))*100)
        if len(desig(i)&credits(income(i)))>l then l=len(desig(i)&credits(income(i)))
    next
    per(mt_last)=int(shares_value/income(mt_last)*100)
    l=l+7
    t="<table><tbody><tr><td>"& html_color("#ffffff") &"Income:</span></td><td></td></tr>"
    i=0

    if income(i)>0 then t=t &"<tr><td>"& html_color("#ffffff") &desig(i) &"</span></td><td align=right>" & html_color("#00ff00")&credits(income(i))&" Cr.</span></td><td>"& html_color("#00ff00")&"(" &per(i)& "%)</span></div></td></tr>"
    if shares_value>0 then t=t &"<tr><td>"& html_color("#ffffff") &"Stock:</span></td><td align=right>" & html_color("#00ff00")&credits(shares_value)&" Cr.</span></td><td>"& html_color("#00ff00")&"(" &per(mt_last)& "%)</span></div></td></tr>"

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
    income(mt_last)+=shares_value()
    for i=0 to mt_last
        per(i)=int((income(i)/income(mt_last))*100)
        if len(desig(i)&credits(income(i)))>l then l=len(desig(i)&credits(income(i)))
    next
    per(mt_last)=int(shares_value/income(mt_last)*100)
    l=l+7
    text="{15}Income:|"
    if shares_value>0 then text=text &"  {11}"&"Stock" &space(l-len(credits(shares_value))-len("Stock"))&"{" & c_gre &  "}"&credits(shares_value) & " Cr. (" &per(mt_last)& "%)|"

    for i=0 to mt_last-1
        if income(i)>0 then text=text &"  {11}"&desig(i) &space(l-len(desig(i))-len(credits(income(i))))&"{" & c_gre &  "}"&credits(income(i)) & " Cr. (" &per(i)& "%)|"
    next
    text=text &"|  {11}"&desig(mt_last) &space(l-len(desig(mt_last))-len(credits(income(mt_last))))&"{" & c_gre &  "}"&credits(income(i)) & " Cr.|"
    ex=player.money-income(mt_last)
    text=text &"|{15}Expenses:|  {"&c_red & "}" & space(l-len(credits(ex)))&credits(ex)&_
    " Cr.|{15}Revenue:|  "&space(l-len(credits(player.money))) &"{11}"&credits(player.money) &" Cr."

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

