class Playing extends State {
  Camera camera;
  Player player;
  Map map;
  int[][] mapc;
  UI ui;
  ArrayList<Widget> widget;
  ArrayList<Cube> cube;
  ArrayList<Enemy> enemy;
  ArrayList<Projectile> playerProjectile = new ArrayList<Projectile>();
  ArrayList<Projectile> enemyProjectile = new ArrayList<Projectile>();
  int stage;
  int currentWeap;


  Playing(int stage) {
    this.stage = stage;
  }

  void start() {
    this.camera = new Camera(-350, -350);
    narrator.setCamera(this.camera);

    this.map = new Map(this);
    this.player = new Player(this.map.getPlayerStart(), this.camera);
    this.camera.setPlayer(this.player);
    this.ui = new UI(this.player);
    this.mapc = map.getCollision();

    this.widget = map.widgetList;
    this.enemy = map.enemyList;
    this.cube = map.cubeList;
    this.map.start();
  }

  //Checks if object is within screen region
  boolean inScreen(Entity entity) {
    if ((entity.tpos.x-entity.w/2) - this.camera.pos.x < width
    && (entity.tpos.x+entity.w/2) - this.camera.pos.x > 0
    && (entity.tpos.y-entity.h/2) - this.camera.pos.y < height
    && (entity.tpos.y+entity.h/2) - this.camera.pos.y > 0
    || camera.isFocus(entity)) return true;
    return false;
  }

  void update() {
    background(30, 30, 30);

    //Draw enemy agro radius first
    for (int i=0; i<enemy.size(); i++) {
      Enemy e = enemy.get(i);
      if (inScreen(e)) e.aggroDraw();
    }

    this.map.update();
    this.map.draw();

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
      this.camera.update();
      this.ui.update();
      if (this.camera.focus != null) {
        if (input.STATE_UP) camera.focus.move(0, -1);
        if (input.STATE_DOWN) camera.focus.move(0, 1);
        if (input.STATE_LEFT) camera.focus.move(-1, 0);
        if (input.STATE_RIGHT) camera.focus.move(1, 0);
        if (input.STATE_ENTER) player.charge();
      }
    } else {
      //Paused screen
      fill(0, 0, 0, 127);
      rect(0, 0, width, height);
      textAlign(CENTER);
      fill(255, 255, 255);
      if (player.health > 0) text("Paused", width/2, height/2);
      textAlign(LEFT);
    }
    //Player dead
    if (player.isDead() && !isPaused()) this.block = true;
  }

  void keyDown() {
    if (Input.isR()) {
      currentWeap = currentWeap == 0 ? 1 : 0;
      player.setWeapon(currentWeap);
    }
    if (Input.isEsc() || Input.isP()) {
      this.pause = !this.pause;
    }
  }

  void keyUp() {
    if (Input.isEnter()) {
      player.shoot(mouseX, mouseY, player.chargeTime, 10, player.reload, playerProjectile);
      player.chargeTime = 0;
    }
  }
}