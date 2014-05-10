'tHeaders


Declare function make_shipequip(a As Short) As _items
Declare function roman(i As Integer) As String

Declare function shares_value() As Short
Declare function planet_artifacts_table() As String
Declare function acomp_table() As String
Declare function uid_pos(uid As UInteger) As Integer

Declare function sort_items(List() As _items) As Short
Declare function items_table() As String
Declare function artifacts_html(artflags() As Short) As String
Declare function postmort_html(text As String) As Short
Declare function ship_table() As String
Declare function uniques_html(unflags() As Byte) As String
Declare function exploration_text_html() As String
Declare function html_color(c As String,indent As Short=0,wid As Short=0) As String
Declare function crew_html(c As _crewmember) As String
Declare function skill_text(c As _crewmember) As String
Declare function augment_text(c As _crewmember) As String
Declare function crew_table() As String
Declare function count_crew(crew() As _crewmember) As Short
Declare function income_expenses_html() As String
Declare function play_poker(st As Short) As Short
Declare function card_shuffle(card() As Integer) As Short

'Declare function font_load_bmp(ByRef _filename As String) As UByte Ptr

Declare function player_eval(p() As _pokerplayer,i As Short,rules As _pokerrules) As Short
Declare function change_captain_appearance(x As Short,y As Short) As Short
Declare function captain_sprite() As Short

Declare function draw_poker_table(p() As _pokerplayer,reveal As Short=0, winner As Short=0,r As _pokerrules) As Short
Declare function better_hand(h1 As _handrank,h2 As _handrank) As Short
Declare function poker_eval(c() As Integer, acehigh As Short,knowall As Short) As _handrank
Declare function ace_highlo_eval(c() As Integer,knowall As Short) As _handrank
Declare function sort_cards(card() As Integer,all As Short=0) As Short
Declare function poker_next(i As Short,p() As _pokerplayer) As Short
Declare function poker_winner(p() As _pokerplayer) As Short
Declare function highest_pot(p() As _pokerplayer) As Short
Declare function display_portals(slot As Short,osx As Short) As Short
Declare function save_keyset() As Short

declare function trouble_with_tribbles() as short
Declare function findbest_jetpack() As Short

' SUB DECLARATION
Declare function add_a_or_an(t As String,beginning As Short) As String

' prospector .bas
Declare function player_energylimits() As Short
Declare function get_planet_cords(ByRef p As _cords,mapslot As Short,shteam As Byte=0) As String
Declare function planet_cursor(p As _cords,mapslot As Short,ByRef osx As Short,shteam As Byte) As String

Declare function start_new_game() As Short
Declare function from_savegame(Key As String) As String
Declare function wormhole_travel() As Short

Declare function wormhole_ani(target As _cords) As Short
Declare function target_landing(mapslot As Short,Test As Short=0) As Short
Declare function landing(mapslot As Short,lx As Short=0,ly As Short=0, Test As Short=0) As Short
Declare function scanning() As Short
Declare function rescue() As Short
Declare function asteroid_mining(slot As Short) As Short
Declare function gasgiant_fueling(t As Short,orbit As Short,sys As Short) As Short
Declare function dock_drifting_ship(a As Short) As Short
Declare function move_rover(pl As Short) As Short
Declare function rnd_crewmember(onship As Short=0) As Short
Declare function haggle_(way As String) As Single
Declare function botsanddrones_shop() As Short
Declare function display_monsters(osx As Short) As Short
Declare function alerts() As Short
Declare function launch_probe() As Short
Declare function move_probes() As Short
Declare function retirement() As Short
Declare function no_spacesuit(who() As Short,ByRef alle As Short=0) As Short
Declare function add_questguys() As Short
Declare function give_patrolquest(employer As Short) As Short
Declare function reward_patrolquest() As Short

Declare function com_radio(defender As _ship, attacker() As _ship, e_track_p() As _cords,e_track_v() As Short,e_map() As Byte,e_last As Short,mines_p() As _cords,mines_v() As Short,mines_last As Short)  As Short
Declare function draw_shield(ship As _ship,osx As Short) As Short
Declare function crew_menu(crew() As _crewmember, from As Short, r As Short=0,text As String="") As Short
declare function ep_rovermove(a as short,slot as short) as short

Declare function load_palette() As Short
Declare function open_file(filename As String) As Short
Declare function death_text() As String

Declare function merc_dis(fl As Short,ByRef goal As Short) As Short
Declare function check_tasty_pretty_cargo() As Short
Declare function update_tmap(slot As Short) As Short

Declare function show_dotmap(x1 As Short, y1 As Short) As Short
Declare function show_minimap(xx As Short,yy As Short) As Short
Declare function lb_filter(lobk() As String, lobn() As Short, lobc() As Short,lobp() As _Cords ,last As Short) As Short

Declare function remove_no_spacesuit(who() As Short,last As Short) As Short
Declare function questguy_newloc(i As Short) As Short

Declare function update_questguy_dialog(i As Short,node() As _dialognode,iteration As Short) As Short
Declare function count_gas_giants_area(c As _cords,r As Short) As Short
Declare function questguy_dialog(i As Short) As Short
Declare function change_armor(st As Short) As Short
Declare function urn(min As Short, max As Short,mult As Short,bonus As Short) As Short
Declare function rarest_good() As Short
Declare function display_stock() As Short
declare function repair_spacesuits(v as short=-1) as short

declare function gets_entry(x as short,y as short, slot as short) as short
Declare function ep_friendfoe(i As Short,j As Short) As Short
Declare function calcosx(x As Short,wrap As Byte) As Short
Declare function rg_icechunk() As Short 
Declare function ep_monsterupdate(i As Short, spawnmask() as _cords,lsp as short,mapmask() As Byte,nightday() As Byte,message() As Byte) As Short
Declare function ep_nearest(i As Short) As Short
Declare function ep_changemood(i As Short,message() As Byte) As Short
Declare function ep_needs_spacesuit(slot As Short,c As _cords,ByRef reason As String="") As Short
Declare function ep_display_clouds(cloudmap() As Byte) As Short

Declare function ep_autoexplore(slot As Short) As Short
Declare function ep_planetroute(route() As _cords,move As Short,start As _cords, target As _cords,rollover As Short) As Short
Declare function ep_autoexploreroute(astarpath() As _cords,start As _cords,move As Short, slot As Short, rover As Short=0) As Short
Declare function ep_roverreveal(i As Integer) As Short

Declare function ep_portal() As _cords
Declare function ep_pickupitem(Key As String) As Short
Declare function ep_shipfire(shipfire() As _shipfire) As Short
Declare function ep_checkmove(ByRef old As _cords,Key As String) As Short
Declare function ep_examine() As Short
Declare function ep_helmet() As Short
Declare function ep_closedoor() As Short
Declare function ep_radio(ByRef nextlanding As _cords,ByRef ship_landing As Short, shipfire() As _shipfire,lavapoint() As _cords, ByRef sf As Single, nightday() As Byte,localtemp() As Single) As Short
Declare function ep_grenade(shipfire() As _shipfire, ByRef sf As Single) As Short
Declare function ep_fire(mapmask() As Byte,Key As String,ByRef autofire_target As _cords) As Short
Declare function ep_playerhitmonster(old As _cords, mapmask() As Byte) As Short
Declare function ep_monstermove(spawnmask() As _cords, lsp As Short,  mapmask() As Byte,nightday() As Byte) As Short
Declare function ep_items(localturn As Short) As Short
Declare function ep_updatemasks(spawnmask() As _cords,mapmask() As Byte,nightday() As Byte, ByRef dawn As Single, ByRef dawn2 As Single) As Short
Declare function ep_tileeffects(areaeffect() As _ae, ByRef last_ae As Short,lavapoint() As _cords, nightday() As Byte, localtemp() As Single,cloudmap() As Byte) As Short
Declare function ep_landship(ByRef ship_landing As Short,nextlanding As _cords,nextmap As _cords) As Short
Declare function ep_areaeffects(areaeffect() As _ae,ByRef last_ae As Short,lavapoint() As _cords, cloudmap() As Byte) As Short
Declare function ep_atship() As Short
Declare function ep_planeteffect(shipfire() As _shipfire, ByRef sf As Single,lavapoint() As _cords,localturn As Short,cloudmap() As Byte) As Short
Declare function ep_jumppackjump() As Short
Declare function ep_inspect(ByRef localturn As Short) As Short
Declare function ep_launch(ByRef nextmap As _cords) As Short
Declare function ep_lava(lavapoint() As _cords) As Short
Declare function ep_communicateoffer(Key As String) As Short
Declare function ep_spawning(spawnmask() As _cords,lsp As Short, diesize As Short,nightday() As Byte) As Short
Declare function ep_dropitem() As Short
Declare function ep_crater(shipfire() As _shipfire, ByRef sf As Single) As Short
Declare function ep_fireeffect(p2 As _cords,slot As Short, c As Short, range As Short, mapmask() As Byte, first As Short=0,last As Short=0) As Short
Declare function ep_heatmap(lavapoint() As _cords,lastlavapoint As Short) As Short
Declare function fuzzyMatch( ByRef correct As String, ByRef match As String ) As Single
Declare function place_shop_order(sh As Short) As Short
Declare function lev_minimum( a As Integer, b As Integer, c As Integer ) As Integer

Declare function addmoney(amount As Integer,mt As Byte) As Short
Declare function count_and_make_weapons(st As Short) As Short

Declare function income_expenses() As String
declare function civ_adapt_tiles(slot as short) as short

Declare function teleport(awaytam As _cords, map As Short) As _cords
Declare function move_monster(i As short, target As _cords,towards as byte,rollover as byte,mapmask() As Byte) As short
Declare function hitmonster(defender As _monster,attacker As _monster,mapmask() As Byte, first As Short=-1, last As Short=-1) As _monster
Declare function monsterhit(defender As _monster, attacker As _monster,vis As Byte) As _monster
Declare function spacecombat(atts As _fleet, ter As Short) As Short
Declare function spacestation(st As Short) As _ship
Declare function buy_weapon(st As Short) As Short
Declare function buy_engine() As Short
Declare function update_world(location As Short) As Short
Declare function robot_invasion() As Short
Declare function explore_space() As Short
Declare function explore_planet(from As _cords, orbit As Short) As _cords
Declare function alienbomb(c As Short,slot As Short) As Short
Declare function tohit_gun(a As Short) As Short
Declare function tohit_close(a As Short) As Short
Declare function missing_ammo() As Short
Declare function max_hull(s As _ship) As Short
Declare function change_loadout() As Short
Declare function grenade(from As _cords,map As Short) As _cords
Declare function poolandtransferweapons(s1 As _ship,s2 As _ship) As Short
Declare function clear_gamestate() As Short
Declare function planetflags_toship(m As Short) As _ship
Declare function can_learn_skill(ci As Short,si As Short) As Short
Declare function form_alliance(who As Short) As Short
Declare function ask_alliance(who As Short) As Short
'

Declare function colonize_planet(st As Short) As Short
Declare function get_com_colon_candidate(st As Short) As Short
Declare function score_planet(i As Short,st As Short) As Short
Declare function score_system(s As Short,st As Short) As Short



Declare function get_highestrisk_questguy(st As Short) As Short
Declare function questguy_newquest(i As Short) As Short
Declare function make_questitem(i As Short,wanthas As Short) As Short
Declare function get_other_questguy(i As Short,sameplace As Byte=0) As Short
Declare function rnd_questguy_byjob(jo As Short,self As Short=0) As Short

' fileIO.bas
Declare function load_dialog_quests() As Short
Declare function character_name(ByRef gender As Byte) As String
Declare function count_lines(file As String) As Short
Declare function delete_custom(pir As Short) As Short
Declare function load_key(ByVal t As String,ByRef n As String="") As String
Declare function assertpath(folder as string) as short
Declare function file_size(filename as string) as integer
Declare function check_filestructure() As Short
'
Declare function load_sounds() As Short
Declare function set_volume(volume as Integer) as short
Declare function play_sound(iSound As Short,iRepeats As Short=1,iDelay As Short=0) as short
'
Declare function load_fonts() As Short
Declare function save_config(oldtiles As Short) As Short
Declare function load_config() As Short
Declare function background(fn As String) As Short
Declare function save_bones(t As Short) As Short
Declare function load_bones() As Short
Declare function getbonesfile() As String
Declare function configuration() As Short
Declare function load_map(m As Short,slot As Short) As Short
Declare function texttofile(text As String) As String
Declare function load_keyset() As Short
Declare function load_dialog(fn As String, n() As _dialognode) As Short
Declare function get_biodata(e As _monster) As Integer
Declare function is_passenger(i As Short) As Short
Declare function add_passenger(n As String,typ As Short, price As Short, bonus As Short, target As Short, ttime As Short, gender As Short) As Short

Declare function gen_fname(fname() As String) As Short
Declare function cargo_text() As String
Declare function weapon_text(w As _weap) As String

Declare function bunk_multi() As Single
' prosIO.bas
Declare function draw_border(xoffset As Short) As Short
Declare function showteam(from As Short, r As Short=0,text As String="") As Short
Declare function gainxp(slot As Short,v As Short=1) As String
Declare function gain_talent(slot As Short,talent as short=0) As String
Declare function add_talent(cr As Short, ta As Short, Value As Single) As Single
Declare function remove_member(n As Short, f As Short) As Short
Declare function changemoral(Value As Short, where As Short) As Short
Declare function isgardenworld(m As Short) As Short
Declare function show_wormholemap(j As Short=0) As Short
Declare function list_inventory() As String
Declare function equipment_value() As Integer

Declare function keybindings(allowed As String="") As Short

Declare function join_fight(f As Short) As Short

Declare function shipstatus(heading As Short=0) As Short
Declare function display_stars(bg As Short=0) As Short
Declare function display_star(a As Short,fbg As Byte=0) As Short
Declare function display_planetmap(slot As Short,xos As Short,bg As Byte) As Short
Declare function display_station(a As Short) As Short
Declare function display_ship(show As Byte=0) As Short
Declare function add_stations() As Short

Declare function display_ship_weapons(m As Short=0) As Short
Declare function display_system(in As Short,forcebar As Byte=0,hi As Byte=0) As Short
Declare function display_awayteam(showshipandteam As Byte=1,osx As Short=555) As Short
Declare function dtile (x As Short,y As Short, tiles As _tile,visible As Byte) As Short
Declare function locEOL() As _cords
Declare function display_sysmap(x As Short, y As Short, in As Short, hi As Short=0,bl As String,br As String) As Short
Declare function nextplan(p As Short,in As Short) As Short
Declare function prevplan(p As Short,in As Short) As Short
Declare function questguy_message(c As Short) As Short
Declare function get_invbay_bytype(t As Short) As Short

Declare function hpdisplay(a As _monster) As Short
Declare function infect(a As Short, dis As Short) As Short
Declare function diseaserun(a As Short) As Short
Declare function settactics() As Short
Declare function make_vismask(c As _cords,sight As Short,m As Short,ad as short=0) As Short
Declare function vis_test(a As _cords,p As _cords,Test As Short) As Short
Declare function ap_astar(start As _cords,ende As _cords,diff As Short) As Short
Declare function has_questguy_want(i As Short,ByRef t As Short) As Short

Declare function caged_monster_text() As String
Declare function sell_alien(sh As Short) As Short
Declare function skill_test(bonus As Short,targetnumber As Short,echo As String="") As Short
Declare function vege_per(slot As Short) As Single
declare function wear_armor(a as short,b as short) as short
Declare function add_ano(p1 As _cords,p2 As _cords,ano As Short=0) As Short
Declare function makestuffstring(l As Short) As String
Declare function levelup(p As _ship,from As Short) As _ship
Declare function max_security() As Short
Declare function get_freecrewslot() As Short
Declare function add_member(a As Short,skill As Short) As Short
Declare function cure_awayteam(where As Short) As Short
Declare function heal_awayteam(ByRef a As _monster,heal As Short) As Short
Declare function dam_awayteam(dam As Short,ap As Short=0,dis As Short=0) As String
Declare function dplanet(p As _planet,orbit As Short, scanned As Short,slot As Short) As Short
Declare function rlprint(text As String, col As Short=11) As Short
Declare function scrollup(b As Short) As Short
Declare function blink(ByVal p As _cords, osx As Short) As Short
Declare function Menu(bg As Byte,text As String,help As String="", x As Short=2, y As Short=2,blocked As Short=0,markesc As Short=0,st As Short=-1) As Short
Declare function move_ship(Key As String) As _ship
Declare function total_bunks() As Short
Declare function getplanet(sys As Short, forcebar As Byte=0) As Short
Declare function get_system() As Short
Declare function get_random_system(unique As Short=0,gascloud As Short=0, disweight As Short=0,hasgarden As Short=0) As Short
Declare function getrandomplanet(s As Short) As Short
Declare function sysfrommap(a As Short)As Short
Declare function orbitfrommap(a As Short) As Short

Declare function get_colony_building(map As Short) As _cords
Declare function grow_colony(map As Short) As Short
Declare function isbuilding(x As Short,y As Short,map As Short) As Short
Declare function closest_building(p As _cords,map As Short) As _Cords
Declare function grow_colonies() As Short
Declare function count_tiles(i As Short,map As Short) As Short
Declare function remove_building(map As Short) As Short
Declare function count_diet(slot As Short,diet As Short) As Short

Declare function merchant() As Single

Declare function sort_by_distance(c As _cords,p() As _cords,l() As Short,last As Short) As Short
Declare function wormhole_navigation() As Short

Declare function random_pirate_system() As Short
Declare function randomname() As String
Declare function isgasgiant(m As Short) As Short
Declare function countgasgiants(sys As Short) As Short
Declare function isasteroidfield(m As Short) As Short
Declare function countasteroidfields(sys As Short) As Short
Declare function checkcomplex(map As Short,fl As Short) As Integer

Declare function getdirection(Key As String) As Short
Declare function keyplus(Key As String) As Short
Declare function keyminus(Key As String) As Short
Declare function paystuff(price As Integer) As Integer
Declare function shop(sh As Short,pmod As Single, shopn As String) As Short
Declare function mondis(enemy As _monster) As String
Declare function getfilename() As String
Declare function savegame(crash as short=0)As Short
Declare function load_game(filename As String) As Short
Declare function refuel_f(f As _fleet, st As Short) As _fleet
Declare function load_font(fontdir As String,ByRef fh As UByte) As UByte Ptr

Declare function load_tiles() As Short
Declare function make_alienship(slot As Short, t As Short) As Short
Declare function makecivfleet(slot As Short) As _fleet
Declare function civfleetdescription(f As _fleet) As String
Declare function string_towords(word() As String, s As String, break As String, punct As Short=0) As Short
Declare function set_fleet(fl As _fleet)As Short

Declare function com_vismask(c As _cords) As Short
Declare function com_display(defender As _ship, attacker() As _ship, marked As Short, e_track_p() As _cords,e_track_v()As Short,e_map() As Byte,e_last As Short,mines_p() As _cords,mines_v() As Short,mines_last As Short) As Short
Declare function com_gettarget(defender As _ship, wn As Short, attacker() As _ship,marked As Short,e_track_p() As _cords,e_track_v() As Short,e_map() As Byte,e_last As Short,mines_p() As _cords,mines_v() As Short,mines_last As Short) As Short
Declare function com_getweapon() As Short
Declare function com_fire(ByRef target As _ship,ByRef attacker As _ship,ByRef w As Short, gunner As Short, range As Short) As _ship
Declare function com_sinkheat(s As _ship,manjets As Short) As Short
Declare function com_hit(target As _ship, w As _weap,damage As Short, range As Short,attn As String,side As Short) As _ship
Declare function com_side(target As _ship,c As _cords) As Short
Declare function com_criticalhit(t As _ship, roll As Short) As _ship
Declare function com_flee(defender As _ship,attacker() As _ship) As Short
Declare function com_wstring(w As _weap, range As Short) As String
Declare function com_testweap(w As _weap, p1 As _cords,attacker() As _ship,mines_p() As _cords,mines_last As Short, echo As Short=0) As Short
Declare function com_remove(attacker() As _ship, t As Short,flag As Short=0) As Short
Declare function com_dropmine(defender As _ship,mines_p() As _cords,mines_v() As Short,ByRef mines_last As Short,attacker() As _ship) As Short
Declare function com_detonatemine(d As Short,mines_p() As _cords, mines_v() As Short, ByRef mines_last As Short, defender As _ship, attacker() As _ship) As Short
Declare function com_damship(ByRef t As _ship, dam As Short, col As Short) As _ship
Declare function com_mindist(s As _ship) As Short
Declare function com_regshields(s As _ship) As Short
Declare function com_shipbox(s As _ship, di As Short) As String
Declare function com_NPCMove(defender As _ship,attacker() As _ship,e_track_p() As _cords,e_track_v() As Short,e_map() As Byte,ByRef e_last As Short) As Short
Declare function com_NPCFire(defender As _ship,attacker() As _ship) As Short
Declare function com_findtarget(defender As _ship,attacker() As _ship) As Short
Declare function com_evaltarget(attacker As _ship,defender As _ship) As Short
Declare function com_turn(dircur As Byte,dirdest As Byte,turnrate As Byte) As Short
Declare function com_direction(dest As _cords,target As _cords) As Short
Declare function com_shipfromtarget(target As _cords,defender As _ship,attacker() As _ship) As Short
Declare function com_NPCfireweapon(ByRef defender As _ship, ByRef attacker As _ship,b As Short) As Short
Declare function com_victory(attacker() As _ship) As Short
Declare function com_add_e_track(ship As _ship,e_track_p() As _cords,e_track_v() As Short, e_map() As Byte,e_last As Short) As Short

declare function display_item(i as integer,osx as short,slot as short) as short
declare function display_portal(b as short,slot as short,osx as short) as short

Declare function get_rumor(i As Short=18) As String
Declare function show_standing() As Short

Declare function date_string() As String
Declare function com_targetlist(list_c() As _cords, list_e() As Short, defender As _ship, attacker() As _ship, mines_p() As _cords,mines_v() As Short, mines_last As Short) As Short
Declare function load_quest_cargo(t As Short,car As Short,dest As Short) As Short

Declare function keyin(allowed As String ="", blocked As Short=0)As String
Declare function screenshot(a As Short) As Short
Declare function logbook() As Short
Declare function auto_pilot(start As _cords, ende As _cords, diff As Short) As Short
Declare function bioreport(slot As Short) As Short
Declare function messages() As Short
Declare function storescreen(As Short) As Short
Declare function alienname(flag As Short) As String
Declare function communicate(e As _monster, mapslot As Short,monslot As Short) As Short
Declare function artifact(c As Short) As Short
'declare function getshipweapon() as short
Declare function getmonster() As Short
Declare function findartifact(v5 As Short) As Short
Declare function scrap_component() As Short

Declare function ep_planetmenu(entrycords as _cords,slot As Short,shipfire() As _shipfire, spawnmask() As _cords, lsp As Short,loctemp As Single) As _cords
Declare function ep_display(osx As Short=555) As Short
Declare function earthquake(t As _tile,dam As Short)As _tile
Declare function ep_gives(awayteam As _monster, ByRef nextmap As _cords, shipfire() As _shipfire, spawnmask() As _cords,lsp As Short,Key As String,loctemp As Single) As Short
Declare function numfromstr(t As String) As Short
Declare function explored_percentage_string() As String

'Star Map generation
Declare function make_spacemap() As Short
Declare function make_clouds() As Short
Declare function add_drifters() As Short
Declare function add_special_planets() As Short
Declare function add_easy_planets(start As _cords) As Short
Declare function add_stars() As Short
Declare function add_company_shop(slot As Short,mt As Short) As Short

Declare function add_wormholes() As Short
Declare function add_event_planets() As Short
Declare function add_caves() As Short
Declare function add_piratebase() As Short
Declare function distribute_stars() As Short


Declare function makefinalmap(m As Short) As Short
Declare function makecomplex(ByRef enter As _cords, down As Short,blocked As Byte=0) As Short
Declare function makecomplex2(slot As Short,gc1 As _cords, gc2 As _cords, roundedcorners1 As Short,roundedcorners2 As Short,nocol1 As Short,nocol2 As Short,doorchance As Short,loopchance As Short,loopdoor As Short,adddoor As Short,addloop As Short,nosmallrooms As Short,culdesacruns As Short, t As Short) As Short
Declare function makecomplex3(slot As Short,cn As Short, rc As Short,collums As Short,t As Short) As Short
Declare function makecomplex4(slot As Short,rn As Short,tileset As Short) As Short
Declare function makeplatform(slot As Short,platforms As Short,rooms As Short,translate As Short, adddoors As Short=0) As Short
Declare function makelabyrinth(slot As Short) As Short
Declare function invisiblelabyrinth(tmap() As _tile,xoff As Short ,yoff As Short, _x As Short=10, _y As Short=10) As Short
Declare function makeroots(slot As Short) As Short
Declare function makeplanetmap(a As Short,orbit As Short, spect As Short) As Short
Declare function modsurface(a As Short,o As Short) As Short
Declare function makecavemap(enter As _cords,tumod As Short,dimod As Short, spemap As Short, froti As Short,blocked As Short=1) As Short
Declare function togglingfilter(slot As Short, high As Short=1, low As Short=2)  As Short
Declare function make_special_planet(a As Short) As Short
Declare function make_drifter(d As _driftingship,bg As Short=0,broken As Short=0, f As Short=0) As Short
Declare function make_civilisation(slot As Short, m As Short) As Short
Declare function makeice(a As Short, o As Short) As Short
Declare function makecanyons(a As Short, o As Short) As Short
Declare function makegeyseroasis(slot As Short) As Short
Declare function makecraters(a As Short, o As Short) As Short
Declare function makemossworld(a As Short,o As Short) As Short
Declare function makeislands(a As Short, o As Short) As Short
Declare function makeoceanworld(a As Short,o As Short) As Short
Declare function adaptmap(slot As Short) As Short
Declare function addpyramid(p As _cords,slot As Short) As Short
Declare function floodfill4(map() As Short,x As Short,y As Short) As Short
Declare function add_door(map() As Short) As Short
Declare function add_door2(map() As Short) As Short
Declare function remove_doors(map() As Short) As Short
Declare function addcastle(dest As _cords,slot As Short) As Short
Declare function make_mine(slot As Short) As Short

Declare function makemudsshop(slot As Short, x1 As Short, y1 As Short) As Short
Declare function make_eventplanet(slot As Short) As Short
Declare function station_event(m As Short) As Short
Declare function makewhplanet() As Short
Declare function makeoutpost (slot As Short,x1 As Short=0, y1 As Short=0) As Short
Declare function makesettlement(p As _cords,slot As Short, typ As Short) As Short
Declare function makevault(r As _rect,slot As Short,nsp As _cords, typ As Short,ind As Short) As Short
Declare function rndwallpoint(r As _rect, w As Byte) As _cords
Declare function rndwall(r As _rect) As Short
Declare function digger(ByVal p As _cords,map() As Short,d As Byte,ti As Short=2,stopti As Short=0) As Short
Declare function flood_fill(x As Short,y As Short,map()As Short, flag As Short=0) As Short
Declare function flood_fill2(x As Short,y As Short, xm As Short, ym As Short, map() As Byte) As Short
Declare function findsmartest(slot As Short) As Short
Declare function makeroad(ByVal s As _cords,ByVal e As _cords, a As Short) As Short
Declare function addportal(from As _cords, dest As _cords, twoway As Short, tile As Short,desig As String, col As Short) As Short
Declare function deleteportal(f As Short=0, d As Short=0) As Short
Declare function checkvalid(x As Short,y As Short, map() As Short) As Short
Declare function floodfill3(x As Short,y As Short,map() As Short) As Short
Declare function checkdoor(x As Short,y As Short, map() As Short) As Short
Declare function checkbord(x As Short,y As Short, map() As Short) As Short
Declare function playerfightfleet(f As Short) As Short
Declare function is_drifter(m As Short) As Short
Declare function is_special(m As Short) As Short
Declare function get_nonspecialplanet(disc As Short=0) As Short
Declare function gen_traderoutes() As Short
Declare function clean_station_event() As Short

'pirates
Declare function friendly_pirates(f As Short) As Short
Declare function ss_sighting(i As Short) As Short
Declare function make_weapon(a As Short) As _weap
Declare function make_ship(a As Short) As _ship
Declare function makemonster(a As Short, map As Short, forcearms As Byte=0) As _monster
'awayteam as _monster, map as short, spawnmask() as _cords,lsp as short,x as short=0,y as short=0, mslot as short=0) as _monster
Declare function makecorp(a As Short) As _basis
Declare function collide_fleets() As Short
Declare function move_fleets() As Short
Declare function make_fleet() As _fleet
Declare function makepatrol() As _fleet
Declare function makemerchantfleet() As _fleet
Declare function makepiratefleet(modifier As Short=0) As _fleet
Declare function update_targetlist()As Short
Declare function bestpilotinfleet(f As _fleet) As Short
Declare function add_fleets(target As _fleet, source As _fleet) As _fleet
Declare function piratecrunch(f As _fleet) As _fleet
Declare function clearfleetlist() As Short
Declare function countfleet(ty As Short) As Short
Declare function meet_fleet(f As Short)As Short
#if __FB_DEBUG__
Declare function debug_printfleet(f As _fleet) As String
#endif
Declare function fleet_battle(ByRef red As _fleet,ByRef blue As _fleet) As Short
Declare function getship(f As _fleet) As Short
Declare function furthest(List() As _cords,last As Short, a As _cords,b As _cords) As Short

Declare function makequestfleet(a As Short) As _fleet
Declare function makealienfleet() As _fleet
Declare function setmonster(enemy As _monster,map As Short,spawnmask()As _cords,lsp As Short,x As Short=0,y As Short=0,mslot As Short=0,its As Short=0) As _monster
Declare function make_aliencolony(slot As Short,map As Short, popu As Short) As Short

Declare function resolve_fight(f2 As Short) As Short
Declare function decide_if_fight(f1 As Short,f2 As Short) As Short

Declare function weapon_string() As String
Declare function crew_text(c As _crewmember) As String

'highscore
Declare function space_mapbmp() As Short


Declare function explper() As Short
Declare function money_text() As String
Declare function exploration_text() As String
Declare function mission_type() As String
Declare function high_score(text As String) As Short
Declare function post_mortemII(text As String) As Short
Declare function score() As Integer
Declare function get_death() As String

'cargotrade
Declare function mudds_shop() As Short
Declare function girlfriends(st As Short) As Short
Declare function pay_bonuses(st As Short) As Short
Declare function check_passenger(st As Short) As Short
Declare function pirateupgrade() As Short
Declare function customize_item() As Short
Declare function findcompany(c As Short) As Short
Declare function drawroulettetable() As Short
Declare function towingmodules() As Short
Declare function getshares(company As Short) As Short
Declare function sellshares(company As Short,n As Short) As Short
Declare function buyshares(company As Short,n As Short) As Short
Declare function cropstock() As Short
Declare function portfolio(x As Short,y As Short) As Short
Declare function dividend() As Short
Declare function getsharetype() As Short
Declare function reroll_shops() As Short
Declare function find_crew_type(t As Short) As Short
Declare function used_ships() As Short

Declare function hiring(st As Short, ByRef hiringpool As Short, hp As Short) As Short
Declare function sort_crew() As Short
Declare function shipupgrades(st As Short) As Short
Declare function starting_turret() As _weap
Declare function shipyard(where As Byte) As Short
Declare function ship_inspection(price As Short) As Short

Declare function buy_ship(st As Short,ds As String,pr As Short) As Short
Declare function make_weap_helptext(w As _weap) As String

Declare function ship_design(where As Byte) As Short
Declare function custom_ships(where As Byte) As Short
Declare function repair_hull(pricemod As Single=1) As Short
Declare function refuel(st As Short,price As Single) As Short
Declare function casino(staked As Short=0, st As Short=0) As Short
Declare function play_slot_machine() As Short
Declare function showprices(st As Short) As Short

Declare function upgradehull(t As Short,ByRef s As _ship, forced As Short=0) As Short
Declare function gethullspecs(t As Short,file As String) As _ship
Declare function makehullbox(t As Short, file As String) As String
Declare function company(st As Short) As Short
Declare function merctrade(ByRef f As _fleet) As Short

Declare function unload_f(f As _fleet, st As Short) As _fleet
Declare function unload_s(s As _ship, st As Short) As _ship
Declare function load_f(f As _fleet, st As Short) As _fleet
Declare function load_s(s As _ship,goods As Short, st As Short) As Short
Declare function trading(st As Short) As Short
Declare function buygoods(st As Short) As Short
Declare function sellgoods(st As Short) As Short
Declare function recalcshipsbays() As Short
Declare function stockmarket(st As Short) As Short
Declare function displaywares(st As Short) As Short
Declare function change_prices(st As Short,etime As Short) As Short
Declare function getfreecargo() As Short
Declare function getnextfreebay() As Short
Declare function nextemptyc() As Short
Declare function station_goods(st As Short,tb As Byte) As String
Declare function cargobay(text As String,st As Short,sell As Byte=0) As String
Declare function getinvbytype(t As Short) As Short
Declare function removeinvbytype(t As Short, am As Short) As Short
Declare function get_item_list(inv() As _items, invn()As Short, ty As Short=0,ty2 As Short=0,ty3 As Short=0,ty4 As Short=0,noequip As Short=0) As Short
Declare function display_item_list(inv() As _items, invn() As Short, marked As Short, l As Short,x As Short,y As Short) As Short
Declare function make_locallist(slot As Short) As Short

Declare function sick_bay(st As Short=0,obe As Short=0) As Short
Declare function first_unused(i As Short) As Short
Declare function item_assigned(i As Short) As Short
Declare function scroll_bar(Offset As Short,linetot As Short,lineshow As Short,winhigh As Short, x As Short,y As Short,col As Short) As Short
Declare function next_item(c As Integer) As Integer
'Items
Declare function check_item_filter(t As Short,f As Short) As Short
Declare function item_filter() As Short
Declare function equip_awayteam(m As Short) As Short
Declare function removeequip() As Short
Declare function lowest_by_id(id As Short) As Short
Declare function findbest(t As Short,p As Short=0, m As Short=0,id As Short=0) As Short
Declare function make_item(a As Short,mod1 As Short=0,mod2 As Short=0,prefmin As Short=0,nomod As Byte=0) As _items
Declare function modify_item(i As _items, nomod As Byte) As _items
Declare function placeitem(i As _items,x As Short=0,y As Short=0,m As Short=0,p As Short=0,s As Short=0) As Short
Declare function get_item(ty As Short=0,ty2 As Short=0,ByRef num As Short=0,noequip As Short=0) As Short
Declare function buysitems(desc As String,ques As String, ty As Short, per As Single=1,agrmod As Short=0) As Short
Declare function giveitem(e As _monster,nr As Short) As Short
Declare function changetile(x As Short,y As Short,m As Short,t As Short) As Short
Declare function textbox(text As String,x As Short,y As Short,w As Short, fg As Short=11, bg As Short=0,pixel As Byte=0,ByRef op As Short=0,ByRef Offset As Short=0) As Short
Declare function destroyitem(b As Short) As Short
Declare function destroy_all_items_at(ty As Short, wh As Short) As Short
Declare function calc_resrev() As Short
Declare function count_items(i As _items) As Short
Declare function findworst(t As Short,p As Short=0, m As Short=0) As Short
Declare function rnd_item(t As Short) As _items
Declare function getrnditem(fr As Short,ty As Short) As Short
Declare function better_item(i1 As _items,i2 As _items) As Short
Declare function list_artifacts(artflags() As Short) As String
Declare function gen_shops() As Short

'math
Declare function round_str(i As Double,c As Short) As String
Declare function round_nr(i As Single,c As Short) As Single
Declare function C_to_F(c As Single) As Single
Declare function find_high(List() As Short,last As Short, start As Short=1) As Short
Declare function find_low(List() As Short,last As Short,start As Short=1) As Short
Declare function countdeadofficers(max As Short) As Short
Declare function nearest_base(c As _cords) As Short
Declare function sub0(a As Single,b As Single) As Single
Declare function disnbase(c As _cords,weight As Short=2) As Single
Declare function dispbase(c As _cords) As Single
Declare function rnd_point(m As Short=-1,w As Short=-1, t As Short=-1,vege As Short=-1)As _cords
Declare function rndrectwall(r As _rect,d As Short=5) As _cords
Declare function fillmap(map() As Short,tile As Short) As Short
Declare function fill_rect(r As _rect,t1 As Short, t2 As Short,map() As Short) As Short
Declare function chksrd(p As _cords, slot As Short) As Short
Declare function findrect(tile As Short,map()As Short, er As Short=0, fi As Short=60) As _rect
Declare function content(r As _rect,tile As Short,map()As Short) As Integer
Declare function distance(first As _cords, last As _cords,rollover As Byte=0) As Single
Declare function rnd_range (first As Short, last As Short) As Short
Declare function movepoint(ByVal c As _cords, a As Short, eo As Short=0,showstats As Short=0) As _cords
Declare function pathblock(ByVal c As _cords,ByVal b As _cords,mapslot As Short,blocktype As Short=1,col As Short=0, delay As Short=100,rollover As Byte=0) As Short
Declare function line_in_points(b As _cords,c As _cords,p() As _cords) As Short

Declare function nearest(ByVal c As _cords, ByVal b As _cords,rollover As Byte=0) As Single
Declare function farthest(c As _cords,b As _cords) As Single
Declare function distributepoints(result() As _cords, ps() As _cords, last As Short) As Single
Declare function getany(possible() As Short)As Short
Declare function maximum(a As Double,b As Double) As Double
Declare function minimum(a As Double,b As Double) As Double
Declare function dominant_terrain(x As Short,y As Short,m As Short) As Short

Declare function checkandadd(queue() As _pfcords,map() As Byte,in As Short) As Short
Declare function add_p(queue() As _pfcords,p As _pfcords) As Short
Declare function check(queue() As _pfcords, p As _pfcords) As Short
Declare function nearlowest(p As _pfcords,queue() As _pfcords) As _pfcords
Declare function gen_waypoints(queue() As _pfcords,start As _pfcords,goal As _pfcords,map() As Byte) As Short
Declare function space_radio() As Short
'quest
Declare function crew_bio(i As Short) As String
Declare function find_passage_quest(m As Short, start As _cords, goal As _cords) As Short
Declare function Find_Passage(m As Short, start As _cords, goal As _cords) As Short
Declare function adapt_nodetext(t As String, e As _monster,fl As Short,qgindex As Short=0) As String
Declare function do_dialog(no As Short,e As _monster, fl As Short) As Short
Declare function node_menu(no As Short,node() As _dialognode, e As _monster, fl As Short,qgindex As Short=0) As Short
Declare function dialog_effekt(effekt As String,p() As Short,e As _monster, fl As Short) As Short
Declare function plant_name(ti As _tile) As String
Declare function randomcritterdescription(enemy As _monster, spec As Short,weight As Short,movetype As Short,ByRef pumod As Byte,diet As Byte,water As Short,depth As Short) As _monster
Declare function give_quest(st As Short) As Short
Declare function bounty_quest_text() As String
Declare function gen_bountyquests() As Short

Declare function check_questcargo(st As Short) As Short
Declare function reward_bountyquest(employer As Short) As Short

Declare function getunusedplanet() As Short
Declare function dirdesc(start As _cords,goal As _cords) As String
Declare function rndsentence(e As _monster) As Short
Declare function show_quests() As Short
Declare function planet_bounty() As Short
Declare function eris_does() As Short
Declare function eris_doesnt_like_your_ship() As Short
Declare function eris_finds_apollo() As Short

Declare function low_morale_message() As Short
Declare function es_part1() As String
Declare function Crewblock() As String
Declare function shipstatsblock() As String
Declare function make_unflags(unflags() As Byte) As Short
Declare function uniques(unflags() As Byte) As String
Declare function talk_culture(c As Short) As Short
Declare function foreignpolicy(c As Short, i As Byte) As Short
Declare function first_lc(t As String) As String
Declare function first_uc(t As String) As String


Declare function text_to_html(text As String) As String

Declare function hasassets() As Short
Declare function sellassetts () As String
Declare function es_title(ByRef pmoney As Single) As String
Declare function es_living(ByRef pmoney As Single) As String
Declare function system_text(a As Short) As String


'tUtils
Declare function set__color(fg As Short,bg As Short,visible As Byte=1) As Short
Declare function _tcol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger

