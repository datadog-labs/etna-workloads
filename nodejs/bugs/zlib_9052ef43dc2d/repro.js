'use strict';
const zlib = require('zlib');
const comp = zlib.gzipSync(Buffer.alloc(512 * 1024 * 1024), { level: 9 });
const d = zlib.createGunzip();
d.end(comp);
setTimeout(() => {
  const n = d._readableState.buffer.length;
  console.log(n <= 16 ? 'backpressure respected' : 'unbounded buffering');
  process.exit(n <= 16 ? 0 : 1);
}, 1500);
