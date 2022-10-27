#include "log.as"
#include "helpers.as"
#include "query_helpers.as"


// --------------------------------------------
class Character {
    const XmlElement@ data;

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


	Character(Metagame@ m_metagame, int character_id) {
        @this.data = getCharacterInfo(m_metagame, character_id);
        // _log(this.data.toString());
        init_from_data(@this.data);
    }

    void init_from_data(const XmlElement@ data) {
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
}