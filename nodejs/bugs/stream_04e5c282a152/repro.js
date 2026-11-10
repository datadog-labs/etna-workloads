const { Readable } = require('stream');
process.on('uncaughtException', (e) => { console.log('uncaught:', e.message); process.exit(1); });
(async () => {
  const r = new Readable({ objectMode: true, read() {} });
  r.push(undefined);
  r.push(1);
  r.push(null);
  const out = [];
  try {
    for await (const c of r) out.push(c);
  } catch (e) { console.log('caught:', e.message); }
  console.log(out);
})();
