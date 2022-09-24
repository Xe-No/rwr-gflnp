#include "tracker.as"
#include "helpers.as"
#include "admin_manager.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"
#include "xe_helpers.as"


//Author: Xe-No
class LootTrigger : Tracker {
	protected Metagame@ m_metagame;
	LootTrigger(Metagame@ metagame) {
		@m_metagame = @metagame;
	}

	// --------------------------------------------
	bool hasEnded() const {
		return false;
	}

	// --------------------------------------------
	bool hasStarted() const {
		return true;
	}

	protected void handleResultEvent(const XmlElement@ event) {
		
		//check key, return item
		dictionary dict_loot = {
			{'loot1', 'loot1.carry_item'},
			{'loot2', 'loot2.carry_item'},
			{'loot3', 'loot3.carry_item'}
		};

		//notify_script key, pass unwanted
		string key = event.getStringAttribute("key");
		if ( !dict_loot.exists(key) ) return;
		string loot_item = string(dict_loot[key]);
		string loot_type = "carry_item";

		Vector3 position = stringToVector3(event.getStringAttribute("position"));
		array<const XmlElement@>@ players = getPlayers(m_metagame);
		array<const XmlElement@>@ characters = getCharactersNearPosition(m_metagame, position, 0, 40.0);
		array<int> player_cids;
		array<int> near_cids;

		//check players, nearby characters, get intersection, reward
		for (uint i = 0; i < players.size(); ++i) {
			player_cids.insertLast(players[i].getIntAttribute('character_id')) ;
		}
		for (uint i = 0; i < characters.size(); ++i) {
			near_cids.insertLast(characters[i].getIntAttribute('id')) ;
		}
		array<int> cids = getCommonElement(player_cids, near_cids);
		_log('P|N|C:'+ player_cids.size()+' ' + near_cids.size() + ' ' + cids.size());

		for (uint i = 0; i < cids.size(); ++i) {
			int cid = cids[i];
			addItemInBackpack(m_metagame, cid, Resource(loot_item, loot_type));
		}
	}
}

