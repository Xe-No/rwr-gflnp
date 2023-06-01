#include "tracker.as"
#include "helpers.as"
#include "admin_manager.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"

class Vindicator : Tracker {
	protected Metagame@ m_metagame;


	// --------------------------------------------
	Vindicator(Metagame@ metagame) {
		@m_metagame = @metagame;
	}

	// --------------------------------------------
	bool hasEnded() const {
		// always on
		return false;
	}

	// --------------------------------------------
	bool hasStarted() const {
		return true;
	}

	// --------------------------------------------
	protected void handleResultEvent(const XmlElement@ event) {
		//emp notify_script key
		string v_Key = "vindicator";
		int vcId = event.getIntAttribute("character_id");
		if (vcId <0) return;
		const XmlElement@ character = getCharacterInfo(m_metagame, vcId);
		int factionId = character.getIntAttribute("faction_id");
		string key = event.getStringAttribute("key");
		if (key == v_Key) {
		Vector3 vPos = stringToVector3(event.getStringAttribute("position"));
		//Vector3 vvPos = vPos.add(Vector3(0, 50, 0));


		string c1 = 
			"<command class='create_instance'" +
			" faction_id='" + factionId + "'" +
			" instance_class='grenade'" +
			" instance_key='r_vindicator_sub_sub_missile_spawn.projectile'" +
			" position='" +  vPos.toString() + "'" +
			" character_id='" + vcId + "' />";
		string c2 = 
			"<command class='create_instance'" +
			" faction_id='" + factionId + "'" +
			" instance_class='grenade'" +
			" instance_key='r_vindicator_sub_sub_shrapnel_spawn.projectile'" +
			" position='" +  vPos.toString() + "'" +
			" character_id='" + vcId + "' />";


			m_metagame.getComms().send(c2);
			m_metagame.getComms().send(c1);
		

			
		}
	}
}


//r_vindicator_dive_bomb