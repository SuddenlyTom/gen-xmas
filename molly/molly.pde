PGraphics background, foreground;
float maskScale = 0.9f;
color bg = color(250);

color colA = color(156, 170, 207);
color colB = color(129, 105, 131);
color colC = color(201, 170, 169);
int brushCount = 0;

PImage bokehSm, bokehMd, bokehLg;
ArrayList<Particle> particles;

PShape mask;
int maskDetail = 150;

void setup() {
  size(900,900);
  smooth(16);
  
  bokehSm = loadImage("bokehSm.png");
  bokehMd = loadImage("bokehMd.png");
  bokehLg = loadImage("bokehLg.png");
  
  particles = new ArrayList<Particle>();
  for(int i = 0; i < 150; i++)
  {
    particles.add(new Particle(random(width), random(height * 0.5) + height * 0.5f, (int)random(0, 3)));
  }
  
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
  foreground.loadPixels();
  for(int y = 0; y < height; y++)
  {
    for(int x = 0; x < width; x++)
    {
      color col = lerpColor(colC, colA, map(y, 0, height, 0, 1));
      foreground.pixels[y * width + x] = col;
    }
  }
  foreground.updatePixels();
  
  foreground.blendMode(ADD);
  for(int i = 0; i < particles.size(); i++)
  {  
    
    particles.get(i).update(foreground);
    //foreground.image(bokehSm, random(width), random(height));
  }
  foreground.blendMode(NORMAL);
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