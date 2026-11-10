const cp = require('child_process');
const tests = {
  spawn_file: () => cp.spawnSync('echo\0x'),
  spawn_args: () => cp.spawnSync('echo', ['a\0b']),
  spawn_argv0: () => cp.spawnSync('echo', [], { argv0: 'a\0b' }),
  spawn_env: () => cp.spawnSync('echo', [], { env: { A: 'a\0b' } }),
  exec: () => cp.execSync('echo a\0b'),
  fork: () => cp.fork('x.js', { execArgv: ['a\0b'], stdio: 'ignore' }),
};
for (const [k, f] of Object.entries(tests)) {
  try { const r = f(); console.log(k, 'no throw', r && r.error ? r.error.code : ''); }
  catch (e) { console.log(k, e.code); }
}
