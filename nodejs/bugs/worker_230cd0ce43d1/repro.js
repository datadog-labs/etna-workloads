const { spawnSync } = require('child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--experimental-web-worker', __filename, 'child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout); process.stdout.write(r.stderr.split('\n').filter((l) => /^\w*Error|^(getter|null|func)/.test(l)).join('\n'));
  console.log('exit=' + r.status);
  return;
}
const worker = new Worker('data:text/javascript,');
function t(name, f) { try { console.log(name, f()); } catch (e) { console.log(name, 'throws', e.name); } }
let n = 0;
const ab = new ArrayBuffer(8);
t('getter', () => {
  const o = { get [Symbol.iterator]() { n++; return function* () { yield ab; }; } };
  worker.postMessage(null, o); return 'reads=' + n + ' detached=' + (ab.byteLength === 0);
});
t('null', () => {
  const b = new ArrayBuffer(8);
  worker.postMessage(null, { [Symbol.iterator]: null, transfer: [b] }); return 'detached=' + (b.byteLength === 0);
});
t('func', () => {
  const b = new ArrayBuffer(8);
  const f = function() {}; f[Symbol.iterator] = function* () { yield b; };
  worker.postMessage(null, f); return 'detached=' + (b.byteLength === 0);
});
worker.terminate();
