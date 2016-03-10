/*
  Here we have all the classes connected to storage and output

*/
class Arm
{
  public PVector wrist; 
  public PVector elbow; 
  public float strength;
  
  void Arm(PVector _elbow, PVector _wrist, float _str )
  {
    wrist = new PVector(_wrist.x, _wrist.y,_wrist.z);
    elbow = new PVector(_elbow.x, _elbow.y,_elbow.z);
    strength = _str;
  }
}

class Stroke
{
  public ArrayList<Arm> stroke;
  
  void Stroke(){
    stroke = new ArrayList<Arm>();
  }
  
  void addArm(PVector _elbow, PVector _wrist, float _str)
  {
    Arm myArm = new Arm(_elbow, _wrist, _str); 
    stroke.add();
  }
  
}