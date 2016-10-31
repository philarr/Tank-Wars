class State {
  Boolean block; //If block is true, this instance of the state is removed
  Boolean pause; //Pause this state

    State() {
    this.block = false;
    this.pause = false;
  }

  //Methods to be overridden at subclass
  void start() {
  }
  void update() {
  }
  void draw() {
  }
  void keyDown() {
  }
  void keyUp() {
  }

  boolean isBlocked() {
    if (this.block) { 
      return true;
    }
    return false;
  }

  boolean isPaused() {
    if (this.pause) {
      return true;
    }
    return false;
  }
}

class Title extends State {

  int bg1X = 0;
  int bg2X = -800;
  int fadeIn = 0;
  int menuNum = 0;
  HUD hud = new HUD(null, null);

  Title() { 
    //this.block = true;
  }


  void update() {

    image(asset.img.get(6), bg2X++, 0);
    image(asset.img.get(6), bg1X++, 0);
    image(asset.img.get(5), 0, 0);

    tint(255, fadeIn); 
    image(asset.img.get(7), width/2-(539/2)-31, height/2-(179/2)-50); 
    noTint();
    if (fadeIn != 255) { 
      fadeIn += 3;
    }

    if (fadeIn >= 100) {
      textAlign(CENTER);
      textSize(24);
      text("Start Game", 800/2, 600/2+100);
      pushMatrix();
      if (menuNum == 0) { 
        translate(800/2-100, 600/2 + 85);
      }
      else { 
        translate(800/2-100, 600/2 + 135);
      }
      scale(0.5);
      triangle(0, 0, 25, 15, 0, 30);
      popMatrix();
      text("Instructions", 800/2, 600/2 + 150);
      textAlign(LEFT);
      hud.update();
    }

    if (bg1X >= 800) bg1X = -800;
    if (bg2X >= 800) bg2X = -800;
  }

  void keyDown() {
    if (hud.messageBox) hud.interceptEnter();
    else {
      if (key == CODED) {
        if (keyCode == UP || keyCode == DOWN) {
          if (menuNum == 0) menuNum++;
          else menuNum--;
        }
      }
    }
    if (key == ' ' || key == ENTER || key == RETURN) {
      if (hud.messageBox) hud.interceptEnter();
      else {
        if (menuNum == 0) this.block = true;
        if (menuNum == 1) {  

          ArrayList<Dialogue> about = new ArrayList<Dialogue>();
          about.add(new Dialogue(-1, null, "Welcome to Tank Wars! \n\n (...)"));
          about.add(new Dialogue(-1, "Controls", "Movement: <W> <A> <S> <D> / Mouse: (Aiming) \nShoot: <Space> / Charge: <Space> + hold \nSwitch Weapon: <R>"));

          hud.say(about);
        }
      }
    }
  }
}

class Playing extends State {

  boolean up, down, left, right, space;
  Camera camera;
  Player player;
  Map map;
  int[][] mapc;
  HUD hud;
  ArrayList<Widget> widget;
  ArrayList<Cube> cube;
  ArrayList<Unit> unit;
  ArrayList<Enemy> enemy;
  ArrayList<Projectile> playerProjectile;
  ArrayList<Projectile> enemyProjectile;
  ArrayList<Portal> portal;
  int stage;
  int currentWeap;


  Playing(int stage) { 

    enemy = new ArrayList<Enemy>();
    widget = new ArrayList<Widget>();
    cube = new ArrayList<Cube>();
    portal = new ArrayList<Portal>();
    playerProjectile = new ArrayList<Projectile>();
    enemyProjectile = new ArrayList<Projectile>();
    this.stage = stage;

  } 

  void start() {
    camera = new Camera(-350, -350);  
    map = new Map(level, width, height, this.camera, stage);
    map.loadAsset();
    mapc = map.getCollision();
    player = new Player(map.getPlayerSpawn(), this.camera);
    hud = new HUD(camera, player); 
    camera.setPlayer(player);
    widget.addAll(map.loadWidget(hud));
    enemy.addAll(map.loadEnemy(pathing, player));

    if (map.bossExist(bosschart)) enemy.add(map.loadBoss(bosschart, hud, player, this));

    cube.addAll(map.loadCube());
    widget.addAll(map.loadPortal(this));

  }


  //Checks if object is within screen region
  boolean inScreen(Entity obj) {
    if ((obj.tpos.x-obj.wSize/2)-camera.pos.x < width && (obj.tpos.x+obj.wSize/2)-camera.pos.x > 0
      &&  (obj.tpos.y-obj.hSize/2)-camera.pos.y < height && (obj.tpos.y+obj.hSize/2)-camera.pos.y > 0
      ||  camera.ifFocus(obj)) return true;
    return false;
  }



  void update() { 
    background(30, 30, 30);

    //Draw enemy agro radius first
    for (int i=0; i<enemy.size(); i++) {
      Enemy e = enemy.get(i);
      if (inScreen(e)) e.aggroDraw();
    }
    map.draw();

    //Widget to player and cube
    for (int h=0; h<widget.size(); h++) {
      Widget w = widget.get(h); 
      w.resolveCollision(player.detectCollision(w));
      for (int i=0; i<cube.size(); i++) {
        Cube c = cube.get(i);
        w.resolveCollision(c.detectCollision(w), c);
      }
      if (!isPaused()) w.update();
      if (inScreen(w)) w.draw();
    }


    //Cube to wall & player
    for (int i=0; i<cube.size(); i++) {
      Cube c = cube.get(i);
      if (c.detectBlock(mapc)) c.resolveBlock();
      if (c.detectCollision(player)) c.resolveCollision(player);
      if (!isPaused()) c.update();
      if (inScreen(c)) c.draw();
    }

    //Enemy to wall & Player
    for (int i=0; i<enemy.size(); i++) {
      Enemy e = enemy.get(i);
      if (e.detectCollision(player)) player.isHit(e, e.dmg);
      if (e.detectAggro(player)) e.shoot(player.pos.x, player.pos.y, e.chargeTime, 10, e.reload, enemyProjectile);
      if (e.detectBlock(mapc)) e.resolveBlock();
      if (!isPaused()) e.update(enemy);
      if (inScreen(e)) e.draw();
    }






    //Player projectile to enemy + cube
    for (int i=0; i<playerProjectile.size(); i++) { 
      Projectile cc = playerProjectile.get(i);
      if (cc.detectBlock(mapc)) cc.resolveBlock(playerProjectile);
      for (int h=0; h<cube.size(); h++) {
        Cube c = cube.get(h);
        if (cc.detectCollision(c)) cc.resolveCollision(c, playerProjectile);
      }
      for (int u=0; u<enemy.size(); u++) {
        Enemy e = enemy.get(u);
        if (cc.detectCollision(e)) cc.resolveCollision(e, playerProjectile);
      }
      if (!isPaused()) cc.update(); 
      if (inScreen(cc)) cc.draw();
    }
    //Enemy projectile to player & cube
    for (int i=0; i<enemyProjectile.size(); i++) {
      Projectile ee = enemyProjectile.get(i);
      if (ee.detectBlock(mapc)) ee.resolveBlock(enemyProjectile);
      if (ee.detectCollision(player)) ee.resolveCollision(player, enemyProjectile);
      for (int u=0; u<cube.size(); u++) {
        Cube c = cube.get(u);
        if (ee.detectCollision(c)) enemyProjectile.remove(ee);
      }

      if (!isPaused()) ee.update();
      if (inScreen(ee)) ee.draw();
    }

    //Player to wall
    if (player.detectBlock(mapc)) {
      player.resolveBlock();
      player.chargeTime = 0;
    }
    if (!isPaused()) player.update(); 
    if (inScreen(player)) player.draw();


    /**********/
    if (!isPaused()) {
      camera.update();
      hud.update();
      if (camera.focus != null) {  
        if (up) camera.focus.move(0, -1); 
        if (down) camera.focus.move(0, 1); 
        if (left) camera.focus.move(-1, 0); 
        if (right) camera.focus.move(1, 0);
        if (space) player.charge();
      }
    }
    else {
      //Paused screen
      fill(0, 0, 0, 127);
      rect(0, 0, width, height);
      textAlign(CENTER);
      fill(255, 255, 255);
      if (player.health > 0) text("Paused", width/2, height/2);
      textAlign(LEFT);
    }
    //Player dead
    if (player.health <= 0 && !isPaused()) {
      this.pause = true;
      hud.say1(new Dialogue(-1, null, "Game over..."));
    }

    if (player.health <= 0) {
      player.update();
      player.draw();
      hud.update();
    }
  }

  void keyDown() { 

    if (key == 119) this.up = true; //w
    else if (key == 115) this.down = true; //s
    else if (key == 97) this.left = true; //a
    else if (key == 100) this.right = true; //d

    if (key == 114) {
      if (currentWeap == 0) {
        player.setWeapon(0);
        currentWeap = 1;
      }
      else {
        currentWeap = 0;
        player.setWeapon(1);
      }
    }


    if (key == ' ' || key == ENTER || key == RETURN) {
      this.space = true;
    }
    //Pausing
    if (keyCode == 27) {
      key = 0;
      if (this.pause) this.pause = false;
      else this.pause = true;
    }
  }
  void keyUp() { 
    if (key == 119) this.up = false; //w
    else if (key == 115) this.down = false; //s
    else if (key == 97) this.left = false; //a
    else if (key == 100) this.right = false; //d

    if (key == ' ' || key == ENTER || key == RETURN) {
      if (space) {
        this.space = false;
        if (!hud.interceptEnter() && !isPaused()) {

          player.shoot(mouseX, mouseY, player.chargeTime, 10, player.reload, playerProjectile);
          player.chargeTime = 0;
        }
      }
    }
  }
}

class Gameover extends State {

  int bg1X = 0;
  int bg2X = -800;
  int fadeIn = 0;
  int menuNum = 0;
  boolean msg;
  HUD hud = new HUD(null, null);

  Gameover() { 
    this.msg = false;
  }

  void update() {
    image(asset.img.get(6), bg2X++, 0);
    image(asset.img.get(6), bg1X++, 0);
    image(asset.img.get(5), 0, 0);
    image(asset.img.get(7), width/2-(539/2)-31, height/2-(179/2)-50); 
    noTint();
    if (!msg) {
      hud.say1(new Dialogue(-1, null, "Thanks for playing!"));
      msg = true;
    }
    hud.update();
    if (bg1X >= 800) bg1X = -800;
    if (bg2X >= 800) bg2X = -800;
  }
}

