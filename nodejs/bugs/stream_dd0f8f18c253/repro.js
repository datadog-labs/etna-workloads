const { Readable, Writable } = require('stream');
const w = new Writable({
  write(buf, enc, cb) { process.nextTick(cb); },
  highWaterMark: 1,
});
while (w.write('asd'));
console.log('needDrain', w.writableNeedDrain);
const r = new Readable({ read() { this.push('asd'); this.push(null); } });
let pauses = 0;
r.on('pause', () => pauses++);
r.on('end', () => console.log('pauses', pauses));
r.pipe(w);
