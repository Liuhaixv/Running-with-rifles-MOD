#include "tracker.as"
#include "helpers.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"

#include "character.as"
/*
游戏地图范围 1024 * 1024 = a * a

每个小格距离是 1024/3/10

另初始毒圈不超过地图范围, 直径为 3/4a
则初始中心x,y范围应在[3/8a, 5/8a]
即[384, 640]

当毒圈radius=1时，r应等于a/2

init_radius=136.5 <-> r=1024/4=256
1365.33333 range= 1024/3
=>游戏内坐标1=4range

4096*4096px
图片毒圈半径 = 1024px = 1 
*/

float distance_of_small_block = 1024/30; // 34.133

class ElectricZone : Tracker {
  protected Metagame@ m_metagame;

  //启用毒圈
  //enable electric zone
  protected bool m_running = false; //the update function is only running when there are calls in queue
 
  //毒圈的更新时间
  protected float update_interval = 1.0;

  //毒圈初始范围

  protected float init_radius = distance_of_small_block * 10;//10个小格距离
  protected float stop_radius = 0;

  //毒圈中心
  protected Vector3 center(512, 100, 512);

  //毒圈缩小的范围
  protected float radius_reduced_when_updated = 1;

  //毒圈当前范围
  protected float current_radius = init_radius;

  protected int init_markerId = 10000;
  protected int markerId = init_markerId;

  //update计时器,用于判断是否应该更新毒圈
  protected float m_timer = 0;
  
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
            //start to recude the radius of electric zone

            //reset timer
            m_timer += update_interval;

            if(current_radius <= stop_radius) {
                pauseElectricZone();
                return;
            }

            // Vector3 offset(rand(-5,5), rand(-5,5), rand(-5,5));
            Vector3 offset(0, 0, 0);

            updateGroundMarker(markerId, current_radius, center.add(offset));
            updateMapViewMarker(markerId, current_radius, center.add(offset));
            killAllCharactersOutOfRange(center, current_radius);
            
            //删除之前的标记，释放资源
            // Remove markers used before
            if(markerId % 2 == init_markerId % 2 && markerId != init_markerId) {
                disableMarker(markerId - 1);
                disableMarker(markerId - 2);
            }

            //更新当前毒圈范围
            current_radius -= radius_reduced_when_updated;
            markerId++;
        } else {
            //未到缩圈的更新时间
            //not the time to update the radius
            return;
        }
	}

    //更新毒圈在游戏内地面上的material
    protected void updateGroundMarker(int id, float radius, Vector3@ center) {
        _log("当前毒圈范围:" + radius);

        // place the marker
        XmlElement command("command");

        command.setStringAttribute("class", "set_marker");
        command.setIntAttribute("id", id);
        command.setIntAttribute("faction_id", 0);
        command.setIntAttribute("atlas_index", 2);
        command.setFloatAttribute("size", 0.5);
        command.setFloatAttribute("range", distance_to_range(radius));
        command.setIntAttribute("enabled", 1);
        command.setStringAttribute("position", center.toString());
        command.setStringAttribute("text", "Center of Electric Zone");
        command.setStringAttribute("type_key", "electric_zone");
        command.setBoolAttribute("show_in_map_view", true);
        command.setBoolAttribute("show_in_game_view", true);
        command.setBoolAttribute("show_at_screen_edge", true);
            
        m_metagame.getComms().send(command);
    }

    protected float range_to_distance(float range) {
        return 1 / 4.0 * range;
    }
    
    protected float distance_to_range(float distance_in_game) {
        return 4.0 * distance_in_game;
    }
    
    //TODO: 更新毒圈在游戏内地图上的material
    protected void updateMapViewMarker(int id, float radius, Vector3@ center) {

    }

    protected void disableMarker(int id) {
        XmlElement command("command");

        command.setStringAttribute("class", "set_marker");
        command.setIntAttribute("id", id);
		command.setIntAttribute("faction_id", 0);
        command.setIntAttribute("enabled", 0);

        m_metagame.getComms().send(command);
    }

    void killAllCharactersOutOfRange(Vector3@ position, float range) {
        _log("开始杀死所有毒圈外玩家...");

        int killed_players = 0;

		for (uint faction_id = 0; faction_id < 3; faction_id++){
			//custom query, collects all soldiers of a faction near target position
			array<const XmlElement@>@ soldiers = getCharacters(m_metagame, faction_id);				
			int s_size = soldiers.length();
			
			//if no target is found, then move on to the next faction
			if (s_size == 0) continue;

            for(int i = 0; i < s_size; i++) {

                Character@ character = @Character(m_metagame, soldiers[i].getIntAttribute("id"));
                
                Vector3@ character_position = @character.position;

                //设置相同高度，计算投影在xy平面上的距离
                position.m_values[1] = center.m_values[1];

                float distance_to_center = getPositionDistance(character_position, center);

                _log("距离毒圈中心距离:" + distance_to_center);

                if(distance_to_center > current_radius) {
                    //Kill
                    XmlElement command("command");

                    command.setStringAttribute("class", "update_character");
                    command.setIntAttribute("id", soldiers[i].getIntAttribute("id"));
                    command.setIntAttribute("dead", 1);
                        
                    m_metagame.getComms().send(command);

                    killed_players++;
                }                
            }         
		}

        if(killed_players == 0) {
            _log("未检测到毒圈外玩家");
        }else {
            _log("已经杀死所有毒圈外玩家,共计:" + killed_players);
        }
    }

    // void killAllCharactersInRange(Vector3@ position, float range) {
    //     _log("开始杀死所有毒圈内玩家...");

    //     int s_size = 0;
	// 	for (uint faction_id = 0; faction_id < 3; faction_id++){
	// 		//custom query, collects all soldiers of a faction near target position
	// 		array<const XmlElement@>@ soldiers = getCharactersNearPosition(m_metagame, position, faction_id, range);				
	// 		s_size = soldiers.length();
			
	// 		//if no target is found, then move on to the next faction
	// 		if (s_size == 0) continue;

    //         for(int i = 0; i < s_size; i++) {
    //             //Kill
    //             XmlElement command("command");

    //             command.setStringAttribute("class", "update_character");
    //             command.setIntAttribute("id", soldiers[i].getIntAttribute("id"));
    //             command.setIntAttribute("dead", 1);
                    
    //             m_metagame.getComms().send(command);
    //         }         
	// 	}
    //     _log("已经杀死所有毒圈内玩家,共计:" + s_size);
    // }

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
