class Bare extends State {
  int stage;
  Map map;

  Bare(Object socket) {
    this.stage = 1;
    this.camera = new Camera(0, 0);
    this.map = new Map(this);


  }


  void handleConnection(Object socket) {
    console.log("a user connected");
  };

  void handleInput(Object msg) {
    console.log(msg);
  }

  void start() {
    map.start();
  }

  void update() {
    map.update();
  }
}