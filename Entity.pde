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

  //If any timers are >0, begin counting down
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


//Unit class to describe any Entity that is moveable
class Unit extends Entity {
  PVector acc, vel, tvel, tacc; //Used to calculate movement, tvel + tacc is used in case this Unit is the camera's focus
  float health; //Health for this unit
  int moveSpeed; //Movement speed
  int weapon; //The current weapon
  boolean up, down, left, right; //Which directin it is going
  
  Unit(float x, float y, Camera obj) { 
    super(x*50, y*50, obj);
    this.wSize = 50;
    this.hSize = 50;
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

    if (timer[0] > 0 || timer[1] > 0 || timer[2] > 0 || timer[5] > 0) return; 

    up = false;
    down = false;
    left = false;
    right = false;

    if (y > 0) up = true;
    if (y < 0) down = true;
    if (x < 0) right = true;
    if (x > 0) left = true;

    x = x * moveSpeed;
    y = y * moveSpeed;

    if (tpos.y <= 150 && y < 0 || 
      tpos.y >= height-150 && y > 0 || 
      tpos.x <= 150 && x < 0 || 
      tpos.x >= width-150 && x > 0) {  
      if (camera.focus == this) {
        camera.move(x, y);
        return;
      }
    }

    tacc.add(new PVector(x, y));
  }
}


//Projectile class to describe the bullets
class Projectile extends Unit {
  int dmg; //How much damage
  int charge; //How much "charge" this projectiles to determine its size and damage
  int type; //What kind of projectile it is (Push back, pull, enemy color, boss color)
  Unit owner; //Who shot this projectile

  Projectile(int dmg, int charge, int type, Unit owner, PVector mouse, Camera camera) {
    super(owner.pos.x/50, owner.pos.y/50, camera);
    float size = 10*(0.03*charge);
    if (size < 10) size = 10;
    this.wSize = size;
    this.hSize = size;
    this.dmg = dmg;
    this.charge = charge;
    this.type = type;
    this.moveSpeed = 10;
    this.owner = owner;
    PVector dir = new PVector();
    mouse.sub(owner.tpos);
    dir.set(mouse);
    dir.normalize();
    this.tpos.add(dir.x*(15+(owner.wSize/2)), dir.y*(15+(owner.hSize)), 0); 
    dir.mult(this.moveSpeed);
    this.tvel.set(dir);
     
  } 

  //Draws different color projectile based on its type
  void draw() {
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    if (type == 0) fill(255, 100, 100);
    if (type == 1) fill(100, 100, 255);
    if (type == 2) fill(255, 255, 255);
    if (type == 4) fill(0, 0, 0);
    if (0.06*charge == 6) {
      strokeWeight(4);
      stroke(255, 255, 255, 170);
    }
    ellipse(0, 0, this.wSize, this.hSize);
    noStroke();
    popMatrix();
  }

  //Overridden update because it moves differently from regular units
  void update() {
    if (camera.ifFocus(this)) {
      this.pos.set(PVector.add(this.tpos, camera.pos));
      this.vel.set(PVector.add(this.tvel, camera.vel));
    }
    else {
      this.pos.set(this.tpos);
      this.vel.set(this.tvel);
    }
    tpos.add(tvel);
  }

  //Shoots more projectile from this projectile at preset locations
  void makeExplosion(ArrayList list) {
    if (this.type == 4) this.type = 2;
    list.add(new Projectile(this.dmg/4, 1, this.type, this, new PVector(this.tpos.x + 1, this.tpos.y), camera));
    list.add(new Projectile(this.dmg/4, 1, this.type, this, new PVector(this.tpos.x - 1, this.tpos.y), camera));
    list.add(new Projectile(this.dmg/4, 1, this.type, this, new PVector(this.tpos.x, this.tpos.y + 1), camera));
    list.add(new Projectile(this.dmg/4, 1, this.type, this, new PVector(this.tpos.x, this.tpos.y - 1), camera));
    list.add(new Projectile(this.dmg/4, 1, this.type, this, new PVector(this.tpos.x + 1, this.tpos.y + 1), camera));
    list.add(new Projectile(this.dmg/4, 1, this.type, this, new PVector(this.tpos.x - 1, this.tpos.y - 1), camera));
    list.add(new Projectile(this.dmg/4, 1, this.type, this, new PVector(this.tpos.x + 1, this.tpos.y - 1), camera));
    list.add(new Projectile(this.dmg/4, 1, this.type, this, new PVector(this.tpos.x - 1, this.tpos.y + 1), camera));
  }


  //Projectile hits a wall
  void resolveBlock(ArrayList list) {
    if (0.06*charge == 6) makeExplosion(list);
    list.remove(this);
  }
  
  //Projectile hits the Unit
  void resolveCollision(Unit obj, ArrayList list) {

    float multcharge = 0.06*charge;

    if (multcharge < 1) multcharge = 1;
    this.tvel.normalize();
    this.tvel.mult(multcharge);
    if (this.type == 1) this.tvel.mult(-1); 
    if (multcharge == 6) this.dmg *= 2;
    obj.isHit((Unit)this, this.dmg);

    if (multcharge == 6) makeExplosion(list);

    list.remove(this);
  }
}


//Enemy class to describe the basic enemy
class Enemy extends Unit {
  ArrayList<int[]> pathing = new ArrayList<int[]>(); //Where it will move to
  int currentPath; //Its current path location
  boolean dir; //Which direction (going forward on its path or go back)
  boolean moving; //If its currently moving
  PVector toMove; //How much left to move
  int moveamount; //How much will it be able to move
  int aggroRadius; //The radius where it can shoot the player
  int reload; //Reload time
  int dmg; //Damage it does when it touches player
  int chargeTime; //Its charge time for bullets
  boolean targetPlayer; //If it is currently targeting the player within its aggro radius
  Player player; //Reference variable to the player

  Enemy(float x, float y, Camera obj, ArrayList pathing, Player player) { 
    super(x, y, obj);
    if (pathing != null) {
      this.pathing = pathing;
    }
    this.currentPath = -1;
    this.dir = false;
    this.moving = false;
    this.moveamount = 0;
    this.toMove = new PVector();
    this.moveSpeed = 1;
    this.player = player;
    this.aggroRadius = 250;
    this.reload = 100;
    this.targetPlayer = false;
    this.health = 100;
    this.weapon = 2;
    this.dmg = 10;
    this.chargeTime = 1;
  }

  //Constantly check if it needs to move to the next path destination and whether or not its dead
  void update(ArrayList enemy) {
 
    if (this.health <= 0 && timer[5] == 0) enemy.remove(this);
   
    else {
      super.update();
      if (moveamount > 0) {
        move(-toMove.x/2, -toMove.y/2);
        moveamount -= 1;
      }
      else {
        if (currentPath == pathing.size()-1) dir = true;
        if (currentPath == 0) dir = false;
        if (dir) currentPath -= 1;
        else currentPath += 1;
        int[] nextXY = pathing.get(currentPath);
        toMove = PVector.sub(tpos, new PVector(nextXY[0]*50, nextXY[1]*50));
        moveamount =  50;
        toMove.div(moveamount);
        moving = true;
      }
    }
  }

  //If it is hit, decrease health
  void isHit(Unit obj, int damage) {
    this.health -= damage;
    if (this.health <= 0 && timer[5] == 0) timer[5] = 50;
    this.timer[4] = 30;

    if (this.timer[0] > 0 || this.timer[1] > 0 || this.timer[2] > 0) return;
    this.move(obj.tvel.x*3, obj.tvel.y*3);

    this.timer[2] = 10;
    this.timer[0] = 0;
    this.timer[1] = 0;
   
    
  }

  //Draws the aggro radius circle
  void aggroDraw() {
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    fill(0, 0, 0, 50);
    ellipse(0, 0, aggroRadius*2, aggroRadius*2); 
    popMatrix();
  }


  void draw() { 
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    if (up) rotate(radians(0));
    if (down) rotate(radians(180));
    if (left) rotate(radians(-90));
    if (right) rotate(radians(90));
    image(asset.img.get(3), -25, -35);
    popMatrix();
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    if (targetPlayer && this.health > 0) rotate(atan2(player.pos.y - this.pos.y, player.pos.x - this.pos.x));
    image(asset.img.get(4), -(wSize*3)/15, -hSize/6);
    popMatrix();

    if (timer[4] > 0) {
      pushMatrix();
      translate2(this.tpos.x, this.tpos.y);
      fill(167, 35, 12);
      rect(wSize/-2, -hSize/1.3, wSize, 10);  
      fill(34, 177, 76);
      if (this.health > 0 ) rect(wSize/-2, -hSize/1.3, wSize*(this.health/100), 10);
      popMatrix();
    }
  }

  //Checks if player is within the circle
  boolean detectAggro(Unit obj) {
    if (dist(pos.x, pos.y, obj.pos.x, obj.pos.y) < aggroRadius + 25) {
      targetPlayer = true;
      return true;
    }
    targetPlayer = false;
    return false; //no collision
  }
}



//Player class to describe the player (you)
class Player extends Unit {
  boolean hitAnimate; //If you are hit, does the fade blinking
  int fade; //Hold the animation number
  int reload; //Reload
  int chargeTime; //The time you charged
  boolean dead; 


  Player(PVector spawn, Camera obj) { 
    super(spawn.x, spawn.y, obj);
    this.moveSpeed = 1;
    this.fade = 0;
    this.health = 500;
    this.reload = 20;
    this.chargeTime = 0;
  }

  //Increase charge time (used from the key down event)
  void charge() {
    if (chargeTime < 100) chargeTime += 2;
  }

  void isHit(Unit obj, int damage) {
    
    if (timer[4] > 0) return;
    this.health -= damage;
    if (this.health <= 0 && timer[5] == 0 && !dead) timer[5] = 100;
    timer[4] = 25;
    if (!hitAnimate) {
      hitAnimate = true;
      fade = 0;
    }
  }

  void draw() { 
    if (this.health <= 0 && timer[5] == 0) dead = true;
    if (dead) return;

    if (hitAnimate) {
      if (fade%10 == 0) tint(255, 255);
      else tint(255, 127);
      fade += 5;
    }
    if (fade == 255) {
      fade = 0;
      hitAnimate = false;
    }

    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    if (up) rotate(radians(0));
    if (down) rotate(radians(180));
    if (left) rotate(radians(-90));
    if (right) rotate(radians(90));
    image(asset.img.get(1), -25, -35);
    popMatrix();
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    rotate(atan2(mouseY - this.tpos.y, mouseX - this.tpos.x));
    image(asset.img.get(2), -(wSize*3)/15, -hSize/6);
    noTint();
    popMatrix();
  }
}


