'tIndex

type _index
    dim as short maxl=128
    dim as short maxv=1024
    vindex(60,20,128) as short
    last(60,20) as short
    value(1024) as short
    vlast as short
    declare function index(x as short,y as short,i as short) as short
    declare function add(v as short,c as _cords) as short
    declare function remove(v as short,c as _cords) as short
    declare function move(v as short,oc as _cords,nc as _cords) as short
    declare function del() as short
end type

dim shared itemindex as _index
dim shared portalindex as _index

function _index.del() as short
    erase vindex,last,value
    vlast=0
    return 0
end function

function _index.index(x as short,y as short,i as short) as short
    return value(vindex(x,y,i))
end function

function _index.add(v as short,c as _cords) as short
    last(c.x,c.y)+=1
    if last(c.x,c.y)>maxl then return -1
    vlast+=1
    if vlast>maxv then return -2
    vindex(c.x,c.y,last(c.x,c.y))=vlast
    value(vlast)=v
    return 0
end function

function _index.remove(v as short, c as _cords) as short
    dim as short j,j2
    for j=1 to last(c.x,c.y)
        if index(c.x,c.y,j)=v then
            value(vindex(c.x,c.y,j))=value(vlast)
            vlast-=1
            vindex(c.x,c.y,j)=vindex(c.x,c.y,last(c.x,c.y))
            last(c.x,c.y)-=1
            exit for
        endif
    next
    return 0
end function

function _index.move(v as short,oc as _cords,nc as _cords) as short
    DbgPrint(last(oc.x,oc.y) &":"&last(nc.x,nc.y))
    remove(v,oc)
    add(v,nc)
    DbgPrint(last(oc.x,oc.y) &":"&last(nc.x,nc.y))
    return 0
end function

