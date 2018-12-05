class Particle
{
  PVector pos;
  int type;
  float alpha;
  
  public Particle(float x, float y, int type)
  {
    pos = new PVector(x, y);
    this.type = type;
    alpha = random(10, 50);
  }
  
  public void update(PGraphics g)
  {
    float vStep;
    PImage toDraw;
    if(type == 0)
    {
      vStep = -3.0f;
      toDraw = bokehSm;
    } else if (type == 1)
    {
      vStep = -1.5f;
      toDraw = bokehMd;
    } else {
      vStep = -0.8f;
      toDraw = bokehLg;
    }
    
    pos.add(new PVector(0, vStep));
    g.tint(255, alpha);
    g.image(toDraw, pos.x, pos.y);
  }
}