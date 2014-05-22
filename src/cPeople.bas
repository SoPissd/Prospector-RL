'tPeople.
'
'defines:
'rnd_questguy_byjob=0, get_other_questguy=0, questguy_newquest=2,
', has_questguy_want=1, get_highestrisk_questguy=0
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
'     -=-=-=-=-=-=-=- TEST: tPeople -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test


#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-


Dim Shared questguyjob(18) As String

#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tPeople -=-=-=-=-=-=-=-

declare function has_questguy_want(i as short,byref t as short) as short

'declare function rnd_questguy_byjob(jo as short,self as short=0) as short
'declare function get_other_questguy(i as short,sameplace as byte=0) as short
'declare function get_highestrisk_questguy(st as short) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tPeople -=-=-=-=-=-=-=-

namespace tPeople
function init(iAction as integer) as integer
	return 0
end function
end namespace'tPeople

function rnd_questguy_byjob(jo as short,self as short=0) as short
    dim as short other,j,h
    dim others(15) as short
    for j=1 to lastquestguy
        if questguy(j).job=jo and (self=0 or j<>self) then
            h+=1
            others(h)=j
        endif    
    next
    return others(rnd_range(1,h))
end function


function get_other_questguy(i as short,sameplace as byte=0) as short
    dim as short other,j,h
    dim others(15) as short
    for j=1 to lastquestguy
        if i<>j and (questguy(i).location<>questguy(j).location or sameplace=1) then
            h+=1
            others(h)=j
        endif    
    next
    return others(rnd_range(1,h))
end function




function has_questguy_want(i as short,byref t as short) as short
    dim as short a,b,c
    dim as short il(255),ic(255),cc,v,r,j,set,fl
    dim as string text
    if questguy(i).want.type=qt_megacorp then
        t=qt_megacorp
        if player.questflag(21)=1 and questguy(i).flag(6)=1 then return -21
        if player.questflag(22)=1 and questguy(i).flag(6)=2 then return -22
        if player.questflag(23)=1 and questguy(i).flag(6)=3 then return -23
        if player.questflag(24)=1 and questguy(i).flag(6)=4 then return -24
    endif
    
    'Item
    for a=0 to lastitem
        if item(a).w.s=-1 then
            select case questguy(i).want.type
            case is=qt_EI
                t=qt_EI
                if item(a).ty=questguy(i).want.it.ty and item(a).v1>=questguy(i).want.it.v1 then 
                    set=0
                    for j=1 to cc
                        if item(il(j)).id=item(a).id then 
                            ic(j)+=1
                            set=1
                        endif
                    next
                    if set=0 then
                        cc+=1
                        il(cc)=a
                        ic(cc)+=1
                    endif
                endif
            case is=qt_autograph
                t=qt_autograph
                if item(a).ty=57 and item(a).ty=questguy(i).want.it.ty and item(a).v1=questguy(i).want.it.v1 then  
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_drug
                t=qt_drug
                if item(a).ty=60 and item(a).v1=questguy(i).want.it.v1 then
                    cc+=1
                    il(cc)=a
                endif
            	case is=qt_souvenir
                t=qt_souvenir
                if item(a).ty=23 then   
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_showconcept
                t=qt_showconcept
                if item(a).ty=63 and (item(a).v1=i or item(a).v1=0) then   
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_stationsensor
                t=qt_stationsensor
                if item(a).ty=64 and (questguy(i).location=-1 or item(a).v1=questguy(i).location) then   
                    item(a).price=(questguy(i).want.motivation+1)*10
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_outloan
                if item(a).ty=62 and item(a).v1=i then
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_research
                t=qt_research
                if item(a).ty=65 and item(a).v1=questguy(i).flag(1) then  
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_tools
                t=qt_tools
                if item(a).ty=59 then   
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_megacorp
                t=qt_megacorp
                if item(a).ty=61 and item(a).v1=questguy(i).want.it.v1 then  
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_juryrig
                t=qt_juryrig
                if item(a).ty=66 then  
                    cc+=1
                    il(cc)=a
                endif
            end select
        endif
    next
    
    if cc=1 then
        t=il(cc)
        return il(cc)
    endif
    if cc>1 then
        text="Offer"&cc
        for j=1 to cc
            if ic(j)<=1 then
                text=text &"/" &item(il(j)).desig &" (Est. "&credits(item(il(j)).price) &" Cr.)"
            else
                text=text &"/" &ic(j) &" " &item(il(j)).desigp &" (Est. "&credits(item(il(j)).price) &" Cr.)"
            endif
        next
        fl=20-cc
        if fl<0 then fl=0
        cc=textmenu(text,,0,fl)
        if cc>0 then 
            t=il(cc)
            return il(cc)
        else
            t=0
            return -1
        endif
    endif
        
    'Location of character
    for a=1 to lastquestguy
        if questguy(a).talkedto=1 then 'Player knows
            if questguy(i).knows(a)=0 then 'character doesnt
                if questguy(i).want.type=qt_stationimp and (questguy(a).job=17 or questguy(a).has.type=qt_stationimp) then
                    t=qt_stationimp
                    return a
                endif
            endif
        endif
    next
    
    'Location of planet
    for a=0 to laststar
        if map(a).discovered>0 and questguy(i).systemsknown(a)=0 then
            for b=1 to 9
                if map(a).planets(b)>0 and map(a).planets(b)<=max_maps then
                    if planets(map(a).planets(b)).discovered<>0 then
                        if questguy(i).want.type=qt_locofpirates then
                            for c=0 to _nopb
                                if piratebase(c)=map(a).planets(b) then
                                    t=qt_locofpirates
                                    return map(a).planets(b)
                                endif
                            next
                        endif
                        if questguy(i).want.type=qt_locofgarden then
                            if isgardenworld(map(a).planets(b))=-1 then
                                t=qt_locofgarden
                                return map(a).planets(b)
                            endif
                        endif
                        if questguy(i).want.type=qt_locofspecial then
                            if is_special(map(a).planets(b))=-1 then
                                t=qt_locofspecial
                                return map(a).planets(b)
                            endif
                        endif
                    endif
                endif
            next
        endif
    next
    
    
    'Info
    
'        
'    qt_showconcept
'    qt_stationsensor
'    qt_message
'    qt_locofpirates
'    qt_locofspecial
'    qt_locofgarden
'    qt_locofperson
'    qt_goodpaying
'    qt_research
'    qt_stationneeds
'    qt_megacorp
'    qt_biodata
'    qt_anomaly
'    qt_murderclients
'    qt_juryrig
'    qt_wormhole
'    qt_crime
'    qt_whereperform
'    qt_haswantsloc
'        if questguy(i).want.it.v1<0 then
'            if item(a).ty=questguy(i).want.it.ty and item(a).v1=abs(questguy(i).want.it.v1) and item(a).w.s=-1 then 
'                if item(a).ty=57 then item(a).price=rnd_range(1,6)*50 'Autograph
'                return a
'            endif
'        else
'            if item(a).ty=questguy(i).want.it.ty and item(a).v1>=questguy(i).want.it.v1 and item(a).w.s=-1 then 
'                t=qt_EI
'                return a
'            endif
'        endif
    'next
    t=-1
    return -1
end function


function get_highestrisk_questguy(st as short) as short
    dim as short r,high,j
    for j=1 to lastquestguy
        if questguy(j).location=st then
            if questguy(j).risk>high then
                r=j
                high=questguy(j).risk
            endif
        endif
    next
    return r
end function


#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tPeople -=-=-=-=-=-=-=-
	tModule.register("tPeople",@tPeople.init()) ',@tPeople.load(),@tPeople.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tPeople -=-=-=-=-=-=-=-
#endif'test
