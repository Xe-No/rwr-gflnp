#include "tracker.as"
#include "helpers.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"

/*
credits:
adapted by Xe-No from ac130x_gun_run.as
*/

//when an Ya401 gun run is requested, the caller's id, the call's position and id, the strike's direction and the marker vehicle's id are stored
class Ya401Request {
	int m_characterId;
	Vector3 m_targetPos;
	Vector3 m_Ya401Pos;
	int m_direction;
	int m_callId;
	int m_factionId;

	Ya401Request(int characterId, Vector3 targetPos, Vector3 Ya401Pos, int direction, int callId, int factionId){
		m_characterId = characterId;
		m_targetPos = targetPos;
		m_Ya401Pos = Ya401Pos;
		m_direction = direction;
		m_callId = callId;
		m_factionId = factionId;
	}
}

class Ya401GunRun : Tracker {
	protected Metagame@ m_metagame;
	protected float m_timer;
	protected float m_timer_attack = 0.0;
	protected float m_timer_scan = 0.0;
	protected float m_timer_a1 = 0.0;
	protected float m_timer_a2 = 0.0;
	protected float m_timer_a3 = 0.0;
	protected float m_timer_main = 0.0;
	protected Vector3 m_Ya401_pos;



	protected bool m_running = false;
	protected array<Ya401Request@> Ya401Queue;
	protected bool m_shadow = false;
	protected float m_pi = acos(-1.0f);


	Ya401GunRun(Metagame@ metagame) {
		@m_metagame = @metagame;
	}

	protected void handleCallEvent(const XmlElement@ event) {
		// Hey we got a call!

		// Check call key
		if (event.getStringAttribute("call_key") == "401_yamato.call") {
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
				Vector3 Ya401Pos = senderPos.add(Vector3(0, 70, 0));

				Ya401Request@ thisCall = Ya401Request(characterId, targetPos, Ya401Pos, direction, callId, factionId);

				//placing ground marker and flag
				//addMarker(thisCall);
				//the queue is necessary to handle multiple simultaneous Ya401 requests
				Ya401Queue.insertLast(thisCall);
			}
			//this timer ensures that the sound lines up with the arrival of the projectiles
			if (phase == "launch") {
				//announcing the aircraft's arrival and direction
				dictionary dict = {{"TagName", "command"},{"class", "chat"},{"text", "Aircraft on its way, coming at " + Ya401Queue[0].m_direction + " o'clock!"},{"faction_id", 0}};
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
				m_timer = 2.0;
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
				m_timer_a1 -= time;
				m_timer_a2 -= time;
				m_timer_a3 -= time;
				m_timer_main -= time;

				if (m_timer_a1 <= 0.0){
					antiPerson(Ya401Queue[0], 1, "401_yamato_cannon.projectile", "401_yamato_shot.wav");
					m_timer_a1 = 0.8;
				}

				if (m_timer_a2 <= 0.0){
					antiPerson(Ya401Queue[0], 1, "401_yamato_cannon.projectile", "401_yamato_shot.wav");
					m_timer_a2= 0.8;
				}
				if (m_timer_a3 <= 0.0){
					antiPerson(Ya401Queue[0], 1, "401_yamato_cannon.projectile", "401_yamato_shot.wav");
					m_timer_a2= 0.8;
				}

				if (m_timer_main <= 0.0){
					antiPerson(Ya401Queue[0], 1, "401_yamato_cannon_larger.projectile", "401_yamato_shot_large.wav");
					m_timer_main = 15.8;
				}
				//removeMarker(Ya401Queue[0]);

			} 
			else {
				//shadow phase
				//stopping timer
				m_running = false;
				m_shadow = false;
				m_timer_attack = 0.0;
				m_timer_scan = 0.0;
				m_timer_a1 = 0.0;
				m_timer_a2 = 0.0;
				m_timer_a3 = 0.0;
				m_timer_main = 0.0;


				//removing completed request
				Ya401Queue.removeAt(0);
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

	void addMarker(Ya401Request@ Ya401Request) {
		//placing the flag
		Vector3 targetPos = Ya401Request.m_targetPos;
		int characterId = Ya401Request.m_characterId;
		Vector3 direction = gunRunVector(Ya401Request.m_direction);		
		int flagId = Ya401Request.m_callId + 8000;

		XmlElement command("command");
		command.setStringAttribute("class", "set_marker");
		command.setIntAttribute("id", flagId);
		command.setIntAttribute("faction_id", Ya401Request.m_factionId);
		command.setIntAttribute("atlas_index", 3);
		command.setFloatAttribute("size", 0.5);
		command.setFloatAttribute("range", 150.0);
		command.setIntAttribute("enabled", 1);
		command.setStringAttribute("position", targetPos.toString());
		command.setStringAttribute("text", "");
		command.setStringAttribute("type_key", "call_marker_a10_" + Ya401Request.m_direction);
		command.setStringAttribute("type_key", "call_marker_gunship");
		command.setBoolAttribute("show_in_map_view", true);
		command.setBoolAttribute("show_in_game_view", true);
		command.setBoolAttribute("show_at_screen_edge", false);
		m_metagame.getComms().send(command);




	}



	void removeMarker(Ya401Request@ Ya401Request) {
		int flagId = Ya401Request.m_callId + 8000;

		//removing the flag
		XmlElement command("command");
		command.setStringAttribute("class", "set_marker");
		command.setIntAttribute("id", flagId);
		command.setIntAttribute("enabled", 0);
		command.setIntAttribute("faction_id", 0);
		m_metagame.getComms().send(command);
	}

	void gunRunShadow(Ya401Request@ Ya401Request) {
		//extracting data
		int characterId = Ya401Request.m_characterId;
		Vector3 targetPos = Ya401Request.m_targetPos;
		Vector3 direction = gunRunVector(Ya401Request.m_direction);

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

	void antiPerson(Ya401Request@ Ya401Request, int number, string instanceKey, string soundFile) {
		// Now we find the line perpendicular to caller-target

		//extracting data
		int characterId = Ya401Request.m_characterId;
		int factionId = Ya401Request.m_factionId;
		float spread = 2.0;
		Vector3 targetPos = Ya401Request.m_targetPos;
		Vector3 direction = gunRunVector(Ya401Request.m_direction);
		Vector3 Ya401Pos = Ya401Request.m_Ya401Pos;
		//projectile speed has been calibrated for 40 horizontal, 40 vertical spawn offset
		Vector3 projectileSpeed = Vector3(-direction.get_opIndex(0), -1, -direction.get_opIndex(2));




		//checking all factions
		for (int f = 0; f < 6; ++f){
			// only affect enemy faction
			if (f!= factionId){
				//custom query, collects all soldiers of a faction near target position
				array<const XmlElement@>@ soldiers = getCharactersNearPosition(m_metagame, targetPos, f, 76.0f);				
				// for (uint i = 0; i < soldiers.length(); ++i) {
					int s_size = soldiers.length();
					if (s_size == 0) continue;
					int s_i = rand(0,soldiers.length()-1);
					int soldier_id = soldiers[s_i].getIntAttribute("id");

					Vector3 soldier_pos = stringToVector3(getCharacterInfo(m_metagame, soldier_id).getStringAttribute("position"));
					P2PAttack(Ya401Pos, soldier_pos, number, instanceKey, soundFile, spread, factionId, characterId);
					// }
				}
			}
		}
	
	void P2PAttack(Vector3 weaponPos, Vector3 targetPos, int number, string instanceKey, string soundFile, float spread, int factionId, int characterId) {

		// aim
		Vector3 projectileSpeed = targetPos.subtract(weaponPos).scale(1.0/60.0);
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
