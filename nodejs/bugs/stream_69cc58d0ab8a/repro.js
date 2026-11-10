const { Readable } = require('stream');
const s = new Readable({
  objectMode: true,
  highWaterMark: 1,
  read() {
    if (!this.first) { this.push('hello'); this.first = true; return; }
    this.push(null);
  }
});
const l = () => console.log('readable fired');
s.on('readable', l);
s.on('end', () => console.log('end'));
s.removeListener('readable', l);
s.resume();
process.on('exit', () => console.log('exit flowing=' + s.readableFlowing));
