#include "path://media/packages/vanilla/scripts"
#include "path://media/packages/GFLNP/scripts"
#include "path://media/packages/GFLNP_INF/scripts"
#include "path://media/packages/GFLNP_HW/scripts"
#include "my_gamemode_campaign.as"


// --------------------------------------------
void main(dictionary@ inputData) {
	XmlElement inputSettings(inputData);

	UserSettings settings;
	settings.m_initialRp = 2000;

	settings.fromXmlElement(inputSettings);

	array<string> overlays = {
			"media/packages/GFLNP",
			"media/packages/GFLNP_INF",
			"media/packages/GFLNP_HW"
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

