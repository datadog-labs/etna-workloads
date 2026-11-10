const { Readable } = require('stream');
let count = 5, reads = 0, data = 0;
const r = new Readable({
  read() {
    reads++;
    process.nextTick(() => { if (count--) r.push('a'); else r.push(null); });
  },
  highWaterMark: 0,
});
r.on('end', () => console.log('end'));
r.on('data', () => data++);
process.on('exit', () => console.log('reads', reads, 'data', data));
