class Narrator extends HUD {
  Camera camera = null; //Reference variable to the camera

  Narrator() {}

  Narrator(Camera camera) {
    super();
    this.camera = !!camera ? camera : null;
  }

  void setCamera(Camera camera) {
    this.camera = camera;
  }

  boolean interceptEnter() {
    if (this.camera != null && this.camera.panning) {
      this.camera.panning = false;
      this.camera.focusPlayer();
      this.camera.queueItem.clear();
    }
    return super.interceptEnter();
  }

  void drawMsgBox() {
    if (!messageBox) return;
    pushMatrix();
    translate(width/2, 500);
    fill(46, 81, 120, 122);
    noStroke();
    rect(-700/2, -150/2, 700, 150);
    fill(255, 255, 255);
    textSize(21);
    text(current.text, -700/2 + 25, -150/2 + 30, 650, 100);
    popMatrix();
  }

  void drawAuthor() {
    pushMatrix();
    translate((width/2)-270, 500-70);
    fill(56, 56, 56);
    noStroke();
    rect(-60, -25, 120, 35);
    fill(255, 255, 255);
    textSize(21);
    textAlign(CENTER);
    text(current.author, -60, -17, 120, 35);
    textAlign(LEFT);
    popMatrix();
  }

  void drawMessage() {
    pushMatrix();
    translate(width/2, 500);
    fill(46, 81, 120, 122);
    noStroke();
    rect(-700/2, -150/2, 700, 150);
    fill(255, 255, 255);
    textSize(21);
    text(current.text, -700/2 + 25, -150/2 + 30, 650, 100);
    popMatrix();

  }

  void draw() {
    if (this.messageBox && this.current) {
      drawMessage();
      if (this.current.author) drawAuthor();
    }
  }

  void update() {
    super.update();
    this.draw();
  }
}
