/*
 * roundtable.pde
 * Brian Yu
 * Crimson Roundtable
 *
 * Roundtable semicircular feature design
 *
 */

int viewWidth = 0;
int viewHeight = 0;
int circleSize = 80;

void setup() {
    println(semicircleCoords(1000, 600, 0.5));
}

void draw() {
    // get current width and height
    int curWidth = min(window.innerWidth, maxWidth);
    viewWidth = curWidth;
    viewHeight = viewWidth / aspectRatio;
    
    // determine whether to render as desktop or mobile
    if (viewWidth <= mobileThreshold)
        renderMobile();
    else
        renderDesktop();
}

void renderDesktop() {
    size(viewWidth, viewHeight);
    background(bgColor);
    stroke(255, 255, 255);
    
    float radius = circleSize + 2 * sin(frameCount / 8);

    int count = 8;
    for (int i = 0; i <= count; i++) {
        float proportion = i / count;
        float[] coords = semicircleCoords(viewWidth, viewHeight, proportion);
        
        ellipse(coords[0], coords[1], radius, radius);
    }
//    ellipse(viewWidth/2, viewHeight/2, radius, radius);
}

void renderMobile() {
    size(viewWidth, viewHeight);
    background(bgColor);
}
