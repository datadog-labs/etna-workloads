const { Readable } = require('stream');
const r = new Readable({ read() {} });
const f = () => {};
r.on('readable', f);
r.removeListener('readable', f);
process.nextTick(() => {
  console.log('readableFlowing:', r.readableFlowing);
  const r2 = new Readable({ read() {} });
  r2.on('data', f);
  r2.removeListener('data', f);
  r2.pause();
  r2.on('readable', f);
  r2.removeListener('readable', f);
  setImmediate(() => console.log('r2 flowing:', r2.readableFlowing));
});
