'tBones.
'
'defines:
'getbonesfile=0, load_bones=2, save_bones=1
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tBones -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tBones -=-=-=-=-=-=-=-

declare function load_bones() as short
declare function save_bones(t as short) as short

'private function getbonesfile() as string

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tBones -=-=-=-=-=-=-=-

namespace tBones
function init() as Integer
	return 0
end function
end namespace'tBones


#define cut2top


function getbonesfile() as string
    dim s as string
    dim d as string
    dim as short chance
    d=dir$("bones/*.bon")
    chance=10
    do
        d=dir()
        chance=chance+1
    loop until d=""
    if _debug_bones=2 then 
		DbgPrint("chance for bones file:"&chance)
    EndIf
    d=dir$("bones/*.bon")
    do
        if (rnd_range(1,100)<chance or _debug_bones=1) and s="" then s=d
        d=dir()
    loop until d=""
    return s
end function


function load_bones() as short
    dim s as string
    dim as short d,c,m,f,sys
    dim as _cords p
    dim as _planet pl
    s=getbonesfile
    if s<>"" then
        f=freefile
        open "bones/"&s for binary as #f
        get #f,,pl
        if pl.depth=0 then
            do
                sys=get_random_system
                m=getrandomplanet(sys)
            loop until m>0 and isgasgiant(m)=0 and is_special(m)=0
            BonesFlag=m
            for x=0 to 60
                for y=0 to 20
                    get #f,,planetmap(x,y,m)
                    if _debug_bones=1 then planetmap(x,y,m)=-planetmap(x,y,m)
                next
            next
            map(sys).discovered=4
        else
            sys=rnd_range(1,lastportal)
            m=portal(sys).dest.m
            for x=0 to 60
                for y=0 to 20
                    get #f,,planetmap(x,y,m)
                    if _debug_bones=1 then planetmap(x,y,m)=-planetmap(x,y,m)
                next
            next
            p=rnd_point(m,0)
            portal(sys).dest.x=p.x
            portal(sys).dest.y=p.y
            map(sysfrommap(portal(sys).from.m)).discovered=4
        endif
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,m)>0 then planetmap(x,y,m)=planetmap(x,y,m)*-1
            next
        next
        planets(m).visited=0
        get #f,,d
        for c=lastitem+1 to lastitem+1+d
            if c>0 and c<=25000 then
                get #f,,item(c)
                item(c).w.m=m
            endif
        next
        lastitem=lastitem+1+d
        close #f
        planets(m)=pl
        planets(m).visited=_debug_bones
        planets_flavortext(m)="You get a wierd sense of deja vu from this place."
        kill "bones/"&s
    endif
    return 0
end function


function save_bones(t as short) as short
    dim f as integer
    dim as short x,y,a,b
    dim as _cords team
    dim bones_item(64) as _items
    if is_special(player.landed.m) then return 0
    if is_drifter(player.landed.m) then return 0
    if planets(player.landed.m).depth=0 then planetmap(player.landed.x,player.landed.y,player.landed.m)=127+player.h_no
    f=freefile
    open "bones/"&player.desig &".bon" for binary as #f
    put #f,,planets(player.landed.m)
    for x=0 to 60
        for y=0 to 20
            if planetmap(x,y,player.landed.m)>0 then planetmap(x,y,player.landed.m)=-planetmap(x,y,player.landed.m)
            put #f,,planetmap(x,y,player.landed.m)
        next
    next
    team=awayteam.c
    for a=0 to lastitem
        if item(a).w.s=-1 and rnd_range(1,100)<25 then
            b+=1
            item(a).w.s=0
            item(a).w.p=0
            item(a).w.x=player.landed.x
            item(a).w.y=player.landed.y
            if rnd_range(1,100)<25 then item(a).w=movepoint(item(a).w,5)
            if b<=64 then bones_item(b)=item(a)
        endif
    next
    b+=1
    if b>64 then b=64
    bones_item(b)=make_item(81)
    bones_item(b).ldesc="The Id-tag of Captain  "&crew(1).n &" of the "&player.desig
    bones_item(b).w.x=team.x
    bones_item(b).w.y=team.y

    put #f,,b
    for a=1 to b
        put #f,,bones_item(a)
    next
    close #f
    return 0
end function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tBones -=-=-=-=-=-=-=-
	tModule.register("tBones",@tBones.init()) ',@tBones.load(),@tBones.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tBones -=-=-=-=-=-=-=-
#endif'test
