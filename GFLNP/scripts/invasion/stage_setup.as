#include "faction_config.as"
#include "stage_invasion.as"

class StageSetup : StageConfigurator {
	protected GameModeInvasion@ m_metagame;
	protected MapRotatorInvasion@ m_mapRotator;

	// ------------------------------------------------------------------------------------------------
	StageSetup(GameModeInvasion@ metagame, MapRotatorInvasion@ mapRotator) {
		@m_metagame = @metagame;
		@m_mapRotator = @mapRotator;
	}	


	// --------------------------------------------
	Stage@ createStage() {
		Stage@ stage = Stage(m_metagame.getUserSettings());
		return stage;
	}

	// --------------------------------------------
	PhasedStage@ createPhasedStage()  {
		return PhasedStage(m_metagame.getUserSettings());
	}

	// --------------------------------------------
	const array<FactionConfig@>@ getFactionConfigs() const {
		return m_mapRotator.getFactionConfigs();
	}

	// ------------------------------------------------------------------------------------------------
	protected void setDefaultAttackBreakTimes(Stage@ stage) {
		for (uint i = 0; i < stage.m_factions.size(); ++i) {
			XmlElement command("command");
			command.setStringAttribute("class", "commander_ai");
			command.setIntAttribute("faction", i);
			command.setFloatAttribute("start_attack_break_time", 50.0f);
			command.setFloatAttribute("attack_break_time", 60.0f);
			// initially clear final attack boost
			command.setFloatAttribute("reduce_defense_for_final_attack", 0.0f); 
			stage.m_extraCommands.insertLast(command);
		}
	}
	
	// ------------------------------------------------------------------------------------------------
	protected void setReduceDefenseForFinalAttack(Stage@ stage, float value) {
		XmlElement command("command");
		command.setStringAttribute("class", "commander_ai");
		command.setIntAttribute("faction", 0);
		command.setFloatAttribute("reduce_defense_for_final_attack", value);
		stage.m_extraCommands.insertLast(command);
	}
	
	// ------------------------------------------------------------------------------------------------
	array<int> randomFactionIndexes(uint arrayLength, int returnSize) {
		array<int> baseArray;
		for (uint i = 1; i < arrayLength; ++i){
			baseArray.insertLast(i);
		}
		
		array<int> returnIndexes;
		for (int i = 0; i < returnSize; ++i){
			int r = rand(0, baseArray.length() - 1);
			returnIndexes.insertLast(baseArray[r]);
			baseArray.removeAt(r);
		}
		
		return returnIndexes;
	}
	// ------------------------------------------------------------------------------------------------
	Stage@ setupStage1() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Keepsake Bay";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map2";
		stage.m_mapInfo.m_id = "map2";

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));
		stage.m_maxSoldiers = 12 * 8;                                             // was 12*7 in 1.65, 1 base added

		stage.m_soldierCapacityVariance = 0.3;
		stage.m_playerAiCompensation = 3;                                         // was 4 (test4)
		stage.m_playerAiReduction = 2.5;                                          // was 2 (test3)    

		stage.m_minRandomCrates = 2; 
		stage.m_maxRandomCrates = 4;
		
		// random faction index
		int rfi = rand(1, getFactionConfigs().size() - 2);

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0));                                                  
			f.m_capacityOffset = 0; 
			f.m_capacityMultiplier = 1.0;
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(1));
			f.m_overCapacity = 40;                                               // was 30 (test2)
			f.m_capacityOffset = 5;                                                 // was 0 in 1.65
			stage.m_factions.insertLast(f);                                         // was 0 in 1.65
		}

		// metadata
		stage.m_primaryObjective = "capture";

		setDefaultAttackBreakTimes(stage);
		// setReduceDefenseForFinalAttack(stage, 0.1); // use this for final attack boost if needed for friendlies
		return stage;
	}

	// ------------------------------------------------------------------------------------------------
	Stage@ setupStage2() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Fridge Valley";
		stage.m_mapInfo.m_path = "media/packages/vanilla.winter/maps/map4";
		stage.m_mapInfo.m_id = "map4";

		stage.m_fogOffset = 20.0;    
		stage.m_fogRange = 50.0;     

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));
		stage.m_maxSoldiers = 17 * 6;
		stage.m_playerAiCompensation = 4;                                         // was 5 (test4)
		stage.m_playerAiReduction = 2.5;                                            // was 2 (test3)

		stage.m_minRandomCrates = 2; 
		stage.m_maxRandomCrates = 3;    
	
		// random faction index
		int rfi = rand(1, getFactionConfigs().size() - 2);

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0));
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(1));
			f.m_overCapacity = 40;                                              // was 30 (test2)
	  		f.m_capacityOffset = 5;                                                // was 0 in 1.65
			stage.m_factions.insertLast(f); 
		}

		// metadata
		stage.m_primaryObjective = "capture";

		setDefaultAttackBreakTimes(stage);
		return stage;
	}

	// ------------------------------------------------------------------------------------------------
	Stage@ setupStage3() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Old Fort Creek";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map3";
		stage.m_mapInfo.m_id = "map3";

		stage.m_includeLayers.insertLast("layer1.invasion");

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));
		stage.m_maxSoldiers = 14 * 8;
		stage.m_playerAiCompensation = 5;                                         // was 6 (test4)
		stage.m_playerAiReduction = 2.0;                                              // was 2.5 (test4)   

		stage.m_soldierCapacityVariance = 0.4;                                   // was 0.31 in 1.65

		stage.m_minRandomCrates = 2; 
		stage.m_maxRandomCrates = 3;    

		// random faction index
		int rfi = rand(1, getFactionConfigs().size() - 2);
	
		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0));
			f.m_capacityOffset = 0; 
			f.m_overCapacity = 0;
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(1));
			f.m_overCapacity = 40;                                              // was 30 (test2)
	  		f.m_capacityOffset = 5;                                                 // was 0 in 1.65 
			stage.m_factions.insertLast(f); 
		}
		

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"flamer_tank.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}        

		// metadata
		stage.m_primaryObjective = "capture";

		setDefaultAttackBreakTimes(stage);
		return stage;
	}

	// ------------------------------------------------------------------------------------------------
	Stage@ setupStage4() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Power Junction";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map7";
		stage.m_mapInfo.m_id = "map7";

		stage.m_includeLayers.insertLast("layer1.invasion");        

		stage.addTracker(Overtime(m_metagame, 0));
//		stage.addTracker(Spawner(m_metagame, 1, Vector3(477,0,520)));
//		stage.addTracker(Spawner(m_metagame, 1, Vector3(455,0,508)));
//		stage.addTracker(Spawner(m_metagame, 1, Vector3(446,0,539)));

		stage.m_maxSoldiers = 30 * 3;                                             // was 28*3 in 1.75
		stage.m_playerAiCompensation = 4;                                         // was 5 (test4)
		stage.m_playerAiReduction = 2;                                            // was 3 (test4)  
		stage.m_soldierCapacityModel = "constant";                                // was set to default in 1.65
	
		stage.m_minRandomCrates = 0; 
		stage.m_maxRandomCrates = 0;
		 
		stage.m_defenseWinTime = 600;     // was 400 in 1.65 old koth mode
		stage.m_defenseWinTimeMode = "custom";
		stage.addTracker(PausingKothTimer(m_metagame, stage.m_defenseWinTime));
		
		// random faction indexes
		array<int> rfi = randomFactionIndexes(getFactionConfigs().size() - 1, 2);
	
		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.35, 0.1));     // was 0.1, 0.1 in 1.65
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi[0]], createCommanderAiCommand(1, 0.38, 0.1));           // was 0.1, 0.1 in 1.65
			f.m_overCapacity = 20;                                              // was 0 (test2)
	  f.m_capacityOffset = 5;                                                             // was 0 in 1.65
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi[1]], createCommanderAiCommand(2, 0.38, 0.1));           // was 0.1, 0.1 in 1.65
			f.m_overCapacity = 20;                                              // was 0 (test2)
	  f.m_capacityOffset = 5;                                                             // was 0 in 1.65
			stage.m_factions.insertLast(f);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"radio_jammer2.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}        
		{
			// neutral
			Faction f(getFactionConfigs()[getFactionConfigs().size() - 1], createCommanderAiCommand(3));
			f.m_capacityMultiplier = 0.0;
			stage.m_factions.insertLast(f);
		}

		// metadata
		stage.m_primaryObjective = "koth";
		stage.m_kothTargetBase = "Power Plant";

		return stage;
	} 

	// ------------------------------------------------------------------------------------------------
	Stage@ setupStage5() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Moorland Trenches";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map1";
		stage.m_mapInfo.m_id = "map1";

		stage.m_maxSoldiers = 18 * 14;
		stage.m_playerAiCompensation = 3;                                     // was 4 (test4)     
		stage.m_playerAiReduction = 1.5;                                            // was 1 (test3)    

		stage.m_soldierCapacityVariance = 0.4; // map1 is a big map; using high variance helps keep the attack group not growing super large when more bases are captured

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));

		stage.m_minRandomCrates = 3; 
		stage.m_maxRandomCrates = 5;
	
		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0));
			f.m_overCapacity = 6;                                                   
			f.m_bases = 1;
			f.m_capacityMultiplier = 0.79;                                          // was 0.81 in 1.65 
			stage.m_factions.insertLast(f);
		}
		for (uint rfi = 1; rfi < getFactionConfigs().size() - 1; ++rfi){
			{
				Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(rfi));
				f.m_overCapacity = 60;                                                  // was 50 (test2)   
				stage.m_factions.insertLast(f);
			}
		}

		// aa emplacements work right only if one enemy faction has them
		// - all factions have it disabled by default
		// - manually enable it for faction #1 in map1 
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}

		// metadata
		stage.m_primaryObjective = "capture";

		setDefaultAttackBreakTimes(stage);
		return stage;
	}

	// ------------------------------------------------------------------------------------------------
	Stage@ setupStage6() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Bootleg Islands";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map5";
		stage.m_mapInfo.m_id = "map5";

		stage.m_maxSoldiers = 11 * 10;
		stage.m_playerAiCompensation = 4;                                       // was 5 (test4)
		stage.m_playerAiReduction = 2.5;                                              // was 2 (test3)

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));

		stage.m_minRandomCrates = 2; 
		stage.m_maxRandomCrates = 4;

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0));
			f.m_overCapacity = 0;                                                  // was 20 in 1.65
			f.m_bases = 1;
			// seems to be quite hard at times, try to favor greens a bit
			f.m_capacityMultiplier = 1.0;                                           // was 1.1 in 1.65
	  		f.m_capacityOffset = 0;                                                // was 0 in 1.65
			stage.m_factions.insertLast(f);
		}
		for (uint rfi = 1; rfi < getFactionConfigs().size() - 1; ++rfi){
			{
				Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(rfi));
				f.m_overCapacity = 30;                                              // was 0 (test2)            
				f.m_capacityOffset = 5;                                                // was 0 in 1.65
				stage.m_factions.insertLast(f);
			}
		}

		// metadata
		stage.m_primaryObjective = "capture";

		setDefaultAttackBreakTimes(stage);
		return stage;
	} 

	// ------------------------------------------------------------------------------------------------
	Stage@ setupStage7() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Rattlesnake Crescent";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map6";
		stage.m_mapInfo.m_id = "map6";

		stage.m_maxSoldiers = 15 * 9;                                             // was 17*7 in 1.65
		stage.m_playerAiCompensation = 5;                                         // was 7 (test4)
		stage.m_playerAiReduction = 2;                                            // was 3 (test2)
	
		stage.addTracker(Spawner(m_metagame, 1, Vector3(485,5,705), 10, "default_ai"));        // outpost filler (1.70)

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));

		stage.m_minRandomCrates = 2; 
		stage.m_maxRandomCrates = 3;

		// random faction index
		int rfi = rand(1, getFactionConfigs().size() - 2);
	
		{
			// greens will push a bit harder here
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.4, 0.15));   // was 0.3, 0.12 in 1.65
			f.m_overCapacity = 0;
			f.m_capacityOffset = 0; 
			f.m_capacityMultiplier = 1.0;                                          // was 0.9 in 1.65
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(1, 0.45, 0.2));        // was not set (default) in 1.65
			f.m_overCapacity = 80;                                              // was 60 (test2) 
			f.m_capacityOffset = 15;                                               // was 10 in 1.65
			stage.m_factions.insertLast(f);
		}

		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}

		setDefaultAttackBreakTimes(stage);
		return stage;
	} 


	Stage@ setupViper() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Viper";
		stage.m_mapInfo.m_path = "media/packages/GFLNP_INF/maps/viper";
		stage.m_mapInfo.m_id = "viper";

		stage.m_maxSoldiers = 15 * 9;                                             // was 17*7 in 1.65
		stage.m_playerAiCompensation = 5;                                         // was 7 (test4)
		stage.m_playerAiReduction = 2;                                            // was 3 (test2)
	
		stage.addTracker(Spawner(m_metagame, 1, Vector3(485,5,705), 10, "default_ai"));        // outpost filler (1.70)

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));

		stage.m_minRandomCrates = 2; 
		stage.m_maxRandomCrates = 3;

		// random faction index
		int rfi = rand(1, getFactionConfigs().size() - 2);
	
		{
			// greens will push a bit harder here
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.4, 0.15));   // was 0.3, 0.12 in 1.65
			f.m_overCapacity = 0;
			f.m_capacityOffset = 0; 
			f.m_capacityMultiplier = 1.0;                                          // was 0.9 in 1.65
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(1, 0.45, 0.2));        // was not set (default) in 1.65
			f.m_overCapacity = 80;                                              // was 60 (test2) 
			f.m_capacityOffset = 15;                                               // was 10 in 1.65
			stage.m_factions.insertLast(f);
		}

		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}

		setDefaultAttackBreakTimes(stage);
		return stage;
	} 

	Stage@ setupClairemont() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "clairemont";
		stage.m_mapInfo.m_path = "media/packages/GFLNP_INF/maps/clairemont";
		stage.m_mapInfo.m_id = "clairemont";

		stage.m_maxSoldiers = 15 * 9;                                             // was 17*7 in 1.65
		stage.m_playerAiCompensation = 5;                                         // was 7 (test4)
		stage.m_playerAiReduction = 2;                                            // was 3 (test2)
	
		stage.addTracker(Spawner(m_metagame, 1, Vector3(485,5,705), 10, "default_ai"));        // outpost filler (1.70)

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));

		stage.m_minRandomCrates = 2; 
		stage.m_maxRandomCrates = 3;

		// random faction index
		int rfi = rand(1, getFactionConfigs().size() - 2);
	
		{
			// greens will push a bit harder here
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.4, 0.15));   // was 0.3, 0.12 in 1.65
			f.m_overCapacity = 0;
			f.m_capacityOffset = 0; 
			f.m_capacityMultiplier = 1.0;                                          // was 0.9 in 1.65
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(1, 0.45, 0.2));        // was not set (default) in 1.65
			f.m_overCapacity = 80;                                              // was 60 (test2) 
			f.m_capacityOffset = 15;                                               // was 10 in 1.65
			stage.m_factions.insertLast(f);
		}

		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}

		setDefaultAttackBreakTimes(stage);
		return stage;
	} 

	Stage@ setupRoberto() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "roberto";
		stage.m_mapInfo.m_path = "media/packages/GFLNP_INF/maps/roberto";
		stage.m_mapInfo.m_id = "roberto";

		stage.m_maxSoldiers = 15 * 9;                                             // was 17*7 in 1.65
		stage.m_playerAiCompensation = 5;                                         // was 7 (test4)
		stage.m_playerAiReduction = 2;                                            // was 3 (test2)
	
		stage.addTracker(Spawner(m_metagame, 1, Vector3(485,5,705), 10, "default_ai"));        // outpost filler (1.70)

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));

		stage.m_minRandomCrates = 2; 
		stage.m_maxRandomCrates = 3;

		// random faction index
		int rfi = rand(1, getFactionConfigs().size() - 2);
	
		{
			// greens will push a bit harder here
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.4, 0.15));   // was 0.3, 0.12 in 1.65
			f.m_overCapacity = 0;
			f.m_capacityOffset = 0; 
			f.m_capacityMultiplier = 1.0;                                          // was 0.9 in 1.65
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(1, 0.45, 0.2));        // was not set (default) in 1.65
			f.m_overCapacity = 80;                                              // was 60 (test2) 
			f.m_capacityOffset = 15;                                               // was 10 in 1.65
			stage.m_factions.insertLast(f);
		}

		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}

		setDefaultAttackBreakTimes(stage);
		return stage;
	} 

	// ------------------------------------------------------------------------------------------------
	Stage@ setupStage8() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Vigil Island";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map8";
		stage.m_mapInfo.m_id = "map8";

		stage.m_includeLayers.insertLast("layer1.invasion"); 

		stage.addTracker(Overtime(m_metagame, 0));
		stage.addTracker(Spawner(m_metagame, 1, Vector3(255,0,344),20, "default_ai"));          // added 15 in 1.65, less over_capacity to compensate


		stage.m_maxSoldiers = 21 * 5;     // was 33 * 3 in 1.65
		stage.m_playerAiCompensation = 4;                                         // was 5 (test4)
		stage.m_playerAiReduction = 2;                                            // wasn't set in 1.65, thus 0   
		stage.m_soldierCapacityModel = "constant";

		stage.m_minRandomCrates = 1; 
		stage.m_maxRandomCrates = 2;

		stage.m_defenseWinTime = 720.0;   // was 600 in 1.65
		stage.m_defenseWinTimeMode = "custom";
		stage.addTracker(PausingKothTimer(m_metagame, stage.m_defenseWinTime));
		
		// random faction index
		int rfi = rand(1, getFactionConfigs().size() - 2);

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.3, 0.1));      // was  0.1 0.1 in 1.65
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(1, 0.25, 0.05));             // was 0.2 0.1 in 1.65
			f.m_overCapacity = 60;
			f.m_capacityMultiplier = 0.0001;                                                      // was 1.32 in 1.65, now working with offset only
			f.m_capacityOffset = 60;
			stage.m_factions.insertLast(f);
		}
		{
			// neutral
			Faction f(getFactionConfigs()[getFactionConfigs().size() - 1], createCommanderAiCommand(2));
			f.m_capacityMultiplier = 0.0;
			stage.m_factions.insertLast(f);
		}

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"radio_jammer.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}

		// metadata
		stage.m_primaryObjective = "koth";
		stage.m_kothTargetBase = "Airfield";
		stage.m_radioObjectivePresent = false;

		return stage;
	}

	// ------------------------------------------------------------------------------------------------
	Stage@ setupStage9() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Black Gold Estuary";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map9";
		stage.m_mapInfo.m_id = "map9";

		stage.m_includeLayers.insertLast("layer1.invasion");

		stage.m_maxSoldiers = 17 * 13;                // 220 in 1.65
		stage.m_soldierCapacityVariance = 0.55;       // 0.4 in 1.65
		stage.m_playerAiCompensation = 4;                                     // was 6 (test4)
		stage.m_playerAiReduction = 2;                                            // wasn't set in 1.65, thus 0

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));

		stage.m_minRandomCrates = 2; 
		stage.m_maxRandomCrates = 4;
	
		// random faction index
		int rfi = rand(1, getFactionConfigs().size() - 2);

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.4, 0.3));      // 0.2, 0.2 in 1.65
			f.m_overCapacity = 0;
			f.m_capacityMultiplier = 1.0;             // 0.9 in 1.65
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(1, 0.5, 0.2));           // 0.45, 0.2 in 1.65
			f.m_overCapacity = 80;                                              // was 60 (test2) 
			f.m_capacityOffset = 5;                                                   // was 0 (test3)
			stage.m_factions.insertLast(f);
		}

		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = true;

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"sev90.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}         

		setDefaultAttackBreakTimes(stage);
		return stage;
	}

	// ------------------------------------------------------------------------------------------------
	Stage@ setupStage10() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Railroad Gap";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map10";
		stage.m_mapInfo.m_id = "map10";

		stage.m_maxSoldiers = 13 * 12;                                            // 156, was 15*10 in 1.65
  
		stage.m_soldierCapacityVariance = 0.45;                                   // 0.4 in 1.65
		stage.m_playerAiCompensation = 4;                                     // was 5 (test4)
		stage.m_playerAiReduction = 2;                                            // was 1.5 (test3)

		stage.addTracker(Spawner(m_metagame, 1, Vector3(309,15,524), 10, "default_ai"));        // 1st tow slot filler
		stage.addTracker(Spawner(m_metagame, 1, Vector3(658,10,374), 10, "default_ai"));        // vulcan slot filler

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));

		stage.m_minRandomCrates = 2; 
		stage.m_maxRandomCrates = 3;
	
		// random faction index
		int rfi = rand(1, getFactionConfigs().size() - 2);
	
// faction 0 had 2 bases to start with (a dummy one), now only 1
		{ 				
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.4, 0.2));    // 0.1 0.2 in 1.65
			f.m_overCapacity = 0;                                                              // 0 in 1.65
			f.m_capacityOffset = 8;                                                            // was 5 (test3)
			f.m_capacityMultiplier = 1.0;                                                      // 0.9 in 1.65
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(1, 0.5, 0.2));          // 0.6 0.2 in 1.65
			f.m_overCapacity = 70;                                              // was 50 (test2) 
			f.m_capacityOffset = 20; 
			stage.m_factions.insertLast(f);
		}

		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}

		setDefaultAttackBreakTimes(stage);
		return stage;
	}

	// ------------------------------------------------------------------------------------------------

	Stage@ setupStage11() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Iron Enclave";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map13";
		stage.m_mapInfo.m_id = "map13";

		stage.m_maxSoldiers = 15 * 15;
		stage.m_playerAiCompensation = 4;                                       // was 5 (test4)
		stage.m_playerAiReduction = 2.0;                                            // was 2.5 (test4) 

		stage.m_soldierCapacityVariance = 0.4; 

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));

		stage.m_minRandomCrates = 1; 
		stage.m_maxRandomCrates = 2;
	
		// random faction indexes
		array<int> rfi = randomFactionIndexes(getFactionConfigs().size() - 1, 2);

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.5, 0.2));
			f.m_overCapacity = 0;                                              // was 20
			f.m_bases = 1;
			f.m_capacityMultiplier = 1.0; 
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi[0]], createCommanderAiCommand(1, 0.5, 0.2));
			f.m_overCapacity = 40;                                              // was 20 (test3)
			f.m_capacityOffset = 20;                                            // was 10 (test3)
			f.m_capacityMultiplier = 1.0; 
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi[1]], createCommanderAiCommand(2, 0.5, 0.2));
			f.m_overCapacity = 40;                                              // was 20 (test3)
			f.m_capacityOffset = 20;                                            // was 10 (test3)
			f.m_capacityMultiplier = 1.0; 
			stage.m_factions.insertLast(f);
		}
		{
			// neutral
			Faction f(getFactionConfigs()[getFactionConfigs().size() - 1], createCommanderAiCommand(3, 0.8, 0.2));
			f.m_capacityMultiplier = 0.0;
			stage.m_factions.insertLast(f);
		}

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}

		// metadata
		stage.m_primaryObjective = "capture";

		setDefaultAttackBreakTimes(stage);
		return stage;
	}
  
	// ------------------------------------------------------------------------------------------------
	Stage@ setupStage12() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Misty Heights";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map14";
		stage.m_mapInfo.m_id = "map14";

		stage.m_fogOffset = 20.0;    
		stage.m_fogRange = 50.0; 

		stage.m_maxSoldiers = 11 * 13;
		stage.m_playerAiCompensation = 4;                                       // was 5 (test4)
		stage.m_playerAiReduction = 2.0;                                            // was 2.5 (test4)
  
		stage.m_soldierCapacityVariance = 0.45;    // instead of 0.4 in 1.50  

//		stage.addTracker(Spawner(m_metagame, 1, Vector3(309,15,524), 10));        // 1st tow slot filler
//		stage.addTracker(Spawner(m_metagame, 1, Vector3(658,10,374), 10));        // vulcan slot filler

		stage.addTracker(PeacefulLastBase(m_metagame, 0));    
		stage.addTracker(CommsCapacityHandler(m_metagame));

		stage.m_minRandomCrates = 1; 
		stage.m_maxRandomCrates = 3;  
	
		// random faction index
		int rfi = rand(1, getFactionConfigs().size() - 2);

		{ 				
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.2, 0.1));     // was 0.1, 0.1 (test3)
			f.m_overCapacity = 0;
			f.m_capacityOffset = 10;                                            // was 0 (test3)
			f.m_capacityMultiplier = 1;                                         // was 0.75 (test2)       
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(1, 0.6, 0.25));
			f.m_overCapacity = 70;                                              // was 50 (test2)
			f.m_capacityOffset = 15; 
			stage.m_factions.insertLast(f);
		}

		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"radio_jammer.vehicle", "radio_jammer2.vehicle", "radar_tower.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}


		setDefaultAttackBreakTimes(stage);
		return stage;
	}  
  
	// ------------------------------------------------------------------------------------------------

	Stage@ setupStage13() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Green Coast";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map16";
		stage.m_mapInfo.m_id = "map16";

		stage.m_maxSoldiers = 18 * 13;
		stage.m_playerAiCompensation = 3;                                       // was 4 (test4)
		stage.m_playerAiReduction = 2;                                            // was 1.5 (test3)

		stage.m_soldierCapacityVariance = 0.45;        // was 0.4

		//		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(AttackDefenseHandlerMap16(m_metagame, 0));   // we use this instead of peacefullastbase for map16
		stage.addTracker(CommsCapacityHandler(m_metagame));

		stage.m_minRandomCrates = 2; 
		stage.m_maxRandomCrates = 5;
	
		// random faction indexes
		array<int> rfi = randomFactionIndexes(getFactionConfigs().size() - 1, 2);

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.53, 0.3));   // was 0.45 0.3
			f.m_overCapacity = 5;                                               // was 0 (test3)
			f.m_bases = 1;
			f.m_capacityMultiplier = 1.0;                                       // was 0.9 (test2)
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi[0]], createCommanderAiCommand(1, 0.6, 0.28));
			f.m_overCapacity = 80;                                              // was 40 (test2)
			f.m_capacityOffset = 10;         
			f.m_capacityMultiplier = 1.0; 
			stage.m_factions.insertLast(f);
		}
		{
// attack score is taken from the map16 attack handler script, if bases => 5    
			Faction f(getFactionConfigs()[rfi[1]], createCommanderAiCommand(2, 0.65, 0.1));          
			f.m_overCapacity = 40;
			f.m_capacityOffset = 5;                                                             
			f.m_capacityMultiplier = 1.0; 
			stage.m_factions.insertLast(f);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"vulcan_tank.vehicle", "radar_tank2.vehicle", "radio_jammer2.vehicle", "apc.vehicle", "apc_1.vehicle", "apc_2.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		} 

		// metadata
		stage.m_primaryObjective = "capture";

		setDefaultAttackBreakTimes(stage);
		return stage;
	} 

	// ------------------------------------------------------------------------------------------------
	Stage@ setupStage14() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Rattlesnake Crescent (alt)";
		stage.m_mapInfo.m_path = "media/packages/GFLNP_INF/maps/map6_2";
		stage.m_mapInfo.m_id = "map6_2";

		// we want to exclude some layers here, as the default ones are already used for the other map6
		int index = stage.m_includeLayers.find("layer1.default");
		if (index >= 0) {
		stage.m_includeLayers.removeAt(index);
		}
		index = stage.m_includeLayers.find("bases.default");
		if (index >= 0) {
		stage.m_includeLayers.removeAt(index);
		}


		stage.m_includeLayers.insertLast("layer1_2.default"); 
		stage.m_includeLayers.insertLast("bases_2.default"); 

		stage.m_maxSoldiers = 15 * 9;                                             
		stage.m_playerAiCompensation = 5;                                       // was 7 (test4) 
		stage.m_playerAiReduction = 2;                                          // was 1.5 (test3)    

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));

		stage.m_minRandomCrates = 1; 
		stage.m_maxRandomCrates = 3;
	
		// random faction index
		int rfi = rand(1, getFactionConfigs().size() - 2);

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.5, 0.15));   
			f.m_overCapacity = 0;                                               
			f.m_capacityOffset = 5;                                             // was 0 (test3)
			f.m_capacityMultiplier = 1.0;                                          
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(1, 0.48, 0.15));        
			f.m_overCapacity = 70;                                                
			f.m_capacityOffset = 15;                                            // was 0 (test2)                           
			stage.m_factions.insertLast(f);
		}

		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"radar_tank2.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		} 

		setDefaultAttackBreakTimes(stage);
		return stage;
	} 
	
	// ------------------------------------------------------------------------------------------------
	Stage@ setupStage15() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Moorland Apocalypse";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map1_2";
		stage.m_mapInfo.m_id = "map1_2";
		
		stage.m_includeLayers.insertLast("layer1.invasion");        

		stage.m_fogOffset = 15.0;    
		stage.m_fogRange = 70.0;          

			// we want to exclude some layers here
		int index = stage.m_includeLayers.find("layer1.default");
		if (index >= 0) {
		stage.m_includeLayers.removeAt(index);
		}
		index = stage.m_includeLayers.find("bases.default");
		if (index >= 0) {
		stage.m_includeLayers.removeAt(index);
		}


		stage.m_includeLayers.insertLast("layer1_2.default"); 
		stage.m_includeLayers.insertLast("bases_2.default"); 

		stage.m_maxSoldiers = 20 * 9;                                             
		stage.m_playerAiCompensation = 4;                                       // was 5 (test4) 
		stage.m_playerAiReduction = 1;                                          // was 2 (test2)
		
		stage.m_soldierCapacityVariance = 0.45;                                                       

//		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(AttackDefenseHandlerMap1_2(m_metagame, 0));   // we use this instead of peacefullastbase for map1_2
		stage.addTracker(CommsCapacityHandler(m_metagame));

		stage.m_minRandomCrates = 2; 
		stage.m_maxRandomCrates = 3;
	
		// random faction indexes
		array<int> rfi = randomFactionIndexes(getFactionConfigs().size() - 1, 2);

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.5, 0.15));   
			f.m_overCapacity = 0;
			f.m_capacityOffset = 0; 
			f.m_capacityMultiplier = 1.0;                                          
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi[0]], createCommanderAiCommand(1, 0.58, 0.15));        
			f.m_overCapacity = 40;                                                
			f.m_capacityOffset = 0;                                            
			stage.m_factions.insertLast(f);
		}
		{
// attack score is taken from the map1_2 attack handler script, if bases => 11    
			Faction f(getFactionConfigs()[rfi[1]], createCommanderAiCommand(2, 0.70, 0.1));          
			f.m_overCapacity = 50;
			f.m_capacityOffset = 30;                                                             
			f.m_capacityMultiplier = 1.0; 
			stage.m_factions.insertLast(f);
		}        

		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"vulcan_tank.vehicle", "radar_tank2.vehicle", "radio_jammer2.vehicle", "apc.vehicle", "apc_1.vehicle", "apc_2.vehicle", "guntruck.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		} 
		
		setDefaultAttackBreakTimes(stage);
		return stage;
	}     

	// ------------------------------------------------------------------------------------------------
	Stage@ setupStage16() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Tropical Blizzard";
		stage.m_mapInfo.m_path = "media/packages/vanilla.winter/maps/map8_2";
		stage.m_mapInfo.m_id = "map8_2";

		stage.m_fogOffset = 10.0;    
		stage.m_fogRange = 40.0;


		stage.m_maxSoldiers = 12 * 11;                                         // 132
		stage.m_soldierCapacityVariance = 0.6;                              

		stage.m_playerAiCompensation = 4;                                         
		stage.m_playerAiReduction = 2.0;                                       // was 1.5 (test5)        
		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));

		stage.addTracker(Spawner(m_metagame, 1, Vector3(146,10,173), 2, "miniboss"));           // Cargo helicopter filler 
		stage.addTracker(Spawner(m_metagame, 1, Vector3(146,10,173), 10, "default_ai"));        // Cargo helicopter filler                  

		stage.m_minRandomCrates = 1; 
		stage.m_maxRandomCrates = 3;
	
		// random faction index
		int rfi = rand(1, getFactionConfigs().size() - 2);

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.5, 0.1));     
			f.m_overCapacity = 0;                                                              
			f.m_capacityOffset = 0; 
			f.m_capacityMultiplier = 1.0;                                          
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(1, 0.65, 0.1));            // was 0.7 0.1
			f.m_overCapacity = 50;                                                
			f.m_capacityOffset = 0;                                            
			stage.m_factions.insertLast(f);
		}

		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"radar_tank2.vehicle", "wiesel_tow.vehicle", "cargo_helicopter_broken.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		} 

		setDefaultAttackBreakTimes(stage);
		return stage;
	} 
	// ------------------------------------------------------------------------------------------------
	Stage@ setupStage17() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Gotcha Island";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map17";
		stage.m_mapInfo.m_id = "map17";

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));
		stage.m_maxSoldiers = 11 * 12;                                          // was 11*10

		stage.m_soldierCapacityVariance = 0.55;                                  // was 0.4
		stage.m_playerAiCompensation = 4;                                       // was 4
		stage.m_playerAiReduction = 2.0;                                        // was 2    

		stage.m_minRandomCrates = 1; 
		stage.m_maxRandomCrates = 3;
		
		// random faction index
		int rfi = rand(1, getFactionConfigs().size() - 2);

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.6, 0.14));      // was 0.62, 0.14 (default values)                                            
			f.m_capacityOffset = 0; 
			f.m_capacityMultiplier = 1.0;
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(1, 0.60, 0.14));             // was 0.0.62, 0.14 (test 6)
			f.m_overCapacity = 60;                                             // was 30
			f.m_capacityOffset = 5;                                            // was 5
			stage.m_factions.insertLast(f);                                    
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"m113_tank_acav.vehicle", "radio_jammer.vehicle", "radar_tower.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}

		// metadata
		stage.m_primaryObjective = "capture";

		setDefaultAttackBreakTimes(stage);
		// setReduceDefenseForFinalAttack(stage, 0.1); // use this for final attack boost if needed for friendlies
		return stage;
	}
	// -----------------------------
	Stage@ setupStage18() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Dry Enclave";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map13_2";
		stage.m_mapInfo.m_id = "map13_2";

		stage.m_includeLayers.insertLast("layer1.invasion");        

		stage.addTracker(Overtime(m_metagame, 0));

		stage.m_maxSoldiers = 10 * 20;                                             
		stage.m_playerAiCompensation = 4;                                         
		stage.m_playerAiReduction = 2;                                              
		stage.m_soldierCapacityModel = "constant";       

		stage.addTracker(Spawner(m_metagame, 3, Vector3(506,0,465), 50, "default"));
	
	
		stage.m_minRandomCrates = 0; 
		stage.m_maxRandomCrates = 1;
		 
		stage.m_defenseWinTime = 800; 
		stage.m_defenseWinTimeMode = "custom";
		stage.addTracker(PausingKothTimer(m_metagame, stage.m_defenseWinTime));
		
		{
		XmlElement command("command");
		command.setStringAttribute("class", "change_game_settings");
		for (uint i = 0; i < m_metagame.getFactionCount(); ++i) {
			XmlElement faction("faction");
			if (int(i) == 3) {
				faction.setFloatAttribute("capacity_multiplier", 0.00001);
				faction.setBoolAttribute("lose_without_bases", false);
			}
			command.appendChild(faction);
			}
		m_metagame.getComms().send(command);
		stage.addTracker(RunAtStart(m_metagame, command));
		}
		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.35, 0.1));     
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[2], createCommanderAiCommand(2, 0.38, 0.1));           
			f.m_overCapacity = 0;                                              
			f.m_capacityOffset = 5;                                                             
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[1], createCommanderAiCommand(1, 0.38, 0.1));           
			f.m_overCapacity = 0;                                              
			f.m_capacityOffset = 5;                                                             
			stage.m_factions.insertLast(f);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"technical.vehicle", "radio_jammer2.vehicle", "radar_tank2.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		} 
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"technical.vehicle", "radio_jammer2.vehicle", "radar_tank2.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}        
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 2);
			addFactionResourceElements(command, "vehicle", array<string> = {"technical.vehicle", "radio_jammer2.vehicle", "radar_tank2.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}  
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 3);
			addFactionResourceElements(command, "vehicle", array<string> = {"technical.vehicle", "radio_jammer2.vehicle", "radar_tank2.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}  		
		{
			// neutral
			Faction f(getFactionConfigs()[3], createCommanderAiCommand(3));
		//	f.m_overCapacity = 60;
			f.m_capacityMultiplier = 0;
			stage.m_factions.insertLast(f);
		}


		// metadata
		stage.m_primaryObjective = "koth";
		stage.m_kothTargetBase = "Dry Enclave";

		return stage;
	} 	



	// ------------------------------------------------------------------------------------------------

	Stage@ setupStage19() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Warsalt Legacy";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map18";
		stage.m_mapInfo.m_id = "map18";
		
		stage.m_includeLayers.insertLast("layer1.invasion");		

//    stage.m_fogOffset = 20.0;    
//    stage.m_fogRange = 50.0; 

		stage.m_maxSoldiers = 16 * 15;
		stage.m_playerAiCompensation = 4;                                       
		stage.m_playerAiReduction = 2.0;                                            
  
//		stage.m_soldierCapacityVariance = 0.45;  

//		stage.addTracker(Spawner(m_metagame, 1, Vector3(309,15,524), 10));        // 1st tow slot filler
//		stage.addTracker(Spawner(m_metagame, 1, Vector3(658,10,374), 10));        // vulcan slot filler

		stage.addTracker(PeacefulLastBase(m_metagame, 0));    
		stage.addTracker(CommsCapacityHandler(m_metagame));

		stage.m_minRandomCrates = 1; 
		stage.m_maxRandomCrates = 3;  

		{ 				
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.4, 0.1));   // was 0.3 0.1  
			f.m_overCapacity = 0;
			f.m_capacityOffset = 0;      // was 5                                       
			f.m_capacityMultiplier = 1;                                               
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[1], createCommanderAiCommand(1, 0.5, 0.2));   // was 0.6 0.2
			f.m_overCapacity = 100;      // was 70                                       
			f.m_capacityOffset = 30;     // was 15
			stage.m_factions.insertLast(f);
		}

		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"radio_jammer.vehicle", "radio_jammer2.vehicle", "radar_tower.vehicle", "m528.vehicle", "apc.vehicle", "apc_1.vehicles", "apc_2.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}


		setDefaultAttackBreakTimes(stage);
		return stage;
	}  
 


	// ------------------------------------------------------------------------------------------------
	// ------------------------------------------------------------------------------------------------
	// FINAL STAGES
	// ------------------------------------------------------------------------------------------------
	// ------------------------------------------------------------------------------------------------
	// --------------------------------------------
	Stage@ setupFinalStage1() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Final mission I"; // warning, default.character has reference to this name, careful if it needs to be changed
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map11";
		stage.m_mapInfo.m_id = "map11";
		
		stage.m_includeLayers.insertLast("layer1.invasion");        

		stage.m_maxSoldiers = 110;   // 100 in 0.99.4

		stage.m_playerAiCompensation = 5;                                       // was 3 (test2)
		stage.m_playerAiReduction = 0;                                              

		stage.m_minRandomCrates = 1; 
		stage.m_maxRandomCrates = 3;

		stage.m_finalBattle = true;
		stage.m_hidden = true;

		stage.addTracker(DestroyVehicleToCaptureBase(m_metagame, "radio_jammer.vehicle", 2));
		stage.addTracker(DestroyVehicleToCaptureBase(m_metagame, "radar_tower.vehicle", 2));    

		stage.addTracker(Spawner(m_metagame, 1, Vector3(367,0,702), 15, "default_ai"));         // 1st tower
		stage.addTracker(Spawner(m_metagame, 1, Vector3(414,0,542), 10, "default_ai"));         // 1st top tower
		stage.addTracker(Spawner(m_metagame, 1, Vector3(507,0,651), 10, "default_ai")); 
		stage.addTracker(Spawner(m_metagame, 1, Vector3(482,0,730), 5, "default_ai"));  
		stage.addTracker(Spawner(m_metagame, 1, Vector3(500,0,550), 5, "default_ai"));           
		stage.addTracker(Spawner(m_metagame, 1, Vector3(612,0,519), 10, "default_ai"));    
		stage.addTracker(Spawner(m_metagame, 1, Vector3(544,0,476), 5, "default_ai")); 
		stage.addTracker(Spawner(m_metagame, 1, Vector3(603,0,620), 10, "default_ai")); 
		stage.addTracker(Spawner(m_metagame, 1, Vector3(707,0,569), 10, "default_ai")); 
		stage.addTracker(Spawner(m_metagame, 1, Vector3(720,0,477), 10, "default_ai"));    
		stage.addTracker(Spawner(m_metagame, 1, Vector3(790,0,454), 10, "default_ai")); 
		stage.addTracker(Spawner(m_metagame, 1, Vector3(538,0,592), 10, "default_ai"));     
		
		// make neutral instantly not alive to avoid any possibility to gain capacity, like via not losing all bases first 
		// and then gaining bases which have vehicles that give capacity offset..
		{
			XmlElement command("command");
			command.setStringAttribute("class", "set_match_status");
			command.setIntAttribute("faction_id", 2);
			command.setBoolAttribute("lose", true);
			// can't use m_extraCommands, they happen before match start, using trackers instead then
			stage.addTracker(RunAtStart(m_metagame, command));     
		}

		// random faction index
		int rfi = rand(1, getFactionConfigs().size() - 2);
		
		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.0, 0.0, false));
			f.m_overCapacity = 2;
			f.m_capacityMultiplier = 0.0001; // have at least a little capacity, otherwise is marked as neutral
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			// in adventure mode, this faction config will be replaced with the correct one when final battle 1 opponent is decided 
			Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(1, 1.0, 0.0, false));
			stage.m_factions.insertLast(f); 
		}
		{
			// neutral
			Faction f(getFactionConfigs()[getFactionConfigs().size() - 1], createCommanderAiCommand(3));
			f.m_capacityMultiplier = 0.0;
			stage.m_factions.insertLast(f);
		}

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"mobile_armory.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		
		// no calls for friendly faction in the last map
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			command.setBoolAttribute("clear_calls", true);
			stage.m_extraCommands.insertLast(command);
		}

		// metadata
		stage.m_primaryObjective = "final1";

		return stage;
	}

	// --------------------------------------------
	Stage@ setupFinalStage2() {
		PhasedStage@ stage = createPhasedStage();
		stage.setPhaseController(PhaseControllerMap12(m_metagame));
		stage.m_mapInfo.m_name = "Final mission II"; // warning, default.character has reference to this name, careful if it needs to be changed
		stage.m_mapInfo.m_path = "media/packages/vanilla.winter/maps/map12";
		stage.m_mapInfo.m_id = "map12";

		stage.m_fogOffset = 20.0;    
		stage.m_fogRange = 50.0; 

		stage.m_maxSoldiers = 70;                                               // was 80 in 1.70
		stage.m_playerAiCompensation = 3;                                       // was 5 (test4)
		stage.m_playerAiReduction = 2;                                              // wasn't set in 1.65, thus 0
	
		stage.m_minRandomCrates = 0; 
		stage.m_maxRandomCrates = 1;

		stage.m_finalBattle = true;
		stage.m_hidden = true;
		
		// random faction index
		int rfi = rand(1, getFactionConfigs().size() - 2);

		// set all defend initially, the phases will control it once things start moving
		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 1.0, 0.0));
			f.m_capacityMultiplier = 0.4;
			stage.m_factions.insertLast(f);
		}
		{
			// in adventure mode, this faction config will be replaced with the correct one when final battle 1 opponent is decided 
			Faction f(getFactionConfigs()[rfi], createCommanderAiCommand(1, 1.0, 0.0));
			f.m_loseWithoutBases = false;
			stage.m_factions.insertLast(f); 
		}
		{
			// neutral
			Faction f(getFactionConfigs()[getFactionConfigs().size() - 1], createCommanderAiCommand(3));
			f.m_capacityMultiplier = 0.0;
			stage.m_factions.insertLast(f);
		}

		// metadata
		stage.m_primaryObjective = "final2";

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"radio_jammer.vehicle", "radar_tower.vehicle"}, false);
			stage.m_extraCommands.insertLast(command);
		}

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);
			stage.m_extraCommands.insertLast(command);
		}

		return stage;
	}


}