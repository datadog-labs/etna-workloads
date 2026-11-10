'use strict';
const net = require('net');
const tls = require('tls');
const h2 = require('http2');
const { execFileSync } = require('child_process');
const fs = require('fs'), os = require('os'), path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
execFileSync('openssl', ['req', '-x509', '-newkey', 'rsa:2048', '-nodes', '-keyout', dir + '/k.pem',
  '-out', dir + '/c.pem', '-subj', '/CN=localhost', '-days', '2'], { stdio: 'ignore' });
const tlsOptions = { key: fs.readFileSync(dir + '/k.pem'), cert: fs.readFileSync(dir + '/c.pem'), ALPNProtocols: ['h2'] };
fs.rmSync(dir, { recursive: true });
process.on('uncaughtException', (e) => { console.log('uncaught exception'); process.exit(1); });
const netServer = net.createServer((socket) => { socket.allowHalfOpen = false; h2Server.emit('connection', socket); });
const h2Server = h2.createSecureServer(tlsOptions, (req, res) => { res.writeHead(200); res.end(); });
h2Server.on('connect', (req, res) => { res.writeHead(200, {}); netServer.emit('connection', res.stream); });
netServer.listen(0, () => {
  const proxyClient = h2.connect(`https://localhost:${netServer.address().port}`, { rejectUnauthorized: false });
  const proxyReq = proxyClient.request({ ':method': 'CONNECT', ':authority': 'example.com:443' });
  proxyReq.on('response', () => {
    const tlsSocket = tls.connect({ socket: proxyReq, ALPNProtocols: ['h2'], rejectUnauthorized: false });
    tlsSocket.on('error', () => {});
    proxyReq.on('close', () => { console.log('closed cleanly'); proxyClient.close(); netServer.close(); });
    tlsSocket.destroy();
  });
});
