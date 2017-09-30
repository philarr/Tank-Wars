const path = require("path");
const io = require('socket.io');
const http = require('http').createServer();
const fs = require("fs");
const Canvas = require("canvas");
const Processing = require("../lib/processing");

global.Quadtree = require("quadtree-lib");

// Bare minimum files to run client logic on server
const pde = [
  'pde/Server.pde',
  'pde/Defintion/LevelDef.pde',
  'pde/Defintion/EntityDef.pde',

  'pde/Camera.pde',
  'pde/Level.pde',
  'pde/Map.pde',
  'pde/State/State.pde',
  'pde/State/Bare.pde',
  // Entity
  'pde/Entity/Entity.pde',
  // Entity > Unit
  'pde/Entity/Unit/Unit.pde',
  'pde/Entity/Unit/Player.pde',
  'pde/Entity/Unit/Projectile.pde',
  'pde/Entity/Unit/Cube.pde',
  'pde/Entity/Unit/Enemy/Enemy.pde',
  'pde/Entity/Unit/Enemy/Boss.pde',
  // Entity > Widget
  'pde/Entity/Widget/Widget.pde',
  'pde/Entity/Widget/Wall.pde',
  'pde/Entity/Widget/Door.pde',
  'pde/Entity/Widget/Portal.pde',
  'pde/Entity/Widget/Trigger.pde'
];

function loadStateFiles() {
  return pde.map((file) => {
    return fs.readFileSync(path.join(__dirname, "..", file), 'utf8');
  }).join('');
}
const canvas = new Canvas(800, 600);
const state = new Processing(canvas, loadStateFiles(), startNetwork());

function startNetwork() {
  const app = io(3000, {
    pingInterval: 2500,
    transports: ['websocket'],
    wsEngine: 'uws'
  });

  return { socket: app };
}

