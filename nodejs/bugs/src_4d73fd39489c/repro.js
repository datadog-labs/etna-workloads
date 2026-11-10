// Worker A starts a nested worker B and calls process.exit() shortly after.
// Native SetImmediate callbacks queued in A's Environment (e.g. the one that
// joins B's thread) must run during Environment cleanup. Without that, the
// process deadlocks on exit.
const { Worker, isMainThread, workerData } = require('worker_threads');
const { spawnSync } = require('child_process');

if (process.env.REPRO_CHILD !== '1') {
  const r = spawnSync(process.execPath, [__filename], {
    env: { ...process.env, REPRO_CHILD: '1' },
    timeout: 10000,
    killSignal: 'SIGKILL',
    encoding: 'utf8',
  });
  if (r.error && r.error.code === 'ETIMEDOUT') {
    console.log('child hung on exit');
    process.exitCode = 1;
  } else {
    console.log('child finished, status', r.status);
    process.stdout.write(r.stdout);
  }
} else if (isMainThread) {
  const w = new Worker(__filename, { workerData: 'A' });
  w.on('exit', (code) => console.log('A exited', code));
} else if (workerData === 'A') {
  const b = new Worker(__filename, { workerData: 'B' });
  b.on('error', () => {});
  b.on('exit', () => {});
  setTimeout(() => process.exit(0), 20);
}
