const { Readable, Writable } = require('stream');
const r = new Readable();
console.log(r.eventNames());
r.on('foo', () => {});
console.log(r.eventNames());
const w = new Writable();
console.log(w.eventNames());
