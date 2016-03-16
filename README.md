# kinectV2calligraphy
Kinect v2 Calligraphy Drawing in 3D Space with hand/arm/finger tracking


Drawing engine:
- create a class that draws according to 3d points
- the class ought to be compatible with any coordinates
-> can be used with both Kinect v1 and Kinect v2


• Class: The Calligraphy
• Class: Stroke
• Class: Arm
	• PVector wrist
	• PVector elbow
	• Floating number strength (for fine adjustments by other hand?)

	
Version 1 		Version 2
SkeletonPoint 	CameraSpacePoint
ColorImagePoint 	ColorSpacePoint
DepthImagePoint 	DepthSpacePoint