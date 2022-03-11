#include "stage_configurator_invasion.as"

// ------------------------------------------------------------------------------------------------
class MyStageConfiguratorInvasion : StageConfiguratorInvasion {
	// ------------------------------------------------------------------------------------------------
	MyStageConfiguratorInvasion(GameModeInvasion@ metagame, MapRotatorInvasion@ mapRotator) {
		super(metagame, mapRotator);
	}

	// ------------------------------------------------------------------------------------------------
	const array<FactionConfig@>@ getAvailableFactionConfigs() const {
		array<FactionConfig@> availableFactionConfigs;

		// --------------------------------
		// TODO: define 3 faction configs here
		// - "green.xml" faction specification filename
		// - "Greenbelts" faction name, usually same as the one in the file
		// - "0.1 0.5 0" color used for faction in the world view
		// - "green_boss.xml" faction specification filename used in the final missions; 
		//   can be same as the regular faction filename
		// --------------------------------

		availableFactionConfigs.push_back(FactionConfig(-1, "grey.xml", "G&K PMC", "0.9 0.6 0", "grey.xml"));
		availableFactionConfigs.push_back(FactionConfig(-1, "green.xml", "USFMC", "0.9 0 0.9", "green.xml"));
		availableFactionConfigs.push_back(FactionConfig(-1, "brown.xml", "USSRA", "0.2 0.2 0.8", "brown.xml"));
		availableFactionConfigs.push_back(FactionConfig(-1, "tx.xml", "SF IMC", "0.7 0.2 0.7", "tx.xml"));
		availableFactionConfigs.push_back(FactionConfig(-1, "kcco.xml", "KCCO", "0.0 0.4 0.1", "kcco.xml"));

		return availableFactionConfigs;
	}
}
