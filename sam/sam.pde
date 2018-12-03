PGraphics mask, content;
float maskScale = 0.9f;
color bg = color(250);
PImage gradient;
boolean recording = false;
float t = 0;

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}


void setup() {
  size(900,900);
  
  mask = createGraphics(width, height);
  content = createGraphics(width, height);
  createMask();
  
  gradient = loadImage("gradient3.png");
  gradient.loadPixels();
    
  content.smooth(16);
  content.beginDraw();
  content.background(255);
  content.endDraw();
}

float noiseScale = 0.002f;
boolean clamp = true; 

void drawContent() {
  content.background(255);
  content.loadPixels();
  
  
  
  for(int y = 0; y < height; y++)
  {
    float threadMult = ease(map(sin(y * 0.85), -1, 1, 0.75, 1), 2);
    for(int x = 0; x < width; x++)
    {
      content.pixels[y * width + x] = (getGradient(noise(x * 0.0025,y * 0.0025, t), threadMult));
      
    }
  }
  content.updatePixels();
  //yarn.show(content);
  t += 0.01;
}

color getGradient(float inVal, float mult)
{
  float in = ease(inVal, 2);
  int sampleVal = (int)map(in, 0, 1, 0, 255);
  color col = gradient.pixels[sampleVal];
  color newCol = color(red(col) * mult, green(col) * mult, blue(col) * mult);
  return newCol;
}

void mousePressed() 
{
  //clamp = !clamp;
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
  if(recording)
  {
    saveFrame("output/frame_####.png");
  }
}