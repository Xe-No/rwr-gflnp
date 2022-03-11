// internal
#include "tracker.as"
#include "log.as"
#include "helpers.as"
#include "query_helpers.as"
#include "generic_call_task.as"
#include "task_sequencer.as"

// --------------------------------------------
class LogManager : Tracker {
	protected Metagame@ m_metagame;

	protected string m_rewardFilename = "rewardlist.xml"; 
	protected array<string> m_rewardNameList;
	protected array<string> m_rewardRpList;

	// --------------------------------------------
	LogManager(Metagame@ metagame) {
		@m_metagame = metagame;
		load();
	}

	// ----------------------------------------------------
	protected void handlePlayerConnectEvent(const XmlElement@ event) {
		// if the connecting player is among the persistently stored tracked players
		// get his tracking or penalty up and running

		const XmlElement@ player = event.getFirstElementByTagName("player");
		if (player !is null) {
			checkReward(player);
		}
	}

	// --------------------------------------------
	protected void rewardPlayer(int playerId, string textKey = "", bool showRules = true) {
		if (textKey != "") {
			notify(m_metagame, textKey, dictionary(), "misc", playerId, true, "Kicked from server", 1.0);
			if (showRules) {
				notify(m_metagame, "rules text", dictionary(), "misc", playerId, true, "Rules", 1.0, 700.0);
			}
		}
        ::kickPlayer(m_metagame, playerId);
	}

	// --------------------------------------------
	protected void load() {
		refresh();
	}

	// --------------------------------------------
	protected array<string> loadData(string filename) {
		return loadStringsFromFile(m_metagame, filename);
	}

	// --------------------------------------------
	protected void refresh() {
		m_rewardList = loadData(m_rewardFilename);


		_log("BanManager: refresh");
		_log(m_rewardNameList.size() + " rewardlist loaded");

		// get players and apply new rewards
		array<const XmlElement@> players = getPlayers(m_metagame);
		for (uint i = 0; i < players.size(); ++i) {
			const XmlElement@ player = players[i];

			int id = player.getIntAttribute("player_id");
			if (id >= 0) {
				checkReward(player);
			}
		}
	}

	// --------------------------------------------
	protected void checkReward(const XmlElement@ player) {
		string hash = player.getStringAttribute("profile_hash");
		string ip = player.getStringAttribute("ip");
		int id = player.getIntAttribute("player_id");
		string sid = player.getStringAttribute("sid");
		string name = player.getStringAttribute("name");

		if (checkRewardByName(name, id)) return;
	}

	// --------------------------------------------
	protected bool checkRewardByName(string name, int id) {
		for (uint i = 0; i < m_rewardNameList.size(); ++i) {
			string pattern = m_rewardNameList[i];

			string rp = m_rewardRpList[i];
			// TODO: not a pattern check anymore
			//if (pattern == name.toLowerCase()) {
			if (matchString(name, pattern)) {
				_log("BanManager: banned player detected, player=" + name + ", pattern " + pattern + " violated");
				rewardPlayer(id, rp, "Kicked - Username banned");
				return true;
			}
		}
		return false;
	}


    // ----------------------------------------------------
    protected void handleChatEvent(const XmlElement@ event) {
		Tracker::handleChatEvent(event);
		// player_id
		// player_name
		// message
		// global
		string message = event.getStringAttribute("message");
		// for the most part, chat events aren't commands, so check that first
		if (!startsWith(message, "/")) {
			return;
		}

		string sender = event.getStringAttribute("player_name");
		int senderId = event.getIntAttribute("player_id");
		if (!m_metagame.getAdminManager().isAdmin(sender, senderId)) {
			return;
		}

		if (checkCommand(message, "refresh_reward")) {
			refresh();
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
}

