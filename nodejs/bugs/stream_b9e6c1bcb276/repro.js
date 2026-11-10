'use strict';
const stream = require('stream');
let n = 0;
const r = new stream.Readable({
  highWaterMark: 16,
  read() {
    setImmediate(() => this.push(n++ < 20 ? Buffer.alloc(16) : null));
  },
});
const t = new stream.Transform({
  highWaterMark: 1,
  transform(chunk, enc, cb) {
    r.unpipe();
    r.resume();
    setImmediate(cb);
  },
});
r.on('end', () => console.log('end'));
r.pipe(t).resume();
setTimeout(() => {
  console.log('ended:', r.readableEnded, 'flowing:', r.readableFlowing);
  process.exit(0);
}, 1000);
