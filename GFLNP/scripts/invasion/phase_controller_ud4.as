// internal
#include "tracker.as"
#include "log.as"
#include "helpers.as"
#include "announce_task.as"
#include "phase_controller.as"

// generic trackers
#include "spawner.as"

#include "gamemode_invasion.as"

// by Xe-No 2022-7-28 01:03:17

// --------------------------------------------
class PhaseUD4 : Tracker {
	protected GameModeInvasion@ m_metagame;
	protected PhaseControllerUD4@ m_controller;
	protected bool m_started;
	protected bool m_ended;

	// --------------------------------------------
	PhaseUD4(GameModeInvasion@ metagame, PhaseControllerUD4@ controller) {
		@m_metagame = @metagame;
		@m_controller = @controller;
		m_started = false;
		m_ended = false;
	}

	// --------------------------------------------
	void start() {
		m_started = true;
	}

	// --------------------------------------------
	void end() {
		Tracker::end();
		m_controller.phaseEnded();
		m_ended = true; // metagame will check has_ended, and will remove the phase from processing if it has ended
	}

	// --------------------------------------------
	bool hasEnded() const {
		return m_ended;
	}

	// --------------------------------------------
	bool hasStarted() const {
		return m_started;
	}

	// --------------------------------------------
	void onDestroyTargetsChanged(array<string>@ destroyTargets) {
	}

	// --------------------------------------------
	void save(XmlElement@ root) {
	}

	// --------------------------------------------
	void load(const XmlElement@ root) {
	}
};

// --------------------------------------------
class PhaseUD4_1 : PhaseUD4 {
	protected float m_timer;

	// --------------------------------------------
	PhaseUD4_1(GameModeInvasion@ metagame, PhaseControllerUD4@ controller) {
		super(metagame, controller);
		m_timer = 0.0;
	}

	// --------------------------------------------
	void start() {
		PhaseUD4::start();
		_log("PhaseUD4_1 starting");
		sendFactionMessage(m_metagame, 0, "Strong enemy force pushing forward. Stand our bases at all cost.", 0.9)

		//$this->timer = 10.0 * 60.0;

		// quick phase1, for testing

		m_timer = 1.0 * 60.0;

		// set enemy commander ai
		m_metagame.getComms().send("<command class='commander_ai' faction='1' base_defense='0.1' border_defense='0.1' attack_start_spread='0' />");

		// set enemy soldier ai modifications
		m_metagame.getComms().send(
			"<command class='soldier_ai' faction='1'>" + 
			"  <parameter class='willingness_to_charge' value='0.7' />" +
			"</command>");

	}

	// --------------------------------------------
	void update(float time) {
		m_timer -= time;
		if (m_timer < 0.0) {
			// done
			end();
		}
	}
	

	// TODO: timer could be saved, but won't bother with it now; if phase1 is save&quit and continued, it'll start from beginning
};

// --------------------------------------------
class PhaseUD4_2 : PhaseUD4 {
	// --------------------------------------------
	PhaseUD4_2(GameModeInvasion@ metagame, PhaseControllerUD4@ controller) {
		super(metagame, controller);
	}

	// --------------------------------------------
	protected void handleSettingsChangeEvent(const XmlElement@ event) {
		applyCapacityMultipliers();
	}	

	// --------------------------------------------
	protected void applyCapacityMultipliers() {
		// decrease amount of enemy soldiers in phase 2
		m_metagame.getComms().send(
			"<command class='change_game_settings'>" + 
			// was 0.8, 0.667*1.2 = 0.8
			"  <faction capacity_multiplier='" + (m_metagame.getUserSettings().m_fellowCapacityFactor * 0.667) + "' />" + 
			// was 0.5, 0.5*1.0 = 0.5
			"  <faction capacity_multiplier='" + (m_metagame.getUserSettings().m_enemyCapacityFactor * 0.5) + "' />" + 
			"  <faction />" + 
			"</command>");
	}

	// --------------------------------------------
	void start() {
		PhaseUD4::start();
		_log("PhaseUD4_2 starting");

		sendFactionMessage(m_metagame, 0, "Enemy attack get weak", 0.9)

		// set enemy commander ai
		m_metagame.getComms().send("<command class='commander_ai' faction='1' base_defense='0.7' border_defense='0.2' />");

		applyCapacityMultipliers();

		// set enemy soldier ai modifications, back to normal actually
		m_metagame.getComms().send(
			"<command class='soldier_ai' faction='1'>" + 
			"  <parameter class='willingness_to_charge' value='0.0' />" +
			"</command>");

		// set friendly commander ai
		m_metagame.getComms().send("<command class='commander_ai' faction='0' base_defense='0.4' border_defense='0.0' />");

		// testing helper:
		//$this->metagame->comms->send("say phase 2 started");
		m_metagame.getComms().send("<command class='update_base' base_key='g1' capturable='1' />");
		m_metagame.getComms().send("<command class='update_base' base_key='g2' capturable='1' />");
		m_metagame.getComms().send("<command class='update_base' base_key='g3' capturable='1' />");

	}
};



// --------------------------------------------
class PhaseControllerUD4 : PhaseController {
	protected GameModeInvasion@ m_metagame;
	protected bool m_started;

	protected uint m_currentPhaseIndex;

	protected array<PhaseUD4@> m_phases;

	protected array<string> m_destroyTargets;

	// --------------------------------------------
	PhaseControllerUD4(GameModeInvasion@ metagame) {
		@m_metagame = @metagame;
		m_started = false;
		m_currentPhaseIndex = 0;

		// reset here initially
		// - continue: reset -> load -> game_continue_pre_start
		// - start: reset -> reset -> start
		// - restart: reset -> reset -> start, reset -> start
		reset();
	}

	// --------------------------------------------
	void reset() {
		m_phases = array<PhaseUD4@>();

		m_phases.insertLast(PhaseUD4_1(m_metagame, this));
		m_phases.insertLast(PhaseUD4_2(m_metagame, this));


		m_currentPhaseIndex = 0;

		// array<string> targets = {"radio_jammer.vehicle", /*"aa_emplacement.vehicle",*/ "radar_tower.vehicle"};
		// m_destroyTargets = targets;
	}

	// --------------------------------------------
	void gameContinuePreStart() {
		_log("starting PhaseControllerUD4 tracker with game_continue_pre_start, phase=" + m_currentPhaseIndex);
		// on_game_continue_pre_start happens before start

		// mark as started, to skip calling start()
		// the metagame won't then call start at all
		m_started = true;
		startCurrentPhase();
	}

	// --------------------------------------------
	void onRemove() {
		// make start() called again if the tracker is added again, like for restart
		m_started = false;
	}

	// --------------------------------------------
	void start() {
		// call reset here, phases and targets are initialized fresh
		// - helps with handling restart
		reset();

		_log("starting PhaseControllerUD4 tracker, phase=" + m_currentPhaseIndex);

		m_started = true;
		startCurrentPhase();
	}

	// --------------------------------------------
	void phaseEnded() {
		// advance to next phase
		m_currentPhaseIndex += 1;
		if (m_currentPhaseIndex < m_phases.size()) {
			startCurrentPhase();
		} else {
			// finished, no more phases left
			completeMatch();
		}
	}

	// --------------------------------------------
	void completeMatch() {
		// m_metagame.getComms().send("<command class='set_match_status' faction_id='1' lose='1' />");
		// m_metagame.getComms().send("<command class='update_base' owner_id='0' base_key='arena' capturable='0' />");
		// m_metagame.getComms().send("<command class='set_match_status' faction_id='0' win='1' />");
	}

	// --------------------------------------------
	void startCurrentPhase() {
		if (m_currentPhaseIndex < m_phases.size()) {
			PhaseUD4@ phase = m_phases[m_currentPhaseIndex];

			m_metagame.addTracker(phase);
		} else {

		}
	}

	// --------------------------------------------
	bool hasEnded() const {
		// always on
		return false;
	}

	// --------------------------------------------
	bool hasStarted() const {
		return m_started;
	}

	// ----------------------------------------------------
	protected void handleVehicleDestroyEvent(const XmlElement@ event) {
	}

	// --------------------------------------------
	void invalidateDestroyTargets() {

	}

	// --------------------------------------------
	protected void handleFactionLoseEvent(const XmlElement@ event) {
		// if green lost a battle, start over
		int factionId = -1;

		const XmlElement@ loseCondition = event.getFirstElementByTagName("lose_condition");
		if (loseCondition !is null) {
			factionId = loseCondition.getIntAttribute("faction_id");
		}

		if (factionId == 0) {
			// friendly faction lost
			// - mark this tracker not started so that it will be added again when map restarts
			m_metagame.removeTracker(this);
			m_started = false;
		}
	}

	// --------------------------------------------
	void save(XmlElement@ root) {

	}

	// --------------------------------------------
	void load(const XmlElement@ root) {

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

		if (checkCommand(message, "end_phase")) {
			PhaseUD4@ phase = m_phases[m_currentPhaseIndex];
			phase.end();
		}
	}
}
