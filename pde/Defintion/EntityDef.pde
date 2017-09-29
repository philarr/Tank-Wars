class EntityDef {
  final static String NAME = "Entity";
}

class UnitDef {
  final static String NAME = "Unit";
  final static float FRICTION = 0.8;
}

class PlayerDef {
  final static String NAME = "Player";
  final static int WIDTH = 50;
  final static int HEIGHT = 50;
  final static String ASSET_BASE = "tank";
  final static String ASSET_TURRET = "tank_turret";
}

class EnemyDef {
  final static String NAME = "Enemy";
  final static int WIDTH = 50;
  final static int HEIGHT = 50;
  final static int HEALTH = 100;
  final static int WEAPON = 2;
  final static int DAMAGE = 10;
  final static String ASSET_BASE = "enemy";
  final static String ASSET_TURRET = "enemy_turret";
}

class BossDef {
  final static String NAME = "Boss";
  final static int WIDTH = 100;
  final static int HEIGHT = 100;
  final static int HEALTH = 2000;
  final static int AGGRO_RADIUS = 400;
  final static int RELOAD = 40;
  final static int WEAPON = 2;
  final static String ASSET_BASE = "boss";
  final static String ASSET_TURRET = "boss_turret";
}

class OnlineEntityDef {
  final static int WIDTH = 50;
  final static int HEIGHT = 50;
}

class DoorDef {
  final static String NAME = "Door";
  final static int WIDTH = 50;
  final static int HEIGHT = 50;
  final static int SLIDE_UP = 0;
  final static int SLIDE_DOWN = 1;
  final static int SLIDE_LEFT = 2;
  final static int SLIDE_RIGHT = 3;
  final static String ASSET_BASE = "door";
}

class TriggerDef {
  final static String NAME = "Trigger";
  final static int WIDTH = 30;
  final static int HEIGHT = 30;
  final static String ASSET_BASE = "trigger";
}

class PortalDef {
  final static String NAME = "Portal";
  final static int WIDTH = 50;
  final static int HEIGHT = 50;
}

class CubeDef {
  final static String NAME = "Cube";
  final static int WIDTH = 50;
  final static int HEIGHT = 50;
  final static String ASSET_BASE = "block";
}

class WallDef {
  final static String NAME = "Wall";
  final static int WIDTH = 50;
  final static int HEIGHT = 50;
  final static String ASSET_BASE = "wall";
}

class WidgetDef {
  final static String NAME = "Widget";
}

class ProjectileDef {
  final static String NAME = "Projectile";
}