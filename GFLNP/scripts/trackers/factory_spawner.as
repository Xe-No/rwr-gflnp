// internal
#include "gamemode.as"
#include "tracker.as"
#include "log.as"
#include "query_helpers.as"

// --------------------------------------------
class FactorySpawner : Tracker {
	protected GameMode@ m_metagame;

	protected float m_spawn_interval;
	protected float m_timer;


	// --------------------------------------------
	FactorySpawner(GameMode@ metagame, float time = 1000010.0) {
		@m_metagame = @metagame;

		m_spawn_interval = time;
		m_timer = m_spawn_interval;
	}
	
	// --------------------------------------------
	void update(float time) {
		m_timer -= time;
		if (m_timer < 0.0) {
			refresh();
			m_timer = m_spawn_interval;
		}
	}

	// --------------------------------------------
	bool hasEnded() const {
		// always on
		return false;
	}

	// --------------------------------------------
	bool hasStarted() const {
		// always on
		return true;
	}

	// --------------------------------------------
	protected void refresh() {
		_log("refresh");
		// todo optimize inner loop
		for (uint f = 0; f < 4; ++f){
			// const XmlElement@ fInfo = getFactionInfo(m_metagame, f);
			// if (fInfo !is null) {

				// string fName = fInfo.getStringAttribute("name");
				// if (fName != "KCCO"){
				// 	// _log("not KCCO");
				// 	continue;
				// } 

			
			array<const XmlElement@>@ vehicles = getVehicles(m_metagame, f, "reconhub.vehicle");
			_log("factory checked");
			for (uint j = 0; j < vehicles.length(); ++j){
				string position = vehicles[j].getStringAttribute("position");
				Vector3 pos = stringToVector3(position);
				// pos.m_values[2] -= 5.0;
				int choice = rand(0, 2);
				string c = "";
				if (choice == 0){
					c = "<command class='create_instance' instance_class='character' instance_key='dactyl' position='" + pos.toString() + "' faction_id='" + f + "' activated='0' />";
				} 
				else{
					c = "<command class='create_instance' instance_class='character' instance_key='pathfinder' position='" + pos.toString() + "' faction_id='" + f + "' activated='0' />";
				}
				
				m_metagame.getComms().send(c);
				// }
			}
		}
	}
}
