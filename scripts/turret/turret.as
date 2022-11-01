#include "helpers.as"
#include "query_helpers.as"

#include "character.as"
//抽象类
abstract class Turret {
    protected Metagame@ m_metagame;

    int owner_id;
    int vehicle_id;
    string vehicle_key;

    //最大的攻击范围
    //Turret can only attack enemies within distance of max_range
    protected float max_range;
    protected Vector3@ position;
    protected Character@ owner;

    //开火坐标偏移
    protected Vector3@ position_offset = @Vector3(0, 0, 0);

    //上一次开火的时间
    float last_fired_time = -1;
    //开火间隔
    float fire_interval = 5;
    float timer = fire_interval;

    Turret(Metagame@ m_metagame, int owner_id, int vehicle_id, string vehicle_key) {
        @this.m_metagame = m_metagame;
        this.owner_id = owner_id;
        this.vehicle_id = vehicle_id;
        this.vehicle_key = vehicle_key;

        //自动查询玩家信息
        @owner = @Character(m_metagame, owner_id);
        _log("炮台已创建, faction_id:" + owner.faction_id + ", owner_id:" + owner.id);

        updateTurretPosition();
    }

    //获取炮台附近的敌人坐标
    //Get enemies' positions near the turret
    protected array<Vector3@> getEnemiesNearBy(){
        return owner.getEnemiesTargets(position, max_range);
    }

    //更新炮台位置
    void updateTurretPosition(){
        const XmlElement@ vehicleInfo = getVehicleInfo(m_metagame, vehicle_id);
        if (vehicleInfo !is null) {
            @position = @stringToVector3(vehicleInfo.getStringAttribute("position"));
        } 
    }

    //更新开火时间
    void updateLastFireTime(float time){
        this.last_fired_time = time;
    }

    //Override
    void attackEnemiesNearBy(float time_passed){
        _log("[ERR]请先实现attackEnemiesNearBy方法!");
    }
}