
PGraphics mask, content, canvasGrid;
float maskScale = 0.9f;
color bg = color(250);

float phase = 0;

int starsRad = 650;
int starsX, starsY;

color a = color(255, 119, 98);
color b = color(255, 213, 187);

ArrayList<dust> dusts = new ArrayList<dust>();
int dustCount = 4;

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

void setup() {
  size(900, 900);
  smooth(16);

  mask = createGraphics(width, height);
  content = createGraphics(width, height);
  canvasGrid = createGraphics(width, height);
  
  for(int i = 0; i < dustCount; i++) {
    dusts.add(new dust(20));
  }
  
  canvasGrid.beginDraw();
  grid(canvasGrid);
  canvasGrid.endDraw();
  
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

  //dispay it
  image(temp, 0, 0);
}

void drawContent() {
  content.loadPixels();
  for (int y = 0; y < height; y++)
  {
    for (int x = 0; x < width; x++)
    {
      content.pixels[y * width + x] = lerpColor(a, b, ease(noise(x * 0.002, y * 0.002), 2));
    }
  }
  content.updatePixels();
  for(int i = 0; i < dustCount; i++) {
    dusts.get(i).show(content);
  }
  
  content.image(canvasGrid, 0, 0);
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




void gridline(PGraphics g, float x1, float y1, float x2, float y2) {
  float tmp;
  if (x1 > x2) { 
    tmp = x1; 
    x1 = x2; 
    x2 = tmp; 
    tmp = y1; 
    y1 = y2; 
    y2 = tmp;
  }
  //if (y1 > y2) { tmp = y1; y1 = y2; y2 = tmp; }

  float dx = x2 - x1;
  float dy = y2 - y1;
  float step = 1;

  if (x2 < x1)
    step = -step;

  float sx = x1;
  float sy = y1;
  for (float x = x1+step; x <= x2; x+=step) {
    float y = y1 + step * dy * (x - x1) / dx;
    g.strokeWeight(1 + map(noise(sx, sy), 0, 1, -0.5, 0.5));
    g.line(sx, sy, x + map(noise(x, y), 0, 1, -1, 1), y + map(noise(x, y), 0, 1, -1, 1));
    sx = x;
    sy = y;
  }
}

void grid(PGraphics g) {
  float spacing = 5;
  for (int i = -width; i < height + width; i+=spacing) {
    g.stroke(255, random(20, 50));
    gridline(g, i, 0, i + height, height);
  }
  for (int i = height + width; i >= -width; i-=spacing) {
    g.stroke(255, random(20, 50));
    gridline(g, i, 0, i - height, height);
  }
}