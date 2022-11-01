#include "helpers.as"

//归一化向量，用于表示方向时使用
Vector3@ normalizeVector3(Vector3@ vector3) {
    //单位向量等于向量乘（模的倒数）
    return vector3.scale(1.0 / getPositionDistance(Vector3(0, 0, 0), vector3));
}