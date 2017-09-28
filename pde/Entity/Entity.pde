class Entity {
  int x, y;
  PVector pos, tpos; //pos - used as a TRUE position, tpos used as temporary position in case current entity is the camera's focus
  float w, h; //Unit width/height size for collision checks
  boolean ignoreWall = false; //True to walk through walls
   /* reference variable to the camera (needed to determine exact location) */
  Camera camera;
  /* timers to countdown (0 - unit collision timer, 1 - wall collision timer, 3 - reload timer, 4 - cooldown for taking damage, 5 - shake timer */
  int[] timer = new int[6];
  Object collision;

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
    self.camera = new Camera(0, 0);
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

  //Returns true if Entity touches wall, 6 different points of the Entity is checked against the map to see if it's touching a wall
  boolean detectBlock(int[][] map) { //Parameter is the collision map
    if (ignoreWall) return false;

    int x = floor((this.pos.x + this.w/2) / Asset.tileW);
    int y = floor((this.pos.y + this.h/2) / Asset.tileH);
    int x2 = floor((this.pos.x - this.w/2) / Asset.tileW);
    int y2 = floor((this.pos.y - this.h/2) / Asset.tileH);
    int y3 = floor((this.pos.y) / Asset.tileH);

    if (map[y][x] > 0 || map[y2][x2] > 0 ||
      map[y][x2] > 0 || map[y2][x] > 0 ||
      map[y3][x] > 0 || map[y3][x2] > 0 ) {
      return true;
    }
    return false;
  }


  //Check if unit is touching another unit (code from the class website notes)
  boolean detectCollision(Entity obj) {
    if (abs(this.pos.x - obj.pos.x) < this.w/2 + obj.w/2 &&
      abs(this.pos.y - obj.pos.y) < this.h/2 + obj.h/2) {
      return true; //collision
    }
    return false; //no collision
  }

  //Declared so camera can call this on any Entity
  void move(float x, float y) { }

}