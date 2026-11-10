const { Readable, Writable } = require('stream');
process.on('uncaughtException', (e) => { console.log('uncaught:', e.code || e.message); });
const src = Readable.from([{ a: 1 }]);
const w = new Writable({ write(c, e, cb) { cb(); } });
w.on('error', (e) => console.log('dest error:', e.code));
src.pipe(w);
setTimeout(() => console.log('done'), 200);
