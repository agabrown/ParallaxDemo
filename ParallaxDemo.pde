/**
 * Recreate the nice demo of parallax that was available from ESA. The ESA version was
 * implemented in Flash which is no longer supported.
 *
 * The drawing is laid out for a 16:9 screen/image format.
 *
 * Anthony Brown Jan 2017
 */

import java.text.DecimalFormat;

int rotationPhase = 0;
int rotationSense = -1;

float sunRadius;
float sunX = 0;
float sunY = 0;
float sunZ = 0;

float starX;
float starY;
float starZ;
float starZMin;
float starZMax;
float starPointSize;
float starCornerSize;

float earthRadius;
float earthOrbitRadius;
float earthX;
float earthY;
float earthZ = 0;

float lineOfSightLength;

float skyProjectionCenX, skyProjectionCenY;
float skyProjectionBoxX, skyProjectionBoxY;
float skyProjectionBoxW, skyProjectionBoxH;
float skyProjectionBoxTextH;
float varpi, varpiRadius;

float[] fieldStarX;
float[] fieldStarY;
float[] fieldStarX2D;
float[] fieldStarY2D;
float fieldStarRadius;

PShape star;
PShape star2D;
PShape sun;
PShape earth;

HorizontalScrollBar scrollbar;

int sizeUnit;
float sceneRotAngle = radians(70);

DecimalFormat formatter;

void setup() {
  size(960, 540, P3D);
  //fullScreen(P3D);
  sizeUnit = width/16;
  frameRate(60);
  ellipseMode(RADIUS);

  scrollbar = new HorizontalScrollBar(10.5*sizeUnit, height-sizeUnit*3/8, 5*sizeUnit, sizeUnit/4);

  sunRadius = sizeUnit/3.0;
  starPointSize = sizeUnit/4.0;
  starCornerSize = starPointSize/5.0;
  earthRadius = sizeUnit/4.0;
  earthOrbitRadius = sizeUnit*3.0;
  starZMin = 2.5*sizeUnit;
  starZMax = 5*sizeUnit;
  lineOfSightLength = sqrt(pow(earthOrbitRadius, 2) + pow(starZMax, 2))*1.1;
  skyProjectionBoxX = 10.1*sizeUnit;
  skyProjectionBoxY = 0.1*sizeUnit;
  skyProjectionBoxW = 5.8*sizeUnit;
  skyProjectionBoxH = 4.8*sizeUnit;
  skyProjectionBoxTextH = 1.1*sizeUnit;
  skyProjectionCenX = skyProjectionBoxX + skyProjectionBoxW/2;
  skyProjectionCenY = skyProjectionBoxY + (skyProjectionBoxH + skyProjectionBoxTextH)/2;
  varpiRadius = (skyProjectionBoxH - skyProjectionBoxTextH - 0.6*sizeUnit)/(2*sizeUnit);

  fieldStarRadius = sizeUnit/10;
  fieldStarX = new float[10];
  fieldStarY = new float[10];
  fieldStarX2D = new float[10];
  fieldStarY2D = new float[10];
  float u;
  randomSeed(3141592653l);
  for (int i=0; i<10; i++) {
    u = random(0, 1);
    fieldStarX[i] = round(0.5*sizeUnit+9.0*sizeUnit*u);
    fieldStarX2D[i] = round(skyProjectionBoxX+0.2*sizeUnit + u*(skyProjectionBoxW-0.4*sizeUnit));
    fieldStarY[i] = random(round(0.25*sizeUnit), round(1.5*sizeUnit));
  }
  for (int i=0; i<10; i++) {
    fieldStarY2D[i] = random(round(skyProjectionBoxY+skyProjectionBoxTextH+0.2*sizeUnit), round(skyProjectionBoxY+skyProjectionBoxH-0.2*sizeUnit));
  }

  /*
   * Create Earth shape, make sure to specify here already that stroke and fill are
   * not needed.
   */
  noStroke();
  noFill();
  earth = createShape(SPHERE, earthRadius);
  earth.setTexture(loadImage("world32k.jpg"));

  /*
   * Create Sun shape.
   */
  noStroke();
  noFill();
  sun = createShape(SPHERE, sunRadius);
  sun.setTexture(loadImage("texture_sun.jpg"));

  /*
   * Create star shape.
   */
  fill(color(#FFFFFF));
  star = createShape();
  star.beginShape();
  star.vertex(starPointSize, 0, 0);
  star.vertex(starCornerSize, -starCornerSize, 0);
  star.vertex(0, -starPointSize, 0);
  star.vertex(-starCornerSize, -starCornerSize, 0);
  star.vertex(-starPointSize, 0, 0);
  star.vertex(-starCornerSize, starCornerSize, 0);
  star.vertex(0, starPointSize, 0);
  star.vertex(starCornerSize, starCornerSize, 0);
  star.noStroke();
  star.endShape(CLOSE);

  /*
   * Create 2D star shape for the sky projection.
   */
  fill(color(#F5DF52));
  star2D = createShape();
  star2D.beginShape();
  star2D.vertex(starPointSize, 0);
  star2D.vertex(starCornerSize, -starCornerSize);
  star2D.vertex(0, -starPointSize);
  star2D.vertex(-starCornerSize, -starCornerSize);
  star2D.vertex(-starPointSize, 0);
  star2D.vertex(-starCornerSize, starCornerSize);
  star2D.vertex(0, starPointSize);
  star2D.vertex(starCornerSize, starCornerSize);
  star2D.noStroke();
  star2D.endShape(CLOSE);

  /*
   * Use orthographic projection to simplify having a 3D scene and 2D GUI next to each other.
   */
  ortho();

  formatter = new DecimalFormat();
  formatter.applyPattern("0.0");
  formatter.setMaximumFractionDigits(3);
}

void draw() {
  rotationPhase = (rotationPhase+1)%360;
  background(0);

  pushStyle();
  fill(0);
  stroke(#CCCCCC);
  rect(skyProjectionBoxX, skyProjectionBoxY, skyProjectionBoxW, skyProjectionBoxH);
  popStyle();

  pushStyle();
  fill(#FFFFFF);
  noStroke();
  for (int i=0; i<fieldStarX.length; i++) {
    ellipse(fieldStarX[i], fieldStarY[i], fieldStarRadius, fieldStarRadius);
    ellipse(fieldStarX2D[i], fieldStarY2D[i], fieldStarRadius, fieldStarRadius);
  }
  popStyle();

  scrollbar.update();
  scrollbar.display();

  pushStyle();
  fill(#FFFFFF);
  textSize(0.3*sizeUnit);
  textAlign(LEFT, TOP);
  text("Apparent position of the closer star", skyProjectionBoxX+0.2*sizeUnit, skyProjectionBoxY+0.2*sizeUnit);
  text("with respect to the distant stars", skyProjectionBoxX+0.2*sizeUnit, skyProjectionBoxY+0.6*sizeUnit);
  text("Distance: "+formatter.format(scrollbar.getPos()*9.0+1.0)+" lightyear", 11*sizeUnit, height-sizeUnit);
  text("Parallax: "+formatter.format(3.26/(scrollbar.getPos()*9.0+1.0))+" \"", 11*sizeUnit, height-1.5*sizeUnit);
  popStyle();

  varpi = varpiRadius*starZMin*sizeUnit/(starZMin+(starZMax-starZMin)*scrollbar.getPos()*3);
  pushMatrix();
  translate(skyProjectionCenX-rotationSense*cos(radians(rotationPhase))*varpi, skyProjectionCenY+sin(radians(rotationPhase))*varpi);
  shape(star2D);
  popMatrix();

  pushStyle();
  stroke(#4477AA);
  strokeWeight(2);
  noFill();
  translate(5*sizeUnit, 7*sizeUnit, 0);
  rotateX(sceneRotAngle);
  ellipse(0, 0, earthOrbitRadius, earthOrbitRadius);
  popStyle();

  pushMatrix();
  ambientLight(0xFF, 0xFF, 0xFF);
  rotateX(-sceneRotAngle);
  shape(sun);
  noLights();
  popMatrix();

  starX = sunX;
  starY = sunY;
  starZ = sunZ+starZMin+(starZMax-starZMin)*scrollbar.getPos();

  pushMatrix();
  pushStyle();
  noStroke();
  ambientLight(0xF5, 0xDF, 0x52);
  translate(starX, starY, starZ);
  rotateX(-sceneRotAngle);
  shape(star);
  noLights();
  popStyle();
  popMatrix();

  pushMatrix();
  ambientLight(0xFF, 0xFF, 0xFF);
  earthX = sunX+rotationSense*cos(radians(rotationPhase))*earthOrbitRadius;
  earthY = sunY+sin(radians(rotationPhase))*earthOrbitRadius;
  translate(earthX, earthY, earthZ);
  rotateX(-sceneRotAngle);
  shape(earth);
  noLights();
  popMatrix();

  PVector starVec = new PVector(starX, starY, starZ);
  PVector earthVec = new PVector(earthX, earthY, earthZ);
  starVec.sub(earthVec);
  starVec.normalize();
  starVec.mult(lineOfSightLength);

  pushStyle();
  stroke(128);
  strokeWeight(1);
  line(earthOrbitRadius, 0, 0, starX, starY, starZ);
  line(-earthOrbitRadius, 0, 0, starX, starY, starZ);
  popStyle();

  pushMatrix();
  pushStyle();
  translate(earthVec.x, earthVec.y, earthVec.z);
  stroke(#FFFFFF);
  strokeWeight(2);
  line(0, 0, 0, starVec.x, starVec.y, starVec.z);
  popStyle();
  popMatrix();
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    save("parallax-demo.png");
  }
}