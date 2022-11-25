#include "tracker.as"
#include "helpers.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"

class ElectricZone : Tracker {
  protected Metagame@ m_metagame;

  //启用毒圈
  //enable electric zone
  protected bool m_running = false; //the update function is only running when there are calls in queue
 
  //毒圈的更新时间
  protected float update_interval = 1.0;

  //毒圈初始范围
  protected float init_range = 1600.0;
  protected float stop_range = 100;

  //毒圈中心
  protected Vector3 center(512, 100, 512);

  //毒圈缩小的范围
  protected float range_reduced_when_updated = 1;

  //毒圈当前范围
  protected float current_range = init_range;

  protected int markerId = 10000;

  //update计时器,用于判断是否应该更新毒圈
  protected float m_timer = update_interval;
  
  ElectricZone(Metagame@ metagame) {
    @m_metagame = @metagame;
  }

  protected void handleCallEvent(const XmlElement@ event) {

    // Check call key
    if (event.getStringAttribute("call_key") == "electric_zone_test.call") {
        enableElectricZone();
    }
  }
  
	// --------------------------------------------
	void update(float time) {
		
        if(!m_running) {
            return;
        }

        m_timer -= time;

        if(m_timer <= 0) {            
            //开始缩圈
            //start to recude the range of electric zone

            //reset timer
            m_timer += update_interval;

            if(current_range <= stop_range) {
                pauseElectricZone();
                return;
            }

            updateGroundMarker(current_range, center);
            updateMapViewMarker(current_range, center);

            //更新当前毒圈范围
            current_range -= range_reduced_when_updated;
        } else {
            //未到缩圈的更新时间
            //not the time to update the range
            return;
        }
	}

    //TODO: 更新毒圈在游戏内地面上的material
    protected void updateGroundMarker(float range, Vector3@ center) {
        _log("当前毒圈范围:" + range);

        // place the marker
        XmlElement command("command");

        command.setStringAttribute("class", "set_marker");
        command.setIntAttribute("id", markerId);
        command.setIntAttribute("faction_id", 0);
        command.setIntAttribute("atlas_index", 2);
        command.setFloatAttribute("size", 0.5);
        command.setFloatAttribute("range", range);
        command.setIntAttribute("enabled", 1);
        command.setStringAttribute("position", center.toString());
        command.setStringAttribute("text", "Center of Electric Zone");
        command.setStringAttribute("type_key", "electric_zone");
        command.setBoolAttribute("show_in_map_view", true);
        command.setBoolAttribute("show_in_game_view", true);
        command.setBoolAttribute("show_at_screen_edge", true);
            
        m_metagame.getComms().send(command);
    }
    
    //TODO: 更新毒圈在游戏内地图上的material
    protected void updateMapViewMarker(float range, Vector3@ center) {

    }

    void enableElectricZone() {
        m_running = true;
    }

    void pauseElectricZone() {
        m_running = false;
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
