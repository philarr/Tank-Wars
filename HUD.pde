//HUD class to manage the dialogue boxes, status/charge/weapon boxes

class HUD {

  int timer; //Timer for the current message
  Player player; //Reference variable to the player
  ArrayList<Dialogue> dialogue; //List of messages (Dialogue instances)
  Dialogue current; //Current instance of dialogue to show
  boolean messageBox; //Whether or not message box needs to be shown
  Camera camera; //Reference variable to the camera
  int meterFlicker; //Charge meter flicker animation
 

  HUD(Camera c, Player p) {
    camera = c;
    messageBox = false;
    timer = 0;
    meterFlicker = 0;
    dialogue = new ArrayList<Dialogue>();
    if (p != null) this.player = p;
    else this.player = null;
  }

//Say 1 message (Had to use a different method name because overloading this didnt work in javascript mode)
  void say1(Dialogue a) {
    dialogue.clear();
    timer = 0;
    dialogue.add(a);
  }
//Say a list of message
  void say(ArrayList d) {
    dialogue.clear();
    timer = 0;
    dialogue.addAll(d);
  }

  void closeMsgBox() {
    this.messageBox = false;
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

    if (messageBox) {
      if (current.timer == -2) return false;
      timer = 0;
      return true;
    }
    return false;
  }



  void draw() {
    if (player != null) {
      if (player.health > 0) {
        drawStatus();
        if (player.chargeTime > 30)drawCharge();
        drawWeapon();
      }
    }


    if (messageBox) drawMsgBox();
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
    }
    else {
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
      pushMatrix();
      translate((width/2)-270, 500-70);
      fill(56, 56, 56);
      noStroke();
      rect(-60, -20, 120, 40);
      fill(255, 255, 255);
      textSize(21);
      textAlign(CENTER);
      text(current.author, -60, -10, 120, 40);
      textAlign(LEFT);
      popMatrix();
    }
  }

//Count down current message timer, goes to next message if exists, if not = close message box
  void update() {
    if (dialogue.size() > 0 ) {
      if (timer == 0) {
        dialogue.remove(current);
        if (dialogue.size() > 0) {
          current = dialogue.get(0);
          if (current.timer != -2) timer += current.timer;
          else timer = 240;
        }
      }
      else messageBox = true;
      if (timer > 0) timer--;
    }
    else closeMsgBox();
    draw();
  }
}


//Small class to describe Dialogue (the time it is to be shown, author, the text)

class Dialogue {

  int timer;
  String author;
  String text;

  Dialogue(int t, String a, String text) {
    this.timer = t;
    this.author = a;
    this.text = text;
  }
}

