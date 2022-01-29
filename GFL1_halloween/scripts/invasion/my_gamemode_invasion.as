#include "gamemode_invasion.as"
#include "my_stage_configurator_invasion.as"
#include "my_item_delivery_configurator_invasion.as"

// costume trackers
#include "ac130x_gun_run.as"
#include "f16_missle_run.as"
#include "heli_gun_run.as"

// costume trackers
#include "redeem_tracker.as"
#include "server_tracker.as"
#include "heal_on_kill.as"

// --------------------------------------------
class MyGameModeInvasion : GameModeInvasion {
	// --------------------------------------------
	MyGameModeInvasion(UserSettings@ settings) {
		super(settings);
	}

	// --------------------------------------------
	protected void setupMapRotator() {
		@m_mapRotator = MapRotatorInvasion(this);
		StageConfiguratorInvasion configurator(this, m_mapRotator);
	}

	// --------------------------------------------
	protected void setupItemDeliveryOrganizer() {
		MyItemDeliveryConfiguratorInvasion configurator(this);
		@m_itemDeliveryOrganizer = ItemDeliveryOrganizer(this, configurator);
	}

	// --------------------------------------------
	protected void setupExperimentalFeatures() {
		addTracker(GpsLaptop(this));
		addTracker(EmpGrenade(this));
		addTracker(RepairCrane(this));
		addTracker(A10GunRun(this));
		addTracker(AC130XGunRun(this));
		addTracker(HeliGunRun(this));
		addTracker(F16GunRun(this));		
		addTracker(HealOnKill(this, "Infected Pumpkin"));   
	}

}



