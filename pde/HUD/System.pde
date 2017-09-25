class SystemHUD extends HUD {
  static int offsetX = 10;
  static int offsetY = 10;
  static int boxWidth = 120;
  static int boxHeight = 35;
  static int textTimer = 120;

  SystemHUD() { }

  void log(String msg) {
    super.say1(new Dialogue(textTimer, 'System', msg, true));
  }

  void log(String author, String msg) {
    super.say1(new Dialogue(textTimer, author, msg, true));
  }

  void drawAuthor() {
    pushMatrix();
    translate(offsetX, offsetY);
    fill(56, 56, 56);
    noStroke();
    rect(0, 0, boxWidth, boxHeight);
    fill(255, 255, 255);
    textSize(21);
    textAlign(CENTER);
    text(current.author, 0, 10, boxWidth, boxHeight);
    textAlign(LEFT);
    popMatrix();
  }

  void drawMessage() {
    pushMatrix();
    translate(boxWidth + offsetX, offsetY);
    fill(46, 81, 120, 122);
    noStroke();
    rect(0, 0, width - (boxWidth + offsetX) - offsetX, boxHeight);
    fill(255, 255, 255);
    textSize(21);
    text(current.text, offsetX, offsetY, width - (boxWidth + offsetX) - offsetX, boxHeight);
    popMatrix();
  }

  void draw() {
    if (this.messageBox && this.current) {
      drawAuthor();
      drawMessage();
    }
  }
  void update() {
    super.update();
    this.draw();
  }
}
