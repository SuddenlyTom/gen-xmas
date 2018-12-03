class Flower
{ 
  PVector position;
  float growth = 0;
  float rotation = 0;
  float k = 5.0 / 3.0;
  
  color base = color(1, 35, 44);
  color top = color(146, 217, 209);
  
  float neighbourSpacing = 80.0f;
  int alpha = 255;
  
  float scale = 1.0f;
  
  public Flower(float x, float y)
  {
    position = new PVector(x, y);
    rotation = random(TWO_PI);
  }
  
  public void update(PGraphics g)
  {

    g.pushMatrix();
    g.pushStyle();
    g.strokeWeight(.5);
    
    int stepCount = 8;
    if(growth < 1.0f)
    {
      for(int i = 0; i < stepCount; i++) {
        g.stroke(base, alpha);    
        float prog = lerp(0, TWO_PI * 1.5f, growth + i * 0.001f);
        float r = cos(k * prog) * 50 * scale;
        float x = position.x + r * cos(prog);
        float y = position.y + r * sin(prog);
        g.line(position.x, position.y, x, y);
      }
    }
    else if(growth < 2.0f)
    {
      for(int i = 0; i < stepCount; i++) {
        g.stroke(top, alpha);
        float prog2 = lerp(0, TWO_PI * 1.5f, growth - 1.0f + i * 0.001f);
        prog2 = min(prog2, TWO_PI * 1.5f);
        float r = cos(k * prog2) * 20 * scale;
        float x = position.x + r * cos(prog2);
        float y = position.y + r * sin(prog2);
        g.line(position.x, position.y, x, y);
      }
    }
    
    if(growth >= 2.0f)
    {
      PVector step = new PVector(neighbourSpacing,0);
      step.rotate(random(TWO_PI));
      position.add(step);
      growth = 0;      
      alpha = (int)random(180) + 30;
      scale = random(0.8) + 0.4;
    }
    else 
    {
      growth += 0.001f * stepCount;
    }
    
    g.popStyle();
    g.popMatrix();
  }
}