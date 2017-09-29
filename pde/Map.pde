/*
  Map states and everything in it.
  (Entity, walls, projectiles, enemy, players)
*/
class Map {
  State container;
  Player player;
  Camera camera;
  int [][] level;
  int [][][] pathing;
  int [][] cubes;
  int [][] portal; // static
  int [] boss;
  Quadtree collision;

  Player player;
  ArrayList<Entity> widgetList = new ArrayList<Entity>();
  ArrayList<Entity> cubeList = new ArrayList<Entity>();
  ArrayList<Entity> enemyList = new ArrayList<Entity>();
  ArrayList<Entity> playerProjectileList = new ArrayList<Entity>();
  ArrayList<Entity> enemyProjectileList = new ArrayList<Entity>();

  static int[] toCoord(int tileX, int tileY) {
    int[] coord = {
      (tileX * LevelDef.TILE_WIDTH) + LevelDef.TILE_WIDTH/2,
      (tileY * LevelDef.TILE_HEIGHT) + LevelDef.TILE_HEIGHT/2
    };
    return coord;
  }


  static Enemy loadBoss(Map map) {
    Boss b = new Boss(map.boss[0], map.boss[1], state);
    map.collision.push(b, true);
    return b;
  }

  static ArrayList<Wall> loadWall(Map map) {
    ArrayList<Wall> wall = new ArrayList<Wall>();
    for (int y = 0; y < map.level.length; y++) {
      for (int x = 0; x < map.level[y].length; x++) {
        if (map.level[y][x] == 1) {
          int[] coord = Map.toCoord(x, y);
          Wall w = new Wall(coord[0], coord[1], map.camera, null);
          wall.add(w);
        }
      }
    }
    map.collision.pushAll(wall.toArray(), true);
    return wall;
  }

  static ArrayList<Portal> loadPortal(Map map) {
    ArrayList<Portal> portal = new ArrayList<Portal>();
    if (!map.portal || map.portal.length == 0) return portal;
    for (int i = 0; i < map.portal.length; i++) {
      int[] coord = Map.toCoord(map.portal[i][0], map.portal[i][1]);
      Portal p = new Portal(coord[0], coord[1], map.camera, map.container);
      portal.add(p);
    }
    map.collision.pushAll(portal.toArray(), true);
    return portal;
  }

  static ArrayList<Cube> loadCube(Map map) {
    ArrayList<Cube> cube = new ArrayList<Cube>();
    if (!map.cubes || map.cubes.length == 0) return cube;
    for (int i = 0; i < map.cubes.length; i++) {
      int[] coord = Map.toCoord(map.cubes[i][0], map.cubes[i][1]);
      Cube c = new Cube(coord[0], coord[1], map.camera)
      cube.add(c);
    }
    map.collision.pushAll(cube.toArray(), true);
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
      int[] coord = Map.toCoord(startX, startY);
      Enemy e = new Enemy(coord[0], coord[1], map.camera, path, map.player);
      enemy.add(e);
    }
    map.collision.pushAll(enemy.toArray(), true);
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
            int[] coord = Map.toCoord(x, y);
            Door d = new Door(coord[0], coord[1], map.camera, Door.direction(x, y, map.level));
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
              int[] coord = Map.toCoord(x, y);
              Trigger t = new Trigger(coord[0], coord[1], map.camera, doors)
              widget.add(t);
            }
          }
        }
      }
      done.add(doorSearch);
      widget.addAll(doors);
      doors.clear();
    }
    map.collision.pushAll(widget.toArray(), true);
    return widget;
  }

  Map(State state) {
    Object Quadtree = external.get('Quadtree');
    if (!Quadtree) system.log('Missing tree class.');

    this.container = state;
    this.camera = state.camera;

    int stage = state.stage;

    this.level = Level.level[stage];
    this.pathing = Level.pathing[stage];
    this.cubes = Level.cubes[stage];
    this.portal = Level.portal[stage];
    this.boss = Level.boss[stage];

    this.player = new Player(this.getPlayerStart(), state.camera);

    this.collision = new Quadtree({
      width: this.level.length * LevelDef.TILE_WIDTH,
      height: this.level.length * LevelDef.TILE_HEIGHT
    });
  }

  void start() {
    Map self = this;
    this.cubeList.addAll(Map.loadCube(self));
    this.widgetList.addAll(Map.loadWall(self));
    this.widgetList.addAll(Map.loadWidget(self));
    this.widgetList.addAll(Map.loadPortal(self));
    this.enemyList.addAll(Map.loadEnemy(self));
    if (this.bossExist()) this.enemyList.add(Map.loadBoss(self));

    // Order matters for draw z-index

    console.log(this.collision.pretty());
  }

  void updateEntity(ArrayList<Entity> list) {
    for (int i = 0; i < list.size(); i++) {
      Entity entity = list.get(i);
      Entity[] collided = this.collision.colliding(entity);
      for (int c = 0; c < collided.length; c++) {
        if (collided[c].resolveBlock(entity)) {
          list.remove(collided[c]);
          this.collision.remove(collided[c]);
        }
        if (entity.resolveBlock(collided[c])) {
          list.remove(entity);
          this.collision.remove(entity);
        }
      }
      entity.update();
    }
  }

  void updateProjectile(ArrayList<Projectile> list) {
    for (int i = 0; i < list.size(); i++) {
      Projectile projectile = list.get(i);
      Entity[] collided = this.collision.colliding(projectile);
      for (int c = 0; c < collided.length; c++) {
        if (collided[c].resolveBlock(projectile)) {
          list.remove(collided[c]);
          this.collision.remove(collided[c]);
        }
        if (projectile.resolveBlock(collided[c], list, this.collision)) {
          list.remove(projectile);
          this.collision.remove(projectile);
        }
      }
      projectile.update();
    }
  }

  void update() {
    if (this.container.isPaused()) return;

    updateProjectile(this.playerProjectileList);
    updateProjectile(this.enemyProjectileList);
    updateEntity(this.widgetList);
    updateEntity(this.cubeList);
    updateEntity(this.enemyList);

    Entity[] collided = this.collision.colliding(this.player);


    for (int c = 0; c < collided.length; c++) {
      collided[c].resolveBlock(this.player);
      this.player.resolveBlock(collided[c]);
    }
    this.player.update();
  }

  void drawEntity(ArrayList<Entity> list) {
    for (int i = 0; i < list.size(); i++) {
      Entity e = list.get(i);
      if (this.camera && this.camera.inScreen(e)) e.draw();
    }
  }

  void draw() {
    drawEntity(this.widgetList);
    drawEntity(this.cubeList);
    drawEntity(this.enemyList);
    drawEntity(this.playerProjectileList);
    drawEntity(this.enemyProjectileList);

    if (this.camera && this.camera.inScreen(this.player)) {
      this.player.draw();
    }
  }

  PVector getPlayerStart() {
    PVector startXY = new PVector(0, 0);
    for (int y = 0; y < this.level.length; y++) {
      for (int x = 0; x < this.level[y].length; x++) {
        if (this.level[y][x] == LevelDef.START) {
          int[] coord = Map.toCoord(x, y);
          startXY.set(coord[0], coord[1], 0);
          return startXY;
        }
      }
    }
    return startXY;
  }

  boolean bossExist() {
    return !!this.boss && this.boss.length > 0;
  }

  void removeEntity() {}
  void removeProjectile(Entity entity) {}

}

