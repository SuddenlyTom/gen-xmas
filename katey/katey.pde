PGraphics background, foreground;
float maskScale = 0.9f;
color bg = color(250);

PImage dirt;

PShape mask;
int maskDetail = 150;

void setup() {
  size(900,900);
  smooth(16);
  dirt = loadImage("dirt.png");
  dirt.resize(width,height);
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
  blendMode(MULTIPLY);
  tint(255, 150);
  image(dirt, 0, 0);
  blendMode(BLEND);
  tint(255, 255);
  shape(mask);
}

void drawBackground() {
  float distScaleSpeed = 48f;
  float globalScale = 1f;
  background.translate(width/2, height/2);
  background.background(255, 180);
  background.noStroke();
  background.fill(233, 86, 81);
  
  for(float i = 0; i <  TWO_PI*2.0f * globalScale; i += 0.01f * globalScale)
  {
    float d = i * distScaleSpeed * globalScale;
    float scale = map(i, 0, TWO_PI*2.0f * globalScale, 0, 100.0f * globalScale);
    float x = cos(i) * d;
    float y = sin(i) * d;
    background.ellipse(x, y, scale, scale);
  }
  
  background.fill(232, 223, 77);
  for(float i = 0; i <  TWO_PI*2.0f * globalScale; i += 0.01f * globalScale)
  {
    float d = i * distScaleSpeed * 0.85 * globalScale;
    float scale = map(i, 0, TWO_PI*2.0f * globalScale, 0, 100.0f * globalScale);
    float x = cos(i) * d;
    float y = sin(i) * d;
    background.ellipse(x, y, scale, scale);
  }
  
  background.fill(131, 219, 174);
  for(float i = 0; i <  TWO_PI*3.0f * globalScale; i += 0.01f * globalScale)
  {
    float d = i * distScaleSpeed * 0.85 *0.88 * globalScale;
    float scale = map(i, 0, TWO_PI*2.0f * globalScale, 0, 80.0f * globalScale);
    float x = cos(i) * d;
    float y = sin(i) * d;
    background.ellipse(x, y, scale, scale);
  }
}

void drawForeground()
{
  
    foreground.background(bg, 0);
    foreground.strokeWeight(3);
    foreground.stroke(210, 180, 58, 80);
  for(float i = 0; i < TWO_PI; i += TWO_PI/28)
  {
    float x = cos(i) * width*maskScale + width/2;
    float y = sin(i) * height*maskScale + height/2;
    foreground.line(width/2, height/2, x, y);
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