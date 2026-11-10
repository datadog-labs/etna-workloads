const { Readable } = require('stream');
async function* gen() {
  try { yield 1; yield 2; yield 3; }
  finally { console.log('iterator closed'); }
}
const r = Readable.from(gen());
r.once('data', (v) => {
  console.log('got', v);
  r.destroy();
});
r.on('close', () => setImmediate(() => console.log('readable closed')));
