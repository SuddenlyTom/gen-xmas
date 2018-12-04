class Flower
{ 
  PVector position;
  float growth = 0;
  float rotation = 0;
  float k = 5.0 / 3.0;
  float flowerDetail = 250;
  float flowerScale = 1f;
  
  int flowersThisRow = 1;
  
  color base = color(1, 35, 44);
  color top = color(146, 217, 209);
      
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
    
    g.stroke(base); 
    int drawScale = 6;
    for(int i = 0; i < drawScale; i++)
    {
      if(growth < 1.0f)
      {
        float prog = lerp(0, TWO_PI * 1.5f, growth);
        prog = min(prog, TWO_PI * 1.5f);
        float ang = prog;
        float r = cos(k * ang) * 50 * flowerScale;
        float x = position.x + r * cos(ang);
        float y = position.y + r * sin(ang);
        g.line(position.x, position.y, x, y);
      }
      else if(growth < 2.0f)
      {
        g.stroke(top);
        float prog2 = lerp(0, TWO_PI * 1.5f, growth - 1.0f);
        prog2 = min(prog2, TWO_PI * 1.5f);
        float ang = prog2;  
        float r = cos(k * ang) * 20 * flowerScale;
        float x = position.x + r * cos(ang);
        float y = position.y + r * sin(ang);
        g.line(position.x, position.y, x, y);
      }
      growth += 0.0025;
    }
    
    if(growth >= 2.0f)
    {
      float newX;
      if(-width/2 * maskScale - position.x - 40.0f < position.x + 40.0f - width/2 * maskScale)
      {
        newX = random(-width/2 * maskScale, position.x - 40.0f);
      } 
      else 
      {
        newX = random(position.x + 40.0f, width/2 * maskScale);
      }
        
      if(flowersThisRow < 5)
      {
         position.set(new PVector(newX, position.y));
         flowersThisRow++;
      }
      else
      {
         position.set(new PVector(newX, position.y + 30.0f));
         flowersThisRow = 1;
      }
      flowerScale = random(0.7f) + 0.3f;
      growth = 0;
    }

    
    g.popStyle();
    g.popMatrix();
  }
}
