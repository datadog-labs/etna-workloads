'use strict';
const repl = require('repl');
const { PassThrough } = require('stream');
const input = new PassThrough();
const output = new PassThrough();
const r = repl.start({ input, output, terminal: false, prompt: '' });
r.eval('globalThis.counter = 0;', r.context, '', () => {});
r.eval('function incCounter() { return counter++; }', r.context, '', () => {});
const codes = ['incCounter().', 'a=(counter+=1).foo.', 'a=(counter++).foo.', 'for((counter)of[1])foo.'];
let i = 0;
function next() {
  if (i === codes.length) { r.close(); return; }
  const c = codes[i++];
  r.complete(c, () => {
    setImmediate(() => {
      console.log(c, 'counter =', r.context.counter);
      next();
    });
  });
}
next();
