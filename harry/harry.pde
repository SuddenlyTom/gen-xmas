PGraphics mask, content;
float maskScale = 0.9f;
color bg = color(250);
float dt = 0;

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

void setup() {
  size(900,900);
  smooth(16);

  mask = createGraphics(width, height);
  content = createGraphics(width, height);
  //content.smooth(4);
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
  content.background(255);
  content.strokeWeight(5);
  content.noFill();
  float offset = width * maskScale * 0.15f;
  float circleScale = width * maskScale*0.5f;
  int circleCount = 24;
  float stepSize = TWO_PI / circleCount;
  float arcFill = ease(map(cos(dt), -1, 1, 0.01, 1), 2);
  
  for(float i = 0; i < TWO_PI; i += stepSize)
  {
    float x = width/2 + cos(i) * offset;
    float y = height/2 + sin(i) * offset;
    content.stroke(map(x, 0, width, 120, 255), map(y, 0, width, 120, 255), 250);
    content.arc(x, y, circleScale, circleScale, i * dt, i * dt + arcFill * TWO_PI);
  }
  dt += 0.01f;
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