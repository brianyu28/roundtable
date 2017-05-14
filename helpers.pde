/*
 * helpers.pde
 * Brian Yu
 * Crimson Roundtable
 *
 * Helper functions for roundtable deisng.
 *
 */

// gets the coordiantes of a point on semicircle 
float[] semicircleCoords(float width, float height, float proportion) {

    // origin of the cicle
    float originX = width / 2;
    float originY = height;
    
    // leftmost and rightmost points along semicircle
    float leftmostX = circleSize;
    float leftmostY = semicircleStart * height;
    float rightmostX = width - circleSize;
    
    // angle and distance from origin to leftmost and rightmost angles
    float leftAngle = atan((originY - leftmostY) / (originX - leftmostX));
    float rightAngle = PI - leftAngle;
    float semicircleRadius = dist(originX, originY, leftmostX, leftmostY);

    // compute desired angle
    float desiredAngle = (proportion * (rightAngle - leftAngle)) + leftAngle;

    // compute desired x and y values
    float x = originX - semicircleRadius * cos(desiredAngle);
    float y = originY - semicircleRadius * sin(desiredAngle);
    
    return [x, y];
}

var boundBy(x, lower, upper) {
    if (x < lower)
        return lower;
    else if (x > upper)
        return upper;
    else
        return x;
}
