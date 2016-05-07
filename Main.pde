 /****************
 Tank Wars
 by Philip Chung (301097069)
 *****************/
Asset asset;
Game game;

void setup() { 
  asset = new Asset();
  game = new Game();
  game.start();
}
void draw() {
  int s = millis();
  game.update(); 
  fill(255);
  textSize(16);
  text(millis() - s, 30, 30);
}
void keyPressed() { 
  game.keyDown();
}
void keyReleased() { 
  game.keyUp();
}
 


