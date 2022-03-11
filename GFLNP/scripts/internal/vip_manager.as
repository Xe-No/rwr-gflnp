// --------------------------------------------
class VIPManager {
	protected Metagame@ m_metagame;
	protected array<string> m_vips;

	// --------------------------------------------
	VIPManager(Metagame@ metagame) {
		@m_metagame = metagame;
	}

	// --------------------------------------------
	void addVIP(string name) {
		m_vips.insertLast(name.toLowerCase());
	}

	// --------------------------------------------
	void loadFromFile() {
		m_vips = loadStringsFromFile(m_metagame, "vips.xml");
		for (uint i = 0; i < m_vips.size(); ++i) {
			m_vips[i] = m_vips[i].toLowerCase();
		}
	}

	// --------------------------------------------
	bool isVIP(string name, int playerId = -1) const {
		// consider server console comments as admin, but not as vip, thus returning false
		if (playerId == 0 && name == "") {
			return false;
		}
		return m_vips.find(name.toLowerCase()) >= 0;
	}
};
