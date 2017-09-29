//Trigger that opens door
class Trigger extends Widget {
  String name = TriggerDef.NAME;
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

  boolean resolveBlock(Entity entity) {
    //Player moved onto tile and is not already on it

    if (!this.on) {
      this.on = true;
      this.onObj = entity;
      for (int i = 0; i < this.door.size(); i++) {
        this.camera.queue(this.door.get(i));
        this.door.get(i).unlock();
        narrator.say1(new Dialogue(100, null, "Switch activated!  \n\n<Space> to skip."));
      }
    }
    //Player moves out of tile..
    if (this.on && entity == onObj) {
      this.onObj = null;
      this.on = false;
      for (int i = 0; i < this.door.size(); i++) {
        this.door.get(i).lock();
      }
    }
  }
}