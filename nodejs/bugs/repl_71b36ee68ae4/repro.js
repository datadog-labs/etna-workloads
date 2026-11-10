// Run with --expose-internals via re-spawn
if (!process.execArgv.includes('--expose-internals')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--expose-internals', __filename], { encoding: 'utf8' });
  process.stdout.write(r.stdout); process.stderr.write(r.stderr);
  process.exit(r.status);
}
const fs = require('fs'), path = require('path'), os = require('os');
const { ReplHistory } = require('internal/repl/history');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'rh-'));
const historyPath = path.join(dir, '.node_repl_history');
fs.writeFileSync(historyPath, 'dummy\n');
const originalOpen = fs.promises.open;
let closeCalled = false;
fs.promises.open = async (p, flags, mode) => {
  const handle = await originalOpen(p, flags, mode);
  if (flags === 'r+' && p === historyPath) {
    handle.truncate = async () => { throw new Error('Mock truncate error'); };
    const oc = handle.close;
    handle.close = async () => { closeCalled = true; return oc.call(handle); };
  }
  return handle;
};
const noop = () => {};
const context = { historySize: 30, on: noop, once: noop, emit: noop, pause: noop,
  resume: noop, off: noop, line: '', _historyPrev: noop, _writeToOutput: noop };
const history = new ReplHistory(context, { filePath: historyPath });
history.initialize((err) => {
  console.log('err:', err, 'closeCalled:', closeCalled);
  fs.rmSync(dir, { recursive: true, force: true });
  process.exit(0);
});
