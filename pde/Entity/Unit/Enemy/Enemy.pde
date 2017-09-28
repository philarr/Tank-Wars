//Enemy class to describe the basic enemy
class Enemy extends Unit {
  ArrayList<int[]> pathing = new ArrayList<int[]>(); //Where it will move to
  int currentPath; //Its current path location
  boolean dir; //Which direction (going forward on its path or go back)
  boolean moving; //If its currently moving
  PVector toMove; //How much left to move
  int moveAmount; //How much will it be able to move
  int aggroRadius; //The radius where it can shoot the player
  int reload; //Reload time
  int dmg; //Damage it does when it touches player
  int chargeTime; //Its charge time for bullets
  boolean targetPlayer; //If it is currently targeting the player within its aggro radius
  Player player; //Reference variable to the player

  Enemy(float x, float y, int w, int h, Camera camera, ArrayList pathing, Player player) {
    super(x, y, w, h, camera);
    if (pathing != null) {
      this.pathing = pathing;
    }
    this.currentPath = -1;
    this.dir = false;
    this.moving = false;
    this.moveAmount = 0;
    this.toMove = new PVector();
    this.moveSpeed = 1;
    this.player = player;
    this.aggroRadius = 250;
    this.reload = 100;
    this.targetPlayer = false;
    this.health = 100;
    this.healthMax = 100;
    this.weapon = 2;
    this.dmg = 10;
    this.chargeTime = 1;
  }

  Enemy(float x, float y, Camera camera, ArrayList pathing, Player player) {
    super(x, y, EnemyDef.WIDTH, EnemyDef.HEIGHT, camera);
    if (pathing != null) {
      this.pathing = pathing;
    }
    this.currentPath = -1;
    this.dir = false;
    this.moving = false;
    this.moveAmount = 0;
    this.toMove = new PVector();
    this.moveSpeed = 1;
    this.player = player;
    this.aggroRadius = 250;
    this.reload = 100;
    this.targetPlayer = false;
    this.health = EnemyDef.HEALTH * 1;
    this.healthMax = EnemyDef.HEALTH;
    this.weapon = EnemyDef.WEAPON;
    this.dmg = EnemyDef.DAMAGE;
    this.chargeTime = 1;
  }

  //Constantly check if it needs to move to the next path destination and whether or not its dead
  void update(ArrayList enemy) {

    if (this.health <= 0 && timer[5] == 0) enemy.remove(this);

    else {
      super.update();
      if (moveAmount > 0) {
        move(-toMove.x/2, -toMove.y/2);
        moveAmount -= 1;
      }
      else {
        if (currentPath == pathing.size()-1) dir = true;
        if (currentPath == 0) dir = false;
        if (dir) currentPath -= 1;
        else currentPath += 1;
        int[] nextXY = pathing.get(currentPath);
        toMove = PVector.sub(tpos, new PVector(nextXY[0]*50, nextXY[1]*50));
        moveAmount =  50;
        toMove.div(moveAmount);
        moving = true;
      }
    }
  }

  //If it is hit, decrease health
  void isHit(Unit unit, int damage) {
    this.health -= damage;
    if (this.health <= 0 && timer[5] == 0) timer[5] = 50;
    this.timer[4] = 30;

    if (this.timer[0] > 0 || this.timer[1] > 0 || this.timer[2] > 0) return;
    this.move(unit.tvel.x*3, unit.tvel.y*3);

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
    image(asset.get("enemy"), -25, -35);
    popMatrix();
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    if (this.player && targetPlayer && this.health > 0) {
      rotate(atan2(player.pos.y - this.pos.y, player.pos.x - this.pos.x));
    }
    image(asset.get("enemy_turret"), -(this.w*3)/15, -this.h/6);
    popMatrix();

    if (timer[4] > 0) {
      pushMatrix();
      translate2(this.tpos.x, this.tpos.y);
      fill(167, 35, 12);
      rect(this.w/-2, -this.h/1.3, this.w, 10);
      fill(34, 177, 76);
      if (this.health > 0 ) rect(this.w/-2, -this.h/1.3, this.w*(this.health/this.healthMax), 10);
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