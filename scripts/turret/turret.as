#include "helpers.as"
#include "query_helpers.as"

#include "character.as"
//抽象类
abstract class Turret {
    protected Metagame@ m_metagame;

    protected int owner_id;
    protected int vehicle_id;
    protected string vehicle_key;

    //最大的攻击范围
    protected int max_range;
    protected Vector3@ position;
    protected Character@ owner;

    Turret(Metagame@ m_metagame, int owner_id, int vehicle_id, string vehicle_key) {
        @this.m_metagame = m_metagame;
        this.owner_id = owner_id;
        this.vehicle_id = vehicle_id;
        this.vehicle_key = vehicle_key;

        //自动查询玩家信息
        @owner = @Character(m_metagame, owner_id);

        updateTurretPosition();
    }

    protected array<Vector3@> getEnemiesNearBy(){

    }

    protected void attackEnemiesNearBy(){}

    //更新炮台位置
    protected void updateTurretPosition(){
        const XmlElement@ vehicleInfo = getVehicleInfo(m_metagame, vehicle_id);
        if (vehicleInfo !is null) {
            @position = @stringToVector3(vehicleInfo.getStringAttribute("position"));
        } 
    }
}