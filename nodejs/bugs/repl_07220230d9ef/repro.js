const repl = require('repl');
const { PassThrough } = require('stream');
const r = repl.start({ input: new PassThrough(), output: new PassThrough(), terminal: false });
r.context.obj = { foo: 1, fab: 2 };
r.context.key = 'foo';
const tests = ['obj["foo"].toS', 'obj[key].toS', 'obj[`fo`].toS', 'obj["foo"].constr', 'obj.f'];
let i = 0;
(function next() {
  if (i >= tests.length) { r.close(); return; }
  const t = tests[i++];
  r.complete(t, (err, res) => {
    console.log(JSON.stringify(t), JSON.stringify(res));
    next();
  });
})();
