//Widget class - the immovable interactable objects in the game

class Widget extends Entity {
  boolean on; 

  Widget(float x, float y, Camera camera) {
    super((x*50)+25, (y*50)+25, camera);
    this.wSize = 50;
    this.hSize = 50;
    this.on = false;
  }
  void resolveCollision(boolean n) {
  }
  void resolveCollision(boolean n, Entity obj) {
  }
  void draw() {
  }
  void update() {
  }
}

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

//Cube that will interact with triggers
class Cube extends Unit {

  Cube(float x, float y, Camera camera) {
    super(x, y, camera);
  }

  void draw() {
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    image(asset.img.get(10), -wSize/2, -hSize/2, 50, 50);
    popMatrix();
  }

  void resolveCollision(Unit obj) {
    if (this.vel.mag() > obj.vel.mag()) {
      if (this.timer[0] == 0) {
        this.tpos.sub(tvel);
        this.tvel.mult(-1);
        this.timer[0] = 15;
        this.timer[1] = 0;
      }
    }
    else {
      if (obj.timer[0] == 0) {
        if (camera.ifFocus(obj)) {
          obj.tvel.add(camera.getVel()); 
          camera.pos.sub(camera.vel);
          camera.vel.mult(-1);
        }
        obj.tpos.sub(obj.vel);
        obj.tpos.sub(obj.tacc);
        obj.tvel.mult(-1);
        obj.timer[0] = 15;
        obj.timer[1] = 0;
      }
    }
  }

  void isHit(Unit obj, int dmg) {
    if (this.timer[0] > 0 || this.timer[1] > 0 || this.timer[2] > 0) return;
    this.move(obj.tvel.x*3, obj.tvel.y*3);
    this.timer[2] = 10;
  }
}

//Trigger that opens door
class Trigger extends Widget {
  HUD hud;
  ArrayList<Door> d = new ArrayList<Door>();
  Entity onObj; //the entity that is on it

  Trigger(float x, float y, Camera camera, ArrayList doors, HUD h) {
    super(x, y, camera);
    this.hud = h;
    this.wSize = 30;
    this.hSize = 30;
    d.addAll(doors);
  }

  void draw() {
    pushMatrix(); 
    translate2(tpos.x, tpos.y);
    image(asset.img.get(9), -18, -18, 36, 36);
    popMatrix();
  }

  void resolveCollision(boolean n, Entity o) {
    //Player moved onto tile and is not already on it

    if (n && !this.on) {
      this.on = true;
      this.onObj = o;
      for (int i=0; i<d.size(); i++) {
        camera.queue(d.get(i));
        d.get(i).unlock();
        hud.say1(new Dialogue(100, null, "Switch activated!  \n\n<Space> to skip."));
      }
    }
    //Player moves out of tile.. 
    if (!n && this.on  && o == onObj) {

      onObj = null;
      this.on = false;

      for (int i=0; i<d.size(); i++) {
        d.get(i).lock();
      }
    }
  }
}


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

