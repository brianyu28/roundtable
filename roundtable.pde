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
int circleSize;
int maxRadius;
int selectedIndex = -1;

int numPoints;

int[] centers_x;
int[] centers_y;

PImage[] images;

void setup() {
    updateSize();
    numPoints = data.length;
    centers_x = new int[numPoints];
    centers_y = new int[numPoints];

    // load images for points
    images = new PImage[numPoints];
    for (int i = 0; i < numPoints; i++) {
        images[i] = loadImage("img/" + data[i]["image"]);
    }

    // determine locations for points
    circleSize = min(80, viewWidth / (numPoints + 3));
    maxRadius = circleSize + 1;
    for (int i = 0; i < numPoints; i++) {
        float proportion = i / (numPoints - 1);
        float[] coords = semicircleCoords(viewWidth, viewHeight, proportion);
        centers_x[i] = coords[0];
        centers_y[i] = coords[1];
    }
}

void updateSize() {
    int curWidth = min(window.innerWidth, maxWidth);
    viewWidth = curWidth;
    viewHeight = viewWidth / aspectRatio;
}

void draw() {
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


    for (int i = 0; i < numPoints; i++) {
        float radius = circleSize + sin((frameCount + 2 * i) / 8);
        drawPoint(i, radius);
    }
}

void renderMobile() {
    size(viewWidth, viewHeight);
    background(bgColor);
}

void drawPoint(int i, float radius) {
    
    int additionalVerticalPadding = 0;

    // show glow
    if (i == selectedIndex) {
        float glowRadius = radius + glowSize;
        fill(yellow, 0);
        for (int j = 0; j < glowRadius; j++) {
            stroke(yellow, 255.0 * (1 - j / glowRadius));
            ellipse(centers_x[i], centers_y[i], j, j);
        }
        additionalVerticalPadding += glowSize / 2;
    }
    // show image
    image(images[i], centers_x[i] - (radius / 2), centers_y[i] - (radius / 2), radius, radius);

    // show text
    textAlign(CENTER);
    textFont(labelFont);
    fill(white);
    text(data[i]["name"],
        centers_x[i] - (maxRadius / 2) - horizontalLabelPadding, // x
        centers_y[i] + (maxRadius / 2) + verticalLabelPadding + additionalVerticalPadding, // y
        maxRadius + 2 * horizontalLabelPadding,  maxRadius, 1);

}

void mousePressed() {
    // check if inside of any circle
    for (int i = 0; i < numPoints; i++) {
        if (pow(mouseX - centers_x[i], 2) + pow(mouseY - centers_y[i], 2) <= pow(maxRadius, 2)) {
            selectedIndex = i;
            break;
        }
    }
}
