#include "log.as"
#include "helpers.as"
#include "query_helpers.as"

#include "create_instance.as"


// --------------------------------------------
class Character {
    protected Metagame@ m_metagame;
    protected const XmlElement@ data;

    private initialized = false;
    
    //-------------------------------------------------------

    string TagName = "character";

    //系统随机分配的士兵名称，非玩家昵称
    //random name of soilder that player controls, not nickname of player
    string name;
    string soldier_group_name;
    //玩家区块位置，如3 4
    string block;
    Vector3@ position;

    //阵营id
    int faction_id;
    //实例id,同character_id
    int id=105;
    //玩家列表中的id
    int player_id=0;

    int rp;
    int xp;

    int leader;
    //小队规模
    int squad_size;

    //玩家健康状态
    int wounded=0;
    int dead=0;


	Character(Metagame@ m_metagame, int character_id, bool init=true) {
        @this.m_metagame = m_metagame;
        if(init) {
            @this.data = getCharacterInfo(m_metagame, character_id);
            // _log(this.data.toString());
            initFromData(@this.data);
            initialized = true;
        }        
    }

    void updateFromData(const XmlElement@ data) {
        initFromData(data);
    }

    void initFromData(const XmlElement@ data) {
        this.name = data.getStringAttribute("name");
        this.soldier_group_name = data.getStringAttribute("soldier_group_name");

        this.block = data.getStringAttribute("block");
        @this.position = stringToVector3(data.getStringAttribute("position"));

        this.faction_id = data.getIntAttribute("faction_id");
        this.id = data.getIntAttribute("id");

        this.player_id = data.getIntAttribute("player_id");
        this.rp = data.getIntAttribute("rp");
        this.xp = data.getIntAttribute("xp");
        this.leader = data.getIntAttribute("leader");
        this.squad_size = data.getIntAttribute("squad_size");
        this.wounded = data.getIntAttribute("wounded");
        this.dead = data.getIntAttribute("dead");
    }

    //获取在某坐标范围内的敌人坐标
    array<Vector3@> getEnemiesTargets(Vector3@ position, float range, uint maxTotalNum = 9999) {
        if(!initialized) {
            array<Vector3@> empty;
            return empty;
        }

        //array of character's id
        array<const XmlElement@> foundSoldiers;
		for (int i = 0; i < 3; i++){
            //跳过友军目标
            if(i == faction_id) {
                continue;                
            }

			//custom query, collects all soldiers of a faction near target position
			array<const XmlElement@>@ soldiers = getCharactersNearPosition(m_metagame, position, i, range);				
			int s_size = soldiers.length();
			
            for(int i = 0; i < soldiers.length() && i < maxTotalNum; i++) {
                foundSoldiers.insertLast(soldiers[i]);
            }
		}

        array<Vector3@> positions;
        for(int i = 0; i < foundSoldiers.length(); i++) { 
			int soldier_id = foundSoldiers[i].getIntAttribute("id");
			//extracting the targeted soldier's position
			const XmlElement@ character = getCharacterInfo(m_metagame, soldier_id);

			if (character !is null) {
				string soldierPos = character.getStringAttribute("position");
                Vector3@ positionOfSoldier = stringToVector3(soldierPos);
                positions.insertLast(positionOfSoldier);
			}
        }
        return positions;
	}

    //发射
    void fire_projectiles(string instance_key, Vector3@ position, Vector3@ offset = Vector3(0, 0, 0), string instance_class = "grenade") {
        if(!initialized){
            return;
        }
        CreateInstance@ create_instance = CreateInstance(this.faction_id, this.id, instance_class, instance_key, position, offset);
        m_metagame.getComms().send(create_instance.toString());
    }
    
    void updateCharacter() {
        @this.data = getCharacterInfo(m_metagame, id);
        // _log(this.data.toString());
        updateFromData(@this.data);
    }
}