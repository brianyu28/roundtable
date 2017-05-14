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
    float leftmostY = (1/2) * height;
    float rightmostX = width - circleSize;

    float semicircleRadius = dist(originX, originY, leftmostX, leftmostY);
    
    // compute desired x value
    float x = (proportion * (rightmostX - leftmostX)) + leftmostX;

    // y = sqrt(r^2 - (x - x1)^2) + y1
    float y = -sqrt(pow(semicircleRadius, 2) - pow(x - originX, 2)) + originY;

    return [x, y];
}
