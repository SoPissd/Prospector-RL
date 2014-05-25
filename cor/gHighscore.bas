'tHighscore.

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
'     -=-=-=-=-=-=-=- TEST: tHighscore -=-=-=-=-=-=-=-
#undef intest
#define test
#endif'test


#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
Type _table
    points As Integer
    desig As String *80
    death As String *80
End Type
#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tHighscore -=-=-=-=-=-=-=-

declare function high_score(text as string) as short

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tHighscore -=-=-=-=-=-=-=-

namespace tHighscore
function init(iAction as integer) as integer
	return 0
end function
end namespace'tHighscore


function high_score(text as string) as short
    dim hScore(11) as _table
    dim in as integer=1
    dim key as string
    dim rank as integer
    dim offset as integer
    dim off2 as integer
    dim store as _table
    dim f as integer
    dim a as integer
    dim s as integer
    dim as short xo,yo,sp
    'open hScore table
    f=freefile
    open "highscore" for binary as f
    for a=1 to 10
        get #f,,hScore(a)
    next        
    close f
    'edit hScore table
    rank=1
    if tVersion.Gamedesig<>"" then
        
        'post_mortemII(text)
        '
        'if tVersion.Gamescore=0 then 
        '    s=score()
        'else
        '    s=player.score
        'endif
        '
        'for a=1 to 10
        '    if hScore(a).points>s then rank=rank+1
        'next
        'if rank<10 then
        '    for a=9 to rank step -1
        '        hScore(a+1)=hScore(a)
        '    next
        'endif
        'if rank<11 then
        '    hScore(rank).points=s
        '    hScore(rank).desig=player.desig &" ("&date_string &"), "& ltrim(player.h_desig) &", " &credits(player.money) &" Cr."            
        '    hScore(rank).death=get_death
        'endif
    else
        rank=-1
    endif
    'display hScore table
    offset=rank

    cls
    tGraphics.background()    
    set__color( 11,0)
    
    if tScreen.isGraphic then
	    yo=(tScreen.y-22*_fh2)/2
	    xo=(tScreen.x-80*_fw2)/2
	    for a=yo/2-_fh2 to tScreen.y-yo/2+_fh2 step _fh2-1
	        draw_string (xo,a,space(80),font2,_col)
	    next
	    set__color( 15,0)
	    draw_string (2*_fw2+xo,yo/2,"10 MOST SUCCESSFUL MISSIONS",Titlefont,_col)
	    
	    for a=1 to 10
	        if a=rank then 
	            set__color( 15,0)
	        else
	            set__color( 11,0)
	        endif
	        sp=73-len(a &".)")-len(trim(hScore(a+off2).desig))-len(hScore(a+off2).points &" pts.")
	        
	        draw_string (2*_fw2+xo,yo+(a*2)*_fh2, a & ".) " & trim(hScore(a+off2).desig) & ", "  & space(sp)&credits( hScore(a+off2).points) &" pts." ,font2,_col)
	        
	        if a=rank then
	            set__color( 14,0)
	        else
	            set__color( 7,0)
	        endif
	        draw_string (2*_fw2+xo,yo+(a*2+1)*_fh2, trim(hScore(a+off2).death),font2,_col)
	    next
	    set__color( 11,0)
	    if rank>10 then draw_string (2*_fw2+xo,tScreen.y-yo, hScore(10).points &" Points required to enter highscore. you scored "&s &" Points",font2,_col)
	    draw_string (2*_fw2+xo,tScreen.y-yo/2, "Esc to continue",font2,_col)
    else
	    yo=(tScreen.y-22)/2
	    xo=(tScreen.x-80)/2
	    for a=yo/2-_fh2 to tScreen.y-yo/2+_fh2 step _fh2-1
	        draw_string (xo,a,space(80),font2,_col)
	    next
	    set__color( 15,0)
	    tScreen.xy(2+xo,yo/2,"10 MOST SUCCESSFUL MISSIONS")',Titlefont,_col)
	    
	    for a=1 to 10
	        if a=rank then 
	            set__color( 15,0)
	        else
	            set__color( 11,0)
	        endif
	        sp=73-len(a &".)")-len(trim(hScore(a+off2).desig))-len(hScore(a+off2).points &" pts.")
	        
	        tScreen.xy(2+xo,yo+(a*2), a & ".) " & trim(hScore(a+off2).desig) & ", "  & space(sp)&credits( hScore(a+off2).points) &" pts.")',font2,_col)
	        
	        if a=rank then
	            set__color( 14,0)
	        else
	            set__color( 7,0)
	        endif
	        tScreen.xy(2+xo,yo+(a*2+1), trim(hScore(a+off2).death))',font2,_col)
	    next
	    set__color( 11,0)
	    if rank>10 then tScreen.xy(2+xo,tScreen.y-yo, hScore(10).points &" Points required to enter highscore. you scored "&s &" Points")',font2,_col)
	    tScreen.xy(2+xo,tScreen.y-yo/2, "Esc to continue")',font2,_col)
    EndIf

    no_key=uConsole.keyinput(key__esc)'    keyin(key__esc)


    'save highscore table
    f=freefile    
    'open highscore table
    in=1
    open "highscore" for binary as f
      for a=1 to 10  
        put #f,,hScore(a)        
      next
    close f
    cls
    return 0
end function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tHighscore -=-=-=-=-=-=-=-
	tModule.register("tHighscore",@tHighscore.init()) ',@tHighscore.load(),@tHighscore.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tHighscore -=-=-=-=-=-=-=-
#endif'test
