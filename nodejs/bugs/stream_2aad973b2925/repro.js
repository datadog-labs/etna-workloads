'use strict';
const { PassThrough, Writable, finished } = require('stream');
const source = new PassThrough({ highWaterMark: 16 * 1024 });
const failing = new Writable({
  highWaterMark: 16 * 1024,
  write(chunk, enc, cb) { cb(new Error('boom')); },
});
failing.on('error', () => {});
let received = 0;
const healthy = new Writable({
  highWaterMark: 16 * 1024,
  write(chunk, enc, cb) { received += chunk.length; cb(); },
});
source.pipe(failing);
source.pipe(healthy);
const chunk = Buffer.alloc(20000, 'a');
source.write(chunk);
source.write(chunk);
source.end();
finished(healthy, () => { console.log('healthy finished, received', received); });
setTimeout(() => { console.log('final received', received, 'expected', chunk.length * 2); }, 1000).unref();
process.on('exit', () => console.log('exit received', received));
