PGraphics background, foreground;
float maskScale = 0.9f;
float maskBorderWeight = 0.05;
color bg = color(250);

color innerbgA = color(51, 63, 103);
color innerbgB = color(132, 150, 211);

PVector top, bottom;
float prog = 0;

PShape mask, maskBorder;
int maskDetail = 150;

void setup() {
  size(900,900);
  smooth(16);
  
  top = new PVector(width/2, (height - (height * maskScale)) * 0.5f);
  bottom = new PVector(width/2, height * maskScale + top.y);
  
  //create our layers!
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
  
  stroke(innerbgA);
  strokeWeight(5);
  noFill();
  ellipse(width/2, height/2, width* (maskScale * 1.03),height* (maskScale * 1.03));

 
}

void drawBackground() {
  //background.clear();
  background.noStroke();
  for(int y = 0; y < height; y+= 20)
  {
    for(int x = 0; x < width; x+= 20)
    {
      background.fill(lerpColor(innerbgA, innerbgB, noise(x * 0.005, y * 0.005, prog)));
      background.ellipse(x, y, 30, 30);
    }
  }
}

void drawForeground()
{
  foreground.clear();
  foreground.strokeWeight(2);
  foreground.stroke(#F7F7F2);
  float bladeCount = 40;
  float angStep = radians(180.0f / bladeCount * ease(map(sin(prog), -1, 1, 0.7, 1), 2.0f));//0.002f;
  for(float i = -bladeCount; i <= bladeCount; i++) {
    float x = cos(angStep * i - PI/2) * width;
    float y = sin(angStep * i - PI/2) * width;
    foreground.line(bottom.x, bottom.y, bottom.x + x, bottom.y + y);
    
    float topX = cos(angStep * i + PI/2) * width;
    float topY = sin(angStep * i + PI/2) * width;
    foreground.line(top.x, top.y, top.x + topX, top.y + topY);
  }
  foreground.noStroke();
  foreground.fill(#F7F7F2);
  for(int i = -4; i <= 4; i++)
  {
    float planetSize = 35f - 5f * abs(i);
    float planetSpacing = 50f - 3f * abs(i);

    foreground.ellipse(width/2, height/2 + i * planetSpacing, planetSize, planetSize);
  }
  
  prog += 0.02f;
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