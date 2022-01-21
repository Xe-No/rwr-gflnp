#include "path://media/packages/vanilla/scripts"
#include "path://media/packages/minimodes/scripts"
#include "path://media/packages/classic/scripts"
#include "gamemode_minimodes.as"

#include "map_rotator_classic.as"

// --------------------------------------------
class GameModeMiniModesClassic : GameModeMiniModes {
	// --------------------------------------------
	GameModeMiniModesClassic(UserSettings@ settings) {
		super(settings);
	}

	// --------------------------------------------
	protected void setupMapRotator() {
		@m_mapRotator = MapRotatorMiniModesClassic(this);
	}
}

// --------------------------------------------
void main(dictionary@ inputData) {
	UserSettings s;

	// override minimodes overlay with one specific to classic
	s.m_overlayPaths = array<string>();
	s.m_overlayPaths.insertLast("media/packages/Girls_Frontline");
	
	s.m_timeBetweenSubstages = 40.0;
	s.m_quickmatchMaxTime = 1800.0;
	s.m_kothMaxTime = 1800.0;

	s.m_startServerCommand = """
<command class='start_server'
        server_name='Girls Frontline[CN11][TEST][PVP]'
        server_port='6100'
        comment='GFL mod QQ qun: 1072742936'
        url='https://steamcommunity.com/sharedfiles/filedetails/?id=1541806712'
        register_in_serverlist='1'
	mode='GFL [PVP]'
	persistency='forever_and_match'
	max_players='24'>
</command>
""";


	s.print();

	GameModeMiniModesClassic@ metagame = GameModeMiniModesClassic(s);
	
	metagame.init();
	// execution blocks here at run until comms from server is lost
	metagame.run();
	metagame.uninit();

	_log("ending execution");
}
