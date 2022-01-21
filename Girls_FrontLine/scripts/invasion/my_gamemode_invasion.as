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
#include "factory_spawner.as"
#include "mixer.as"



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
		addTracker(SquadEquipmentKit(this)); 
		addTracker(RangeFinder(this)); 
		// addTracker(Halloween(this));

		addTracker(HeliGunRun(this));
		addTracker(F16GunRun(this));		
		addTracker(RedeemTracker(this));
		addTracker(ServerTracker(this));
		addTracker(FactorySpawner(this));
		addTracker(Mixer(this));
	}
	
	protected void setupCallMarkers() {
		// if you're adding a call here, make sure it has notify_metagame="1" in it's <call> tag
		array<CallMarkerConfig@> configs = {
			//CallMarkerConfig(string key, int atlasIndex = 0, float size = 2.0, float range = 1.0, string text = "")
			CallMarkerConfig("mortar1.call", "call_marker", 6, 0.5, 30.0),
			CallMarkerConfig("mortar2.call", "call_marker", 6, 0.5, 50.0),      
			CallMarkerConfig("artillery1.call", "call_marker", 8, 1.0, 90.0),
			CallMarkerConfig("artillery2.call", "call_marker", 8, 1.0, 90.0),
			CallMarkerConfig("paratroopers1.call", "call_marker_drop", 10, 0.5),
			CallMarkerConfig("paratroopers2.call", "call_marker_drop", 10, 0.5),
			CallMarkerConfig("paratroopers_medic.call", "call_marker_gunship", 14, 0.5, 60.0),            
			CallMarkerConfig("humvee.call", "call_marker_drop", 12, 0.5),
			CallMarkerConfig("buggy.call", "call_marker_drop", 12, 0.5),
			CallMarkerConfig("supply_quad.call", "call_marker_drop", 13, 0.5),
			CallMarkerConfig("tank.call", "call_marker_drop", 12, 0.5),
			CallMarkerConfig("cover_drop.call", "call_marker_drop", 13, 0.5),


			CallMarkerConfig("apc_1.call", "call_marker_drop", 12, 0.5),

			CallMarkerConfig("jugger_drop.call", "call_marker_gunship", 13, 0.5, 60.0),
			CallMarkerConfig("squad_404.call", "call_marker_gunship", 11, 0.5, 1.0),
			CallMarkerConfig("squad_AR.call", "call_marker_gunship", 11, 0.5, 1.0),
			CallMarkerConfig("squad_defy.call", "call_marker_gunship", 11, 0.5, 60.0),
			
			CallMarkerConfig("strike_2b14.call", "call_marker", 6, 0.5, 40.0),
			CallMarkerConfig("strike_air.call", "call_marker", 7, 0.5, 10.0),
			CallMarkerConfig("strike_stuka.call", "call_marker", 16, 0.5, 20.0),

			CallMarkerConfig("artillery_105.call", "call_marker", 8, 0.5, 80.0),
			CallMarkerConfig("ac130_gun_run.call", "call_marker_gunship", 3, 1.0, 90.0)
            //CallMarkerConfig("a10_gun_run.call", "call_marker", 4, 0.5) //handled in a10_gun_run.as
			};

		addTracker(CallMarkerTracker(this, configs));
	}



}



