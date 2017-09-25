/*
  Using socket capability from outside of Processing sandbox.
  This game was created before the existence of p5.js and relies
  on processing.js to convert existing processing codebase to run
  on the browser.
  Reliance on ws from the browser means java applet is no longer supported.
*/
class Network {
  String serverUrl;
  Boolean connected = false;
  Boolean isStarted = false;
  int latency = 0;
  Socket socket;
  HUD hud;

  Network(serverUrl) {
    this.serverUrl = serverUrl;
  }

  void log(String msg) {
    system.log(msg);
  }

  void end() {
    if (!this.socket) return;
    this.connected = false;
    this.latency = null;
    this.socket.disconnect();
  }

  void getLatency() {
    return this.latency;
  }

  void isConnected() {
    return this.connected;
  }

  void initEventHandlers(Object socket) {
    self = this;

    socket.on('connect', function() {
      self.connected = true;
      self.log('Connected!');
    });

    socket.on('connect_error', function(error) {
      self.connected = false;
      self.latency = null;
      self.log('Connection error');
    });

    socket.on('pong', function(latency) {
      self.latency = latency;
      self.log(str(latency) + 'ms');
    });
  }

  void start() {
    if (this.isStarted) return;
    this.socket = external.get('socket');

    if (!this.socket) {
      this.log('Missing external socket library!');
      return;
    }
    this.isStarted = true;
    Object socket = this.socket(serverUrl, {
      transports: ['websocket']
    });

    this.initEventHandlers(socket);
  }
}
