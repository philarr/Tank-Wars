class Input {
  Network network;

  Boolean STATE_UP = false;
  Boolean STATE_DOWN = false;
  Boolean STATE_LEFT = false;
  Boolean STATE_RIGHT = false;
  Boolean STATE_ENTER = false;
  Boolean STATE_R = false;
  Boolean STATE_P = false;

  static void setNetwork(Network network) {
    Input.network = network;
  }

  static void disableNetwork() {
    Input.network = null;
  }

  static Boolean isEsc() {
    return key == 27 || keyCode == ESC;
  }

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
    if (Input.isUp()) STATE_UP = true;
    else if (Input.isDown()) STATE_DOWN = true;
    else if (Input.isLeft()) STATE_LEFT = true;
    else if (Input.isRight()) STATE_RIGHT = true;
    else if (Input.isR()) STATE_R = true;
    else if (Input.isEnter()) STATE_ENTER = true;
  }

  void keyUp() {
    if (Input.isUp()) STATE_UP = false;
    else if (Input.isDown()) STATE_DOWN = false;
    else if (Input.isLeft()) STATE_LEFT = false;
    else if (Input.isRight()) STATE_RIGHT = false;
    else if (Input.isR()) STATE_R = false;
    else if (Input.isEnter()) STATE_ENTER = false;
  }
}