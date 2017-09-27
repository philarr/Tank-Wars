//Cube that will interact with triggers
class Cube extends Unit {

  Cube(float x, float y, Camera camera) {
    super(x, y, CubeDef.WIDTH, CubeDef.HEIGHT, camera);
  }

  void draw() {
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    image(asset.img.get(10), -this.w/2, -this.h/2, 50, 50);
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
        if (camera.isFocus(obj)) {
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