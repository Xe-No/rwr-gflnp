#include "path://media/packages/vanilla/scripts"
#include "path://media/packages/Girls_FrontLine/scripts"
#include "path://media/packages/GFL1_arcade/scripts"
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
                "media/packages/Girls_FrontLine",
                "media/packages/GFL1_arcade"
        };
        settings.m_overlayPaths = overlays;

	MyGameModeCampaign metagame(settings);

	metagame.init();
	metagame.run();
	metagame.uninit();

	_log("ending execution");
}
