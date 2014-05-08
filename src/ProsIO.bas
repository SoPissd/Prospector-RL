

'function display_planetmap(slot as short,osx as short,bg as byte) as short
'
'    dim x as short
'    dim y as short
'    dim b as short
'    dim x2 as short
'    dim debug as byte
'
'    for x=_mwx to 0 step-1
'        for y=0 to 20
'            x2=x+osx
'            if x2>60 then x2=x2-61
'            if x2<0 then x2=x2+61
'            if planetmap(x2,y,slot)>0 then
'                if tmap(x2,y).no=0 then tmap(x2,y)=tiles(planetmap(x2,y,slot))
'                dtile(x,y,tmap(x2,y),bg)
'#if __FB_DEBUG__
'                draw string(x,y),""&planetmap(x2,y,slot)
'#endif
'            endif
'            if itemindex.last(x2,y)>0 then
'                for b=1 to itemindex.last(x2,y)
'                    display_item(itemindex.index(x2,y,b),osx,slot)
'                next
'            endif
'        next
'    next
'
'    display_portals(slot,osx)
'
'#if __FB_DEBUG__
'    if lastapwp>0 then
'        for b=0 to lastapwp
'            if apwaypoints(b).x-osx>=0 and apwaypoints(b).x-osx<=_mwx then
'                set__color( 11,0)
'                draw string((apwaypoints(b).x-osx)*_tix,apwaypoints(b).y*_tiy),""& b,,Font1,custom,@_col
'            endif
'        next
'    endif
'#endif
'
'    return 0
'end function


'function getshipweapon() as short
'    dim as short a,b,c
'    dim p(7) as short
'    dim t as string
'    t="Chose weapon/"
'    for a=1 to 5
'        if player.weapons(a).dam>0 then
'            b=b+1
'            p(b)=a
'            t=t &player.weapons(a).desig & "/"
'        endif
'    next
'    b=b+1
'    p(b)=-1
'    t=t &"Cancel"
'    c=b-1
'    if b>1 then c=p(menu(t))
'    return c
'end function


