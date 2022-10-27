#include "tracker.as"
#include "helpers.as"
#include "admin_manager.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"


class TrackingGrenade : Tracker {
	protected Metagame@ m_metagame;
	
	private string notify_script_key = "tracking_grenade";
	// protected array<empdVehicle@> empList;

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

	protected void handleResultEvent(const XmlElement@ event) {		
		//checking if the event was triggered
		string key = event.getStringAttribute("key");
		if (key == notify_script_key) {
			//开始处理tracking_grenade事件:TagName=result_event character_id=105 direction=-0.969464 -0.227791 0.0908327 key=tracking_grenade position=861.832 16.9094 572.977 
            _log("开始处理tracking_grenade事件:" + event.toString());
		} else {
			return;
		}
    }

	void update(float time) {
		//updating the timer on all tracked vehicles
		// for (uint i = 0; i < empList.length() ; ++i) {		
		// 	empList[i].m_timer -= time;
			
		// 	if (empList[i].m_timer < 0){
		// 		unlockVehicle(m_metagame, empList[i].m_id);
				
		// 		empList.removeAt(i);
		// 		--i;
		// 	}
		// }
	}

    
    // void getEnemiesInRange(int friendlyFactionId, float range) {
	// 	//extracting data
	// 	int factionId = AC130Request.m_factionId;
	// 	Vector3 targetPos;
		
	// 	//randomizing faction order, so that the AC130 won't always prioritize targeting one faction over an another
	// 	array<int> fRandomized = indexRandomizer(4, factionId);
	
	// 	//scanning for a target
	// 	for (uint f = 0; f < 3; ++f){
	// 		//custom query, collects all soldiers of a faction near target position
	// 		array<const XmlElement@>@ soldiers = getCharactersNearPosition(m_metagame, targetPos, fRandomized[f], range);				
	// 		int s_size = soldiers.length();
			
	// 		//if no target is found, then move on to the next faction
	// 		if (s_size == 0) continue;
			
	// 		//randomly selecting a soldier
	// 		int s_i = rand(0,soldiers.length()-1);
	// 		int soldier_id = soldiers[s_i].getIntAttribute("id");

	// 		//extracting the targeted soldier's position
	// 		const XmlElement@ character = getCharacterInfo(m_metagame, soldier_id);
	// 		if (character !is null) {
	// 			string soldierPos = character.getStringAttribute("position");
	// 			return soldierPos;
	// 		}
	// 	}
		
	// 	//if no valid target is found at all, then we return this message
	// 	return "no_target";
    // }
}