//HUD class to manage the dialogue boxes, status/charge/weapon boxes
class UI extends HUD {
  Player player = null; //Reference variable to the player
  Camera camera = null; //Reference variable to the camera
  int meterFlicker = 0; //Charge meter flicker animation

  UI() {}

  UI(Camera c, Player p) {
    super();
    this.camera = !!c ? c : null;
    this.player = !!p ? p : null;
  }

//Intercepts enter keydown to check if it's meant to skip to the next message or close message box if there is no next message
  boolean interceptEnter() {
    if (camera != null) {
      if (camera.panning) {
        camera.panning = false;
        camera.focusPlayer();
        if (camera.queueItem.size() > 0) camera.queueItem.clear();
      }
    }
    return super.interceptEnter();
  }

  void drawWeapon() {
    textSize(16);
    if (player.weapon == 0) {
      pushMatrix();
      translate(width-88, height-75);
      image(asset.img.get(13), 0, 0, 63, 63);
      fill(255, 100, 100);
      text("PUSH", 8, 35);
      popMatrix();
    } else {
      pushMatrix();
      translate(width-88, height-153);
      image(asset.img.get(13), 0, 0, 63, 63);
      fill(100, 100, 255);
      text("PULL", 12, 35);
      popMatrix();
    }
  }

  void drawCharge() {
    pushMatrix();
    translate(width/2-101, height-75);

    if (player.chargeTime >= 100) {
      if (meterFlicker < 255) {
        tint(255, meterFlicker);
        meterFlicker += 15;
      }
      if (meterFlicker >= 255) {
        meterFlicker = 0;
      }
    }

    image(asset.img.get(12), 0, 0, 203, 63);
    fill(0, 0, 0);
    rect(25, 23, 155, 13);
    if (player.chargeTime >= 100) fill(77, 134, 180, meterFlicker);
    else fill(77, 134, 180);
    rect(25, 23, 155*(float(player.chargeTime)/100), 13);
    noTint();
    popMatrix();
  }

  void drawStatus() {
    pushMatrix();
    translate(25, height-75);
    image(asset.img.get(11), 0, 0, 203, 63);
    //Black background
    fill(0, 0, 0);
    rect(35, 13, 140, 13);
    rect(35, 34, 140, 13);
    //Health meter
    fill(154, 50, 50);
    float hp = 140*(player.health/500);
    if ( hp >= 0) rect(35, 13, hp, 13);
    //Reload meter
    fill(147, 125, 58);
    rect(35, 34, (140*(1-(player.timer[3]/float(player.reload)))), 13);
    popMatrix();
  }

  void drawMsgBox() {
    if (!messageBox) return;
    //Dialogue box
    pushMatrix();
    translate(width/2, 500);
    fill(46, 81, 120, 122);
    noStroke();
    rect(-700/2, -150/2, 700, 150);
    fill(255, 255, 255);
    textSize(21);
    text(current.text, -700/2 + 25, -150/2 + 30, 650, 100);
    popMatrix();

    if (current.author != null) {

    }
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
    if (player != null) {
      if (player.health > 0) {
        drawStatus();
        if (player.chargeTime > 30) drawCharge();
        drawWeapon();
      }
    }
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
