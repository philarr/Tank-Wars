//Asset - class to load the images needed for the game

class Asset {
  final static String imgFolder = "Asset/";
  final static String tileFolder = "Asset/Tile/";
  final static int tileW = 50;
  final static int tileH = 50;
  HashMap<String, PImage> images = new HashMap<String, PImage>();

  Asset() {
    this.images.put("Title", loadImage(imgFolder + "Title.png"));
    this.images.put("tank", loadImage(imgFolder + "tank.png"));
    this.images.put("tank_turret", loadImage(imgFolder + "tank_turret.png"));
    this.images.put("enemy", loadImage(imgFolder + "enemy.png"));
    this.images.put("enemy_turret", loadImage(imgFolder + "enemy_turret.png"));
    this.images.put("Title1", loadImage(imgFolder + "Title1.png"));
    this.images.put("Title2", loadImage(imgFolder + "Title2.png"));
    this.images.put("Title_", loadImage(imgFolder + "Title_.png"));
    this.images.put("door", loadImage(imgFolder + "Tile/door.png"));
    this.images.put("wall", loadImage(imgFolder + "Tile/wall.png"));
    this.images.put("trigger", loadImage(imgFolder + "trigger.png"));
    this.images.put("block", loadImage(imgFolder + "block.png"));
    this.images.put("hudbox", loadImage(imgFolder + "hudbox.png"));
    this.images.put("hudcharge", loadImage(imgFolder + "hudcharge.png"));
    this.images.put("hudsmallbox", loadImage(imgFolder + "hudsmallbox.png"));
    this.images.put("boss", loadImage(imgFolder + "boss.png"));
    this.images.put("boss_turret", loadImage(imgFolder + "boss_turret.png"));
  }

  PImage get(String key) {
    return this.images.get(key);
  }
}

