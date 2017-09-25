//Trigger that opens door
class Trigger extends Widget {
  HUD hud;
  ArrayList<Door> d = new ArrayList<Door>();
  Entity onObj; //the entity that is on it

  Trigger(float x, float y, Camera camera, ArrayList doors, HUD h) {
    super(x, y, camera);
    this.hud = h;
    this.wSize = 30;
    this.hSize = 30;
    d.addAll(doors);
  }

  void draw() {
    pushMatrix();
    translate2(tpos.x, tpos.y);
    image(asset.img.get(9), -18, -18, 36, 36);
    popMatrix();
  }

  void resolveCollision(boolean n, Entity o) {
    //Player moved onto tile and is not already on it

    if (n && !this.on) {
      this.on = true;
      this.onObj = o;
      for (int i=0; i<d.size(); i++) {
        camera.queue(d.get(i));
        d.get(i).unlock();
        hud.say1(new Dialogue(100, null, "Switch activated!  \n\n<Space> to skip."));
      }
    }
    //Player moves out of tile..
    if (!n && this.on  && o == onObj) {

      onObj = null;
      this.on = false;

      for (int i=0; i<d.size(); i++) {
        d.get(i).lock();
      }
    }
  }
}