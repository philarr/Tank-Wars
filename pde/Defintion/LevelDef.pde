class LevelDef {
  final static int TILE_WIDTH = 50;
  final static int TILE_HEIGHT = 50;

  final static int WALL = 1;
  final static int START = -99;

  final static PVector CAMERA_START = PVector(-350, -350);

  /* Door n's corresponding trigger will be -n */
  static int getTrigger(int door) {
    return -door;
  }
}
