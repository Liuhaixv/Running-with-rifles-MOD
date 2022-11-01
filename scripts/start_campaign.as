#include "path://media/packages/vanilla/scripts"
// --------------------------------------------
// TODO: replace with your package's script folder here
// --------------------------------------------
#include "path://media/packages/liuhaixv/scripts"

#include "my_gamemode.as"

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
                "media/packages/liuhaixv"
        };
        settings.m_overlayPaths = overlays;
		//投掷物
		//projectiles, including throwables
		settings.m_overlayPaths.insertLast("media/packages/liuhaixv/weapons/projectiles/throwables");
		settings.m_overlayPaths.insertLast("media/packages/liuhaixv/weapons/projectiles");
		//turret
		settings.m_overlayPaths.insertLast("media/packages/liuhaixv/vehicles/turrets");
		//枪、发射器类手持武器
		//weapons of guns and launchers
		settings.m_overlayPaths.insertLast("media/packages/liuhaixv/weapons/guns");

	MyGameMode metagame(settings);

	metagame.init();
	metagame.run();
	metagame.uninit();

	_log("ending execution");
}
