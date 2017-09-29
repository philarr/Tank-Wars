class Entity {
  static String name = "Entity";
  int x, y;
  PVector pos, tpos; //pos - used as a TRUE position, tpos used as temporary position in case current entity is the camera's focus
  float w, h; //Unit width/height size for collision checks
  boolean ignoreWall = false; //True to walk through walls
   /* reference variable to the camera (needed to determine exact location) */
  Camera camera;
  /* timers to countdown (0 - unit collision timer, 1 - wall collision timer, 3 - reload timer, 4 - cooldown for taking damage, 5 - shake timer */
  int[] timer = new int[6];
  Entity owner;

  int COLLISION_DMG = 10;

  //Default settings for ALL entity (does not include walls)
  Entity(float x, float y, int w, int h) {
    Entity self = this;
    self.w = w;
    self.h = h;
    self.x = x;
    self.y = y;
    self.width = w;
    self.height = h;
    self.pos = new PVector(x, y);
    self.tpos = new PVector(x, y);
  }

  Entity(float x, float y, int w, int h, Camera camera) {
    Entity self = this;
    self.x = x;
    self.y = y;
    self.w = w;
    self.h = h;
    self.width = w;
    self.height = h;
    self.pos = new PVector(x, y);
    self.tpos = new PVector(x, y);
    self.camera = camera;
  }

  //If any timers are > 0, begin counting down
  void update() {
    updateCollision();
    updateTimers();
  }

  void updateCollision() {
    Entity self = this;
    int x = int(self.pos.x);
    int y = int(self.pos.y);
    if (x != self.x) self.x = x;
    if (y != self.y) self.y = y;
  }

  void updateTimers() {
    for (int i = 0; i < timer.length; i++) {
      if (timer[i] > 0) timer[i] -= 1;
    }
  }

  //This translate version takes into account of the camera's focus and whether or not it needed the offset added
  void translate2(float x, float y) {
    if (camera.isFocus(this)) {
      translate(x, y);
    }
    else {
      PVector cameraPos = camera.getPos();
      translate(x - cameraPos.x, y - cameraPos.y);
    }
  }

  //Declared so camera can call this on any Entity
  void move(float x, float y) {}
  void draw() {}

  Boolean resolveBlock(Entity entity) {
    return false;
  }

  boolean delayResolve() {
    return (this.timer[0] > 0 ||
            this.timer[1] > 0 ||
            this.timer[2] > 0);
  }
}
