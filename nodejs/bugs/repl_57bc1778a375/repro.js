'use strict';
const repl = require('repl');
const { PassThrough } = require('stream');
const s = repl.start({ input: new PassThrough(), output: new PassThrough(), terminal: false });
const inputs = ['delete globalThis._', 'delete globalThis', 'typeof globalThis', 'void globalThis'];
let i = 0;
(function next() {
  if (i === inputs.length) { s.close(); return; }
  const inp = inputs[i++];
  s.complete(inp, (err, res) => {
    console.log(JSON.stringify(inp), err ? 'err' : JSON.stringify(res[1]));
    next();
  });
})();
