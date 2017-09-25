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

  boolean isDead() {
    return this.dead;
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