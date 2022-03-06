#include "tracker.as"
#include "helpers.as"
#include "admin_manager.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"



	// --------------------------------------------
class RepairG : Tracker {
	protected Metagame@ m_metagame;

	// --------------------------------------------
	RepairG(Metagame@ metagame) {
		@m_metagame = @metagame;
	}

	// --------------------------------------------
	array<const XmlElement@>@ getVehiclesNearPosition(const Metagame@ metagame, const Vector3@ position, int factionId, float range = 40.0f) {
	array<const XmlElement@> vehicles;

	XmlElement@ query = XmlElement(
		makeQuery(metagame, array<dictionary> = {
			dictionary = { {"TagName", "data"}, {"class", "vehicles"}, {"faction_id", factionId}, 
						   {"position", position.toString()}, {"range", range} } }));

	const XmlElement@ doc = metagame.getComms().query(query);
	if (doc !is null) {
		vehicles = doc.getElementsByTagName("vehicle");
		return vehicles;
	} else {
		array<const XmlElement@> empty;
		return @empty;
	}
}
	// --------------------------------------------
	protected void handleResultEvent(const XmlElement@ event) {
		//repair effect radius (at 5.0 or higher the crane repairs itself)
		float range;
		//the amount of health points added each repair cycle
		float repairValue = 0.0;
		//overrepair percentage
		float overHealth;	
		
		
		//xp reward for the repairer each repair cycle
		float xpReward = 0.0004;
		//rp reward for the repairer each repair cycle
		uint rpReward = 5;
		
		//checking if the event was triggered by a repair projectile
		string key = event.getStringAttribute("key");		
		
		if (key == "repair_grenade") {
			range = 5.0;
			repairValue = 0.8;
			overHealth = 1.0;
			rpReward = 0;
			xpReward = 0.0;
		}
		
		if (repairValue > 0.0) {
			//extracting the repairer's id
			int repairerId = event.getIntAttribute("character_id");
			const XmlElement@ repairer = getCharacterInfo(m_metagame, repairerId);
			int factionId = repairer.getIntAttribute("faction_id");	
			//extracting the repair position
			Vector3 repairPos = stringToVector3(event.getStringAttribute("position"));
			repairPos = Vector3(repairPos.get_opIndex(0), repairPos.get_opIndex(1), repairPos.get_opIndex(2));

			array<const XmlElement@>@ vehicles = getVehiclesNearPosition(m_metagame, repairPos, factionId, range);



			for (uint i = 0; i < vehicles.length(); ++i) {	

					int vehicleId = vehicles[i].getIntAttribute("id");
					const XmlElement@ vehicleInfo = getVehicleInfo(m_metagame, vehicleId);
					if (vehicleInfo !is null) {
						string key2 = vehicleInfo.getStringAttribute("key");
							
							
						float vehicleHealth = vehicleInfo.getFloatAttribute("health");
								
						//not running for destroyed vehicles
						if (vehicleHealth > 0.0) {
							float vehicleMaxHealth = vehicleInfo.getFloatAttribute("max_health");
							float vehicleMaxOverHealth = vehicleMaxHealth * overHealth;
									
							//only running the update command when necessary
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
					}
				}
			}
		}
    }
}