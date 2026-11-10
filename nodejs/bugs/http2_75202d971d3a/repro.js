'use strict';
const http2 = require('http2');
const tls = require('tls');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { execFileSync } = require('child_process');

const d = fs.mkdtempSync(path.join(os.tmpdir(), 'h2r-'));
execFileSync('openssl', ['req', '-x509', '-newkey', 'rsa:2048', '-nodes', '-keyout',
  path.join(d, 'k.pem'), '-out', path.join(d, 'c.pem'), '-days', '2', '-subj', '/CN=localhost'],
  { stdio: 'ignore' });
const key = fs.readFileSync(path.join(d, 'k.pem'));
const cert = fs.readFileSync(path.join(d, 'c.pem'));
fs.rmSync(d, { recursive: true, force: true });

const server = http2.createSecureServer({ key, cert }, (req, res) => res.end());
const timer = setTimeout(() => {
  console.log('TIMEOUT: remoteSettings never received');
  process.exit(1);
}, 5000);

server.listen(0, '127.0.0.1', () => {
  const options = { ALPNProtocols: ['h2'], host: '127.0.0.1', servername: 'localhost',
    port: server.address().port, rejectUnauthorized: false };
  const socket = tls.connect(options, () => {
    socket.once('readable', () => {
      const client = http2.connect('https://localhost:' + options.port,
        { ...options, createConnection: () => socket });
      client.once('remoteSettings', () => {
        console.log('remoteSettings received');
        client.close();
        server.close();
        clearTimeout(timer);
      });
      client.on('error', (e) => console.log('error', e.code));
    });
  });
});
