//Asset - class to load the images needed for the game

class Asset {

  String imgFolder = "Asset/";
  ArrayList<PImage> img = new ArrayList<PImage>();

  Asset() {
    String[] asset = {
      "Title.png", //0
      "tank.png", //1
      "tank_turret.png", //2
      "enemy.png", //3
      "enemy_turret.png", //4
      "Title1.png", //5
      "Title2.png", //6 
      "Title_.png", //7
      "Tile/1.png", //8
      "trigger.png", //9
      "block.png", //10
      "hudbox.png", //11
      "hudcharge.png", //12
      "hudsmallbox.png", //13
      "boss.png", //14
      "boss_turret.png" // 15
    };

    for (int i=0; i<asset.length; i++) {
      img.add(loadImage(imgFolder + asset[i]));
      //println("Loaded -> " + asset[i]);
    }
  }
}

