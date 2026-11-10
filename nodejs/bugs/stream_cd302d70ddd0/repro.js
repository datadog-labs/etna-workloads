'use strict';
const { Readable } = require('stream');
const buf = Buffer.alloc(8192);
let reads = 0, readables = 0, i = 0;
const r = new Readable({
  highWaterMark: 16 * 1024,
  read() { reads++; this.push(buf); },
});
r.on('readable', () => {
  readables++;
  if (i++ === 10) { r.removeAllListeners('readable'); return; }
  r.read();
});
setTimeout(() => console.log(`reads=${reads} readables=${readables}`), 200);
