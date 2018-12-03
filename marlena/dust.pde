class dust
{
  float x;
  float y;
  float rad;
  float phase;
  int count;
  
  ArrayList<PVector> points = new ArrayList<PVector>();
  
  public dust(int count) {
    this.count = count;  
    phase = random(0, TWO_PI);
    make(random(300, 600));
  };
  
  public void make(float rad) {
    this.points.clear();
    this.rad = rad;
    this.x = random(width/6, 5*width/6);
    this.y = random(height/6, 5*height/6);
  
    float ox = this.x + random(-50, 50);
    float oy = this.y + random(-50, 50);
    PVector oPoint = new PVector(ox, oy);
    this.points.add(oPoint);
  
    for(int i = 1; i < this.count; i++)
    {
      float thisx = cos(random(0, TWO_PI)) * random(0, rad/2);
      float thisy = sin(random(0, TWO_PI)) * random(0, rad/2);
      PVector newPoint = new PVector(thisx + this.x, thisy + this.y);
      this.points.add(newPoint);
    }
  
  };
  
  public void show(PGraphics g) {
    float prog = map(sin(this.phase), -1, 1, 0, 1);
  
    g.fill(255, prog * 255);
    g.stroke(255, prog * 255);
    g.strokeWeight(2);
    
    float ox = points.get(0).x;
    float oy = points.get(0).y;
    for(int i = 1; i < this.count; i++)
    {
      float x = points.get(i).x;
      float y = points.get(i).y;
      
      g.ellipse(x, y, 5, 5);
      g.line(ox, oy, lerp( ox, x, ease(prog, 2)), lerp(oy, y, ease(prog, 2)));
    }
    
    if(sin(this.phase) < -0.99)
    {
      make(random(300, 600));
    }
    this.phase += 0.1;

  }

}