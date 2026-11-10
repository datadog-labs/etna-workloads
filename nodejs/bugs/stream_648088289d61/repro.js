const { pipeline, Readable, Writable, PassThrough } = require('stream');
const w = new Writable({ write(c, e, cb) { cb(); } });
const p = new PassThrough();
const r = new Readable({ read() {} });
w.on('error', (e) => console.log('writable error:', e.message));
p.on('error', (e) => console.log('passthrough error:', e.message));
pipeline(r, p, w, (err) => {
  console.log('callback:', err && err.message);
  const r2 = new Readable({ read() {} });
  const p2 = new PassThrough();
  pipeline(r2, p2, (e) => console.log('cb2:', e && e.message));
  (async () => {
    try { for await (const _ of p2); console.log('iteration resolved'); }
    catch (e) { console.log('iteration rejected:', e.message); }
  })();
  setImmediate(() => r2.destroy(new Error('boom2')));
});
setImmediate(() => r.destroy(new Error('boom')));
