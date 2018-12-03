class Flower
{ 
  PVector position;
  float growth = 0;
  float rotation = 0;
  float k = 5.0 / 3.0;
  
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
    float prog = lerp(0, TWO_PI * 1.5f, growth);
    prog = min(prog, TWO_PI * 1.5f);
    for(float ang = 0; ang < prog; ang += TWO_PI/150)
    {
      float r = cos(k * ang) * 50;
      float x = position.x + r * cos(ang);
      float y = position.y + r * sin(ang);
      g.line(position.x, position.y, x, y);
    }
    
    if(growth >= 1.0f)
    {
      g.stroke(top);
      float prog2 = lerp(0, TWO_PI * 1.5f, growth - 1.0f);
      prog2 = min(prog2, TWO_PI * 1.5f);
      for(float ang = 0; ang < prog2; ang += TWO_PI/150)
      {
        float r = cos(k * ang) * 20;
        float x = position.x + r * cos(ang);
        float y = position.y + r * sin(ang);
        g.line(position.x, position.y, x, y);
      }
    }

    growth += 0.01f;
    
    g.popStyle();
    g.popMatrix();
  }
}

class Stem
{
  ArrayList<Flower> flowers = new ArrayList<Flower>();
  ArrayList<PVector> points = new ArrayList<PVector>();
  
  public Stem()
  {
    
  }
}