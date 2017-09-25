//Map class that generates the blocks and non unit collision

class Map {
  int tileW = 50;
  int tileH = 50;
  int fullWidth, fullHeight;
  int[][][] level;
  int stage;
  Camera camera;
  String tileFolder = "Asset/Tile/";
  ArrayList<PImage> img = new ArrayList<PImage>();

  Map(int[][][] level, int w, int h, Camera obj, int stage) {
    this.fullWidth = w;
    this.fullHeight = h;
    this.camera = obj;
    this.level = level;
    this.stage = stage;
  }

  int[][] getCollision() {
    return level[this.stage];
  }

  PVector getPlayerSpawn() {
    PVector spawnXY = new PVector(0, 0);
    for (int i=0; i<level[stage].length; i++) {
      for (int u=0; u<level[stage][i].length; u++) {
        if (level[stage][i][u] == -99) {
          spawnXY.set(u, i, 0);
        }
      }
    }
    return spawnXY;
  }

  boolean bossExist(int[][] bosschart) {
    if (bosschart[stage].length != 0) {
      return true;
    }
    return false;
  }

  Boss loadBoss(int[][] bosschart, UI hud, Player player, State s) {
    Boss b = new Boss(bosschart[stage][0], bosschart[stage][1], camera, player, hud, s);
    return b;
  }

  ArrayList loadPortal(State state) {
    ArrayList<Portal> portals = new ArrayList<Portal>();

    if (stage > portal.length ) return portals;
    for (int i=0; i<portal[stage].length; i++) {
      portals.add(new Portal(portal[stage][i][0], portal[stage][i][1], this.camera, state));
    }
    return portals;
  }


  ArrayList loadCube() {
    ArrayList<Cube> cube = new ArrayList<Cube>();
    if (stage > cubes.length-1) return cube;
    for (int i=0; i<cubes[stage].length; i++) {
      cube.add(new Cube(cubes[stage][i][0], cubes[stage][i][1], this.camera));
    }
    return cube;
  }

  ArrayList loadEnemy(int[][][][] p, Player player) {
    ArrayList<Enemy> enemy = new ArrayList<Enemy>();
    if (stage > pathing.length-1) return enemy;
    int[][][] enemies = p[stage];

    for (int i=0; i<enemies.length; i++) {
      ArrayList<int[]> enemypath = new ArrayList<int[]>();
      for (int u=0; u<enemies[i].length; u++) {
        int spawnX = enemies[i][0][0];
        int spawnY = enemies[i][0][1];
        enemypath.add(enemies[i][u]);
      }
      enemy.add(new Enemy(enemies[i][0][0], enemies[i][0][1], camera, enemypath, player));
    }

    return enemy;
  }

  ArrayList loadWidget(UI hud) {
    int cSearch;
    int addCount = 1;
    ArrayList<Widget> widget = new ArrayList<Widget>();
    ArrayList<Door> doors = new ArrayList<Door>();
    ArrayList<Integer> done = new ArrayList<Integer>();

    while (addCount > 0) {
      addCount = 0;
      cSearch = 0;
      for (int i=0; i<level[stage].length; i++) {
        for (int u=0; u<level[stage][i].length; u++) {
          if (cSearch == 0 && level[stage][i][u] > 2 && level[stage][i][u] != -99) {
            cSearch = level[stage][i][u];
            for (int d=0; d<done.size(); d++) {
              if (done.get(d) == cSearch) cSearch = 0;
            }
          }
          if (cSearch == level[stage][i][u] && cSearch != 0) {
            doors.add(new Door(u, i, camera, hud, stage));
            addCount += 1;
          }
        }
      }
      if (cSearch != 0) {
        int triggerNum = cSearch * -1;
        for (int i=0; i<level[stage].length; i++) {
          for (int u=0; u<level[stage][i].length; u++) {
            if (level[stage][i][u] == triggerNum) {
              widget.add(new Trigger(u, i, camera, doors, hud));
            }
          }
        }
      }

      done.add(cSearch);
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
      img.add(loadImage(tileFolder + asset[i]));
      //println("Loaded -> " + asset[i]);
    }
    return true;
  }



  void draw() {
    int l = this.stage;
    int xPos, yPos, cX, cY, oX, oY;
    cX = abs(floor(camera.pos.x/tileW));
    cY = abs(floor(camera.pos.y/tileH));
    oX = abs(ceil((camera.pos.x+fullWidth)/tileW));
    oY = abs(ceil((camera.pos.y+fullHeight)/tileH));
    if (camera.pos.x < 0) cX = 0;
    if (camera.pos.y < 0) cY = 0;
    if (cY+oY > level[l].length) oY = level[l].length;
    if (cX+oX > level[l][0].length) oX = level[l][0].length;

    yPos = cY * 50;
    for (int i=cY; i<oY; i++) {
      xPos = cX * 50;
      for (int u=cX; u<oX; u++) {
        if (level[l][i][u] == 1) {
          pushMatrix();
          translate(xPos - camera.pos.x, yPos - camera.pos.y  );
          fill(255, 53, 62);
          noStroke();
          image(img.get(0), 0, 0);
          popMatrix();
        }

        if (level[l][i][u] > 0) {
          if (level[l][i][u+1] <= 0) {
            pushMatrix();
            translate(xPos+tileW - camera.pos.x, yPos - camera.pos.y  );
            fill(0, 0, 0, 127);
            noStroke();
            rect(0, 0, 10, tileH);
            popMatrix();
            if (level[l][i+1][u+1] <= 0 && level[l][i+1][u] <= 0 ) {
              pushMatrix();
              translate(xPos+tileW - camera.pos.x, yPos+tileH - camera.pos.y  );
              fill(0, 0, 0, 127);
              noStroke();
              rect(0, 0, 10, 10);
              popMatrix();
            }
          }
          if (level[l][i+1][u] <= 0) {
            pushMatrix();
            translate(xPos - camera.pos.x, yPos+tileH - camera.pos.y  );
            fill(0, 0, 0, 127);
            noStroke();
            rect(0, 0, tileW, 10);
            popMatrix();
          }
        }

        xPos += 50;
      }
      yPos += 50;
    }
  }
}

