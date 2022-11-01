#include "tracker.as"
#include "helpers.as"
#include "admin_manager.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"

#include "character.as"


class TrackingGrenade : Tracker {
	protected Metagame@ m_metagame;
	private string notify_script_key = "tracking_grenade";

	//跟踪手雷爆炸时跟踪的范围
	private float trackingRange = 35;
	//跟踪手雷发射的子雷数量限制
	private int maxNumOfChildGrenades = 5;
	//子雷的速度
	private float speedOfChildGrenades = 1.2;
	//子雷的注册名
	private string childGrenadeKeyName = "firenade.projectile";

	TrackingGrenade(Metagame@ metagame) {
		@m_metagame = @metagame;
	}
    
	bool hasEnded() const {
		// always on
		return false;
	}
    
	bool hasStarted() const {
		return true;
	}

	void update(float time) {
	}
	
	protected void handleResultEvent(const XmlElement@ event) {		
		//checking if the event was triggered
		string key = event.getStringAttribute("key");
		if (key == notify_script_key) {
			//开始处理tracking_grenade事件:TagName=result_event character_id=105 direction=-0.969464 -0.227791 0.0908327 key=tracking_grenade position=861.832 16.9094 572.977 
            _log("开始处理tracking_grenade事件:" + event.toString());

			int character_id = event.getIntAttribute("character_id");
			Character@ character = Character(m_metagame, character_id);
			//爆炸的位置
			string position_str = event.getStringAttribute("position");
			if(position_str.isEmpty()) return;
			Vector3@ position = stringToVector3(position_str);

			//character的xml数据数组
			//获取爆炸位置附近的所有敌人
			array<Vector3@>@ enemies = character.getEnemiesTargets(position, trackingRange, maxNumOfChildGrenades);

			//对每一个敌人发射子雷
			for(uint i = 0; i < enemies.length() && i < maxNumOfChildGrenades; i++) {
				Vector3@ enemyPosition = enemies[i];
				//计算敌人的方向
				Vector3@ direction = enemyPosition.subtract(position);		
				_log("方向归一化前:" + direction.toString());
				@direction = normalizeVector3(direction);				
				_log("方向方向归一化后:" + direction.toString());

				//速度
				Vector3@ offset = direction.scale(speedOfChildGrenades);
				_log("速度:" + offset.toString());

				character.fire_projectiles(childGrenadeKeyName, position, offset);
			}
		} else {
			return;
		}
    }

	//归一化向量，用于表示方向时使用
	private Vector3@ normalizeVector3(Vector3@ vector3) {
		//单位向量等于向量乘（模的倒数）
		return vector3.scale(1.0 / getPositionDistance(Vector3(0, 0, 0), vector3));
	}

	//test
	//在position处生成手雷
	private void generate_grenade(Vector3 position, int faction_id, int character_id) {

		//生成实例

		//写法1
		// string c = 
		// 	"<command class='create_instance'" +
		// 	" faction_id='" + factionId + "'" +
		// 	" character_id='" + characterId + "'" +
		// 	" instance_class='grenade'" +
		// 	" instance_key='" + instanceKey + "'" +
		// 	" position='" + position.toString() + "'" +
		// 	" offset='" + projectileSpeed.toString() + "' />";
		//
		// m_metagame.getComms().send(c);

		//写法2
		XmlElement command("command");

		command.setStringAttribute("class", "create_instance");

		command.setIntAttribute("faction_id", faction_id);
		command.setIntAttribute("character_id", character_id);

		command.setStringAttribute("instance_class", "projectile");
		command.setStringAttribute("instance_key", "stun_grenade.projectile");

		command.setStringAttribute("position", position.toString());
		command.setStringAttribute("offset", Vector3(0, 0.1, 0).toString());
		m_metagame.getComms().send(command);
	}
}