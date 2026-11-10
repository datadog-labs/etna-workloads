const { Readable } = require('stream');
let reads = 0;
const r = new Readable({
  construct(cb) { setImmediate(cb); },
  read() { reads++; this.push('x'); },
});
setTimeout(() => {
  console.log('reads before consumer:', reads);
  console.log('readableLength:', r.readableLength);
}, 100);
