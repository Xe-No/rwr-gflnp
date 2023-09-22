#include "tracker.as"
#include "helpers.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"

/*
credits:
adapted by Xe-No from a10_gun_run.as
*/

//when an Heli gun run is requested, the caller's id, the call's position and id, the strike's direction and the marker vehicle's id are stored
class HeliRequest {
	int m_characterId;
	Vector3 m_targetPos;
	Vector3 m_heliPos;
	int m_direction;
	int m_callId;
	int m_factionId;

	HeliRequest(int characterId, Vector3 targetPos, Vector3 heliPos, int direction, int callId, int factionId){
		m_characterId = characterId;
		m_targetPos = targetPos;
		m_heliPos = heliPos;
		m_direction = direction;
		m_callId = callId;
		m_factionId = factionId;
	}
}

class HeliGunRun : Tracker {
	protected Metagame@ m_metagame;
	protected float m_timer;
	protected float m_timer_attack = 0.0;
	protected float m_timer_scan = 0.0;
	protected float m_timer_25 = 0.0;
	protected float m_timer_40 = 0.0;
	protected float m_timer_105 = 0.0;
	protected Vector3 m_heli_pos;



	protected bool m_running = false;
	protected array<HeliRequest@> HeliQueue;
	protected bool m_shadow = false;
	protected float m_pi = acos(-1.0f);


	HeliGunRun(Metagame@ metagame) {
		@m_metagame = @metagame;
	}

	protected void handleCallEvent(const XmlElement@ event) {
		// Hey we got a call!

		// Check call key
		string call_key = event.getStringAttribute("call_key");
		if (call_key == "jugger_drop.call" 
			|| call_key == "paratroopers_medic.call" 
			|| call_key == "squad_somst.call" 
			// || call_key == "squad_404.call"
			// || call_key == "squad_AR.call"
			|| call_key == "squad_defy.call"
			) {
			string phase = event.getStringAttribute("phase");
			//during the request all necessary information gets stored about the call, except for the marker the vehicle, it's done later
			if (phase == "queue") {
				int characterId = event.getIntAttribute("character_id");
				int callId = event.getIntAttribute("id");
				int factionId = event.getIntAttribute("faction_id");

				Vector3 targetPos = stringToVector3(event.getStringAttribute("target_position"));
				Vector3 senderPos = stringToVector3(event.getStringAttribute("target_position"));

				//determining on which direction out of the 12 the current call fits the most
				// int direction = gunRunDirection(senderPos, targetPos); // forced to be 9
				int direction = 9;

				if(call_key != "squad_somst.call" ){
					const XmlElement@ characterInfo = getCharacterInfo(m_metagame, characterId);
					if(characterInfo is null) return;
					senderPos = stringToVector3(characterInfo.getStringAttribute("position"));

				}
				
				Vector3 heliPos = senderPos.add(Vector3(0.0,30.0,0.0));

				HeliRequest@ thisCall = HeliRequest(characterId, targetPos, heliPos, direction, callId, factionId);

				//placing ground marker and flag
				//addMarker(thisCall);
				//the queue is necessary to handle multiple simultaneous Heli requests
				HeliQueue.insertLast(thisCall);
			}
			//this timer ensures that the sound lines up with the arrival of the projectiles
			if (phase == "launch") {
				//announcing the aircraft's arrival and direction
				dictionary dict = {{"TagName", "command"},{"class", "chat"},{"text", "Aircraft on its way"},{"faction_id", 0}};
				m_metagame.getComms().send(XmlElement(dict));

				//starting timer
				m_timer = 4.0;
				m_running = true;
			}
		}
	}

	// --------------------------------------------
	void update(float time) {
		m_timer -= time;
		//once the timer ran out, the spawning process is started
		if (m_timer < 0.0) {
			if (HeliQueue.length() == 0) return;
			if (m_timer_attack < 10.0) {
				m_timer_attack += time;
				m_timer_scan -= time;
				m_timer_25 -= time;
				m_timer_40 -= time;
				m_timer_105 -= time;

				if (m_timer_25 <= 0.0){
					
					antiPerson(HeliQueue[0], rand(4,8), "ac130_25mm.projectile", "ac130_25mm.wav");
					m_timer_25 = 1.0;
				}

				// if (m_timer_40 <= 0.0){
				// 	antiPerson(HeliQueue[0], 1, "ac130_40mm.projectile", "ac130_40mm.wav");
				// 	m_timer_40 = 1.5;
				// }

				// if (m_timer_105 <= 0.0){
				// 	antiPerson(HeliQueue[0], 1, "ac130_105mm.projectile", "ac130_105mm.wav");
				// 	m_timer_105 = 6.0;
				// }
				//removeMarker(HeliQueue[0]);

			} 
			else {
				//shadow phase
				//stopping timer
				m_running = false;
				m_shadow = false;
				m_timer_attack = 0.0;
				m_timer_scan = 0.0;
				m_timer_25 = 0.0;
				m_timer_40 = 0.0;
				m_timer_105 = 0.0;


				//removing completed request
				HeliQueue.removeAt(0);
			}
		}
	}

	int gunRunDirection(Vector3 senderPos, Vector3 targetPos) {
		// First we get the line from the sender to the target
		Vector3 sightLine = senderPos.subtract(targetPos);

		//calculating which direction it fits on the most out of the 12 possible orientations
		int direction = int( (((atan2(-sightLine.get_opIndex(2), -sightLine.get_opIndex(0))) / m_pi) * 180 + 195) / 30 ) + 3;

		if (direction > 12) { direction -= 12; }

		return direction;
	}

	Vector3 gunRunVector(int direction) {
		//recalculating the 3d vector from the direction data
		float angle = (float(direction) / 6) * m_pi;

		Vector3 attackVector = Vector3(sin(angle), 0, -cos(angle));

		return attackVector;
	}

	void addMarker(HeliRequest@ HeliRequest) {
		//placing the flag
		Vector3 targetPos = HeliRequest.m_targetPos;
		int characterId = HeliRequest.m_characterId;
		Vector3 direction = gunRunVector(HeliRequest.m_direction);		
		int flagId = HeliRequest.m_callId + 8000;

		XmlElement command("command");
		command.setStringAttribute("class", "set_marker");
		command.setIntAttribute("id", flagId);
		command.setIntAttribute("faction_id", HeliRequest.m_factionId);
		command.setIntAttribute("atlas_index", 5);
		command.setFloatAttribute("size", 0.5);
		command.setFloatAttribute("range", 120.0);
		command.setIntAttribute("enabled", 1);
		command.setStringAttribute("position", targetPos.toString());
		command.setStringAttribute("text", "");
		// command.setStringAttribute("type_key", "call_marker_a10_" + HeliRequest.m_direction);
		command.setStringAttribute("type_key", "call_marker_gunship");
		command.setBoolAttribute("show_in_map_view", true);
		command.setBoolAttribute("show_in_game_view", true);
		command.setBoolAttribute("show_at_screen_edge", false);
		m_metagame.getComms().send(command);




	}



	void removeMarker(HeliRequest@ HeliRequest) {
		int flagId = HeliRequest.m_callId + 8000;

		//removing the flag
		XmlElement command("command");
		command.setStringAttribute("class", "set_marker");
		command.setIntAttribute("id", flagId);
		command.setIntAttribute("enabled", 0);
		command.setIntAttribute("faction_id", 0);
		m_metagame.getComms().send(command);
	}


	void antiPerson(HeliRequest@ HeliRequest, int number, string instanceKey, string soundFile) {
		// Now we find the line perpendicular to caller-target

		//extracting data
		int characterId = HeliRequest.m_characterId;
		int factionId = HeliRequest.m_factionId;
		Vector3 targetPos = HeliRequest.m_targetPos;
		Vector3 direction = gunRunVector(HeliRequest.m_direction);
		Vector3 heliPos = HeliRequest.m_heliPos;
		//projectile speed has been calibrated for 40 horizontal, 40 vertical spawn offset
		Vector3 projectileSpeed = Vector3(-direction.get_opIndex(0), -1, -direction.get_opIndex(2));

		float spread = 1.0;


		//checking all factions
		for (int f = 0; f < 6; ++f){
			// only affect enemy faction
			if (f!= factionId){
				//custom query, collects all soldiers of a faction near target position
				array<const XmlElement@>@ soldiers = getCharactersNearPosition(m_metagame, targetPos, f, 30.0f);				
				// for (uint i = 0; i < soldiers.length(); ++i) {
				int s_size = soldiers.length();
				if (s_size == 0) continue;
				int s_i = rand(0,soldiers.length()-1);
				int soldier_id = soldiers[s_i].getIntAttribute("id");


				if (soldier_id >= 0){
					const XmlElement@ characterInfo = getCharacterInfo(m_metagame, soldier_id);
					if(characterInfo is null) continue;
					Vector3 soldier_pos = stringToVector3(characterInfo.getStringAttribute("position"));
					P2PAttack(heliPos, soldier_pos, number, instanceKey, soundFile, spread, factionId, characterId);
				}
			}
		}
	}

	void P2PAttack(Vector3 weaponPos, Vector3 targetPos, int number, string instanceKey, string soundFile, float spread, int factionId, int characterId) {

		// aim
		Vector3 projectileSpeed = targetPos.subtract(weaponPos).scale(2.0/40.0);
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

	bool hasEnded() const {
		// always on
		return false;
	}

	// --------------------------------------------
	bool hasStarted() const {
		//timer on/off
		return m_running;
	}
}
