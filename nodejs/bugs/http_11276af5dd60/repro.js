const { IncomingMessage } = require('http');
const { Readable } = require('stream');
const sock = new Readable({ highWaterMark: 1234, read() {} });
const msg = new IncomingMessage(sock);
console.log(msg.readableHighWaterMark);
