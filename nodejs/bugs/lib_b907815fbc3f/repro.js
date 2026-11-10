'use strict';
const { spawnSync } = require('child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--expose-internals', '--permission', '--allow-fs-read=*', __filename, 'child'],
    { encoding: 'utf8', env: { ...process.env, TERM: 'xterm' }, timeout: 20000 });
  console.log('status', r.status);
  console.log(r.stdout);
  console.log(r.stderr.split('\n').filter((l) => /^\w*Error|ERR_|code:/.test(l)).join('\n'));
  return;
}
const stream = require('stream');
const REPL = require('internal/repl');
class AS extends stream.Stream {
  run(data) {
    const it = data[Symbol.iterator]();
    const go = () => {
      const n = it.next();
      if (n.done) { this.emit('keypress', '', { ctrl: true, name: 'd' }); return; }
      if (typeof n.value === 'object') this.emit('keypress', '', n.value);
      else this.emit('data', `${n.value}`);
      setImmediate(go);
    };
    go();
  }
  resume() {}
  pause() {}
}
AS.prototype.readable = true;
REPL.createInternalRepl({}, {
  input: new AS(),
  output: new stream.Writable({ write(c, _, next) { next(); } }),
  allowBlockingCompletions: true,
  prompt: '> ', useColors: false, terminal: true,
}, (err, repl) => {
  if (err) throw err;
  repl.once('close', () => console.log('closed cleanly'));
  repl.input.run(['f', { name: 'tab' }, { name: 'enter' }]);
});
