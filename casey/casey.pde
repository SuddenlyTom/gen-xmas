PGraphics background, foreground;
float maskScale = 0.9f;
color bg = color(250);

color colA = color(0, 52, 73);
color colB = color(158, 226, 187);
int brushCount = 0;

PShape mask;
int maskDetail = 150;

int waterStrokeWeight = 16;


void setup() {
  size(900,900);
  smooth(16);
  
  //create our layers!
  createMask();
  background = createGraphics(width, height);
  foreground = createGraphics(width, height);
  //get smoothed!
  foreground.smooth(16);
  background.smooth(16);
  //fill a base amount
  background.beginDraw();
  background.background(bg);
  drawBackground();
  background.endDraw();
  
  foreground.beginDraw();
  foreground.background(175, 175, 240);
  foreground.strokeWeight(waterStrokeWeight);
  foreground.endDraw();
  
  //form our mask
  createMask();
}

void draw() {
  background(bg);
  
  background.beginDraw();
  drawBackground();
  background.endDraw();
  
  foreground.beginDraw();
  drawForeground();
  foreground.endDraw();
  
  image(background.get(), 0, 0);
  image(foreground.get(), 0, 0);
  shape(mask);
}

void drawBackground() {

}

void drawForeground()
{
    // water and reflection coloration based on perlin noise
  int lineToggle = 0;
  float reflectionHalfWidth = width * 0.25f;
  color reflectionColor = color(240, 125, 125);
  color highlightColor = color(240, 240, 175);
  color waterLowColor = color(0, 12, 31);
  color waterHighColor = color(100, 110, 130);
  float waveMovementSpeed = 1.75f;
  float noiseZInput = frameCount * 0.001 * waveMovementSpeed;
  float sunHeight = (height - (height * maskScale)) * 0.4f;
  int waterStride = 10;
  float noiseScale = 0.07f;
  
  for (float yPos = sunHeight + waterStrokeWeight; yPos < height + waterStrokeWeight; yPos += waterStrokeWeight) {
    float yPosMap01 = map(yPos, sunHeight, height, 0, 1);
    float noiseYInput = noiseScale * (yPos * map(yPos, sunHeight, height, 1.5, 1) - frameCount * 0.5) * waveMovementSpeed;
    
    for (float xPos = lineToggle; xPos <= width - lineToggle; xPos += waterStride) {
      float noiseXInput = noiseScale * ((xPos - (1 - yPosMap01) * height*0.5f / 2) + waterStride * 0.5) / (yPosMap01 * 10 + 1);
      float noiseVal = noise(noiseXInput, noiseYInput, noiseZInput);
      float noiseValIncreasedContrast = constrain(map(noiseVal, 0.1, 0.6, 0, 1), 0, 1);
      float edgeBlendModifier = constrain((2 - (abs(height*0.5f - xPos + lineToggle) / (reflectionHalfWidth * (yPosMap01 + 0.6))) * 2), 0, 1);
      
      // base water color
      color c = lerpColor(waterLowColor, waterHighColor, noiseVal);
      // primary reflection color within the center region
      c = lerpColor(c, reflectionColor, constrain(noiseValIncreasedContrast * 4 - 3, 0, edgeBlendModifier));
      // secondary highlight color (with added emphasis just below the sun)
      c = lerpColor(c, highlightColor, constrain((noiseVal * 10 - 6), 0, edgeBlendModifier) + pow(1 - yPosMap01, 8) * edgeBlendModifier * 1.5);
      // random highlights in the waves outside of the center region
      c = lerpColor(c, highlightColor, constrain((noiseVal * 10 - 7), 0, 1));

      // draw the line segment
      foreground.stroke(c);
      foreground.line(xPos, yPos, xPos + waterStride, yPos);
    }
    // alternate each row to add variety
    lineToggle = lineToggle == 0 ? -waterStride / 2 : 0;
  }
}

void createMask() {
  mask = createShape();
  mask.beginShape();
  mask.fill(bg);
  mask.noStroke();
  mask.vertex(0, 0);
  mask.vertex(width, 0);
  mask.vertex(width, height);
  mask.vertex(0, height);
  mask.vertex(0, 0); 
  // Interior part of shape
  mask.beginContour();  
  for(int i = 0; i < maskDetail + 1; i++)
  {
    float ang = i * (TWO_PI / (float)maskDetail) + PI/2;
    float x = cos(TWO_PI - ang) * width * maskScale * 0.5f;
    float y = sin(TWO_PI - ang) * height * maskScale * 0.5f;
    mask.vertex(width/2 + x, height/2 + y);
  }
  mask.endContour(); 
  mask.endShape(CLOSE);
}