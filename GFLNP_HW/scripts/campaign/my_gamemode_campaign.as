#include "gamemode_campaign.as"
#include "my_stage_configurator_campaign.as"
#include "my_item_delivery_configurator_campaign.as"

// costume trackers
#include "ac130x_gun_run.as"
#include "f16_missle_run.as"
#include "heli_gun_run.as"

// costume trackers
#include "redeem_tracker.as"
#include "server_tracker.as"
#include "heal_on_kill.as"

// --------------------------------------------
class MyGameModeCampaign : GameModeCampaign {
	// --------------------------------------------
	MyGameModeCampaign(UserSettings@ settings) {
		super(settings);
	}

	// --------------------------------------------
	// protected void setupMapRotator() {
	// 	MapRotatorCampaign mapRotatorCampaign(this);
	// 	MyStageConfiguratorCampaign configurator(this, mapRotatorCampaign);
	// 	@m_mapRotator = @mapRotatorCampaign;
	// }
	protected void setupMapRotator() {
		@m_mapRotator = MapRotatorInvasion(this);
		StageConfiguratorInvasion configurator(this, m_mapRotator);
	}	
	
	// --------------------------------------------
	protected void setupItemDeliveryOrganizer() {
		MyItemDeliveryConfiguratorCampaign configurator(this);
		@m_itemDeliveryOrganizer = ItemDeliveryOrganizer(this, configurator);
	}

		// --------------------------------------------
	protected void setupExperimentalFeatures() {
		addTracker(GpsLaptop(this));
		addTracker(EmpGrenade(this));
		addTracker(RepairCrane(this));
		addTracker(A10GunRun(this));
		addTracker(AC130GunRun(this));
		addTracker(HeliGunRun(this));
		addTracker(F16GunRun(this));
		addTracker(HealOnKill(this, "Infected Pumpkin"));   
	}
}
