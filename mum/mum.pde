PGraphics content, foreground;
float maskScale = 0.9f;
color bg = color(250);

color colA = color(0, 52, 73);
color colB = color(158, 226, 187);
int brushCount = 0;

PShape mask;
int maskDetail = 150;

ArrayList<PImage> strokes = new ArrayList<PImage>();
Flower flower;

void setup() {
  size(900,900);
  smooth(16);
  flower = new Flower(0, 0);
  
  for(int i = 1; i < 8; i++)
  {
    strokes.add(loadImage("brush" + i + ".png"));  
  } 
  //create our layers!
  createMask();
  content = createGraphics(width, height);
  foreground = createGraphics(width, height);
  //get smoothed!
  foreground.smooth(16);
  content.smooth(16);
  //fill a base amount
  content.beginDraw();
  content.background(bg);
  for(int i = 0; i < 500; i++)
  {
    drawContent();
  }
  content.endDraw();
  //form our mask
  createMask();
}

void draw() {
  background(bg);
  
  content.beginDraw();
  drawContent();
  content.endDraw();
  foreground.beginDraw();
  drawForeground();
  foreground.endDraw();
  
  image(content.get(), 0, 0);
  image(foreground.get(), 0, 0);
  shape(mask);
}

void drawContent() {
  if(brushCount < 2000)
  {
    color thisCol = lerpColor(colA, colB, random(1.0f));
    content.tint(red(thisCol), green(thisCol), blue(thisCol), random(10));
    
    content.pushMatrix();
    content.translate(random(width / 5, 4 * width/5), random(height / 5, 4 * height/5));
    content.rotate(radians(random(360)));
    float randSize = random(0.8) + 0.2;
    int brush = (int)random(1, 7);
    content.image(strokes.get(brush), 0, 0, 506 * randSize, 320 * randSize);
    content.popMatrix();

    brushCount++;
  }  
}

void drawForeground()
{
  foreground.beginDraw();
  //foreground.clear();
  foreground.pushStyle();
  foreground.pushMatrix();
  
  foreground.translate(width * maskScale * 0.85f, height * maskScale * 0.85f);
  foreground.rotate(3* PI/4);
  flower.update(foreground);
  
  foreground.popMatrix();
  foreground.popStyle();  
  foreground.endDraw();
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
