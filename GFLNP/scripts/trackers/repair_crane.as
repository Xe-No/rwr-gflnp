#include "tracker.as"
#include "helpers.as"
#include "admin_manager.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"

//Author: Unit G17
//Originally created for stationary cranes only. Expanded for repair tanks and blowtorches.

	// --------------------------------------------
class RepairCrane : Tracker {
	protected Metagame@ m_metagame;

	// --------------------------------------------
	RepairCrane(Metagame@ metagame) {
		@m_metagame = @metagame;
	}

	// --------------------------------------------
	protected void handleResultEvent(const XmlElement@ event) {
		//repair effect radius (at 5.0 or higher the crane repairs itself)
		float range;
		//the amount of health points added each repair cycle
		float repairValue = 0.0;
		//overrepair percentage
		float overHealth = 1.0;	
		
		//vertical offset for repair position
		float y_offset = 0.0;
		
		//xp reward for the repairer each repair cycle
		float xpReward = 0.0004;
		//rp reward for the repairer each repair cycle
		uint rpReward = 5;
		
		//checking if the event was triggered by a repair projectile
		string key = event.getStringAttribute("key");	
		int count = 0;
		
		if (key == "repair_crane") {
			range = 3.5;
			repairValue = 0.6;
			overHealth = 1.1;
			y_offset = -5.0;
		} else if (key == "repair_tank") {
			range = 3.5;
			repairValue = 0.5;
			overHealth = 1.0;
			y_offset = -5.0;
		}else if (key == "repair_lancet2") {
			range = 4.5;
			repairValue = 0.5;
			overHealth = 1.0;
			y_offset = -5.0;
		} else if (key == "repair_torch") {
			range = 3.0;
			repairValue = 0.4;
			overHealth = 1.1;
			y_offset = 0.0;
			rpReward = 0;
			xpReward = 0.0;
		} else if (key == "repair_grenade") {
			range = 5.4;
			repairValue = 1.6;
			overHealth = 1.0;
			y_offset = 0.0;
			rpReward = 0;
			xpReward = 0.0;
		} else if (key == "heal_grenade") {
			range = 4.0;
			count = 2;
			xpReward = 0.0001;
			rpReward = 0;
		} else if (key == "repair_c4") {
			range = 8.0;
			repairValue = 10.0;
			overHealth = 1.1;
			y_offset = 0.0;
			rpReward = 0;
			xpReward = 0.0;
		} else if (key == "heal_shot") {
			range = 3.0;
			count = 3;
			xpReward = 0.0001;
			rpReward = 2;
		} else if (key == "repair_upgrade") {
			range = 3.0;
			repairValue = 1.0;
			overHealth = 1.5;
			y_offset = 0.0;
			rpReward = 0;
			xpReward = 0.0;
		} else{
			return;
		}
		
		if (repairValue > 0.0) {
			//extracting the repairer's id
			int repairerId = event.getIntAttribute("character_id");
			const XmlElement@ repairer = getCharacterInfo(m_metagame, repairerId);
			int factionId = repairer.getIntAttribute("faction_id");
		
			//extracting the repair position
			Vector3 repairPos = stringToVector3(event.getStringAttribute("position"));
			repairPos = Vector3(repairPos.get_opIndex(0), repairPos.get_opIndex(1) + y_offset, repairPos.get_opIndex(2));
			array<const XmlElement@>@ characters = getCharactersNearPosition(m_metagame, repairPos, factionId, range);
			//checking for all factions, including neutral
			for (uint f = 0; f < 4; ++f){
				//custom query, collects all vehicles of a faction
				array<const XmlElement@>@ vehicles = getAllVehicles(m_metagame, f);
				
				for (uint i = 0; i < vehicles.length(); ++i) {
					//collecting vehicle positions
					Vector3 vehiclePos = stringToVector3(vehicles[i].getStringAttribute("position"));
					
					//checking for vehicles within the repair radius and extracting their keys
					if (checkRange(repairPos, vehiclePos, range)) {
						int vehicleId = vehicles[i].getIntAttribute("id");
						const XmlElement@ vehicleInfo = getVehicleInfo(m_metagame, vehicleId);
						if (vehicleInfo !is null) {
							string key2 = vehicleInfo.getStringAttribute("key");
							
							//repair tank can't repair repair tanks to prevent self repair
							if (not(key == "repair_tank" && key2 == "zjx19.vehicle")) {
								float vehicleHealth = vehicleInfo.getFloatAttribute("health");
								
								//not running for destroyed vehicles
								if (vehicleHealth > 0.0) {
									float vehicleMaxHealth = vehicleInfo.getFloatAttribute("max_health");
									float vehicleMaxOverHealth = vehicleMaxHealth * overHealth;
									
									//only running the update command when necessary
									if(key != "repair_upgrade"){
										if (vehicleHealth < vehicleMaxOverHealth) {
											//rounding error fix
											vehicleMaxOverHealth += 0.01;
										
											string command = "";
										
											//calculating and applying repairs
											float vehicleHealthDifference = vehicleMaxOverHealth - vehicleHealth;
											if (vehicleHealthDifference > repairValue){
												vehicleHealth += repairValue;
												vehicleHealthDifference = repairValue;
												command = "<command class='update_vehicle' id='" + vehicleId + "' health='" + vehicleHealth + "' />";
											} else {
												command = "<command class='update_vehicle' id='" + vehicleId + "' health='" + vehicleMaxOverHealth + "' />";
											}
											m_metagame.getComms().send(command);
										
											//rewarding the repairer
											float xpRewardFinal = xpReward * vehicleHealthDifference;
											float rpRewardFinal = rpReward * vehicleHealthDifference;
											command = "<command class='xp_reward' character_id='" + repairerId + "' reward='" + xpRewardFinal + "' />";
											m_metagame.getComms().send(command);
											command = "<command class='rp_reward' character_id='" + repairerId + "' reward='" + rpRewardFinal + "' />";
											m_metagame.getComms().send(command);
										}
									}else if(key == "repair_upgrade"){
										if (vehicleHealth < vehicleMaxOverHealth && vehicleHealth >= vehicleMaxHealth) {
											//rounding error fix
											vehicleMaxOverHealth += 0.01;
										
											string command = "";
										
											//calculating and applying repairs
											float vehicleHealthDifference = vehicleMaxOverHealth - vehicleHealth;
											if (vehicleHealthDifference > repairValue){
												vehicleHealth += repairValue;
												vehicleHealthDifference = repairValue;
												command = "<command class='update_vehicle' id='" + vehicleId + "' health='" + vehicleHealth + "' />";
											} else {
												command = "<command class='update_vehicle' id='" + vehicleId + "' health='" + vehicleMaxOverHealth + "' />";
											}
											m_metagame.getComms().send(command);
										
											//rewarding the repairer
											float xpRewardFinal = xpReward * vehicleHealthDifference;
											float rpRewardFinal = rpReward * vehicleHealthDifference;
											command = "<command class='xp_reward' character_id='" + repairerId + "' reward='" + xpRewardFinal + "' />";
											m_metagame.getComms().send(command);
											command = "<command class='rp_reward' character_id='" + repairerId + "' reward='" + rpRewardFinal + "' />";
											m_metagame.getComms().send(command);
										}
									}

								}
							}
						}
					}
				}
			}
		}
		if (count > 0) {
			//extracting the healer's id,faction
			int healerId = event.getIntAttribute("character_id");
			const XmlElement@ healer = getCharacterInfo(m_metagame, healerId);
			int factionId = healer.getIntAttribute("faction_id");
			//extracting the heal position
			Vector3 healPos = stringToVector3(event.getStringAttribute("position"));
			//Vector3 soldierPos = stringToVector3(healer.getStringAttribute("position"));

			
				//collecting all nearby soldiers
				array<const XmlElement@>@ characters = getCharactersNearPosition(m_metagame, healPos, factionId, range);
				
				for (uint i = 0; i < characters.length(); ++i) {

					int soldierId = characters[i].getIntAttribute("id");
					const XmlElement@ characterInfo = getCharacterInfo(m_metagame, soldierId);
					
						if (characterInfo !is null) {
										XmlElement c("command");
										c.setStringAttribute("class", "update_inventory");
										c.setIntAttribute("character_id", soldierId); 
										c.setStringAttribute("untransform_equipment_class", "vest");
										c.setIntAttribute("untransform_count", count);
										m_metagame.getComms().send(c);
						}
					}
										//rewarding the healer
										string command = "";
										float xpRewardFinal = xpReward * count * characters.length();
										float rpRewardFinal = rpReward * count * characters.length();
										command = "<command class='xp_reward' character_id='" + healerId + "' reward='" + xpRewardFinal + "' />";
										m_metagame.getComms().send(command);
										command = "<command class='rp_reward' character_id='" + healerId + "' reward='" + rpRewardFinal + "' />";
										m_metagame.getComms().send(command);
		}				
    }
}