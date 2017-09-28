//Door that changes wall to moveable tile
class Door extends Widget {
  boolean open;
  int timer;
  Trigger t;
  int direction;

  PImage ASSET_BASE;

  static int getDirection(int x, int y, int[][] level) {
    if (level[y][x+1] == 1) return DoorDef.SLIDE_LEFT;
    if (level[y][x-1] == 1) return DoorDef.SLIDE_RIGHT;
    if (level[y+1][x] == 1) return DoorDef.SLIDE_DOWN;
    if (level[y-1][x] == 1) return DoorDef.SLIDE_UP;
  }

  Door(float x, float y, Camera camera) {
    super(x, y, 50, 50, camera);
    this.timer = 0;
    this.level = level;
    this.open = false;
    ASSET_BASE = asset.get(DoorDef.ASSET_BASE);
  }

  void update() {
    if (open && timer < 50) timer++;
    if (!open && timer != 0) timer--;
  }

  void animateDoorOpen() {
    if (this.timer == 0) return;
    switch(this.direction) {
      case DoorDef.SLIDE_UP:
        translate2(this.tpos.x, this.tpos.y - this.timer);
        break;
      case DoorDef.SLIDE_DOWN:
        translate2(this.tpos.x, this.tpos.y + this.timer);
        break;
      case DoorDef.SLIDE_LEFT:
        translate2(this.tpos.x - this.timer, this.tpos.y);
        break;
      case DoorDef.SLIDE_RIGHT:
        translate2(this.tpos.x + this.timer, this.tpos.y);
        break;
      default:
        break;
    }
  }

  void draw() {
    pushMatrix();
    animateDoorOpen();
    image(ASSET_BASE, -this.w/2, -this.h/2);
    popMatrix();
  }
  void unlock() {
    this.open = true;
    // this.level[tileY][tileX] = 0;
  }
  void lock() {
    this.open = false;
    // this.level[tileY][tileX] = 2;
  }

  void resolveCollision(boolean n) {
    //Player moved onto tile and is not already on it
    if (n && !this.on) {
      this.on = true;
      if (!this.open && narrator) {
        narrator.say1(new Dialogue(100, null, "This door is locked..."));
      }
    }
    //Player moves out of tile..
    if (!n && this.on) {
      this.on = false;
    }
  }
}