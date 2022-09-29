#include "tracker.as"
#include "gamemode.as"
#include "query_helpers.as"
#include "gift_item_delivery_rewarder.as"
#include "enemy_drop.as"
#include "helpers.as"
// #include "basic_command_handler.as"

//Author: Xe-No

// --------------------------------------------
class DropOnKill : Tracker {
	protected Metagame@ m_metagame;

	// --------------------------------------------
	DropOnKill(Metagame@ metagame) {
		@m_metagame = @metagame;

		m_metagame.getComms().send("<command class='set_metagame_event' name='character_kill' enabled='1' />");
	}
	
	// --------------------------------------------
	protected void handleCharacterKillEvent(const XmlElement@ event) {
		const XmlElement@ killer = event.getFirstElementByTagName("killer");
		const XmlElement@ target = event.getFirstElementByTagName("target");
		if (killer is null || target is null) return;

		// get infos
		int k_fid = killer.getIntAttribute("faction_id");
		int t_fid = target.getIntAttribute("faction_id");
		string t_sgn = target.getStringAttribute("soldier_group_name");
		string t_pos = target.getStringAttribute("position");
		// drop from 0 killing none-0
		if (k_fid !=0 || t_fid ==0) return;		


		if (!enemy_drop.exists(t_sgn)) t_sgn = '';

		array<const XmlElement@>@ players = getPlayers(m_metagame);
		int player_count = players.size();
		float dynamic_factor = (1.0 + 7.0 ) / (float(player_count) + 7.0);
		if(player_count > 8){
			dynamic_factor = 9.0 / ((float(player_count) - 9)/2 + 18.0);
		}
		if (t_sgn == '') dynamic_factor = 1.0;
		ScoredResource@ r = cast<ScoredResource> (enemy_drop[t_sgn]);


		if ( rand(0.0,1.0) < r.m_score * dynamic_factor ){
			spawnInstance(m_metagame, r.m_type, r.m_key, t_pos, 0);
		}
	}


	protected void handleChatEvent(const XmlElement@ event) {
		string message = event.getStringAttribute("message");
		// for the most part, chat events aren't commands, so check that first 
		if (!startsWith(message, "/")) {
			return;
		}

		int sender_pid = event.getIntAttribute("player_id");
		string sender_name = event.getStringAttribute("player_name");

		if (!m_metagame.getAdminManager().isAdmin(sender_name, sender_pid)) return;
		
		const XmlElement@ info = getPlayerInfo(m_metagame, sender_pid);
		if (info is null) return;
		int cid = info.getIntAttribute("character_id");

		// test drop
		array<string> paras = parseParameters2(message, " ", -1);

		// if (checkCommand(message, "td")) {
		if (matchString(paras[0], "td")) {
			string group = paras[1];
			int num = parseInt(paras[2]);
			// _log(type(enemy_drop['aa02s']));
			if (!enemy_drop.exists(group)) group = '';
			ScoredResource@ r = cast<ScoredResource> (enemy_drop[group]);
			for (int i=0; i<num; ++i){
				if ( rand(0.0,1.0) < r.m_score ){
					// spawnInstanceNearPlayer(m_metagame, sender_pid, r.m_key, r.m_type);
					addItemInBackpack(m_metagame, cid, Resource(r.m_key, r.m_type));
				}
			}
			
		}

	}



}
