/*
  Here we have all the classes connected to storage and output

*/
<<<<<<< HEAD
/*
=======
>>>>>>> 2921c9b74a854206d6dde5663c55d90d29355352
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
  
  void Stroke(){
    stroke = new ArrayList<Arm>();
  }
  
  void addArm(PVector _elbow, PVector _wrist, float _str)
  {
    stroke.add(new Arm(_elbow, _wrist, _str));
  }
  
<<<<<<< HEAD
}*/


=======
}
>>>>>>> 2921c9b74a854206d6dde5663c55d90d29355352
