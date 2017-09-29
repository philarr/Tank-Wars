//Cube that will interact with triggers
class Cube extends Unit {
  String name = CubeDef.NAME;

  Cube(float x, float y, Camera camera) {
    super(x, y, CubeDef.WIDTH, CubeDef.HEIGHT, camera);
  }

  void draw() {
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    image(asset.get("block"), -this.w/2, -this.h/2, 50, 50);
    popMatrix();
  }

  boolean resolveBlock(Entity entity) {
    super.resolveBlock(entity);
    return false;
  }

  void isHit(Unit obj, int dmg) {
    if (this.timer[0] > 0 || this.timer[1] > 0 || this.timer[2] > 0) return;
    this.move(obj.tvel.x*3, obj.tvel.y*3);
    this.timer[2] = 10;
  }
}