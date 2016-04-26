// Stuff Related to Game Class

/////////////////////////////VARIABLES/////////////////////////////
game playGame;
int lastPicPlayed = 0;
String timestamp = "";
/////////////////////////////CLASS/////////////////////////////
class game {

  /////////////////////////////DATA///////////////////////////// 
  int numPixels = 307200; //height * width
  int[] bgBmpPixels = new int[numPixels]; //temporary array for b&w silhouette image
  int[] kinectPixels = new int[numPixels]; //temporary array for silhouette image
  int phase =0;
  String[] gamePics = {"games", "japanesefood", "legos", "pizzaicecream", "nature", "plushies"};
  String chosenObject = "";
  PImage gameObject;
  PImage scanned;
  int gameTimer = 0; //timer
  KinectTracker tracker;

  Minim minim;
  AudioPlayer player;
  AudioPlayer cdplayer;
  //   AudioPlayer magic;
  String stringscore ="";

  int oldPicBright =255;
  int newPicBright =0;

  /////////////////////////////CONSTRUCTOR/////////////////////////////  
  game(PApplet pa) {
    // println(numPixels);
   // tracker = new KinectTracker(pa);   
   tracker = new KinectTracker();  
    //////////////CHOSE OBJET RANDOMLY////////////
    int randomNum = int(random(gamePics.length-1));
    if (randomNum == lastPicPlayed) {//This part is so you never get repeats of chosen image
      randomNum++;
      if (randomNum>gamePics.length-1) {
        randomNum = 0;
      }
    }
    lastPicPlayed = randomNum; //stores in global variable so that next image is not the same image
    chosenObject=gamePics[randomNum];
    gameObject = loadImage(chosenObject+".png");
    println(chosenObject);//FOR DEBUG
    gameTimer = millis(); //start timer
    timestamp = (hour() +"_"+ minute()+"_"+month()+"_"+day()+"_"+ year());
    scanned = loadImage("scanned.jpg");   
    scanned.loadPixels();
    //////////////SOUND SHIT/////////////////////
    minim = new Minim(pa); // load a file, give the AudioPlayer buffers that are 2048 samples long
    player = minim.loadFile("LittleHappies2.wav", 2048);
    cdplayer = minim.loadFile("countCAM.wav", 2048);
    //  magic = minim.loadFile("magic_2.wav", 2048);

    player.loop();
  } 

  /////////////////////////////FUNCTIONS/////////////////////////////
  void run() {
    /////////PHASE 0: SHOWS RANDOMLY SELECTED OBJECT///////////
    if (phase == 0) { //intro object
      PImage a;
      a = loadImage("screen_random.png");
      background(a);
      image(gameObject, 192, 239, 261, 196);
      checkGameTimer(10000);
    }
    /////////PHASE 1: SHOWS OBJECT & WEBCAM SUPERIMPOSED///////////
    else if (phase == 1) {//seeThru
      tracker.seethru(chosenObject);
      checkGameTimer(10000);
    }
    /////////PHASE 2: SHOWS OBJECT & WEBCAM SUPERIMPOSED & COUNTDOWN///////////
    else if (phase == 2) {//Countdown
      cdplayer.play();
      tracker.seethru(chosenObject);
      if (!cdplayer.isPlaying()) {
        tracker.freezeWebCam();

        tracker.track();
        tracker.display();
        tracker.track();
        tracker.display();
        tracker.track();
        tracker.display();
        /*try {
         Thread.sleep(2000);
         } 
         catch(InterruptedException e) {
         } */
        gameTimer = millis();
        phase++;
      }
    } 
    /////////PHASE 3: SSCORING///////////
    else if (phase == 3) {//scoring
      oneLineTxt("calculating...");
      scoreMe();
    } 
    /////////PHASE 4: SHOWS FINAL SNAP SHOT & SAVES IMAGES ON COMPUTER//////////
    else if (phase == 4) {//scoring
      // screenImage("screens/NSW_scrn4.png");
      PImage a;
      a = loadImage("screen_score.png");
      background(a);
      scoreTxt(stringscore);   
      PImage d;
      d = loadImage("gamepic.jpg");
      image(d, 40, 250, 261, 196);
      checkGameTimer(10000);
    } else if (phase == 5) {//scoring
      PImage d;
      d = loadImage(chosenObject+".png");
      image(d, 0, 0);
      checkGameTimer(5000);
    } else if (phase == 6) {
      picFade(chosenObject+".png", "scanned.jpg");
    } else if (phase == 7) {
      picFade("scanned.jpg", "emailthis.jpg");
    }
    /////////PHASE 5:  STUFF//////////
    else if (phase == 8) {//scoring
      PImage k;
      k= loadImage("emailthis.jpg");
      // sendMail(stringscore);
     // tweet(stringscore);
      image(k, 0, 0);
      save(sketchPath() + "/data/tweets/Indiecade East 2016 Score:"+stringscore+"%.jpg"); 
      phase++;
      // checkGameTimer(10000);
    }

    /////////PHASE : //////////
    else if (phase == 9) {
      PImage n;
      n = loadImage("gamepic.jpg");
      image(n, 0, 0);
      save(stringscore+"%.jpg"); 
      phase ++;
    } else if (phase == 10) {
      stop();
    }
  }

  void picFade(String oldPic, String newPic) {
    background(255);
    tint(255, newPicBright);   
    PImage l;
    l = loadImage(newPic);
    image(l, 0, 0);
    tint(255, oldPicBright);
    PImage m;
    m = loadImage(oldPic);
    image(m, 0, 0);
    if (oldPicBright>0) {
      newPicBright=newPicBright+5;
      oldPicBright=oldPicBright-5;
    } else {
      tint(255, 255);   
      PImage q;
      q = loadImage(newPic);
      image(q, 0, 0);
      checkGameTimer(5000);  //Keeps showing new Pic for a while
    }
  }

  void scoreMe() {
    println("scoring first");
    PImage chosenOutline;
    chosenOutline = loadImage(chosenObject +".bmp");
    chosenOutline.loadPixels();
    float pixelBrightness; // Declare variable to store a pixel's color
    //FIRST CHECK TOTAL NUMBER OF SHADOW PIXELS
    for (Integer i = 0; i < (numPixels); i++) {
      pixelBrightness = brightness(chosenOutline.pixels[i]);
      // if (pixelBrightness < threshold) { // If the pixel is brighter than the
      if (pixelBrightness<125.0) {
        bgBmpPixels[i] = 0; // make it black;
      } else { // Otherwise,
        bgBmpPixels[i] = 1;
      }
    }

    PImage gamePic;
    //pic = loadImage("bw_pic.bmp");
    gamePic = loadImage("bw_pic.bmp");
    gamePic.loadPixels();
    for (Integer h = 0; h < (numPixels); h++) {
      pixelBrightness = brightness(gamePic.pixels[h]);
      if (pixelBrightness<125.0) {
        kinectPixels[h] = 0; // make it black;
      } else { // Otherwise,
        kinectPixels[h] = 1;
      }
    }   

    println("calculating...");
    int total =0;
    int score =0;
    for (int j = 0; j < numPixels; j++) { 
      if (kinectPixels[j] == 0 && bgBmpPixels[j] == 0) {
        total++;
        score++;
        scanned.pixels[j] = color(0, 255, 0);
      } else if (kinectPixels[j] ==1 && bgBmpPixels[j] ==0||kinectPixels[j] ==0 && bgBmpPixels[j] ==1) {
        total++;
        scanned.pixels[j] = color(255, 0, 0);
      } else
      {
        scanned.pixels[j] = color(0);
      }
    }
    scanned.updatePixels();
    scanned.save(sketchPath()+"/scanned.jpg");


    float tempnum= (100*(float(score)/float(total)));
    if (tempnum >100.0) 
      tempnum =100.0;
    stringscore = Integer.toString(int(tempnum));
    PImage a;
    a = loadImage("gamepic.jpg");
    background(a);
    //screenImage("gamepic.jpg");
    PImage b;
    b = loadImage(chosenObject+".png");
    image(b, 490, 365, 113, 85);
    save(sketchPath()+"/emailthis.jpg");
    background(0);
    gameTimer = millis();
    // trigger.magic;


    phase++;
  }

  void checkGameTimer(int timeLimit) {
    if (millis() - gameTimer > timeLimit) {
      gameTimer = millis();
      println("timelimit met");
      oldPicBright =255;
      newPicBright =0;
      phase++;
    }
  }

  void stop() {

    phase = 0;
    mode = 0;
    cdplayer.close();
    player.close();
  }
}