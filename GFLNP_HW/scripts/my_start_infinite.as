#include "path://media/packages/vanilla/scripts"
#include "path://media/packages/Girls_FrontLine/scripts"
#include "path://media/packages/GFL1_inf/scripts"
#include "path://media/packages/GFL1_halloween/scripts"
#include "my_gamemode_campaign.as"


// --------------------------------------------
void main(dictionary@ inputData) {
	XmlElement inputSettings(inputData);

	UserSettings settings;
	settings.m_initialRp = 2000;

	settings.fromXmlElement(inputSettings);

	array<string> overlays = {
			"media/packages/Girls_FrontLine",
			"media/packages/GFL1_inf",
			"media/packages/GFL1_halloween"
		};
	settings.m_overlayPaths = overlays;

	_setupLog(inputSettings);
	settings.print();

	MyGameModeCampaign metagame(settings);

	metagame.init();
	metagame.run();
	metagame.uninit();

	_log("ending execution");
}

