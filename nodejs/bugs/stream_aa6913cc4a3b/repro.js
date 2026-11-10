if (!process.execArgv.includes('--experimental-stream-iter')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--no-warnings', '--experimental-stream-iter', __filename], { encoding: 'utf8' });
  process.stdout.write(r.stdout); process.stderr.write(r.stderr);
  process.exit(r.status);
}
const { Writable } = require('stream');
const { fromWritable } = require('stream/iter');
const w = new Writable({ write(c, e, cb) { cb(); } });
const a = fromWritable(w);
try { fromWritable(w, { backpressure: 'bogus' }); console.log('no throw'); }
catch (e) { console.log('throw', e.code); }
const b = fromWritable(w, { backpressure: 'unbounded' });
console.log('same adapter:', a === b);
