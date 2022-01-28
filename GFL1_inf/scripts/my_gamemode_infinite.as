#include "my_gamemode_campaign.as"
#include "map_rotator_invasion.as"

// --------------------------------------------
class MyGameModeInfinite : MyGameModeCampaign {
	// --------------------------------------------
	MyGameModeInfinite(UserSettings@ settings) {
		super(settings);
	}

	protected void setupMapRotator() {
		@m_mapRotator = MapRotatorInvasion(this);
		MyStageConfiguratorInvasion configurator(this, m_mapRotator);
	}
}
