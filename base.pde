PGraphics mask, content;
float maskScale = 0.9f;
color bg = color(250);

void setup() {
  size(1000,1000);
  
  mask = createGraphics(width, height);
  content = createGraphics(width, height);
  
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
  content.background(38);

  
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