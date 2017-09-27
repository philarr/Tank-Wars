class Lobby extends State {

  void setHandle(String name) {
    if (!name) return;
    network.setHandle(name);
  }

  void draw() { }

  void update() {
    draw();
  }
}
