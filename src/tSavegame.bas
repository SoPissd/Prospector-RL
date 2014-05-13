'tSavegame.
'
'defines:
'count_savegames=1, getfilename=1, savegame_crashfilename=0,
', savegame=7, load_game=2
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
'     -=-=-=-=-=-=-=- TEST: tSavegame -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tSavegame -=-=-=-=-=-=-=-

declare function count_savegames() as short
declare function getfilename() as string
declare function load_game(filename as string) as short

#ifndef savegame 'allow this to be a forward
declare function savegame(crash as short=0) as short
#endif

'private function savegame_crashfilename(fname as String, ext as String) as String

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tSavegame -=-=-=-=-=-=-=-

namespace tSavegame
function init() as Integer
	return 0
end function
end namespace'tSavegame


#define cut2top


function count_savegames() as short
    dim as short c
    dim as string text
    chdir "savegames"
    text=dir$("*.sav")
    while text<>""
        text=dir$()
        c=c+1
    wend
    chdir ".."
    cls
    return c
end function


function getfilename() as string
    dim filename as string
    dim a as string
    dim b as string*36
    dim c as short
    dim n(24) as string
    dim d as string*36
    dim datestring as string*12
    dim ustring as string*512
    dim as string help
    dim text as string
    dim unflags(lastspecial) as byte
    dim artflags(lastartifact) as short
    dim f as integer
    dim i as integer
    dim as short j,ll,ca
    
    dim as integer crashfile, crashnr
    
    text="Savegames:"
    a=dir$("savegames/*.sav")
    while a<>""
        if a<>"empty.sav" and c<24 then
            c+=1
            n(c)=a

			crashfile= instr(n(c),"crash")
			if crashfile>0 then
				crashnr=val(mid(n(c),crashfile+len("crash"),1))
			EndIf

            if tFile.OpenBinary("savegames/"&n(c),f) then
				get #f,,b
	            get #f,,d
	            get #f,,datestring
	            get #f,,unflags()
	            get #f,,artflags()
		        tFile.Closefile(f)
            EndIf

            text=text &"/" & b &d &"("&datestring &")"

	        if crashfile>0 then
				text=text & " !" & crashnr
			EndIf
				            
            ll=0
            for j=0 to lastspecial
                if unflags(j)=1 then ll+=1
            next
            for j=0 to lastartifact
                if artflags(j)=1 then ca+=1
            next
            text=text &"/" & b &d &"(" &datestring &")"
            if ll>20 then
                help=help &"/ Discovered " & ll &" unique planets"
            else
                help=help &"/" &trim(uniques(unflags()))
            endif
            if ca>20 then
                help=help &"| Discovered "& ca &" artifacts"
            else
                help=help &"|"& trim(list_artifacts(artflags()))
            endif
            
	        if crashfile>0 then
				help=help & "|This is a crash-file.|"
			EndIf
            
        endif
        a=dir()
    wend
    text=text &"/Exit"
    c=menu(bg_randompictxt,text,help,2,2)
    if c>0 and c<=24 then filename=n(c)
    return filename
end function


function savegame_crashfilename(fname as String, ext as String) as String
	' use an unnumbered crash file
	' if one already exists, find a non-existing crash-file numbered from 1 to 9
	' wrap-around delete the next one so that there are at max 8 + the original, or 9 crash files per game 
	if not fileexists(fname+ext) then return fname+ext
	dim as short i,j
	j=0
	for i= 1 to 9 
		if not fileexists(fname & i & ext) then 
			j=i
			exit for
		EndIf		
	Next
	if (j=0) then j=1
	if (j=9) then
		kill(fname & 1 & ext)
	else 
		kill(fname & j+1 & ext)
	EndIf
    return fname & j & ext		
End function

function savegame(crash as short=0) as short
    dim back as short
    dim a as short
    dim b as short
    dim c as short
    dim fname as string
    dim f as integer
    dim desig as string*36
    dim names as string*36
    dim datestring as string*12
    dim cl as string
    dim unflags(lastspecial) as byte
    dim artifactstr as string*512

    'Needed for compression
    dim as Integer dest_len, header_len
    dim as Ubyte Ptr dest
    dim filedata_string as string
    dim as short emptyshort
    make_unflags(unflags())
    cl=player.h_sdesc
    names=player.desig
    desig="("&cl &", "&credits(player.money) &" Cr, T:" &display_time(tVersion.gameturn,2) &")"
    datestring=date_string
    'cls
    back=99
    f=freefile
    fname="savegames/"&player.desig
    if crash=0 then 
        fname=fname &".sav"
    else
        fname=savegame_crashfilename(fname &"-crash",".sav")
    endif
    print "Saving "&fname;
    open fname for binary as #f
    print ".";
    'save shortinfo
    put #f,,names
    put #f,,desig
    put #f,,datestring
    put #f,,unflags()
    put #f,,artflag()
    print ".";
    'save player
    put #f,,player
    put #f,,whtravelled
    put #f,,whplanet
    put #f,,ano_money
    put #f,,questroll
    put #f,,_autopickup
    put #f,,_autoinspect
    put #f,,ranoutoffuel
    put #f,,income()
    put #f,,piratekills()
    put #f,,farthestexpedition
    put #f,,BonesFlag
    put #f,,alliance()
    put #f,,bountyquest()
    put #f,,patrolquest()
    for a=1 to 255
        put #f,,crew(a)
    next

    for a=0 to 8
        put #f,,faction(a)
    next

    for a=0 to 9
        put #f,,tCompany.combon(a)
    next

    put #f,,captainskill
    put #f,,wage

    for a=0 to 16
        put #f,,tRetirement.assets(a)
    next

    print ".";
    for a=0 to 16

        put #f,,savefrom(a).awayteam
        put #f,,savefrom(a).lastlocalitem
        put #f,,savefrom(a).lastenemy
        if savefrom(a).lastenemy>0 then
            for b=0 to savefrom(a).lastenemy
                put #f,,savefrom(a).enemy(b)
            next
        endif
        put #f,,savefrom(a).ship
        put #f,,savefrom(a).map
        print ".";
        'dat(1)=dat(1)+sizeof(savefrom(a))
    next
    'save maps
    put #f,,wormhole
    for a=0 to laststar+wormhole
        put #f,,map(a)
        print ".";
    next
    for a=0 to 12
        put #f,,basis(a)
        print ".";
    next

    put #f,,lastprobe
    if lastprobe>0 then
        for a=1 to lastprobe
            put #f,,probe(a)
        next
    endif

    for a=1 to 4
        put #f,,tCompany.companystats(a)
    next

    put #f,,alienattacks

    put #f,,tCompany.lastshare
    for a=0 to tCompany.lastshare
        put #f,,tCompany.shares(a)
    next

    for a=0 to 2
        put #f,,shop_order(a)
    next

    for a=0 to 20
        for b=0 to 30
            put #f,,shopitem(a,b)
        next
        print ".";
    next
    for a=0 to 5
        for b=0 to 20
            put #f,,makew(b,a)
        next
    next

    put #f,,usedship()

    put #f,,lastcagedmonster
    for a=0 to lastcagedmonster
        put #f,,cagedmonster(a)
    next

    for x=0 to sm_x
        for y=0 to sm_y
            put #f,,spacemap(x,y)
        next
    next

    put #f,,lastdrifting
    if lastdrifting>128 then lastdrifting=128
    for a=1 to lastdrifting
        put #f,,drifting(a)
        print ".";
    next

    put #f,,lastportal
    for a=0 to lastportal
        put #f,,portal(a)
        print ".";
    next
    put #f,,_NoPB
    for a=0 to _NoPB
        put #f,,piratebase(a)
        print ".";
    next

    put #f,,lastplanet
    for a=0 to lastplanet
        put #f,,planetmap(0,0,a)
        if planetmap(0,0,a)<>0 then
            for b=0 to 60
                for c=0 to 20
                    put #f,,planetmap(b,c,a)
                next
            next
            put #f,,planets(a)
            print ".";
        endif
    next
    for a=0 to lastspecial
        put #f,,specialplanet(a)
        put #f,,specialflag(a)
    next

    for a=272 to 279
        put #f,,tiles(a)
    next

    print ".";

    put #f,,uid
    put #f,,lastitem
    for a=0 to lastitem
        put #f,,item(a)
    next



    print ".";
    'save pirates
    put #f,,reward()
    print ".";

    put #f,,flag()



    put #f,,firstwaypoint
    put #f,,lastwaypoint
    for a=0 to lastwaypoint
        put #f,,targetlist(a)
    next

    put #f,,lastfleet
    for a=0 to lastfleet
        put #f,,fleet(a)
    next
    print ".";

    'save comments
    put #f,,lastcom
    for a=1 to lastcom
        put #f,,coms(a)
        print ".";
    next

    for c=0 to 12
        for a=0 to 12
            for b=0 to 8
                put #f,,goods_prices(b,a,c)
            next
        next
    next

    for a=0 to lastquestguy
        put #f,,questguy(a)
    next

    put #f,,foundsomething

    put #f,,civ()
	tRng.save(f)
    
    tFile.Closefile(f)
    ?

    'Overwrites large save file with compressed save file. but skills if file is empty
    if fname<>"savegames/empty.sav" then
        if tFile.Openbinary(fname,f)=0 then
	        filedata_string = space(LOF(f))
	        get #f,, filedata_string
	        tFile.Closefile(f)
        EndIf

        dim as Integer src_len = len(filedata_string) + 1
        dest_len = compressBound(src_len)
        dest = Allocate(dest_len)
        kill(fname)

        if tFile.Openbinary(fname,f)=0 then        	    
	        compress(dest , @dest_len, StrPtr(filedata_string), src_len)
	        put #f,,names           '36 bytes
	        put #f,,desig           '36 bytes
	        put #f,,datestring      '12 bytes + 1 overhead
	        put #f,,unflags()       'lastspecial + 1 overhead
	        put #f,,artflag()       'lastartifact + 1 overhead
	        put #f,, src_len 'we can use this to know the amount of memory needed when we load - should be 4 bytes long
   		    'Putting in the short info the the load game menu
        	header_len =  36 + 36 + 12 + lastspecial + lastartifact*2 + 4 + 4 + 3 ' bytelengths of names, desig, datestring,
	        'unflags, artflag, src_len, header_len, and 3 bytes of over head for the 3 arrays datestring, unflags, artflag
	        put #f,, header_len
	        put #f,, *dest, dest_len
	        tFile.Closefile(f)
        EndIf
        Deallocate(dest)
        
'     	if <0 then
'			text= "Failed to save the crashed game."
'			tError.log_error(text)
'      	Print text
'     	EndIf
        
    endif
    'Done with compressed file stuff

    'set__color( 14,0)
    'cls
    return back
end function


function load_game(filename as string) as short
    dim from as short
    dim ship as _cords
    dim awayteam as _monster
    dim back as short
    dim a as short
    dim b as short
    dim c as short
    dim fname as string
    dim f as integer
    dim dat as string*36
    dim names as string*36
    dim datestring as string*12
    dim unflags(lastspecial) as byte
    dim as short emptyshort
    dim text as string
    dim p as _planet
    dim debug as byte

    'needed to handle the compressed data
    dim as uByte ptr src, dest
    dim as Integer src_len, dest_len, header_len
    dim as string compressed_data

    for a=0 to max_maps
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=0
            next
        next
        planets(a)=p
    next

    player.desig=filename
    tVersion.gamedesig=filename

    if filename<>"" then
        fname="savegames/"&filename
        print "loading"&fname;

        if (filename <> "savegames/empty.sav") _	'makes sure we dont load the uncompressed empty
        and (tFile.OpenBinary(fname,f)>0) then		'Starting the uncompress

            get #f,,names           '36 bytes
            get #f,,dat             '36 bytes
            get #f,,datestring      '12 bytes + 1 overhead
            get #f,,unflags()       'lastspecial + 1 overhead
            get #f,,artflag()       'lastartifact + 1 overhead

            get #f,,dest_len
            dest = Allocate(dest_len)

            get #f,,header_len
            src_len = LOF(f)-header_len
            src = Allocate(src_len)
            
            get #f,,*src, src_len
            tFile.Closefile(f)
            
            if uncompress(dest, @dest_len, src, src_len) = Z_OK then
				'make a copy of the compressed data
				if (tFile.OpenBinary(fname,f)>0) then
		            compressed_data = space(LOF(f))
		            get #f,, compressed_data
		            tFile.Closefile(f)
				endif
	
	            'and write out as uncompressed
	            kill(fname)	
				if (tFile.OpenBinary(fname,f)>0) then
		            put #f,, *dest, dest_len
		            tFile.Closefile(f)
				endif
            else
            	'not compressed
            endif
    	endif

        'Ending uncompress


		if (tFile.OpenBinary(fname,f)>0) then
		endif
			
        get #f,,names
        get #f,,dat
        get #f,,datestring
        get #f,,unflags()
        get #f,,artflag()
        print ".";
        'save player
        get #f,,player
        get #f,,whtravelled
        get #f,,whplanet
        get #f,,ano_money
        get #f,,questroll
        get #f,,_autopickup
        get #f,,_autoinspect
        get #f,,ranoutoffuel
        get #f,,income()
        get #f,,piratekills()
        get #f,,farthestexpedition
        get #f,,BonesFlag
        get #f,,alliance()
        get #f,,bountyquest()
        get #f,,patrolquest()
        
        for a=1 to 255
            get #f,,crew(a)
        next
    
        for a=0 to 8
            get #f,,faction(a)
        next

        for a=0 to 9
            get #f,,tCompany.combon(a)
        next

        get #f,,captainskill
        get #f,,wage
        for a=0 to 16
            get #f,,tRetirement.assets(a)
        next

        print ".";

        for a=0 to 16
            get #f,,savefrom(a).awayteam
            get #f,,savefrom(a).lastlocalitem
            get #f,,savefrom(a).lastenemy
            if savefrom(a).lastenemy>0 then
                for b=0 to savefrom(a).lastenemy
                    get #f,,savefrom(a).enemy(b)
                next
            endif
            get #f,,savefrom(a).ship
            get #f,,savefrom(a).map
            print ".";
        next
        get #f,,wormhole
        for a=0 to laststar+wormhole
            get #f,,map(a)
            print ".";
        next

        for a=0 to 12
            get #f,,basis(a)
            print ".";
        next

        get #f,,lastprobe
        if lastprobe>0 then
            for a=1 to lastprobe
                get #f,,probe(a)
            next
        endif

        for a=1 to 4
            get #f,,tCompany.companystats(a)
        next

        get #f,,alienattacks

        get #f,,tCompany.lastshare
        for a=0 to tCompany.lastshare
            Get #f,,tCompany.shares(a)
        next

        for a=0 to 2
            Get #f,,shop_order(a)
        next


        for a=0 to 20
            for b=0 to 30
                get #f,,shopitem(a,b)
            next
            print ".";
        next
        for a=0 to 5
            for b=0 to 20
                get #f,,makew(b,a)
            next
        next


        get #f,,usedship()

        get #f,,lastcagedmonster
        for a=0 to lastcagedmonster
            get #f,,cagedmonster(a)
        next



        for x=0 to sm_x
            for y=0 to sm_y
                get #f,,spacemap(x,y)
            next
        next

        get #f,,lastdrifting
        for a=1 to lastdrifting
            get #f,,drifting(a)
            print ".";
        next

        get #f,,lastportal
        for a=0 to lastportal
            get #f,,portal(a)
        next
        get #f,,_NoPB
        for a=0 to _NoPB
            get #f,,piratebase(a)
        next

        get #f,,lastplanet
        for a=0 to lastplanet
            get #f,,planetmap(0,0,a)

            if planetmap(0,0,a)<>0 then
                for b=0 to 60
                    for c=0 to 20
                        get #f,,planetmap(b,c,a)
                    next
                next
                get #f,,planets(a)
                print ".";
            endif
        next
        for a=0 to lastspecial
            get #f,,specialplanet(a)
            get #f,,specialflag(a)
            print ".";
        next

        for a=272 to 279
            get #f,,tiles(a)
        next

        get #f,,uid
        get #f,,lastitem
        for a=0 to lastitem
            get #f,,item(a)
            print ".";
        next
        'save pirates
        get #f,,reward()
        print ".";

        get #f,,flag()

        print ".";


        get #f,,firstwaypoint
        get #f,,lastwaypoint
        for a=0 to lastwaypoint
            get #f,,targetlist(a)
        next

        get #f,,lastfleet
        for a=0 to lastfleet
            get #f,,fleet(a)
        next
        print ".";

        get #f,,lastcom
        for a=1 to lastcom
            get #f,,coms(a)
            print ".";
        next

        for c=0 to 12
            for a=0 to 12
                for b=0 to 8
                    get #f,,goods_prices(b,a,c)
                next
            next
        next


        for a=0 to lastquestguy
            get #f,,questguy(a)
        next

        get #f,,foundsomething

        get #f,,civ()
        tRng.load(f)
	    
        tFile.Closefile(f)
        ?
        if fname<>"savegames/empty.sav" and configflag(con_savescumming)=1 then
            kill(fname)
        elseif (fname<>"savegames/empty.sav") and (len(compressed_data)>0) then
            'need to rewrite our compressed data back
            kill(fname)
			if (tFile.OpenBinary(fname,f)>0) then
	            put #f,, compressed_data
		        tFile.Closefile(f)
			endif
        endif
        player.lastvisit.s=-1
    else
    endif
    
    'cls
    
    DbgPortalsCSV
    DbgItems2CSV
	DbgFactionsCSV
	DbgFleetsCSV
    return 0
end function

#define cut2bottom
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tSavegame -=-=-=-=-=-=-=-
	tModule.register("tSavegame",@tSavegame.init()) ',@tSavegame.load(),@tSavegame.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tSavegame -=-=-=-=-=-=-=-
#endif'test
