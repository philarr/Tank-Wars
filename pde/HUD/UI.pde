// Draws what state the player is in
class UI {
  Player player = null; //Reference variable to the player
  int meterFlicker = 0; //Charge meter flicker animation

  UI(Player player) {
    this.player = !!player ? player : null;
  }

  void drawWeapon() {
    textSize(16);
    if (this.player.weapon == 0) {
      pushMatrix();
      translate(width-88, height-75);
      image(asset.get("hudsmallbox"), 0, 0, 63, 63);
      fill(255, 100, 100);
      text("PUSH", 8, 35);
      popMatrix();
    } else {
      pushMatrix();
      translate(width-88, height-153);
      image(asset.get("hudsmallbox"), 0, 0, 63, 63);
      fill(100, 100, 255);
      text("PULL", 12, 35);
      popMatrix();
    }
  }

  void drawCharge() {
    pushMatrix();
    translate(width/2-101, height-75);

    if (this.player.chargeTime >= 100) {
      if (this.meterFlicker < 255) {
        tint(255, this.meterFlicker);
        this.meterFlicker += 15;
      }
      if (this.meterFlicker >= 255) {
        this.meterFlicker = 0;
      }
    }

    image(asset.get("hudcharge"), 0, 0, 203, 63);
    fill(0, 0, 0);
    rect(25, 23, 155, 13);
    if (this.player.chargeTime >= 100) fill(77, 134, 180, this.meterFlicker);
    else fill(77, 134, 180);
    rect(25, 23, 155*(float(this.player.chargeTime)/100), 13);
    noTint();
    popMatrix();
  }

  void drawStatus() {
    pushMatrix();
    translate(25, height-75);
    image(asset.get("hudbox"), 0, 0, 203, 63);
    //Black background
    fill(0, 0, 0);
    rect(35, 13, 140, 13);
    rect(35, 34, 140, 13);
    //Health meter
    fill(154, 50, 50);
    float hp = 140*(player.health/500);
    if (hp >= 0) rect(35, 13, hp, 13);
    //Reload meter
    fill(147, 125, 58);
    rect(35, 34, (140*(1-(player.timer[3]/float(player.reload)))), 13);
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
  }

  void update() {
    this.draw();
  }
}
