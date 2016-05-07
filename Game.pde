//Game class to manage the states
class Game { 

  int fullWidth = 800;
  int fullHeight = 600;
  int fade; //Fade in when state changes
 

  ArrayList<State> gameState = new ArrayList<State>(); //Holds the states
  State cState; //Current state
  Game() {
    fade = 0;
  }

  void start() {    
    size(fullWidth, fullHeight);
    //Preload the font so game doesn't stutter when it first appears in the middle of the game
    text("", 0, 0);

    gameState.add(new Title());
    //gameState.add(new Playing(1));
    gameState.add(new Playing(0));
    gameState.add(new Playing(2));
    gameState.add(new Gameover());
    cState = gameState.get(0);
    cState.start();
  }

  void update() { 
    //If state is blocked, remove and go to the next state
    if (cState.isBlocked()) {
      fade = 255;
      gameState.remove(cState);
      cState = gameState.get(0);
      cState.start();
    }
    cState.update();
    if (fade != 0 ) {
      fill(0, 0, 0, fade);
      rect(0, 0, width, height);
    }
    if (fade > 0) fade -= 5;
  }

 

  void keyDown() { 
    cState.keyDown();
  }
  void keyUp() { 
    cState.keyUp();
  }
}

