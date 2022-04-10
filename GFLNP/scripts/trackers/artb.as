#include "tracker.as"
#include "helpers.as"
#include "admin_manager.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"

//Author: Unit G17

	// --------------------------------------------
class ArtB : Tracker {
	protected Metagame@ m_metagame;

	// --------------------------------------------
	ArtB(Metagame@ metagame) {
		@m_metagame = @metagame;
	}

	// --------------------------------------------
	protected void handleResultEvent(const XmlElement@ event) {
	
		//checking if the event was triggered by a rangefinder notify_script		
		if (event.getStringAttribute("key") == "artb") {
		
			int characterId = event.getIntAttribute("character_id");
			const XmlElement@ character = getCharacterInfo(m_metagame, characterId);
			int factionId = character.getIntAttribute("faction_id");
			
			if (character !is null) {
				int playerId = character.getIntAttribute("player_id");
				const XmlElement@ player = getPlayerInfo(m_metagame, playerId);
				
				if (player !is null) {
			
					if (player.hasAttribute("aim_target")) {
						Vector3 target = stringToVector3(player.getStringAttribute("aim_target"));
						Vector3 origin = stringToVector3(character.getStringAttribute("position"));
						Vector3 FPos = Vector3(target.get_opIndex(0), target.get_opIndex(1) + 40, target.get_opIndex(2));
						//int distance = int(getPositionDistance(target, origin));
			string c = 
				"<command class='create_instance'" +
				" faction_id='" + factionId + "'" +
				" instance_class='grenade'" +
				" instance_key='mortar_flare.projectile'" +
				" position='" + FPos.toString() + "'" +
				" character_id='" + characterId + "' />";
			m_metagame.getComms().send(c);

						
						//sendFactionMessageKeySaidAsCharacter(m_metagame, 0, characterId, "target marked, flare out, mortar fire ready.");				

					}
				}
			}
		}
	}
}