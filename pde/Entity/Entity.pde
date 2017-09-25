class Entity {
  PVector pos, tpos; //pos - used as a TRUE position, tpos used as temporary position in case current entity is the camera's focus
  float wSize, hSize; //Unit width/height size for collision checks
  boolean ignoreWall; //True to walk through walls
  Camera camera; //Reference variable to the camera (needed to determine exact location)
  int[] timer = new int[6]; //Timers to countdown (0 - unit collision timer, 1 - wall collision timer, 3 - reload timer, 4 - cooldown for taking damage, 5 - shake timer

  //Default settings for ALL entity (does not include walls)
  Entity(float x, float y, Camera obj) {
    this.pos = new PVector(x, y);
    this.tpos = new PVector(x, y);
    this.camera = obj;
    this.ignoreWall = false;
  }

  //If any timers are > 0, begin counting down
  void update() {
    for (int i=0; i<timer.length; i++) {
      if (timer[i] > 0) timer[i] -= 1;
    }
  }

  //This translate version takes into account of the camera's focus and whether or not it needed the offset added
  void translate2(float x, float y) {
    if (camera.ifFocus(this)) {
      translate(x, y);
    }
    else {
      PVector cp = camera.getPos();
      translate(x - cp.x, y - cp.y);
    }
  }

  //Returns true if Entity touches wall, 6 different points of the Entity is checked against the map to see if it's touching a wall
  boolean detectBlock(int[][] mapc) { //Parameter is the collision map
    if (ignoreWall) return false;

    int x = floor((this.pos.x+this.wSize/2)/50);
    int y = floor((this.pos.y+this.hSize/2)/50);
    int x2 = floor((this.pos.x-this.wSize/2)/50);
    int y2 = floor((this.pos.y-this.hSize/2)/50);
    int y3 = floor((this.pos.y)/50);

    if (mapc[y][x] > 0 || mapc[y2][x2] > 0 || mapc[y][x2] > 0 || mapc[y2][x] > 0 || mapc[y3][x] > 0 || mapc[y3][x2] > 0 ) {
      return true;
    }

    return false;
  }


  //Check if unit is touching another unit (code from the class website notes)
  boolean detectCollision(Entity obj) {
    if (abs(this.pos.x - obj.pos.x) < this.wSize/2 + obj.wSize/2 &&
      abs(this.pos.y - obj.pos.y) < this.hSize/2 + obj.hSize/2) {
      return true; //collision
    }
    return false; //no collision
  }

  //Declared so camera can call this on any Entity
  void move(float x, float y) { }

}