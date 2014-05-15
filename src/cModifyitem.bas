'tModifyitem.
'
'defines:
'modify_item=0
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
'     -=-=-=-=-=-=-=- TEST: tModifyitem -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tModifyitem -=-=-=-=-=-=-=-


'private function modify_item(i as _items,nomod as byte) as _items

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tModifyitem -=-=-=-=-=-=-=-

namespace tModifyitem
function init() as Integer
	return 0
end function
end namespace'tModifyitem


#define cut2top


function modify_item(i as _items,nomod as byte) as _items
    dim as short a,rate
    rate=500-disnbase(player.c)
    if rate<100 then rate=100
    a=i.id
    if i.id>=13 and i.id<=19 and nomod=0 then
        if rnd_range(1,100)<10+tVersion.gameturn/rate then
        if rnd_range(1,100)<50+tVersion.gameturn/rate then
            i.desig="thick "&i.desig
            i.desigp="thick "&i.desigp
            i.id=i.id+1000
            i.v1=i.v1+1
            i.price=i.price*1.2
        else
            if i.v1>1 then
                i.desig="old "&i.desig
                i.desigp="old "&i.desigp
                i.id=i.id+1100
                i.v1=i.v1-1
                i.price=i.price*0.8
            endif
        endif
        endif
    endif
    
    if i.id>=13 and i.id<=21 then
        if rnd_range(1,100)<10+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)+tVersion.gameturn/rate<66 then
                i.desig="camo "&i.desig
                i.desigp="camo "&i.desigp
                i.v2=1
                i.id=i.id+1200
                i.price=i.price*1.1
            else
                i.desig="imp. camo "&i.desig
                i.desigp="imp. camo "&i.desigp
                i.id=i.id+1300
                i.v2=3
                i.price=i.price*1.25
            endif
        endif
        if rnd_range(1,100)<15+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)+tVersion.gameturn/rate<75 then
                i.desig="sturdy "&i.desig
                i.desigp="sturdy "&i.desigp
                i.res=i.res+50
                i.id=i.id+1400
                i.price=i.price*1.1
            else
                i.desig="acidproof "&i.desig
                i.desigp="acidproof "&i.desigp
                i.res=i.res+100
                i.id=i.id+1500
                i.price=i.price*1.25
            endif
        endif
    endif
    
    if i.ty=3 or i.ty=103 then
        if rnd_range(1,100)<15+tVersion.gameturn/rate and nomod=0 then
            i.v3=i.v3*1.1
            i.price=i.price*1.1
        endif
    endif
    
    if i.id>=3 and i.id<=11 then
        if rnd_range(1,100)<10+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)<50 then
                if rnd_range(1,100)+tVersion.gameturn/rate<75 then
                    i.desig="balanced "&i.desig
                    i.desigp="balanced "&i.desigp
                    i.id=i.id+1000
                    i.v3=i.v3+1
                    i.price=i.price*1.2
                else
                    i.desig="well balanced "&i.desig
                    i.desigp="well balanced "&i.desigp
                    i.id=i.id+1100
                    i.v3=i.v3+2
                    i.price=i.price*1.5
                endif
            else
                if rnd_range(1,100)+tVersion.gameturn/rate<75 then
                    i.desig="powerful "&i.desig
                    i.desigp="powerful "&i.desigp
                    i.id=i.id+1200
                    i.v1=i.v1+.1
                    i.price=i.price*1.2
                else
                    i.desig="very powerful "&i.desig
                    i.desigp="very powerful "&i.desigp
                    i.id=i.id+1300
                    i.v1=i.v1+.2
                    i.price=i.price*1.5
                endif
            endif
        endif
        if rnd_range(1,100)<15+tVersion.gameturn/rate then
            if rnd_range(1,100)+tVersion.gameturn/rate<75 then
                i.desig="sturdy "&i.desig
                i.desigp="sturdy "&i.desigp
                i.res=i.res+50
                i.id=i.id+1400
                i.price=i.price*1.1
            else
                i.desig="acidproof "&i.desig
                i.desigp="acidproof "&i.desigp
                i.res=i.res+100
                i.id=i.id+1500
                i.price=i.price*1.25
            endif
        endif
    endif
    
    if i.id=1 then
        if rnd_range(1,100)<20+tVersion.gameturn/rate  and nomod=0 then
            if rnd_range(1,100)+tVersion.gameturn/rate<50 then
                i.desig="small "&i.desig
                i.desigp="small "&i.desigp
                i.v2=4
                i.price=i.v2*115
                i.id=101
            else
                i.desig="large "&i.desig
                i.desigp="large "&i.desigp
                i.v2=6
                i.price=i.v2*85
                i.id=102
            endif
        endif
        i.ldesc="A platform held aloft by aircushions. It can transport up to "&i.v2 &" persons and cross water. Going up mountains is impossible though"
    endif
    
    
    if i.id=2 then
        if rnd_range(1,100)<20+tVersion.gameturn/rate  and nomod=0 then
            if rnd_range(1,100)+tVersion.gameturn/rate<50 then
                i.id=211
                i.desig="efficient "&i.desig
                i.desigp="efficient "&i.desigp
                i.price=i.price*1.2
                i.v3=.8
                i.ldesc=i.ldesc &" This particular one has a very efficient fuel system."
            else
                i.id=212
                i.desig="inefficient "&i.desig
                i.desigp="inefficient "&i.desigp
                i.price=i.price*0.8
                i.v3=1.2
                i.ldesc=i.ldesc &" This particular one needs more fuel."
            endif
        endif
    endif
    if i.id>=40 and i.id<=47 then
        if rnd_range(1,100)<10+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)<50 then
                if rnd_range(1,100)+tVersion.gameturn/rate<75 then
                    i.desig="balanced "&i.desig
                    i.desigp="balanced "&i.desigp
                    i.id=i.id+100
                    i.v3=i.v3+1
                    i.price=i.price*1.2
                else
                    i.desig="well balanced "&i.desig
                    i.desigp="well balanced "&i.desigp
                    i.id=i.id+110
                    i.v3=i.v3+2
                    i.price=i.price*1.5
                endif
            else
                if rnd_range(1,100)+tVersion.gameturn/rate<75 then
                    i.desig="sharp "&i.desig
                    i.desigp="sharp "&i.desigp
                    i.id=i.id+120
                    i.v1=i.v1+.1
                    i.price=i.price*1.2
                else
                    i.desig="very sharp "&i.desig
                    i.desigp="very sharp "&i.desigp
                    i.id=i.id+130
                    i.v1=i.v1+.2
                    i.price=i.price*1.5
                endif
            endif
        endif
        if rnd_range(1,100)<15+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)+tVersion.gameturn/rate<75 then
                i.desig="sturdy "&i.desig
                i.desigp="sturdy "&i.desigp
                i.res=i.res+50
                i.price=i.price*1.1
            else
                i.desig="acidproof "&i.desig
                i.desigp="acidproof "&i.desigp
                i.res=i.res+100
                i.price=i.price*1.25
            endif
        endif
    endif
    
    if i.id=49 then 'tanks
        if rnd_range(1,100)<30+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)<50+tVersion.gameturn/rate then
                i.id=i.id+100
                i.desig="big "&i.desig
                i.desigp="big "&i.desigp
                i.v1=30
                i.price=12
            else
                i.id=i.id+110
                i.desig="small "&i.desig
                i.desigp="small "&i.desigp
                i.v1=20
                i.price=8
            endif
        endif
    endif
    if i.id=97 then
        if rnd_range(1,100)<33+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)<50 then
                if rnd_range(1,100)+tVersion.gameturn/rate<50 then
                    i.desig="balanced "&i.desig
                    i.desigp="balanced "&i.desigp
                    i.id=i.id+100
                    i.v3=i.v3+1
                    i.price=i.price*1.2
                else
                    i.desig="well balanced "&i.desig
                    i.desigp="well balanced "&i.desigp
                    i.id=i.id+101
                    i.v3=i.v3+2
                    i.price=i.price*1.5
                endif
            else
                if rnd_range(1,100)+tVersion.gameturn/rate<50 then
                    i.desig="powerful "&i.desig
                    i.desigp="powerful "&i.desigp
                    i.id=i.id+102
                    i.v1=i.v1+.1
                    i.price=i.price*1.2
                else
                    i.desig="very powerful "&i.desig
                    i.desigp="very powerful "&i.desigp
                    i.id=i.id+103
                    i.v1=i.v1+.2
                    i.price=i.price*1.5
                endif
            endif
        endif
    
    endif
    if i.id=98 or i.id=523 then 
        if rnd_range(1,100)<30+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)<5+tVersion.gameturn/rate then
                if rnd_range(1,100)<50+tVersion.gameturn/rate then
                    i.desig="thick "&i.desig
                    i.desigp="thick "&i.desigp
                    i.id=i.id+200
                    i.v1=i.v1+1
                    i.price=i.price*1.5
                else
                    i.desig="tattered "&i.desig
                    i.desigp="tattered "&i.desigp
                    i.id=i.id+201
                    i.v1=i.v1-1
                    i.price=i.price*0.75
                endif
            endif
        endif
    endif
    
    if i.ty=18 then
        if rnd_range(1,100)<30+tVersion.gameturn/rate and nomod=0 then
            if rnd_range(1,100)<50+tVersion.gameturn/rate then
                i.desig="fast "&i.desig
                i.desigp="fast "&i.desigp
                i.v4+=1
                i.id+=600
                i.price=i.price*1.2
            else
                i.desig="slow "&i.desig
                i.desigp="slow "&i.desigp
                i.v4-=1
                i.id+=610
                i.price=i.price*0.8
            endif
        endif
    endif
    
    return i
end function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tModifyitem -=-=-=-=-=-=-=-
	tModule.register("tModifyitem",@tModifyitem.init()) ',@tModifyitem.load(),@tModifyitem.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tModifyitem -=-=-=-=-=-=-=-
#endif'test
