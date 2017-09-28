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

  ArrayList<Widget> widgetList = new ArrayList<Widget>();
  ArrayList<Cube> cubeList = new ArrayList<Cube>();
  ArrayList<Enemy> enemyList = new ArrayList<Enemy>();
  ArrayList<Projectile> playerProjectileList = new ArrayList<Projectile>();
  ArrayList<Projectile> enemyProjectileList = new ArrayList<Projectile>();


  static Enemy loadBoss(Map map) {
    Boss b = new Boss(map.boss[0], map.boss[1], state);
    map.collision.push(b, true);
    return b;
  }

  static ArrayList<Entity> loadWall(Map map) {
    ArrayList<Entity> wall = new ArrayList<Entity>();
    for (int y = 0; y < map.level.length; y++) {
      for (int x = 0; x < map.level[y].length; x++) {
        if (map.level[y][x] == 1) {
          int pX = (x * LevelDef.TILE_WIDTH) + LevelDef.TILE_WIDTH/2;
          int pY = (y * LevelDef.TILE_HEIGHT) + LevelDef.TILE_HEIGHT/2;
          Entity w = new Entity(pX, pY, LevelDef.TILE_WIDTH, LevelDef.TILE_HEIGHT)
          map.collision.push(w, true);
          wall.add(w);
        }
      }
    }
    return wall;
  }

  static ArrayList<Portal> loadPortal(Map map) {
    ArrayList<Portal> portal = new ArrayList<Portal>();
    if (!map.portal || map.portal.length == 0) return portal;
    for (int i = 0; i < map.portal.length; i++) {
      Portal p = new Portal(map.portal[i][0], map.portal[i][1], map.camera, map.container);
      map.collision.push(p, true);
      portal.add(p);
    }
    return portal;
  }

  static ArrayList<Cube> loadCube(Map map) {
    ArrayList<Cube> cube = new ArrayList<Cube>();
    if (!map.cubes || map.cubes.length == 0) return cube;
    for (int i = 0; i < map.cubes.length; i++) {
      Cube c = new Cube(map.cubes[i][0], map.cubes[i][1], map.camera)
      map.collision.push(c, true);
      cube.add(c);
    }
    return cube;
  }

  static ArrayList<Enemy> loadEnemy(Map map) {
    ArrayList<Enemy> enemy = new ArrayList<Enemy>();
    if (!map.pathing || map.pathing.length == 0) return enemy;
    int[][] enemies = map.pathing;

    for (int i = 0; i < enemies.length; i++) {
      ArrayList<int[]> path = new ArrayList<int[]>();
      int startX = enemies[i][0][0];
      int startY = enemies[i][0][1];
      for (int u = 0; u < enemies[i].length; u++) {
        path.add(enemies[i][u]);
      }
      Enemy e = new Enemy(startX, startY, map.camera, path, map.player);
      map.collision.push(e, true);
      enemy.add(e);
    }
    return enemy;
  }

  static ArrayList<Widget> loadWidget(Map map) {
    int doorSearch;
    int addCount = 1;
    ArrayList<Widget> widget = new ArrayList<Widget>();
    ArrayList<Door> doors = new ArrayList<Door>();
    ArrayList<Integer> done = new ArrayList<Integer>();
    while (addCount > 0) {
      addCount = 0;
      doorSearch = 0;
      for (int y = 0; y < map.level.length; y++) {
        for (int x = 0; x < map.level[y].length; x++) {
          if (doorSearch == 0 && map.level[y][x] > 2 && map.level[y][x] != LevelDef.START) {
            doorSearch = map.level[y][x];
            for (int d = 0; d < done.size(); d++) {
              if (done.get(d) == doorSearch) doorSearch = 0;
            }
          }
          if (doorSearch == map.level[y][x] && doorSearch != 0) {
            Door d = new Door(x, y, Door.direction(x, y, map.level));
            map.collision.push(d, true);
            doors.add(d);
            addCount += 1;
          }
        }
      }
      if (doorSearch != 0) {
        int triggerId = LevelDef.getTrigger(doorSearch);
        for (int y = 0; y < map.level.length; y++) {
          for (int x = 0; x < map.level[y].length; x++) {
            if (map.level[y][x] == triggerId) {
              Trigger t = new Trigger(x, y, map.camera, doors)
              map.collision.push(t, true);
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

  Map(State state) {
    Object Quadtree = external.get('Quadtree');
    if (!Quadtree) system.log('Missing tree class.');

    this.container = state;
    this.camera = state.camera;
    this.player = state.player;

    int stage = state.stage;

    this.level = Level.level[stage];
    this.pathing = Level.pathing[stage];
    this.cubes = Level.cubes[stage];
    this.portal = Level.portal[stage];
    this.boss = Level.boss[stage];

    this.collision = new Quadtree({
      width: this.level.length * LevelDef.TILE_WIDTH,
      height: this.level.length * LevelDef.TILE_HEIGHT
    });
  }

  void start() {
    Map self = this;
    this.loadWall(self);
    this.cubeList.addAll(Map.loadCube(self));
    this.widgetList.addAll(Map.loadWidget(self));
    this.widgetList.addAll(Map.loadPortal(self));
    this.enemyList.addAll(Map.loadEnemy(self));
    if (this.bossExist()) this.enemyList.add(Map.loadBoss(self));

    console.log(this.collision.pretty());
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

  void drawWall(int x, int y) {
    pushMatrix();
    translate(x, y);
    fill(255, 53, 62);
    noStroke();
    image(asset.get(WallDef.ASSET_BASE), 0, 0);
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
    cX = abs(floor(this.camera.pos.x / LevelDef.TILE_WIDTH));
    cY = abs(floor(this.camera.pos.y / LevelDef.TILE_HEIGHT));
    oX = abs(ceil((this.camera.pos.x + __WIDTH__) / LevelDef.TILE_WIDTH));
    oY = abs(ceil((this.camera.pos.y + __HEIGHT__) / LevelDef.TILE_HEIGHT));
    if (this.camera.pos.x < 0) cX = 0;
    if (this.camera.pos.y < 0) cY = 0;
    if (cY+oY > this.level.length) oY = this.level.length;
    if (cX+oX > this.level[0].length) oX = this.level[0].length;

    yPos = cY * LevelDef.TILE_HEIGHT;
    for (int i = cY; i < oY; i++) {
      xPos = cX * LevelDef.TILE_WIDTH;
      for (int u = cX; u < oX; u++) {
        int drawX = xPos - this.camera.pos.x;
        int drawY = yPos - this.camera.pos.y;

        if (this.level[i][u] == 1) {
          this.drawWall(drawX, drawY);
        }
        if (this.level[i][u] > 0) {
          if (this.level[i][u+1] <= 0) {
            drawShadow(drawX + LevelDef.TILE_WIDTH, drawY, 10, LevelDef.TILE_HEIGHT);
            if (this.level[i+1][u+1] <= 0 && this.level[i+1][u] <= 0 ) {
              drawShadow(drawX + LevelDef.TILE_WIDTH, drawY + LevelDef.TILE_HEIGHT, 10, 10);
            }
          }
          if (this.level[i+1][u] <= 0) {
            drawShadow(drawX, drawY + LevelDef.TILE_HEIGHT, LevelDef.TILE_WIDTH, 10);
          }
        }
        xPos += LevelDef.TILE_WIDTH;
      }
      yPos += LevelDef.TILE_HEIGHT;
    }
  }
}

