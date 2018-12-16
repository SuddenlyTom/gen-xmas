PGraphics background, foreground;
float maskScale = 0.9f;
color bg = color(250);

color colA = color(0, 52, 73);
color colB = color(158, 226, 187);
int brushCount = 0;

PShape mask;
int maskDetail = 150;

float x, y, z, tt, r;
float X, Y, Z, R;
int N = 1600;
float age;
float rotSpeed;
float x_, y_, z_;

int samplesPerFrame = 4;
int numFrames = 280;        
float shutterAngle = .5;
float t;

boolean recording = true;

void setup() {
  size(1000,1000, P3D);
  r = width/2*maskScale*0.7;
  
  //form our mask
  createMask();
  
  pixelDensity(1);
  smooth(8);
  rectMode(CENTER);
  
  noStroke();
  sphereDetail(8);
}

void draw() {
  background(bg);
  drawForeground();
  shape(mask);
  saveFrame("output.png");
  noLoop();
}

void drawForeground()
{
  background(0); 
  pushMatrix();
  pushStyle();
  translate(width/2, height/2);
  randomSeed(1);
  for (int i=0; i<N; i++)
  {
    light();
  }
  popMatrix();
  popStyle();
  t = map(frameCount-1 + shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);

}

void light() {
  rotSpeed = random(-1, -.2);
  
  X = randomGaussian();
  Y = randomGaussian();
  Z = randomGaussian();
  R = dist(0, 0, 0, X, Y, Z);
  x_ = X*r/R;
  y_ = Y*r/R;
  z_ = Z*r/R;

  age = (t + 1000 - .0016*y + randomGaussian()*.18) % 1;
  age = c01(1.5*age);

  x = x_*cos(rotSpeed*age) + z_*sin(rotSpeed*age);
  y = y_;
  z = z_*cos(rotSpeed*age) - x_*sin(rotSpeed*age);
  
  pushMatrix();
  pushStyle();
  translate(x, y, z);
  color col = lerpColor(color(255, 0, 0), color(255, 255, 0), random(0, 1.0f));
  float zDist = map(modelZ(x, y, z), -r, r, 0, 255);
  float f = map(cos(TWO_PI*age), 1, -1, 0, zDist);
  fill(color(red(col), green(col), blue(col), f));
  sphere(map(cos(TWO_PI*age), 1, -1, 0, 3.5));
  popMatrix();
  popStyle();
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

float c01(float g) {
  return constrain(g, 0, 1);
}