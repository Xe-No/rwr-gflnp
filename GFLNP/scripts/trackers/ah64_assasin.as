#include "tracker.as"
#include "helpers.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"

/*
credits:
adapted by Xe-No from ac130x_gun_run.as
*/

//when an AH64 gun run is requested, the caller's id, the call's position and id, the strike's direction and the marker vehicle's id are stored
class AH64Request {
	int m_characterId;
	Vector3 m_targetPos;
	Vector3 m_AH64Pos;
	int m_direction;
	int m_callId;
	int m_factionId;

	AH64Request(int characterId, Vector3 targetPos, Vector3 AH64Pos, int direction, int callId, int factionId){
		m_characterId = characterId;
		m_targetPos = targetPos;
		m_AH64Pos = AH64Pos;
		m_direction = direction;
		m_callId = callId;
		m_factionId = factionId;
	}
}

class AH64GunRun : Tracker {
	protected Metagame@ m_metagame;
	protected float m_timer;
	protected float m_timer_attack = 0.0;
	protected float m_timer_scan = 0.0;
	protected float m_timer_25 = 0.0;
	protected float m_timer_40 = 0.0;
	protected float m_timer_105 = 0.0;
	protected Vector3 m_AH64_pos;



	protected bool m_running = false;
	protected array<AH64Request@> AH64Queue;
	protected bool m_shadow = false;
	protected float m_pi = acos(-1.0f);


	AH64GunRun(Metagame@ metagame) {
		@m_metagame = @metagame;
	}

	protected void handleCallEvent(const XmlElement@ event) {
		// Hey we got a call!

		// Check call key
		if (event.getStringAttribute("call_key") == "ah64_assasin.call") {
			string phase = event.getStringAttribute("phase");
			int characterId = event.getIntAttribute("character_id");
			if (characterId < 0 ) return;
			//during the request all necessary information gets stored about the call, except for the marker the vehicle, it's done later
			if (phase == "queue") {
				
				int callId = event.getIntAttribute("id");
				int factionId = event.getIntAttribute("faction_id");

				Vector3 senderPos = stringToVector3(event.getStringAttribute("target_position"));
				Vector3 targetPos = stringToVector3(event.getStringAttribute("target_position"));

				const XmlElement@ character = getCharacterInfo(m_metagame, characterId);
				int playerId = character.getIntAttribute("player_id");
				const XmlElement@ player = getPlayerInfo(m_metagame, playerId);
				if(player !is null){
				senderPos = stringToVector3(getCharacterInfo(m_metagame, characterId).getStringAttribute("position"));
				};
				//determining on which direction out of the 12 the current call fits the most
				int direction = gunRunDirection(senderPos, targetPos);
				Vector3 AH64Pos = senderPos.add(Vector3(0, 50, 0));

				AH64Request@ thisCall = AH64Request(characterId, targetPos, AH64Pos, direction, callId, factionId);

				//placing ground marker and flag
				//addMarker(thisCall);
				//the queue is necessary to handle multiple simultaneous AH64 requests
				AH64Queue.insertLast(thisCall);
			}
			//this timer ensures that the sound lines up with the arrival of the projectiles
			if (phase == "launch") {
				//announcing the aircraft's arrival and direction
				dictionary dict = {{"TagName", "command"},{"class", "chat"},{"text", "Aircraft on its way, coming at " + AH64Queue[0].m_direction + " o'clock!"},{"faction_id", 0}};
				m_metagame.getComms().send(XmlElement(dict));


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
				m_timer = 5.0;
				m_running = true;
			}
		}
	}

	// --------------------------------------------
	void update(float time) {
		m_timer -= time;
		//once the timer ran out, the spawning process is started
		if (m_timer < 0.0) {
			
			if (m_timer_attack < 16.0) {
				m_timer_attack += time;
				m_timer_scan -= time;
				m_timer_25 -= time;
				m_timer_40 -= time;
				m_timer_105 -= time;

				if (m_timer_25 <= 0.0){
					antiPerson(AH64Queue[0], 2, "ac130_40mm.projectile", "ah64_cannon.wav");
					m_timer_25 = 2.0;
				}

				if (m_timer_40 <= 0.0){
					antiPerson(AH64Queue[0], 2, "ac130_40mm.projectile", "ah64_cannon.wav");
					m_timer_40 = 2.0;
				}

				if (m_timer_105 <= 0.0){
					antiPerson(AH64Queue[0], 1, "tracer_missile.projectile", "ah64_hellfire.wav");
					m_timer_105 = 10.0;
				}
				//removeMarker(AH64Queue[0]);

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
				AH64Queue.removeAt(0);
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

	void addMarker(AH64Request@ AH64Request) {
		//placing the flag
		Vector3 targetPos = AH64Request.m_targetPos;
		int characterId = AH64Request.m_characterId;
		Vector3 direction = gunRunVector(AH64Request.m_direction);		
		int flagId = AH64Request.m_callId + 8000;

		XmlElement command("command");
		command.setStringAttribute("class", "set_marker");
		command.setIntAttribute("id", flagId);
		command.setIntAttribute("faction_id", AH64Request.m_factionId);
		command.setIntAttribute("atlas_index", 3);
		command.setFloatAttribute("size", 0.5);
		command.setFloatAttribute("range", 150.0);
		command.setIntAttribute("enabled", 1);
		command.setStringAttribute("position", targetPos.toString());
		command.setStringAttribute("text", "");
		command.setStringAttribute("type_key", "call_marker_a10_" + AH64Request.m_direction);
		command.setStringAttribute("type_key", "call_marker_gunship");
		command.setBoolAttribute("show_in_map_view", true);
		command.setBoolAttribute("show_in_game_view", true);
		command.setBoolAttribute("show_at_screen_edge", false);
		m_metagame.getComms().send(command);




	}



	void removeMarker(AH64Request@ AH64Request) {
		int flagId = AH64Request.m_callId + 8000;

		//removing the flag
		XmlElement command("command");
		command.setStringAttribute("class", "set_marker");
		command.setIntAttribute("id", flagId);
		command.setIntAttribute("enabled", 0);
		command.setIntAttribute("faction_id", 0);
		m_metagame.getComms().send(command);
	}

	void gunRunShadow(AH64Request@ AH64Request) {
		//extracting data
		int characterId = AH64Request.m_characterId;
		Vector3 targetPos = AH64Request.m_targetPos;
		Vector3 direction = gunRunVector(AH64Request.m_direction);

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

	void antiPerson(AH64Request@ AH64Request, int number, string instanceKey, string soundFile) {
		// Now we find the line perpendicular to caller-target

		//extracting data
		int characterId = AH64Request.m_characterId;
		int factionId = AH64Request.m_factionId;
		float spread = 1.5;
		Vector3 targetPos = AH64Request.m_targetPos;
		Vector3 direction = gunRunVector(AH64Request.m_direction);
		Vector3 AH64Pos = AH64Request.m_AH64Pos;
		//projectile speed has been calibrated for 40 horizontal, 40 vertical spawn offset
		Vector3 projectileSpeed = Vector3(-direction.get_opIndex(0), -1, -direction.get_opIndex(2));




		//checking all factions
		for (int f = 0; f < 6; ++f){
			// only affect enemy faction
			if (f!= factionId){
				//custom query, collects all soldiers of a faction near target position
				array<const XmlElement@>@ soldiers = getCharactersNearPosition(m_metagame, targetPos, f, 45.0f);				
				// for (uint i = 0; i < soldiers.length(); ++i) {
					int s_size = soldiers.length();
					if (s_size == 0) continue;
					int s_i = rand(0,soldiers.length()-1);
					int soldier_id = soldiers[s_i].getIntAttribute("id");

					Vector3 soldier_pos = stringToVector3(getCharacterInfo(m_metagame, soldier_id).getStringAttribute("position"));
					P2PAttack(AH64Pos, soldier_pos, number, instanceKey, soundFile, spread, factionId, characterId);
					// }
				}
			}
		}
	
	void P2PAttack(Vector3 weaponPos, Vector3 targetPos, int number, string instanceKey, string soundFile, float spread, int factionId, int characterId) {

		// aim
		Vector3 projectileSpeed = targetPos.subtract(weaponPos).scale(1.0/40.0);
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
