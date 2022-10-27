#include "log.as"
#include "helpers.as"
#include "query_helpers.as"


// --------------------------------------------
class Character {
    string TagName = "character";

    //系统随机分配的士兵名称，非玩家昵称
    //random name of soilder that player controls, not nickname of player
    string name;
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

    string soldier_group_name;

    int leader;
    //小队规模
    int squad_size;

    //玩家健康状态
    int wounded=0
    int dead=0


	Character(Metagame@ m_metagame, int character_id) {
        this.character_id = character_id;
        @data = getCharacterInfo(m_metagame, character_id);
    }
}

