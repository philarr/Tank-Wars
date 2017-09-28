class Gameover extends State {
  int background1 = 0;
  int background2 = -1 * __WIDTH__;
  int fadeIn = 0;
  int menuNum = 0;

  Gameover() {
    this.msg = false;
  }

  void start() {
    narrator.say1(new Dialogue(-1, null, "Thanks for playing!"));
  }

  void update() {
    image(asset.get("Title2"), background1++, 0);
    image(asset.get("Title2"), background2++, 0);
    image(asset.get("Title1"), 0, 0);
    image(asset.get("Title_"), width/2-(539/2)-31, height/2-(179/2)-50);
    noTint();
    if (background1 >= __WIDTH__) background1 = -1 * __WIDTH__;
    if (background2 >= __WIDTH__) background2 = -1 * __WIDTH__;
  }

  void keyDown() {
    if (Input.isEnter()) {
      this.block = true
    }
  }
}
