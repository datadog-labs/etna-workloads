const stream = require('stream');
const r = new stream.Readable({
  read() { this.push('content'); this.push(null); }
});
const t = new stream.Transform({
  transform(chunk, enc, cb) { this.push(chunk); cb(); },
  flush(cb) { cb(); }
});
let n = 0;
r.pipe(t);
t.on('readable', () => {
  n++;
  while (t.read() !== null);
});
t.on('end', () => console.log('end'));
t.resume;
setTimeout(() => console.log('readable events:', n), 200);
