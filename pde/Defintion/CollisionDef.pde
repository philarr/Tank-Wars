class CollisionDef {
  int x;
  int y;
  int w;
  int h;
  Entity e;

  collisionDef(int x, int y, int w, int h, Entity e) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.e = e;
  }

  Object create() {
    Object define = external.get('defineObject');
    return define(this);
  }
}