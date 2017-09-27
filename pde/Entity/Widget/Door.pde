//Door that changes wall to moveable tile
class Door extends Widget {
  boolean open;
  int timer;
  HUD hud;
  Trigger t;
  int tileX;
  int tileY;
  int[][] level;

  Door(float x, float y, Camera camera, HUD hud, int[][] level) {
    super(x, y, 50, 50, camera);
    this.tileX = int(x);
    this.tileY = int(y);
    this.hud = hud;
    this.timer = 0;
    this.level = level;
    open = false;
  }

  void update() {
    if (open && timer < 50) timer++;
    if (!open && timer != 0) timer--;
  }

  void draw() {
    pushMatrix();
    if (this.level[tileY][tileX+1] == 1)  translate2(this.tpos.x + this.timer, this.tpos.y);
    else if (this.level[tileY][tileX-1] == 1) translate2(this.tpos.x - this.timer, this.tpos.y);
    else if (this.level[tileY+1][tileX] == 1)  translate2(this.tpos.x, this.tpos.y + this.timer);
    else if (this.level[tileY-1][tileX] == 1)  translate2(this.tpos.x, this.tpos.y - this.timer);
    image(asset.img.get(8), -this.width/2, -this.height/2);
    popMatrix();
  }
  void unlock() {
    this.open = true;
    this.level[tileY][tileX] = 0;
  }
  void lock() {
    this.open = false;
    this.level[tileY][tileX] = 2;
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