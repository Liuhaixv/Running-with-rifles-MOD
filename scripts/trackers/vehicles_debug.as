#include "tracker.as"
#include "log.as"
#include "helpers.as"

class VehiclesDebug: Tracker {    

	protected Metagame@ m_metagame;

    VehiclesDebug(Metagame@ metagame) {
		@m_metagame = @metagame;
	}
    //载具生成
	protected void handleVehicleSpawnEvent(const XmlElement@ event) {
        string m_vehicleKey = event.getStringAttribute("vehicle_key");
        _log("载具生成, key=" + m_vehicleKey);
        //TagName=vehicle_spawn_event owner_id=0 vehicle_id=14 vehicle_key=auto_turret.vehicle
        _log("载具生成, 事件：" + event.toString());

    }
	protected void handleVehicleHolderChangeEvent(const XmlElement@ event) {}
    //载具被毁
	protected void handleVehicleDestroyEvent(const XmlElement@ event) {
        string m_vehicleKey = event.getStringAttribute("vehicle_key");

        _log("载具被摧毁, key=" + m_vehicleKey);
        _log("载具被摧毁, 事件：" + event.toString());

    }
	protected void handleVehicleSpotEvent(const XmlElement@ event) {}
}