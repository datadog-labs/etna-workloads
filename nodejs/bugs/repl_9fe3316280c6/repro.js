'use strict';
const repl = require('repl');
const { PassThrough } = require('stream');
const input = new PassThrough();
const output = new PassThrough();
let out = '';
output.on('data', (d) => { out += d; });
process.on('uncaughtException', (e) => { console.log('uncaught:', e.code || e.message); });
let release;
const gate = new Promise((r) => { release = r; });
const s = repl.start({
  input, output, terminal: false,
  eval(cmd, ctx, file, cb) {
    gate.then(() => { cb(new Error('eval failed')); });
  },
});
s.write('\n');
s.close();
release();
setTimeout(() => {
  console.log(/Uncaught Error: eval failed/.test(out) ? 'error printed' : 'no error printed');
}, 200);
