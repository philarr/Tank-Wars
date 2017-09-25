 /****************
 Tank Wars
 by Philip Chung (301097069)
 *****************/
int __WIDTH__ = 800;
int __HEIGHT__ = 600;

HashMap<String, Object> external = new HashMap<String, Object>();
Asset asset;
Game game;
Input input;
Network network;
SystemHUD system;

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
  game.start();
}

void draw() {
  game.update();
  system.update();
}

void keyPressed() {
  input.keyDown();
  game.keyDown();
}

void keyReleased() {
  input.keyUp();
  game.keyUp();
}
