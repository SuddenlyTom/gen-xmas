PGraphics mask, content, foreground;
float maskScale = 0.9f;
color bg = color(250);

color colA = color(0, 52, 73);
color colB = color(158, 226, 187);
int brushCount = 0;

ArrayList<PImage> strokes = new ArrayList<PImage>();
ArrayList<Stem> stems = new ArrayList<Stem>();
Flower flower;

void setup() {
  size(900,900);
  smooth(16);
  flower = new Flower(width/2, height/2);
  
  for(int i = 1; i < 8; i++)
  {
    strokes.add(loadImage("brush" + i + ".png"));  
  } 
  //create our layers!
  mask = createGraphics(width, height);
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
    drawBackground();
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
  
  // get an imge out of our content...
  PImage temp = content.get();
  //mask image
  temp.mask(mask);
  
  image(temp, 0, 0);
  image(foreground.get(), 0, 0);
}

void drawContent() {
  drawBackground();
  
  foreground.beginDraw();
  foreground.clear();
  foreground.pushStyle();
  foreground.fill(255, 255, 0);
  flower.update(foreground);
  foreground.popStyle();  
  foreground.endDraw();
  
  //content.image(foreground.get(), 0, 0);
}

void drawBackground()
{
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

void createMask() {
   // draw a circle as a mask
  mask.beginDraw();
  mask.background(0);
  mask.noStroke();
  mask.fill(255);
  mask.ellipse(width/2, height/2, width * maskScale, height * maskScale);
  mask.endDraw();
}