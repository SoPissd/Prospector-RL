'tSlotmachine.
'
'defines:
'play_slot_machine=1
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
'     -=-=-=-=-=-=-=- TEST: tSlotmachine -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tSlotmachine -=-=-=-=-=-=-=-

declare function play_slot_machine() as short


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tSlotmachine -=-=-=-=-=-=-=-

namespace tSlotmachine
function init() as Integer
	return 0
end function
end namespace'tSlotmachine


#define cut2top


function play_slot_machine() as short
    DimDebugL(0)
    dim as short bet,win,a,b,c,d
    do
        set__color(11,0)
        cls
        display_ship
        rlprint "How much do you want to bet(0-100)"
        bet=getnumber(0,100,0)
        if bet>player.money then bet=0
        if bet>0 then
            player.money=player.money-bet
            a=rnd_range(1,9)
            b=rnd_range(1,9)
            c=rnd_range(1,9)
            for d=1 to 10+rnd_range(1,6) + rnd_range(1,6)
                if rnd_range(1,100)>33 then a+=1
                if rnd_range(1,100)>33 then b+=1
                if rnd_range(1,100)>33 then c+=1
                
                if a>9 then a=1
                if b>9 then b=1
                if c>9 then c=1
                if configflag(con_tiles)=0 then
                    line (45*_fw2+1*_tix,10*_tiy)-(45*_fw2+3*_tix,11*_tiy),rgba(0,0,0,255),bf
                    
                    put (45*_fw2+1*_tix,10*_tiy),gtiles(a+68),trans
                    put (45*_fw2+2*_tix,10*_tiy),gtiles(b+68),trans
                    put (45*_fw2+3*_tix,10*_tiy),gtiles(c+68),trans
                else
                    if a<8 then
                        set__color( spectraltype(a),0)
                        draw string (45*_fw2+1*_fh1,10*_fw1),"*",,font1,custom,@_col
                    else
                        if a=8 then set__color( 7,0)
                        if a=9 then set__color( 179,0)
                        draw string (45*_fw2+1*_fh1,10*_fw1),"o",,font1,custom,@_col
                    endif
                    
                    
                    if b<8 then
                        set__color( spectraltype(b),0)
                        draw string (45*_fw2+2*_fh1,10*_fw1),"*",,font1,custom,@_col
                    else
                        if b=8 then set__color( 7,0)
                        if b=9 then set__color( 179,0)
                        draw string (45*_fw2+2*_fh1,10*_fw1),"o",,font1,custom,@_col
                    endif
                    
                    
                    if c<8 then
                        set__color( spectraltype(c),0)
                        draw string (45*_fw2+3*_fh1,10*_fw1),"*",,font1,custom,@_col
                    else
                        if c=8 then set__color( 7,0)
                        if c=9 then set__color( 179,0)
                        draw string (45*_fw2+3*_fh1,10*_fw1),"o",,font1,custom,@_col
                    endif
                    
                endif
                sleep 50+d*10
            next
            win=0
            if a=b and b=c then win=(a)*2+1
            if (a=b or b=c or a=c) and win=0 then win=1
            if (a=9 or b=9 or c=9) then win=win+1
            
            if win=0 then
                rlprint "You lose "& bet &" Cr."
            else
                
                addmoney(bet*win,mt_gambling)
                rlprint "You win "& bet*win &" Cr."
            endif
            if debug=0 then sleep
        endif
    loop until bet<=0
    
    return 0
end function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tSlotmachine -=-=-=-=-=-=-=-
	tModule.register("tSlotmachine",@tSlotmachine.init()) ',@tSlotmachine.load(),@tSlotmachine.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tSlotmachine -=-=-=-=-=-=-=-
#endif'test
