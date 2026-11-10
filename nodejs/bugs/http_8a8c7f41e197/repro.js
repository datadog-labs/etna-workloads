const https = require('https');
const fs = require('fs');
const path = require('path');
const dir = path.join(process.cwd(), 'test/fixtures/keys');
let key, cert;
try { key = fs.readFileSync(dir + '/agent1-key.pem'); cert = fs.readFileSync(dir + '/agent1-cert.pem'); } catch {}
const { execFileSync } = require('child_process');
if (!key) {
  const os = require('os'); const d = fs.mkdtempSync(path.join(os.tmpdir(), 'k'));
  execFileSync('openssl', ['req','-x509','-newkey','rsa:2048','-nodes','-keyout',d+'/k.pem','-out',d+'/c.pem','-subj','/CN=localhost','-days','2'],{stdio:'ignore'});
  key = fs.readFileSync(d+'/k.pem'); cert = fs.readFileSync(d+'/c.pem');
}
const server = https.createServer({ key, cert, maxHeaderSize: 100 }, (req, res) => res.end('ok'));
console.log('server.maxHeaderSize =', server.maxHeaderSize);
server.on('clientError', (e, s) => { console.log('clientError', e.code); s.destroy(); });
server.listen(0, () => {
  const req = https.request({ port: server.address().port, rejectUnauthorized: false,
    headers: { x: 'A'.repeat(500) } }, (res) => {
    console.log('status', res.statusCode); res.resume(); res.on('end', () => server.close());
  });
  req.on('error', (e) => { console.log('client error', e.code); server.close(); });
  req.end();
});
