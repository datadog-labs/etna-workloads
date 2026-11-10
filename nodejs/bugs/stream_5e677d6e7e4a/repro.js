const { Readable, PassThrough, Duplex } = require('stream');
const c = Readable.from(['a']).compose(new PassThrough());
console.log(typeof c.write, c instanceof Duplex, c.writable);
