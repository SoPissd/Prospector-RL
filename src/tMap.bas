'tMap

function load_map(m as short,slot as short)as short
    dim as short f,b,x,y
    f=freefile
    open "data/deckplans.dat" for binary as #f
    for b=1 to m
        for x=0 to 60
            for y=0 to 20
                get #f,,planetmap(x,y,slot)
                planetmap(x,y,slot)=-planetmap(x,y,slot)
            next
        next
    next
    close #f
    return 0
end function



function explored_percentage_string() as string
    dim as short x,y,ex
    for x=0 to sm_x
        for y=0 to sm_y
            if spacemap(x,y)>0 then ex+=1
        next
    next
    if ex<(sm_x*sm_y) then
        return "Explored {15}"&ex &"{11} parsec ({15}"& int(ex/(sm_x*sm_y)*100) &" %{11} of the sector)"
    else
        return "Explored the complete sector."
    endif
end function



function isbuilding(x as short,y as short,map as short) as short 
    if abs(planetmap(x,y,map))=16 then return -1
    if abs(planetmap(x,y,map))=68 then return -1
    if abs(planetmap(x,y,map))=69 then return -1
    if abs(planetmap(x,y,map))=70 then return -1
    if abs(planetmap(x,y,map))=71 then return -1
    if abs(planetmap(x,y,map))=72 then return -1
    if abs(planetmap(x,y,map))=74 then return -1
    if abs(planetmap(x,y,map))=98 then return -1
    if abs(planetmap(x,y,map))=237 then return -1
    if abs(planetmap(x,y,map))=238 then return -1
    if abs(planetmap(x,y,map))=261 then return -1
    if abs(planetmap(x,y,map))=262 then return -1
    if abs(planetmap(x,y,map))=266 then return -1
    if abs(planetmap(x,y,map))=268 then return -1
    if abs(planetmap(x,y,map))=294 then return -1
    if abs(planetmap(x,y,map))=299 then return -1
    if abs(planetmap(x,y,map))=300 then return -1
    if abs(planetmap(x,y,map))=301 then return -1
    if abs(planetmap(x,y,map))=302 then return -1
    return 0
end function



function get_colony_building(map as short) as _cords
    dim p(255) as _cords
    dim as short x,y,x1,y1,i
    dim cand(60,20) as short
    p(255).x=-1
    p(255).y=-1
    for x=0 to 60
        for y=0 to 20
            if isbuilding(x,y,map)=-1 then
                for x1=x-2 to x+2
                    for y1=y-2 to y+2
                        if x1>=0 and x1<=60 and y1>=0 and y1<=20 then
                            if x1=x-2 or x1=x+2 or y1=y-2 or y1=y+2 then
                                cand(x1,y1)=1
                            else
                                cand(x1,y1)=0
                            endif
                        endif
                    next
                next
            endif
        next
    next
    for x=0 to 60
        for y=0 to 20
            if cand(x,y)=1 and tiles(abs(planetmap(x,y,map))).walktru=0 and i<255 then 
                i+=1
                p(i).x=x
                p(i).y=y
            endif
        next
    next
    if i=0 then        
        for x=0 to 60
            for y=0 to 20
                if cand(x,y)=1 then 
                    i+=1
                    p(i).x=x
                    p(i).y=y
                endif
            next
        next
    endif
    
    if i=0 then return p(255)
    
    return p(rnd_range(1,i))
end function

function remove_building(map as short) as short
    dim as _cords p(255),c
    dim as short i,j
    for x=0 to 60
        for y=0 to 20
            if isbuilding(x,y,map)=-1 then 
                if abs(planetmap(x,y,map))>=299 then
                    p(255).x=x
                    p(255).y=y
                else
                    i+=1
                    p(i).x=x
                    p(i).y=y
                endif
            endif
        next
    next
    if i>0 then 
        j=rnd_range(1,i)
     else
         j=255
         planets(map).colflag(0)=-1
     endif
     planetmap(p(j).x,p(j).y,map)=76
     return 0
 end function
 

function closest_building(p as _cords,map as short) as _Cords
    dim as short x,y,i,j
    dim as single d
    dim as _cords points(1281),result
    for x=0 to 60
        for y=0 to 20
            if isbuilding(x,y,map)=-1 then
                i+=1
                points(i).x=x
                points(i).y=y
            endif
        next
    next
    d=9999
    for j=1 to i
        if distance(p,points(j))<d and (points(j).x<>p.x or points(j).y<>p.y) then
            d=distance(p,points(j))
            result=points(j)
        endif
    next
    return result
end function


