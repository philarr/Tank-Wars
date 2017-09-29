//Projectile class to describe the bullets
class Projectile extends Unit {
  String name = ProjectileDef.NAME;
  int dmg; //How much damage
  int charge; //How much "charge" this projectiles to determine its size and damage
  int type; //What kind of projectile it is (Push back, pull, enemy color, boss color)

  Projectile(int dmg, int charge, int type, Unit owner, PVector mouse, Camera camera) {
    float size = 10*(0.03*charge);
    if (size < 10) size = 10;
    super(owner.pos.x, owner.pos.y, size, size, camera);
    console.log(size);
    this.w = size;
    this.h = size;
    this.dmg = dmg;
    this.charge = charge;
    this.type = type;
    this.moveSpeed = 10;
    this.owner = owner;
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

  //Overridden update because it moves differently from regular units
  void update() {
    this.updateCollision();
    if (this.camera && camera.isFocus(this)) {
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
  ArrayList<Projectile> makeExplosion() {
    if (this.type == 4) this.type = 2;
    ArrayList<Projectile> list = new ArrayList<Projectile>();
    list.add(new Projectile(this.dmg/4, 1, this.type, this.owner, new PVector(this.tpos.x + 1, this.tpos.y), camera));
    list.add(new Projectile(this.dmg/4, 1, this.type, this.owner, new PVector(this.tpos.x - 1, this.tpos.y), camera));
    list.add(new Projectile(this.dmg/4, 1, this.type, this.owner, new PVector(this.tpos.x, this.tpos.y + 1), camera));
    list.add(new Projectile(this.dmg/4, 1, this.type, this.owner, new PVector(this.tpos.x, this.tpos.y - 1), camera));
    list.add(new Projectile(this.dmg/4, 1, this.type, this.owner, new PVector(this.tpos.x + 1, this.tpos.y + 1), camera));
    list.add(new Projectile(this.dmg/4, 1, this.type, this.owner, new PVector(this.tpos.x - 1, this.tpos.y - 1), camera));
    list.add(new Projectile(this.dmg/4, 1, this.type, this.owner, new PVector(this.tpos.x + 1, this.tpos.y - 1), camera));
    list.add(new Projectile(this.dmg/4, 1, this.type, this.owner, new PVector(this.tpos.x - 1, this.tpos.y + 1), camera));
    return list;
  }



  boolean resolveBlock(Entity entity, list, collision) {
    console.log(entity.name);
    if (this.owner == entity || entity == this) return false;
    console.log('projectile block', entity);
    if (0.06*charge == 6) {
      ArrayList<Projectile> toAdd = this.makeExplosion();
      list.addAll(toAdd);
      collision.pushAll(toAdd.toArray(), true);
    }
    if (entity.isHit) {
      entity.isHit(this.dmg);
    }
    return true;
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
