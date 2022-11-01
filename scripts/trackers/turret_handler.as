#include "tracker.as"
#include "log.as"
#include "helpers.as"

#include "turret.as"

class TurretHandler: Tracker {
    protected Metagame@ m_metagame;

    array<Turret@> turrets;

    TurretHandler(Metagame@ metagame) {
		@m_metagame = @metagame;
	}

    //载具生成
	protected void handleVehicleSpawnEvent(const XmlElement@ event) {
        string m_vehicleKey = event.getStringAttribute("vehicle_key");
        //查找key值是否包含.turret
        if(m_vehicleKey.findLast(".turret") >= 0) {
            int owner_id = event.getIntAttribute("owner_id");
            int vehicle_id = event.getIntAttribute("vehicle_id");

            Turret@ turret = Turret("")
            addTurret()
        }

    }
    
    //载具被毁
	protected void handleVehicleDestroyEvent(const XmlElement@ event) {
        int vehicle_id = event.getIntAttribute("vehicle_id");
        removeTurret(vehicle_id);
    }

    void update(float time) {
	}

    private void addTurret(Turret@ turret) {
        turrets.insertLast(turret);
    }

    private void removeTurret(int vehicle_id) {
        //遍历所有炮塔删除指定炮塔
        for(int i = 0; i < turrets.length(); i++) {
            if(turrets[vehicle_id] = vehicle_id) {
                turrets.removeAt(i);
                return;
            }
        }
    }
}