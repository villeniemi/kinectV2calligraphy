/*
  Here we have all the classes connected to storage and output

*/

class Arm
{
  public PVector wrist; 
  public PVector elbow; 
  public float strength;
  public color colour;
  
  Arm(PVector _elbow, PVector _wrist, float _str, color _clr)
  {
    wrist = new PVector(_wrist.x, _wrist.y,_wrist.z);
    elbow = new PVector(_elbow.x, _elbow.y,_elbow.z);
    strength = _str;
    colour = _clr;
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
  
  void addArm(PVector _elbow, PVector _wrist, float _str, color _clr )
  {
    stroke.add(new Arm(_elbow, _wrist, _str, _clr));
  }
  
}

class Calligraphy
{
  public ArrayList<Stroke> strokes;
  private boolean lastStrokeFinished;
  public int uId;
  
  Calligraphy(int _uId){
    strokes = new ArrayList<Stroke>();
    lastStrokeFinished = true;
    uId = _uId;
  }
  
  void addArm(PVector _e, PVector _wrist, float _str, color _clr)
  {
    if (lastStrokeFinished == false){ 
      strokes.get(strokes.size()-1).addArm(_e, _wrist, _str, _clr);
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

// People 

class People
{
  public ArrayList<Calligraphy> calligraphies;
  
  People(){   
    calligraphies = new ArrayList<Calligraphy>();
  }
  
  void addPeople(int[] _uIds)
  {
    for(int i=0;i<_uIds.length;i++) // For each user in the list
    {
      if (userExists(_uIds[i]) == false) 
      {
        calligraphies.add(new Calligraphy(_uIds[i]));
        //println("new person " + _uIds[i] );
      }
    }
  }
  
  boolean userExists(int _uId)
  {
    boolean ret = false; 
    for(int i = 0; i < calligraphies.size(); i++)
    {
      int testId = calligraphies.get(i).uId;
      //println (ret + "  testId: " + testId + "   uid: " + _uId);
      if (testId == _uId) ret = true;
    }
    println (ret);
    
    return ret;  
  }
  
  Calligraphy getById(int _uId)
  {
    Calligraphy ret = new Calligraphy(-1);
    int testId = -1;
    for(int i = 0; i < calligraphies.size(); i++)
    {
      testId = calligraphies.get(i).uId;
      if (testId == _uId) ret = calligraphies.get(i);
    }
    
    return ret;
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
      fill(255);
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
      color colour = _s.stroke.get(i).colour;

      // Previous
      PVector pWrist = _s.stroke.get(i-1).wrist;
      PVector pElbow = _s.stroke.get(i-1).elbow;
      float pStrength = _s.stroke.get(i-1).strength;
      float pColour = _s.stroke.get(i-1).colour;

      PVector addPoint = PVector.sub(wrist, elbow);
      addPoint.setMag(strength);
      PVector secondPoint = PVector.add(wrist, addPoint);
      
      PVector pAddPoint = PVector.sub(pWrist, pElbow);
      pAddPoint.setMag(pStrength);
      PVector pSecondPoint = PVector.add(pWrist, pAddPoint);      
      
      //translate ((wrist.x + elbow.x)/2, (wrist.y + elbow.y)/2, (wrist.z + elbow.z)/2);     
//      println(" colour is: "+colour);
      noStroke();
      fill(colour);
      smooth();

      beginShape();
      vertex(wrist.x, wrist.y, wrist.z);
      vertex( secondPoint.x, secondPoint.y, secondPoint.z);
      vertex( pSecondPoint.x, pSecondPoint.y, pSecondPoint.z);
      vertex(pWrist.x, pWrist.y, pWrist.z);
      endShape(CLOSE);
      
      
    }
  
  }
  
  void brush3(Stroke _s){
          stroke(255);
//          float colour = _s.stroke.get(i).colour;
    fill(255);
    beginShape();
    for (int i=1; i<_s.stroke.size(); i++)
    {
      PVector wrist = _s.stroke.get(i).wrist;
      PVector elbow = _s.stroke.get(i).elbow;
      float strength = _s.stroke.get(i).strength;
      
      PVector addPoint = PVector.sub(wrist, elbow);
      addPoint.setMag(strength);
      PVector secondPoint = PVector.add(wrist, addPoint);
      
      //translate ((wrist.x + elbow.x)/2, (wrist.y + elbow.y)/2, (wrist.z + elbow.z)/2); 
      
      
      curveVertex (wrist.x, wrist.y, wrist.z);
      if (i == _s.stroke.size() - 1)
      {
        vertex (secondPoint.x, secondPoint.y, secondPoint.z);
      }
      
      
    }
     
    
    for (int i=_s.stroke.size()-1; i >= 0; i--)
    {
      PVector wrist = _s.stroke.get(i).wrist;
      PVector elbow = _s.stroke.get(i).elbow;
      float strength = _s.stroke.get(i).strength;
      
      PVector addPoint = PVector.sub(wrist, elbow);
      addPoint.setMag(strength);
      PVector secondPoint = PVector.add(wrist, addPoint);
      
      //translate ((wrist.x + elbow.x)/2, (wrist.y + elbow.y)/2, (wrist.z + elbow.z)/2); 
      
      curveVertex (secondPoint.x, secondPoint.y, secondPoint.z); 
    }
    
    endShape(CLOSE);
    
      
  
  }
  
  
    
  void drawMe(Stroke _s)
  {
    if (_s.brush == 1) brush2(_s);
    else 
    println ("no such a brush");
  }
  

}
