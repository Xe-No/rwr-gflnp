#include "path://media/packages/vanilla/scripts"
#include "path://media/packages/GFLNP/scripts"
#include "path://media/packages/GFLNP_INF/scripts"
#include "path://media/packages/GFLNP_FOB/scripts"

#include "gamemode_fob.as"

void main(dictionary@ inputData) {
	XmlElement inputSettings(inputData);

	UserSettings settings;
	// settings.m_difficulty = 1;
	settings.m_fov = false;

	// TODO: setup settings
    settings.m_startServerCommand = """
<command class='start_server'
	server_name='FOB'
	server_port='60000'
	comment=''
	url=''
	register_in_serverlist='0'
	mode='PvPvE'
	max_players='32'>
	<client_faction id='0' />
</command>
""";

	_setupLog(inputSettings);
	settings.print();

	GameModeFOB metagame(settings);

	metagame.init();
	metagame.run();
	metagame.uninit();

	_log("ending execution");
}
