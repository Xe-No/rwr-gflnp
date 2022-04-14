#include "tracker.as"
#include "helpers.as"
#include "admin_manager.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"

//Author: Unit G17
//Changed something for MOD

class empgVehicle {
	int m_id = -1;
	//duration of the emp effect
	float m_timer = 5.0;
	
	empgVehicle(int id){
		m_id = id;
	}
}

	// --------------------------------------------
class EmpG : Tracker {
	protected Metagame@ m_metagame;
	protected array<empgVehicle@> empList;

	// --------------------------------------------
	EmpG(Metagame@ metagame) {
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

	protected	float xpReward = 0.005;
	protected	uint rpReward = 150;

	// --------------------------------------------
	protected void handleResultEvent(const XmlElement@ event) {
		//emp notify_script key
		string empKey = "emp_g";
		int empId = event.getIntAttribute("character_id");
		//checking if the event was triggered by an emp grenade
		string key = event.getStringAttribute("key");
		if (key == empKey) {
			//emp effect radius
			float range = 6.5;
		
			//list of vehicles NOT affected by emp
			array<string> targetKeys = {
				"deployable_gl.vehicle",
				"deployable_mg.vehicle",
				"deployable_mg_2.vehicle",
				"deployable_minig.vehicle",
				"hornet.vehicle",
				"mortar.vehicle",
				"para_spawn.vehicle",
				"tank2.vehicle"
			};
		
			Vector3 empPos = stringToVector3(event.getStringAttribute("position"));

			string c = 
				"<command class='create_instance'" +
				" instance_class='grenade'" +
				" instance_key='gw_emp_blast.projectile'" +
				" position='" + empPos.toString() + "' />";
			m_metagame.getComms().send(c);

			empVehicles(empPos, targetKeys, range);

			string command = "";
			int xrc = (1 + empList.length()) / 2;
			float xpRewardFinal = xpReward * xrc;
			float rpRewardFinal = rpReward * xrc;
			command = "<command class='xp_reward' character_id='" + empId + "' reward='" + xpRewardFinal + "' />";
			m_metagame.getComms().send(command);
			command = "<command class='rp_reward' character_id='" + empId + "' reward='" + rpRewardFinal + "' />";
			m_metagame.getComms().send(command);
		}
    }
	
	// --------------------------------------------
	void empVehicles (Vector3 empPos, array<string> targetKeys, float range) {
		//checking all factions, including neutral

		for (uint f = 0; f < 6; ++f){
			//custom query, collects all vehicles of a faction
			array<const XmlElement@>@ vehicles = getAllVehicles(m_metagame, f);
			
			for (uint i = 0; i < vehicles.length(); ++i) {
				Vector3 vehiclePos = stringToVector3(vehicles[i].getStringAttribute("position"));

				//checking first whether this vehicle is within emp range
				if (checkRange(empPos, vehiclePos, range)) {
					//getting vehicle key to see whether this vehicle is on the unaffected list
					int vehicleId = vehicles[i].getIntAttribute("id");
					const XmlElement@ vehicleInfo = getVehicleInfo(m_metagame, vehicleId);
					if (vehicleInfo !is null) {
						string vehicleKey = vehicleInfo.getStringAttribute("key");
						if (targetKeys.find(vehicleKey) == -1){
							addToEmpList (vehicleId);
						}
					}
				}
			}

		}
	}

	// --------------------------------------------
	void addToEmpList (int vehicleId) {
		//checking whether this vehicle is already on the tracked list
		for (uint i = 0; i < empList.length() ; ++i){
			if (empList[i].m_id == vehicleId){
				//resetting the timer
				empList[i].m_timer = 4.0;
				return;
			}
		}
		
		lockVehicle(m_metagame, vehicleId);
		empList.insertLast(empgVehicle(vehicleId));
	}
	
	// --------------------------------------------
	void update(float time) {
		//updating the timer on all tracked vehicles
		for (uint i = 0; i < empList.length() ; ++i) {		
			empList[i].m_timer -= time;
			
			if (empList[i].m_timer < 0){
				unlockVehicle(m_metagame, empList[i].m_id);
				
				empList.removeAt(i);
				--i;
			}
		}
	}
}