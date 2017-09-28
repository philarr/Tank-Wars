HashMap<String, Object> external = new HashMap<String, Object>();
int __WIDTH__ = 800;
int __HEIGHT__ = 600;

Asset asset;
Game game;
Input input;
Network network;
SystemHUD system;
Narrator narrator;
GameHUD hud;
Player player;

void addLibrary(String name, Object instance) {
  external.put(name, instance);
}

void setup() {
  size(800, 600);
  network = new Network('ws://localhost:3000');
  asset = new Asset();
  game = new Game();
  input = new Input();
  system = new SystemHUD();
  narrator = new Narrator();
  game.start();
}

void draw() {
  game.update();
  narrator.update();
  system.update();
}

void keyPressed() {
  input.keyDown();
  if (Input.isEnter()) return narrator.interceptEnter();
  game.keyDown();
}

void keyReleased() {
  input.keyUp();
  game.keyUp();
}
