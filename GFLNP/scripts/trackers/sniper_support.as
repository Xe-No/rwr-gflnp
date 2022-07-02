#include "tracker.as"
#include "helpers.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"

/*
credits:
adapted by Xe-No from a10_gun_run.as
*/

//when an Snip gun run is requested, the caller's id, the call's position and id, the strike's direction and the marker vehicle's id are stored
class SnipRequest {
	int m_characterId;
	Vector3 m_targetPos;
	Vector3 m_snipPos;
	int m_direction;
	int m_callId;
	int m_factionId;

	SnipRequest(int characterId, Vector3 targetPos, Vector3 snipPos, int direction, int callId, int factionId){
		m_characterId = characterId;
		m_targetPos = targetPos;
		m_snipPos = snipPos;
		m_direction = direction;
		m_callId = callId;
		m_factionId = factionId;
	}
}

class SnipGunRun : Tracker {
	protected Metagame@ m_metagame;
	protected float m_timer;
	protected float m_timer_attack = 0.0;
	protected float m_timer_scan = 0.0;
	protected float m_timer_shot = 0.0;
	protected Vector3 m_snip_pos;



	protected bool m_running = false;
	protected array<SnipRequest@> SnipQueue;
	protected bool m_shadow = false;
	protected float m_pi = acos(-1.0f);


	SnipGunRun(Metagame@ metagame) {
		@m_metagame = @metagame;
	}

	protected void handleCallEvent(const XmlElement@ event) {
		// Hey we got a call!

		// Check call key
		if (event.getStringAttribute("call_key") == "sniper_call.call") {
			string phase = event.getStringAttribute("phase");
			//during the request all necessary information gets stored about the call, except for the marker the vehicle, it's done later
			if (phase == "queue") {
				int characterId = event.getIntAttribute("character_id");
				int callId = event.getIntAttribute("id");
				int factionId = event.getIntAttribute("faction_id");



				Vector3 senderPos = stringToVector3(getCharacterInfo(m_metagame, characterId).getStringAttribute("position"));
				Vector3 targetPos = stringToVector3(event.getStringAttribute("target_position"));

				//determining on which direction out of the 12 the current call fits the most
				int direction = gunRunDirection(senderPos, targetPos);
				Vector3 snipPos = senderPos.add(Vector3(0, 30, 0));

				SnipRequest@ thisCall = SnipRequest(characterId, targetPos, snipPos, direction, callId, factionId);

				//placing ground marker and flag
				//addMarker(thisCall);
				//the queue is necessary to handle multiple simultaneous Snip requests
				SnipQueue.insertLast(thisCall);
			}
			//this timer ensures that the sound lines up with the arrival of the projectiles
			if (phase == "launch") {
				//announcing the aircraft's arrival and direction
				//dictionary dict = {{"TagName", "command"},{"class", "chat"},{"text", "Sniper at " + SnipQueue[0].m_direction + " o'clock!"},{"faction_id", 0}};
				//m_metagame.getComms().send(XmlElement(dict));


				//calculating the smoke position 
				//Vector3 smokePos = targetPos;
				//smokePos.m_values[1] += 1.0;

				//string c = 
				//"<command class='create_instance'" +
				//" faction_id='0'" +
				//" instance_class='grenade'" +
				//" instance_key='strike_marker_1.projectile'" +
				//" position='" + smokePos.toString() + "'" +
				//" character_id='" + characterId + "' />";
				//m_metagame.getComms().send(c);


				//starting timer
				m_timer = 1.5;
				m_running = true;
			}
		}
	}

	// --------------------------------------------
	void update(float time) {
		m_timer -= time;
		//once the timer ran out, the spawning process is started
		if (m_timer < 0.0) {
			if (m_timer_attack < 10.0) {
				m_timer_attack += time;
				m_timer_scan -= time;
				m_timer_shot -= time;


				if (m_timer_shot <= 0.0){
					antiPerson(SnipQueue[0], 1, "sniper_call_dsr50.projectile", "gw_ax50.wav");
					m_timer_shot = 1.5;
				}

				//removeMarker(SnipQueue[0]);

			} 
			else {
				//shadow phase
				//stopping timer
				m_running = false;
				m_shadow = false;
				m_timer_attack = 0.0;
				m_timer_scan = 0.0;
				m_timer_shot = 0.0;


				//removing completed request
				SnipQueue.removeAt(0);
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

	void addMarker(SnipRequest@ SnipRequest) {
		//placing the flag
		Vector3 targetPos = SnipRequest.m_targetPos;
		int characterId = SnipRequest.m_characterId;
		Vector3 direction = gunRunVector(SnipRequest.m_direction);		
		int flagId = SnipRequest.m_callId + 8000;

		XmlElement command("command");
		command.setStringAttribute("class", "set_marker");
		command.setIntAttribute("id", flagId);
		command.setIntAttribute("faction_id", SnipRequest.m_factionId);
		command.setIntAttribute("atlas_index", 3);
		command.setFloatAttribute("size", 0.5);
		command.setFloatAttribute("range", 120.0);
		command.setIntAttribute("enabled", 1);
		command.setStringAttribute("position", targetPos.toString());
		command.setStringAttribute("text", "");
		// command.setStringAttribute("type_key", "call_marker_a10_" + SnipRequest.m_direction);
		command.setStringAttribute("type_key", "call_marker_gunship");
		command.setBoolAttribute("show_in_map_view", true);
		command.setBoolAttribute("show_in_game_view", true);
		command.setBoolAttribute("show_at_screen_edge", false);
		m_metagame.getComms().send(command);




	}



	void removeMarker(SnipRequest@ SnipRequest) {
		int flagId = SnipRequest.m_callId + 8000;

		//removing the flag
		XmlElement command("command");
		command.setStringAttribute("class", "set_marker");
		command.setIntAttribute("id", flagId);
		command.setIntAttribute("enabled", 0);
		command.setIntAttribute("faction_id", 0);
		m_metagame.getComms().send(command);
	}

	void gunRunShadow(SnipRequest@ SnipRequest) {
		//extracting data
		int characterId = SnipRequest.m_characterId;
		Vector3 targetPos = SnipRequest.m_targetPos;
		Vector3 direction = gunRunVector(SnipRequest.m_direction);

		//calculating the shadow projectile's starting position and speed
		Vector3 shadowPos = targetPos.subtract(direction.scale(-40));
		shadowPos.m_values[1] += 50.0;
		Vector3 shadowSpeed = direction.scale(-1);

		string c = 
		"<command class='create_instance'" +
		" faction_id='0'" +
		" instance_class='grenade'" +
		" instance_key='a10_warthog_shadow.projectile'" +
		" position='" + shadowPos.toString() + "'" +
		" character_id='" + characterId + "'" +
		" offset='" + shadowSpeed.toString() + "' />";
		m_metagame.getComms().send(c);
	}

	void antiPerson(SnipRequest@ SnipRequest, int number, string instanceKey, string soundFile) {
		// Now we find the line perpendicular to caller-target

		//extracting data
		int characterId = SnipRequest.m_characterId;
		int factionId = SnipRequest.m_factionId;
		float spread = 0.01;
		Vector3 targetPos = SnipRequest.m_targetPos;
		Vector3 direction = gunRunVector(SnipRequest.m_direction);
		Vector3 snipPos = SnipRequest.m_snipPos;
		//projectile speed has been calibrated for 40 horizontal, 40 vertical spawn offset
		Vector3 projectileSpeed = Vector3(-direction.get_opIndex(0), -1, -direction.get_opIndex(2));




		//checking all factions
		for (int f = 0; f < 6; ++f){
			// only affect enemy faction
			if (f!= factionId){
				//custom query, collects all soldiers of a faction near target position
				array<const XmlElement@>@ soldiers = getCharactersNearPosition(m_metagame, targetPos, f, 25.0f);				
				// for (uint i = 0; i < soldiers.length(); ++i) {
					int s_size = soldiers.length();
					if (s_size == 0) continue;
					int s_i = rand(0,soldiers.length()-1);
					int soldier_id = soldiers[s_i].getIntAttribute("id");

					Vector3 soldier_pos = stringToVector3(getCharacterInfo(m_metagame, soldier_id).getStringAttribute("position"));
					P2PAttack(snipPos, soldier_pos, number, instanceKey, soundFile, spread, factionId, characterId);
					// }
				}
			}
		}

	void P2PAttack(Vector3 weaponPos, Vector3 targetPos, int number, string instanceKey, string soundFile, float spread, int factionId, int characterId) {

		// aim
		Vector3 projectileSpeed = targetPos.subtract(weaponPos).scale(10.0/40.0);
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
