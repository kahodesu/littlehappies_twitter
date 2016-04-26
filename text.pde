PFont font, font2;

void oneLineTxt(String line1) {//for one lined text on screen
    bigFont();
   text(line1, width/2, height/2); 
}

void twoLineTxt(String line1, String line2) {//for 2 lined text on screen
  littleFont();
   text(line1, width/2, 4*height/9);
  text(line2, width/2, 5*height/9);

}

void twoLineTxt2(String line1, String line2) {//for 2 lined text on screen
  littleFont();
   text(line1, width/2, 1*height/9);
  text(line2, width/2, 2*height/9);

}

void btmLineTxt(String line1) {//for one lined text on screen
littleFont();
  text(line1, width/8,  7*height/8); 

}

void scoreTxt(String scoreNum) {
     bigFont();
     text(scoreNum, 485,  350);     
}

void bigFont() {
    fill(0);
    font = loadFont("KomikaAxis-48.vlw"); //loadFont("KomikaAxis-24.vlw"); 
  textFont(font); 
  textAlign(CENTER);  
}

void littleFont() {
   fill(0);
   font2 = loadFont("KomikaAxis-24.vlw"); 
  textFont(font2); 
  textAlign(CENTER);  
}