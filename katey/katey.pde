PGraphics background, foreground;
float maskScale = 0.9f;
color bg = color(250);
color[] colors;
PImage dirt;
float rSpeed = 0.002f;
PShape mask;
int maskDetail = 150;

void setup() {
  size(900,900);
  smooth(16);
  colors = new color[3];
  colors[0] = color( 235, 89, 87 );
  colors[1] = color( 255, 245, 90 );
  colors[2] = color( 136, 228, 188 );
  
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
  pushMatrix();
  translate(width/2, height/2);
  rotate(frameCount * rSpeed);
  imageMode(CENTER);
  image(dirt, 0, 0);
  blendMode(BLEND);
  tint(255, 255);
  imageMode(CORNERS);
  popMatrix();
  shape(mask);
}

void keyPressed()
{
  rs -= 0.01f;
  println(rs);
}

float rs = 0.26f;
float prog = 0;
void drawBackground() {
  background.translate(width/2, height/2);
  background.rotate(frameCount * rSpeed);
  background.background(255, 180);
  background.noStroke();
 
  float ellipseStep = 0.02f;
  float a = 1.3f;
  for(int i = 0; i < 3; i++)
  {
    background.fill(colors[i]);
    for(float t = 0; t < TWO_PI * prog; t+= ellipseStep)
    {
      float r = pow(a, i + t);
      background.ellipse(cos(t) * r, sin(t) * r, r * rs, r * rs);
    }    
  }
  prog += 0.005;
}

void drawForeground()
{
    foreground.translate(width/2, height/2);
    foreground.rotate(frameCount * rSpeed);
    foreground.background(bg, 0);
    foreground.strokeWeight(5);
    foreground.stroke(210, 180, 58, 80);
  for(float i = 0; i < TWO_PI; i += TWO_PI/28)
  {
    float x = cos(i) * width*maskScale;
    float y = sin(i) * height*maskScale;
    foreground.line(0, 0, x, y);
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