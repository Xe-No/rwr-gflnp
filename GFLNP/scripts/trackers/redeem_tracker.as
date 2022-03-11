// internal
#include "tracker.as"
#include "log.as"
#include "helpers.as"
#include "query_helpers.as"
#include "xe_helpers.as"

// --------------------------------------------
class RedeemTracker : Tracker {
	protected Metagame@ m_metagame;

	protected string rewardFileName = "reward_list.xml";
	// --------------------------------------------
	RedeemTracker(Metagame@ metagame) {
		@m_metagame = metagame;
	}
	
	protected void handleChatEvent(const XmlElement@ event) {
		string message = event.getStringAttribute("message");
		if (!startsWith(message, "/")) {
			return;
		}
		string sender = event.getStringAttribute("player_name");
		int senderId = event.getIntAttribute("player_id");


		if (checkCommand(message, "redeem")) {
			handleRewardFromXML(senderId, sender);
		}


		// admin only from here on
		if (!m_metagame.getAdminManager().isAdmin(sender, senderId)) {
			return;
		}
			
	}
	

	protected void handlePlayerConnectEvent(const XmlElement@ event) {
		
		const XmlElement@ player = event.getFirstElementByTagName("player");
		if (player !is null) {
			string playerName = player.getStringAttribute("name");
			int playerId = player.getIntAttribute("player_id");
			handleRewardFromXML(playerId, playerName);
		}
	}


	protected void handleRewardFromXML(int pid, string pname) {
		array<string> name_list =  loadStringsFromFile(m_metagame, rewardFileName, "reward", "name");
		array<string> rp_list =  loadStringsFromFile(m_metagame, rewardFileName, "reward", "rp");
		for (uint i = 0; i < name_list.size(); ++i) {
			if (pname == name_list[i]) {
				rewardPlayerById(pid, rp_list[i]);
				removeTagFromXML(m_metagame, rewardFileName, "reward", i );
				break;
			}
		}
	}


	void rewardPlayerById(int playerId, string rp){
		const XmlElement@ info = getPlayerInfo(m_metagame, playerId);
		if (info !is null) {
			int id = info.getIntAttribute("character_id");
			// string command =
			// 	"<command class='rp_reward'" +
			// 	"	character_id='" + id + "'" +
			// 	"	reward='" + rp + "'>" + // multiplier affected..
			// 	"</command>";
			// m_metagame.getComms().send(command);

			XmlElement c("command");
				c.setStringAttribute("class", "rp_reward");
				c.setIntAttribute("character_id", id); 
				c.setStringAttribute("reward", rp); 
			m_metagame.getComms().send(c);


			
			// sendPrivateMessage(m_metagame, id, rp);
			string text = "Reward: " + rp + " RP!!";
			notify(m_metagame, "" , dictionary(), "misc", playerId, true, text, 1.0);
			sendPrivateMessage(m_metagame, playerId, text);
		}
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
};


