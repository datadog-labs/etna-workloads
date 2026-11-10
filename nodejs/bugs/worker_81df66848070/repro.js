const { spawnSync } = require('child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--expose-internals', '--no-warnings', __filename, 'child'], { encoding: 'utf8' });
  console.log('status', r.status, 'signal', r.signal);
  console.log(r.stdout.trim());
  process.exit(0);
}
const { markTransferMode, kTransfer, kTransferList } = require('internal/worker/js_transferable');
const { MessageChannel } = require('worker_threads');
class Outer {
  constructor() {
    markTransferMode(this, false, true);
    const c = new MessageChannel();
    this.inner = c.port1;
    c.port2.postMessage(this.inner, [this.inner]);
  }
  [kTransferList] = () => [this.inner];
  [kTransfer] = () => ({ data: { inner: this.inner }, deserializeInfo: 'does-not:matter' });
}
const { port1 } = new MessageChannel();
const ot = new Outer();
try { port1.postMessage(ot, [ot]); console.log('no throw'); }
catch (e) { console.log('threw', e.name); }
