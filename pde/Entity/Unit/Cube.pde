//Cube that will interact with triggers
class Cube extends Unit {
  static String name = "Cube";
  PImage BASE_ASSET;
  Cube(int x, int y, Camera camera) {
    super(x, y, CubeDef.WIDTH, CubeDef.HEIGHT, camera);
    BASE_ASSET = asset.get("block");
  }

  void draw() {
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    image(BASE_ASSET, -this.w/2, -this.h/2, CubeDef.WIDTH, CubeDef.HEIGHT);
    popMatrix();
  }

  void update() {
    super.update();
    tvel.add(tacc);
    tvel.mult(UnitDef.FRICTION);
    tpos.add(tvel);
    tacc.set(0, 0, 0);
  }

  boolean resolveBlock(Entity entity) {
    switch (entity.name) {
      case "Projectile":
        if (!this.delayResolve()) {
          entity.displacement(this);
          this.timer[0] = 15;
        }
        return false;
      case "Wall":
        this.bounceBack();
      default:
        return false;
    }
  }
}