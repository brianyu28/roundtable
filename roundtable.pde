/*
 * roundtable.pde
 * Brian Yu
 * Crimson Roundtable
 *
 * Roundtable semicircular feature design
 *
 */

// view variables
int viewWidth = 0;
int viewHeight;
int detailWidth;
int detailHeight;
int detailX;
int detailY;

// circle variables
int numPoints;
int circleSize;
int maxRadius;
int selectedIndex = -1;
int[] centers_x;
int[] centers_y;
PImage[] images;

void setup() {
    numPoints = data.length;
    centers_x = new int[numPoints];
    centers_y = new int[numPoints];
    updateSize();

    // load images for points
    images = new PImage[numPoints];
    for (int i = 0; i < numPoints; i++) {
        images[i] = loadImage("img/" + data[i]["image"]);
    }
}

void updateSize() {
    int curWidth = min(window.innerWidth, maxWidth);
    if (curWidth == viewWidth) {
        return;
    }

    viewWidth = curWidth;
    viewHeight = viewWidth / aspectRatio;

    // determine locations for points
    circleSize = min(80, viewWidth / (numPoints + 3));
    maxRadius = circleSize + 1;
    for (int i = 0; i < numPoints; i++) {
        float proportion = i / (numPoints - 1);
        float[] coords = semicircleCoords(viewWidth, viewHeight, proportion);
        centers_x[i] = coords[0];
        centers_y[i] = coords[1];
    }

    // determine detail view location
    float mainRadius = dist(viewWidth / 2, viewHeight, circleSize, semicircleStart * viewHeight);
    detailHeight = mainRadius * sin(PI / 4);
    detailWidth = detailHeight * 2;
    detailX = (viewWidth / 2) - detailHeight;
    detailY = viewHeight - detailHeight;
}

void draw() {
    updateSize();

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

    showDetail();
}

void renderMobile() {
    size(viewWidth, viewHeight);
    background(bgColor);
}

int currentGlowSize = 0;
void drawPoint(int i, float radius) {
    
    int additionalVerticalPadding = 0;

    // show glow
    if (i == selectedIndex) {
        if (currentGlowSize < glowSize)
            currentGlowSize += 2;
        float glowRadius = radius + currentGlowSize;
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
            if (selectedIndex != i) {
                currentGlowSize = 0;
                selectedIndex = i;
                break;
            }
        }
    }
}

void showTitle() {

    // show main headline
    textAlign(CENTER);
    int headlineFontSize = boundBy(11 + (viewWidth / 40.0), 11, 36);
    textFont(headlineFont, headlineFontSize);
    text(roundtableTitle,
        detailX + detailHeadPadding,
        detailY + 0.3 * detailHeight,
        detailWidth - 2 * detailHeadPadding,
        0.7 * detailHeight, 1);

    // show instructions
    textAlign(CENTER);
    textFont(descriptionFont);
    text(instructions,
        detailX + detailHeadPadding,
        detailY + 0.7 * detailHeight,
        detailWidth - 2 * detailHeadPadding,
        0.3 * detailHeight, 1);
}

void showDetail() {
    if (selectedIndex == -1) {
        showTitle();
        return;
    }
    
    int headlineFontSize = boundBy(11 + (viewWidth / 40.0), 11, 36);
    
    // show person's name
    String name = data[selectedIndex]["name"];
    textAlign(CENTER);
    textFont(headlineFont, headlineFontSize);
    fill(white);
    text(name, detailX,
        detailY + detailHeadPadding,
        detailWidth,
        50,
        1);

    // show person's image
    float imgX = detailX + detailHeadPadding;
    float imgY = detailY + boundBy(23 + (viewWidth / 15), 40, 90);
    float imgWidth = 0.3 * detailWidth;
    float imgHeight = imgWidth;
    image(images[selectedIndex], imgX, imgY, imgWidth, imgHeight);

    // show description
    String description = data[selectedIndex]["description"];
    textAlign(LEFT);
    textFont(descriptionFont);
    fill(white);
    text(description,
        imgX + 0.4 * detailWidth,
        imgY,
        0.5 * detailWidth,
        imgHeight, 1);

}
