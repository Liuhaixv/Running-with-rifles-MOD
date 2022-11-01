#include "helpers.as"

//归一化向量，用于表示方向时使用
Vector3@ normalizeVector3(Vector3@ vector3) {
    //单位向量等于向量乘（模的倒数）
    return vector3.scale(1.0 / getPositionDistance(Vector3(0, 0, 0), vector3));
}

//通过初速率和g加速度计算到达目标的速度向量
//Provided by @AmeMliky
//Added by @Liuhaixv
Vector3@ getVelocityToFlyToTarget(Vector3@ target, Vector3@ source, float initialSpeed, float g, bool smaller, bool normalise = true) {
    // Calculate direction to target point
    Vector3@ direction = target.subtract(source);

    // This is our target height
    float y = direction.get_opIndex(1);

    // We won't be needing y component over here anymore
    direction.m_values[1] = 0;

    float v = initialSpeed;
    float x = getPositionDistance(Vector3(0, 0, 0), direction);

    if (x < 0.001f) {
        // ensure x is at least something
        x = 0.001f;
    }

    float sq = pow(v, 4) - g * (g*(x*x) + 2 * y*(v*v));
    if(sq <= 0) {
        sq = 0.1f;
    }

    float inner = sqrt(sq);
    float root1 = (pow(v,2) + inner) / (g*x);
    float root2 = (pow(v,2) - inner) / (g*x);

    float angle0 = atan(root1);
    float angle1 = atan(root2);

    float theta = 0.0f;
    if (smaller) {
        // Get smaller one
        theta = angle0 < angle1 ? angle0 : angle1;
    } else {
        // use the greater one
        theta = angle0 > angle1 ? angle0 : angle1;
    }

    // This is the direction we're going to shoot, with an angle of theta
    // -> get the height for this vector using the angle (basic trigonometry of 90deg triangle)
    direction.m_values[1] = tan(theta) * x;

    if (normalise) {
        // Set length to initial speed
        @direction = @normalizeVector3(direction);
        @direction = direction.scale(v);
    }

    return direction;
}