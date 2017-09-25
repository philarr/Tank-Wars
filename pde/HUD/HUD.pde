class HUD {
  int timer = 0;
  ArrayList<Dialogue> dialogue = new ArrayList<Dialogue>();
  Dialogue current = null;
  boolean messageBox = false;

  HUD() { }

  void say1(Dialogue a) {
    timer = 0;
    dialogue.clear();
    dialogue.add(a);
  }

  void say(ArrayList<Dialogue> d) {
    timer = 0;
    dialogue.clear();
    dialogue.addAll(d);
  }

  void closeMsgBox() {
    this.messageBox = false;
  }

  boolean interceptEnter() {
    if (this.messageBox) {
      if (this.current.sticky) return false;
      this.timer = 0;
      return true;
    }
    return false;
  }

  void updateMessageState() {
    if (this.dialogue.size() > 0 ) {
      if (this.timer == 0) {
        this.dialogue.remove(current);
        if (this.dialogue.size() > 0) {
          this.current = this.dialogue.get(0);
          this.timer += this.current.timer;
        }
      }
      else this.messageBox = true;
      if (this.timer > 0) this.timer--;
    }
    else this.closeMsgBox();
  }

  /*
    Count down current message timer, goes to next message
    if exists, if not = close message box, drawing is handled
    by subclasses.
  */
  void update() {
    this.updateMessageState();
  }
}
