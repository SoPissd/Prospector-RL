'tGamekeys

function keyin(byref allowed as string="" , blocked as short=0)as string
    DimDebugL(0)'1
    dim key as string
    dim as string text
    static as byte recording
    static as byte seq
    static as string*3 comseq
    static as string*3 lastkey
    dim as short a,b,i,tog1,tog2,tog3,tog4,ctr,f,it
    dim as string control

    if walking<>0 then sleep 50
    flip
    if _test_disease=1 and allowed<>"" then allowed="#"&allowed
    if tVersion.gamerunning and allowed<>"" then allowed=allowed &" " ' gamerunning == player.dead>0
    do 
        control=""
        do        
            If (ScreenEvent(@evkey)) Then
'                
'if evkey.ascii=0 and evkey.scancode=23 or evkey.ascii=asc(key_extended) then
'                    if evkey.type=EVENT_KEY_PRESS or evkey.type=EVENT_KEY_REPEAT THEN
'                        if evkey.scancode=23 then control="\C"
'                        if evkey.ascii=asc(key_extended) then control=key_extended
'                    else
'                        control=""
'                    endif
'                endif
                Select Case evkey.type
               	case FB.EVENT_KEY_REPEAT
                        while screenevent(@evkey)
                        wend
                        key=lastkey
                	Case (FB.EVENT_KEY_PRESS)
                        if debug =1 then
                            locate 1,1
                            print evkey.scancode &":"& evkey.ascii &":"&FB.EVENT_KEY_PRESS &":"&FB.EVENT_KEY_REPEAT
                        endif
                        select case evkey.scancode
									case FB.sc_down
                            key = key_south
                        	case FB.sc_up
                            key = key_north
                        	case FB.sc_left
                            key = key_west
                        	case FB.sc_right
                            key = key_east
                        	case FB.sc_home
                            key = key_nw
                        	case FB.sc_pageup
                            key = key_ne
                        	case FB.sc_end
                            key = key_sw
                        	case FB.sc_pagedown
                            key = key_se
                        	case FB.sc_escape
                            key=key__esc
                        	case FB.sc_enter
                            key=key__enter
                       		case FB.sc_pageup
                            key=key_pageup
                        	case FB.sc_pagedown
                            key=key_pagedown
                        	'case sc_control
                        	' control="\C"
                        	case else
                            if evkey.ascii<=26 then
                                key="\C"&chr(evkey.ascii+96)
                            else
                                if len(chr(evkey.ascii))>0 then key = chr(evkey.ascii)
                            endif
                        end select
                    
                    end select
                endif            
            sleep 1
        loop until key<>"" or walking<>0 or (allowed="" and tVersion.gamerunning) or just_run<>0 'gamerunning==player.dead<>0
        lastkey=key    
        comstr.nextpage
        if key<>"" then walking=0 
'        if _test_disease=1 and key="#" then
'            a=getnumber(0,255,0)
'            b=Getnumber(0,255,0)
'            crew(a).disease=b
'            crew(a).duration=disease(b).duration
'            crew(a).incubation=disease(b).incubation
'            if b>player.disease then player.disease=b
'            rlprint a &":" & b
'            a=0
'            b=0
'            key=""
'        endif
        
        if blocked>=97 then
            if (asc(key)>=97 and asc(key)<=blocked) then return key
        endif
        if blocked=0 or blocked>=97 then
                        
#if __FB_DEBUG__
            if debug>0 and key="\Ci" then
            	DbgItemDump
            endif
            
            if debug=-1 and key="�" then
                for x=0 to 60
                    for y=0 to 20
                        planetmap(x,y,player.map)=abs(planetmap(x,y,player.map))
                    next
                next
            endif
            
            if debug>0 and key="�" then
            	DbgFleetsDump
            endif
                
            
            if debug>0 and key=key_testspacecombat then
                spacecombat(fleet(rnd_range(6,lastfleet)),9)
            endif
#endif
            
            if key=key_awayteam then
                if location=lc_onship then
                    showteam(0)
                else
                    showteam(1)
                endif
                return ""
            endif
            
            if key=key_accounting then
                textbox(income_expenses,2,2,45,11,1)
                no_key=keyin
                return ""
            endif
            
            if key=key_manual then
                a=menu(bg_parent,"Help/Manual/Keybindings/Configuration/Exit","",2,2)
                if a=1 then viewfile("readme.txt")
                if a=2 then keybindings
                if a=3 then configuration
                return ""
            endif
            
            if key=key_messages then 
                messages
                return ""
            endif
            
            if key=key_configuration then
                configuration
                return ""
            endif
            
            if key=key_tactics then
                settactics
                return ""
            endif
            
            if key=key_shipstatus then         
                shipstatus()
                return ""
            endif
            
            if key=key_logbook then
                logbook()
                return ""
            endif

            if key=key_equipment then
                a=get_item()
                if a>0 then rlprint item(a).ldesc
                key=keyin()
                return ""
            endif
            
            if key=key_standing then
                show_standing()
                
                return ""
            endif
            
            if key=key_quest then
                show_quests
                return ""
            endif
            
            if key=key_quit then 
                if askyn("Do you really want to quit? (y/n)") then player.dead=6
            endif
            
        endif
        if key=key_autoinspect then
            tScreen.set(1)
            select case _autoinspect
                case is =0
                    _autoinspect=1
                    rlprint "Autoinspect Off"
                case is =1
                    _autoinspect=0
                    rlprint "Autoinspect On"                
            end select
            key=""     
        endif
        if key=key_autopickup then
            tScreen.set(1)
            select case _autopickup
                case is =0
                    _autopickup=1
                    rlprint "Autopickup Off"
                case is =1
                    _autopickup=0
                    rlprint "Autopickup On"                
            end select
            key=""     
        endif       
        if key=key_togglehpdisplay then
            tScreen.set(1)
            select case _HPdisplay
                case is =0
                    _HPdisplay=1
                    rlprint "Hp display now displays icons"
                case is =1
                    _HPdisplay=0
                    rlprint "Hp display now displays HPs"
            end select
            key=""
        endif
        if key="$" and dbshow_factionstatus=1 then
            
            for a=0 to 7
                text="Faction "&a
                for b=0 to 7
                    text=text &":"&faction(a).war(b)
                next
                rlprint text
            next
        endif
        if len(allowed)>0 and key<>key__esc and key<>key__enter and getdirection(key)=0 then
            if instr(allowed,key)=0 and walking=0 then 
                'keybindings(allowed)
                key=""
            endif
        endif
    loop until key<>"" or walking <>0 or just_run<>0
    if just_run<>0 then 
        if just_run>0 then just_run-=1
        if key=key__esc then just_run=0
    endif
    comstr.reset
    return key
end function

