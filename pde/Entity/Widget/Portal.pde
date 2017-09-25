//The portal to move onto the next state
class Portal extends Widget {
  HUD hud;
  State state;

  Portal(float x, float y, Camera camera, State state) {
    super(x, y, camera);
    this.state = state;
  }

  void draw() {
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    fill(50, 100, 190);
    rect(-25, -25, 50, 50);
    popMatrix();
  }

  void resolveCollision(boolean n) {
    //Player moved onto tile and is not already on it
    if (n && !this.on) {
      this.on = true;
      state.block = true;
    }
    //Player moves out of tile..

    if (!n && this.on) {
      this.on = false;
    }
  }
}