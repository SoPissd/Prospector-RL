'tSpecialPlanet


function make_special_planet(a as short) as short
    DimDebugL(0)
    dim as short x,y,b,c,d,b1,b2,b3,cnt,wx,wy,ti,x1,y1
    dim as _cords p,p1,p2,p3,p4,p5
    dim as _cords pa(5)
    dim as _rect r
    dim as _cords gc,gc1
    dim it as _items
    dim addship as _driftingship

    ' UNIQUE PLANETS
    '
    for b=0 to lastspecial
        if a=specialplanet(b) then
            planets(a).temp=22+rnd_range(2,20)/10
            planets(a).rot=1
            planets(a).grav=1
            planets(a).atmos=7
        endif
    next
    
    if a=specialplanet(0) then
        makemossworld(a,3)
    endif
    
    if a=specialplanet(1) then 'apollos temple
        planetmap(rnd_range(1,60),rnd_range(0,20),a)=-56
        planets_flavortext(a)="A huge guy in a robe claims to be apollo and demands you to worship him. He seems a little agressive. Also your ship suddenly disappears."        
    endif
    
    if a=specialplanet(2) then 'Defense town
        deletemonsters(a)
        for x=0 to 60
            for y=0 to 20
                if rnd_range(1,100)<90 then
                    if rnd_range(1,100)<20 then
                        planetmap(x,y,a)=-3
                    else
                        planetmap(x,y,a)=-4
                    endif
                else
                    planetmap(x,y,a)=-14
                endif
            next
        next
        for y=0 to 20
            p1=rnd_point
            for x=0 to rnd_range(1,5)+5
                planetmap(p1.x,p1.y,a)=-7
                p1=movepoint(p1,5)
            next
        next
        p1=rnd_point
        for x=0 to rnd_range(1,5)+5
            planetmap(p1.x,p1.y,a)=-16
            p1=movepoint(p1,5)
        next
        p1=movepoint(p1,5)
        planetmap(p1.x,p1.y,a)=-100
        p1=movepoint(p1,5)
        planetmap(p1.x,p1.y,a)=-4
        
        lastplanet=lastplanet+1
        
        gc.x=p1.x
        gc.y=p1.y
        gc.m=a
        gc1.x=rnd_range(2,58)
        gc1.y=rnd_range(2,18)
        gc1.m=lastplanet
        makecomplex(gc1,1,1)
        
        addportal(gc,gc1,0,asc("#"),"A building still in good condition",15)
        p1=rnd_point(lastplanet,0)
        planetmap(p1.x,p1.y,lastplanet)=-167
        p1=rnd_point
        planetmap(p1.x,p1.y,a)=-100
        for x=0 to rnd_range(1,6)+rnd_range(1,6)
            p1=rnd_point
            planetmap(p1.x,p1.y,a)=-127-rnd_range(1,10)
        next
        planets(a).atmos=6
        planets(lastplanet).atmos=6
        p1=rnd_point
        planetmap(p1.x,p1.y,a)=-168
    endif
    
    if a=specialplanet(3) or a=specialplanet(4) or a=specialplanet(28) then 'cityworld
        deletemonsters(a)
        planets(a).depth=5
        lastportal=lastportal+1
        portal(lastportal).desig="A building still in good condition. "
        portal(lastportal).tile=asc("#")
        portal(lastportal).col=15
        portal(lastportal).from.m=a
        portal(lastportal).from.x=rnd_range(0,60)
        portal(lastportal).from.y=rnd_range(0,20)
        portal(lastportal).dest.m=lastplanet+1
        'specialplanet(11)=portal(lastportal).dest.m
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_portals
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        lastplanet=lastplanet+1
        makecomplex(portal(lastportal).dest,0)
        for b=0 to rnd_range(1,6)+rnd_range(1,6)
            placeitem(rnd_item(RI_StrandedShip),rnd_range(0,60),rnd_range(0,20),a)
        next
        makelabyrinth(a)
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)<>-4 then 
                    planetmap(x,y,a)=-16
                else
                    planetmap(x,y,a)=-31
                    if rnd_range(1,100)>50 then planetmap(x,y,a)=-32
                    if rnd_range(1,100)>50 then planetmap(x,y,a)=-33
                endif
            next
        next
        
        
        'roads
        'round the corners
        for x=1 to 59
            for y=1 to 19
                if planetmap(x,y,a)<-30 then
                    if planetmap(x-1,y,a)<-30 or planetmap(x+1,y,a)<-30 then planetmap(x,y,a)=-32
                    if planetmap(x,y-1,a)<-30 or planetmap(x,y+1,a)<-30 then planetmap(x,y,a)=-31
                    
                    if planetmap(x-1,y,a)<-30 and planetmap(x,y+1,a)<-30 then 'bow down
                        planetmap(x,y,a)=-34
                    endif
                    if planetmap(x-1,y,a)<-30 and planetmap(x,y-1,a)<-30 then 'bow up
                        planetmap(x,y,a)=-35
                    endif
                    if planetmap(x+1,y,a)<-30 and planetmap(x,y+1,a)<-30 then 'bow down
                        planetmap(x,y,a)=-36
                    endif
                    if planetmap(x+1,y,a)<-30 and planetmap(x,y-1,a)<-30 then 'bow up
                        planetmap(x,y,a)=-37
                    endif
                    
                    
                    if planetmap(x-1,y,a)<-30 and planetmap(x,y+1,a)<-30 and planetmap(x,y-1,a)<-30 then 'bow down
                        planetmap(x,y,a)=-38
                    endif
                    if planetmap(x,y+1,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x+1,y,a)<-30 then 'bow up
                        planetmap(x,y,a)=-39
                    endif
                    if planetmap(x+1,y,a)<-30 and planetmap(x,y+1,a)<-30 and planetmap(x-1,y,a)<-30 then 'bow down
                        planetmap(x,y,a)=-40
                    endif
                    if planetmap(x+1,y,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x-1,y,a)<-30then 'bow up
                        planetmap(x,y,a)=-41
                    endif
                    
                    if planetmap(x-1,y,a)<-30 and planetmap(x+1,y,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x,y+1,a)<-30 then
                        planetmap(x,y,a)=-33
                    endif
                endif
            next
        next
        
        for x=0 to 55+rnd_range(1,10)
            do
                p2=rnd_point
            loop until planetmap(p2.x,p2.y,a)<-30
            planetmap(p2.x,p2.y,a)=-16
        next
        
        
        for x=0 to rnd_range(1,5)+1
            p2=rnd_point
            planetmap(p2.x,p2.y,a)=-100
        next
        
        for x=0 to rnd_range(1,5)+1
            placeitem(make_item(96,planets(a).depth+disnbase(player.c)\5,planets(a).depth+disnbase(player.c)\6),rnd_range(0,60),rnd_range(0,20),a)
        next
        
        if specialplanet(3)=a then            
            for x=0 to rnd_range(1,5)+20
                planetmap(rnd_range(0,60),rnd_range(0,20),a)=-18
            next    
            planetmap(rnd_range(0,60),rnd_range(0,20),a)=-17
        endif
        
        if a=specialplanet(28) then
            for b=0 to 1
                p=rnd_point
                if p.x>=52 then p.x=51
                if p.y>=15 then p.y=14
                for x=p.x to p.x+8
                    for y=p.y to p.y+5
                        planetmap(x,y,a)=-68
                    next
                next
            next
            p.x=rnd_range(p.x,p.x+10)
            p.y=rnd_range(p.y,p.y+5)
            planetmap(p.x,p.y,a)=-241
            'Unused
        endif
        
        planets(a).mon_template(0)=makemonster(8,a)
        planets(a).mon_noamin(0)=4
        planets(a).mon_noamax(0)=10
        
        
        planets(a).mon_template(1)=makemonster(53,a)
        planets(a).mon_noamin(1)=5
        planets(a).mon_noamax(1)=10
        
        planets(a).mon_template(2)=makemonster(54,a)
        planets(a).mon_noamin(2)=5
        planets(a).mon_noamax(2)=10
        
        
        
    endif
    
    
    if a=specialplanet(5) then 
        deletemonsters(a)'dune and sandworms
        for x=0 to 60
            for y=0 to 20
                if rnd_range(1,100)<66 then
                    planetmap(x,y,a)=-12
                else 
                    planetmap(x,y,a)=-3
                endif
            next
        next
        b1=rnd_range(1,10)+rnd_range(1,10)+25
        p1.x=rnd_range(1,59)
        p1.y=rnd_range(1,19)
        for x=0 to b1
            planetmap(p1.x,p1.y,a)=-8
            if rnd_range(1,100)<30 then
                p1=movepoint(p1,5)
            else
                p1.x=rnd_range(1,59)
                p1.y=rnd_range(1,19)
            endif    
        next
        b1=rnd_range(1,4)+rnd_range(1,4)+2
        for x=0 to b1
            placeitem(make_item(96,planets(a).depth+disnbase(player.c)\5,planets(a).depth+disnbase(player.c)\6),rnd_range(0,60),rnd_range(0,20),a)
        next
        
        if specialplanet(5)=a then
            p1.x=rnd_range(0,60)
            p1.y=rnd_range(0,20)
            planetmap(p1.x,p1.y,a)=-62
            b=rnd_range(1,8)
            if b=4 then b=b+1
            p2=movepoint(p1,b)
            c=1
            
            do
                p2=movepoint(p2,b)
                c=c+1
            loop until p1.x=0 or p1.y=0 or p1.x=60 or p1.y=60 or planetmap(p1.x,p1.y,a)=-8 or c>8
            planetmap(p2.x,p2.y,a)=-63
    
            planets(a).mon_template(0)=makemonster(11,a)
            planets(a).mon_noamax(0)=15
            planets(a).mon_noamin(0)=8
        endif
    endif
    
    if specialplanet(6)=a then'invisible critters +mine
        deletemonsters(a)
        p1.x=rnd_range(0,50)
        p1.y=rnd_range(0,16)
        planetmap(p1.x,p1.y,a)=-76
        planetmap(p1.x+2,p1.y,a)=-76
        planetmap(p1.x,p1.y+2,a)=-76
        planetmap(p1.x+2,p1.y+2,a)=-76
        planetmap(p1.x+1,p1.y,a)=-32
        planetmap(p1.x+1,p1.y+2,a)=-32
        planetmap(p1.x,p1.y+1,a)=-33
        planetmap(p1.x+2,p1.y+1,a)=-33        
        planetmap(p1.x+3,p1.y,a)=-32
        planetmap(p1.x+4,p1.y,a)=-32
        planetmap(p1.x+5,p1.y,a)=-32
        planetmap(p1.x+6,p1.y,a)=-68
        planetmap(p1.x+1,p1.y+1,a)=-4
        
        lastportal=lastportal+1
        portal(lastportal).desig="A Mineshaft. "
        portal(lastportal).tile=asc("#")
        portal(lastportal).col=14
        portal(lastportal).from.m=a
        portal(lastportal).from.x=p1.x+1
        portal(lastportal).from.y=p1.y+1
        portal(lastportal).dest.m=lastplanet+1
        'specialplanet(11)=portal(lastportal).dest.m
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_portals
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        lastplanet=lastplanet+1
        
        planets(a).mon_template(0)=makemonster(13,a)
        planets(a).mon_noamax(0)=8
        planets(a).mon_noamin(0)=15
        planets(lastplanet).mon_template(0)=makemonster(13,a)
        planets(lastplanet).mon_noamax(0)=25
        planets(lastplanet).mon_noamin(0)=10
        placeitem(make_item(15),p1.x,p1.y+2,a,0,0)
        'placeitem(make_item(97),rnd_range(0,60),rnd_range(0,20),lastplanet,0,0,0)
        placeitem(make_item(98),rnd_range(0,60),rnd_range(0,20),lastplanet,0,0)
        placeitem(make_item(99),rnd_range(0,60),rnd_range(0,20),lastplanet,0,0)
        
    endif
    
    if specialplanet(7)=a then 'Civ 1
        'Make Spacefaring civilization
    endif
    
    if specialplanet(8)=a then 'Pirate treasure on stormy world
        planetmap(rnd_range(0,60),rnd_range(0,20),a)=-75        
    endif
    
    
    if a=specialplanet(9) then
        deletemonsters(a)
        planets(a).water=25
        makeislands(a,3)
        planets(a).atmos=4
        planets(a).temp=15.5
        for x=4 to 16
            for y=4 to 16
                if x=4 or y=4 or x=16 or y=16 then planetmap(x,y,a)=-18
            next
        next
        for x=5 to 15
            for y=5 to 15
                if x=5 or y=5 or x=15 or y=15 then
                    planetmap(x,y,a)=-16
                else
                    if frac(x/2)=0 and frac(y/2)=0 then planetmap(x,y,a)=-68
                endif
            next
        next
        for x=6 to 8
            for y=6 to 8
                planetmap(x,y,a)=-18
            next
        next
        planetmap(7,7,a)=-241
        for b=0 to 1
            gc.m=a
            gc.x=rnd_range(20,60)
            gc.y=rnd_range(1,18)
            lastplanet+=1
            gc1.m=lastplanet
            p1=rnd_point(lastplanet,0)
            gc1.x=p1.x
            gc1.y=p1.y
            makecomplex(gc1,1)
            addportal(gc,gc1,0,asc("o"),"A shaft",14)
        next
        p1=rnd_point(lastplanet,0)
        planetmap(p1.x,p1.y,lastplanet)=-242
    endif
    
    if specialplanet(10)=a or a=piratebase(0) then 'Settlement
        deletemonsters(a)

        planets(a).grav=0.8+rnd_range(1,3)/2
        planets(a).atmos=6
        planets(a).temp=9+rnd_range(1,200)/10
        
        if rnd_range(1,100)<35 then
            p1=rnd_point
            makemudsshop(a,p1.x,p1.y) 'Mud's Bazar
        endif
        
        wx=rnd_range(5,8)
        wy=wx
        p1.x=rnd_range(20,40)
        
        p2.x=p1.x+wx
        p2.y=10
        
        for y=p2.y-wy+1 to p2.y+wy-1 step 3    
        
                for x=p2.x-wx to p2.x+wx 
                    if p4.x=0 and p4.y=0 then
                        p4.x=x
                        p4.y=y 'Grab first east west street
                    endif
                    planetmap(x,y,a)=32
                next
            next
            for x=p2.x-wx+1 to p2.x+wx-1 step 3
                for y=p2.y-wy to p2.y+wy
                    planetmap(x,y,a)=31
                next
            next
            
        for x=p2.x-wx to p2.x+wx
            for y=p2.y-wy to p2.y+wy
                if planetmap(x,y,a)>30 and planetmap(x+1,y,a)>30 and  planetmap(x,y+1,a)>30 then
                    planetmap(x,y,a)=33
                endif
            next
        next
        for x=0 to 60
           for y=0 to 20
               p3.x=x
               p3.y=y
               d=distance(p3,p2)
                
                if d<=wy then
                    if rnd_range(1,100)<80 and planetmap(x,y,a)<30 then
                    
                        planetmap(x,y,a)=16
                    endif
                endif
            next
        next
        cnt=0
        
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y,p2.y+wy)
        loop until planetmap(x,y,a)<30 or cnt>9999
        
        if a=piratebase(0) then 
            planetmap(x,y,a)=74
        else
            planetmap(x,y,a)=42
        endif
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y,p2.y+wy)
        loop until planetmap(x,y,a)<30 or cnt>20000
        planetmap(x,y,a)=43
        
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y-wy,p2.y+wy)
        loop until planetmap(x,y,a)<30 or cnt>40000
        if a<>piratebase(0) then planetmap(x,y,a)=270
        
        
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y,p2.y+wy)
        loop until planetmap(x,y,a)<30 or cnt>40000
        
        if a<>piratebase(0) then 
            planetmap(x,y,a)=89
        else
            planetmap(x,y,a)=164
        endif
        
        
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y,p2.y+wy)
        loop until abs(planetmap(x,y,a))<30 or cnt>40000
        
        planetmap(x,y,a)=286
        
        if rnd_range(1,100)<50 or a=piratebase(0) then
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y,p2.y+wy)
        loop until planetmap(x,y,a)<30 or cnt>40000
        
        if a<>piratebase(0) then 
            planetmap(x,y,a)=110
        else
            planetmap(x,y,a)=111
        endif
        endif
        
        planets(a).mon_template(0)=makemonster(14,a)
        planets(a).mon_noamin(0)=8
        planets(a).mon_noamax(0)=17
        
        if specialplanet(10)=a then 'Small spaceport for colony
            p3.x=p2.x+wx
            p3.y=10
            if p3.x+3>60 then p3.x-=3
            for x=p3.x to p3.x+3
                for y=10 to 12
                    planetmap(x,y,a)=68
                next
            next
            
            if (a=specialplanet(10) and rnd_range(1,100)<50) or debug=2 then planetmap(p3.x,12,a)=-112
            planetmap(p3.x,10,a)=70
            planetmap(p3.x,11,a)=71
    
        endif
        
        if a=piratebase(0) then 'add spaceport
            c=rnd_range(1,53)
            if c>p4.x then 
                b=1
            else
                b=-1
            endif
            for x=p4.x to c step b
                planetmap(x,p4.y,a)=32
            next
            'c=ende der strasse
            d=0
            if p4.y-3<0 then p4.y=p4.y+3
            if p4.y+3>60 then p4.y=p4.y-3
            
            for x=c to c+5
                for y=p4.y-3 to p4.y+3
                    planetmap(x,y,a)=68
                    if rnd_range(1,100)<25 then planetmap(x,y,a)=67
                    if x=c+1 and y>p4.y-3 and d<5 then
                        planetmap(x,y,a)=69+d
                        d=d+1
                    endif
                next
            next
            if rnd_range(1,100)<50 or debug=2 then planetmap(c+1,p4.y+3,a)=112
            planetmap(c,p4.y-3,a)=-259
            planetmap(c,p4.y-2,a)=74
            do
                p=rnd_point(a,0)
            loop until tiles(abs(planetmap(p.x,p.y,a))).walktru>0 or abs(planetmap(p.x,p.y,a))<15
            planetmap(p.x,p.y,a)=-197
            planets(a).grav=.8+rnd_range(1,2)/2
            planets(a).atmos=5
            planets(a).temp=33+rnd_range(1,20)-10
            
            planets(a).mon_template(0)=makemonster(3,a)
            planets(a).mon_noamin(0)=8
            planets(a).mon_noamax(0)=15
            
            planets(a).mon_template(1)=makemonster(49,a)
            planets(a).mon_noamin(1)=6
            planets(a).mon_noamax(1)=10
            
            planets(a).mon_template(2)=makemonster(50,a)
            planets(a).mon_noamin(2)=3
            planets(a).mon_noamax(2)=6
        endif
    
    
    
        'Turn all around if player isnt pirate
        if not(faction(0).war(2)>=0 and a=piratebase(0)) then        
            for x=0 to 60
                for y=0 to 20
                    if planetmap(x,y,a)>0 then planetmap(x,y,a)=-planetmap(x,y,a)
                next
            next
        endif
        
    endif
    
    if specialplanet(11)=a then
        p1=rnd_point
        planetmap(p1.x,p1.y,a)=79
        p2=movepoint(p1,5)
        planetmap(p2.x,p2.y,a)=270
        do
            p3=movepoint(p1,5)
        loop until (p1.x<>p3.x or p1.y<>p3.y) and (p2.x<>p3.x or p2.y<>p3.y)
        planetmap(p3.x,p3.y,a)=271
    endif
    
    if specialplanet(12)=a then
        planetmap(30,10,a)=296
    endif
    
    if a=specialplanet(13) then 'Entertainment world
        deletemonsters(a)
        makecraters(a,3)
        p=rnd_point
        p2=rnd_point
        if p2.x+4>60 then p2.x=55
        if p2.y+4>20 then p2.y=15
        makeroad(p,p2,a)
        p3=rnd_point
        if p3.x+3>60 then p3.x-=3
        makeroad(p3,p2,a)
        for x=p3.x to p3.x+3
            for y=10 to 12
                planetmap(x,y,a)=68
            next
        next
        planetmap(p3.x,10,a)=70
        planetmap(p3.x,11,a)=71

        for x=p2.x to p2.x+4
            for y=p2.y to p2.y+4
                planetmap(x,y,a)=-68
            next
        next
        p.m=a
        planetmap(p.x,p.y,a)=-4
        
        lastplanet+=1
        makecomplex3(lastplanet,5,6,0,3)
        
        for x=2 to 58
            for y=2 to 18
                if planetmap(x,y,lastplanet)=-202 and planetmap(x,y-1,lastplanet)=-50 and planetmap(x,y+1,lastplanet)=-50 then planetmap(x,y-1,lastplanet)=-202 
                if planetmap(x,y,lastplanet)=-202 and planetmap(x-1,y,lastplanet)=-50 and planetmap(x+1,y,lastplanet)=-50 then planetmap(x-1,y,lastplanet)=-202
            next
        next
        p2=rnd_point(lastplanet,0)
        p3=rnd_point
        if p3.x+8>59 then p3.x=51
        if p3.y+8>19 then p3.y=11
        for x=p3.x to p3.x+8
            for y=p3.y to p3.y+8
                planetmap(x,y,lastplanet)=-202
            next
        next
        for x=p3.x+1 to p3.x+7
            for y=p3.y+1 to p3.y+7
                planetmap(x,y,lastplanet)=-3
                if x=p3.x+1 or x=p3.x+7 or y=p3.y+1 or y=p3.y+7 then planetmap(x,y,lastplanet)=-51
            next
        next
        
        
        p2=rnd_point(lastplanet,0)
        p2.m=lastplanet
        addportal(p,p2,0,asc(">"),"A wide and well lit staircase",15)
        
        planetmap(p3.x+1,p3.y+4,lastplanet)=-265
        for b=0 to 6
            do
                p4=rnd_point(lastplanet,0)
            loop until p4.x<p3.x or p4.x>p3.x+7 or p4.y<p3.y or p4.y>p3.y+7
            planetmap(p4.x,p4.y,lastplanet)=-69
        next
        
        for b=0 to 2
            do
                p4=rnd_point(lastplanet,0)
            loop until p4.x<p3.x or p4.x>p3.x+7 or p4.y<p3.y or p4.y>p3.y+7
            planetmap(p4.x,p4.y,lastplanet)=-266
        next

        do
            p4=rnd_point(lastplanet,0)
        loop until p4.x<p3.x or p4.x>p3.x+7 or p4.y<p3.y or p4.y>p3.y+7
        if p4.x<0 then p4.x=0
        if p4.y<0 then p4.y=0
        if p4.y>20 then p4.y=20
        if p4.x>60 then p4.x=60
        planetmap(p4.x,p4.y,lastplanet)=-261
    
        do
            p4=rnd_point(lastplanet,0)
        loop until p4.x<p3.x or p4.x>p3.x+7 or p4.y<p3.y or p4.y>p3.y+7
        if p4.x<0 then p4.x=0
        if p4.y<0 then p4.y=0
        if p4.y>20 then p4.y=20
        if p4.x>60 then p4.x=60
        planetmap(p4.x,p4.y,lastplanet)=-262

        do
            p4=rnd_point(lastplanet,0)
        loop until p4.x<p3.x or p4.x>p3.x+7 or p4.y<p3.y or p4.y>p3.y+7
        if p4.x<0 then p4.x=0
        if p4.y<0 then p4.y=0
        if p4.y>20 then p4.y=20
        if p4.x>60 then p4.x=60
        planetmap(p4.x,p4.y,lastplanet)=-261
        
        
        do
            p4=rnd_point(lastplanet,0)
        loop until p4.x<p3.x or p4.x>p3.x+7 or p4.y<p3.y or p4.y>p3.y+7
        if p4.x<0 then p4.x=0
        if p4.y<0 then p4.y=0
        if p4.y>20 then p4.y=20
        if p4.x>60 then p4.x=60
        planetmap(p4.x,p4.y,lastplanet)=-271
        
        
        do
            p4=rnd_point(lastplanet,0)
        loop until p4.x<p3.x or p4.x>p3.x+7 or p4.y<p3.y or p4.y>p3.y+7
        if p4.x<0 then p4.x=0
        if p4.y<0 then p4.y=0
        if p4.y>20 then p4.y=20
        if p4.x>60 then p4.x=60
        planetmap(p4.x,p4.y,lastplanet)=-270
        
        
        planets(lastplanet).depth=1
        planets(lastplanet).mon_template(2)=makemonster(39,lastplanet)
        planets(lastplanet).mon_noamin(2)=3
        planets(lastplanet).mon_noamax(2)=10
        
        'planets(lastplanet).mon_template(3)=makemonster(23,lastplanet)
        'planets(lastplanet).mon_noamin(3)=1
        'planets(lastplanet).mon_noamax(3)=3
        
        planets(lastplanet).atmos=7
        p2=rnd_point(lastplanet,0)
        p2.m=lastplanet
        lastplanet+=1
        makecomplex3(lastplanet,5,6,0,3)
        
        for x=2 to 58
            for y=2 to 18
                if planetmap(x,y,lastplanet)=-202 and planetmap(x,y-1,lastplanet)=-50 and planetmap(x,y+1,lastplanet)=-50 then planetmap(x,y-1,lastplanet)=-202 
                if planetmap(x,y,lastplanet)=-202 and planetmap(x-1,y,lastplanet)=-50 and planetmap(x+1,y,lastplanet)=-50 then planetmap(x-1,y,lastplanet)=-202
            next
        next
        p=rnd_point(lastplanet,0)
        p.m=lastplanet
        addportal(p2,p,0,asc(">"),"A wide and well lit staircase",15)
        for b=0 to 35
            p=rnd_point(lastplanet,0)
            planetmap(p.x,p.y,lastplanet)=-267
        next
        p=rnd_point(lastplanet,0)
        planetmap(p.x,p.y,lastplanet)=-268
    
        planets(lastplanet)=planets(lastplanet-1)
    endif
    
    if specialplanet(14)=a then 'Black Market
        deletemonsters(a)
        
        if rnd_range(1,100)<25 then
            p1=rnd_point
            makemudsshop(a,p1.x,p1.y) 'Mud's Bazar
        endif
        p2=rnd_point
        p3=rnd_point
        p4=rnd_point
        p5=rnd_point
        makeoutpost(a,p2.x,p2.y)
        makeoutpost(a,p3.x,p3.y)
        p1=rnd_point
        makeroad(p1,p2,a)
        makeroad(p1,p3,a)
        makeroad(p1,p4,a)
        makeroad(p1,p5,a)
        
        if p5.x+3>60 then p5.x-=3
        if p5.y+3>20 then p5.y-=3
        for x=p5.x to p5.x+3
            for y=p5.y to p5.y+3
                planetmap(x,y,a)=68
            next
        next
        
        
        if rnd_range(1,100)<50 then planetmap(p3.x,9,a)=-112
        planetmap(p3.x,10,a)=70
        planetmap(p3.x,11,a)=71
    
        if p1.x>50 then p1.x=50
        if p1.x<5 then p1.x=10
        if p1.y<5 then p1.y=5
        if p1.y>19 then p1.y=19
        if p1.x>58 then p1.x=58
        planetmap(p1.x,p1.y,a)=-68
        planetmap(p1.x+1,p1.y,a)=-68
        planetmap(p1.x,p1.y+1,a)=-68
        planetmap(p1.x+1,p1.y+1,a)=-68
        planetmap(p1.x+2,p1.y,a)=-98
        planetmap(p1.x+2,p1.y+1,a)=-43
        
        
        p2.x=rnd_range(2,p1.x-2)
        p2.y=rnd_range(1,p1.y)
        if p2.y<5 then p2.y=5
        makeroad(p1,p2,a)
        for x=p2.x to p2.x+3
            for y=p2.y to p2.y+4
                if x>=0 and y>=0 and x<=60 and y<=20 then
                    planetmap(x,y,a)=-68
                endif
            next
        next
        planetmap(p2.x-1,p2.y,a)=-238
        planetmap(p2.x-1,p2.y+2,a)=-237
        planetmap(p2.x-1,p2.y+4,a)=-259
        planetmap(p3.x,p3.y,a)=-261
        planetmap(p4.x,p4.y,a)=-270
        planetmap(p4.x-1,p4.y,a)=-271
        p4.x+=2
        if p4.x>60 then p4.x-=60
        planetmap(p4.x,p4.y,a)=-110
        
        planets(a).mon_template(1)=makemonster(100,a)
        planets(a).mon_noamax(1)=1
        planets(a).mon_noamin(1)=1
        
    endif
    
    if specialplanet(15)=a then
        planets(a).water=66
        deletemonsters(a)
        makeislands(a,3)
        for b=0 to rnd_range(15,25)
            planetmap(rnd_range(1,59),rnd_range(1,19),a)=-91
            planetmap(rnd_range(1,59),rnd_range(1,19),a)=-96
        next
        lastportal=lastportal+1
        portal(lastportal).desig="A natural tunnel. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).col=7
        portal(lastportal).from.m=a
        portal(lastportal).from.x=rnd_range(0,60)
        portal(lastportal).from.y=rnd_range(0,20)
        portal(lastportal).dest.m=lastplanet+1
        'specialplanet(11)=portal(lastportal).dest.m
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_portals
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        
        lastplanet+=1
        planets(a).mon_template(0)=makemonster(20,a)
        planets(a).mon_noamax(0)=24
        planets(a).mon_noamin(0)=18
        
        planets(a).mon_template(1)=makemonster(58,a)
        planets(a).mon_noamax(1)=24
        planets(a).mon_noamin(1)=18
        
        planets(lastplanet).depth=1
        gc.x=portal(lastportal).dest.x
        gc.y=portal(lastportal).dest.y
        gc.m=lastplanet
        makecavemap(gc,4-rnd_range(1,8),2-rnd_range(1,4),0,0)
        r.x=rnd_range(1,40)
        r.y=rnd_range(1,15)
        r.w=rnd_range(5,7)
        r.h=rnd_range(4,5)
        p1.x=gc.x
        p1.y=gc.y
        makevault(r,gc.m,p1,99,0)
    endif 
    
    if specialplanet(16)=a then
        b=lastportal
        c=lastplanet
        deletemonsters(a)
        planets(a).temp=22.5
        planets(a).grav=0.9
        planets(a).atmos=6
        planets(a).water=66
        makeislands(a,3)
        for x=26 to 34
            for y=6 to 14
                p.x=x
                p.y=y
                p1.x=30
                p1.y=10
                if distance(p,p1)<=3 then planetmap(x,y,a)=-7
                if rnd_range(1,100)<88 and distance(p,p1)=2  then p2=p
            next
        next
        planetmap(p2.x,p2.y,a)=-4
        planetmap(30,10,a)=-150
        planets(a).mon_noamin(0)=15
        planets(a).mon_noamax(0)=25
        planets(a).mon_template(0)=makemonster(22,a)
        
        gc.x=rnd_range(1,60)
        gc.y=rnd_range(1,20)
        gc.m=c+1
        makecavemap(gc,4-rnd_range(1,8),2-rnd_range(1,4),-1,0)
        planets(gc.m).depth=1
        
        
        
        planets(lastplanet+3).depth=3
        
        lastportal=b
        lastportal=lastportal+1
        portal(lastportal).desig="A natural tunnel. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).ti_no=3001
        portal(lastportal).col=7
        portal(lastportal).from.m=a
        portal(lastportal).from.x=p2.x
        portal(lastportal).from.y=p2.y
        portal(lastportal).dest.m=gc.m
        p=rnd_point(lastplanet+1,0)
        portal(lastportal).dest.x=p.x
        portal(lastportal).dest.y=p.y
        portal(lastportal).discovered=show_specials
        
        gc.x=rnd_range(1,60)
        gc.y=rnd_range(1,20)
        gc.m=c+2
        makecavemap(gc,4-rnd_range(1,8),2-rnd_range(1,4),-1,0)
        planets(gc.m).depth=2
        lastportal=lastportal+1
        portal(lastportal).desig="Am ascending tunnel. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).ti_no=3001
        portal(lastportal).col=7
        portal(lastportal).from.m=c+1
        p=rnd_point(c+1,0)
        portal(lastportal).from.x=p.x
        portal(lastportal).from.y=p.y
        portal(lastportal).dest.m=c+2
        p=rnd_point(c+2,0)
        portal(lastportal).dest.x=p.x
        portal(lastportal).dest.y=p.y
        portal(lastportal).discovered=show_specials
        
        makelabyrinth(c+3)
        
        lastportal=lastportal+1
        portal(lastportal).desig="A stair going upwards. "
        portal(lastportal).tile=asc("<")
        portal(lastportal).ti_no=3004
        portal(lastportal).col=7
        portal(lastportal).from.m=c+2
        p=rnd_point(c+2,0)
        portal(lastportal).from.x=p.x
        portal(lastportal).from.y=p.y
        portal(lastportal).dest.m=c+3
        p=rnd_point(c+3,0)
        portal(lastportal).dest.x=p.x
        portal(lastportal).dest.y=p.y
        portal(lastportal).discovered=show_specials
        portal(lastportal).oneway=1
        
        lastportal=lastportal+1
        portal(lastportal)=portal(lastportal-1)
        swap portal(lastportal).from,portal(lastportal).dest
        portal(lastportal).desig="A stair leading down."
        portal(lastportal).tile=asc(">")
        portal(lastportal).ti_no=3004
        portal(lastportal).col=7
    
        for b=0 to 30
            p1=rnd_point(lastplanet+3,0)
            planetmap(p1.x,p1.y,lastplanet+3)=-161
        next
        planets(lastplanet+1).mon_template(0)=makemonster(1,lastplanet+1)
        planets(lastplanet+1).mon_template(1)=makemonster(9,lastplanet+1)
        planets(lastplanet+1).mon_noamin(0)=9
        planets(lastplanet+1).mon_noamax(0)=18
        planets(lastplanet+1).mon_noamax(1)=1
        planets(lastplanet+1).mon_noamax(1)=2
        planets(lastplanet+1).atmos=6
        planets(lastplanet+2).mon_template(0)=makemonster(1,lastplanet+2)
        planets(lastplanet+2).mon_template(1)=makemonster(9,lastplanet+2)
        planets(lastplanet+2).mon_noamin(0)=9
        planets(lastplanet+2).mon_noamax(0)=18
        planets(lastplanet+2).mon_noamax(1)=1
        planets(lastplanet+2).mon_noamax(1)=2
        planets(lastplanet+2).atmos=6
        
        planets(lastplanet+3).mon_template(0)=makemonster(8,lastplanet+3)
        planets(lastplanet+3).mon_template(1)=makemonster(9,lastplanet+3)
        planets(lastplanet+3).mon_noamin(0)=9
        planets(lastplanet+3).mon_noamax(0)=18
        planets(lastplanet+3).mon_noamax(1)=1
        planets(lastplanet+3).mon_noamax(1)=3
        planets(lastplanet+3).atmos=6
       
        p1=rnd_point(lastplanet+3,0)
        placeitem(make_item(90),p1.x,p1.y,lastplanet+3,0,0) 
        planetmap(p1.x,p1.y,lastplanet+3)=-162
        lastplanet=lastplanet+3
    endif
    
    if specialplanet(17)=a then
        planets(a).water=66
        planets(a).atmos=6
        makeislands(a,4)
        
        deletemonsters(a)
        p1=rnd_point
        
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)<>-1 and planetmap(x,y,a)<>-2 then
                    c=0
                    p.x=x
                    p.y=y
                    for b=1 to 9
                        p1=movepoint(p,b)
                        if planetmap(p1.x,p1.y,a)=-1 or planetmap(p1.x,p1.y,a)=-2 then c=c+1
                    next
                    if c=0 then  
                        planetmap(x,y,a)=-16
                        if rnd_range(1,100)<18 then planetmap(x,y,a)=-107
                        if rnd_range(1,100)<28 then planetmap(x,y,a)=-16
                    endif
                endif
            next
        next
        p.x=rnd_range(4,54)
        p.y=rnd_range(4,14)
        for x=p.x-2 to p.x+2
            for y=p.y-2 to p.y+2
                planetmap(x,y,a)=-11
            next
        next
        for x=0 to 15
            makeroad(rnd_point,rnd_point,a)
        next
        planetmap(p.x,p.y,a)=-108
        planetmap(p.x,p.y+1,a)=-108
        planetmap(p.x+1,p.y,a)=-108
        planetmap(p.x-1,p.y,a)=-108
        planetmap(p.x,p.y-1,a)=-108
        makeice(a,4)
        planets(a).mon_template(0)=makemonster(30,a)
        planets(a).mon_noamax(0)=25
        planets(a).mon_noamin(0)=18
        planets(a).temp=49.7
        planets(a).rot=12.7
        planets(a).atmos=3
    endif
    
    if specialplanet(18)=a then
        makemossworld(a,6)
        
        deletemonsters(a)
        y=rnd_range(8,12)
        for b=5 to 55
            planetmap(b,y,a)=-32
        next
        for x=5 to 55 step 10
            p.x=x-1+rnd_range(1,2)
            p.y=rnd_range(7,12)
            planetmap(p.x,p.y,a)=-171
            planetmap(p.x-1,p.y-1,a)=-171
            planetmap(p.x-2,p.y-2,a)=-171
            planetmap(p.x+1,p.y,a)=-171
            planetmap(p.x+2,p.y,a)=-171
            planetmap(p.x+1,p.y+1,a)=-171
            planetmap(p.x+2,p.y+2,a)=-171
            planetmap(p.x+1,p.y,a)=-171
            planetmap(p.x+2,p.y,a)=-171
            planetmap(p.x-1,p.y,a)=-171
            planetmap(p.x-2,p.y,a)=-171
            planetmap(p.x,p.y+1,a)=-171
            planetmap(p.x,p.y+2,a)=-171
            planetmap(p.x,p.y-1,a)=-171
            planetmap(p.x,p.y-2,a)=-171
            planetmap(p.x+1,p.y-1,a)=-171
            planetmap(p.x+2,p.y-2,a)=-171
            planetmap(p.x-1,p.y+1,a)=-171
            planetmap(p.x-2,p.y+2,a)=-171
            planetmap(p.x+3,p.y,a)=-171
            planetmap(p.x-3,p.y,a)=-171
            planetmap(p.x,p.y+3,a)=-171
            planetmap(p.x,p.y-3,a)=-171
        next
        p=rnd_point
        planetmap(3,3,a)=-173
        p=rnd_point
        planetmap(30,10,a)=-172
        planets(a).mon_template(0)=makemonster(25,a)
        planets(a).mon_noamax(0)=12
        planets(a).mon_noamin(0)=8
        
        planets(a).mon_template(1)=makemonster(26,a)
        planets(a).mon_noamax(1)=10
        planets(a).mon_noamin(1)=8
        
        planets(a).temp=19.7
        planets(a).grav=1.1
        planets(a).atmos=5
    endif
    
    if a=specialplanet(19) then
        deletemonsters(a)
        p.x=rnd_range(10,50)
        p.y=rnd_range(5,15)
        planetmap(p.x,p.y,a)=-171
        planetmap(p.x-1,p.y-1,a)=-171
        planetmap(p.x-2,p.y-2,a)=-171
        planetmap(p.x+1,p.y,a)=-171
        planetmap(p.x+2,p.y,a)=-171
        planetmap(p.x+1,p.y+1,a)=-171
        planetmap(p.x+2,p.y+2,a)=-171
        planetmap(p.x+1,p.y,a)=-171
        planetmap(p.x+2,p.y,a)=-171
        planetmap(p.x-1,p.y,a)=-171
        planetmap(p.x-2,p.y,a)=-171
        planetmap(p.x,p.y+1,a)=-171
        planetmap(p.x,p.y+2,a)=-171
        planetmap(p.x,p.y-1,a)=-171
        planetmap(p.x,p.y-2,a)=-171
        planetmap(p.x+1,p.y-1,a)=-171
        planetmap(p.x+2,p.y-2,a)=-171
        planetmap(p.x-1,p.y+1,a)=-171
        planetmap(p.x-2,p.y+2,a)=-171
        planetmap(p.x+3,p.y,a)=-171
        planetmap(p.x-3,p.y,a)=-171
        planetmap(p.x,p.y+3,a)=-171
        planetmap(p.x,p.y-3,a)=-171
        planets(a).mon_template(0)=makemonster(26,a)
        planets(a).mon_noamax(0)=12
        planets(a).mon_noamin(0)=8
        planets(a).temp=-219.7
        planets(a).grav=1.1
        planets(a).atmos=4
    endif
    
    if a=specialplanet(20) then
        planets(a).water=33
        makeislands(a,3)
        
        deletemonsters(a)
        p=rnd_point
        for b=0 to 6
            makeroad(p,rnd_point,a)
            p.x=rnd_range(2,55)
            p.y=rnd_range(2,15)
            for x=p.x to p.x+4
                for y=p.y to p.y+4
                    planetmap(x,y,a)=-181
                next
            next
        next
        p2=rnd_point
        planetmap(p2.x,p2.y,a)=-183
        p2=rnd_point
        makeroad(p,p2,a)
        if p2.x=60 then p2.x=59
        if p2.y=20 then p2.y=19
        planetmap(p2.x,p2.y,a)=-182
        planetmap(p2.x+1,p2.y,a)=-182
        planetmap(p2.x,p2.y+1,a)=-182
        planetmap(p2.x+1,p2.y+1,a)=-182
        planets(a).mon_template(0)=makemonster(28,a)
        planets(a).mon_noamin(0)=5
        planets(a).mon_noamax(0)=15
        planets(a).atmos=6
        planets(a).grav=1.1
        planets(a).temp=15.3
        
        
        lastportal=lastportal+1
        portal(lastportal).desig="A natural tunnel. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).ti_no=3001
        portal(lastportal).col=7
        portal(lastportal).from.m=a
        portal(lastportal).from.x=rnd_range(0,60)
        portal(lastportal).from.y=rnd_range(0,20)
        portal(lastportal).dest.m=lastplanet+1
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_all
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        lastplanet=lastplanet+1
        b=lastplanet
        
        gc.x=portal(lastportal).dest.x
        gc.y=portal(lastportal).dest.y
        gc.m=b
        makecavemap(gc,4-rnd_range(1,8),2-rnd_range(1,4),-1,0)
        planets(b).depth=1
        
        planets(b).mon_template(0)=makemonster(29,a)
        planets(b).mon_noamin(0)=3
        planets(b).mon_noamax(0)=10
        
        planets(b).mon_template(1)=makemonster(65,a)
        planets(b).mon_noamin(1)=1
        planets(b).mon_noamax(1)=5
        
        lastportal=lastportal+1
        portal(lastportal).desig="A natural tunnel. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).ti_no=3001
        portal(lastportal).col=7
        portal(lastportal).from.m=lastplanet
        portal(lastportal).from.x=rnd_range(0,60)
        portal(lastportal).from.y=rnd_range(0,20)
        p=rnd_point(lastplanet,0)
        portal(lastportal).from.x=p.x
        portal(lastportal).from.y=p.y
        
        portal(lastportal).dest.m=lastplanet+1
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_all
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        lastplanet=lastplanet+1
        b=lastplanet
        
        gc.x=portal(lastportal).dest.x
        gc.y=portal(lastportal).dest.y
        gc.m=b
        makecavemap(gc,4-rnd_range(1,8),2-rnd_range(1,4),-1,0)
        planets(b).depth=1
        
        
        planets(b).mon_template(0)=makemonster(29,a)
        planets(b).mon_noamin(0)=5
        planets(b).mon_noamax(0)=15
        
        planets(b).mon_template(1)=makemonster(65,a)
        planets(b).mon_noamin(1)=3
        planets(b).mon_noamax(1)=8
        
        
        p=rnd_point(b,0)
        planetmap(p.x,p.y,b)=-190
        for c=0 to 10
            placeitem(make_item(96,planets(a).depth+disnbase(player.c)\7,planets(a).depth),p.x,p.y,b,0,0)
        next
        for c=0 to 5
            placeitem(make_item(rnd_range(1,lstcomit)),p.x,p.y,b,0,0)
        next
        placeitem(make_item(89),p.x,p.y,lastplanet)
    endif
    
    if a=specialplanet(26) then
        b=-13
        
        deletemonsters(a)
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=b
                if rnd_range(1,100)<22 then b=-14
                if rnd_range(1,100)<22 then b=-4
                if rnd_range(1,100)<22 then b=-3
                if rnd_range(1,100)<22 then b=-13
            next
        next
        
        for b=0 to 25
            p=rnd_point
                
            for c=0 to 15+rnd_range(2,6)+rnd_range(2,6)
                p=movepoint(p,5)
                planetmap(p.x,p.y,a)=-193
            next
        next
        for b=0 to rnd_range(2,4)
            p=rnd_point
            planetmap(p.x,p.y,a)=-191
        next
        p=rnd_point
        planetmap(p.x,p.y,a)=-132
        
        planets(a).mon_template(0)=makemonster(31,a)
        planets(a).mon_noamin(0)=10
        planets(a).mon_noamax(0)=15
        
        planets(a).mon_template(1)=makemonster(65,a)
        planets(a).mon_noamin(1)=1
        planets(a).mon_noamax(1)=5
        
        lastportal=lastportal+1
        portal(lastportal).desig="A natural tunnel. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).ti_no=3001
        portal(lastportal).col=7
        portal(lastportal).from.m=a
        portal(lastportal).from.x=rnd_range(0,60)
        portal(lastportal).from.y=rnd_range(0,20)
        portal(lastportal).dest.m=lastplanet+1
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_all
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        lastplanet=lastplanet+1
        b=lastplanet
        
        gc.x=portal(lastportal).dest.x
        gc.y=portal(lastportal).dest.y
        gc.m=b
        makecavemap(gc,4-rnd_range(1,8),2-rnd_range(1,4),-1,0)
        for x=0 to 60
            for y=0 to 20
                if tiles(abs(planetmap(x,y,b))).walktru>0 then planetmap(x,y,b)=-194
            next
        next
    
        p=rnd_point(b,0)
        planetmap(p.x,p.y,b)=-191   
        p=rnd_point(b,0)
        planetmap(p.x,p.y,b)=-191   
        p=rnd_point(b,0)
        planetmap(p.x,p.y,b)=-191
        
        planets(b).depth=1
        planets(b).mon_template(0)=makemonster(31,b)
        planets(b).mon_noamin(0)=5
        planets(b).mon_noamax(0)=15
                
        planets(b).mon_template(1)=makemonster(65,b)
        planets(b).mon_noamin(1)=3
        planets(b).mon_noamax(1)=10
        
        planets(b).atmos=6
        
        lastportal=lastportal+1
        portal(lastportal).desig="A natural tunnel. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).ti_no=3001
        portal(lastportal).col=7
        portal(lastportal).from.m=lastplanet
        portal(lastportal).from.x=rnd_range(0,60)
        portal(lastportal).from.y=rnd_range(0,20)
        p=rnd_point(lastplanet,0)
        portal(lastportal).from.x=p.x
        portal(lastportal).from.y=p.y
        
        portal(lastportal).dest.m=lastplanet+1
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_all
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        lastplanet=lastplanet+1
        b=lastplanet
        
        gc.x=portal(lastportal).dest.x
        gc.y=portal(lastportal).dest.y
        gc.m=b
        makelabyrinth(b)
        for x=0 to 60
            for y=0 to 20
                if tiles(abs(planetmap(x,y,b))).walktru>0 then planetmap(x,y,b)=-194
                if abs(planetmap(x,y,b))=151 then planetmap(x,y,b)=-195
            next
        next
        planets(b).depth=2
        planets(b).mon_template(0)=makemonster(31,a)
        planets(b).mon_noamin(0)=15
        planets(b).mon_noamax(0)=20        
        
        planets(b).mon_template(1)=makemonster(65,b)
        planets(b).mon_noamin(1)=10
        planets(b).mon_noamax(1)=12
        
        planets(b).atmos=6
        
        p=rnd_point(b,0)
        planetmap(p.x,p.y,b)=-191
        
        p=rnd_point(b,0)
        portal(lastportal).dest.x=p.x
        portal(lastportal).dest.y=p.y
    endif
        
    if a=specialplanet(27) then
        makecraters(a,3)
        
        deletemonsters(a)
        p.x=30
        p.y=10
        p2.x=8
        p2.y=5
        p3.x=50
        p3.y=6
        p4.x=7
        p4.y=13
        p5.x=50
        p5.y=14
        p2=movepoint(p2,5)
        p3=movepoint(p3,5)
        p4=movepoint(p4,5)
        p5=movepoint(p5,5)
        b=10
        for x=0 to 60
            for y=0 to 20
                p1.x=x
                p1.y=y
                if int(distance(p,p1))=b  or int(distance(p,p1))=b-2 then planetmap(x,y,a)=-8 
                if int(distance(p,p1))=b-1 then planetmap(x,y,a)=-7  
                if distance(p,p1)<b-2 then planetmap(x,y,a)=-4 
                if distance(p,p1)<b-4 then planetmap(x,y,a)=-186 
                if distance(p,p1)<b-6 then planetmap(x,y,a)=-185 
                
                if distance(p2,p1)<5 then planetmap(x,y,a)=-186
                if distance(p2,p1)<2.5 then planetmap(x,y,a)=-185
                
                if distance(p3,p1)<5 then planetmap(x,y,a)=-186
                if distance(p3,p1)<2.5 then planetmap(x,y,a)=-185
            
                if distance(p4,p1)<5 then planetmap(x,y,a)=-186
                if distance(p4,p1)<2.5 then planetmap(x,y,a)=-185
            
                if distance(p5,p1)<5 then planetmap(x,y,a)=-186
                if distance(p5,p1)<2.5 then planetmap(x,y,a)=-185
            
            next
        next
        p=rnd_point()
        planetmap(p.x,p.y,a)=-rnd_range(140,143)
        p=rnd_point()
        planetmap(p.x,p.y,a)=-rnd_range(140,143)
        planets(a).mon_template(0)=makemonster(36,a)
        planets(a).mon_noamin(0)=2
        planets(a).mon_noamax(0)=5
        planets(a).mon_template(1)=makemonster(79,a)
        planets(a).mon_noamin(1)=2
        planets(a).mon_noamax(1)=5
        
        lastplanet=lastplanet+1
        gc1.m=lastplanet
        p2=rnd_point(lastplanet,0)
        gc1.x=p2.x
        gc1.y=p2.y
            
        makecavemap(gc1,3,1,0,0)
        for x=0 to 60
            for y=0 to 20
                p3.x=x
                p3.y=y
                p4.x=30
                p4.y=10
                if distance(p3,p4)<6 then planetmap(x,y,lastplanet)=-185
                if abs(planetmap(x,y,lastplanet))=4 then planetmap(x,y,lastplanet)=-185
                if abs(planetmap(x,y,lastplanet))=185 and rnd_range(1,100)<45 then planetmap(x,y,lastplanet)=-186
            next
        next
        
        
        planets(lastplanet).mon_template(0)=makemonster(36,lastplanet)
        planets(lastplanet).mon_noamin(0)=3
        planets(lastplanet).mon_noamax(0)=7
        
        
        planets(lastplanet).mon_template(1)=makemonster(79,lastplanet)
        planets(lastplanet).mon_noamin(1)=3
        planets(lastplanet).mon_noamax(1)=7
        
        planets(lastplanet).atmos=6
        planets(lastplanet).depth=1
        
        for b=0 to 2
            gc.m=a
            p1=rnd_point(a,0)
            gc.y=p1.y
            if b=0 then gc.x=rnd_range(5,15)
            if b=1 then gc.x=rnd_range(25,35)
            if b=1 then gc.y=rnd_range(7,13)
            if b=2 then gc.x=rnd_range(50,55)
            planetmap(gc.x,gc.y,a)=-185
            gc1.m=lastplanet
            p2=rnd_point(lastplanet,0)
            gc1.x=p2.x
            gc1.y=p2.y
            addportal(gc,gc1,0,asc("o"),"a dark cave entry",8)
        next
        gc.m=lastplanet
        p1=rnd_point(lastplanet,0)
        gc.x=p1.x
        gc.y=p1.y
        lastplanet=lastplanet+1
        gc1.m=lastplanet
        p2=rnd_point(lastplanet,0)
        gc1.x=p2.x
        gc1.y=p2.y
        makecavemap(gc1,2,3,0,0)
        addportal(gc,gc1,0,asc("o"),"a dark cave entry",8)
        for x=0 to 60
            for y=0 to 20
                p3.x=x
                p3.y=y
                p4.x=30
                p4.y=10
                if abs(planetmap(x,y,lastplanet))=185 and rnd_range(1,100)<35 then planetmap(x,y,lastplanet)=-186
                if distance(p3,p4)<6 then planetmap(x,y,lastplanet)=-185
                if abs(planetmap(x,y,lastplanet))=4 then planetmap(x,y,lastplanet)=-185
            next
        next
        
        
        planets(lastplanet).mon_template(0)=makemonster(36,lastplanet)
        planets(lastplanet).mon_noamin(0)=6
        planets(lastplanet).mon_noamax(0)=17
        
        
        planets(lastplanet).mon_template(1)=makemonster(79,lastplanet)
        planets(lastplanet).mon_noamin(1)=6
        planets(lastplanet).mon_noamax(1)=17
        
        planets(lastplanet).atmos=6
        planets(lastplanet).depth=1
        
        gc.m=lastplanet
        p1=rnd_point(lastplanet,0)
        gc.x=p1.x
        gc.y=p1.y
        lastplanet=lastplanet+1
        gc1.m=lastplanet
        p2=rnd_point(lastplanet,0)
        gc1.x=p2.x
        gc1.y=p2.y
        makecavemap(gc1,2,3,0,0)
        addportal(gc,gc1,0,asc("o"),"a dark cave entry",8)
        for x=0 to 60
            for y=0 to 20
                p3.x=x
                p3.y=y
                p4.x=30
                p4.y=10
                if abs(planetmap(x,y,lastplanet))=185 and rnd_range(1,100)<15 then planetmap(x,y,lastplanet)=-186
                if distance(p3,p4)<6 then planetmap(x,y,lastplanet)=-185
                if abs(planetmap(x,y,lastplanet))=4 then planetmap(x,y,lastplanet)=-185
            next
        next
        planetmap(30,10,lastplanet)=-187
        
        planets(lastplanet).mon_template(0)=makemonster(36,lastplanet)
        planets(lastplanet).mon_noamin(0)=13
        planets(lastplanet).mon_noamax(0)=27
        
        
        planets(lastplanet).mon_template(1)=makemonster(79,lastplanet)
        planets(lastplanet).mon_noamin(1)=13
        planets(lastplanet).mon_noamax(1)=27
        
        planets(lastplanet).atmos=6
        planets(lastplanet).depth=1
        
    endif
    
    if a=specialplanet(29)then
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=-4
            next
        next
        
        deletemonsters(a)
        planets_flavortext(a)="This is truly the most boring piece of rock you have ever laid eyes upon."
        planets(a).atmos=4
    endif
    
    if specialplanet(30)=a then 'Secret Base thingy
        wx=rnd_range(0,53)
        wy=rnd_range(0,13)
        
        deletemonsters(a)
        for x=wx to wx+7
            for y=wy to wy+7
                planetmap(x,y,a)=-18
            next
        next
        for x=wx+1 to wx+6
            for y=wy+1 to wy+6
                planetmap(x,y,a)=-16
            next
        next
        planetmap(wx+4,wy+4,a)=-4
        'planets(a).depth=7
        lastportal=lastportal+1
        portal(lastportal).desig="A building still in good condition. "
        portal(lastportal).tile=ASC("#")
        portal(lastportal).ti_no=3006
        portal(lastportal).col=14
        portal(lastportal).from.m=a
        portal(lastportal).from.x=wx+4
        portal(lastportal).from.y=wy+4
        portal(lastportal).dest.m=lastplanet+1
        'specialplanet(11)=portal(lastportal).dest.m
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_portals
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        lastplanet=lastplanet+1
        
        makecomplex(portal(lastportal).dest,lastplanet,1)
        wx=rnd_range(0,53)
        wy=rnd_range(0,13)
        for x=wx to wx+4
            for y=wy to wy+4
                planetmap(x,y,a)=-18
            next
        next
        for x=wx+1 to wx+3
            for y=wy+1 to wy+3
                planetmap(x,y,a)=-80
                if rnd_range(1,100)<33 then planetmap(x,y,a)=-81
                placeitem(make_item(rnd_range(96,99)),x,y,a)
            next
        next
        
        for b=0 to 6
            p1=rnd_point(lastplanet,0)
            p1.m=lastplanet
            lastplanet+=1
            p2=rnd_point(lastplanet,0)
            p2.m=lastplanet
            planets(lastplanet).depth=b+1
            makecomplex(p2,lastplanet,1)
            if b<6 then addportal(p1,p2,0,asc("o"),"A shaft",14)
        next    
        lastplanet+=1
        p2.x=32
        p2.y=2
        p2.m=lastplanet
        addportal(p1,p2,0,asc("o"),"A very deep shaft",14)
        makefinalmap(lastplanet)
    endif
    
    if a=specialplanet(31)then
        makemossworld(a,4)
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,a))=1 then planetmap(x,y,a)=-4 
                if abs(planetmap(x,y,a))=2 then planetmap(x,y,a)=-158 
                if abs(planetmap(x,y,a))=102 then planetmap(x,y,a)=-158 
                if abs(planetmap(x,y,a))=103 then planetmap(x,y,a)=-158 
                if abs(planetmap(x,y,a))=104 then planetmap(x,y,a)=-80 
                if abs(planetmap(x,y,a))=105 then planetmap(x,y,a)=-145 
                if abs(planetmap(x,y,a))=106 then planetmap(x,y,a)=-145 
                if abs(planetmap(x,y,a))=146 then planetmap(x,y,a)=-145 
            next
        next
        for b=0 to 5
            pa(b)=rnd_point
        next
        for b=0 to 4
            planetmap(pa(b).x,pa(b).y,a)=-170
            if rnd_range(1,100)<2 then planetmap(pa(b).x,pa(b).y,a)=-169
        next
        
        planets(a).atmos=1
        planets(a).grav=.5
        planets(a).rot=12
        planets(a).mon_template(0)=makemonster(8,a)
        planets(a).mon_noamin(0)=5
        planets(a).mon_noamax(0)=15
        
        planets(a).mon_template(1)=makemonster(51,a)
        planets(a).mon_noamin(1)=5
        planets(a).mon_noamax(1)=15
        
        planets(a).mon_template(2)=makemonster(52,a)
        planets(a).mon_noamin(2)=5
        planets(a).mon_noamax(2)=15
        
        planets(a).atmos=6
        planets(a).temp=-241
        p.x=30
        p.y=10
        gc.x=pa(5).x
        gc.y=pa(5).y
        gc.m=a    
        for b=0 to 4
            lastplanet+=1
            makeplatform(lastplanet,rnd_range(1,3)+b+2,rnd_range(0,1)+b,2,b*2)
            for c=0 to (b+1)*2
                p=rnd_point(lastplanet,0)
                placeitem(make_item(96),p.x,p.y,lastplanet)
                p=rnd_point(lastplanet,0)
                if rnd_range(1,100)<b+5 then placeitem(make_item(99),p.x,p.y,lastplanet) 
            next
            
            gc1.x=p.x
            gc1.y=p.y
            gc1.m=lastplanet
            addportal(gc,gc1,0,asc("o"),"A shaft",14)
            p=rnd_point(lastplanet,0)
            gc.x=p.x
            gc.y=p.y
            gc.m=lastplanet
            planets(lastplanet)=planets(a)
            planets(lastplanet).atmos=1
            planets(lastplanet).grav=.5
            planets(lastplanet).depth+=1
            planets(lastplanet).mon_template(0)=makemonster(8,lastplanet)
            planets(lastplanet).mon_noamin(0)=10
            planets(lastplanet).mon_noamax(0)=15
        
        next
        p=rnd_point(lastplanet,0)
        planetmap(p.x,p.y,lastplanet)=-234
    endif
    
    if a=specialplanet(32) then
        deletemonsters(a)
        pa(0).x=10
        pa(0).y=10
        pa(1).x=30
        pa(1).y=16
        pa(2).x=30
        pa(2).y=10
        d=rnd_range(1,3)
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=-8
                if rnd_range(1,100)<55 then planetmap(x,y,a)=-7
                if rnd_range(1,100)<15 then planetmap(x,y,a)=-158
                p.x=x
                p.y=y
                if distance(pa(0),p)<4 then planetmap(x,y,a)=-4
                if distance(pa(1),p)<4 then planetmap(x,y,a)=-4
                if distance(pa(2),p)<4 then planetmap(x,y,a)=-4
                if x>10 and x<30 and y=10 then planetmap(x,y,a)=-4
                
            next
        next
        p=rnd_point(a,0)
        planetmap(p.x,p.y,a)=-138
        p=rnd_point
        p2=p
        do
            if p.x<30 then p.x+=1
            if p.x>30 then p.x-=1
            planetmap(p.x,p.y,a)=-4
            if p.y<10 then p.y+=1
            if p.y>10 then p.y-=1
            planetmap(p.x,p.y,a)=-4
        loop until p.x=30 and p.y=10
        planetmap(p2.x,p2.y,a)=-4
        gc.x=p2.x
        gc.y=p2.y
        gc.m=a
        planets(a).atmos=1
        planets(a).grav=.3
        planets(a).temp=-211
        planets(a).rot=.8
        for b=0 to 2
            lastplanet+=1
            makeplatform(lastplanet,rnd_range(2,5)+b+2,rnd_range(1,3)+b,3)
            p=rnd_point(lastplanet,0)
            for c=0 to (b+1)*2
                placeitem(rnd_item(RI_StrandedShip),p.x,p.y,lastplanet)
                do
                    p=movepoint(p,5)
                loop until tiles(abs(planetmap(p.x,p.y,lastplanet))).walktru=0
            next
            p=rnd_point(lastplanet,0)
            for c=0 to (b+1)*2
                placeitem(make_item(96,6,-1),p.x,p.y,lastplanet)
                do
                    p=movepoint(p,5)
                loop until tiles(abs(planetmap(p.x,p.y,lastplanet))).walktru=0
            next
            p=rnd_point(lastplanet,0)
            planetmap(p.x,p.y,lastplanet)=-231
            p=rnd_point(lastplanet,0)
            gc1.x=p.x
            gc1.y=p.y
            gc1.m=lastplanet
            addportal(gc,gc1,0,asc(">"),"Stairs",15)
            p=rnd_point(lastplanet,0)
            gc.x=p.x
            gc.y=p.y
            gc.m=lastplanet
            planets(lastplanet).depth+=1
            planets(lastplanet).atmos=1
            planets(lastplanet).temp=1
            if d=1 then planets(lastplanet).mon_template(0)=makemonster(40,lastplanet)
            if d=2 then planets(lastplanet).mon_template(0)=makemonster(13,lastplanet)
            if d=3 then planets(lastplanet).mon_template(0)=makemonster(29,lastplanet)
            planets(lastplanet).mon_template(0).hasoxy=1
            planets(lastplanet).mon_noamin(0)=10
            planets(lastplanet).mon_noamax(0)=15
        
        next
    endif
        
    if a=specialplanet(33) then
        pa(0).x=10
        pa(0).y=10
        pa(1).x=30
        pa(1).y=16
        pa(2).x=30
        pa(2).y=10
        
        deletemonsters(a)
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=-8
                if rnd_range(1,100)<55 then planetmap(x,y,a)=-7
                if rnd_range(1,100)<15 then planetmap(x,y,a)=-158
                p.x=x
                p.y=y
                if distance(pa(0),p)<4 then planetmap(x,y,a)=-4
                if distance(pa(1),p)<4 then planetmap(x,y,a)=-4
                if distance(pa(2),p)<4 then planetmap(x,y,a)=-4
                
                if x>10 and x<30 and y=10 then planetmap(x,y,a)=-4
                
            next
        next
        for b=0 to 5
            p=rnd_point(a,0)
            if p.y=10 then p.y=11
            planetmap(p.x,p.y,a)=-67
        next
        p=rnd_point(a,2)
        p2=p
        do
            if p.x<30 then p.x+=1
            if p.x>30 then p.x-=1
            planetmap(p.x,p.y,a)=-4
            if p.y<10 then p.y+=1
            if p.y>10 then p.y-=1
            planetmap(p.x,p.y,a)=-4
        loop until p.x=30 and p.y=10
        planetmap(p2.x,p2.y,a)=-4
        gc.x=p2.x
        gc.y=p2.y
        gc.m=a
        planets(a).atmos=1
        planets(a).grav=.3
        planets(a).temp=-211
        planets(a).rot=.8
       
        planets(lastplanet).mon_template(0)=makemonster(3,a)
        planets(lastplanet).mon_noamin(0)=8
        planets(lastplanet).mon_noamax(0)=12
        for b=0 to 2
            lastplanet+=1
            makeplatform(lastplanet,rnd_range(2,5)+b+2,rnd_range(0,2)+b,3)
            p=rnd_point(lastplanet,0)
            for c=0 to (b+1)*2
                placeitem(rnd_item(RI_StrandedShip),p.x,p.y,lastplanet)
                do
                    p=movepoint(p,5)
                loop until tiles(abs(planetmap(p.x,p.y,lastplanet))).walktru=0
            next
            p=rnd_point(lastplanet,0)
            for c=0 to (b+1)*2
                placeitem(make_item(96,6,-1),p.x,p.y,lastplanet)
                do
                    p=movepoint(p,5)
                loop until tiles(abs(planetmap(p.x,p.y,lastplanet))).walktru=0
            next
            
            p=rnd_point(lastplanet,0)
            d=0
            for c=0 to (b+1)*2
                if d<4 then planetmap(p.x,p.y,lastplanet)=-215-d
                d+=1
                planets(lastplanet).flags(11+d)=rnd_range(2,6)
                do
                    p=movepoint(p,5)
                loop until tiles(abs(planetmap(p.x,p.y,lastplanet))).walktru=0
            next
            p=rnd_point(lastplanet,0)
            planetmap(p.x,p.y,lastplanet)=-231
            p=rnd_point(lastplanet,0)
            gc1.x=p.x
            gc1.y=p.y
            gc1.m=lastplanet
            addportal(gc,gc1,0,asc(">"),"Stairs",15)
            p=rnd_point(lastplanet,0)
            gc.x=p.x
            gc.y=p.y
            gc.m=lastplanet
            planets(lastplanet).depth+=1
            planets(lastplanet).atmos=6
            planets(lastplanet).temp=16
            planets(lastplanet).mon_template(0)=makemonster(3,lastplanet)
            planets(lastplanet).mon_template(0).hasoxy=1
            planets(lastplanet).mon_noamin(0)=8+b
            planets(lastplanet).mon_noamax(0)=18+b
        next
    endif
    
    if a=specialplanet(34) then 'Radioactive World 
        planets(a).water=15
        makeislands(a,3)
        for c=1 to 12+rnd_range(1,6)
            p1=rnd_point
            b=rnd_range(0,2)+rnd_range(0,2)+2
            for x=p1.x-4 to p1.x+4
                for y=p1.y-4 to p1.y+4
                    if x>=0 and y>=0 and x<=60 and y<=20 then
                        p2.x=x
                        p2.y=y
                        if distance(p1,p2)<b then planetmap(x,y,a)=-160
                        if distance(p1,p2)=b then planetmap(x,y,a)=-159
                    endif
                next
            next
            it=make_item(96,9,9)
            it.v2=6
            it.col=11
            it.desig="transuranic metals"
            it.v5=(it.v1+rnd_range(1,player.science(0)+it.v2))*(it.v2*rnd_range(1,10-player.science(0)))            
            placeitem(it,p1.x,p1.y,a)
        next
        p1=rnd_point
        planetmap(p1.x,p1.y,a)=-100 
        planets(a).mon_template(0)=makemonster(2,a)
        planets(a).mon_noamin(0)=5
        planets(a).mon_noamax(0)=7
    endif
    
    if a=specialplanet(35) then
        makeoceanworld(a,3)
        for b=0 to 36
            planetmap(rnd_range(0,60),rnd_range(4,16),a)=-239
        next
        deletemonsters(a)
        planets(a).temp=16.3
        planets(a).rot=12.3
        planets(a).atmos=5
        planets(a).mon_template(0)=makemonster(42,a)
        planets(a).mon_noamin(0)=10
        planets(a).mon_noamax(0)=25
        p1=rnd_point(a,,2)
        addship.x=p1.x
        addship.y=p1.y
        addship.m=a
        addship.s=18
        planetmap(p1.x,p1.y,a)=-149
        make_drifter(addship,2,1)
        deletemonsters(lastplanet)
        planets(lastplanet).mon_template(0)=makemonster(90,a)
        planets(lastplanet).mon_noamin(0)=0
        planets(lastplanet).mon_noamax(0)=5
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,lastplanet))=82 then planetmap(x,y,lastplanet)=-80 'Delete spawning computers
            next
        next
        for b=0 to rnd_range(1,6)
            p1=rnd_point(lastplanet,,202)
            planetmap(p1.x,p1.y,lastplanet)=-rnd_range(290,293)
        next
        for b=0 to rnd_range(1,6)
            p1=rnd_point(lastplanet,,202)
            placeitem(make_item(99),p1.x,p1.y,lastplanet)
        next
    endif
    
    if a=specialplanet(36) then
        planets(a).water=77
        makeislands(a,3)
        deletemonsters(a)
        planets(a).mon_template(0)=makemonster(43,a)
        planets(a).mon_noamin(0)=10
        planets(a).mon_noamax(0)=25
        planets(a).temp=12.3
        planets(a).atmos=8
        planets(a).rot=12.3
        for b=0 to 36
            planetmap(rnd_range(0,60),rnd_range(4,16),a)=-90
        next
        lastplanet+=1
        gc.x=rnd_range(0,60)
        gc.y=rnd_range(0,20)
        gc.m=a    
        gc1.x=rnd_range(0,60)
        gc1.y=rnd_range(0,20)
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc("o"),"A natural tunnel",7)
        makecavemap(gc1,2-rnd_range(1,4),4-rnd_range(1,8),0,0)
        for b=0 to 25
            planetmap(rnd_range(0,60),rnd_range(0,20),lastplanet)=-146
        next 
        deletemonsters(lastplanet)
        planets(lastplanet).mon_template(0)=makemonster(44,a)
        planets(lastplanet).mon_noamin(0)=1
        planets(lastplanet).mon_noamax(0)=1
        planets(lastplanet).depth=1
        planets(lastplanet).temp=12.3
        planets(lastplanet).atmos=8
        planets(lastplanet).rot=12.3
    endif
    
    if a=specialplanet(37) then 'Invisible Labyrinth
        planets(a).temp=12.3
        planets(a).atmos=8
        planets(a).rot=12.3
        it=make_item(96,9,9)
        it.v2=6
        it.col=3
        it.desig="lutetium"
        it.discovered=1
        it.v5=(it.v1+rnd_range(1,player.science(0)+it.v2))*(it.v2*rnd_range(1,10-player.science(0)))            
        placeitem(it,30,10,a)
    endif
    
    if a=specialplanet(38) then 'Ted Rofes and the living trees
        planets(a).water=57
        deletemonsters(a)
        makeislands(a,3)
        planetmap(rnd_range(1,60),rnd_range(3,12),a)=-62
         
        planets(a).mon_template(0)=makemonster(45,a)
        planets(a).mon_noamin(0)=45
        planets(a).mon_noamax(0)=46
        planets(a).mon_template(1)=makemonster(48,a)
        planets(a).mon_noamin(1)=1
        planets(a).mon_noamax(1)=1
        
        planets(a).temp=12.3
        planets(a).atmos=5
        planets(a).rot=12.3
        
        lastplanet+=1
        gc.x=rnd_range(0,60)
        gc.y=rnd_range(0,20)
        gc.m=a    
        gc1.x=rnd_range(0,60)
        gc1.y=rnd_range(0,20)
        gc1.m=lastplanet
        planets(lastplanet)=planets(a)
        planets(lastplanet).depth=2
        deletemonsters(lastplanet)
        planets(lastplanet).mon_template(0)=makemonster(8,lastplanet)
        planets(lastplanet).mon_noamin(0)=5
        planets(lastplanet).mon_noamax(0)=8
        makecavemap(gc1,3-rnd_range(1,4),3-rnd_range(1,6),0,0)
        addportal(gc,gc1,0,asc("o"),"A natural tunnel",7)
        gc.m=lastplanet   
        p1=rnd_point(lastplanet,0)
        gc.x=p1.x
        gc.y=p1.y
        lastplanet+=1
        planets(lastplanet)=planets(a)
        planets(lastplanet).depth=3
        deletemonsters(lastplanet)
                 
        planets(lastplanet).mon_template(0)=makemonster(8,lastplanet)
        planets(lastplanet).mon_noamin(0)=15
        planets(lastplanet).mon_noamax(0)=25
        
        planets(lastplanet).mon_template(1)=makemonster(54,lastplanet)
        planets(lastplanet).mon_noamin(1)=5
        planets(lastplanet).mon_noamax(1)=8
        
        planets(lastplanet).mon_template(2)=makemonster(53,lastplanet)
        planets(lastplanet).mon_noamin(2)=5
        planets(lastplanet).mon_noamax(2)=10
        
        gc1.x=rnd_range(1,59)
        gc1.y=rnd_range(1,19)
        gc1.m=lastplanet
        makecomplex(gc1,2)
        addportal(gc,gc1,0,asc("o"),"A shaft",14)
        p1=rnd_point(lastplanet,0)
        planetmap(p1.x,p1.y,lastplanet)=-240
    endif
    
    if a=specialplanet(39) then 'Burrowers
        deletemonsters(a)
        planets(a).grav=0.9
        planets(a).atmos=5
        planets(a).temp=15.3
        planets(a).weat=0
        makeislands(a,3)
        for b=0 to 166
            p1=rnd_point(a,0)
            planetmap(p1.x,p1.y,a)=-96
        next
        p1.x=30
        p1.y=10
        pa(0).x=rnd_range(1,20)
        pa(0).y=rnd_range(1,5)
        pa(1).x=rnd_range(21,40)
        pa(1).y=rnd_range(1,5)
        pa(2).x=rnd_range(41,60)
        pa(2).y=rnd_range(1,5)
        
        pa(3).x=rnd_range(1,20)
        pa(3).y=rnd_range(15,20)
        pa(4).x=rnd_range(21,40)
        pa(4).y=rnd_range(15,20)
        pa(5).x=rnd_range(41,60)
        pa(5).y=rnd_range(15,20)
        
        for b=0 to 5
            makeroad(pa(b),p1,a)
        next
        
        for b=0 to 5
            planetmap(pa(b).x,pa(b).y,a)=-16
        next
        planetmap(p1.x,p1.y,a)=-247
        
        planets(a).mon_template(0)=makemonster(85,a) 'Colonists
        
        planets(a).mon_noamin(0)=5
        planets(a).mon_noamax(0)=8
        
        planets(a).mon_template(1)=makemonster(83,a) 'Burrowers
        planets(a).mon_noamin(1)=10
        planets(a).mon_noamax(1)=15
        
        for b=0 to 2
            lastplanet+=1
            lastportal+=1
            portal(lastportal).desig="A hole in the ground. "
            portal(lastportal).tile=asc("o")
            portal(lastportal).ti_no=3001
            portal(lastportal).col=4
            portal(lastportal).from.m=a
            portal(lastportal).from.x=rnd_range(0,60)
            portal(lastportal).from.y=rnd_range(0,20)
            portal(lastportal).dest.m=lastplanet
            portal(lastportal).dest.x=rnd_range(1,59)
            portal(lastportal).dest.y=rnd_range(1,19)
            portal(lastportal).discovered=show_all
            portal(lastportal).tumod=10
            portal(lastportal).dimod=-3
            
            gc.x=portal(lastportal).dest.x
            gc.y=portal(lastportal).dest.y
            gc.m=lastplanet
            
            planets(lastplanet).grav=0.9
            planets(lastplanet).atmos=5
            planets(lastplanet).temp=15.3
            planets(lastplanet).weat=0
            planets(lastplanet).depth=1
            planets(lastplanet).mon_template(0)=makemonster(83,lastplanet)
            planets(lastplanet).mon_template(0).invis=0
            planets(lastplanet).mon_noamin(0)=20
            planets(lastplanet).mon_noamax(0)=25
            planets(lastplanet).mon_template(1)=makemonster(84,lastplanet)
            planets(lastplanet).mon_template(1).invis=0
            planets(lastplanet).mon_noamin(1)=2
            planets(lastplanet).mon_noamax(1)=5
            makecavemap(gc,6-rnd_range(2,7),3-rnd_range(1,6),0,0)
        next
    endif
        
    if a=specialplanet(40) then 'Eridianis Scandal
        planets(a).water=57
        planets(a).temp=33
        planets(a).rot=33
        planets(a).grav=0.9
        planets(a).atmos=5
        makeislands(a,3)
        p.x=rnd_range(1,52)
        p.y=rnd_range(1,12)
        for x=p.x to p.x+7
            for y=p.y to p.y+7
                if x=p.x or x=p.x+1 or x=p.x+6 or x=p.x+7 or y=p.y or y=p.y+1 or y=p.y+6 or y=p.y+7 then 
                    planetmap(x,y,a)=-16
                else
                    planetmap(x,y,a)=-68
                endif
            next
        next
        deletemonsters(a)
        planets(a).mon_template(0)=makemonster(86,a)
        planets(a).mon_noamin(0)=10
        planets(a).mon_noamax(0)=15
        planets(a).mon_template(1)=makemonster(1,a)
        planets(a).mon_template(1).diet=2
        planets(a).mon_template(1).disease=13
        planets(a).mon_template(1).faction=1
        planets(a).mon_noamin(1)=5
        planets(a).mon_noamax(1)=10
        lastplanet+=1
        makecomplex3(lastplanet,10,0,0,1)
        gc.x=p.x+4
        gc.y=p.y+4
        gc.m=a
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).mon_template(0)=makemonster(86,a)
        planets(lastplanet).mon_noamin(0)=15
        planets(lastplanet).mon_noamax(0)=20
        planets(lastplanet).mon_template(1)=makemonster(87,a)
        planets(lastplanet).mon_noamin(1)=2
        planets(lastplanet).mon_noamax(1)=3
        planets(lastplanet).depth=3
        planets(lastplanet).temp=20
        planets(lastplanet).atmos=4
        lastplanet+=1
        makecomplex3(lastplanet,10,0,0,1)
        p=rnd_point(lastplanet-1,0)
        gc.x=p.x
        gc.y=p.y
        gc.m=lastplanet-1
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).mon_template(0)=makemonster(86,a)
        planets(lastplanet).mon_noamin(0)=20
        planets(lastplanet).mon_noamax(0)=25
        planets(lastplanet).mon_template(1)=makemonster(87,a)
        planets(lastplanet).mon_noamin(1)=5
        planets(lastplanet).mon_noamax(1)=8
        planets(lastplanet).depth=6
        planets(lastplanet).temp=20
        planets(lastplanet).atmos=4
        p1=rnd_point(lastplanet,0)
        planetmap(p1.x,p1.y,lastplanet)=250
    endif
    
    if a=specialplanet(41) then 'Smith heavy industries Scandal
        makecraters(a,3)
        deletemonsters(a)
        p1=rnd_point
        p2=rnd_point
        p3=rnd_point
        p1.x=rnd_range(1,20)
        p2.x=rnd_range(20,40)
        p3.x=rnd_range(40,55)
        makeroad(p1,p2,a)
        makeroad(p1,p3,a)
        
        for x=p2.x to p2.x+5
            for y=p2.y to p2.y+3
                if x<=60 and y<=20 then planetmap(x,y,a)=-16
            next
        next
        for x=p1.x to p1.x+3
            for y=p2.y to p2.y+3
                if x<=60 and y<=20 then planetmap(x,y,a)=-68
            next
        next
        for x=p3.x to p3.x+3
            for y=p3.y to p3.y+3
                if x<=60 and y<=20 then planetmap(x,y,a)=-16
            next
        next
        
        planetmap(p1.x,p1.y,a)=-111
                
        planets(a).atmos=1
        planets(a).temp=-233
        planets(a).grav=.3
        planets(a).mon_template(0)=makemonster(70,a)
        planets(a).mon_noamin(0)=5
        planets(a).mon_noamax(0)=8
        planets(a).mon_template(1)=makemonster(71,a)
        planets(a).mon_noamin(1)=1
        planets(a).mon_noamax(1)=5
        lastplanet+=1
        makecomplex3(lastplanet,10,0,0,1)
        gc.x=p2.x+1
        gc.y=p2.y+1
        gc.m=a
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        if gc.x>60 then gc.x=60
        if gc.y>20 then gc.y=20
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).mon_template(0)=makemonster(71,lastplanet)
        planets(lastplanet).mon_noamin(0)=10
        planets(lastplanet).mon_noamax(0)=15
        planets(lastplanet).depth=3
        planets(lastplanet).atmos=4
        planets(lastplanet).temp=20
        planets(lastplanet).darkness=1
        planets(lastplanet).grav=.3
        lastplanet+=1
        makecomplex3(lastplanet,10,0,0,1)
        p=rnd_point(lastplanet-1,0)
        gc.x=p.x
        gc.y=p.y
        gc.m=lastplanet-1
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).mon_template(0)=makemonster(71,lastplanet)
        planets(lastplanet).mon_noamin(0)=15
        planets(lastplanet).mon_noamax(0)=20
        planets(lastplanet).mon_template(1)=makemonster(72,lastplanet)
        planets(lastplanet).mon_noamin(1)=5
        planets(lastplanet).mon_noamax(1)=6
        planets(lastplanet).mon_template(2)=makemonster(73,lastplanet)
        planets(lastplanet).mon_noamin(2)=10
        planets(lastplanet).mon_noamax(2)=15
        
        
        planets(lastplanet).depth=6
        planets(lastplanet).atmos=4
        planets(lastplanet).temp=20
        planets(lastplanet).darkness=1
        planets(lastplanet).grav=.3
        p1=rnd_point(lastplanet,0)
        planetmap(p1.x,p1.y,lastplanet)=252
        lastplanet+=1
        makecomplex4(lastplanet,10,1)
        p=rnd_point(lastplanet-1,0)
        gc.x=p.x
        gc.y=p.y
        gc.m=lastplanet-1
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        p1=rnd_point(lastplanet,0)
        planetmap(p1.x,p1.y,lastplanet)=-252
        planets(lastplanet).mon_template(0)=makemonster(71,lastplanet)
        planets(lastplanet).mon_noamin(0)=20
        planets(lastplanet).mon_noamax(0)=25
        planets(lastplanet).mon_template(1)=makemonster(72,lastplanet)
        planets(lastplanet).mon_noamin(1)=8
        planets(lastplanet).mon_noamax(1)=10
        planets(lastplanet).mon_template(2)=makemonster(73,lastplanet)
        planets(lastplanet).mon_noamin(2)=20
        planets(lastplanet).mon_noamax(2)=25
        planets(lastplanet).depth=6
        planets(lastplanet).atmos=4
        planets(lastplanet).darkness=1
        planets(lastplanet).grav=.3
        
    endif
    
    if a=specialplanet(42) then 'Triax Traders Scandal
        p2=rnd_point
        for x=p2.x to p2.x+5
            for y=p2.y to p2.y+5
                if x<60 and y<20 then 
                    planetmap(x,y,a)=-68
                    if rnd_range(1,100)<10 then planetmap(x,y,a)=67
                endif
            next
        next
        
        deletemonsters(a)
        gc.x=p2.x
        gc.y=p2.y
        gc.m=a
        lastplanet+=1
        makecomplex3(lastplanet,6,60,60,2)
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).mon_template(0)=makemonster(7,a)
        planets(lastplanet).mon_noamin(0)=10
        planets(lastplanet).mon_noamax(0)=15
        planets(lastplanet).mon_template(1)=makemonster(50,a)
        planets(lastplanet).mon_noamin(1)=10
        planets(lastplanet).mon_noamax(1)=15
        planets(lastplanet).depth=3
        planets(lastplanet).atmos=4
        planets(lastplanet).temp=20
        planets(lastplanet).darkness=1
        planets(lastplanet).grav=.3
        
        makeoutpost(a)
        planets(a).mon_template(0)=makemonster(7,a)
        planets(a).mon_noamin(0)=10
        planets(a).mon_noamin(0)=15
        lastplanet+=1
        makecomplex3(lastplanet,6,60,60,2)
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)=-16 or planetmap(x,y,a)=+16 then 
                    p1.x=x
                    p1.y=y
                endif
            next
        next
        makeroad(p1,p2,a)
        gc.x=p1.x
        gc.y=p1.y
        gc.m=a
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).mon_template(0)=makemonster(7,a)
        planets(lastplanet).mon_noamin(0)=10
        planets(lastplanet).mon_noamax(0)=15
        planets(lastplanet).mon_template(1)=makemonster(50,a)
        planets(lastplanet).mon_noamin(1)=10
        planets(lastplanet).mon_noamax(1)=15
        planets(lastplanet).depth=3
        planets(lastplanet).atmos=4
        planets(lastplanet).temp=20
        planets(lastplanet).darkness=1
        planets(lastplanet).grav=.3
        p2=rnd_point(lastplanet,0)
        
        gc.x=p2.x
        gc.y=p2.y
        gc.m=lastplanet
        lastplanet+=1
        makecomplex3(lastplanet,6,60,60,2)

        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).mon_template(0)=makemonster(7,a)
        planets(lastplanet).mon_noamin(0)=10
        planets(lastplanet).mon_noamax(0)=15
        planets(lastplanet).mon_template(1)=makemonster(50,a)
        planets(lastplanet).mon_noamin(1)=10
        planets(lastplanet).mon_noamax(1)=15
        planets(lastplanet).depth=3
        planets(lastplanet).atmos=4
        planets(lastplanet).temp=20
        planets(lastplanet).darkness=1
        planets(lastplanet).grav=.3
        p2=rnd_point(lastplanet,0)
        planetmap(p2.x,p2.y,lastplanet)=-255
    endif
    
    if a=specialplanet(43) then 'Omega Bioengineering Scandal
        makeplatform(a,rnd_range(4,8),rnd_range(1,3),4)
        deletemonsters(a)
        planets(a).temp=-160
        planets(a).grav=.1
        planets(a).atmos=9
        planets(a).depth=1
        planets(a).mon_template(0)=makemonster(76,a)
        planets(a).mon_noamin(0)=5
        planets(a).mon_noamax(0)=8
        planets(a).mon_template(1)=makemonster(77,a)
        planets(a).mon_noamin(1)=1
        planets(a).mon_noamax(1)=5
        
        p1=rnd_point(a,,80)
        gc.x=p1.x
        gc.y=p1.y
        gc.m=a
        lastplanet+=1
        makecomplex3(lastplanet,6,60,60,1)
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).temp=20
        planets(lastplanet).grav=1
        planets(lastplanet).atmos=4
        planets(lastplanet).mon_template(0)=makemonster(76,lastplanet)
        planets(lastplanet).mon_noamin(0)=10
        planets(lastplanet).mon_noamax(0)=15
        planets(lastplanet).mon_template(1)=makemonster(77,lastplanet)
        planets(lastplanet).mon_noamin(1)=4
        planets(lastplanet).mon_noamax(1)=6
        planets(lastplanet).mon_template(2)=makemonster(78,lastplanet)
        planets(lastplanet).mon_noamin(2)=10
        planets(lastplanet).mon_noamax(2)=15
        planets(lastplanet).depth=1
        p1=rnd_point(lastplanet,0)
        gc.x=p1.x
        gc.y=p1.y
        gc.m=lastplanet
        lastplanet+=1
        makecomplex3(lastplanet,6,60,60,1)
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).temp=20
        planets(lastplanet).grav=1
        planets(lastplanet).atmos=4
        planets(lastplanet).mon_template(0)=makemonster(76,lastplanet)
        planets(lastplanet).mon_noamin(0)=10
        planets(lastplanet).mon_noamax(0)=15
        planets(lastplanet).mon_template(1)=makemonster(77,lastplanet)
        planets(lastplanet).mon_noamin(1)=8
        planets(lastplanet).mon_noamax(1)=10
        planets(lastplanet).mon_template(2)=makemonster(78,lastplanet)
        planets(lastplanet).mon_noamin(2)=10
        planets(lastplanet).mon_noamax(2)=15
        planets(lastplanet).depth=1
        for b=0 to 1
            p=rnd_point(lastplanet,0)
            x1=rnd_range(6,8)
            y1=rnd_range(4,6)
            if p.x+x1>=59 then p.x=p.x-x1-1
            if p.y+y1>=19 then p.y=p.y-y1-1
            if p.x<0 then p.x=1
            if p.y<0 then p.y=1
            
            for x=p.x to p.x+x1
                for y=p.y to p.y+y1
                    if x=p.x or y=p.y or x=p.x+x1 or y=p.y+y1 then
                        planetmap(x,y,lastplanet)=-52
                    else
                        planetmap(x,y,lastplanet)=-202
                    endif
                next
            next
            if b=0 then    
                planets(lastplanet).vault(0).x=p.x
                planets(lastplanet).vault(0).y=p.y
                planets(lastplanet).vault(0).w=x1
                planets(lastplanet).vault(0).h=y1
                planets(lastplanet).vault(0).wd(5)=3
            endif
        next
        planetmap(p.x+x1/2,p.y+y1/2,lastplanet)=257
        for x=1 to 59
            for y=1 to 19
                if abs(planetmap(x,y,lastplanet))=52 then
                    if abs(planetmap(x-1,y,lastplanet))=202 and abs(planetmap(x+1,y,lastplanet))=202 then
                        if abs(planetmap(x,y+1,lastplanet))=52 and abs(planetmap(x,y-1,lastplanet))=52 then planetmap(x,y,lastplanet)=-54
                    endif
                    if abs(planetmap(x,y-1,lastplanet))=202 and abs(planetmap(x,y+1,lastplanet))=202 then
                        if abs(planetmap(x-1,y,lastplanet))=52 and abs(planetmap(x+1,y,lastplanet))=52 then planetmap(x,y,lastplanet)=-54
                    endif
                endif
            next
        next
    endif
    
    if a=specialplanet(44) then
        makecraters(a,0)
        deletemonsters(a)
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,a))=4 and rnd_range(1,100)<20 then planetmap(x,y,a)=-102 
                if abs(planetmap(x,y,a))=4 and rnd_range(1,100)<10 then planetmap(x,y,a)=-146
                if abs(planetmap(x,y,a))=7 and rnd_range(1,100)<10 then planetmap(x,y,a)=-244 
                if abs(planetmap(x,y,a))=8 and rnd_range(1,100)<15 then planetmap(x,y,a)=-244 
                if abs(planetmap(x,y,a))=8 and rnd_range(1,100)<15 then 
                    p.x=x
                    p.y=y
                endif
            next
        next
        if p.x=0 and p.y=0 then p=rnd_point
        planetmap(p.x,p.y,a)=-244
        planets(a).mon_template(0)=makemonster(8,a)
        planets(a).mon_noamin(0)=4
        planets(a).mon_noamax(0)=10
        
        gc.x=p.x
        gc.y=p.y
        gc.m=a
        p2=rnd_point
        gc1.x=p2.x
        gc1.y=p2.y
        lastplanet+=1
        gc1.m=lastplanet
        addportal(gc,gc1,1,asc("^"),"This tunnel leads deeper underground.",14)
        addportal(gc1,gc,1,asc("o"),"This tunnel leads back to the surface.",7)
        makecavemap(gc1,5,-1,0,0)
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,lastplanet))=4 and rnd_range(1,100)<20 then planetmap(x,y,lastplanet)=-102 
                if abs(planetmap(x,y,lastplanet))=4 and rnd_range(1,100)<12 then planetmap(x,y,lastplanet)=-146
            next
        next
        p.y=rnd_range(1,13)
        p.x=rnd_range(1,24)
        p2.x=rnd_range(30,54)
        p2.y=rnd_range(1,13)
        for x=p.x to p.x+6
            for y=p.y to p.y+6
                'planetmap(x,y,lastplanet)=-4
                if x=p.x or x=p.x+6 or y=p.y or y=p.y+6 then 
                    planetmap(x,y,lastplanet)=-52
                else
                    planetmap(x,y,lastplanet)=-4
                endif
            next
        next
        for x=p2.x to p2.x+6
            for y=p2.y to p2.y+6
                'planetmap(x,y,lastplanet)=-4
                if x=p2.x or x=p2.x+6 or y=p2.y or y=p2.y+6 then
                    planetmap(x,y,lastplanet)=-52
                else
                    planetmap(x,y,lastplanet)=-4
                endif
            next
        next
        planetmap(p.x+3,p.y,lastplanet)=-54
        planetmap(p.x+3,p.y+6,lastplanet)=-54
        planetmap(p.x,p.y+3,lastplanet)=-54
        planetmap(p.x+6,p.y+3,lastplanet)=-54
        
        planetmap(p2.x+3,p2.y,lastplanet)=-54
        planetmap(p2.x+3,p2.y+6,lastplanet)=-54
        planetmap(p2.x,p2.y+3,lastplanet)=-54
        planetmap(p2.x+6,p2.y+3,lastplanet)=-54
        
        
        planets(lastplanet).mon_template(0)=makemonster(8,a)
        planets(lastplanet).mon_noamin(0)=14
        planets(lastplanet).mon_noamax(0)=20
        
        planets(lastplanet).mon_template(1)=makemonster(56,a)
        planets(lastplanet).mon_noamin(1)=1
        planets(lastplanet).mon_noamax(1)=2
        
        for b=0 to 15
            placeitem(make_item(301),p.x+3,p.y+3,lastplanet,0,0)
        next
        planetmap(p.x+3,p.y+3,lastplanet)=-4
    endif
    
    if a=specialplanet(isgasgiant(a)) and isgasgiant(a)>1 and isgasgiant(a)<40 then
        deletemonsters(a)
        makeplatform(a,rnd_range(4,8),rnd_range(1,3),1)
        p=rnd_point(a,0)
        if rnd_range(1,100)<10 then placeitem(make_item(99),p.x,p.y,a,0,0)
        p=rnd_point(a,0)
        if rnd_range(1,100)<10 then placeitem(make_item(99),p.x,p.y,a,0,0)
        p=rnd_point(a,0)
        if rnd_range(1,100)<10 then planetmap(p.x,p.y,a)=-100
        p=rnd_point(a,0)
        if rnd_range(1,100)<88 then planetmap(p.x,p.y,a)=-178
        p=rnd_point(a,0)
        if rnd_range(1,100)<18 then planetmap(p.x,p.y,a)=-178

        planets(a).temp=-160
        planets(a).grav=1.1
        planets(a).atmos=9
        if rnd_range(1,100)<35 then                 
            planets(a).mon_template(0)=makemonster(8,a)
            planets(a).mon_noamin(0)=5
            planets(a).mon_noamax(0)=15
        endif
        if rnd_range(1,100)<25 then             
            planets(a).mon_template(0)=makemonster(9,a)
            planets(a).mon_noamin(0)=5
            planets(a).mon_noamax(0)=15
        endif
        if rnd_range(1,100)<15 then
             
            planets(a).mon_template(0)=makemonster(27,a)
            planets(a).mon_noamin(0)=1
            planets(a).mon_noamax(0)=5
        endif
        if rnd_range(1,100)<10 then
            planets(a).mon_template(0)=makemonster(61,a)
            planets(a).mon_noamin(0)=1
            planets(a).mon_noamax(0)=3
        endif
        
        if rnd_range(1,100)<10 then
            planets(a).mon_template(0)=makemonster(62,a)
            planets(a).mon_noamin(0)=1
            planets(a).mon_noamax(0)=3
        endif
        
        if rnd_range(1,100)<10 then
            planets(a).mon_template(0)=makemonster(63,a)
            planets(a).mon_noamin(0)=1
            planets(a).mon_noamax(0)=3
        endif
    endif
    return 0
end function



function makewhplanet() as short
    dim as short a,b,c,x,y
    dim as _cords p
    lastplanet+=1
    a=lastplanet
    whplanet=a
    b=-13
    makeplanetmap(a,3,9)
    deletemonsters(a)
    planets(a).mon_template(1)=makemonster(55,a)
    planets(a).mon_noamin(1)=2
    planets(a).mon_noamax(1)=3
    for x=0 to 60
        for y=0 to 20
            planetmap(x,y,a)=b
            if rnd_range(1,100)<22 then b=-14
            if rnd_range(1,100)<22 then b=-4
            if rnd_range(1,100)<22 then b=-3
            if rnd_range(1,100)<22 then b=-13
        next
    next
    
    for b=0 to 25
        p=rnd_point
            
        for c=0 to 15+rnd_range(2,6)+rnd_range(2,6)
            p=movepoint(p,5)
            planetmap(p.x,p.y,a)=-193
        next
    next
    p=rnd_point
    placeitem(make_item(99,13),p.x,p.y,a)
    p=rnd_point
    placeitem(make_item(99,16),p.x,p.y,a)
    return 0
end function