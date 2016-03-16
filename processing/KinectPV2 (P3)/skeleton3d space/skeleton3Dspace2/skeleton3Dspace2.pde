import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import peasy.test.*;


import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;
PeasyCam cam;



void setup() {   
  size(1024, 768, P3D);   
  kinect = new KinectPV2(this);   
//  kinect.enableSkeleton(true);
//  kinect.enableColorMap(true);
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeleton3DMap(true);
  kinect.enableSkeletonDepthMap(true);
  kinect.enableBodyTrackImg(true);  
  
  kinect.init();
  
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(1200);
  
}  
void draw() {
  background(0);   
  image(kinect.getDepthMaskImage(), 0, 0);
  //get the skeletons as an Arraylist of KSkeletons
    //  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();
  //get the skeleton as an Arraylist mapped to the color frame
    //  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  //get the skeleton as an Arraylist mapped to the 3D skeleton
      ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
  //individual joints
  for (int i = 0; i < skeletonArray.size(); i++) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      KJoint[] joints = skeleton.getJoints();
      color col  = skeleton.getIndexColor();
      fill(col);
      stroke(col);
      drawBody(joints);
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);
    }
  }
  
  
void drawBody(KJoint[] joints) {
  
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);
  
  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
}


//draw joint
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
//  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  float joiX = map(joints[jointType].getX(),-2,2,0,width);
  float joiY = map(joints[jointType].getY(),-2,2,0,height);
  float joiZ = map(joints[jointType].getZ(),-10,10,-200,200);
  translate(joiX,joiY,joiZ);
//  translate(joints[jointType].getX()*width/2 + width/2,-1*joints[jointType].getY()*height/2 + height/2, joints[jointType].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
  println("x: "+ joints[jointType].getX() +" | y: "+ joints[jointType].getY() +" | z: "+ joints[jointType].getZ() );
}

//draw bone
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX()*width/2 + width/2,-1*joints[jointType1].getY()*height/2 + height/2, joints[jointType1].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
  //  println("r-thumb:" + KinectPV2.JointType_ThumbRight +" | r-wrist: "+ KinectPV2.JointType_WristRight +" | r-elbow: " + KinectPV2.JointType_ElbowRight );
}

//draw hand state
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
//  println("z? - " + joint.getZ());
  ellipse(0, 0, 70, 70);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(255, 255, 255);
    break;
  }
}