/* --------------------------------------------------------------------------
 * SimpleOpenNI User3d Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect 2 library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / Zhdk / http://iad.zhdk.ch/
 * date:  12/12/2012 (m/d/y)
 * ----------------------------------------------------------------------------
 */
 
import SimpleOpenNI.*;


SimpleOpenNI context;
float        zoomF =0.25f;
float        rotX = radians(180);  // by default rotate the whole scene 180deg around the x-axis, 
                                   // the data from openni comes upside down
float        rotY = radians(0);

float traY = 0;
float traX = 0;
float traZ = -1500;

boolean      autoCalib=true;

boolean      sceneRotation = true; // toggle with spacebar

PVector      bodyCenter = new PVector();
PVector      bodyDir = new PVector();
PVector      com = new PVector();                                   
PVector      com2d = new PVector();                                   
color[]      userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };

PImage rgbImg;
// Calligraphy myCal;

People myPeople;


// Shaders




// -----------------------------------------------------------------
// S E T U P

void setup()
{
//  size(640,480,P3D); 
  size(1440,960,P3D);
  
  //Setting up kinect context
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  
  // disable mirror
  context.setMirror(false);
  // enable cam image
  context.enableRGB();

  // enable depthMap generation 
  context.enableDepth();

  // enable skeleton generation for all joints
  context.enableUser();
  
  // align depth to cam
  context.alternativeViewPointDepthToImage();  
  context.setDepthColorSyncEnabled(true);  

  stroke(255,255,255);
  smooth();

  // Perspective adjustments  
  perspective(radians(51),
              float(width)/float(height),
              10,50000);
  // Setting up calligraphy class
  //myCal = new Calligraphy();
  myPeople = new People();  

}
 
 
// -----------------------------------------------------------------
// D R A W

void draw()
{
  // update the cam
  context.update();

  rgbImg = context.rgbImage();
  rgbImg.resize(width, height);
  background(0);
  ambientLight(200, 200, 200);
  spotLight(255, 255, 255, width/2, height/2, 0, width/2, height/2, 3000, PI/2, 2);
  spotLight(255, 255, 255, width/2, height/2, 400, 0, 0, -1, PI/4, 2);
   spotLight(255, 255, 255, 50, 50, 400, 0, 0, -1, PI/16, 2); 
  // set the scene pos
  translate(width/2, height/2, 0);
  if(sceneRotation){
    rotY = rotY + 0.02;
  }
    rotateX(rotX);
    rotateY(rotY);
  scale(zoomF);
  
  int[]   depthMap = context.depthMap();
  int[]   userMap = context.userMap();
  int     steps   = 2;  // add steps to speed up the drawing
  int     index;
  PVector realWorldPoint;

  translate(traX,traY,traZ);  // default 0, 0, -1000

  // draw the pointcloud
  
  beginShape(POINTS);
  for(int y=0;y < context.depthHeight();y+=steps)
  {
    for(int x=0;x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      if(depthMap[index] > 0)
      { 
        // draw the projected point
        realWorldPoint = context.depthMapRealWorld()[index];
        // but only if the user is there
        if(userMap[index] != 0) {
          // Get colour from the rgb pixel map
          stroke(rgbImg.pixels[index]);
          // Or the userClr array-adjusted presets
        //  stroke(userClr[ (userMap[index] - 1) % userClr.length ]);        
          point(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);
        } 
        else {
        }
        //  stroke(userClr[ (userMap[index] - 1) % userClr.length ]);        
        //  point(currentPoint.x, currentPoint.y, currentPoint.z); 
      }
    } 
  } 
  endShape();
  
  // draw the skeleton if it's available
  
  int[] userList = context.getUsers();
  
  for(int i=0;i<userList.length;i++) // For each user in the list
  {
    if(context.isTrackingSkeleton(userList[i])) 
      drawSkeleton(userList[i]);
    // draw the center of mass
    if(context.getCoM(userList[i],com))
    {
      stroke(130,130,130);
      strokeWeight(1);
      beginShape(LINES);
        vertex(com.x - 15,com.y,com.z);
        vertex(com.x + 15,com.y,com.z);
        
        vertex(com.x,com.y - 15,com.z);
        vertex(com.x,com.y + 15,com.z);

        vertex(com.x,com.y,com.z - 15);
        vertex(com.x,com.y,com.z + 15);
      endShape();
      
      fill(255,255,255);
      text(Integer.toString(userList[i]),com.x,com.y,com.z);
    }      
  }    
 
  // draw the kinect cam
//  context.drawCamFrustum();

  // adding new users to the list
  
  myPeople.addPeople(userList);
  
  println (myPeople.calligraphies.size());
  
  // draw calligraphy 
 
  
  for(int i=0;i<userList.length;i++) // For each user in the list
  {
    int uId = userList[i]; 
    
    if(context.isTrackingSkeleton(uId))
    {
            
      Calligraphy myCal = myPeople.getById(uId);
      
      
       PVector wristPos = new PVector();
       PVector elbowPos = new PVector();
       PVector leftWristPos = new PVector();
       PVector leftHipPos = new PVector();
       
       float  confidence;
       
       confidence =  context .getJointPositionSkeleton(userList[i],SimpleOpenNI.SKEL_RIGHT_HAND,wristPos);
       confidence =  context.getJointPositionSkeleton(userList[i],SimpleOpenNI.SKEL_RIGHT_ELBOW,elbowPos);
       confidence =  context.getJointPositionSkeleton(userList[i],SimpleOpenNI.SKEL_LEFT_HAND,leftWristPos);
       confidence =  context.getJointPositionSkeleton(userList[i],SimpleOpenNI.SKEL_LEFT_HIP,leftHipPos);
       
       //println(wristPos + "   " + elbowPos);

      // Adjuster hand
  
         // If left wrist is higher than left hip, draw stroke. Otherwise don't and show red.       
         // myCal.startStroke(1);
         if (leftWristPos.y > leftHipPos.y) 
         {
           myCal.startStroke(1);
           stroke(0,255,0);
         }
         else
        {
          myCal.finishStroke();
          stroke(130,0,0);
        }  
        pushMatrix();
          translate(leftWristPos.x, leftWristPos.y, leftWristPos.z);
          sphere(20);
        popMatrix();
        // Draw the arm, elbow to wrist. Third variable is "strength"
//        float str = (leftWristPos.y - leftHipPos.y)/8;
        float strength = (leftWristPos.y - leftHipPos.y)/8;

  //      float colour = userClr[ (userMap[i] - 1) % userClr.length ];
    
      color colour = userClr[uId-1];
      myCal.addArm(elbowPos, wristPos, strength, colour);
      
/*
        color colour;
      if(userMap[uId+1] != 0) {
        colour = userClr[ (userMap[uId]) % userClr.length ];
      } else {
        colour = 255;
      }

      println("user id: "+uId+", color = "+colour+", usermap: "+userClr[uId]);
*/
      stroke(colour);

      // Drawing hand
       pushMatrix();
         // Draw a "stick" to where the line will be drawn
         PVector handPoint = PVector.sub(wristPos, elbowPos);
         handPoint.setMag(strength);
         PVector brushPoint = PVector.add(wristPos, handPoint);
       //  translate(wristPos.x, wristPos.y, wristPos.z);
         strokeWeight(30);
         line(wristPos.x, wristPos.y, wristPos.z, brushPoint.x, brushPoint.y, brushPoint.z);
         strokeWeight(1);
//         box(str, str, str);
       popMatrix();
     
    }

  }
  
  for (int i=0; i < myPeople.calligraphies.size(); i++)
  {
    color c = color(255, 255, 255);
    myPeople.calligraphies.get(i).drawAll(c);
  }
  
  
}


// -----------------------------------------------------------------
// Kinect drawing functions

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  strokeWeight(3);

  // to get the 3d joint data
  drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
/*
  Hide the body parts that we don't need
*/
/*
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
*/
  // draw body direction
  getBodyDirection(userId,bodyCenter,bodyDir);
  
  bodyDir.mult(200);  // 200mm length
  bodyDir.add(bodyCenter);
  
  stroke(255,200,200);
  line(bodyCenter.x,bodyCenter.y,bodyCenter.z,
       bodyDir.x ,bodyDir.y,bodyDir.z);

  strokeWeight(1);
 
}

void drawLimb(int userId,int jointType1,int jointType2)
{
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float  confidence;
  
  // draw the joint position
  confidence = context.getJointPositionSkeleton(userId,jointType1,jointPos1);
  confidence = context.getJointPositionSkeleton(userId,jointType2,jointPos2);

  stroke(255,0,0,confidence * 200 + 55);
  line(jointPos1.x,jointPos1.y,jointPos1.z,
       jointPos2.x,jointPos2.y,jointPos2.z);
  
  drawJointOrientation(userId,jointType1,jointPos1,50);
}

void drawJointOrientation(int userId,int jointType,PVector pos,float length)
{
  // draw the joint orientation  
  PMatrix3D  orientation = new PMatrix3D();
  float confidence = context.getJointOrientationSkeleton(userId,jointType,orientation);
  if(confidence < 0.001f) 
    // nothing to draw, orientation data is useless
    return;
    
  pushMatrix();
    translate(pos.x,pos.y,pos.z);
    
    // set the local coordsys
    applyMatrix(orientation);
    
    // coordsys lines are 100mm long
    // x - r
    stroke(255,0,0,confidence * 200 + 55);
    line(0,0,0,
         length,0,0);
    // y - g
    stroke(0,255,0,confidence * 200 + 55);
    line(0,0,0,
         0,length,0);
    // z - b    
    stroke(0,0,255,confidence * 200 + 55);
    line(0,0,0,
         0,0,length);
  popMatrix();
}

void getBodyDirection(int userId,PVector centerPoint,PVector dir)
{
  PVector jointL = new PVector();
  PVector jointH = new PVector();
  PVector jointR = new PVector();
  float  confidence;
  
  // draw the joint position
  confidence = context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,jointL);
  confidence = context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_HEAD,jointH);
  confidence = context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,jointR);
  
  // take the neck as the center point
  confidence = context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,centerPoint);
  
  /*  // manually calc the centerPoint
  PVector shoulderDist = PVector.sub(jointL,jointR);
  centerPoint.set(PVector.mult(shoulderDist,.5));
  centerPoint.add(jointR);
  */
  
  PVector up = PVector.sub(jointH,centerPoint);
  PVector left = PVector.sub(jointR,centerPoint);
    
  dir.set(up.cross(left));
  dir.normalize();
}

// -----------------------------------------------------------------
// SimpleOpenNI user events

void onNewUser(SimpleOpenNI curContext,int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  context.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext,int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext,int userId)
{
  //println("onVisibleUser - userId: " + userId);
}


// -----------------------------------------------------------------
// Keyboard events (camera controls)

void keyPressed()
{
  logLocation();
  switch(key)
  {
  case 'R':
    context.setMirror(!context.mirror());
    sceneRotation = !sceneRotation;
    break;
  case ' ':
//    for (int i=myPeople.calligraphies.size(); i>=0; i++)
//        myPeople.calligraphies.get(i).remove();
//       myPeople.calligraphies.size drawAll();
        for (int i = myPeople.calligraphies.size() - 1; i >= 0; i--) {
          Calligraphy ret = myPeople.calligraphies.get(i);
          myPeople.calligraphies.remove(i);
        }
    break;
  }
    
  switch(keyCode)
  {
    case LEFT:
      if(keyEvent.isControlDown()){
        traX -= 100;
      } else {
        rotY += 0.1f;        
      }
      break;
    case RIGHT:
      if(keyEvent.isControlDown()){
        traX += 100;
      } else {
        // zoom out
        rotY -= 0.1f;
      }
      break;
    case UP:
      if(keyEvent.isControlDown() && keyEvent.isControlDown()){
        traZ += 100;
      } else {
        if(keyEvent.isControlDown()){
          traY += 100;
        } else {
          if(keyEvent.isShiftDown()){
            zoomF += 0.01f;
          } else {
            rotX += 0.1f;
          }
        }
      }
      break;
    case DOWN:
      if(keyEvent.isControlDown() && keyEvent.isControlDown()){
        traZ -= 100;
      } else {
        if(keyEvent.isControlDown()){
          traY -= 100;
        } else {
          if(keyEvent.isShiftDown()){
            zoomF -= 0.01f;
            if(zoomF < 0.01)
              zoomF = 0.01;
          }
          else {
            rotX -= 0.1f;
          }
        }
      }
      break;
  }
}

void logLocation(){
      println("traX: "+traX+" | traY: "+traY+" | traZ: "+traZ+" | zoomF: "+zoomF+" | rotX: "+rotX+" | rotY: "+rotY+".");
}
