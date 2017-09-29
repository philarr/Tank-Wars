//Trigger that opens door
class Trigger extends Widget {
  static String name = "Trigger";
  ArrayList<Door> door = new ArrayList<Door>();
  Entity onObj; //the entity that is on it

  Trigger(int x, int y, Camera camera, ArrayList doors) {
    super(x, y, TriggerDef.WIDTH, TriggerDef.HEIGHT, camera);
    this.door.addAll(doors);
  }

  void draw() {
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    image(asset.get("trigger"), -18, -18, 36, 36);
    popMatrix();
  }

  void update() {
    this.onObj = false
  }

  boolean resolveBlock(Entity entity) {
    //Player moved onto tile and is not already on it
    switch (entity.name) {
      case "Cube":
        if (!this.on || this.onObj != entity) {
          this.on = true;
          this.onObj = entity;
          for (int i = 0; i < this.door.size(); i++) {
            this.camera.queue(this.door.get(i));
            this.door.get(i).unlock();
            narrator.say1(new Dialogue(100, null, "Switch activated!  \n\n<Space> to skip."));
          }
        }
        break;
      default:
        break;
    }
  }
}