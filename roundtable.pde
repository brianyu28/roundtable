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

int numPoints;

PImage[] images;

void setup() {
    numPoints = data.length;

    // load images for points
    images = new PImage[numPoints];
    for (int i = 0; i < numPoints; i++) {
        images[i] = loadImage("img/" + data[i]["image"]);
    }
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

    circleSize = min(80, viewWidth / (numPoints + 3));

    for (int i = 0; i < numPoints; i++) {
        float radius = circleSize + sin((frameCount + 2 * i) / 8);
        float maxRadius = circleSize + 1;
        var item = data[i];
        float proportion = i / (numPoints - 1);
        float[] coords = semicircleCoords(viewWidth, viewHeight, proportion);
        drawPoint(coords, radius, maxRadius, i);
    }
}

void renderMobile() {
    size(viewWidth, viewHeight);
    background(bgColor);
}

void drawPoint(float[] coords, float radius, float maxRadius, int i) {

    // show image
    image(images[i], coords[0] - (radius / 2), coords[1] - (radius / 2), radius, radius);

    // show text
    textAlign(CENTER);
    textFont(labelFont);
    text(data[i]["name"],
        coords[0] - (maxRadius / 2) - horizontalLabelPadding, // x
        coords[1] + (maxRadius / 2) + verticalLabelPadding, // y
        maxRadius + 2 * horizontalLabelPadding,  maxRadius, 1);
}
