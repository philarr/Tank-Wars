HashMap<String, Object> external = new HashMap<String, Object>();
int __WIDTH__ = 800;
int __HEIGHT__ = 600;

boolean __SERVER__ = true;

void addLibrary(String name, Object instance) {
  external.put(name, instance);
}

class Asset {
  // noop
  void get(String string) {}
}

Asset asset = new Asset();
Bare bareClient;

void setup() {
  size(800, 600);
  addLibrary("Quadtree", global.Quadtree);
  bareClient = new Bare(this.socket);
  bareClient.start();
}

void draw() {
  bareClient.update();
}



