class Title extends State {
  int bgPos1 = 0;
  int bgPos2 = -1 * __WIDTH__;
  int fadeIn = 0;
  int menuNum = 0;
  State[] gameState;

  private Str[] menuOptions = [
    "Start Game",
    "Online mode",
    "Instructions"
  ];

  private void handleMenuInteract(menuNum) {
    switch(menuNum) {
      case 0: // Single player
        if (!this.block) {
          this.gameState.add(new Playing(1));
          this.gameState.add(new Playing(0));
          this.gameState.add(new Playing(2));
          this.gameState.add(new Gameover());
          this.block = true;
        }
        break;
      case 1: // Online mode
        network.start();
        Input.setNetwork(network);
        break;
      case 2: // Instructions
        ArrayList<Dialogue> about = new ArrayList<Dialogue>();
        about.add(new Dialogue(-1, null, "Welcome to Tank Wars! \n\n (...)"));
        about.add(new Dialogue(-1, "Controls", "Movement: <W> <A> <S> <D> / Mouse: (Aiming) \nShoot: <Space> / Charge: <Space> + hold \nSwitch Weapon: <R>"));
        narrator.say(about);
        break;
      default:
        break;
    }
  }

  Title(State[] gameState) {
    this.gameState = gameState;
  }

  void drawBackground() {
    image(asset.get("Title2"), bgPos1++, 0);
    image(asset.get("Title2"), bgPos2++, 0);
    image(asset.get("Title1"), 0, 0);
    if (bgPos1 >= __WIDTH__) bgPos1 = -1 * __WIDTH__;
    if (bgPos2 >= __WIDTH__) bgPos2 = -1 * __WIDTH__;
  }

  void drawLogo() {
    tint(255, this.fadeIn);
    image(asset.get("Title_"), width/2-(539/2)-31, height/2-(179/2)-50);
    noTint();
  }

  void drawMenu() {
    // Draw menu options
    textAlign(CENTER);
    textSize(24);
    fill(255);
    for (int i=0; i < this.menuOptions.length; i++) {
      int optionPos = 100 + (i * 50)
      text(this.menuOptions[i], __WIDTH__/2, __HEIGHT__/2 + optionPos);
    }
    textAlign(LEFT);

    // Draw arrow indicator
    pushMatrix();
    int menuArrowPos = 85 + (this.menuNum * 50)
    translate(__WIDTH__/2-100, __HEIGHT__/2 + menuArrowPos);
    scale(0.5);
    triangle(0, 0, 25, 15, 0, 30);
    popMatrix();
  }

  void update() {
    drawBackground()
    drawLogo();
    this.fadeIn += this.fadeIn != 255 ? 3 : 0;
    if (this.fadeIn >= 100) {
      drawMenu();
    }
  }

  void keyDown() {
    if (Input.isUp()) {
      this.menuNum = this.menuNum == 0 ? this.menuOptions.length - 1: this.menuNum - 1;
    }

    if (Input.isDown()) {
      this.menuNum = this.menuNum < this.menuOptions.length - 1 ? this.menuNum + 1 : 0;
    }

    if (Input.isEnter()) {
      this.handleMenuInteract(this.menuNum);
    }
  }
}
