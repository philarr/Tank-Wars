//Camera class - controls offset x and y for objects
//Also does panning and focus on specific entity to follow its movement
class Camera {
  final static int EDGE_OFFSET = 150;

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
    this.panning = false;
  }

  void setPlayer(Entity p) {
    this.player = p;
  }

  void move(float x, float y) {
    this.acc.add(new PVector(x, y));
  }

  //Set camera to follow the object
  void setFocus(Entity entity) {
    if (this.focus != null) {
      this.focus.tpos.set(this.focus.pos);
    }
    entity.tpos.sub(this.pos);
    this.focus = entity;
    this.vel.set(0, 0, 0);
  }

  void queue(Entity entity) {
    this.queueItem.add(entity);
  }

  //Pan camera to Entity
  boolean goTo(Entity entity) {
    if (this.panning) return false;
    if (this.focus != null) {
      this.focus.tpos.set(this.focus.pos);
    }
    this.focus = null;
    this.toFocus = entity;
    PVector mid = new PVector(__WIDTH__ / 2, __HEIGHT__ / 2);
    PVector diff = PVector.sub(entity.tpos, mid);
    PVector diff2 = PVector.sub(this.pos, diff);
    this.stopAt.set(diff);
    diff2.div(60);
    this.mr.set(diff2);
    this.panning = true;
    return true;
  }

  //Centers onto object
  void centerOn(Entity entity) {
    this.setFocus(entity);
    PVector mid = new PVector(__WIDTH__ / 2, __HEIGHT__ / 2);
    PVector diff = PVector.sub(mid, entity.tpos);
    entity.tpos.add(diff);
    this.pos.sub(diff);
  }

  PVector getPos() {
    return this.pos;
  }

  PVector getVel() {
    return this.vel;
  }

  void focusPlayer() {
    centerOn(this.player);
  }

  boolean isFocus(Entity entity) {
    return entity == this.focus;
  }

  boolean inScreen(Entity entity) {
    return ((entity.tpos.x - entity.w/2) - this.pos.x < width
    && (entity.tpos.x + entity.w/2) - this.pos.x > 0
    && (entity.tpos.y - entity.h/2) - this.pos.y < height
    && (entity.tpos.y + entity.h/2) - this.pos.y > 0
    || this.isFocus(entity));
  }

  void update() {
    // If no pan item is queued, focus on player
    if (!this.panning & this.queueItem.size() <= 0 && this.focus != this.player) {
      goTo(this.player);
    }
    // Focus on pan items
    if(!this.panning && this.queueItem.size() > 0) {
      goTo(queueItem.get(0));
    }
    if (this.panning) {
      this.count++;
      if (this.count == 60) {
        this.count = 0;
        this.panning = false;
        if (this.queueItem.size() > 0) this.queueItem.remove(0);
        setFocus(this.toFocus);
      }
      else {
        this.pos.add(new PVector(-this.mr.x, -this.mr.y ));
      }
    }

    this.vel.add(this.acc);
    this.vel.mult(0.8);
    this.pos.add(this.vel);
    this.acc.set(0, 0, 0);
  }
}

