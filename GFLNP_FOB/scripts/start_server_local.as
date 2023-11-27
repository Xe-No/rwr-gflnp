#include "path://media/packages/vanilla/scripts"
#include "path://media/packages/GFLNP/scripts"
#include "path://media/packages/GFLNP_INF/scripts"
#include "path://media/packages/GFLNP_FOB/scripts"
#include "my_gamemode_invasion.as"

void main(dictionary@ inputData) {
	XmlElement inputSettings(inputData);

	UserSettings settings;
	
    settings.m_factionChoice = 0;
    settings.m_playerAiCompensationFactor = 1;
    settings.m_fellowCapacityFactor = 0;
	settings.m_fellowAiAccuracyFactor = 0.94;
	settings.m_enemyCapacityFactor = 0;
	settings.m_enemyAiAccuracyFactor = 0.94;
   	settings.m_playerAiReduction = 1.0;
   	settings.m_teamKillPenaltyEnabled = true;
   	settings.m_completionVarianceEnabled = false;
   	settings.m_journalEnabled = true; //todo
	settings.m_fellowDisableEnemySpawnpointsSoldierCountOffset = 1;

    settings.m_fov = false; //halloween

	settings.m_xpFactor = 2.0;
	settings.m_rpFactor = 1.0;
	
	array<string> overlays = {
			"media/packages/GFLNP",
			"media/packages/GFLNP_INF",
			"media/packages/GFLNP_FOB"
	};
	settings.m_overlayPaths = overlays;
	
	// TODO: setup settings
    settings.m_startServerCommand = """
<command class='start_server'
        server_name='GFLNP[FOB]'
        server_port='60000'
        comment='GFL mod QQ qun: 748950999 / 1072742936（满）'
        url='https://steamcommunity.com/sharedfiles/filedetails/?id=2513537759'
        register_in_serverlist='0'
        mode='GFL [FOB]'
        persistency='forever'
        max_players='32'>
        <client_faction id='0' />
</command>
""";

	_setupLog(inputSettings);

	settings.print();

	MyGameModeInvasion metagame(settings);

	metagame.init();
	metagame.run();
	metagame.uninit();

	_log("ending execution");
}

