//STUFF RELATED TO BUTTON
//changed this to mousepressed since new start button is soldered to USB mouse circuit board. 

/////////////////////FUNCTIONS////////////////////
void button(PApplet pa) {
  if(mousePressed && mode == 0) { //if the button is pressed when it's in default mode then start the game
    //println("start game"); //FOR DEBUG
    mode = 1; //goes to game mode
    playGame = new game(pa);
    
   }
}

