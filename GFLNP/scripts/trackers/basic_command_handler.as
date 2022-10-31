// internal
#include "tracker.as"
#include "helpers.as"
#include "admin_manager.as"
#include "vip_manager.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"
#include "xe_helpers.as"

// --------------------------------------------
class BasicCommandHandler : Tracker {
	protected Metagame@ m_metagame;

	// --------------------------------------------
	BasicCommandHandler(Metagame@ metagame) {
		@m_metagame = @metagame;
	}
	
	// ----------------------------------------------------
	protected void handleChatEvent(const XmlElement@ event) {
		// player_id
		// player_name
		// message
		// global

		string message = event.getStringAttribute("message");
		// for the most part, chat events aren't commands, so check that first 
		if (!startsWith(message, "/")) {
			return;
		}

		string sender = event.getStringAttribute("player_name");
		int senderId = event.getIntAttribute("player_id");
		array<string> paras = parseParameters2(message, " ", -1);
		int pn = paras.size();
		if (pn == 0) return;

		const XmlElement@ info = getPlayerInfo(m_metagame, senderId);
		if (info is null) return;
		int characterId = info.getIntAttribute("character_id");


		// sendPrivateMessage(m_metagame, senderId, squad);





		// normal player from here on
		if (matchString(paras[0], "buy")) {
			

			if (pn == 2) {
				string item = paras[1];
				switch(parseInt(item))
				{
					case 1:
						handleBuy(senderId, "medikit.weapon", "weapon",  10);
						break;
					case 2:
						handleBuy(senderId, "wrench.weapon", "weapon",  100);
						break;
					case 3:
						handleBuy(senderId, "supply_box.vehicle", "vehicle",  500);
						break;
					case 4:
						handleBuy(senderId, "m202_flash.weapon", "weapon",  200);
						break;
					case 5:
						handleBuy(senderId, "gw_repair_q.weapon", "weapon",  200);
						break;
					// case 99:
					// 	handleBgo(senderId, senderId, "ak47.weapon", "weapon",  10, 0);
					// 	break;

					default:
						handleSpecialBuy( m_metagame, senderId, "codes.xml", "item",  "code", item, "player", "name", sender);
						break;					
				}
			}

			if ( pn == 3){
				string item = paras[1];
				int receiverId = parseInt(paras[1]);
				handleSpecialBuy( m_metagame, senderId, "codes.xml", "item",  "code", item, "owner", "name", sender, receiverId);	
			}
		}




		else if (matchString(paras[0], "bus")) {
			// string item = message.substr(5);
			// array<string> paras = parseParameters2(message, " ", 3);
			// string item = paras[0];

			// string item = item;
			if (pn == 2) {
				string item = paras[1];
				string squad =checkAttr1ForAttr2(m_metagame, "squads.xml", "player", "name", sender, "squad" );
				handleSpecialBuy( m_metagame, senderId, "codes.xml", "item",  "code", item, "squad", "name", squad, senderId);
			}
		}




		else if (matchString(paras[0], "link")) {
			int id = info.getIntAttribute("character_id");
			int faction_id = info.getIntAttribute("faction_id");

			// string pos = info.getStringAttribute("aim_target");
			const XmlElement@ info2 = getCharacterInfo2(m_metagame, id);
			array<const XmlElement@>@ equipment = info2.getElementsByTagName("item");
			// int w_amount = equipment[0].getIntAttribute("amount");
			string w_key = equipment[0].getStringAttribute("key");
			string p_key = equipment[2].getStringAttribute("key");
			int p_amount = equipment[2].getIntAttribute("amount");
			// sendPrivateMessage(m_metagame, senderId, w_key);	
			// sendPrivateMessage(m_metagame, senderId, p_key);

			array<string> w_keys = w_key.split(".");
			string w_key_0 = w_keys[0];

			if (p_key == "dummy_core.projectile" && p_amount > 0) {
				
				dictionary dict = {
					
					{"gw_ak12",		"gs_ak12"},
					{"gw_an94",		"gs_an94"},

					{"gw_ar15",		"gs_ar15"},
					{"gw_m16a1",	"gs_m16a1"},
					{"gw_m4a1",		"gs_m4a1"},
					{"gw_m4_sopmod_ii",    "gs_m4 sopmod ii"},

					{"gw_g11",		"gs_g11"},
					{"gw_hk416",	"gs_hk416"},
					{"gw_ump9",		"gs_ump9"},
					{"gw_ump45",	"gs_ump45"},

					
					{"gw_m1873",	"gs_m1873"},
					{"gw_m9",		"gs_m9"},

					{"gw_m14",		"gs_m14"},
					{"gw_98k",		"gs_98k"},
					{"gw_m99",		"gs_m99"},
					{"gw_m82a1",	"gs_m82a1"},
					{"rw_cb98",		"gs_sv98"},

					{"gw_fnfnc",	"gs_fnfnc"},
					{"gw_95type",	"gs_95type"},
					{"gw_95type",	"gs_97type"},
					
					{"gw_mp40",		"gs_mp40"},
					{"gw_mp5",		"gs_mp5"},
					
					{"mg42",		"gs_mg42"},
					{"gw_pkp",		"gs_pkp"},
					{"gw_negev",	"gs_negev"},
					{"gw_m2hb",		"gs_m2hb"},
					
					{"aa-12",		"gs_aa12"},
					{"spas-12",		"gs_spas12"}
				};
				if (dict.exists(w_key_0)) {
					string s_key = string(dict[w_key_0]);
					
					XmlElement command("command");
						command.setStringAttribute("class", "play_sound");
						command.setStringAttribute("filename", "ding.wav");
						command.setStringAttribute("position",  info.getStringAttribute("position"));
					m_metagame.getComms().send(command);

					XmlElement c2("command");
						c2.setStringAttribute("class", "update_inventory");
						c2.setIntAttribute("character_id", id); 
						c2.setIntAttribute("add", 0); 
						c2.setIntAttribute("container_type_id", 4);
						{
							XmlElement j("item");
							j.setStringAttribute("class", "projectile");
							j.setStringAttribute("key", "dummy_core.projectile");
							c2.appendChild(j);
						}
					m_metagame.getComms().send(c2);

					
					spawnInstanceNearPlayer(senderId, s_key , "soldier");
				}
			}	
		}

		else if (matchString(paras[0], "sw")) {
			if (payRP(characterId, 5000) ){
				sendPrivateMessage(m_metagame, senderId, "Safe warfare service activated");
				killCharacter(m_metagame, characterId, true );
			}
			else{
				sendPrivateMessage(m_metagame, senderId, "Insufficient funds");
			}
		}

		else if (matchString(paras[0], "pose")) {

			array<string> actions = {
				"male action pose",
				"female laying pose 3",
				"male laying pose",
				"female laying pose 5",
				"female laying pose 4",
				"male sitting pose 2",
				"female laying pose 6",
				"female laying pose",
				"male sitting pose 3",
				"female standing pose 2",
				"female standing pose 3",
				"female standing pose 4",
				"male sitting pose 4",
				"female standing pose 5",
				"female standing pose 6",
				"male sitting pose",
				"female standing pose",
				"male standing pose",
				"female dance pose",
				"female crouch pose",
				"male action pose 2",
				"female laying pose 2",
				"prone, orga"
			};
			if (pn == 2) {	
				uint action_i = parseInt(paras[1]);
				if (action_i >= actions.size()) return;
				animate(characterId, actions[action_i]);
			}
		}





		else if (matchString(paras[0], "action")) {
			array<string> actions = {
				'bicycle crunch',
				'crouch death',
				'crouching',
				'laying seizure',
				'waving',
				'waving 2'
			};
			if (pn == 2) {	
				uint action_i = parseInt(paras[1]);
				if (action_i >= actions.size()) return;
				animate(characterId, actions[action_i]);
			}
		}

		else if (matchString(paras[0], "dance")) {
			array<string> actions = {
				'jumping jacks',
				'breakdance flare',
				'breakdance uprock 1',
				'breakdance headspin start',
				'breakdance headspin',
				'breakdance freeze 1',
				'breakdance hip hop move',
				'breakdance footwork 1',
				'hip hop dancing',
				'slavic kick dance'
			};
			if (pn == 2) {	
				uint action_i = parseInt(paras[1]);
				if (action_i >= actions.size()) return;
				animate(characterId, actions[action_i]);
			}
		}


		else if (matchString(paras[0], "mutate1")) {
			handleMutate(senderId, "infected_walk.carry_item", 15);
		}

		else if (matchString(paras[0], "mutate2")) {
			handleMutate(senderId, "infected_brute.carry_item", 20);
		}


		// admin and moderator only from here on
		if (!m_metagame.getAdminManager().isAdmin(sender, senderId) && !m_metagame.getModeratorManager().isModerator(sender, senderId)) {
			return;
		}

		if (matchString(paras[0], "modtest")) {
			dictionary dict = {{"TagName", "command"},{"class", "chat"},{"text", "mod or admin"}};
			m_metagame.getComms().send(XmlElement(dict));
		}
			
		else if (matchString(paras[0], "buy")) {
			string item = message.substr(5);
			// sendPrivateMessage(m_metagame, senderId, name);
	
			// const XmlElement@ info = getPlayerInfo(m_metagame, senderId);
			if (info !is null)
			{	
				string name = info.getStringAttribute("name");
				switch(parseInt(item))
				{

					case 6:
						handleBuy(senderId, "mobile_armory.vehicle", "vehicle",  1000);
						break;
					case 7:
						handleBuy(senderId, "endercar.vehicle", "vehicle",  1000);
						break;
					case 8:
						handleBuy(senderId, "templax.vehicle", "vehicle",  1500);
						break;
					case 101:
						handleBuy(senderId, "tank.vehicle", "vehicle",  900);
						break;
					case 102:
						handleBuy(senderId, "tank_1.vehicle", "vehicle",  1400);
						break;
					case 103:
						handleBuy(senderId, "tank_2.vehicle", "vehicle",  900);
						break;
					case 104:
						handleBuy(senderId, "t80um.vehicle", "vehicle",  900);
						break;

					case 106:
						handleBuy(senderId, "sturmtiger.vehicle", "vehicle",  1800);
						break;
					case 107:
						handleBuy(senderId, "kingtiger.vehicle", "vehicle",  1800);
						break;
					case 201:
						handleBuy(senderId, "apc.vehicle", "vehicle",  800);
						break;
					case 202:
						handleBuy(senderId, "apc_1.vehicle", "vehicle",  800);
						break;
					case 203:
						handleBuy(senderId, "apc_2.vehicle", "vehicle",  800);
						break;
					case 301:
						handleBuy(senderId, "transport_truck.vehicle", "vehicle",  700);
						break;
					case 302:
						handleBuy(senderId, "transport_truck_2.vehicle", "vehicle",  700);
						break;

					case 502:
						handleBuy(senderId, "humvee.vehicle", "vehicle",  800);
						break;


					default:
						break;					
				}
			}
		}

		else if (matchString(paras[0], "cgc")) {
			string item = message.substr(5);

			XmlElement c("command");
				c.setStringAttribute("class", "update_player");
				c.setIntAttribute("player_id", senderId); 
				c.setStringAttribute("color", item); // e.g. "#FF00FF"
			m_metagame.getComms().send(c);
		}



		else if (matchString(paras[0], "sidinfo")) {
			handleSidInfo(message,senderId);
		} 

		else if (matchString(paras[0], "sst")) {
			handleBuy(senderId, "armored_truck.vehicle", "vehicle",  1500);

		} 
		else if (matchString(paras[0], "kick_id")) {
			handleKick(message, senderId, true);
		} 
		else if (matchString(paras[0], "kick")) {
			handleKick(message, senderId);
		} 
		else if (matchString(paras[0], "0_win")) {
			m_metagame.getComms().send("<command class='set_match_status' lose='1' faction_id='1' />");
			m_metagame.getComms().send("<command class='set_match_status' lose='1' faction_id='2' />");
			m_metagame.getComms().send("<command class='set_match_status' win='1' faction_id='0' />");
		} 
		else if (matchString(paras[0], "1_win")) {
			m_metagame.getComms().send("<command class='set_match_status' lose='1' faction_id='0' />");
			m_metagame.getComms().send("<command class='set_match_status' lose='1' faction_id='2' />");
			m_metagame.getComms().send("<command class='set_match_status' win='1' faction_id='1' />");
		} 
		else if (matchString(paras[0], "1_lose")) {
			m_metagame.getComms().send("<command class='set_match_status' lose='1' faction_id='1' />");
		} 
		 if (matchString(paras[0], "1_own")) {
			int factionId = 1;
			array<const XmlElement@> bases = getBases(m_metagame);
			for (uint i = 0; i < bases.size(); ++i) {
				const XmlElement@ base = bases[i];
				if (base.getIntAttribute("owner_id") != factionId) {
					XmlElement command("command");
					command.setStringAttribute("class", "update_base");
					command.setIntAttribute("base_id", base.getIntAttribute("id"));
					command.setIntAttribute("owner_id", factionId);
					m_metagame.getComms().send(command);
				}
			}
		} else if (matchString(paras[0], "0_own")) {
			int factionId = 0;
			array<const XmlElement@> bases = getBases(m_metagame);
			for (uint i = 0; i < bases.size(); ++i) {
				const XmlElement@ base = bases[i];
				if (base.getIntAttribute("owner_id") != factionId) {
					XmlElement command("command");
					command.setStringAttribute("class", "update_base");
					command.setIntAttribute("base_id", base.getIntAttribute("id"));
					command.setIntAttribute("owner_id", factionId);
					m_metagame.getComms().send(command);
				}
			}
		}
		
		// admin only from here on
		if (!m_metagame.getAdminManager().isAdmin(sender, senderId)) {
			return;
		}
		// it's a silent server command, check which one









		if (matchString(paras[0], "test2")) {
			string command = "<command class='set_marker' faction_id='0' position='512 0 512' color='0 0 1' atlas_index='0' text='hello!' />";
			m_metagame.getComms().send(command);
		} 

		else if (matchString(paras[0], "test")) {
			dictionary dict = {{"TagName", "command"},{"class", "chat"},{"text", "test yourself!"}};
			m_metagame.getComms().send(XmlElement(dict));

		} 

		else if (matchString(paras[0], "banana")) {
			spawnInstanceAtEnemy(senderId, "banana_peel.projectile", "projectile");
		}

		else if (matchString(paras[0], "defend")) {
			// make ai defend only, both sides
			for (int i = 0; i < 2; ++i) {
				string command =
					"<command class='commander_ai'" +
					"	faction='" + i + "'" +
					"	base_defense='1.0'" +
					"	border_defense='0.0'>" +
					"</command>";
				m_metagame.getComms().send(command);
			}
			sendPrivateMessage(m_metagame, senderId, "defensive ai set");

		} 

		else if (matchString(paras[0], "0_attack")) {
			// make ai attack only, both sides
			string command =
				"<command class='commander_ai'" +
				"	faction='0'" +
				"	base_defense='0.0'" +
				"	border_defense='0.0'>" +
				"</command>";
			m_metagame.getComms().send(command);
			sendPrivateMessage(m_metagame, senderId, "attack green ai set");
		} 

		else if (matchString(paras[0], "save_data")) {


			string com1 = """
<command 
	class='save_data' filename='ee.xml' location='app_data'>
	<root>
	<foo bar='0' />
	</root>
</command>""";
			//string com1 = "<command class='add_custom_stat' character_id="+ cid +" tag='bbq'></command>";

			m_metagame.getComms().send(com1);
			sendPrivateMessage(m_metagame, senderId, characterId+"");
		}
		
		else if (matchString(paras[0], "acid")) {
			XmlElement c2("command");
				c2.setStringAttribute("class", "update_inventory");
				c2.setIntAttribute("character_id", characterId); 
				c2.setIntAttribute("add", 1); 
				c2.setIntAttribute("container_type_id", 4);
				{
					XmlElement j("item");
					j.setStringAttribute("class", "projectile");
					j.setStringAttribute("key", "acid_bomb.projectile");
					c2.appendChild(j);
				}
			for (int i=0; i<5; i++){
				m_metagame.getComms().send(c2);
			}
					
		}


		else  if(matchString(paras[0], "kill_aa")) {
			for (uint f = 1; f < 3; ++f) {
				array<const XmlElement@>@ vehicles = getVehicles(m_metagame, f, "aa_emplacement.vehicle");
				
				for (uint i = 0; i < vehicles.size(); ++i) {
					const XmlElement@ vehicle = vehicles[i];
					int id = vehicle.getIntAttribute("id");
					destroyVehicle(m_metagame, id);
				}
			}
		} else  if(matchString(paras[0], "xp")) {
			
			if (info !is null) {
				int id = info.getIntAttribute("character_id");
				string command =
					"<command class='xp_reward'" +
					"	character_id='" + id + "'" +
					"	reward='10.'>" + // multiplier affected..
					"</command>";
				m_metagame.getComms().send(command);
			} else {
				_log("player info is null");
			}
		} else if (matchString(paras[0], "rp")) {
			
			if (info !is null) {
				int id = info.getIntAttribute("character_id");
				string command =
					"<command class='rp_reward'" +
					"	character_id='" + id + "'" +
					"	reward='50000'>" + // multiplier affected..
					"</command>";
				m_metagame.getComms().send(command);
			}
		} else if (matchString(paras[0], "create_vehicle")) {
			spawnInstanceNearPlayer(senderId, "special_cargo_vehicle1.vehicle", "vehicle");
		} else if (matchString(paras[0], "jeep")) {
			spawnInstanceNearPlayer(senderId, "jeep.vehicle", "vehicle");
		} else  if(matchString(paras[0], "suitcase")) {
			// .. create suitcase near local player
			spawnInstanceNearPlayer(senderId, "suitcase.carry_item", "carry_item");
		} else  if(matchString(paras[0], "laptop")) {
			// .. create laptop near local player
			spawnInstanceNearPlayer(senderId, "laptop.carry_item", "carry_item");      
		} else  if(matchString(paras[0], "c4")) {
			spawnInstanceNearPlayer(senderId, "c4.projectile", "projectile");      
		} else if (matchString(paras[0], "dc")) {
			spawnInstanceNearPlayer(senderId, "cover_resource.weapon", "weapon");
		} else if (matchString(paras[0], "dgl")) {
			spawnInstanceNearPlayer(senderId, "gl_resource.weapon", "weapon");
		} else if (matchString(paras[0], "dmg")) {
			spawnInstanceNearPlayer(senderId, "mg_resource.weapon", "weapon");
		} else if (matchString(paras[0], "dminig")) {
			spawnInstanceNearPlayer(senderId, "minig_resource.weapon", "weapon");
		} else if (matchString(paras[0], "m72")) {
			spawnInstanceNearPlayer(senderId, "m72_law.weapon", "weapon");
			spawnInstanceNearPlayer(senderId, "m72_law.weapon", "weapon");
			spawnInstanceNearPlayer(senderId, "m72_law.weapon", "weapon");
			spawnInstanceNearPlayer(senderId, "m72_law.weapon", "weapon");
		} else if (matchString(paras[0], "g36")) {
			spawnInstanceNearPlayer(senderId, "g36.weapon", "weapon");
			spawnInstanceNearPlayer(senderId, "g36.weapon", "weapon");
			spawnInstanceNearPlayer(senderId, "g36.weapon", "weapon");
			spawnInstanceNearPlayer(senderId, "g36.weapon", "weapon");
			spawnInstanceNearPlayer(senderId, "g36.weapon", "weapon");
		} else if (matchString(paras[0], "cargo")) {
			spawnInstanceNearPlayer(senderId, "cargo_truck.vehicle", "vehicle", 1);


		} else if (matchString(paras[0], "t80u")) {
			spawnInstanceNearPlayer(senderId, "t80u.vehicle", "vehicle");
		} else if (matchString(paras[0], "l2a5")) {
			spawnInstanceNearPlayer(senderId, "tank_1.vehicle", "vehicle");
		} else if (matchString(paras[0], "apc1")) {
			spawnInstanceNearPlayer(senderId, "apc_1.vehicle", "vehicle");


		} else if (matchString(paras[0], "m4a1mod")) {
			spawnInstanceNearPlayer(senderId, "gw_m4a1mod.weapon", "weapon");
		} else if (matchString(paras[0], "gk_hg")) {
			spawnInstanceNearPlayer(senderId, "gk_supply_hg.vehicle", "vehicle");
		} else if (matchString(paras[0], "gk_ar")) {
			spawnInstanceNearPlayer(senderId, "gk_supply_ar.vehicle", "vehicle");
		} else if (matchString(paras[0], "gk_smg")) {
			spawnInstanceNearPlayer(senderId, "gk_supply_smg.vehicle", "vehicle");
		} else if (matchString(paras[0], "gk_rf")) {
			spawnInstanceNearPlayer(senderId, "gk_supply_rf.vehicle", "vehicle");		
		} else if (matchString(paras[0], "gk_mg")) {
			spawnInstanceNearPlayer(senderId, "gk_supply_mg.vehicle", "vehicle");		
		} else if (matchString(paras[0], "gk_sg")) {
			spawnInstanceNearPlayer(senderId, "gk_supply_sg.vehicle", "vehicle");	
		} else if (matchString(paras[0], "gk_skin")) {
			spawnInstanceNearPlayer(senderId, "gk_supply_skin.vehicle", "vehicle");	
		} else if (matchString(paras[0], "gk_new")) {
			spawnInstanceNearPlayer(senderId, "gk_supply_new.vehicle", "vehicle");	


		} else if (matchString(paras[0], "0cm")) {
			spawnInstanceNearPlayer(senderId, "commando", "soldier", 0);  
		} else if (matchString(paras[0], "0md")) {
			spawnInstanceNearPlayer(senderId, "medic", "soldier", 0);  
		} else if (matchString(paras[0], "0mg")) {
			spawnInstanceNearPlayer(senderId, "mg", "soldier", 0);  
		} else if (matchString(paras[0], "0at")) {
			spawnInstanceNearPlayer(senderId, "at", "soldier", 0);

		} else if (matchString(paras[0], "0ecm")) {
			spawnInstanceNearPlayer(senderId, "para", "soldier", 0);  
		} else if (matchString(paras[0], "0emd")) {
			spawnInstanceNearPlayer(senderId, "medic2", "soldier", 0);  
		} else if (matchString(paras[0], "0sn")) {
			spawnInstanceNearPlayer(senderId, "sharp shooter", "soldier", 0);  
		} else if (matchString(paras[0], "0lw")) {
			spawnInstanceNearPlayer(senderId, "lone wolf", "soldier", 0);


		} else if (matchString(paras[0], "0ops")) {
			spawnInstanceNearPlayer(senderId, "ops", "soldier", 0);
		} else if (matchString(paras[0], "0eod")) {
			spawnInstanceNearPlayer(senderId, "eod", "soldier", 0);
		} else if (matchString(paras[0], "0gr")) {
			spawnInstanceNearPlayer(senderId, "grenadier", "soldier", 0);
		} else if (matchString(paras[0], "0elite")) {
			spawnInstanceNearPlayer(senderId, "miniboss", "soldier", 0);
		} else if (matchString(paras[0], "0jn")) {
			spawnInstanceNearPlayer(senderId, "jugger", "soldier", 0);

		} else if (matchString(paras[0], "2cm")) {
			spawnInstanceNearPlayer(senderId, "commando", "soldier", 2);  
		} else if (matchString(paras[0], "2md")) {
			spawnInstanceNearPlayer(senderId, "medic", "soldier", 2);  
		} else if (matchString(paras[0], "2mg")) {
			spawnInstanceNearPlayer(senderId, "mg", "soldier", 2);  
		} else if (matchString(paras[0], "2at")) {
			spawnInstanceNearPlayer(senderId, "at", "soldier", 2);

		} else if (matchString(paras[0], "2ecm")) {
			spawnInstanceNearPlayer(senderId, "para", "soldier", 2);  
		} else if (matchString(paras[0], "2emd")) {
			spawnInstanceNearPlayer(senderId, "medic2", "soldier", 2);  
		} else if (matchString(paras[0], "2sn")) {
			spawnInstanceNearPlayer(senderId, "sharp shooter", "soldier", 2);  
		} else if (matchString(paras[0], "2lw")) {
			spawnInstanceNearPlayer(senderId, "lone wolf", "soldier", 2);


		} else if (matchString(paras[0], "2ops")) {
			spawnInstanceNearPlayer(senderId, "ops", "soldier", 2);
		} else if (matchString(paras[0], "2eod")) {
			spawnInstanceNearPlayer(senderId, "eod", "soldier", 2);
		} else if (matchString(paras[0], "2gr")) {
			spawnInstanceNearPlayer(senderId, "grenadier", "soldier", 2);
		} else if (matchString(paras[0], "2elite")) {
			spawnInstanceNearPlayer(senderId, "miniboss", "soldier", 2);
		} else if (matchString(paras[0], "2jn")) {
			spawnInstanceNearPlayer(senderId, "jugger", "soldier", 2);


		} else if (matchString(paras[0], "xenophage")) {
			spawnInstanceNearPlayer(senderId, "xenophage.weapon", "weapon");

		} else if (matchString(paras[0], "vest1")) {
			spawnInstanceNearPlayer(senderId, "vest1.carry_item", "carry_item", 0);

		} else if (matchString(paras[0], "m14")) {
			spawnInstanceNearPlayer(senderId, "m14", "carry_item", 0);

		} else if (matchString(paras[0], "detonate")) { // makes an explosion at supplied coordinates. Bind with %input_position  suggested
			// extract detonate target position
			string position = message.substr(string("detonate ").length() + 1);
			const XmlElement@ playerInfo = getPlayerInfo(m_metagame, senderId);
			m_metagame.getComms().send("<command class='create_instance' faction_id='" + playerInfo.getIntAttribute("faction_id") + 
										 "' position='" + position + "' instance_class='projectile' instance_key='detonation.projectile' />");


		} else if (matchString(paras[0], "tank_0")) {
			spawnInstanceNearPlayer(senderId, "tank.vehicle", "vehicle", 0);
		} else if (matchString(paras[0], "tank_1")) {
			spawnInstanceNearPlayer(senderId, "tank_1.vehicle", "vehicle", 0);
		} else if (matchString(paras[0], "tank_2")) {
			spawnInstanceNearPlayer(senderId, "tank_2.vehicle", "vehicle", 0);


		} else if (matchString(paras[0], "apc_0")) {
			spawnInstanceNearPlayer(senderId, "apc.vehicle", "vehicle", 0);
		} else if (matchString(paras[0], "apc_1")) {
			spawnInstanceNearPlayer(senderId, "apc_1.vehicle", "vehicle", 0);
		} else if (matchString(paras[0], "apc_2")) {
			spawnInstanceNearPlayer(senderId, "apc_2.vehicle", "vehicle", 0);

		} else if (matchString(paras[0], "artk")) {
			spawnInstanceNearPlayer(senderId, "armored_truck.vehicle", "vehicle", 0);


		} else if (matchString(paras[0], "tow")) {
			spawnInstanceNearPlayer(senderId, "tow.vehicle", "vehicle", 1);
		} else if (matchString(paras[0], "teddy")) {
			spawnInstanceNearPlayer(senderId, "teddy.carry_item", "carry_item", 0);
		} else if (matchString(paras[0], "briefcase")) {
			spawnInstanceNearPlayer(senderId, "suitcase.carry_item", "carry_item", 0);
		} else if (matchString(paras[0], "friend")) {
			spawnInstanceNearPlayer(senderId, "default", "soldier", 0);
		} else if (matchString(paras[0], "grenadier")) {
			spawnInstanceNearPlayer(senderId, "grenadier", "soldier", 0);            
		} else if (matchString(paras[0], "foe")) {
			spawnInstanceNearPlayer(senderId, "default", "soldier", 1);
		} else if (matchString(paras[0], "lw")) {
			spawnInstanceNearPlayer(senderId, "lonewolf", "soldier", 0);
		} else if (matchString(paras[0], "sniper")) {
			spawnInstanceNearPlayer(senderId, "sniper", "soldier", 0);
		} else if (matchString(paras[0], "gb1")) {
			spawnInstanceNearPlayer(senderId, "gift_box_1.carry_item", "carry_item", 0);
		} else if (matchString(paras[0], "gb2")) {
			spawnInstanceNearPlayer(senderId, "gift_box_2.carry_item", "carry_item", 0);
		} else if (matchString(paras[0], "gb3")) {
			spawnInstanceNearPlayer(senderId, "gift_box_3.carry_item", "carry_item", 0);        
		} else if (matchString(paras[0], "cb1")) {
			spawnInstanceNearPlayer(senderId, "gift_box_community_1.carry_item", "carry_item", 0); 
		} else if (matchString(paras[0], "cb2")) {
			spawnInstanceNearPlayer(senderId, "gift_box_community_2.carry_item", "carry_item", 0);                      
				} else if (matchString(paras[0], "cb3")) {
			spawnInstanceNearPlayer(senderId, "gift_box_community_3.carry_item", "carry_item", 0);  
				} else if (matchString(paras[0], "cb4")) {
			spawnInstanceNearPlayer(senderId, "gift_box_community_4.carry_item", "carry_item", 0);                                     
				} else if (matchString(paras[0], "lottery")) {
			spawnInstanceNearPlayer(senderId, "lottery.carry_item", "carry_item", 0);                                     
		} else if (matchString(paras[0], "quad")) {
			spawnInstanceNearPlayer(senderId, "atv_armory.vehicle", "vehicle", 0);        
		} else if (matchString(paras[0], "m29")) {
			spawnInstanceNearPlayer(senderId, "model_29.weapon", "weapon", 0);        
		} else if (matchString(paras[0], "mg")) {
			spawnInstanceNearPlayer(senderId, "deployable_mg.vehicle", "vehicle", 0);        
		} else  if(matchString(paras[0], "kill_rt")) {
			destroyAllEnemyVehicles("radar_tower.vehicle");
		} else  if(matchString(paras[0], "kill_own_rt")) {
			destroyAllFactionVehicles(0, "radar_tower.vehicle");
		} else  if(matchString(paras[0], "kill_rj")) {
			destroyAllEnemyVehicles("radio_jammer.vehicle");
		} else  if(matchString(paras[0], "mustela")) {
			spawnInstanceNearPlayer(senderId, "wiesel_tow.vehicle", "vehicle", 0);        
		} else  if(matchString(paras[0], "mortar")) {
			spawnInstanceNearPlayer(senderId, "mortar_resource.weapon", "weapon", 0);        
		} else  if(matchString(paras[0], "humvee")) {
			spawnInstanceNearPlayer(senderId, "humvee_gl_para.vehicle", "vehicle", 0);        
		} else  if(matchString(paras[0], "javelin")) {
			spawnInstanceNearPlayer(senderId, "javelin_ap.weapon", "weapon", 0);        
		} else  if(matchString(paras[0], "complete_campaign")) {
			m_metagame.getComms().send("<command class='set_campaign_status' show_stats='1'/>");
		} else if (matchString(paras[0], "enable_gps")) {
			m_metagame.getComms().send("<command class='faction_resources' faction_id='0'><call key='gps.call' /></command>");
		} else  if(matchString(paras[0], "icecream")) {
			spawnInstanceNearPlayer(senderId, "icecream.vehicle", "vehicle", 0);        
		} else  if(matchString(paras[0], "wound")) {
			for (int i = 2; i < 100; ++i) {
				string command =
					"<command class='update_character'" +
					"	id='" + i + "'" +
					"	wounded='1'>" + 
					"</command>";
				m_metagame.getComms().send(command);
			}
		}


		else if (matchString(paras[0], "inv"))
		{
			const XmlElement@ playerInfo = getPlayerInfo(m_metagame, senderId);
			const int id = playerInfo.getIntAttribute("character_id");

			XmlElement c3("command");
				c3.setStringAttribute("class", "update_inventory");
				c3.setIntAttribute("character_id", id); 
				c3.setIntAttribute("add", 1); 
				c3.setIntAttribute("amount", 1); 
				c3.setIntAttribute("container_type_id", 4);
				{
					XmlElement k("item");
					k.setStringAttribute("class", "weapon");
					k.setStringAttribute("key", "gw_m2hb.weapon");
					c3.appendChild(k);
				}
			m_metagame.getComms().send(c3);
		}

		else if (matchString(paras[0], "fill")) {
			fillInventory(senderId);
		}

		else  if(matchString(paras[0], "ahaha")) {
			addCustomStatToAllPlayers(m_metagame, "AHA");
		}



		// custom summon
		else if (matchString(paras[0], "q"))
		{
			const XmlElement@ playerInfo = getPlayerInfo(m_metagame, senderId);
			Vector3 t_pos = stringToVector3(playerInfo.getStringAttribute("aim_target"));

			if (playerInfo !is null) {
				const XmlElement@ characterInfo = getCharacterInfo(m_metagame, playerInfo.getIntAttribute("character_id"));
				if (characterInfo !is null) {
					// int characterId = characterInfo.getIntAttribute("character_id");
					int factionId = characterInfo.getIntAttribute("faction_id");
					Vector3 w_pos = stringToVector3(characterInfo.getStringAttribute("position"));
					w_pos.m_values[1] += 10.0;
					// string weapon = message.substr(string("w ").length() + 1) + ".weapon";
					// array<string> paras = parseParameters(message, " ");
					if (pn == 3) {
						int count = parseInt(paras[2]);
						P2PAttack(w_pos, t_pos, count, paras[1] + '.projectile', "woosh1.wav", 1.0f, factionId, characterId);
					}
					else {
						P2PAttack(w_pos, t_pos, 5, paras[1] + '.projectile', "woosh1.wav", 1.0f, factionId, characterId);
					}
				}
			}
		}

		else if (matchString(paras[0], "r"))
		{
			// string weapon = message.substr(string("w ").length() + 1) + ".weapon";
			// array<string> paras = parseParameters(message, " ");
			if (pn == 3)
			{
				int count = parseInt(paras[2]);
				for (int i = 0; i < count; ++i)
				{
					spawnInstanceAtCursor(senderId, paras[1] + ".call", "call");
				}
			}
			else
			{
				spawnInstanceAtCursor(senderId, paras[1] + ".call", "call");
			}
		}

		else if (matchString(paras[0], "v"))
		{
			// array<string> paras = parseParameters(message, " ");
			if (pn == 3)
			{
				int count = parseInt(paras[2]);
				for (int i = 0; i < count; ++i)
				{
					spawnInstanceAtCursor(senderId, paras[1] + ".vehicle", "vehicle");
				}
			}
			else
			{
				spawnInstanceAtCursor(senderId, paras[1] + ".vehicle", "vehicle");
			}
		}

		else if (matchString(paras[0], "w"))
		{
			// string weapon = message.substr(string("w ").length() + 1) + ".weapon";
			// array<string> paras = parseParameters(message, " ");
			if (pn == 3)
			{
				int count = parseInt(paras[2]);
				for (int i = 0; i < count; ++i)
				{
					spawnInstanceAtCursor(senderId, paras[1] + ".weapon", "weapon");
				}
			}
			else
			{
				spawnInstanceAtCursor(senderId, paras[1] + ".weapon", "weapon");
			}
		}

		else if (matchString(paras[0], "s"))
		{
			// array<string> paras = parseParameters(message, " ");
			if (pn == 4)
			{
				int count = parseInt(paras[2]);
				int factionId = parseInt(paras[3]);
				for (int i = 0; i < count; ++i)
				{
					spawnInstanceAtCursor(senderId, paras[1] , "soldier", factionId);
				}
			}			
			else if (pn == 3)
			{
				int count = parseInt(paras[2]);
				for (int i = 0; i < count; ++i)
				{
					spawnInstanceAtCursor(senderId, paras[1] , "soldier");
				}
			}
			else
			{
				spawnInstanceAtCursor(senderId, paras[1] , "soldier");
			}
			// string projectile = message.substr(string("p ").length() + 1) + ".projectile";
			// spawnInstanceNearPlayer(senderId, projectile, "carry_item");
		}
		else if (matchString(paras[0], "p"))
		{
			// array<string> paras = parseParameters(message, " ");
			if (pn == 3)
			{
				int count = parseInt(paras[2]);
				for (int i = 0; i < count; ++i)
				{
					spawnInstanceAtCursor(senderId, paras[1] + ".projectile", "projectile");
				}
			}
			else
			{
				spawnInstanceAtCursor(senderId, paras[1] + ".projectile", "projectile");
			}
			// string projectile = message.substr(string("p ").length() + 1) + ".projectile";
			// spawnInstanceNearPlayer(senderId, projectile, "carry_item");
		}
		else if (matchString(paras[0], "c"))
		{
			// array<string> paras = parseParameters(message, " ");
			if (pn == 3)
			{
				int count = parseInt(paras[2]);
				for (int i = 0; i < count; ++i)
				{
					spawnInstanceAtCursor(senderId, paras[1] + ".carry_item", "carry_item");
				}
			}
			else
			{
				spawnInstanceAtCursor(senderId, paras[1] + ".carry_item", "carry_item");
			}
		}
		else if (matchString(paras[0], "u"))
		{
			// array<string> paras = parseParameters(message, " ");
			if (pn == 3)
			{
				int count = parseInt(paras[2]);
				for (int i = 0; i < count; ++i)
				{
					giveItem(senderId, paras[1] + ".weapon", "weapon");
				}
			}
			else
			{
				giveItem(senderId, paras[1] + ".weapon", "weapon");
			}
		}
		else if (matchString(paras[0], "i"))
		{
			// array<string> paras = parseParameters(message, " ");
			if (pn == 3)
			{
				int count = parseInt(paras[2]);
				for (int i = 0; i < count; ++i)
				{
					giveItem(senderId, paras[1] + ".carry_item", "carry_item");
				}
			}
			else
			{
				giveItem(senderId, paras[1] + ".carry_item", "carry_item");
			}
		}
		else if (matchString(paras[0], "o"))
		{
			// array<string> paras = parseParameters(message, " ");
			if (pn == 3)
			{
				int count = parseInt(paras[2]);
				for (int i = 0; i < count; ++i)
				{
					giveItem(senderId, paras[1] + ".projectile", "projectile");
				}
			}
			else
			{
				giveItem(senderId, paras[1] + ".projectile", "projectile");
			}
		}



		else if (matchString(paras[0], "g"))
		{
			// array<string> paras = parseParameters(message, " ");
			if (pn == 3)
			{
				string player_name = paras[1];
				int rp = parseInt(paras[2]);

				//get player
				const XmlElement@ player = findPlayerByName(m_metagame, player_name);
				sendPrivateMessage(m_metagame, senderId, player_name);
				if (player !is null) {
					int playerId = player.getIntAttribute("player_id");
					string name = player.getStringAttribute("name");
					notify(m_metagame, "reward player", dictionary = {{"%player_name", name}}, "misc");
					sendPrivateMessage(m_metagame, senderId, "1");
					//get character
					// const XmlElement@ info = getPlayerInfo(m_metagame, playerId);
					if (info !is null) {
						int id = info.getIntAttribute("character_id");
						string command =
							"<command class='rp_reward'" +
							"	character_id='" + id + "'" +
							"	reward='" + rp + "'>" + // multiplier affected..
							"</command>";
						m_metagame.getComms().send(command);
						sendPrivateMessage(m_metagame, senderId, "2");
					}
				}
				else
				{
					sendPrivateMessage(m_metagame, senderId, "Not found");
				}
			}
			else
			{
				sendPrivateMessage(m_metagame, senderId, "reward missed!");
			}
		}



	}

	// --------------------------------------------
	bool hasEnded() const {
		// always on
		return false;
	}

	// --------------------------------------------
	bool hasStarted() const {
		// always on
		return true;
	}


	// --------------------------------------------
	void handleKick(string message, int senderId, bool id = false) {
		const XmlElement@ player = getPlayerByIdOrNameFromCommand(m_metagame, message, id);
		if (player !is null) {
			int playerId = player.getIntAttribute("player_id");
			string name = player.getStringAttribute("name");
			notify(m_metagame, "kicking player", dictionary = {{"%player_name", name}}, "misc");
			string command = "<command class='kick_player' player_id='" + playerId + "' />";
			m_metagame.getComms().send(command);
		} else {
			//_log("* couldn't find a match for name=" + name + "");
			sendPrivateMessage(m_metagame, senderId, "kick missed!");
		}
	}
	
	// --------------------------------------------
	void handleSidInfo(string message, int senderId) {
		// get name given as parameter
		string name = message.substr(string("sidinfo ").length() + 1);

		// assuming player name 
		// ask for player list from the server
		array<const XmlElement@> playerList = getPlayers(m_metagame);
		_log("* "  + playerList.size() + " players found");
		
		// go through the player list and match for the given name
		bool foundFlag = false;
		string playerSid = "";
		for (uint i = 0; i < playerList.size(); ++i) {
			const XmlElement@ player = playerList[i];
			string name2 = player.getStringAttribute("name");
			// case insensitive
			if (name2.toLowerCase() == name.toLowerCase()) {
				// found it
				playerSid = player.getStringAttribute("sid");
				foundFlag = true;
				break;
			}
		}
		if (foundFlag){
			sendPrivateMessage(m_metagame, senderId, "player " + name + " found, SID: " + playerSid);
		} else {
			_log("* couldn't find a match for " + name);
			sendPrivateMessage(m_metagame, senderId, "player not found");
		}
	}
	
	// VANILLA START---------------------------------------------------- 
	protected void spawnInstanceNearPlayer(int senderId, string key, string type, int factionId = 0) {
		const XmlElement@ playerInfo = getPlayerInfo(m_metagame, senderId);
		if (playerInfo !is null) {
			const XmlElement@ characterInfo = getCharacterInfo(m_metagame, playerInfo.getIntAttribute("character_id"));
			if (characterInfo !is null) {
				Vector3 pos = stringToVector3(characterInfo.getStringAttribute("position"));
				pos.m_values[0] += 5.0;
				string c = "";
				if (type == 'projectile'){
					c = "<command class='create_instance' instance_class='" + type + "' instance_key='" + key + "' position='" + pos.toString() + "' faction_id='" + factionId + "' activated='0' />";
				}
				else{
					c = "<command class='create_instance' instance_class='" + type + "' instance_key='" + key + "' position='" + pos.toString() + "' faction_id='" + factionId + "' />";
				}
				
				m_metagame.getComms().send(c);
			}
		}
	}

	// ----------------------------------------------------
	protected void destroyAllFactionVehicles(uint f, string key) {
		array<const XmlElement@>@ vehicles = getVehicles(m_metagame, f, key);
		
		for (uint i = 0; i < vehicles.size(); ++i) {
			const XmlElement@ vehicle = vehicles[i];
			int id = vehicle.getIntAttribute("id");
			destroyVehicle(m_metagame, id);
		}
	}

	// ----------------------------------------------------
	protected void destroyAllEnemyVehicles(string key) {
		for (uint f = 1; f < 3; ++f) {
			destroyAllFactionVehicles(f, key);
		}
	}


	// ----------------------------------------------------
	protected void fillInventory(int senderId) {
		const XmlElement@ player = getPlayerInfo(m_metagame, senderId);
		if (player !is null) {
			const XmlElement@ characterInfo = getCharacterInfo(m_metagame, player.getIntAttribute("character_id"));
			if (characterInfo !is null) {
				int characterId = player.getIntAttribute("character_id");
				XmlElement c("command");
				c.setStringAttribute("class", "update_inventory");

				c.setIntAttribute("character_id", characterId); 
				c.setStringAttribute("container_type_class", "backpack");
				
				for (uint i = 0; i < 3; ++i) {
					array<string> typeStr1 = {"weapon", "grenade", "carry_item"};
					array<string> typeStr2 = {"weapons", "grenades", "carry_items"};
					for (uint k = 0; k < typeStr1.size(); ++k) {
						array<const XmlElement@>@ resources = getFactionResources(m_metagame, i, typeStr1[k], typeStr2[k]);
						for (uint j = 0; j < resources.size(); ++j) {
							const XmlElement@ item = resources[j];
							addItem(c, Resource(item.getStringAttribute("key"), typeStr1[k]));
						}
					}
				}
				
				m_metagame.getComms().send(c);
			}
		}
	}

	// ----------------------------------------------------
	protected void addItem(XmlElement@ command, Resource@ r) {
		XmlElement i("item"); 
		i.setStringAttribute("class", r.m_type); 
		i.setStringAttribute("key", r.m_key); 
		command.appendChild(i); 
	}
	// VANILLA END----------------------------------------------------

	// ----------------------------------------------------
	protected void spawnInstanceAtEnemy(int senderId, string key, string type, int factionId = 0) {
		const XmlElement@ playerInfo = getPlayerInfo(m_metagame, senderId);
		if (playerInfo !is null) {
			const XmlElement@ characterInfo = getCharacterInfo(m_metagame, playerInfo.getIntAttribute("character_id"));
			if (characterInfo !is null) {
				Vector3 player_pos = stringToVector3(characterInfo.getStringAttribute("position"));
				//checking all factions
				for (int f = 0; f < 3; ++f){
					// only affect enemy faction
					if (f!= factionId){
						//custom query, collects all soldiers of a faction near player
						array<const XmlElement@>@ soldiers = getCharactersNearPosition(m_metagame, player_pos, f, 80.0f);				
						for (uint i = 0; i < soldiers.length(); ++i) {
							int soldier_id = soldiers[i].getIntAttribute("id");
							Vector3 soldier_pos = stringToVector3(getCharacterInfo(m_metagame, soldier_id).getStringAttribute("position"));
							soldier_pos.m_values[1] += 5.0;
			
	
							string c = "<command class='create_instance' instance_class='" + type + "' instance_key='" + key + "' position='" + soldier_pos.toString() + "' faction_id='" + factionId + "' />";
							m_metagame.getComms().send(c);
						}
					}
				}

				// pos.m_values[0] += 5.0;
				// string c = "<command class='create_instance' instance_class='" + type + "' instance_key='" + key + "' position='" + pos.toString() + "' faction_id='" + factionId + "' />";
				// m_metagame.getComms().send(c);
			}
		}
	}

	protected void handleMutate(int senderId, string c_key, int p_consume){

		const XmlElement@ info = getPlayerInfo(m_metagame, senderId);


		if (info !is null) {
			int id = info.getIntAttribute("character_id");
			int faction_id = info.getIntAttribute("character_id");

			// string pos = info.getStringAttribute("aim_target");
			const XmlElement@ info2 = getCharacterInfo2(m_metagame, id);
			array<const XmlElement@>@ equipment = info2.getElementsByTagName("item");
			// int w_amount = equipment[0].getIntAttribute("amount");
			string w_key = equipment[0].getStringAttribute("key");
			string p_key = equipment[2].getStringAttribute("key");
			int p_amount = equipment[2].getIntAttribute("amount");
			// sendPrivateMessage(m_metagame, senderId, w_key);	
			// sendPrivateMessage(m_metagame, senderId, p_key);

			array<string> w_keys = w_key.split(".");
			string w_key_0 = w_keys[0];

			if (p_key == "acid_bomb.projectile" && p_amount >= p_consume) {
				
				// if (dict.exists(w_key_0)) {
					// string s_key = string(dict[w_key_0]);
					
					XmlElement command("command");
						command.setStringAttribute("class", "play_sound");
						command.setStringAttribute("filename", "zomb_mutate.wav");
						command.setStringAttribute("position",  info.getStringAttribute("position"));
					m_metagame.getComms().send(command);

					XmlElement c2("command");
						c2.setStringAttribute("class", "update_inventory");
						c2.setIntAttribute("character_id", id); 
						c2.setIntAttribute("add", 0); 
						c2.setIntAttribute("amount", p_consume); 
						c2.setIntAttribute("container_type_id", 4);
						{
							XmlElement j("item");
							j.setStringAttribute("class", "projectile");
							j.setStringAttribute("key", "acid_bomb.projectile");
							c2.appendChild(j);
						}
					for (int i = 0 ; i < p_consume; i++){
						m_metagame.getComms().send(c2);
					}
					

					XmlElement c3("command");
						c3.setStringAttribute("class", "update_inventory");
						c3.setIntAttribute("character_id", id); 
						c3.setIntAttribute("add", 1); 
						c3.setIntAttribute("amount", 1); 
						c3.setIntAttribute("container_type_id", 4);
						{
							XmlElement k("item");
							k.setStringAttribute("class", "carry_item");
							k.setStringAttribute("key", c_key);
							c3.appendChild(k);
						}
					m_metagame.getComms().send(c3);

				// }
			}
		}
	}


	// ----------------------------------------------------
	protected void spawnInstanceAtCursor(int senderId, string key, string type, int factionId = 0) {
		const XmlElement@ playerInfo = getPlayerInfo(m_metagame, senderId);
		Vector3 pos = stringToVector3(playerInfo.getStringAttribute("aim_target"));
		if (playerInfo !is null) {
			const XmlElement@ characterInfo = getCharacterInfo(m_metagame, playerInfo.getIntAttribute("character_id"));
			if (characterInfo !is null) {
				
				// pos.m_values[0] += 5.0;
				string c = "";
				if (type == 'projectile'){
					c = "<command class='create_instance' instance_class='" + type + "' instance_key='" + key + "' position='" + pos.toString() + "' faction_id='" + factionId + "' activated='0' />";
				}
				else{
					c = "<command class='create_instance' instance_class='" + type + "' instance_key='" + key + "' position='" + pos.toString() + "' faction_id='" + factionId + "' />";
				}
				
				m_metagame.getComms().send(c);
			}
		}
	}


	protected bool payRP(int cid,  int cost = 100) {
		const XmlElement@ characterInfo = getGenericObjectInfo(m_metagame, "character", cid);
		int rp = characterInfo.getIntAttribute("rp");

		if (rp >= cost) {
			string command =
				"<command class='rp_reward'	character_id='" + cid + "'" +
				"	reward='-"+ cost +"'>" + // multiplier affected..
				"</command>";
			m_metagame.getComms().send(command);
			return true;
			
		}
		else {
			// sendPrivateMessage(m_metagame, senderId, "Insufficient funds!!");
			return false;
		}
	}

	protected void handleBuy(int senderId, string key, string type, int cost = 100) {

		const XmlElement@ playerInfo = getPlayerInfo(m_metagame, senderId);
		int id = playerInfo.getIntAttribute("character_id");
		
		const XmlElement@ characterInfo = getGenericObjectInfo(m_metagame, "character", id);
		int rp = characterInfo.getIntAttribute("rp");

		if (rp >= cost) {
			string command =
				"<command class='rp_reward'	character_id='" + id + "'" +
				"	reward='-"+ cost +"'>" + // multiplier affected..
				"</command>";
			m_metagame.getComms().send(command);
			if (type == "weapon" || type == "projectile" || type == "carry_item") {
				giveItem(senderId, key, type);
			}
			else{
				spawnInstanceNearPlayer(senderId, key, type);
			}
			sendPrivateMessage(m_metagame, senderId, "Buy ["+ key + "] for " + cost + "!");
		}
		else {
			sendPrivateMessage(m_metagame, senderId, "Insufficient funds!!");
		}
	}

	protected bool handleBgo(int senderId, string key, string type, int cost = 100, int receiverId = -1) {
		const XmlElement@ playerInfo = getPlayerInfo(m_metagame, senderId);
		int id = playerInfo.getIntAttribute("character_id");
		string bName = playerInfo.getStringAttribute("name");

		const XmlElement@ rInfo = getPlayerInfo(m_metagame, receiverId);
		if (rInfo is null){
			return false;
		}

		string rName = rInfo.getStringAttribute("name");

		const XmlElement@ characterInfo = getGenericObjectInfo(m_metagame, "character", id);
		int rp = characterInfo.getIntAttribute("rp");

		if (rp >= cost) {
			string command =
				"<command class='rp_reward'	character_id='" + id + "'" +
				"	reward='-"+ cost +"'>" + // multiplier affected..
				"</command>";
			m_metagame.getComms().send(command);
			if (type == "weapon" || type == "projectile" || type == "carry_item") {
				giveItem(receiverId, key, type);
			}
			else{
				spawnInstanceNearPlayer(receiverId, key, type);
			}
			sendPrivateMessage(m_metagame, senderId, bName + " Buy "+ rName +	" ["+ key + "] for " + cost + "!");
		}
		else {
			sendPrivateMessage(m_metagame, senderId, "Insufficient funds!!");
		}

		return true;
	}

	protected void handleBuyXp(int senderId, float xp) {
		// TODO get xp work
		const XmlElement@ playerInfo = getPlayerInfo(m_metagame, senderId);
		int id = playerInfo.getIntAttribute("character_id");
		
		const XmlElement@ characterInfo = getGenericObjectInfo(m_metagame, "character", id);
		float rp = characterInfo.getIntAttribute("rp");

		float cost = xp * 4.0;
		// string cost = "4000"
		// string xp = "1000"

		if (rp >= cost) {
			string command =
				"<command class='rp_reward'	character_id='" + id + "'" +
				"	reward='-"+ cost +"'>" + // multiplier affected..
				"</command>";
			m_metagame.getComms().send(command);
			string command2 =
				"<command class='xp_reward'	character_id='" + id + "'" +
				"	reward='"+ xp*0.0001 +"'>" + // multiplier affected..
				"</command>";
			m_metagame.getComms().send(command2);
			sendPrivateMessage(m_metagame, senderId, "Buy ["+ xp + " xp] for " + cost + " rp!");
		}
		else {
			sendPrivateMessage(m_metagame, senderId, "Insufficient funds!!");
		}
	}



	// ----------------------------------------------------
	void P2PAttack(Vector3 weaponPos, Vector3 targetPos, int number, string instanceKey, string soundFile, float spread, int factionId, int characterId) {

		// aim
		Vector3 projectileSpeed = targetPos.subtract(weaponPos).scale(4.0/40.0);
		float dt = 0.05;
	
		// burst fire
		for (int i = 0; i < number; ++i){		
			
			//only playing the firing sound at the beginning of a salvo, for optimization reasons
			if (i == 0){
				XmlElement command("command");
					command.setStringAttribute("class", "play_sound");
					command.setStringAttribute("filename", soundFile);
					command.setStringAttribute("position", weaponPos.toString());
				m_metagame.getComms().send(command);
			}
			Vector3 ds = projectileSpeed.scale(- 40.0 * dt *i );
			//randomizing the positions of the shots, based on the spread value
			float randx = rand(-spread, spread);
			float randz = rand(-spread, spread);
			
			Vector3 newPos = weaponPos.add(Vector3(randx,0,randz)).add(ds);

			//spawning projectiles
			string c = 
				"<command class='create_instance'" +
				" faction_id='" + factionId + "'" +
				" instance_class='grenade'" +
				" instance_key='" + instanceKey + "'" +
				" position='" + newPos.toString() + "'" +
				" character_id='" + characterId + "'" +
				" offset='" + projectileSpeed.toString() + "' />";
			m_metagame.getComms().send(c);
		}
	}

	protected void giveItem(int senderId, string key, string type) {
		const XmlElement@ playerInfo = getPlayerInfo(m_metagame, senderId);
		int id = playerInfo.getIntAttribute("character_id");
		string c = 
			"<command class='update_inventory' character_id='" + id + "' container_type_class='backpack'>" + 
				"<item class='" + type + "' key='" + key + "' />" +
			"</command>";
		m_metagame.getComms().send(c);	
	}

	// --------------------------------------------
	protected bool handleSpecialBuy(const Metagame@ metagame, int senderId, string filename, string itemName = "item", string itemAttrib = "code", string targetValue = "1000", string subItemName ="player",   string subItemAttrib = "name", string subTargetValue = "X", int receiverId = -1) {
		array<string> result;
		XmlElement@ query = XmlElement(
			makeQuery(metagame, array<dictionary> = {
				dictionary = { {"TagName", "data"}, {"class", "saved_data"}, {"filename", filename}, {"location", "app_data"} } }));
		const XmlElement@ doc = metagame.getComms().query(query);

		if (doc !is null) {
			const XmlElement@ root = doc.getFirstChild();
			if (root !is null) {
				array<const XmlElement@> items = root.getElementsByTagName(itemName);
				for (uint i = 0; i < items.size(); ++i) {
					const XmlElement@ item = items[i];
					string itemValue = item.getStringAttribute(itemAttrib);
					_log(itemValue + "",1);

					if (itemValue == targetValue ){
						sendPrivateMessage(m_metagame, senderId, "Code Found!");

						array<const XmlElement@> subItems = item.getElementsByTagName(subItemName);
						string i_key = item.getStringAttribute("key");
						string i_class = item.getStringAttribute("class");
						int i_price = item.getIntAttribute("price");


						
							for (uint j = 0; j < subItems.size(); ++j) {
								const XmlElement@ subItem = subItems[j];
								string subItemValue = subItem.getStringAttribute(subItemAttrib);
								_log(subItemValue,1);

								if (subItemValue == subTargetValue) {
									sendPrivateMessage(m_metagame, senderId, "Code authorized!");

									if ( subItemName == "player") {
										handleBuy(senderId, i_key, i_class, i_price);
										return true;
									}
									if ( subItemName == "owner" ) {
										handleBgo(senderId, i_key, i_class, i_price, receiverId);
										return true;
									}
									if ( subItemName == "squad" ) {
										handleBuy(senderId, i_key, i_class, i_price);
										return true;
									}

									return false;
								}


							}


						sendPrivateMessage(m_metagame, senderId, "Code not authorized!");
						return false;
					}

					// result.insertLast(item.getStringAttribute(valueName));
				}
				sendPrivateMessage(m_metagame, senderId, "Code not found!");
				return false;
			}
		}
		sendPrivateMessage(m_metagame, senderId, "Cannot read file!");
		return false;
	}

	// --------------------------------------------
	void animate(int characterId, string animationKey, bool interruptable = true, bool hideWeapon = true) {
		XmlElement command("command");
		command.setStringAttribute("class", "update_character");
		command.setIntAttribute("id", characterId);
		command.setStringAttribute("animate", animationKey);
		command.setBoolAttribute("interruptable", interruptable);
		command.setBoolAttribute("hide_weapon", hideWeapon);
		m_metagame.getComms().send(command);
	}

	// --------------------------------------------
//	array<string>@ loadStringsFromFile(const Metagame@ metagame, string filename, string itemName = "item", string valueName = "value") {
//		array<string> result;
//		XmlElement@ query = XmlElement(
//			makeQuery(metagame, array<dictionary> = {
//				dictionary = { {"TagName", "data"}, {"class", "saved_data"}, {"filename", filename}, {"location", "app_data"} } }));
//		const XmlElement@ doc = metagame.getComms().query(query);
//
//		if (doc !is null) {
//			const XmlElement@ root = doc.getFirstChild();
//			if (root !is null) {
//				array<const XmlElement@> items = root.getElementsByTagName(itemName);
//				for (uint i = 0; i < items.size(); ++i) {
//					const XmlElement@ item = items[i];
//					result.insertLast(item.getStringAttribute(valueName));
//				}
//			}
//		}
//		return result;
//	}
}
