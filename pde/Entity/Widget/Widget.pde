//Widget class - the immovable interactable objects in the game
class Widget extends Entity {
  boolean on = false;
  Widget(float x, float y, int w, int h, Camera camera) {
    super((x * 50) + 25, (y * 50) + 25, w, h, camera);
  }
  void resolveCollision(boolean n) {}
  void resolveCollision(boolean n, Entity obj) {}
  void draw() {}
  void update() {}
}