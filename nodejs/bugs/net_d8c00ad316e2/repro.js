'use strict';
const http = require('http');
const net = require('net');
const blockList = new net.BlockList();
blockList.addAddress('127.0.0.1');
const lookup = (_h, _o, cb) => cb(null, '127.0.0.1', 4);
process.on('uncaughtException', (e) => console.log('uncaught', e.code));
const req = http.request({
  host: 'example.com', port: 80, lookup, family: 4,
  createConnection: (o) => net.createConnection({ ...o, blockList }),
});
req.on('error', (e) => console.log('req error', e.code));
req.end();
