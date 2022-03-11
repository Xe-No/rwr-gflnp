#include "path://media/packages/vanilla/scripts"
#include "path://media/packages/Girls_FrontLine/scripts"
#include "path://media/packages/GFL1_inf/scripts/invasion"
//#include "path://media/packages/GFL1_halloween"
#include "my_gamemode_invasion.as"

void main(dictionary@ inputData) {
	XmlElement inputSettings(inputData);

	UserSettings settings;
	
    //settings.m_factionChoice = 0; // 0 for halloween
     settings.m_factionChoice = 1;
    settings.m_playerAiCompensationFactor = 1;
    settings.m_fellowCapacityFactor = 0.95;
	settings.m_fellowAiAccuracyFactor = 0.94;
	settings.m_enemyCapacityFactor = 1.05;
	settings.m_enemyAiAccuracyFactor = 0.94;
   	settings.m_playerAiReduction = 1.0;
   	settings.m_teamKillPenaltyEnabled = true;
   	settings.m_completionVarianceEnabled = false;
   	settings.m_journalEnabled = true; //todo
	settings.m_fellowDisableEnemySpawnpointsSoldierCountOffset = 1;
	settings.m_playerDamageModifier = -1.0;
    settings.m_fov = false; //halloween

	settings.m_xpFactor = 1.5;
	settings.m_rpFactor = 1.0;
	
	array<string> overlays = {
            "media/packages/Girls_FrontLine",
			"media/packages/GFL1_inf"
	};
	settings.m_overlayPaths = overlays;
	
	// TODO: setup settings
    settings.m_startServerCommand = """
<command class='start_server'
        server_name='RUA'
        server_port='20591'
        comment='GFL mod QQ qun: 1072742936'
        url='https://steamcommunity.com/sharedfiles/filedetails/?id=1541806712'
        register_in_serverlist='0'
        mode='GFL [INF]'
        persistency='forever'
        max_players='28'>
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

