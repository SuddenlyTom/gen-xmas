class Wanderer
{
  ArrayList<PVector> positions = new ArrayList<PVector>();
  
  PVector pos;
  PVector dir;
  
  color start;
  color end;
  color col;
  
  float stepScale = 9f;//40.0f;
  
  float strokeWeight = 3.0f;
  
  Wanderer(float x, float y)
  {
    pos = new PVector(x, y);
    positions.add(new PVector(x, y));
    start = color(255, 0, 0);
    end = color(255, 255, 255);
    
    
    col = lerpColor(start, end, map(x, 0, width, 0, 1.0f));
    PVector mid = new PVector(width/2, height/2);
    dir = PVector.sub(mid, pos);
    dir.normalize();
  }
    
  void show(PGraphics g)
  {
    float ang = noise(pos.x * 0.001f, pos.y * 0.001f);
    ang = map(ang, 0, 1.0f, -PI/2, PI/2);
    PVector step = new PVector(dir.x, dir.y);
    step.rotate(ang);
    step.mult(stepScale);
    pos.add(step);
    
    positions.add(new PVector(pos.x, pos.y));
    g.noFill();
    g.strokeWeight(strokeWeight);
    g.stroke(col);
    g.beginShape();
    for(int i = 0; i < positions.size(); i++) {
      PVector thisPos = positions.get(i);
      g.curveVertex(thisPos.x, thisPos.y);
      //g.curveVertex(thisPos.x, thisPos.y);
    }
    g.endShape();
  }
  
}