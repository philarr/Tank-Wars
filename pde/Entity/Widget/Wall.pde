class Wall extends Widget {
  String name = WallDef.NAME;
  boolean SHADOW_BOTTOM;
  boolean SHADOW_RIGHT;

  PImage ASSET_BASE;

  Wall(int x, int y, Camera camera, int direction) {
    super(x, y, WallDef.WIDTH, WallDef.HEIGHT, camera);
    ASSET_BASE = asset.get(WallDef.ASSET_BASE);
  }

  void drawWall() {
    pushMatrix();
    translate2(tpos.x, tpos.y);
    fill(255, 53, 62);
    noStroke();
    image(asset.get(WallDef.ASSET_BASE), -this.w/2, -this.h/2);
    popMatrix();
  }

  void drawShadow(int x, int y, int w, int h) {
    pushMatrix();
    translate2(tpos.x, tpos.y);
    fill(0, 0, 0, 127);
    noStroke();
    rect(0, 0, w, h);
    popMatrix();
  }

  void update() {}

  boolean resolveBlock(Entity entity) {
    console.log('walled ->', entity);
    return false;
  }

  void draw() {
    drawWall();
  }
}