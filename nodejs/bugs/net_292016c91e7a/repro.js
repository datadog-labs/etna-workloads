'use strict';
const net = require('net');
process.on('exit', (c) => console.log('exit', c));
const socket = net.connect({ port: 12345, host: 'localhost', autoSelectFamily: true });
socket.on('error', () => {});
socket.on('lookup', () => { socket.destroy(); });
setTimeout(() => console.log('done'), 500);
