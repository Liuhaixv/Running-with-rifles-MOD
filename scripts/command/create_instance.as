#include "log.as"
#include "helpers.as"
// #include "query_helpers.as"

class CreateInstance {
    int faction_id;
    int character_id;
    //vehicle, grenade, projectile
    string instance_class;
    //注册的key值，如emp_blast.projectile
    string instance_key;
    //生成实例的坐标
    Vector3@ position;
    //生成实例的初速
    Vector3@ offset;

    //是否被激活，例如手雷如果被激活的话生成时会爆炸，未激活的话可以被捡起来
    int activated = 1;

    CreateInstance(int faction_id, int character_id, string instance_class, string instance_key, Vector3@ position,Vector3@ offset) {
        this.faction_id = faction_id;
        this.character_id = character_id;
        this.instance_class = instance_class;
        this.instance_key = instance_key;
        @this.position = @position;
        @this.offset = @offset;
    }

    string toString() {
        string c = 
				"<command class='create_instance'" +
				" faction_id='" + faction_id + "'" +
				" instance_class='"+ instance_class + "'" +
				" instance_key='" + instance_key + "'" +
				" position='" + position.toString() + "'" +
				" character_id='" + character_id + "'" +
				" activated='" + activated + "'" +
				" offset='" + offset.toString() + "' />";
        return c;
    }
}