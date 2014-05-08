
#if __FB_DEBUG__

Function _WeapdumpCSV() as Short
	dim as Short f,i,j,keep
    DbgPrint("WeapdumpCSV")
	keep=gameturn
    f=Freefile
    Open "weapdump.csv" For Output As #f
    For i=0 To 100
        gameturn=i*1000
        Print #f,display_time(gameturn)&","&make_item(96).desig
        For j=0 To 10
            'player.weapons(0)=make_weapon(6)
            'print #f,player.weapons(0).desig
        Next
    Next
    Close #f
	gameturn=keep
	return 0
End Function

Function _PlanetTempCSV() as Short
	dim as Short f,i,j
	dim as string text
    DbgPrint("PlanetTempCSV")
	f=Freefile
	Open "planettemp.csv" For Output As #f
    For i=0 To laststar
    	text=map(i).spec &";"
        For j=1 To 9
        	text=text &";"
            If map(i).planets(j)>0 And map(i).planets(j)<1024 Then
            	makeplanetmap(map(i).planets(j),j,map(i).spec)
                text=text &planets(map(i).planets(j)).temp
            EndIf
		Next
		Print #f,text
		'Print ".";
    Next
    Close #f
	return 0
End Function
    
Function _TilesCSV() as Short
	dim as Short f,i,j
    DbgPrint("TilesCSV")
	f=Freefile
	Open "tiles.csv" For Output As #f
	For i=1 To 400
		If tiles(i).gives>0 Then Print #f,i &";"&tiles(i).desc &";"& tiles(i).gives
	Next
	Close #f
	return 0
End Function

declare function change_prices(st as short,etime as short) as short

Function _PricesCSV() as Short
	dim as Short f,a,b
	dim as string Key
    DbgPrint("PricesCSV")
	f=Freefile
	basis(0).company=1
    Open "prices.csv" For Output As #f
    For b=1 To 200
        change_prices(0,1)
        Key=""
        For a=1 To 9
            Key &=basis(0).inv(a).p &";"
        Next
        For a=1 To 9
            Key &=basis(0).inv(a).v &";"
        Next
        Print #f,Key
	Next
	Close #f
	return 0
End Function

Function _MonsterCSV() as Short
	dim as Short f,a,b
    DbgPrint("MonsterCSV")
    f=Freefile
    Open "monster.csv" For Output As #f
    Print #f,"name;hp;speed;atcost;biodata"
    For a=1 To 400
        enemy(0)=makemonster(a,1)
        If enemy(0).sdesc<>"" Then Print #f,enemy(0).sdesc &";"& Int(enemy(0).hp)  &";"& enemy(0).speed  &";"& enemy(0).atcost &";"&get_biodata(enemy(0))
    Next
    Close #f
	return 0
End Function

Function _ItemsCSV() as Short
	dim as Short f,a
    dim i as _items
    DbgPrint("ItemsCSV")
    f=freefile
    open "items.csv" for output as #f
    for a=0 to 302
        i=make_item(a)
        if i.ldesc<>"" or i.desig<>"" then
            print #f,a &";"& i.desig
        endif
    next
    close #f
	return 0
End Function

Function _Items2CSV() as Short
	dim as Short f,a
    DbgPrint("Items2CSV")
    f=freefile
    open "items2.csv" for output as #f
    for a=0 to lastitem
        if item(a).w.s<0 then print #f,item(a).desig &";"&item(a).w.s &";"& item(a).ty &";"&item(a).uid
    next
    close #f
	return 0
End Function

Function _ItemDump() as Short
	dim as Short f,i
    DbgPrint("Itemdump")
    f=freefile
    open "itemdump.txt" for output as #f
    for i=0 to lastitem
        print #f,i &";"&item(i).desig &";"&item(i).w.s &"m:"& item(i).w.m &"C:"&cords(item(i).w)
    next
    close #f
	return 0
End Function


Function _PortalsCSV() as Short
	dim as Short f,a
    DbgPrint("PortalsCSV")
    f=freefile
    open "portals.csv" for output as #f
    for a=0 to lastportal
        print #f,portal(a).from.x &";"&portal(a).from.y &";"&portal(a).from.m &";"& portal(a).dest.x &";"&portal(a).dest.y &";"&portal(a).dest.m &";"&portal(a).oneway
    next
    print #f,player.map
    close #f
	return 0
End Function

Function _FactionsCSV() as Short
	dim as Short f,a,b
	dim as string text
    f=freefile
    open "factions.csv" for output as #f
    for a=0 to 5
        text=""
        for b=0 to 5
            text=text &faction(a).war(b) &";"
        next
        print #f,text
    next
    close #f
	return 0
End Function

Function _FleetsCSV() as Short
	dim as Short f,a,b
    DbgPrint("FleetsCSV")
    f=freefile
    open "Fleets.csv" for output as #f
    print #f,_NoPB
    for a=0 to _NoPB
        print #f,piratebase(a)
    next
    for a=0 to lastfleet
        print #f,"Fleet "&fleet(a).ty &":"&cords(fleet(a).c)
        for b=0 to 15
            if fleet(a).mem(b).hull>0 then print #f,fleet(a).mem(b).hull
        next
    next
    close #f
    DbgPrint("Randombase:"&random_pirate_system)
	return 0
End Function

Function _FleetsDump() as Short
	dim as Short f,i
    DbgPrint("Fleetdump")
    f=freefile
    open "Fleetdump.csv" for output as #f
    for i=0 to lastfleet
        print #f,i &";"& fleet(i).ty  &";"& fleet(i).count  &";"& cords(fleet(i).c)
    next
    close #f
	return 0
End Function

'

Function _DbgLogMQI(text as string) as Short	' not really a csv.. but anyway
	dim as Short f,a,b
    f=freefile
    open "MQI.txt" for append as #f
    print #f, text
    close #f
	return 0
End Function


' refine the previously declared debug helpers
' they will now do what they are supposed to do

#Define DbgWeapdumpCSV 		assert(not (_DbgPrintCSVs and _WeapdumpCSV()))
#Define DbgPlanetTempCSV 	assert(not (_DbgPrintCSVs and _PlanetTempCSV()))
#Define DbgTilesCSV 		assert(not (_DbgPrintCSVs and _TilesCSV()))
#Define DbgPricesCSV 		assert(not (_DbgPrintCSVs and _PricesCSV()))
#Define DbgMonsterCSV 		assert(not (_DbgPrintCSVs and _MonsterCSV()))
#Define DbgItemsCSV 		assert(not (_DbgPrintCSVs and _ItemsCSV()))
#Define DbgItems2CSV 		assert(not (_DbgPrintCSVs and _Items2CSV()))
#Define DbgPortalsCSV		assert(not (_DbgPrintCSVs and _PortalsCSV()))
#Define DbgFactionsCSV		assert(not (_DbgPrintCSVs and _FactionsCSV()))
#Define DbgFleetsCSV		assert(not (_DbgPrintCSVs and _FleetsCSV()))
'
#Define DbgLogMQI(text)		assert(not (_DbgPrintCSVs and _DbgLogMQI(text)))
#Define DbgItemDump 		assert(not (_DbgPrintCSVs and _ItemDump()))
#Define DbgFleetsDump 		assert(not (_DbgPrintCSVs and _FleetsDump()))


#if _DbgLogExplorePlanet=1
	dim shared _LogExplorePlanet as short
'	_LogExplorePlanet=freefile
'	open "exploreplanet.log" for output as _LogExplorePlanet
	
	#macro DbgLogExplorePlanet(text) 
_LogExplorePlanet=freefile
open "exploreplanet.log" for append as _LogExplorePlanet
		print #_LogExplorePlanet, text
close #_LogExplorePlanet
		DbgPrint(text)
	#EndMacro

	#define DbgLogExplorePlanetEnd 'close #_LogExplorePlanet

#else
	#define DbgLogExplorePlanet(text)
	#define DbgLogExplorePlanetEnd
#endif
	


#else ' not making a debug build

' define the 'debug only' subs here as noops
#Define DbgWeapdumpCSV 	
#Define DbgPlanetTempCSV 	
#Define DbgTilesCSV 		
#Define DbgPricesCSV 		
#Define DbgMonsterCSV	
#Define DbgItemsCSV	
#Define DbgItems2CSV
#Define DbgPortalsCSV		
#Define DbgFactionsCSV
#Define DbgFleetsCSV
'
#Define DbgLogMQI(text)
#Define DbgItemDump
#Define DbgFleetsDump
'
#define DbgLogExplorePlanet(text)
#define DbgLogExplorePlanetEnd

#endif


   
