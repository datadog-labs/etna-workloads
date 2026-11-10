'use strict';
const { Readable, Writable } = require('stream');
(async () => {
  const src = new Readable({ read() {} });
  src.push(Buffer.alloc(100));
  src.push(null);
  src.pause();
  await new Promise((r) => setImmediate(r));
  const dst = new Writable({
    highWaterMark: 1000,
    write(buf, enc, cb) { process.nextTick(cb); },
  });
  dst.write(Buffer.alloc(1000));
  dst.on('finish', () => console.log('finish'));
  src.pipe(dst);
  setTimeout(() => {
    console.log('done');
    process.exit(0);
  }, 500);
})();
