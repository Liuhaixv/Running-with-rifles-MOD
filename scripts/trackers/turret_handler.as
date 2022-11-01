#include "tracker.as"
#include "log.as"
#include "helpers.as"

#include "turret.as"
#include "auto_turret.as"

class TurretHandler: Tracker {
    protected Metagame@ m_metagame;

    array<Turret@> turrets;

    //检查炮台开火间隔
    float interval = 0.0;
    float timer = interval;

    //enable update
    bool m_running = false;

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
            
            Turret@ turret;
            if(m_vehicleKey == "auto_turret.as") {
                @turret= cast<AutoTurret>(AutoTurret(m_metagame, owner_id, vehicle_id, m_vehicleKey));
            } else {
                @turret= cast<AutoTurret>(AutoTurret(m_metagame, owner_id, vehicle_id, m_vehicleKey));
            }
            addTurret(turret);
            m_running = true;
        }

    }
    
    //载具被毁
	protected void handleVehicleDestroyEvent(const XmlElement@ event) {
        string m_vehicleKey = event.getStringAttribute("vehicle_key");
        //查找key值是否包含.turret
        if(m_vehicleKey.findLast(".turret") >= 0) {
            if(turrets.length() == 1) {
                m_running = false;
            }

            int vehicle_id = event.getIntAttribute("vehicle_id");
            removeTurret(vehicle_id);
        }
    }

    void update(float time) {
        timer -= time;
        if(timer > 0) {
            return;
        }
        _log("开始遍历炮塔, total: " + turrets.length());
        for(int i = 0; i < turrets.length(); i++) {
            turrets[i].attackEnemiesNearBy(time);
        }
        timer = interval;
	}

    private void addTurret(Turret@ turret) {
        turrets.insertLast(turret);
    }

    private void removeTurret(int vehicle_id) {
        //遍历所有炮塔删除指定炮塔
        for(int i = 0; i < turrets.length(); i++) {
            if(turrets[i].vehicle_id == vehicle_id) {
                turrets.removeAt(i);
                return;
            }
        }
    }

    bool hasEnded() const {
		// always on
		return false;
	}

	// --------------------------------------------
	bool hasStarted() const {
		//timer on/off
		return m_running;
	}
}