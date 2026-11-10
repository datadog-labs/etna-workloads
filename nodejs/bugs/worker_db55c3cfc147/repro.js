'use strict';
const { MessageChannel } = require('worker_threads');
const obj = [
  [ new SharedArrayBuffer(0), new SharedArrayBuffer(1) ],
  [ new SharedArrayBuffer(2), new SharedArrayBuffer(3) ],
];
const { port1, port2 } = new MessageChannel();
port1.once('message', (m) => {
  console.log(m.map((p) => p.map((b) => b.byteLength)).join('|'));
  port1.close();
});
port2.postMessage(obj);
