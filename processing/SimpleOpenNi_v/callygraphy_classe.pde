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
  
  void drawAll(color _c)
  {
    Brushes myBrushes = new Brushes();
    for (int i=0; i<strokes.size(); i++)
    {
      
      myBrushes.drawMe(strokes.get(i), _c);
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
  
   void brush4(Stroke _s, color _c){
    stroke(255);

   /* noFill();
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
    
    endShape(CLOSE); */
    
    
    for (int i=1; i<_s.stroke.size()-2; i++)
    {
      
      // Saving end- and control points for the line segment
      
      PVector wrist1 = _s.stroke.get(i-1).wrist;
      PVector elbow1 = _s.stroke.get(i-1).elbow;
      float strength1 = _s.stroke.get(i-1).strength;
      
      PVector addPoint1 = PVector.sub(wrist1, elbow1);
      addPoint1.setMag(strength1);
      PVector secondPoint1 = PVector.add(wrist1, addPoint1);
      
      PVector wrist2 = _s.stroke.get(i).wrist;
      PVector elbow2 = _s.stroke.get(i).elbow;
      float strength2 = _s.stroke.get(i).strength;
      
      PVector addPoint2 = PVector.sub(wrist2, elbow2);
      addPoint2.setMag(strength2);
      PVector secondPoint2 = PVector.add(wrist2, addPoint2);
      
      
      PVector wrist3 = _s.stroke.get(i+1).wrist;
      PVector elbow3 = _s.stroke.get(i+1).elbow;
      float strength3 = _s.stroke.get(i+1).strength;
      
      PVector addPoint3 = PVector.sub(wrist3, elbow3);
      addPoint3.setMag(strength3);
      PVector secondPoint3 = PVector.add(wrist3, addPoint3);
      
      PVector wrist4 = _s.stroke.get(i+2).wrist;
      PVector elbow4 = _s.stroke.get(i+2).elbow;
      float strength4 = _s.stroke.get(i+2).strength;
      
      PVector addPoint4 = PVector.sub(wrist4, elbow4);
      addPoint4.setMag(strength4);
      PVector secondPoint4 = PVector.add(wrist4, addPoint4);
    
      int steps = 4; // Precision
      
      
      // Drawing segmented line
      
      for (int j = 1; j <= steps; j++) {
        float t = j / (float(steps));
        float tp = (j - 1) / (float(steps));
        
        float x1 = curvePoint(wrist1.x, wrist2.x, wrist3.x, wrist4.x, t);
        float y1 = curvePoint(wrist1.y, wrist2.y, wrist3.y, wrist4.y, t);
        float z1 = curvePoint(wrist1.z, wrist2.z, wrist3.z, wrist4.z, t);
        
        float x2 = curvePoint(wrist1.x, wrist2.x, wrist3.x, wrist4.x, tp);
        float y2 = curvePoint(wrist1.y, wrist2.y, wrist3.y, wrist4.y, tp);
        float z2 = curvePoint(wrist1.z, wrist2.z, wrist3.z, wrist4.z, tp);
        
        float x3 = curvePoint(secondPoint1.x, secondPoint2.x, secondPoint3.x, secondPoint4.x, tp);
        float y3 = curvePoint(secondPoint1.y, secondPoint2.y, secondPoint3.y, secondPoint4.y, tp);
        float z3 = curvePoint(secondPoint1.z, secondPoint2.z, secondPoint3.z, secondPoint4.z, tp);
        
        float x4 = curvePoint(secondPoint1.x, secondPoint2.x, secondPoint3.x, secondPoint4.x, t);
        float y4 = curvePoint(secondPoint1.y, secondPoint2.y, secondPoint3.y, secondPoint4.y, t);
        float z4 = curvePoint(secondPoint1.z, secondPoint2.z, secondPoint3.z, secondPoint4.z, t);
        
        fill(red(_c),green(_c), blue(_c), 96);
        blendMode(BLEND);

        noStroke();
        beginShape();
          vertex(x1, y1, z1);
          vertex(x2, y2, z2);
          vertex(x3, y3, z3);
          vertex(x4, y4, z4);
        endShape(CLOSE);
        
        
      }
    
      
      
    }
  blendMode(ADD);
      
  
  }
  
  
    
  void drawMe(Stroke _s, color _c)
  {
//    if (_s.brush == 1) brush2(_s);
if (_s.brush == 1) brush4(_s, _c);
    else 
    println ("no such a brush");
  }
  

}
