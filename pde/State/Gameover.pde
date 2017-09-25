class Gameover extends State {
  int background1 = 0;
  int background2 = -1 * __WIDTH__;
  int fadeIn = 0;
  int menuNum = 0;
  UI hud = new UI();

  Gameover() {
    this.msg = false;
  }

  void start() {
    hud.say1(new Dialogue(-1, null, "Thanks for playing!"));
  }

  void update() {
    image(asset.img.get(6), background1++, 0);
    image(asset.img.get(6), background2++, 0);
    image(asset.img.get(5), 0, 0);
    image(asset.img.get(7), width/2-(539/2)-31, height/2-(179/2)-50);
    noTint();
    hud.update();
    if (background1 >= __WIDTH__) background1 = -1 * __WIDTH__;
    if (background2 >= __WIDTH__) background2 = -1 * __WIDTH__;
  }

  void keyDown() {
    if (Input.isEnter()) {
      if (hud.interceptEnter()) return;
      this.block = true
    }
  }
}
