#include "tracker.as"
#include "helpers.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"

/*
credits:
original idea and script - DoomMetal
polishing, timer, markers, shadow - Unit G17
*/

//when an A10_2 gun run is requested, the caller's id, the call's position and id, the strike's direction and the marker vehicle's id are stored
class A10_2Request {
	int m_characterId;
	Vector3 m_targetPos;
	int m_direction;
	int m_callId;
	int m_factionId;
	
	A10_2Request(int characterId, Vector3 targetPos, int direction, int callId, int factionId){
		m_characterId = characterId;
		m_targetPos = targetPos;
		m_direction = direction;
		m_callId = callId;
		m_factionId = factionId;
	}
}

class A10_2GunRun : Tracker {


	protected Metagame@ m_metagame;
	protected float m_timer;
	protected bool m_running = false;
	protected array<A10_2Request@> A10_2Queue;
	protected bool m_shadow = false;
	protected float m_pi = acos(-1.0f);

	A10_2GunRun(Metagame@ metagame) {
		@m_metagame = @metagame;
	}

	protected void handleCallEvent(const XmlElement@ event) {
	// Hey we got a call!

	// Check call key
		if (event.getStringAttribute("call_key") == "a10_gun_run_2.call") {
			string phase = event.getStringAttribute("phase");
		//during the request all necessary information gets stored about the call, except for the marker the vehicle, it's done later
			if (phase == "queue") {
				int characterId = event.getIntAttribute("character_id");
				int callId = event.getIntAttribute("id");
				int factionId = event.getIntAttribute("faction_id");

				Vector3 senderPos = stringToVector3(getCharacterInfo(m_metagame, characterId).getStringAttribute("position"));
				Vector3 targetPos = stringToVector3(event.getStringAttribute("target_position"));
				int direction = gunRunDirection(senderPos, targetPos);

				const XmlElement@ character = getCharacterInfo(m_metagame, characterId);
				if(character is null){
					direction = 0;
				}
				int playerId = character.getIntAttribute("player_id");
				const XmlElement@ player = getPlayerInfo(m_metagame, playerId);
				if(player is null){
					direction = 0;
				}else if(player.hasAttribute("aim_target")) {
					Vector3 targetPos2 = Vector3(1,1,1);
					targetPos2 = stringToVector3(player.getStringAttribute("aim_target"));
					if(targetPos2 !is null){
						direction = gunRunDirection(targetPos2, targetPos);
					}else{
						direction = 0;
					}
				}

			//determining on which direction out of the 12 the current call fits the most
				

				A10_2Request@ thisCall = A10_2Request(characterId, targetPos, direction, callId, factionId);

			//placing ground marker and flag
				addMarker(thisCall);
			//the queue is necessary to handle multiple simultaneous A10_2 requests
				A10_2Queue.insertLast(thisCall);
			}
		//this timer ensures that the sound lines up with the arrival of the projectiles
			if (phase == "launch") {
			//announcing the aircraft's arrival and direction
				dictionary dict = {{"TagName", "command"},{"class", "chat"},{"text", "Aircraft on its way, coming at " + A10_2Queue[0].m_direction + " o'clock!"},{"faction_id", 0}};
				m_metagame.getComms().send(XmlElement(dict));

			//starting timer
				m_timer = 0.1;
				m_running = true;
			}
		}
	}

	// --------------------------------------------
	void update(float time) {
		m_timer -= time;
		//once the timer ran out, the spawning process is started
		if (m_timer < 0.0) {
			if (!m_shadow) {
				//attack phase, launching the actual projectiles
				//setting timer for shadow phase, so there is a short delay after the attack phase
				m_timer = 2.0;
				m_shadow = true;
				
				//launching the projectiles and removing the markers
				gunRunLaunchProjectiles(A10_2Queue[0], 60, "30mm.projectile");
				gunRunLaunchProjectiles(A10_2Queue[0], 4, "a10_bomb.projectile");
				removeMarker(A10_2Queue[0]);
			} else {
				//shadow phase
				//stopping timer
				m_running = false;
				m_shadow = false;
				
				//spawning the plane shadow
				gunRunShadow(A10_2Queue[0]);
				
				//removing completed request
				A10_2Queue.removeAt(0);
			}
		}
	}
	
	int gunRunDirection(Vector3 senderPos, Vector3 targetPos) {
		// First we get the line from the sender to the target
		Vector3 sightLine = senderPos.subtract(targetPos);
		
		//calculating which direction it fits on the most out of the 12 possible orientations
		int direction = int( (((atan2(-sightLine.get_opIndex(2), -sightLine.get_opIndex(0))) / m_pi) * 180 + 105) / 30 );
		
		if (direction == 0) { direction = 12; }
		else if (direction == -1) { direction = 11; }
		else if (direction == -2) { direction = 10; }
		
		return direction;
	}
	
	Vector3 gunRunVector(int direction) {
		//recalculating the 3d vector from the direction data
		float angle = (float(direction) / 6) * m_pi;

		Vector3 attackVector = Vector3(sin(angle), 0, -cos(angle));
		
		return attackVector;
	}
	
	void addMarker(A10_2Request@ A10_2Request) {
	//placing the flag
		Vector3 targetPos = A10_2Request.m_targetPos;
		Vector3 direction = gunRunVector(A10_2Request.m_direction);		
		int flagId = A10_2Request.m_callId + 8000;

		XmlElement command("command");
		command.setStringAttribute("class", "set_marker");
		command.setIntAttribute("id", flagId);
		command.setIntAttribute("faction_id", A10_2Request.m_factionId);
		command.setIntAttribute("atlas_index", 4);
		command.setFloatAttribute("size", 0.5);
		command.setFloatAttribute("range", 40.0);
		command.setIntAttribute("enabled", 1);
		command.setStringAttribute("position", targetPos.toString());
		command.setStringAttribute("text", "");
		command.setStringAttribute("type_key", "call_marker_a10_" + A10_2Request.m_direction);
		command.setBoolAttribute("show_in_map_view", true);
		command.setBoolAttribute("show_in_game_view", true);
		command.setBoolAttribute("show_at_screen_edge", false);

		m_metagame.getComms().send(command);
	}

	void removeMarker(A10_2Request@ A10_2Request) {
		int flagId = A10_2Request.m_callId + 8000;

	//removing the flag
		XmlElement command("command");
		command.setStringAttribute("class", "set_marker");
		command.setIntAttribute("id", flagId);
		command.setIntAttribute("enabled", 0);
		command.setIntAttribute("faction_id", 0);
		m_metagame.getComms().send(command);
	}

	void gunRunShadow(A10_2Request@ A10_2Request) {
	//extracting data
		int characterId = A10_2Request.m_characterId;
		Vector3 targetPos = A10_2Request.m_targetPos;
		Vector3 direction = gunRunVector(A10_2Request.m_direction);

	//calculating the shadow projectile's starting position and speed
		Vector3 shadowPos = targetPos.subtract(direction.scale(-40));
		shadowPos.m_values[1] += 10.0;
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

	void gunRunLaunchProjectiles(A10_2Request@ A10_2Request, int number, string instanceKey) {
	// Now we find the line perpendicular to caller-target

	//extracting data
		int characterId = A10_2Request.m_characterId;
		Vector3 targetPos = A10_2Request.m_targetPos;
		Vector3 direction = gunRunVector(A10_2Request.m_direction);

	//projectile speed has been calibrated for 40 horizontal, 40 vertical spawn offset
		Vector3 projectileSpeed = Vector3(-direction.get_opIndex(0)*2, -1*2, -direction.get_opIndex(2)*2);

	// Loop and spawn instances
		for (int i = 0; i < number; i++) {
	// This is used to scale the positions around the center
			int j = i - (number-1)/2;



			float distance = 10.0;
      		for (int k = 0; k <= 0; k++) {
				Vector3 newPos = targetPos.subtract(direction.scale((j * 0.8) - 40));

				if (j / 5 * 5 - j == 0) { 
				XmlElement command("command");
				command.setStringAttribute("class", "play_sound");
				command.setStringAttribute("filename", "a10_30mm.wav");
				command.setStringAttribute("position", newPos.toString());
				m_metagame.getComms().send(command);
				}
		// Insert the new height, scales with the loop index
		// Also randomize the positions a tiny bit
				float randx = rand(-3.5f, 3.5f);
				float randz = rand(-3.5f, 3.5f);
				newPos.set(newPos.get_opIndex(0) + randx, newPos.get_opIndex(1) + 40.0, newPos.get_opIndex(2) + randz);
				newPos = newPos.add(Vector3(  direction.get_opIndex(2) * distance * k  ,  0,   - direction.get_opIndex(0) * distance *k) );

		// And finally, spawn the thing in!
				string c = 
				"<command class='create_instance'" +
				" faction_id='0'" +
				" instance_class='grenade'" +
				" instance_key='" + instanceKey + "'" +
				" position='" + newPos.toString() + "'" +
				" character_id='" + characterId + "'" +
				" offset='" + projectileSpeed.toString() + "' />";
				m_metagame.getComms().send(c);
			}
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
