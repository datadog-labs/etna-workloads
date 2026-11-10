const { IncomingMessage } = require('http');
const { Socket } = require('net');
const msg = new IncomingMessage(new Socket());
msg.on('error', () => {});
console.log(msg.destroy() === msg);
