//Widget class - the immovable interactable objects in the game
class Widget extends Entity {
  String name = WidgetDef.NAME;
  boolean on = false;
  Widget(int x, int y, int w, int h, Camera camera) {
    super(x, y, w, h, camera);
  }

  boolean resolveBlock(Entity entity) {}
  boolean resolveBlock(Entity entity, boolean n) {}
  void draw() {
    // No need to call super.update(), widgets are static
    // so we do not need to rebalance tree.
  }
}