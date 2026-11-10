'use strict';
const { Transform } = require('stream');
const t = new Transform({
  objectMode: true, highWaterMark: 0,
  transform(chunk, enc, cb) { process.nextTick(() => cb(null, chunk, enc)); },
});
console.log('write1', t.write(1));
let drained = false;
t.on('drain', () => {
  drained = true;
  console.log('drain; write2', t.write(2));
  t.end();
});
t.once('readable', () => {
  console.log('read', t.read());
  setImmediate(() => {
    console.log('read again', t.read());
    t.once('readable', () => console.log('read', t.read()));
  });
});
process.on('exit', () => console.log('drained', drained));
