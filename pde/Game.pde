//Game class to manage the states
class Game {
  int fade; //Fade in when state changes
  ArrayList<State> gameState = new ArrayList<State>(); //Holds the states
  State cState; //Current state

  private void resetTransition() {
    this.fade = 255;
  }

  private void drawTransition() {
    if (this.fade != 0 ) {
      fill(0, 0, 0, this.fade);
      rect(0, 0, width, height);
    }
    if (this.fade > 0) this.fade -= 5;
  }

  Game() {
    this.fade = 0;
  }

  void start() {
    //Preload the font so game doesn't stutter when it first appears in the middle of the game
    text("", 0, 0);
    this.gameState.add(new Title(this.gameState));
    this.cState = gameState.get(0);
    this.cState.start();
  }

  void update() {
    //If state is blocked, remove and go to the next state
    if (cState.isBlocked()) {
      this.resetTransition()
      this.gameState.remove(this.cState);
      if (this.gameState.size() == 0) {
        this.gameState.add(new Title(this.gameState));
      }
      this.cState = this.gameState.get(0);
      this.cState.start();
    }
    this.cState.update();
    this.drawTransition();
  }

  void keyDown() {
    this.cState.keyDown();
  }

  void keyUp() {
    this.cState.keyUp();
  }
}

