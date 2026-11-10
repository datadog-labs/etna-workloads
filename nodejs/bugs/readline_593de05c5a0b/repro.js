const repl = require('repl');
const { PassThrough } = require('stream');
const input = new PassThrough();
const output = new PassThrough();
const r = repl.start({ input, output, terminal: true, prompt: '> ' });
try {
  r.write('.editor\n');
  r.write('a');
  r.write(null, { name: 'tab' });
  console.log('no throw');
} catch (e) {
  console.log('threw:', e.constructor.name);
}
r.close();
