'use strict';
const { spawnSync } = require('child_process');
if (process.argv[2] === 'child') {
  const { internalBinding } = require('internal/test/binding');
  internalBinding('process_methods').causeSegfault();
} else {
  const c = spawnSync(process.execPath, ['--expose-internals', __filename, 'child'],
                      { stdio: 'ignore', timeout: 5000 });
  const crashed = ['SIGSEGV', 'SIGILL', 'SIGTRAP', 'SIGBUS'].includes(c.signal);
  console.log('crashed with hard signal:', crashed);
  process.exitCode = crashed ? 0 : 1;
}
