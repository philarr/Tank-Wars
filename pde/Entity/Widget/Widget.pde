//Widget class - the immovable interactable objects in the game

class Widget extends Entity {
  boolean on;

  Widget(float x, float y, Camera camera) {
    super((x*50)+25, (y*50)+25, camera);
    this.wSize = 50;
    this.hSize = 50;
    this.on = false;
  }
  void resolveCollision(boolean n) {
  }
  void resolveCollision(boolean n, Entity obj) {
  }
  void draw() {
  }
  void update() {
  }
}