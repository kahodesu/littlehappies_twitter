/////////////////////LIBRARIES////////////////////

import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import ddf.minim.*;  //for sound
//import javax.mail.*;  //for mailing
//import javax.mail.internet.*;//for mailing

/////////////////////VARIABLES////////////////////

int mode = 0; //game modes 0=REST, 1=GAME, 2=FINAL
Kinect kinect; //kinect camera named kinect

/////////////////////MAIN CODE/////////////////////
void setup()  {
  
  //BASIC SCREEN STUFF
  size(640, 480);  // size always goes first!
//  if (frame != null) {
//    frame.setResizable(true);
//}
 //size(displayWidth, displayHeight);

  smooth();
  noCursor();
  resting = new Rest(); 
  kinect = new Kinect(this);
  
  setupTwitterer();
}

void draw() {
  checkTwitterer();
  if (mode == 0) { //if it's in rest mode, show the default slides
    resting.run();
  }
 
  else if (mode == 1) { //if it's in game mode then run the game!
    playGame.run(); 
  }
  
  button(this);  //checks big button, see the x_button tab
}