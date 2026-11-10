const { Readable } = require('stream');
process.on('uncaughtException', (e) => { console.log('uncaught', e.code); });
const r = Readable.from([]);
r.on('close', () => reader.cancel());
const reader = Readable.toWeb(r).getReader();
reader.read();
setTimeout(() => console.log('done'), 200);
