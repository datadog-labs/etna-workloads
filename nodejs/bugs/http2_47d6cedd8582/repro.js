'use strict';
const h2 = require('http2');
const tls = require('tls');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { execFileSync } = require('child_process');

const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'h2repro-'));
execFileSync('openssl', ['req', '-x509', '-newkey', 'rsa:2048', '-nodes', '-keyout',
  path.join(dir, 'k.pem'), '-out', path.join(dir, 'c.pem'), '-subj', '/CN=localhost',
  '-days', '2'], { stdio: 'ignore' });

const server = h2.createSecureServer({
  key: fs.readFileSync(path.join(dir, 'k.pem')),
  cert: fs.readFileSync(path.join(dir, 'c.pem')),
  unknownProtocolTimeout: 500,
  allowHalfOpen: true,
});
server.on('secureConnection', (socket) => {
  socket.on('close', () => {
    console.log('server socket destroyed after timeout');
    fs.rmSync(dir, { recursive: true, force: true });
    process.exit(0);
  });
});
server.listen(0, () => {
  tls.connect({ port: server.address().port, rejectUnauthorized: false });
  setTimeout(() => {
    console.log('server socket still open (no unknownProtocolTimeout)');
    fs.rmSync(dir, { recursive: true, force: true });
    process.exit(1);
  }, 4000);
});
