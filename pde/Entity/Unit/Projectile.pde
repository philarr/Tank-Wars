//Projectile class to describe the bullets
class Projectile extends Unit {
  static String name = "Projectile";
  static float SCALAR = 0.03;
  int dmg; //How much damage
  int charge; //How much "charge" this projectiles to determine its size and damage
  int type; //What kind of projectile it is (Push back, pull, enemy color, boss color)

  Projectile(int dmg, int charge, int type, Unit owner, PVector mouse, Camera camera) {
    float size = 10 * (Projectile.SCALAR * charge);
    size = size < 10 ? 10 : size;
    super(owner.pos.x, owner.pos.y, size, size, camera);
    this.dmg = dmg;
    this.charge = charge;
    this.type = type;
    this.moveSpeed = 10;
    this.owner = owner.owner ? owner.owner : owner;
    PVector dir = new PVector();
    mouse.sub(owner.tpos);
    dir.set(mouse);
    dir.normalize();
    this.tpos.add(dir.x*(15+(owner.w/2)), dir.y*(15+(owner.h)), 0);
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
    ellipse(0, 0, this.w, this.h);
    noStroke();
    popMatrix();
  }

  void update() {
    super.update();
    tpos.add(tvel);
  }

  //Shoots more projectile from this projectile at preset locations
  ArrayList<Projectile> makeExplosion() {
    if (this.type == 4) this.type = 2;
    Projectile[] explosion = {
      new Projectile(this.dmg/4, 1, this.type, this, new PVector(this.tpos.x + 1, this.tpos.y), camera),
      new Projectile(this.dmg/4, 1, this.type, this, new PVector(this.tpos.x - 1, this.tpos.y), camera),
      new Projectile(this.dmg/4, 1, this.type, this, new PVector(this.tpos.x, this.tpos.y + 1), camera),
      new Projectile(this.dmg/4, 1, this.type, this, new PVector(this.tpos.x, this.tpos.y - 1), camera),
      new Projectile(this.dmg/4, 1, this.type, this, new PVector(this.tpos.x + 1, this.tpos.y + 1), camera),
      new Projectile(this.dmg/4, 1, this.type, this, new PVector(this.tpos.x - 1, this.tpos.y - 1), camera),
      new Projectile(this.dmg/4, 1, this.type, this, new PVector(this.tpos.x + 1, this.tpos.y - 1), camera),
      new Projectile(this.dmg/4, 1, this.type, this, new PVector(this.tpos.x - 1, this.tpos.y + 1), camera)
    };
    return explosion;
  }

  boolean resolveBlock(Entity entity, list, collision) {
    switch (entity.name) {
      case "Projectile": return false;
      default:
        if (0.06 * charge == 6) {
          ArrayList<Projectile> toAdd = this.makeExplosion();
          list.addAll(toAdd);
          collision.pushAll(toAdd, true);
        }
        return true;
    }
  }

  void displacement(Entity entity) {
    float multiplier = 0.06 * charge;
    multiplier = multiplier < 1 ? 1 : multiplier;
    if (multiplier == 6) this.dmg *= 2;
    this.tvel.normalize();
    this.tvel.mult(multiplier);
    if (this.type == 1) this.tvel.mult(-1);
    entity.move(this.tvel.x * 3, this.tvel.y * 3);
  }
}
