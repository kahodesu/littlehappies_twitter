// REST MODE
//basically this is a slide show that uses a timer to show the screens looped. 

Rest resting;   

/////////////////////////////CLASS/////////////////////////////
class Rest {
  
/////////////////////////////DATA/////////////////////////////
  PImage screen1, screen2, screen3;   
  int restTimer = 0;
   
/////////////////////////////CONSTRUCTOR/////////////////////////////
  Rest() { 
    screen1 = loadImage("screen1.png");
    screen2 = loadImage("screen2.png");
    screen3 = loadImage("screen3.png");
  } 

/////////////////////////////FUNCTIONS/////////////////////////////
  void run() {

    if (restTimer == 0) {
     background(screen1);
    }
    if (restTimer == 750) {
      background(screen2);
    }
    if (restTimer == 1500) {
      background(screen3);
    }
    restTimer++;   
    if (restTimer >= 2250) {
      restTimer =0;
    }
  }
}