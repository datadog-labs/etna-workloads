const { Duplex } = require('stream');
const a = new Duplex({ writableObjectMode: true, read() {}, write(c, e, cb) { cb(); } });
console.log('writableObjectMode', a.writableObjectMode);
console.log('readableObjectMode', a.readableObjectMode);
const b = new Duplex({ objectMode: true, read() {}, write(c, e, cb) { cb(); } });
console.log('objectMode', b.writableObjectMode, b.readableObjectMode);
