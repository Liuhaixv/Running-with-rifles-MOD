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

    CreateInstance(int faction_id, int character_id, string instance_class, string instance_key, Vector3@ position,Vector3@ offset) {
        this.faction_id = faction_id;
        this.character_id = character_id;
        this.instance_class = instance_class;
        this.instance_key = instance_key;
        @this.position = @position;
        @this.offset = @offset;
    }

    //TODO:创建toString()方法，方便调用
    string toString() {
        
    }
}