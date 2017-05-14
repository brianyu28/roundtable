/*
 * constants.pde
 * Brian Yu
 * Crimson Roundtable
 *
 * Constants for use in roundtable design.
 *
 */

/* @pjs font="fonts/Merriweather-Regular.ttf"; */

// basic colors
color crimson = color(168, 41, 49);
color blue1 = color(0, 78, 106);
color blue2 = color(119, 153, 183);
color blue3 = color(176, 207, 231);
color green = color(41, 136, 72);
color yellow = color(219, 211, 0);
color white = color(255, 255, 255);

// fonts
PFont labelFont = createFont("fonts/Merriweather-Regular.ttf", 12);
PFont headlineFont = createFont("fonts/Merriweather-Regular.ttf", 36);
PFont descriptionFont = createFont("fonts/Merriweather-Regular.ttf", 16);

// color assignments
color bgColor = crimson;

// size constants
int maxWidth = 1000;
int mobileThreshold = 450;
float aspectRatio = 5/3;
float semicircleStart = 1/2; // semicircle starts 1/2 way down view

int horizontalLabelPadding = 15;
int verticalLabelPadding = 10;
int glowSize = 40;

int detailHeadPadding = 30;
int detailHeadHeight = 90;

// strings
String instructions = "Click on a person above to see details.";
