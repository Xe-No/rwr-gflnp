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

//when an F16 gun run is requested, the caller's id, the call's position and id, the strike's direction and the marker vehicle's id are stored
class F16Request {
	int m_characterId;
	Vector3 m_targetPos;
	int m_direction;
	int m_callId;
	int m_factionId;
	
	F16Request(int characterId, Vector3 targetPos, int direction, int callId, int factionId){
		m_characterId = characterId;
		m_targetPos = targetPos;
		m_direction = direction;
		m_callId = callId;
		m_factionId = factionId;
	}
}

class F16GunRun : Tracker {
  protected Metagame@ m_metagame;
  protected float m_timer;
  protected bool m_running = false;
  protected array<F16Request@> F16Queue;
  protected bool m_shadow = false;
  protected float m_pi = acos(-1.0f);

  F16GunRun(Metagame@ metagame) {
    @m_metagame = @metagame;
  }

  protected void handleCallEvent(const XmlElement@ event) {
    // Hey we got a call!

    // Check call key
    if (event.getStringAttribute("call_key") == "f16_missle_run.call") {
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

			F16Request@ thisCall = F16Request(characterId, targetPos, direction, callId, factionId);
			
			//placing ground marker and flag
			addMarker(thisCall);
			//the queue is necessary to handle multiple simultaneous F16 requests
			F16Queue.insertLast(thisCall);
		}
		//this timer ensures that the sound lines up with the arrival of the projectiles
		if (phase == "launch") {
			//announcing the aircraft's arrival and direction
			dictionary dict = {{"TagName", "command"},{"class", "chat"},{"text", "Aircraft on its way, coming at " + F16Queue[0].m_direction + " o'clock!"},{"faction_id", 0}};
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
			if (!m_shadow) {
				//attack phase, launching the actual projectiles
				//setting timer for shadow phase, so there is a short delay after the attack phase
				m_timer = 2.0;
				m_shadow = true;
				
				//launching the projectiles and removing the markers
				gunRunLaunchProjectiles(F16Queue[0], 8, "f16_missle.projectile", "f16_missle.wav");
				removeMarker(F16Queue[0]);
			} else {
				//shadow phase
				//stopping timer
				m_running = false;
				m_shadow = false;
				
				// //spawning the plane shadow
				// gunRunShadow(F16Queue[0]);
				
				//removing completed request
				F16Queue.removeAt(0);
			}
		}
	}
  
  	int gunRunDirection(Vector3 senderPos, Vector3 targetPos) {
		// First we get the line from the sender to the target
		Vector3 sightLine = senderPos.subtract(targetPos);
		
		//calculating which direction it fits on the most out of the 12 possible orientations
		int direction = int( (((atan2(-sightLine.get_opIndex(2), -sightLine.get_opIndex(0))) / m_pi) * 180 + 195) / 30 );
		
		if (direction == 0) { direction = 12; }
		
		return direction;
	}
	
	Vector3 gunRunVector(int direction) {
		//recalculating the 3d vector from the direction data
		float angle = (float(direction) / 6) * m_pi;
				
		Vector3 attackVector = Vector3(sin(angle), 0, -cos(angle));
				
		return attackVector;
	}
  
  void addMarker(F16Request@ F16Request) {
	//placing the flag  
	Vector3 targetPos = F16Request.m_targetPos;
	Vector3 direction = gunRunVector(F16Request.m_direction);		
	int flagId = F16Request.m_callId + 8000;
		
	XmlElement command("command");
		command.setStringAttribute("class", "set_marker");
		command.setIntAttribute("id", flagId);
		command.setIntAttribute("faction_id", F16Request.m_factionId);
		command.setIntAttribute("atlas_index", 7);
		command.setFloatAttribute("size", 0.5);
		command.setFloatAttribute("range", 35.0);
		command.setIntAttribute("enabled", 1);
		command.setStringAttribute("position", targetPos.toString());
		command.setStringAttribute("text", "");
		command.setStringAttribute("type_key", "call_marker_a10_" + F16Request.m_direction);
		command.setBoolAttribute("show_in_map_view", true);
		command.setBoolAttribute("show_in_game_view", true);
		command.setBoolAttribute("show_at_screen_edge", false);
		
	m_metagame.getComms().send(command);
  }
  
  void removeMarker(F16Request@ F16Request) {
	int flagId = F16Request.m_callId + 8000;
	
	//removing the flag
	XmlElement command("command");
		command.setStringAttribute("class", "set_marker");
		command.setIntAttribute("id", flagId);
		command.setIntAttribute("enabled", 0);
		command.setIntAttribute("faction_id", 0);
	m_metagame.getComms().send(command);
  }
  
  void gunRunShadow(F16Request@ F16Request) {
	//extracting data
	int characterId = F16Request.m_characterId;
	Vector3 targetPos = F16Request.m_targetPos;
	Vector3 direction = gunRunVector(F16Request.m_direction);
	
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
  
  void gunRunLaunchProjectiles(F16Request@ F16Request, int number, string instanceKey, string soundFile) {
    // Now we find the line perpendicular to caller-target

	//extracting data
	int characterId = F16Request.m_characterId;
	Vector3 targetPos = F16Request.m_targetPos;
	Vector3 direction = gunRunVector(F16Request.m_direction);
	
	//projectile speed has been calibrated for 40 horizontal, 40 vertical spawn offset
	Vector3 projectileSpeed = Vector3(-direction.get_opIndex(0), -1, -direction.get_opIndex(2));

    // Loop and spawn instances
    for (int i = 0; i < number; i++) {

      // This is used to scale the positions around the center
      int j = i - (number-1)/2;
      Vector3 newPos = targetPos.subtract(direction.scale((j * 2) - 40));

      // Insert the new height, scales with the loop index
      // Also randomize the positions a tiny bit
      float randx = rand(-2.0f, 2.0f);
      float randz = rand(-2.0f, 2.0f);
      newPos.set(newPos.get_opIndex(0) + randx, newPos.get_opIndex(1) + 40.0, newPos.get_opIndex(2) + randz);


		XmlElement command("command");
			command.setStringAttribute("class", "play_sound");
			command.setStringAttribute("filename", soundFile);
			command.setStringAttribute("position", newPos.toString());
		m_metagame.getComms().send(command);


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
