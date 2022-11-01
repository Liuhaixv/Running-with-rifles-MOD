// internal
#include "tracker.as"
#include "helpers.as"
#include "admin_manager.as"
#include "log.as"
#include "query_helpers.as"
#include "generic_call_task.as"
#include "task_sequencer.as"

// --------------------------------------------
class SpawnCommandHandler : Tracker {
	protected Metagame@ m_metagame;

	// --------------------------------------------
	SpawnCommandHandler(Metagame@ metagame) {
		@m_metagame = @metagame;
	}
	
	//生成实体
    //如$hand_grenade.projectile， 生成手雷在附近
	protected void handleChatEvent(const XmlElement@ event) {
		// player_id
		// player_name
		// message
		// global

		string message = event.getStringAttribute("message");
		// for the most part, chat events aren't commands, so check that first 
		if (!startsWith(message, "$") || message.length() <= 1) {
			return;
		}

		string sender = event.getStringAttribute("player_name");
		int senderId = event.getIntAttribute("player_id");

		// admin and moderator only from here on
		if (!m_metagame.getAdminManager().isAdmin(sender, senderId) && !m_metagame.getModeratorManager().isModerator(sender, senderId)) {
			return;
		}

        //获取最后一个"."的位置
        int instanceClassIndex = message.findLast(".");
        if(instanceClassIndex < 0 || instanceClassIndex >= message.length() - 1) {
            return;
        }

        //实例类
        string instanceClass = message.substr(instanceClassIndex + 1);

		if(instanceClass == "turret") {
			instanceClass = "vehicle";
		}

        //截取$后所有字符
        string instanceStr = message.substr(1);

        _log("生成实例:" + instanceStr + " class: " + instanceClass);
        spawnInstanceNearPlayer(senderId, instanceStr, instanceClass);            
    } 

	// --------------------------------------------
	bool hasEnded() const {
		// always on
		return false;
	}

	// --------------------------------------------
	bool hasStarted() const {
		// always on
		return true;
	}
	
	
	// ----------------------------------------------------
	protected void spawnInstanceNearPlayer(int senderId, string key, string type, int factionId = 0, bool skydive = false) {
		const XmlElement@ playerInfo = getPlayerInfo(m_metagame, senderId);
		if (playerInfo !is null) {
			const XmlElement@ characterInfo = getCharacterInfo(m_metagame, playerInfo.getIntAttribute("character_id"));
			if (characterInfo !is null) {
				Vector3 pos = stringToVector3(characterInfo.getStringAttribute("position"));
				pos.m_values[0] += 5.0;
				if (skydive) {
					pos.m_values[1] += 50.0;
				}
				string c = "<command class='create_instance' instance_class='" + type + "' activated='"+ "0" + "' instance_key='" + key + "' position='" + pos.toString() + "' faction_id='" + factionId + "' />";
				m_metagame.getComms().send(c);
			}
		}
	}
}
