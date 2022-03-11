#include "path://media/packages/vanilla/scripts"
#include "path://media/packages/GFLNP/scripts"
#include "path://media/packages/GFLNP_AC/scripts"
#include "my_gamemode_campaign.as"

// --------------------------------------------
void main(dictionary@ inputData) {
	XmlElement inputSettings(inputData);

	UserSettings settings;
	settings.fromXmlElement(inputSettings);
	_setupLog(inputSettings);
	settings.print();

	// --------------------------------------------
	// TODO: replace with your package's folder here
	// --------------------------------------------
	array<string> overlays = {
                "media/packages/GFLNP",
                "media/packages/GFLNP_AC"
        };
        settings.m_overlayPaths = overlays;

	MyGameModeCampaign metagame(settings);

	metagame.init();
	metagame.run();
	metagame.uninit();

	_log("ending execution");
}
