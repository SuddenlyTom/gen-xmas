PGraphics mask, content;
float maskScale = 0.9f;
color bg = color(250);

Wanderer[] wanderers;
int wandererCount = 100;

void setup() {
  size(900,900);
  smooth(16);
  wanderers = new Wanderer[wandererCount];   
  for(int i = 0; i < wandererCount; i++) {
    wanderers[i] = new Wanderer((width / wandererCount) * i, height);
  }
  
  mask = createGraphics(width, height);
  content = createGraphics(width, height);
  content.smooth(16);
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

  for(int i = 0; i < wandererCount; i++) {
    wanderers[i].show(content);    
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