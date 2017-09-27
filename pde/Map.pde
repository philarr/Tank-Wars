/*
  Map states and everything in it.
  (Entity, walls, projectiles, enemy, players)
*/
class Map {
  State container;
  Camera camera;
  int [][] level;
  int [][][] pathing;
  int [][] cubes;
  int [][] portal; // static
  int [] boss;
  Quadtree collision;
  ArrayList<PImage> img = new ArrayList<PImage>();
 // Quadtree collisionMap = new Quadtree();


  ArrayList<Widget> widgetList;
  ArrayList<Cube> cubeList;
  ArrayList<Enemy> enemyList;
  ArrayList<Projectile> playerProjectileList = new ArrayList<Projectile>();
  ArrayList<Projectile> enemyProjectileList = new ArrayList<Projectile>();


  Map(State state) {
    Object Quadtree = external.get('Quadtree');
    if (!Quadtree) system.log('Missing tree class.');

    this.tileW = Asset.tileW;
    this.tileH = Asset.tileH;
    this.tileFolder = Asset.tileFolder;

    this.container = state;
    this.camera = state.camera;

    int stage = state.stage;

    this.level = Level.level[stage];
    this.pathing = Level.pathing[stage];
    this.cubes = Level.cubes[stage];
    this.portal = Level.portal[stage];
    this.boss = Level.boss[stage];

    this.collision = new Quadtree({
      width: this.level.length * Asset.tileW,
      height: this.level.length * Asset.tileH
    });
  }

  void start() {
    this.loadAsset();
    this.loadWall();
    this.cubeList = this.loadCube();
    this.widgetList = this.loadWidget(this.container.hud);
    this.widgetList.addAll(this.loadPortal(this.container));
    this.enemyList = this.loadEnemy(this.container.player);
    if (this.bossExist()) enemyList.add(this.loadBoss(this.container.hud, this.container.player, this.container));

    console.log(this.collision.pretty());
  }


  boolean inScreen(Entity obj) {
    return ((obj.tpos.x-obj.w/2)-camera.pos.x < __WIDTH__ && (obj.tpos.x+obj.w/2)-camera.pos.x > 0
      &&  (obj.tpos.y-obj.h/2)-camera.pos.y < __HEIGHT__ && (obj.tpos.y+obj.h/2)-camera.pos.y > 0
      ||  camera.isFocus(obj));
  }

  int[][] getCollision() {
    return this.level;
  }

  PVector getPlayerStart() {
    PVector startXY = new PVector(0, 0);
    for (int y = 0; y < this.level.length; y++) {
      for (int x = 0; x < this.level[y].length; x++) {
        if (this.level[y][x] == LevelDef.START) {
          startXY.set(x, y, 0);
          return startXY;
        }
      }
    }
    return startXY;
  }

  boolean bossExist() {
    return !!this.boss && this.boss.length > 0;
  }

  Enemy loadBoss(UI hud, Player player, State state) {
    Boss b = new Boss(this.boss[0], this.boss[1], camera, player, hud, state);
    this.collision.push(b, true);
    return b;
  }

  ArrayList<Entity> loadWall() {
    ArrayList<Entity> walls = new ArrayList<Entity>();
    for (int y = 0; y < this.level.length; y++) {
      for (int x = 0; x < this.level[y].length; x++) {
        if (this.level[y][x] == 1) {
          Entity w = new Entity((x * 50) + 25, (y * 50) + 25, 50, 50)
          this.collision.push(w, true);
          walls.add(w);
        }
      }
    }
    return walls;
  }

  ArrayList<Portal> loadPortal() {
    ArrayList<Portal> portals = new ArrayList<Portal>();
    if (!this.portal || this.portal.length == 0) return portals;
    for (int i = 0; i < this.portal.length; i++) {
      Portal p = new Portal(this.portal[i][0], this.portal[i][1], this.camera, this.container);
      this.collision.push(p, true);
      portals.add(p);
    }
    return portals;
  }

  ArrayList loadCube() {
    ArrayList<Cube> cube = new ArrayList<Cube>();
    if (!this.cubes || this.cubes.length == 0) return cube;
    for (int i = 0; i < this.cubes.length; i++) {
      Cube c = new Cube(this.cubes[i][0], this.cubes[i][1], this.camera)
      this.collision.push(c, true);
      cube.add(c);
    }
    return cube;
  }

  ArrayList<Enemy> loadEnemy(Player player) {
    ArrayList<Enemy> enemy = new ArrayList<Enemy>();
    if (!this.pathing || this.pathing.length == 0) return enemy;
    int[][] enemies = this.pathing;

    for (int i = 0; i < enemies.length; i++) {
      ArrayList<int[]> enemyPath = new ArrayList<int[]>();
      int startX = enemies[i][0][0];
      int startY = enemies[i][0][1];
      for (int u = 0; u < enemies[i].length; u++) {
        enemyPath.add(enemies[i][u]);
      }
      Enemy e = new Enemy(startX, startY, camera, enemyPath, player);
      this.collision.push(e, true);
      enemy.add(e);
    }
    return enemy;
  }

  ArrayList<Widget> loadWidget(UI hud) {
    int doorSearch;
    int addCount = 1;
    ArrayList<Widget> widget = new ArrayList<Widget>();
    ArrayList<Door> doors = new ArrayList<Door>();
    ArrayList<Integer> done = new ArrayList<Integer>();
    while (addCount > 0) {
      addCount = 0;
      doorSearch = 0;
      for (int y = 0; y < this.level.length; y++) {
        for (int x = 0; x < this.level[y].length; x++) {
          if (doorSearch == 0 && this.level[y][x] > 2 && this.level[y][x] != LevelDef.START) {
            doorSearch = this.level[y][x];
            for (int d = 0; d < done.size(); d++) {
              if (done.get(d) == doorSearch) doorSearch = 0;
            }
          }
          if (doorSearch == this.level[y][x] && doorSearch != 0) {
            Door d = new Door(x, y, camera, hud, this.level);
            this.collision.push(d, true);
            doors.add(d);
            addCount += 1;
          }
        }
      }
      if (doorSearch != 0) {
        int triggerId = LevelDef.getTrigger(doorSearch);
        for (int y = 0; y < this.level.length; y++) {
          for (int x = 0; x < this.level[y].length; x++) {
            if (this.level[y][x] == triggerId) {
              Trigger t = new Trigger(x, y, camera, doors, hud)
              this.collision.push(t, true);
              widget.add(t);
            }
          }
        }
      }
      done.add(doorSearch);
      widget.addAll(doors);
      doors.clear();
    }
    return widget;
  }


  boolean loadAsset() {
    String[] asset = {
      "0.png"
    };
    for (int i=0; i<asset.length; i++) {
      img.add(loadImage(this.tileFolder + asset[i]));
      //println("Loaded -> " + asset[i]);
    }
    return true;
  }

  void drawWall(int x, int y) {
    pushMatrix();
    translate(x, y);
    fill(255, 53, 62);
    noStroke();
    image(this.img.get(0), 0, 0);
    popMatrix();
  }

  void drawShadow(int x, int y, int w, int h) {
    pushMatrix();
    translate(x, y);
    fill(0, 0, 0, 127);
    noStroke();
    rect(0, 0, w, h);
    popMatrix();
  }

  void update() {
  }

  void draw() {
    int xPos, yPos, cX, cY, oX, oY;
    cX = abs(floor(this.camera.pos.x / this.tileW));
    cY = abs(floor(this.camera.pos.y / this.tileH));
    oX = abs(ceil((this.camera.pos.x + __WIDTH__) / this.tileW));
    oY = abs(ceil((this.camera.pos.y + __HEIGHT__) / this.tileH));
    if (this.camera.pos.x < 0) cX = 0;
    if (this.camera.pos.y < 0) cY = 0;
    if (cY+oY > this.level.length) oY = this.level.length;
    if (cX+oX > this.level[0].length) oX = this.level[0].length;

    yPos = cY * 50;
    for (int i = cY; i < oY; i++) {
      xPos = cX * 50;
      for (int u = cX; u < oX; u++) {
        int drawX = xPos - this.camera.pos.x;
        int drawY = yPos - this.camera.pos.y;

        if (this.level[i][u] == 1) {
          this.drawWall(drawX, drawY);
        }
        if (this.level[i][u] > 0) {
          if (this.level[i][u+1] <= 0) {
            drawShadow(drawX + this.tileW, drawY, 10, this.tileH);
            if (this.level[i+1][u+1] <= 0 && this.level[i+1][u] <= 0 ) {
              drawShadow(drawX + this.tileW, drawY + this.tileH, 10, 10);
            }
          }
          if (this.level[i+1][u] <= 0) {
            drawShadow(drawX, drawY + this.tileH, this.tileW, 10);
          }
        }
        xPos += 50;
      }
      yPos += 50;
    }
  }
}

