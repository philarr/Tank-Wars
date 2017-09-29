class Playing extends State {
  Camera camera;
  Player player;
  Map map;
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
    this.map.start();
    this.player = map.player;
    console.log(this.player);
    this.camera.setPlayer(this.player);
    this.ui = new UI(this.player);
    this.widget = map.widgetList;
    this.enemy = map.enemyList;
    this.cube = map.cubeList;
  }


  void update() {
    background(30, 30, 30);

    if (!this.isPaused()) this.map.update();
    this.map.draw();

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
      player.shoot(mouseX, mouseY, player.chargeTime, 10, player.reload, this.map.playerProjectileList, this.map.collision);
      player.chargeTime = 0;
    }
  }
}