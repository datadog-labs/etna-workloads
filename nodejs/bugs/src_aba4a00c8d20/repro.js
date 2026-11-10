const { Worker, isMainThread } = require('worker_threads');
if (isMainThread) {
  if (!process.execArgv.includes('--expose-internals')) {
    const r = require('child_process').spawnSync(process.execPath,
      ['--expose-internals', __filename], { encoding: 'utf8' });
    process.stdout.write(r.stdout + r.stderr);
    process.exit(r.status);
  }
  const w = new Worker(`
    try { require('internal/options'); console.log('internal ok'); }
    catch (e) { console.log('failed:', e.code); }
  `, { eval: true, env: process.env });
  w.on('error', (e) => console.log('error', e.code));
} else {}
