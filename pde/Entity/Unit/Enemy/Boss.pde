//Boss class - Scripting
class Boss extends Enemy {
  static String name = "Boss";
  boolean intro; //Say something when the level starts
  boolean phase1; //Set phase difficulty
  boolean phase2; // ^
  boolean phase3; // ^
  boolean phase4; // ^
  int ramCooldown; //Current ram cooldown time
  boolean shake; //To shake or not to shake
  PVector ramTo; //Position to ram to
  int ramCD; //Ram cooldown
  int dblProc; //Chance to double shoot
  int fade; //Hold the fade animation numbers
  State state; //Reference variable to the current state

  //Class constructor
  Boss(float x, float y, State state) {
    super(x, y, BossDef.WIDTH, BossDef.HEIGHT, camera, null, player);
    //Difficulty at start of battle
    this.intro = false;
    this.phase1 = false;
    this.phase2 = false;
    this.phase3 = false;
    this.phase4 = false;
    this.health = BossDef.HEALTH * 1;
    this.healthMax = BossDef.HEALTH;
    this.aggroRadius = 400;
    this.reload = 90;
    this.weapon = 2;
    this.chargeTime = 1;
    this.ramCooldown = 300;
    this.shake = false;
    this.ramTo = null;
    this.dblProc = 700;
    this.ramCD = 800;
    this.fade = 125;
    this.state = state;
  }

  //isHit - overridden from Unit superclass so it can perform Boss specific actions
  void isHit(Unit obj, int dmg) {

    this.health -= dmg;

    //Shakes the boss if dead
    if (this.health <= 0 && timer[5] == 0) timer[5] = 100;
    this.timer[4] = 30;
    //If boss is already in process of bouncing back from a previous  collision, return
    //Otherwise does a new bounce back
    if (this.timer[0] > 0 || this.timer[1] > 0 || this.timer[2] > 0) return;
    this.move(obj.tvel.x*3, obj.tvel.y*3);
    this.timer[2] = 10;
    this.timer[0] = 0;


    if (this.health <= 0) timer[5] = 150;
    //Need a charged projectile to stop boss from ramming player
    Projectile convert = (Projectile) obj;
    if (convert.charge >= 100) {
      //If boss is stuck in wall, dont cancel the ramming
      if (this.timer[1] == 0) {
        //Phase 3 - taunt when player try to cancel the shake
        if (phase3 && timer[5] > 0) {
          int randomSpeech = int(random(3));
          if (randomSpeech == 0) narrator.say1(new Dialogue(240, "Boss", "I'm unstoppable!", true));
          if (randomSpeech == 1) narrator.say1(new Dialogue(240, "Boss", "Nothing can stop me!", true));
          if (randomSpeech == 2) narrator.say1(new Dialogue(240, "Boss", "You think that will stop me?!", true));
        }
        else {
          //Reset boss to normal behaviour
          this.aggroRadius = 400;
          this.ignoreWall = false;
          this.moveSpeed = 1;
          this.timer[5] = 0;
        }
      }
    }
  }

  void update(ArrayList enemy) {
    super.update();

    //If boss is dead and already perform the shaking animation, remove and block current state
    if (this.health <= 0 && timer[5] == 0) {
      enemy.remove(this);
      state.block = true;
    }

    //Randomly reset cooldown to make it harder
    if (int(random(this.dblProc)) == 0) {
      timer[3] = 0; //Reset shooting cooldown
    }
    if (phase2) {
      if (int(random(2000)) == 0) {
        ramCooldown = 0; //Resets ramming cooldown
      }
    }

    //If intro speech has not been said yet
    if (!intro) {
      narrator.say1(new Dialogue(240, "Boss", "You are no match for me!", true));
      this.intro = true;
    }

    //Move to player if outside of aggro radius
    if (this.moveSpeed == 1) {
      //If regular speed (non ramming mode), seek to player
      if (dist(this.pos.x, this.pos.y, player.pos.x, player.pos.y) > this.aggroRadius) {
        PVector getDir = PVector.sub(player.pos, this.pos);
        getDir.normalize();
        this.move(getDir.x*this.moveSpeed, getDir.y*this.moveSpeed);
      }
    }
    else {
      //If ramming mode, go only to recorded position
      if (ramTo != null) {
        if (dist(this.pos.x, this.pos.y, ramTo.x, ramTo.y) > this.aggroRadius) {
          PVector getDir = PVector.sub(ramTo, this.pos);

          getDir.normalize();
          this.move(getDir.x*this.moveSpeed, getDir.y*this.moveSpeed);
        }
        else {
          //Reset boss to normal behaviour if it reached its ramming destination
          this.aggroRadius = 400;
          this.ignoreWall = false;
          this.moveSpeed = 1;
          this.timer[5] = 0;
        }
      }
    }

    if (this.health < 1850) {
      //PHASE 1 - Shoots max charge projectiles
      if (!phase1) {
        narrator.say1(new Dialogue(240, "Boss", "Looks like I need more fire power!", true));
        timer[5] = 100;
        this.reload = 80;
        this.weapon = 4;
        this.chargeTime = 100;
        phase1 = true;
      }
    }

    if (this.health < 1450) {
      //PHASE 2 - Ram the player (goes through walls)
      if (!phase2) {
        narrator.say1(new Dialogue(240, "Boss", "You can't hide from me!", true));
        this.ramCooldown = 0;
        phase2 = true;
      }
      if (this.ramCooldown == 0) {
        timer[5] = 70;
        this.aggroRadius = 10;
        this.moveSpeed = 2;
        this.ramCooldown = this.ramCD;
        this.ramTo = null;
      }
      if (ramCooldown > 0) ramCooldown--;
      //Record player pos after its almost done shaking to ram
      if (moveSpeed == 2 && timer[5] == 15 && ramTo == null) {
        this.ramTo = player.pos.get();
        this.ignoreWall = true;
      }
    }

    if (this.health < 950) {
      //PHASE 3 - Spam projectiles at player, lower ram cooldown + lower shake time, higher chance of double shot and uncancellable ram
      if (!phase3) {
        narrator.say1(new Dialogue(240, "Boss", "Die!", true));
        phase3 = true;
        timer[5] = 50;
        this.reload = 55;
        this.ramCD = 500;
        this.dblProc = 500;
      }
      if (fade >= 255) fade = 125;
      else fade += 5;
    }

    if (this.health < 200) {
      //PHASE 4 - angrier version of phase 3
      if (!phase4) {
        narrator.say1(new Dialogue(240, "Boss", "!!!!!", true));
        timer[5] = 50;
        this.phase4 = true;
        this.reload = 20;
        this.dblProc = 300;
      }
    }
  }

  void drawHPBar() {
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    fill(167, 35, 12);
    rect(this.width/-2, -this.height/1.3, this.width, 10);
    fill(34, 177, 76);
    if (this.health > 0 ) rect(this.width/-2, -this.height/1.3, this.width*(this.health/this.healthMax), 10);
    popMatrix();
  }

  void draw() {

    if (phase3) tint(255, 100, 100, fade);
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    if (up) rotate(radians(0));
    if (down) rotate(radians(180));
    if (left) rotate(radians(-90));
    if (right) rotate(radians(90));
    image(asset.get("boss"), -50, -50);
    popMatrix();
    pushMatrix();
    translate2(this.tpos.x, this.tpos.y);
    if (this.health > 0) rotate(atan2(player.pos.y - this.pos.y, player.pos.x - this.pos.x));
    image(asset.get("boss_turret"), -(this.width*2)/15, -this.height/4);
    noTint();
    popMatrix();
    //Shows the HP bar temporary when it has been hit
    if (timer[4] > 0) {
      drawHPBar();
    }
  }
}
