'use strict';
const tls = require('tls');
let out = 'none';
process.on('uncaughtException', (e) => { out = 'uncaught ' + e.code; finish(); });
const server = tls.createServer({
  ciphers: 'PSK+HIGH',
  pskCallback: () => 'invalid',
  pskIdentityHint: 'h',
});
server.on('tlsClientError', (e, s) => { out = 'tlsClientError ' + e.code; s.destroy(); finish(); });
let done = false;
function finish() {
  if (done) return; done = true;
  console.log(out);
  process.exit(0);
}
setTimeout(() => { out = 'timeout'; finish(); }, 8000);
server.listen(0, () => {
  const c = tls.connect({ port: server.address().port, host: '127.0.0.1', ciphers: 'PSK+HIGH',
    checkServerIdentity() {}, pskCallback: () => ({ psk: Buffer.alloc(32), identity: 'x' }) });
  c.on('error', () => {});
});
