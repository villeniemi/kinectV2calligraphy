/*
  Here we have all the classes connected to storage and output

*/

class Arm
{
  public PVector wrist; 
  public PVector elbow; 
  public float strength;
  
  Arm(PVector _elbow, PVector _wrist, float _str )
  {
    wrist = new PVector(_wrist.x, _wrist.y,_wrist.z);
    elbow = new PVector(_elbow.x, _elbow.y,_elbow.z);
    strength = _str;
  }
}

class Stroke
{
  public ArrayList<Arm> stroke;
  public int brush;
  
  Stroke(int _b){
    stroke = new ArrayList<Arm>();
    brush = _b;
  }
  
  void addArm(PVector _elbow, PVector _wrist, float _str)
  {
    stroke.add(new Arm(_elbow, _wrist, _str));
  }
  
}

class Calligraphy
{
  public ArrayList<Stroke> strokes;
  private boolean lastStrokeFinished;
  
  Calligraphy(){
    strokes = new ArrayList<Stroke>();
    lastStrokeFinished = true;
  }
  
  void addArm(PVector _e, PVector _wrist, float _str)
  {
    if (lastStrokeFinished == false){ 
      strokes.get(strokes.size()-1).addArm(_e, _wrist, _str);
    }   
  }
  
  void finishStroke()
  {
    lastStrokeFinished = true;
  }
  
  void startStroke(int _b)
  {
    if (lastStrokeFinished == true)
    {
      strokes.add(new Stroke(_b));
      lastStrokeFinished = false;
    }
  }
  
  void drawAll()
  {
    Brushes myBrushes = new Brushes();
    for (int i=0; i<strokes.size(); i++)
    {
      
      myBrushes.drawMe(strokes.get(i));
    }
    
  }
}

// Drawing brushes

 class Brushes
{
  Brushes(){
  
  }
  
  void brush1(Stroke _s){
    for (int i=1; i<_s.stroke.size(); i++)
    {
      PVector wrist = _s.stroke.get(i).wrist;
      PVector elbow = _s.stroke.get(i).elbow;
      float strength = _s.stroke.get(i).strength;
      
      PVector pWrist = _s.stroke.get(i-1).wrist;
      PVector pElbow = _s.stroke.get(i-1).elbow;
      float pStrength = _s.stroke.get(i-1).strength;
      
      //translate ((wrist.x + elbow.x)/2, (wrist.y + elbow.y)/2, (wrist.z + elbow.z)/2); 
      stroke(255);
      fill(127);
      beginShape();
      vertex(wrist.x, wrist.y, wrist.z);
      vertex( elbow.x, elbow.y, elbow.z);
      vertex( pElbow.x, pElbow.y, pElbow.z);
      vertex(pWrist.x, pWrist.y, pWrist.z);
      endShape(CLOSE);
      
      
    }
  
  }
  
   void brush2(Stroke _s){
    for (int i=1; i<_s.stroke.size(); i++)
    {
      PVector wrist = _s.stroke.get(i).wrist;
      PVector elbow = _s.stroke.get(i).elbow;
      float strength = _s.stroke.get(i).strength;
      
      PVector pWrist = _s.stroke.get(i-1).wrist;
      PVector pElbow = _s.stroke.get(i-1).elbow;
      float pStrength = _s.stroke.get(i-1).strength;
      
      PVector addPoint = PVector.sub(wrist, elbow);
      addPoint.setMag(strength);
      PVector secondPoint = PVector.add(wrist, addPoint);
      
      PVector pAddPoint = PVector.sub(pWrist, pElbow);
      pAddPoint.setMag(pStrength);
      PVector pSecondPoint = PVector.add(pWrist, pAddPoint);      
      
      //translate ((wrist.x + elbow.x)/2, (wrist.y + elbow.y)/2, (wrist.z + elbow.z)/2); 
      
      noStroke();
      fill(127);
      beginShape();
      vertex(wrist.x, wrist.y, wrist.z);
      vertex( secondPoint.x, secondPoint.y, secondPoint.z);
      vertex( pSecondPoint.x, pSecondPoint.y, pSecondPoint.z);
      vertex(pWrist.x, pWrist.y, pWrist.z);
      endShape(CLOSE);
      
      
    }
  
  }
    
  void drawMe(Stroke _s)
  {
    if (_s.brush == 1) brush2(_s);
    else 
    println ("no such a brush");
  }
  

}
