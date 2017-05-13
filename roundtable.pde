/*
 * roundtable.pde
 * Brian Yu
 * Crimson Roundtable
 *
 * Roundtable semicircular feature design
 *
 */

void setup() {
}

void draw() {
    size(window.innerWidth, window.innerHeight);
    background(background_color);
    stroke(255, 255, 255);
    radius = base_radius + 2 * sin(frameCount / 8);
    ellipse(width/2, height/2, radius, radius);
}
