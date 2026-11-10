if (!process.argv.includes('child')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--no-warnings', '--experimental-stream-iter', __filename, 'child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout + r.stderr);
  process.exit(r.status);
}
const { pull, pullSync, from, fromSync, bytes, bytesSync } = require('stream/iter');
const first = (c) => (c === null ? null : new Uint8Array([65]));
let a = null;
const second = (c) => { if (c !== null) a = Array.isArray(c); return c; };
let s = null;
const second2 = (c) => { if (c !== null) s = Array.isArray(c); return c; };
(async () => {
  const d = await bytes(pull(from('x'), first, second));
  console.log('async batch:', a, Array.from(d));
  const e = bytesSync(pullSync(fromSync('x'), first, second2));
  console.log('sync batch:', s, Array.from(e));
})();
