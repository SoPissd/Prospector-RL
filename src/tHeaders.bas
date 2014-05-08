'tHeaders


Declare Function make_shipequip(a As Short) As _items
Declare Function roman(i As Integer) As String

Declare Function shares_value() As Short
Declare Function planet_artifacts_table() As String
Declare Function acomp_table() As String
Declare Function uid_pos(uid As UInteger) As Integer

Declare Function sort_items(List() As _items) As Short
Declare Function items_table() As String
Declare Function artifacts_html(artflags() As Short) As String
Declare Function postmort_html(text As String) As Short
Declare Function ship_table() As String
Declare Function uniques_html(unflags() As Byte) As String
Declare Function exploration_text_html() As String
Declare Function html_color(c As String,indent As Short=0,wid As Short=0) As String
Declare Function crew_html(c As _crewmember) As String
Declare Function skill_text(c As _crewmember) As String
Declare Function augment_text(c As _crewmember) As String
Declare Function crew_table() As String
Declare Function count_crew(crew() As _crewmember) As Short
Declare Function income_expenses_html() As String
Declare Function play_poker(st As Short) As Short
Declare Function card_shuffle(card() As Integer) As Short

'Declare Function font_load_bmp(ByRef _filename As String) As UByte Ptr

Declare Function player_eval(p() As _pokerplayer,i As Short,rules As _pokerrules) As Short
Declare Function change_captain_appearance(x As Short,y As Short) As Short
Declare Function captain_sprite() As Short

Declare Function draw_poker_table(p() As _pokerplayer,reveal As Short=0, winner As Short=0,r As _pokerrules) As Short
Declare Function better_hand(h1 As _handrank,h2 As _handrank) As Short
Declare Function poker_eval(c() As Integer, acehigh As Short,knowall As Short) As _handrank
Declare Function ace_highlo_eval(c() As Integer,knowall As Short) As _handrank
Declare Function sort_cards(card() As Integer,all As Short=0) As Short
Declare Function poker_next(i As Short,p() As _pokerplayer) As Short
Declare Function poker_winner(p() As _pokerplayer) As Short
Declare Function highest_pot(p() As _pokerplayer) As Short
Declare Function display_portals(slot As Short,osx As Short) As Short
Declare Function save_keyset() As Short

declare function trouble_with_tribbles() as short
Declare Function findbest_jetpack() As Short

' SUB DECLARATION
Declare Function add_a_or_an(t As String,beginning As Short) As String

' prospector .bas
Declare Function player_energylimits() As Short
Declare Function get_planet_cords(ByRef p As _cords,mapslot As Short,shteam As Byte=0) As String
Declare Function planet_cursor(p As _cords,mapslot As Short,ByRef osx As Short,shteam As Byte) As String

Declare Function start_new_game() As Short
Declare Function from_savegame(Key As String) As String
Declare Function wormhole_travel() As Short

Declare Function wormhole_ani(target As _cords) As Short
Declare Function target_landing(mapslot As Short,Test As Short=0) As Short
Declare Function landing(mapslot As Short,lx As Short=0,ly As Short=0, Test As Short=0) As Short
Declare Function scanning() As Short
Declare Function rescue() As Short
Declare Function asteroid_mining(slot As Short) As Short
Declare Function gasgiant_fueling(t As Short,orbit As Short,sys As Short) As Short
Declare Function dock_drifting_ship(a As Short) As Short
Declare Function move_rover(pl As Short) As Short
Declare Function rnd_crewmember(onship As Short=0) As Short
Declare Function haggle_(way As String) As Single
Declare Function botsanddrones_shop() As Short
Declare Function display_monsters(osx As Short) As Short
Declare Function alerts() As Short
Declare Function launch_probe() As Short
Declare Function move_probes() As Short
Declare Function retirement() As Short
Declare Function no_spacesuit(who() As Short,ByRef alle As Short=0) As Short
Declare Function add_questguys() As Short
Declare Function give_patrolquest(employer As Short) As Short
Declare Function reward_patrolquest() As Short

Declare Function com_radio(defender As _ship, attacker() As _ship, e_track_p() As _cords,e_track_v() As Short,e_map() As Byte,e_last As Short,mines_p() As _cords,mines_v() As Short,mines_last As Short)  As Short
Declare Function draw_shield(ship As _ship,osx As Short) As Short
Declare Function crew_menu(crew() As _crewmember, from As Short, r As Short=0,text As String="") As Short
declare function ep_rovermove(a as short,slot as short) as short

Declare Function load_palette() As Short
Declare Function open_file(filename As String) As Short
Declare Function death_text() As String

Declare Function merc_dis(fl As Short,ByRef goal As Short) As Short
Declare Function check_tasty_pretty_cargo() As Short
Declare Function update_tmap(slot As Short) As Short

Declare Function show_dotmap(x1 As Short, y1 As Short) As Short
Declare Function show_minimap(xx As Short,yy As Short) As Short
Declare Function lb_filter(lobk() As String, lobn() As Short, lobc() As Short,lobp() As _Cords ,last As Short) As Short

Declare Function remove_no_spacesuit(who() As Short,last As Short) As Short
Declare Function questguy_newloc(i As Short) As Short

Declare Function update_questguy_dialog(i As Short,node() As _dialognode,iteration As Short) As Short
Declare Function count_gas_giants_area(c As _cords,r As Short) As Short
Declare Function questguy_dialog(i As Short) As Short
Declare Function change_armor(st As Short) As Short
Declare Function urn(min As Short, max As Short,mult As Short,bonus As Short) As Short
Declare Function rarest_good() As Short
Declare Function display_stock() As Short
declare function repair_spacesuits(v as short=-1) as short

declare function gets_entry(x as short,y as short, slot as short) as short
Declare Function ep_friendfoe(i As Short,j As Short) As Short
Declare Function calcosx(x As Short,wrap As Byte) As Short
Declare Function rg_icechunk() As Short 
Declare Function ep_monsterupdate(i As Short, spawnmask() as _cords,lsp as short,mapmask() As Byte,nightday() As Byte,message() As Byte) As Short
Declare Function ep_nearest(i As Short) As Short
Declare Function ep_changemood(i As Short,message() As Byte) As Short
Declare Function ep_needs_spacesuit(slot As Short,c As _cords,ByRef reason As String="") As Short
Declare Function ep_display_clouds(cloudmap() As Byte) As Short

Declare Function ep_autoexplore(slot As Short) As Short
Declare Function ep_planetroute(route() As _cords,move As Short,start As _cords, target As _cords,rollover As Short) As Short
Declare Function ep_autoexploreroute(astarpath() As _cords,start As _cords,move As Short, slot As Short, rover As Short=0) As Short
Declare Function ep_roverreveal(i As Integer) As Short

Declare Function ep_portal() As _cords
Declare Function ep_pickupitem(Key As String) As Short
Declare Function ep_shipfire(shipfire() As _shipfire) As Short
Declare Function ep_checkmove(ByRef old As _cords,Key As String) As Short
Declare Function ep_examine() As Short
Declare Function ep_helmet() As Short
Declare Function ep_closedoor() As Short
Declare Function ep_radio(ByRef nextlanding As _cords,ByRef ship_landing As Short, shipfire() As _shipfire,lavapoint() As _cords, ByRef sf As Single, nightday() As Byte,localtemp() As Single) As Short
Declare Function ep_grenade(shipfire() As _shipfire, ByRef sf As Single) As Short
Declare Function ep_fire(mapmask() As Byte,Key As String,ByRef autofire_target As _cords) As Short
Declare Function ep_playerhitmonster(old As _cords, mapmask() As Byte) As Short
Declare Function ep_monstermove(spawnmask() As _cords, lsp As Short,  mapmask() As Byte,nightday() As Byte) As Short
Declare Function ep_items(localturn As Short) As Short
Declare Function ep_updatemasks(spawnmask() As _cords,mapmask() As Byte,nightday() As Byte, ByRef dawn As Single, ByRef dawn2 As Single) As Short
Declare Function ep_tileeffects(areaeffect() As _ae, ByRef last_ae As Short,lavapoint() As _cords, nightday() As Byte, localtemp() As Single,cloudmap() As Byte) As Short
Declare Function ep_landship(ByRef ship_landing As Short,nextlanding As _cords,nextmap As _cords) As Short
Declare Function ep_areaeffects(areaeffect() As _ae,ByRef last_ae As Short,lavapoint() As _cords, cloudmap() As Byte) As Short
Declare Function ep_atship() As Short
Declare Function ep_planeteffect(shipfire() As _shipfire, ByRef sf As Single,lavapoint() As _cords,localturn As Short,cloudmap() As Byte) As Short
Declare Function ep_jumppackjump() As Short
Declare Function ep_inspect(ByRef localturn As Short) As Short
Declare Function ep_launch(ByRef nextmap As _cords) As Short
Declare Function ep_lava(lavapoint() As _cords) As Short
Declare Function ep_communicateoffer(Key As String) As Short
Declare Function ep_spawning(spawnmask() As _cords,lsp As Short, diesize As Short,nightday() As Byte) As Short
Declare Function ep_dropitem() As Short
Declare Function ep_crater(shipfire() As _shipfire, ByRef sf As Single) As Short
Declare Function ep_fireeffect(p2 As _cords,slot As Short, c As Short, range As Short, mapmask() As Byte, first As Short=0,last As Short=0) As Short
Declare Function ep_heatmap(lavapoint() As _cords,lastlavapoint As Short) As Short
Declare Function fuzzyMatch( ByRef correct As String, ByRef match As String ) As Single
Declare Function place_shop_order(sh As Short) As Short
Declare Function lev_minimum( a As Integer, b As Integer, c As Integer ) As Integer

Declare Function addmoney(amount As Integer,mt As Byte) As Short
Declare Function count_and_make_weapons(st As Short) As Short

Declare Function income_expenses() As String
declare function civ_adapt_tiles(slot as short) as short

Declare Function teleport(awaytam As _cords, map As Short) As _cords
Declare Function move_monster(i As short, target As _cords,towards as byte,rollover as byte,mapmask() As Byte) As short
Declare Function hitmonster(defender As _monster,attacker As _monster,mapmask() As Byte, first As Short=-1, last As Short=-1) As _monster
Declare Function monsterhit(defender As _monster, attacker As _monster,vis As Byte) As _monster
Declare Function spacecombat(atts As _fleet, ter As Short) As Short
Declare Function spacestation(st As Short) As _ship
Declare Function buy_weapon(st As Short) As Short
Declare Function buy_engine() As Short
Declare Function update_world(location As Short) As Short
Declare Function robot_invasion() As Short
Declare Function explore_space() As Short
Declare Function explore_planet(from As _cords, orbit As Short) As _cords
Declare Function alienbomb(c As Short,slot As Short) As Short
Declare Function tohit_gun(a As Short) As Short
Declare Function tohit_close(a As Short) As Short
Declare Function missing_ammo() As Short
Declare Function max_hull(s As _ship) As Short
Declare Function change_loadout() As Short
Declare Function grenade(from As _cords,map As Short) As _cords
Declare Function poolandtransferweapons(s1 As _ship,s2 As _ship) As Short
Declare Function clear_gamestate() As Short
Declare Function planetflags_toship(m As Short) As _ship
Declare Function can_learn_skill(ci As Short,si As Short) As Short
Declare Function form_alliance(who As Short) As Short
Declare Function ask_alliance(who As Short) As Short
'

Declare Function colonize_planet(st As Short) As Short
Declare Function get_com_colon_candidate(st As Short) As Short
Declare Function score_planet(i As Short,st As Short) As Short
Declare Function score_system(s As Short,st As Short) As Short



Declare Function get_highestrisk_questguy(st As Short) As Short
Declare Function questguy_newquest(i As Short) As Short
Declare Function make_questitem(i As Short,wanthas As Short) As Short
Declare Function get_other_questguy(i As Short,sameplace As Byte=0) As Short
Declare Function rnd_questguy_byjob(jo As Short,self As Short=0) As Short

' fileIO.bas
Declare Function load_dialog_quests() As Short
Declare Function character_name(ByRef gender As Byte) As String
Declare Function count_lines(file As String) As Short
Declare Function delete_custom(pir As Short) As Short
Declare Function load_key(ByVal t As String,ByRef n As String="") As String
Declare Function assertpath(folder as string) as short
Declare Function file_size(filename as string) as integer
Declare Function check_filestructure() As Short
'
Declare Function load_sounds() As Short
Declare Function set_volume(volume as Integer) as short
Declare Function play_sound(iSound As Short,iRepeats As Short=1,iDelay As Short=0) as short
'
Declare Function load_fonts() As Short
Declare Function save_config(oldtiles As Short) As Short
Declare Function load_config() As Short
Declare Function background(fn As String) As Short
Declare Function save_bones(t As Short) As Short
Declare Function load_bones() As Short
Declare Function getbonesfile() As String
Declare Function configuration() As Short
Declare Function load_map(m As Short,slot As Short) As Short
Declare Function texttofile(text As String) As String
Declare Function load_keyset() As Short
Declare Function load_dialog(fn As String, n() As _dialognode) As Short
Declare Function get_biodata(e As _monster) As Integer
Declare Function is_passenger(i As Short) As Short
Declare Function add_passenger(n As String,typ As Short, price As Short, bonus As Short, target As Short, ttime As Short, gender As Short) As Short

Declare Function gen_fname(fname() As String) As Short
Declare Function cargo_text() As String
Declare Function weapon_text(w As _weap) As String

Declare Function bunk_multi() As Single
' prosIO.bas
Declare Function draw_border(xoffset As Short) As Short
Declare Function showteam(from As Short, r As Short=0,text As String="") As Short
Declare Function gainxp(slot As Short,v As Short=1) As String
Declare Function gain_talent(slot As Short,talent as short=0) As String
Declare Function add_talent(cr As Short, ta As Short, Value As Single) As Single
Declare Function remove_member(n As Short, f As Short) As Short
Declare Function changemoral(Value As Short, where As Short) As Short
Declare Function isgardenworld(m As Short) As Short
Declare Function show_wormholemap(j As Short=0) As Short
Declare Function list_inventory() As String
Declare Function equipment_value() As Integer

Declare Function keybindings(allowed As String="") As Short

Declare Function join_fight(f As Short) As Short

Declare Function shipstatus(heading As Short=0) As Short
Declare Function display_stars(bg As Short=0) As Short
Declare Function display_star(a As Short,fbg As Byte=0) As Short
Declare Function display_planetmap(slot As Short,xos As Short,bg As Byte) As Short
Declare Function display_station(a As Short) As Short
Declare Function display_ship(show As Byte=0) As Short
Declare Function add_stations() As Short

Declare Function display_ship_weapons(m As Short=0) As Short
Declare Function display_system(in As Short,forcebar As Byte=0,hi As Byte=0) As Short
Declare Function display_awayteam(showshipandteam As Byte=1,osx As Short=555) As Short
Declare Function dtile (x As Short,y As Short, tiles As _tile,visible As Byte) As Short
Declare Function locEOL() As _cords
Declare Function display_sysmap(x As Short, y As Short, in As Short, hi As Short=0,bl As String,br As String) As Short
Declare Function nextplan(p As Short,in As Short) As Short
Declare Function prevplan(p As Short,in As Short) As Short
Declare Function questguy_message(c As Short) As Short
Declare Function get_invbay_bytype(t As Short) As Short

Declare Function hpdisplay(a As _monster) As Short
Declare Function infect(a As Short, dis As Short) As Short
Declare Function diseaserun(a As Short) As Short
Declare Function settactics() As Short
Declare Function make_vismask(c As _cords,sight As Short,m As Short,ad as short=0) As Short
Declare Function vis_test(a As _cords,p As _cords,Test As Short) As Short
Declare Function ap_astar(start As _cords,ende As _cords,diff As Short) As Short
Declare Function has_questguy_want(i As Short,ByRef t As Short) As Short

Declare Function caged_monster_text() As String
Declare Function sell_alien(sh As Short) As Short
Declare Function skill_test(bonus As Short,targetnumber As Short,echo As String="") As Short
Declare Function vege_per(slot As Short) As Single
declare function wear_armor(a as short,b as short) as short
Declare Function add_ano(p1 As _cords,p2 As _cords,ano As Short=0) As Short
Declare Function makestuffstring(l As Short) As String
Declare Function levelup(p As _ship,from As Short) As _ship
Declare Function max_security() As Short
Declare Function get_freecrewslot() As Short
Declare Function add_member(a As Short,skill As Short) As Short
Declare Function cure_awayteam(where As Short) As Short
Declare Function heal_awayteam(ByRef a As _monster,heal As Short) As Short
Declare Function dam_awayteam(dam As Short,ap As Short=0,dis As Short=0) As String
Declare Function dplanet(p As _planet,orbit As Short, scanned As Short,slot As Short) As Short
Declare Function rlprint(text As String, col As Short=11) As Short
Declare Function scrollup(b As Short) As Short
Declare Function blink(ByVal p As _cords, osx As Short) As Short
Declare Function Menu(bg As Byte,text As String,help As String="", x As Short=2, y As Short=2,blocked As Short=0,markesc As Short=0,st As Short=-1) As Short
Declare Function move_ship(Key As String) As _ship
Declare Function total_bunks() As Short
Declare Function getplanet(sys As Short, forcebar As Byte=0) As Short
Declare Function get_system() As Short
Declare Function get_random_system(unique As Short=0,gascloud As Short=0, disweight As Short=0,hasgarden As Short=0) As Short
Declare Function getrandomplanet(s As Short) As Short
Declare Function sysfrommap(a As Short)As Short
Declare Function orbitfrommap(a As Short) As Short

Declare Function get_colony_building(map As Short) As _cords
Declare Function grow_colony(map As Short) As Short
Declare Function isbuilding(x As Short,y As Short,map As Short) As Short
Declare Function closest_building(p As _cords,map As Short) As _Cords
Declare Function grow_colonies() As Short
Declare Function count_tiles(i As Short,map As Short) As Short
Declare Function remove_building(map As Short) As Short
Declare Function count_diet(slot As Short,diet As Short) As Short

Declare Function merchant() As Single

Declare Function sort_by_distance(c As _cords,p() As _cords,l() As Short,last As Short) As Short
Declare Function wormhole_navigation() As Short

Declare Function random_pirate_system() As Short
Declare Function randomname() As String
Declare Function isgasgiant(m As Short) As Short
Declare Function countgasgiants(sys As Short) As Short
Declare Function isasteroidfield(m As Short) As Short
Declare Function countasteroidfields(sys As Short) As Short
Declare Function checkcomplex(map As Short,fl As Short) As Integer

Declare Function getdirection(Key As String) As Short
Declare Function keyplus(Key As String) As Short
Declare Function keyminus(Key As String) As Short
Declare Function paystuff(price As Integer) As Integer
Declare Function shop(sh As Short,pmod As Single, shopn As String) As Short
Declare Function mondis(enemy As _monster) As String
Declare Function getfilename() As String
Declare Function savegame(crash as short=0)As Short
Declare Function load_game(filename As String) As Short
Declare Function refuel_f(f As _fleet, st As Short) As _fleet
Declare Function load_font(fontdir As String,ByRef fh As UByte) As UByte Ptr

Declare Function load_tiles() As Short
Declare Function make_alienship(slot As Short, t As Short) As Short
Declare Function makecivfleet(slot As Short) As _fleet
Declare Function civfleetdescription(f As _fleet) As String
Declare Function string_towords(word() As String, s As String, break As String, punct As Short=0) As Short
Declare Function set_fleet(fl As _fleet)As Short

Declare Function com_vismask(c As _cords) As Short
Declare Function com_display(defender As _ship, attacker() As _ship, marked As Short, e_track_p() As _cords,e_track_v()As Short,e_map() As Byte,e_last As Short,mines_p() As _cords,mines_v() As Short,mines_last As Short) As Short
Declare Function com_gettarget(defender As _ship, wn As Short, attacker() As _ship,marked As Short,e_track_p() As _cords,e_track_v() As Short,e_map() As Byte,e_last As Short,mines_p() As _cords,mines_v() As Short,mines_last As Short) As Short
Declare Function com_getweapon() As Short
Declare Function com_fire(ByRef target As _ship,ByRef attacker As _ship,ByRef w As Short, gunner As Short, range As Short) As _ship
Declare Function com_sinkheat(s As _ship,manjets As Short) As Short
Declare Function com_hit(target As _ship, w As _weap,damage As Short, range As Short,attn As String,side As Short) As _ship
Declare Function com_side(target As _ship,c As _cords) As Short
Declare Function com_criticalhit(t As _ship, roll As Short) As _ship
Declare Function com_flee(defender As _ship,attacker() As _ship) As Short
Declare Function com_wstring(w As _weap, range As Short) As String
Declare Function com_testweap(w As _weap, p1 As _cords,attacker() As _ship,mines_p() As _cords,mines_last As Short, echo As Short=0) As Short
Declare Function com_remove(attacker() As _ship, t As Short,flag As Short=0) As Short
Declare Function com_dropmine(defender As _ship,mines_p() As _cords,mines_v() As Short,ByRef mines_last As Short,attacker() As _ship) As Short
Declare Function com_detonatemine(d As Short,mines_p() As _cords, mines_v() As Short, ByRef mines_last As Short, defender As _ship, attacker() As _ship) As Short
Declare Function com_damship(ByRef t As _ship, dam As Short, col As Short) As _ship
Declare Function com_mindist(s As _ship) As Short
Declare Function com_regshields(s As _ship) As Short
Declare Function com_shipbox(s As _ship, di As Short) As String
Declare Function com_NPCMove(defender As _ship,attacker() As _ship,e_track_p() As _cords,e_track_v() As Short,e_map() As Byte,ByRef e_last As Short) As Short
Declare Function com_NPCFire(defender As _ship,attacker() As _ship) As Short
Declare Function com_findtarget(defender As _ship,attacker() As _ship) As Short
Declare Function com_evaltarget(attacker As _ship,defender As _ship) As Short
Declare Function com_turn(dircur As Byte,dirdest As Byte,turnrate As Byte) As Short
Declare Function com_direction(dest As _cords,target As _cords) As Short
Declare Function com_shipfromtarget(target As _cords,defender As _ship,attacker() As _ship) As Short
Declare Function com_NPCfireweapon(ByRef defender As _ship, ByRef attacker As _ship,b As Short) As Short
Declare Function com_victory(attacker() As _ship) As Short
Declare Function com_add_e_track(ship As _ship,e_track_p() As _cords,e_track_v() As Short, e_map() As Byte,e_last As Short) As Short

declare function display_item(i as integer,osx as short,slot as short) as short
declare function display_portal(b as short,slot as short,osx as short) as short

Declare Function get_rumor(i As Short=18) As String
Declare Function show_standing() As Short

Declare Function date_string() As String
Declare Function com_targetlist(list_c() As _cords, list_e() As Short, defender As _ship, attacker() As _ship, mines_p() As _cords,mines_v() As Short, mines_last As Short) As Short
Declare Function load_quest_cargo(t As Short,car As Short,dest As Short) As Short

Declare Function keyin(allowed As String ="", blocked As Short=0)As String
Declare Function screenshot(a As Short) As Short
Declare Function logbook() As Short
Declare Function auto_pilot(start As _cords, ende As _cords, diff As Short) As Short
Declare Function bioreport(slot As Short) As Short
Declare Function messages() As Short
Declare Function storescreen(As Short) As Short
Declare Function alienname(flag As Short) As String
Declare Function communicate(e As _monster, mapslot As Short,monslot As Short) As Short
Declare Function artifact(c As Short) As Short
'declare function getshipweapon() as short
Declare Function getmonster() As Short
Declare Function findartifact(v5 As Short) As Short
Declare Function scrap_component() As Short

Declare Function ep_planetmenu(entrycords as _cords,slot As Short,shipfire() As _shipfire, spawnmask() As _cords, lsp As Short,loctemp As Single) As _cords
Declare Function ep_display(osx As Short=555) As Short
Declare Function earthquake(t As _tile,dam As Short)As _tile
Declare Function ep_gives(awayteam As _monster, ByRef nextmap As _cords, shipfire() As _shipfire, spawnmask() As _cords,lsp As Short,Key As String,loctemp As Single) As Short
Declare Function numfromstr(t As String) As Short
Declare Function explored_percentage_string() As String

'Star Map generation
Declare Function make_spacemap() As Short
Declare Function make_clouds() As Short
Declare Function add_drifters() As Short
Declare Function add_special_planets() As Short
Declare Function add_easy_planets(start As _cords) As Short
Declare Function add_stars() As Short
Declare Function add_company_shop(slot As Short,mt As Short) As Short

Declare Function add_wormholes() As Short
Declare Function add_event_planets() As Short
Declare Function add_caves() As Short
Declare Function add_piratebase() As Short
Declare Function distribute_stars() As Short


Declare Function makefinalmap(m As Short) As Short
Declare Function makecomplex(ByRef enter As _cords, down As Short,blocked As Byte=0) As Short
Declare Function makecomplex2(slot As Short,gc1 As _cords, gc2 As _cords, roundedcorners1 As Short,roundedcorners2 As Short,nocol1 As Short,nocol2 As Short,doorchance As Short,loopchance As Short,loopdoor As Short,adddoor As Short,addloop As Short,nosmallrooms As Short,culdesacruns As Short, t As Short) As Short
Declare Function makecomplex3(slot As Short,cn As Short, rc As Short,collums As Short,t As Short) As Short
Declare Function makecomplex4(slot As Short,rn As Short,tileset As Short) As Short
Declare Function makeplatform(slot As Short,platforms As Short,rooms As Short,translate As Short, adddoors As Short=0) As Short
Declare Function makelabyrinth(slot As Short) As Short
Declare Function invisiblelabyrinth(tmap() As _tile,xoff As Short ,yoff As Short, _x As Short=10, _y As Short=10) As Short
Declare Function makeroots(slot As Short) As Short
Declare Function makeplanetmap(a As Short,orbit As Short, spect As Short) As Short
Declare Function modsurface(a As Short,o As Short) As Short
Declare Function makecavemap(enter As _cords,tumod As Short,dimod As Short, spemap As Short, froti As Short,blocked As Short=1) As Short
Declare Function togglingfilter(slot As Short, high As Short=1, low As Short=2)  As Short
Declare Function make_special_planet(a As Short) As Short
Declare Function make_drifter(d As _driftingship,bg As Short=0,broken As Short=0, f As Short=0) As Short
Declare Function make_civilisation(slot As Short, m As Short) As Short
Declare Function makeice(a As Short, o As Short) As Short
Declare Function makecanyons(a As Short, o As Short) As Short
Declare Function makegeyseroasis(slot As Short) As Short
Declare Function makecraters(a As Short, o As Short) As Short
Declare Function makemossworld(a As Short,o As Short) As Short
Declare Function makeislands(a As Short, o As Short) As Short
Declare Function makeoceanworld(a As Short,o As Short) As Short
Declare Function adaptmap(slot As Short) As Short
Declare Function addpyramid(p As _cords,slot As Short) As Short
Declare Function floodfill4(map() As Short,x As Short,y As Short) As Short
Declare Function add_door(map() As Short) As Short
Declare Function add_door2(map() As Short) As Short
Declare Function remove_doors(map() As Short) As Short
Declare Function addcastle(dest As _cords,slot As Short) As Short
Declare Function make_mine(slot As Short) As Short

Declare Function makemudsshop(slot As Short, x1 As Short, y1 As Short) As Short
Declare Function make_eventplanet(slot As Short) As Short
Declare Function station_event(m As Short) As Short
Declare Function makewhplanet() As Short
Declare Function makeoutpost (slot As Short,x1 As Short=0, y1 As Short=0) As Short
Declare Function makesettlement(p As _cords,slot As Short, typ As Short) As Short
Declare Function makevault(r As _rect,slot As Short,nsp As _cords, typ As Short,ind As Short) As Short
Declare Function rndwallpoint(r As _rect, w As Byte) As _cords
Declare Function rndwall(r As _rect) As Short
Declare Function digger(ByVal p As _cords,map() As Short,d As Byte,ti As Short=2,stopti As Short=0) As Short
Declare Function flood_fill(x As Short,y As Short,map()As Short, flag As Short=0) As Short
Declare Function flood_fill2(x As Short,y As Short, xm As Short, ym As Short, map() As Byte) As Short
Declare Function findsmartest(slot As Short) As Short
Declare Function makeroad(ByVal s As _cords,ByVal e As _cords, a As Short) As Short
Declare Function addportal(from As _cords, dest As _cords, twoway As Short, tile As Short,desig As String, col As Short) As Short
Declare Function deleteportal(f As Short=0, d As Short=0) As Short
Declare Function checkvalid(x As Short,y As Short, map() As Short) As Short
Declare Function floodfill3(x As Short,y As Short,map() As Short) As Short
Declare Function checkdoor(x As Short,y As Short, map() As Short) As Short
Declare Function checkbord(x As Short,y As Short, map() As Short) As Short
Declare Function playerfightfleet(f As Short) As Short
Declare Function is_drifter(m As Short) As Short
Declare Function is_special(m As Short) As Short
Declare Function get_nonspecialplanet(disc As Short=0) As Short
Declare Function gen_traderoutes() As Short
Declare Function clean_station_event() As Short

'pirates
Declare Function friendly_pirates(f As Short) As Short
Declare Function ss_sighting(i As Short) As Short
Declare Function make_weapon(a As Short) As _weap
Declare Function make_ship(a As Short) As _ship
Declare Function makemonster(a As Short, map As Short, forcearms As Byte=0) As _monster
'awayteam as _monster, map as short, spawnmask() as _cords,lsp as short,x as short=0,y as short=0, mslot as short=0) as _monster
Declare Function makecorp(a As Short) As _basis
Declare Function collide_fleets() As Short
Declare Function move_fleets() As Short
Declare Function make_fleet() As _fleet
Declare Function makepatrol() As _fleet
Declare Function makemerchantfleet() As _fleet
Declare Function makepiratefleet(modifier As Short=0) As _fleet
Declare Function update_targetlist()As Short
Declare Function bestpilotinfleet(f As _fleet) As Short
Declare Function add_fleets(target As _fleet, source As _fleet) As _fleet
Declare Function piratecrunch(f As _fleet) As _fleet
Declare Function clearfleetlist() As Short
Declare Function countfleet(ty As Short) As Short
Declare Function meet_fleet(f As Short)As Short
#if __FB_DEBUG__
Declare Function debug_printfleet(f As _fleet) As String
#endif
Declare Function fleet_battle(ByRef red As _fleet,ByRef blue As _fleet) As Short
Declare Function getship(f As _fleet) As Short
Declare Function furthest(List() As _cords,last As Short, a As _cords,b As _cords) As Short

Declare Function makequestfleet(a As Short) As _fleet
Declare Function makealienfleet() As _fleet
Declare Function setmonster(enemy As _monster,map As Short,spawnmask()As _cords,lsp As Short,x As Short=0,y As Short=0,mslot As Short=0,its As Short=0) As _monster
Declare Function make_aliencolony(slot As Short,map As Short, popu As Short) As Short

Declare Function resolve_fight(f2 As Short) As Short
Declare Function decide_if_fight(f1 As Short,f2 As Short) As Short

Declare Function weapon_string() As String
Declare Function crew_text(c As _crewmember) As String

'highscore
Declare Function space_mapbmp() As Short


Declare Function explper() As Short
Declare Function money_text() As String
Declare Function exploration_text() As String
Declare Function mission_type() As String
Declare Function high_score(text As String) As Short
Declare Function post_mortemII(text As String) As Short
Declare Function score() As Integer
Declare Function get_death() As String

'cargotrade
Declare Function mudds_shop() As Short
Declare Function girlfriends(st As Short) As Short
Declare Function pay_bonuses(st As Short) As Short
Declare Function check_passenger(st As Short) As Short
Declare Function pirateupgrade() As Short
Declare Function customize_item() As Short
Declare Function findcompany(c As Short) As Short
Declare Function drawroulettetable() As Short
Declare Function towingmodules() As Short
Declare Function getshares(company As Short) As Short
Declare Function sellshares(company As Short,n As Short) As Short
Declare Function buyshares(company As Short,n As Short) As Short
Declare Function cropstock() As Short
Declare Function portfolio(x As Short,y As Short) As Short
Declare Function dividend() As Short
Declare Function getsharetype() As Short
Declare Function reroll_shops() As Short
Declare Function find_crew_type(t As Short) As Short
Declare Function used_ships() As Short

Declare Function hiring(st As Short, ByRef hiringpool As Short, hp As Short) As Short
Declare Function sort_crew() As Short
Declare Function shipupgrades(st As Short) As Short
Declare Function starting_turret() As _weap
Declare Function shipyard(where As Byte) As Short
Declare Function ship_inspection(price As Short) As Short

Declare Function buy_ship(st As Short,ds As String,pr As Short) As Short
Declare Function make_weap_helptext(w As _weap) As String

Declare Function ship_design(where As Byte) As Short
Declare Function custom_ships(where As Byte) As Short
Declare Function repair_hull(pricemod As Single=1) As Short
Declare Function refuel(st As Short,price As Single) As Short
Declare Function casino(staked As Short=0, st As Short=0) As Short
Declare Function play_slot_machine() As Short
Declare Function showprices(st As Short) As Short

Declare Function upgradehull(t As Short,ByRef s As _ship, forced As Short=0) As Short
Declare Function gethullspecs(t As Short,file As String) As _ship
Declare Function makehullbox(t As Short, file As String) As String
Declare Function company(st As Short) As Short
Declare Function merctrade(ByRef f As _fleet) As Short

Declare Function unload_f(f As _fleet, st As Short) As _fleet
Declare Function unload_s(s As _ship, st As Short) As _ship
Declare Function load_f(f As _fleet, st As Short) As _fleet
Declare Function load_s(s As _ship,goods As Short, st As Short) As Short
Declare Function trading(st As Short) As Short
Declare Function buygoods(st As Short) As Short
Declare Function sellgoods(st As Short) As Short
Declare Function recalcshipsbays() As Short
Declare Function stockmarket(st As Short) As Short
Declare Function displaywares(st As Short) As Short
Declare Function change_prices(st As Short,etime As Short) As Short
Declare Function getfreecargo() As Short
Declare Function getnextfreebay() As Short
Declare Function nextemptyc() As Short
Declare Function station_goods(st As Short,tb As Byte) As String
Declare Function cargobay(text As String,st As Short,sell As Byte=0) As String
Declare Function getinvbytype(t As Short) As Short
Declare Function removeinvbytype(t As Short, am As Short) As Short
Declare Function get_item_list(inv() As _items, invn()As Short, ty As Short=0,ty2 As Short=0,ty3 As Short=0,ty4 As Short=0,noequip As Short=0) As Short
Declare Function display_item_list(inv() As _items, invn() As Short, marked As Short, l As Short,x As Short,y As Short) As Short
Declare Function make_locallist(slot As Short) As Short

Declare Function sick_bay(st As Short=0,obe As Short=0) As Short
Declare Function first_unused(i As Short) As Short
Declare Function item_assigned(i As Short) As Short
Declare Function scroll_bar(Offset As Short,linetot As Short,lineshow As Short,winhigh As Short, x As Short,y As Short,col As Short) As Short
Declare Function next_item(c As Integer) As Integer
'Items
Declare Function check_item_filter(t As Short,f As Short) As Short
Declare Function item_filter() As Short
Declare Function equip_awayteam(m As Short) As Short
Declare Function removeequip() As Short
Declare Function lowest_by_id(id As Short) As Short
Declare Function findbest(t As Short,p As Short=0, m As Short=0,id As Short=0) As Short
Declare Function make_item(a As Short,mod1 As Short=0,mod2 As Short=0,prefmin As Short=0,nomod As Byte=0) As _items
Declare Function modify_item(i As _items, nomod As Byte) As _items
Declare Function placeitem(i As _items,x As Short=0,y As Short=0,m As Short=0,p As Short=0,s As Short=0) As Short
Declare Function get_item(ty As Short=0,ty2 As Short=0,ByRef num As Short=0,noequip As Short=0) As Short
Declare Function buysitems(desc As String,ques As String, ty As Short, per As Single=1,agrmod As Short=0) As Short
Declare Function giveitem(e As _monster,nr As Short) As Short
Declare Function changetile(x As Short,y As Short,m As Short,t As Short) As Short
Declare Function textbox(text As String,x As Short,y As Short,w As Short, fg As Short=11, bg As Short=0,pixel As Byte=0,ByRef op As Short=0,ByRef Offset As Short=0) As Short
Declare Function destroyitem(b As Short) As Short
Declare Function destroy_all_items_at(ty As Short, wh As Short) As Short
Declare Function calc_resrev() As Short
Declare Function count_items(i As _items) As Short
Declare Function findworst(t As Short,p As Short=0, m As Short=0) As Short
Declare Function rnd_item(t As Short) As _items
Declare Function getrnditem(fr As Short,ty As Short) As Short
Declare Function better_item(i1 As _items,i2 As _items) As Short
Declare Function list_artifacts(artflags() As Short) As String
Declare Function gen_shops() As Short

'math
Declare Function round_str(i As Double,c As Short) As String
Declare Function round_nr(i As Single,c As Short) As Single
Declare Function C_to_F(c As Single) As Single
Declare Function find_high(List() As Short,last As Short, start As Short=1) As Short
Declare Function find_low(List() As Short,last As Short,start As Short=1) As Short
Declare Function countdeadofficers(max As Short) As Short
Declare Function nearest_base(c As _cords) As Short
Declare Function sub0(a As Single,b As Single) As Single
Declare Function disnbase(c As _cords,weight As Short=2) As Single
Declare Function dispbase(c As _cords) As Single
Declare Function rnd_point(m As Short=-1,w As Short=-1, t As Short=-1,vege As Short=-1)As _cords
Declare Function rndrectwall(r As _rect,d As Short=5) As _cords
Declare Function fillmap(map() As Short,tile As Short) As Short
Declare Function fill_rect(r As _rect,t1 As Short, t2 As Short,map() As Short) As Short
Declare Function chksrd(p As _cords, slot As Short) As Short
Declare Function findrect(tile As Short,map()As Short, er As Short=0, fi As Short=60) As _rect
Declare Function content(r As _rect,tile As Short,map()As Short) As Integer
Declare Function distance(first As _cords, last As _cords,rollover As Byte=0) As Single
Declare Function rnd_range (first As Short, last As Short) As Short
Declare Function movepoint(ByVal c As _cords, a As Short, eo As Short=0,showstats As Short=0) As _cords
Declare Function pathblock(ByVal c As _cords,ByVal b As _cords,mapslot As Short,blocktype As Short=1,col As Short=0, delay As Short=100,rollover As Byte=0) As Short
Declare Function line_in_points(b As _cords,c As _cords,p() As _cords) As Short

Declare Function nearest(ByVal c As _cords, ByVal b As _cords,rollover As Byte=0) As Single
Declare Function farthest(c As _cords,b As _cords) As Single
Declare Function distributepoints(result() As _cords, ps() As _cords, last As Short) As Single
Declare Function getany(possible() As Short)As Short
Declare Function maximum(a As Double,b As Double) As Double
Declare Function minimum(a As Double,b As Double) As Double
Declare Function dominant_terrain(x As Short,y As Short,m As Short) As Short

Declare Function checkandadd(queue() As _pfcords,map() As Byte,in As Short) As Short
Declare Function add_p(queue() As _pfcords,p As _pfcords) As Short
Declare Function check(queue() As _pfcords, p As _pfcords) As Short
Declare Function nearlowest(p As _pfcords,queue() As _pfcords) As _pfcords
Declare Function gen_waypoints(queue() As _pfcords,start As _pfcords,goal As _pfcords,map() As Byte) As Short
Declare Function space_radio() As Short
'quest
Declare Function crew_bio(i As Short) As String
Declare Function find_passage_quest(m As Short, start As _cords, goal As _cords) As Short
Declare Function Find_Passage(m As Short, start As _cords, goal As _cords) As Short
Declare Function adapt_nodetext(t As String, e As _monster,fl As Short,qgindex As Short=0) As String
Declare Function do_dialog(no As Short,e As _monster, fl As Short) As Short
Declare Function node_menu(no As Short,node() As _dialognode, e As _monster, fl As Short,qgindex As Short=0) As Short
Declare Function dialog_effekt(effekt As String,p() As Short,e As _monster, fl As Short) As Short
Declare Function plant_name(ti As _tile) As String
Declare Function randomcritterdescription(enemy As _monster, spec As Short,weight As Short,movetype As Short,ByRef pumod As Byte,diet As Byte,water As Short,depth As Short) As _monster
Declare Function give_quest(st As Short) As Short
Declare Function bounty_quest_text() As String
Declare Function gen_bountyquests() As Short

Declare Function check_questcargo(st As Short) As Short
Declare Function reward_bountyquest(employer As Short) As Short

Declare Function getunusedplanet() As Short
Declare Function dirdesc(start As _cords,goal As _cords) As String
Declare Function rndsentence(e As _monster) As Short
Declare Function show_quests() As Short
Declare Function planet_bounty() As Short
Declare Function eris_does() As Short
Declare Function eris_doesnt_like_your_ship() As Short
Declare Function eris_finds_apollo() As Short

Declare Function low_morale_message() As Short
Declare Function es_part1() As String
Declare Function Crewblock() As String
Declare Function shipstatsblock() As String
Declare Function make_unflags(unflags() As Byte) As Short
Declare Function uniques(unflags() As Byte) As String
Declare Function talk_culture(c As Short) As Short
Declare Function foreignpolicy(c As Short, i As Byte) As Short
Declare Function first_lc(t As String) As String
Declare Function first_uc(t As String) As String


Declare Function text_to_html(text As String) As String

Declare Function hasassets() As Short
Declare Function sellassetts () As String
Declare Function es_title(ByRef pmoney As Single) As String
Declare Function es_living(ByRef pmoney As Single) As String
Declare Function system_text(a As Short) As String


'tUtils
Declare Function set__color(fg As Short,bg As Short,visible As Byte=1) As Short
Declare Function _tcol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger

