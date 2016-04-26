//Kinect Tracker class

class KinectTracker {


  // Depth threshold
  int threshold = 885;

  // Raw location
  PVector loc;

  // Interpolated location
  PVector lerpedLoc;

  // Depth data
  int[] depth;
  
  // What we'll show the user
  PImage display;
   

 KinectTracker() {
    // This is an awkard use of a global variable here
    // But doing it this way for simplicity
    kinect.initDepth();
  kinect.initVideo();
    kinect.enableMirror(true);
    // Make a blank image
    display = createImage(kinect.width, kinect.height, RGB);
    // Set up the vectors
    loc = new PVector(0, 0);
    lerpedLoc = new PVector(0, 0);
  }


  void seethru(String imagePic) {  //background is image, video superimposed on top
    PImage pic;
    pic = loadImage(imagePic +".png");
    background(pic);
    tint(255, 100);
    //this part flips video from kinect and then displays it
    //pushMatrix();
    //scale(-1, 1);
    //PImage img = kinect.getVideoImage();
    //image(img, -640, 0);

  //pushMatrix();
    //scale(-1, 1);
  image(kinect.getVideoImage(), 0, 0);
    //popMatrix();
  }

  void freezeWebCam() {  //capturing video to still image
    //kinect.enableDepth(true);//don't need depth until later
    background(0);
    tint(255, 255);
    //this part flips video from kinect and then displays it
    //pushMatrix();
    //scale(-1, 1);
    PImage img = kinect.getVideoImage();
    image(img, 0, 0); 
    //popMatrix();   
    save("gamepic.jpg");
  }

  void track() {
    // Get the raw depth as array of integers
    depth = kinect.getRawDepth();

    // Being overly cautious here
    if (depth == null) return;

    float sumX = 0;
    float sumY = 0;
    float count = 0;

    for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {
        
        int offset =  x + y*kinect.width;
        // Grabbing the raw depth
        int rawDepth = depth[offset];

        // Testing against threshold
        if (rawDepth < threshold) {
          sumX += x;
          sumY += y;
          count++;
        }
      }
    }
    // As long as we found something
    if (count != 0) {
      loc = new PVector(sumX/count, sumY/count);
    }

    // Interpolating the location, doing it arbitrarily for now
    lerpedLoc.x = PApplet.lerp(lerpedLoc.x, loc.x, 0.3f);
    lerpedLoc.y = PApplet.lerp(lerpedLoc.y, loc.y, 0.3f);
  }

  PVector getLerpedPos() {
    return lerpedLoc;
  }

  PVector getPos() {
    return loc;
  }

  void display() {
    PImage img = kinect.getDepthImage();

    // Being overly cautious here
    if (depth == null || img == null) return;

    // Going to rewrite the depth image to show which pixels are in threshold
    // A lot of this is redundant, but this is just for demonstration purposes
    display.loadPixels();
    for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {

        int offset = x + y * kinect.width;
        // Raw depth
        int rawDepth = depth[offset];
        int pix = x + y * display.width;
       if (rawDepth < threshold) {

          display.pixels[pix] = color(0);
        }

        else {
          display.pixels[pix] = color(255);
        }
      }
    }
    display.updatePixels();
    display.save("bw_pic.bmp");
  }

  int getThreshold() {
    return threshold;
  }

  void setThreshold(int t) {
    threshold =  t;
  }
}