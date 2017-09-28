class State {
  Boolean block; // If block is true, the state will be popped next frame
  Boolean pause; // Pause this state
  String id; // For online play purposes

  State() {
    this.block = false;
    this.pause = false;
  }

  State(String id) {
    this.block = false;
    this.pause = false;
    this.id = id;
  }

  void setBlock() {
    this.block = true;
  }

  boolean isBlocked() {
    return this.block;
  }

  boolean isPaused() {
    return this.pause;
  }

  void keyDown() { }
  void keyUp() { }
  void start() { }
  void return() { }
  void update() { }
  void draw() { }
}
