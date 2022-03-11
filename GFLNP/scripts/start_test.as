#include "path://media/packages/vanilla/scripts"
#include "path://media/packages/GFLNP/scripts"
#include "path://media/packages/GFLNP_INF/scripts/invasion"
#include "my_gamemode_invasion.as"

void main(dictionary@ inputData) {
	XmlElement inputSettings(inputData);

	UserSettings settings;
	
	settings.m_factionChoice = 1;
    settings.m_factionChoice = 1;
    settings.m_playerAiCompensationFactor = 1;
    settings.m_enemyAiAccuracyFactor = 0.95;
    settings.m_playerAiReduction = 1.0;
    settings.m_teamKillPenaltyEnabled = true;
    settings.m_completionVarianceEnabled = false;
    settings.m_journalEnabled = false; //todo
	settings.m_fellowDisableEnemySpawnpointsSoldierCountOffset = 1;

	settings.m_xpFactor = 1.5;
	settings.m_rpFactor = 1;
	
	array<string> overlays = {
            "media/packages/GFLNP",
            "media/packages/GFLNP_INF"
	};
	settings.m_overlayPaths = overlays;
	
	// TODO: setup settings
    settings.m_startServerCommand = """
<command class='start_server'
        server_name='Girls Frontline[CN1]'
        server_port='1234'
        comment='GFL ver0.10.2 - QQ qun: 1072742936'
        url=''
        register_in_serverlist='0'
        mode='GFL [INF]'
        persistency='forever'
        max_players='16'>
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

