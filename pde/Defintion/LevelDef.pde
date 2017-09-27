class LevelDef {
  final static int WALL = 1;
  final static int START = -99;
  /* Door n's corresponding trigger will be n * -1 */
  static int getTrigger(int door) {
    return -door;
  }
}
