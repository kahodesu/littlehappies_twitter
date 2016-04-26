///////////////////////////////////////
//         AUTO TWITTERER            //
//          by Kaho Abe              //
//          Sept 4, 2015             //
///////////////////////////////////////
// Made this for games.              //
// Run this seperately to tweet as   //
// many images as possible, without  //
// shutting down.                    //
///////////////////////////////////////

//=======================LIBRARIES=======================

//twitter4j java library can be found at http://twitter4j.org/en/index.html
import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;

import java.util.*;
import java.io.*;

//=======================VARIABLES=======================
Twitter twitter;
String str = "";
boolean lastTimeTweeted = false;
Timer timer;
String[] lines = new String [4];

//=======================SET UP=======================
void setupTwitterer()
{


//this text file has all the secret codes to tweet
//gets parsed and distributed into the OAuth functions
  lines = loadStrings(sketchPath()+"/file.txt");
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey(lines[0]);
  cb.setOAuthConsumerSecret(lines[1]);
  cb.setOAuthAccessToken(lines[2]);
  cb.setOAuthAccessTokenSecret(lines[3]);

  TwitterFactory tf = new TwitterFactory(cb.build());
  twitter = tf.getInstance();

//starting the timer for 2 seconds 
//the min time required between tweets before the account is frozen
  timer = new Timer(120000); 
  timer.start();
}

//=======================DRAW=======================
void checkTwitterer()
{
 //print(lastTimeTweeted);//FOR DEBUG
//if you didn't tweet last time then check to see if there's something to tweet
  if (lastTimeTweeted == false) {
    check();
  }
//or if the timer is finished and you did just tweet something then check if there's something to tweet
  else if (timer.isFinished()&& lastTimeTweeted == true) {
    check();
  }
//otherwise, just keep looping, maaaaaan. 
}

//you can use this to DEBUG
//void keyPressed()
//{
//  tweet();
//}

//=======================CHECKING FUNCTION=======================
//This function checks to see if you have something 
//waiting to be tweeted in the data folder

void check() {
//sets path to the data folder
  File dir = new File(sketchPath()+"/data/tweets"); 
//makes a list of files in data folder excluding hidden file .DS_Store found in macs
  File[] list = dir.listFiles(excludeHidden);
//if there is something in the folder, then tweet it!
  if (list.length!=0) {
    tweet(dir, list);       //tweeting
    lastTimeTweeted = true; //just tweeted!
    timer.start();          //reset the timer
  } 
//if there isn't anything in the folder then you didn't just tweet
  else {
    lastTimeTweeted = false;
  }
}

//=======================FILTERS=======================
//filters out any .DS_Store file like on a mac

FilenameFilter excludeHidden = new FilenameFilter() {
  boolean accept(File dir, String name) {
    return !name.equals(".DS_Store");
  }
};