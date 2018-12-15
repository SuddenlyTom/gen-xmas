PGraphics background, foreground;
float maskScale = 0.9f;
color bg = color(250);
PImage pallette;
PShape mask;
int maskDetail = 150;

void setup() {
  size(900,900);
  smooth(16);
  pallette = loadImage("pallette.png");
  
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
  foreground.clear();
  
  float spacing = 50.0f;
  float halfStep = spacing * 0.5f;
  for(float y = 0; y < height; y+= spacing)
  {
    for(float x = 0; x < width; x+= spacing)
    {
      float thisNoise = getNoise(x, y);
      float topRightNoise = getNoise(x + halfStep, y - halfStep);
      float topLeftNoise = getNoise(x - halfStep, y - halfStep);
      float botRightNoise = getNoise(x + halfStep, y + halfStep);
      float botLeftNoise = getNoise(x - halfStep, y + halfStep);
      
      PVector thisPos = getNoisePos(x, y, spacing);           
      PVector topRight = getNoisePos(x + halfStep, y - halfStep, spacing);
      PVector topLeft = getNoisePos(x - halfStep, y - halfStep, spacing);
      PVector botRight = getNoisePos(x + halfStep, y + halfStep, spacing);
      PVector botLeft = getNoisePos(x - halfStep, y + halfStep, spacing);
      float thisAvg = map((thisNoise + topLeftNoise + topRightNoise), 0, 3, 0, 1);
      color thisCol = getGradient(thisAvg, 1.0f);
      foreground.stroke(thisCol);
      foreground.fill(thisCol);
      foreground.beginShape();
      foreground.vertex(thisPos.x, thisPos.y);
      foreground.vertex(topLeft.x, topLeft.y);
      foreground.vertex(topRight.x, topRight.y);
      foreground.endShape(CLOSE);     
      
      thisAvg = map((thisNoise + topRightNoise + botRightNoise), 0, 3, 0, 1);
      thisCol = getGradient(thisAvg, 1.0f);
      foreground.stroke(thisCol);
      foreground.fill(thisCol);
      foreground.beginShape();
      foreground.vertex(thisPos.x, thisPos.y);
      foreground.vertex(topRight.x, topRight.y);
      foreground.vertex(botRight.x, botRight.y);
      foreground.endShape(CLOSE);
      
      thisAvg = map((thisNoise + botRightNoise + botLeftNoise), 0, 3, 0, 1);
      thisCol = getGradient(thisAvg, 1.0f);
      foreground.stroke(thisCol);
      foreground.fill(thisCol);
      foreground.beginShape();
      foreground.vertex(thisPos.x, thisPos.y);
      foreground.vertex(botRight.x, botRight.y);
      foreground.vertex(botLeft.x, botLeft.y);
      foreground.endShape(CLOSE); 
      
      thisAvg = map((thisNoise + botLeftNoise + topLeftNoise), 0, 3, 0, 1);
      thisCol = getGradient(thisAvg, 1.0f);
      foreground.stroke(thisCol);
      foreground.fill(thisCol);
      foreground.beginShape();
      foreground.vertex(thisPos.x, thisPos.y);
      foreground.vertex(botLeft.x, botLeft.y);
      foreground.vertex(topLeft.x, topLeft.y);      
      foreground.endShape(CLOSE); 
    }   
  }
}

color getGradient(float inVal, float mult)
{
  float in = ease(inVal, 2.5);
  int sampleVal = (int)map(in, 0, 1, 0, pallette.pixels.length);
  color col = color(pallette.pixels[sampleVal]);
  return col;
}

float getNoise(float x, float y)
{
  float noiseScale = 0.02f;
  float timeScale = 0.3f;
  return noise(x * noiseScale, y * noiseScale, frameCount * timeScale * noiseScale);
}

PVector getNoisePos(float x, float y, float spacing)
{
  float wanderScale = 0.3f;
  
  float ang = getNoise(x, y);
   ang = map(ang, 0, 1.0f, 0, TWO_PI);
   float newX = cos(ang) * spacing * wanderScale;
   float newY = sin(ang) * spacing * wanderScale;
   
   return new PVector(x + newX, y + newY);
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

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}