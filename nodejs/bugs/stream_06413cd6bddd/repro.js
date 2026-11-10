'use strict';
const { Utf8Stream } = require('node:fs');
const chunks = [];
const fsOverride = {
  write(fd, data, enc, cb) { chunks.push(data); process.nextTick(cb, null, Buffer.byteLength(data)); },
  writeSync() { throw new Error('no'); },
  fsync(fd, cb) { cb(); }, fsyncSync() {}, close(fd, cb) { cb(); },
  open(p, f, m, cb) { cb(null, 42); }, mkdir(p, o, cb) { cb(); }, mkdirSync() {},
};
const stream = new Utf8Stream({ fd: 42, sync: false, minLength: 0, maxWrite: 1, fs: fsOverride });
stream.on('ready', () => {
  for (let i = 0; i < 3; i++) stream.write('€');
  setTimeout(() => {
    console.log('writes:', chunks.length, 'data:', chunks.join(''));
    stream.destroy();
  }, 200);
});
