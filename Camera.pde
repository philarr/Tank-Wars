//Camera class - controls offset x and y for objects
//Also does panning and focus on specific entity to follow its movement
class Camera {
  PVector pos, vel, acc;
  Entity focus;
  Entity toFocus;
  boolean panning;
  PVector mr;
  PVector stopAt;
  int count = 0;
  ArrayList<Entity> queueItem;
  Entity player;


  Camera(float x, float y) {
    this.pos = new PVector(x, y); 
    this.vel = new PVector();
    this.acc = new PVector();
    this.mr = new PVector();
    this.stopAt = new PVector();
    this.queueItem = new ArrayList<Entity>();
    panning = false;
  }
  
  void setPlayer(Entity p) {
    this.player = p;
  }
 
  
  void move(float x, float y) {
    acc.add(new PVector(x, y));
  }

  //Set camera to follow the object
  void setFocus(Entity obj) {
    if (focus != null) {
      focus.tpos.set(focus.pos);
    }
    obj.tpos.sub(pos);
    this.focus = obj;
    vel.set(0, 0, 0);
  }
  
  
  void queue(Entity obj) {
    this.queueItem.add(obj);
  }
  

  //Pan camera to Entity
  boolean goTo(Entity obj) {
    if (panning) return false;
    if (focus != null) {
      focus.tpos.set(focus.pos);
    }
    focus = null;
    toFocus = obj;
    PVector mid = new PVector(width/2, height/2); 
    PVector diff = PVector.sub(obj.tpos, mid);
    PVector diff2 = PVector.sub(pos, diff);
    stopAt.set(diff);
    diff2.div(60);
    mr.set(diff2);
    panning = true;
    return true;
  }

  //Centers onto object
  void centerOn(Entity obj) {
    setFocus(obj);
    PVector mid = new PVector(width/2, height/2); 
    PVector diff = PVector.sub(mid, obj.tpos);
    obj.tpos.add(diff);
    pos.sub(diff);
  }

  PVector getPos() {
    return pos;
  }
  PVector getVel() {
    return vel;
  }
  
  void focusPlayer() {
    centerOn(player);
  }

  boolean ifFocus(Entity obj) {
    if (obj == this.focus) {
      return true;
    }
    return false;
  }

  void update() {
    if (!panning & queueItem.size() <= 0 && this.focus != player) goTo(player);
    if(!panning && queueItem.size() > 0) goTo(queueItem.get(0));
    if (panning) {
      count++;
      if (count == 60) {
        count = 0;
        panning = false;
        if (queueItem.size() > 0) queueItem.remove(0);
        setFocus(toFocus);
      }
      else {
        pos.add(new PVector(-mr.x, -mr.y ));
      }
    }

    vel.add(acc); 
    vel.mult(0.8);
    pos.add(vel);
    acc.set(0, 0, 0);
  }
}

