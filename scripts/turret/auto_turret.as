#include "turret.as"
#include "liuhaixv_helpers.as"

final class AutoTurret: Turret {
    //每轮攻击的目标数量
    array<Vector3@>@ enemies = null;
    int max_targets = 4;
    float projectile_speed = 0.7;

    AutoTurret(Metagame@ m_metagame, int owner_id, int vehicle_id, string vehicle_key){
        super(m_metagame, owner_id, vehicle_id, vehicle_key);

        //开火间隔
        fire_interval = 0.0;
        //开火坐标偏移
        @position_offset = @Vector3(0, 12, 0);
    }

    protected void attackEnemiesNearBy(float time_passed){
        timer -= time_passed;
        //如果小于开火间隔
        if(timer > 0) {
            return;
        }

        _log("auto_turret开始攻击附近敌人");
        @enemies = getEnemiesNearBy();

        if(enemies.length() == 0) {
            return;
        }

        for(int i = 0; i < enemies.length() && i < max_targets; i++) {
            Vector3@ direction = normalizeVector3(enemies[i].subtract(this.position));

            this.owner.fire_projectiles("firenade.projectile", this.position.add(position_offset), direction.scale(projectile_speed),"grenade");
        }

        timer = fire_interval;
        //获取最近的敌人
        // Vector3@ nearstEnemy = enemies[0];
        // for(int i = 1, float min_distance = 9999999, float distance; i < enemies.length(); i++) {
        //     distance = getPositionDistance(this.position, enemies[i]);
        //     if(distance < min_distance) {
        //         @nearstEnemy = @enemies[i];
        //         min_distance = distance;
        //     }
        // }
    }
}