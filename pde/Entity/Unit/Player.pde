//Player class to describe the player (you)
class Player extends Unit {
  static String name = "Player";
  boolean hitAnimate; //If you are hit, does the fade blinking
  int fade; //Hold the animation number
  int reload; //Reload
  int chargeTime; //The time you charged
  boolean dead;
  PImage ASSET_BASE;
  PImage ASSET_TURRET;

  Player(PVector start, Camera camera) {
    super(start.x, start.y, PlayerDef.WIDTH, PlayerDef.HEIGHT, camera);
    this.moveSpeed = 1;
    this.fade = 0;
    this.health = 500;
    this.reload = 20;
    this.chargeTime = 0;
    ASSET_BASE = asset.get(PlayerDef.ASSET_BASE);
    ASSET_TURRET = asset.get(PlayerDef.ASSET_TURRET);
  }

  //Increase charge time (used from the key down event)
  void charge() {
    if (chargeTime < 100) chargeTime += 2;
  }

  void isHit(int damage) {
    if (timer[4] > 0) return;
    this.health -= damage;
    if (this.health <= 0 && timer[5] == 0 && !dead) timer[5] = 100;
    timer[4] = 25;
    if (!hitAnimate) {
      hitAnimate = true;
      fade = 0;
    }
  }

  boolean isDead() {
    return this.dead;
  }

  void update() {
    super.update();
    tvel.add(tacc);
    tvel.mult(UnitDef.FRICTION);
    tpos.add(tvel);
    tacc.set(0, 0, 0);

    //Shake timer
    if (timer[5] > 0) {
      if ( timer[5] % 4 == 1 || timer[5] % 4 == 2) this.tpos.add(5, 5, 0);
      else this.tpos.sub(5, 5, 0);
    }
  }

  boolean resolveBlock(Entity entity) {
    switch(entity.name) {
      case "Projectile":
        if (entity.owner != this && !this.delayResolve()) {
          entity.displacement(this);
          this.timer[0] = 15;
        }
        break;
      case "Enemy":
        this.chargeTime = 0;
      case "Wall":
      case "Cube":
        this.bounceBack();
        this.chargeTime = 0;
        break;
      case "Door":
        if (!entity.open) {
          this.bounceBack();
          this.chargeTime = 0;
        }
      default:
        break;
    }
    return false;
  }

  void drawBase() {
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    if (up) rotate(radians(0));
    if (down) rotate(radians(180));
    if (left) rotate(radians(90));
    if (right) rotate(radians(-90));
    image(ASSET_BASE, -25, -35);
    popMatrix();
  }

  void drawTurret() {
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    rotate(atan2(mouseY - this.tpos.y, mouseX - this.tpos.x));
    image(ASSET_TURRET, -(this.width * 3) / 15, -this.height/6);
    noTint();
    popMatrix();
  }

  void draw() {
    this.dead = this.health <= 0 && timer[5] == 0;
    if (this.dead) return;

    if (hitAnimate) {
      if (fade%10 == 0) tint(255, 255);
      else tint(255, 127);
      fade += 5;
    }
    if (fade == 255) {
      fade = 0;
      hitAnimate = false;
    }
    drawBase();
    drawTurret();
  }
}
