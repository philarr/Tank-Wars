//The portal to move onto the next state
class Portal extends Widget {
  State state;
  String name = PortalDef.NAME;

  Portal(float x, float y, Camera camera, State state) {
    super(x, y, PortalDef.WIDTH, PortalDef.HEIGHT, camera);
    this.state = state;
  }

  void draw() {
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    fill(50, 100, 190);
    rect(-PortalDef.WIDTH/2, -PortalDef.HEIGHT/2, PortalDef.WIDTH, PortalDef.HEIGHT);
    popMatrix();
  }

  void resolveCollision(boolean n) {
    //Player moved onto tile and is not already on it
    if (n && !this.on) {
      this.on = true;
      state.block = true;
      system.log('Leaving level ' + state.stage);
    }

    //Player moves out of tile..
    if (!n && this.on) {
      this.on = false;
    }
  }
}