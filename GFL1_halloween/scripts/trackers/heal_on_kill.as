#include "tracker.as"
#include "gamemode.as"
#include "query_helpers.as"

// --------------------------------------------
class HealOnKill : Tracker {
	protected Metagame@ m_metagame;
	protected string m_factionName;

	// --------------------------------------------
	HealOnKill(Metagame@ metagame, string factionName) {
		@m_metagame = @metagame;
		m_factionName = factionName;

		m_metagame.getComms().send("<command class='set_metagame_event' name='character_kill' enabled='1' />");
	}
	
	// --------------------------------------------
	protected void handleCharacterKillEvent(const XmlElement@ event) {
		const XmlElement@ killer = event.getFirstElementByTagName("killer");
		const XmlElement@ target = event.getFirstElementByTagName("target");



		if (killer !is null && target !is null ){

			int kfi = killer.getIntAttribute("faction_id");
			const XmlElement@ kf = getFactionInfo(m_metagame, kfi);
			string kfn = kf.getStringAttribute("name");
			int tfi = target.getIntAttribute("faction_id");
			if (// only do heal for the defined faction
				kfn == m_factionName &&
				// don't heal on teamkill
				tfi != kfi) {

				int id = killer.getIntAttribute("id");
				if (id >= 0) {
					// const XmlElement@ characterInfo = getCharacterInfo(m_metagame, id);
					// Vector3 pos = stringToVector3(characterInfo.getStringAttribute("position"));
					// pos.m_values[0] += 1.0;
					Vector3 pos = stringToVector3(target.getStringAttribute("position"));

					XmlElement c("command");
					c.setStringAttribute("class", "update_inventory");
					c.setIntAttribute("character_id", id); 
					c.setIntAttribute("untransform_count", 2);
					m_metagame.getComms().send(c);

					string c3 = 
							"<command class='update_inventory' character_id='" + id + "' container_type_id='4'>" + 
								"<item class='" + "projectile" + "' key='" + "acid_bomb.projectile" + "' />" +
							"</command>";
					m_metagame.getComms().send(c3);

					
					// current soldier number
					int kfs = kf.getIntAttribute("soldiers");
					int kfc = kf.getIntAttribute("soldier_capacity");
					// spawn zombie only in
					if (kfs < kfc+50){
						string c2 = "<command class='create_instance' instance_class='" + "soldier" + "' instance_key='" + "zomberry" + "' position='" + pos.toString() + "' faction_id='" + kfi + "' />";
						m_metagame.getComms().send(c2);
						
						XmlElement command("command");
							command.setStringAttribute("class", "play_sound");
							command.setStringAttribute("filename", "zomb_infect.wav");
							command.setStringAttribute("position", pos.toString());
						m_metagame.getComms().send(command);


					}
				}
			}
		}
	}
}
