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
  game.update(); 
}
void keyPressed() { 
  game.keyDown();
}
void keyReleased() { 
  game.keyUp();
}
 


