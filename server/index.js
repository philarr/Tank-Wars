const http = require('http').createServer();

const options = {
  pingInterval: 2500,
  transports: ['websocket'],
  wsEngine: 'uws'
};

const io = require('socket.io')(3000, options);

io.on('connection', (socket) => {
  console.log('a user connected');
});
