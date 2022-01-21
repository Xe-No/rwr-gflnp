// internal
#include "tracker.as"
#include "log.as"
#include "helpers.as"
#include "query_helpers.as"
#include "xe_helpers.as"

// --------------------------------------------
class ServerTracker : Tracker {
	protected Metagame@ m_metagame;

	protected string serverFile = "cn1.server";
	// --------------------------------------------
	ServerTracker(Metagame@ metagame) {
		@m_metagame = metagame;
	}
	
	protected void handleChatEvent(const XmlElement@ event) {
		string message = event.getStringAttribute("message");
		if (!startsWith(message, "/")) {
			return;
		}
		string sender = event.getStringAttribute("player_name");
		int senderId = event.getIntAttribute("player_id");

		// admin only from here on
		if (!m_metagame.getAdminManager().isAdmin(sender, senderId)) {
			return;
		}
		if (checkCommand(message, "server_check")) {
			checkServer();
		}			
	}


	protected void checkServer() {
		_log("Check Server Players");

		XmlElement@ query = XmlElement(
			makeQuery(m_metagame, array<dictionary> = {
				dictionary = { {"TagName", "data"}, {"class", "players"} } }));

		const XmlElement@ cxml = m_metagame.getComms().query(query);
		XmlElement@ xml;
		@xml = XmlElement(cxml.toDictionary() ) ;

		writeXML(m_metagame, serverFile, xml );
	}
		

	protected void handleBaseOwnerChangeEvent(const XmlElement@ event) {
		// checkServer();
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


