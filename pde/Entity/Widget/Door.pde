//Door that changes wall to moveable tile
class Door extends Widget {
  boolean open;
  int timer;
  HUD hud;
  Trigger t;
  int tileX;
  int tileY;
  int stage;

  Door(float x, float y, Camera camera, HUD hud, int stage) {
    super(x, y, camera);
    tileX = int(x);
    tileY = int(y);
    this.t = t;
    this.hud = hud;
    this.timer = 0;
    this.stage = stage;
    open = false;
  }

  void update() {
    if (open && timer < 50) timer++;
    if (!open && timer != 0) timer--;
  }

  void draw() {
    pushMatrix();
    if (level[stage][tileY][tileX+1] == 1)  translate2(tpos.x + timer, tpos.y);
    else if (level[stage][tileY][tileX-1] == 1) translate2(tpos.x - timer, tpos.y);
    else if (level[stage][tileY+1][tileX] == 1)  translate2(tpos.x, tpos.y + timer);
    else if (level[stage][tileY-1][tileX] == 1)  translate2(tpos.x, tpos.y - timer);

    image(asset.img.get(8), -wSize/2, -hSize/2);
    popMatrix();
  }
  void unlock() {
    this.open = true;
    level[stage][tileY][tileX] = 0;
  }
  void lock() {
    this.open = false;
    level[stage][tileY][tileX] = 2;
  }

  void resolveCollision(boolean n) {
    //Player moved onto tile and is not already on it
    if (n && !this.on) {
      this.on = true;
      if (!open) hud.say1(new Dialogue(100, null, "This door is locked..."));
    }
    //Player moves out of tile..

    if (!n && this.on) {
      this.on = false;
    }
  }
}