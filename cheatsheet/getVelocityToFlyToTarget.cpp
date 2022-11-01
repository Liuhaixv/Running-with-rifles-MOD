Vector3 getVelocityToFlyToTarget(Vector3@ target, Vector3@ source, float initialSpeed, float g, bool smaller, bool normalise) {
    // Calculate direction to target point
    Vector3 direction = target - source;

    // This is our target height
    float y = direction.y;

    // We won't be needing y component over here anymore
    direction.y = 0;

    float v = initialSpeed;
    float x = direction.length();

    if (x < 0.001f) {
        // ensure x is at least something
        x = 0.001f;
    }

    float sq = pow(v, 4) - g * (g * x * x + 2 * y * v * v);
    if(sq <= 0) {
        sq = 0.1f;
    }

    float inner = sqrt(sq);
    float root1 = (pow(v,2) + inner) / (g * x);
    float root2 = (pow(v,2) - inner) / (g * x);

    float angle0 = atan(root1);
    float angle1 = atan(root2);

    float theta(0.0f);
    if (smaller) {
        // Get smaller one
        theta = angle0 < angle1 ? angle0 : angle1;
    } else {
        // use the greater one
        theta = angle0 > angle1 ? angle0 : angle1;
    }

    // This is the direction we're going to shoot, with an angle of theta
    // -> get the height for this vector using the angle (basic trigonometry of 90deg triangle)
    direction.y = tan(theta) * x;

    if (normalise) {
        // Set length to initial speed
        direction.normalise();
        direction *= v;
    }

    return direction;
}
// g is -pulldown

/*

Ogre::Vector3 getVelocityToFlyToTarget(const Ogre::Vector3& target, const Ogre::Vector3& source, Ogre::Real initialSpeed, Ogre::Real g, bool smaller, bool normalise) {
    // Calculate direction to target point
    Ogre::Vector3 direction = target - source;

    // This is our target height
    Ogre::Real y = direction.y;

    // We won't be needing y component over here anymore
    direction.y = 0;

    Ogre::Real v = initialSpeed;
    Ogre::Real x = direction.length();

    if (x < 0.001f) {
        // ensure x is at least something
        x = 0.001f;
    }

    Ogre::Real sq = pow(v, 4) - g * (g(xx) + 2 * y(vv));
    if(sq <= 0) {
        sq = 0.1f;
    }

    Ogre::Real inner = sqrt(sq);
    Ogre::Real root1 = (pow(v,2) + inner) / (gx);
    Ogre::Real root2 = (pow(v,2) - inner) / (gx);

    Ogre::Real angle0 = atan(root1);
    Ogre::Real angle1 = atan(root2);

    Ogre::Real theta(0.0f);
    if (smaller) {
        // Get smaller one
        theta = angle0 < angle1 ? angle0 : angle1;
    } else {
        // use the greater one
        theta = angle0 > angle1 ? angle0 : angle1;
    }

    // This is the direction we're going to shoot, with an angle of theta
    // -> get the height for this vector using the angle (basic trigonometry of 90deg triangle)
    direction.y = tan(theta) * x;

    if (normalise) {
        // Set length to initial speed
        direction.normalise();
        direction *= v;
    }

    return direction;
}
g is -pulldown


*/