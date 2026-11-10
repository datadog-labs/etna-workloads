const { spawnSync } = require('child_process');
const r = spawnSync(process.execPath, ['--use-bundled-ca', '-e', 'require("tls").getCACertificates("default")'],
  { env: { ...process.env, NODE_DEBUG_NATIVE: 'crypto' }, encoding: 'utf8' });
console.log('bundled off-thread:', /Started loading bundled root certificates off-thread/.test(r.stderr));
console.log('exit', r.status);
