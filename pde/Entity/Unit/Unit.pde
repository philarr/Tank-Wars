//Unit class to describe any Entity that is moveable
class Unit extends Entity {
  PVector acc, vel, tvel, tacc; //Used to calculate movement, tvel + tacc is used in case this Unit is the camera's focus
  float health; //Health for this unit
  int moveSpeed; //Movement speed
  int weapon; //The current weapon
  boolean up, down, left, right; //Which directin it is going

  Unit(float x, float y, int w, int h, Camera obj) {
    super(x*50, y*50, w, h, obj);
    this.vel = new PVector();
    this.tvel = new PVector();
    this.acc = new PVector();
    this.tacc = new PVector();
    this.weapon = 0;
    this.moveSpeed = 1;
  }

  void update() {
    super.update();

    //If this Unit is the camera's focused, add its temporary position and camera's offset to get
    if (camera.ifFocus(this)) {
      this.pos.set(PVector.add(this.tpos, camera.pos));
      this.vel.set(PVector.add(this.tvel, camera.vel));
    }
    else {
      this.pos.set(this.tpos);
      this.vel.set(this.tvel);
    }
    tvel.add(tacc);
    tvel.mult(0.8);
    tpos.add(tvel);
    tacc.set(0, 0, 0);

    //Shake timer
    if (timer[5] > 0) {
      if ( timer[5] % 4 == 1 || timer[5] % 4 == 2) this.tpos.add(5, 5, 0);
      else this.tpos.sub(5, 5, 0);
    }
  }

  void resolveBlock() {
    if (timer[1] > 0) return;
    if (camera.ifFocus(this)) {
      tvel.add(camera.getVel());
      camera.pos.sub(camera.vel);
      camera.vel.mult(-1);
    }
    tpos.sub(tvel);
    tpos.sub(tacc);
    tvel.mult(-1);

    timer[0] = 0;
    timer[1] = 10;
  }

  boolean isDead() {
    return this.health <= 0;
  }

  //Lets projectile class to interact with any Unit class
  void isHit(Unit obj, int dmg) { }
  void resolveCollision(Unit obj) { }

  //Set the unit's weapon
  void setWeapon(int w) {
    this.weapon = w;
  }

  //Shoot if it is not bouncing back after any collision and reload is 0
  void shoot(float x, float y, int charge, int damage, int reload, ArrayList list) {
    if (timer[3] > 0 || timer[1] > 0 || timer[0] > 0 || this.health <= 0) return;

    PVector mouseXY = new PVector(x, y);
    list.add(new Projectile(damage, charge, this.weapon, this, mouseXY, camera));
    timer[3] = reload;
  }


  //Move if not bouncing back from collision and not shaking
  void move(float x, float y) {
    int EDGE_OFFSET = 150;
    if (timer[0] > 0 || timer[1] > 0 || timer[2] > 0 || timer[5] > 0) return;

    up = y > 0;
    down = y < 0;
    left = x < 0;
    right = x > 0;

    x = x * moveSpeed;
    y = y * moveSpeed;


    // Move camera along with Unit if passes EDGE_OFFSET
    if (tpos.y <= EDGE_OFFSET && y < 0 ||
      tpos.y >= height - EDGE_OFFSET && y > 0 ||
      tpos.x <= EDGE_OFFSET && x < 0 ||
      tpos.x >= width - EDGE_OFFSET && x > 0) {
      if (camera.focus == this) {
        camera.move(x, y);
        return;
      }
    }

    tacc.add(new PVector(x, y));
  }
}
