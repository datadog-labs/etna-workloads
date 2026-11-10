const { Readable } = require('stream');
let calls = 0;
const r = new Readable({ read() { calls++; }, highWaterMark: 100 });
for (let i = 0; i < 10; i++) r.push('a'.repeat(200));
r.resume();
r.once('data', () => r.pause());
setImmediate(() => { console.log('_read calls:', calls); });
