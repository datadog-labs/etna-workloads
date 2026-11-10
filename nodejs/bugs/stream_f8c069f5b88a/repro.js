const { Readable } = require('stream');
const r = new Readable({ read() {} });
const size = 16 * 1024 * 1024;
r.push(Buffer.alloc(size));
r.push(null);
r.on('end', () => console.log('end'));
r.once('readable', () => {
  const b = r.read(size);
  console.log('got', b === null ? null : b.length, 'hwm', r.readableHighWaterMark);
});
