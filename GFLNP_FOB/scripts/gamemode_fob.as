#include "simple_gamemode.as"
#include "basic_command_handler.as"
// #include "my_item_delivery_configurator_invasion.as"
#include "spawn_at_node.as"  

// --------------------------------------------
class GameModeFOB : SimpleGameMode {
	// --------------------------------------------
	GameModeFOB(UserSettings@ settings) {
		super(settings);
	}


	// --------------------------------------------
	void init() {
		SimpleGameMode::init();

		// setupItemDeliveryOrganizer(); //TODO

		// add local player as admin for easy testing, hacks, etc
		// if (!getAdminManager().isAdmin(getUserSettings().m_username)) {
		// 	getAdminManager().addAdmin(getUserSettings().m_username);
		// }
	}

	// protected void setupItemDeliveryOrganizer() {
	// 	MyItemDeliveryConfiguratorInvasion configurator(this);
	// 	@m_itemDeliveryOrganizer = ItemDeliveryOrganizer(this, configurator);
	// }



	// --------------------------------------------
	protected void changeMap() {
		XmlElement command("command");
		command.setStringAttribute("class", "change_map");
		command.setStringAttribute("map", "media/packages/vanilla/maps/map0");
		// command.setStringAttribute("map", "media/packages/GFLNP_INF/maps/fob");
		
		{
			XmlElement package("package");
			package.setStringAttribute("path", "media/packages/GFLNP");
			command.appendChild(package);
		}

		getComms().send(command);
	}

	// --------------------------------------------
	protected void startMatch() {
		XmlElement command("command");
		command.setStringAttribute("class", "start_game");
		command.setStringAttribute("savegame", getUserSettings().m_savegame); 
		command.setIntAttribute("vehicles", 1);
		command.setIntAttribute("max_soldiers", 500);
		command.setFloatAttribute("soldier_capacity_variance", 0.5);  // was 0.4 (1.63)     // was 0.45 (1.64)
		command.setFloatAttribute("player_ai_compensation", 3);      // was 4    (1.63)      // was 2 (1.64)
		command.setFloatAttribute("player_ai_reduction", 2);         // was 1    (1.63)      // was 1 (1.64)
		command.setFloatAttribute("xp_multiplier", 0.5);
		command.setFloatAttribute("rp_multiplier", 1.0);
		command.setFloatAttribute("initial_xp", 0.2);
		command.setFloatAttribute("initial_rp", 100.0);
		command.setStringAttribute("base_capture_system", "any");
		command.setIntAttribute("randomize_respawn_items", 0);
		command.setIntAttribute("fov", getUserSettings().m_fov ? 1 : 0);
	
		{
			XmlElement f("faction");
			f.setFloatAttribute("initial_over_capacity", 0);
			f.setFloatAttribute("ai_accuracy", 0.95);
			f.setFloatAttribute("capacity_multiplier", 0.34);               // was 0.33 (1.64)
			f.setFloatAttribute("initial_over_capacity", 30);
			f.setBoolAttribute("lose_without_bases", false);      
			command.appendChild(f);
		}		
		{
			XmlElement f("faction");
			f.setFloatAttribute("initial_over_capacity", 0);
			f.setFloatAttribute("ai_accuracy", 0.95);
			f.setFloatAttribute("capacity_multiplier", 0.34);               // was 0.33 (1.64)
			f.setFloatAttribute("initial_over_capacity", 30);
			f.setBoolAttribute("lose_without_bases", false);      
			command.appendChild(f);
		}



		XmlElement player("local_player");
		player.setIntAttribute("faction_id", getUserSettings().m_factionChoice);
		player.setStringAttribute("username", getUserSettings().m_username);
		command.appendChild(player);

		getComms().send(command);

		getComms().send("<command class='commander_ai' faction='0' active='1' base_defense='0.35' border_defense='0.25' />");
		getComms().send("<command class='commander_ai' faction='1' active='1' base_defense='0.35' border_defense='0.35' side_base_attack_probability='0.15' />");
		getComms().send("<command class='commander_ai' faction='2' active='1' base_defense='0.55' border_defense='0.25' />");
		getComms().send("<command class='commander_ai' faction='3' active='1' base_defense='0.50' border_defense='0.38' minimum_squad_size_to_send_to_side_base_attack='1' side_base_attack_probability='0.7' />");     // default values are respectively 4 and 0.05 

	}

	// --------------------------------------------
	void postBeginMatch() {
		SimpleGameMode::postBeginMatch();

		addTracker(BasicCommandHandler(this));
		


   
	
// helper tracker used to spawn randomized resources at randomized generic nodes when the map starts
// --------------------------------------------

{
	array<ScoredResource@> resources = {
		ScoredResource("special_crate_wood1.vehicle", "vehicle", 20.0f),
	ScoredResource("special_crate_wood2.vehicle", "vehicle", 20.0f),
	ScoredResource("special_crate_wood3.vehicle", "vehicle", 20.0f),
	ScoredResource("special_crate_wood4.vehicle", "vehicle", 20.0f),
	ScoredResource("special_crate_wood5.vehicle", "vehicle", 20.0f),
	ScoredResource("special_crate_wood6.vehicle", "vehicle", 10.0f),
	ScoredResource("special_crate_wood7.vehicle", "vehicle", 10.0f),
	ScoredResource("special_crate_wood8.vehicle", "vehicle", 10.0f)        
 
	};
	addTracker(SpawnAtNode(this, resources, "wooden_crate", 0, 10));
	// 0 here is faction id, consider if 0 is ok and adjust accordingly
}    
	
	}

	// --------------------------------------------
	uint getFactionCount() const {
		return 2;    
	}
}
