#include "tracker.as"
#include "helpers.as"
#include "admin_manager.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"

// --------------------------------------------
class HealG: Tracker {
	protected Metagame@ m_metagame;

	// --------------------------------------------
	HealG	(Metagame@ metagame) {
		@m_metagame = @metagame;

	}
	protected void handleResultEvent(const XmlElement@ event) {
			float range;
			int count;
			//check event
			string key = event.getStringAttribute("key");
			//xp reward for the repairer each repair cycle
			float xpReward;
			//rp reward for the repairer each repair cycle
			uint rpReward;

		if (key == "heal_grenade") {
			range = 4.0;
			count = 2;
			xpReward = 0.0002;
			rpReward = 0;
		}else if (key == "heal_tower") {
			range = 20.0;
			count = 3;
			xpReward = 0;
			rpReward = 0;
		}
			
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
