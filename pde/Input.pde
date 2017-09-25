class Input {
  Network network;

  Boolean up = false;
  Boolean down = false;
  Boolean left = false;
  Boolean right = false;
  Boolean space = false;
  Boolean r = false;

  static Boolean isP() {
    return key == 112;
  }

  static Boolean isR() {
    return key == 114;
  }

  static Boolean isUp() {
    return key == 119 || (key == CODED && keyCode == UP);
  }

  static Boolean isDown() {
    return key == 115 || (key == CODED && keyCode == DOWN);
  }

  static Boolean isLeft() {
    return key == 97 || (key == CODED && keyCode == LEFT);
  }

  static Boolean isRight() {
    return key == 100 || (key == CODED && keyCode == RIGHT);
  }

  static Boolean isEnter() {
    return (key == ' ' || key == ENTER || key == RETURN);
  }

  Input() { }

  void keyDown() {
    if (Input.isUp()) this.up = true;
    else if (Input.isDown()) this.down = true;
    else if (Input.isLeft()) this.left = true;
    else if (Input.isRight()) this.right = true;
    else if (Input.isR()) this.r = true;
    else if (Input.isEnter()) this.space = true;
  }

  void keyUp() {
    if (Input.isUp()) this.up = false;
    else if (Input.isDown()) this.down = false;
    else if (Input.isLeft()) this.left = false;
    else if (Input.isRight()) this.right = false;
    else if (Input.isR()) this.r = false;
    else if (Input.isEnter()) this.space = false;
  }
}