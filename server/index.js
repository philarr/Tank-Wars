const io = require('socket.io');
const http = require('http').createServer();

const options = {
  pingInterval: 2500,
  transports: ['websocket'],
  wsEngine: 'uws'
};

const app = io(3000, options);

app.on('connection', (socket) => {
  console.log('a user connected');
});
