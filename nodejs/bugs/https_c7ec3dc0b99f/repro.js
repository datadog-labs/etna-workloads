'use strict';
const https = require('https');
const { execFileSync } = require('child_process');
const fs = require('fs'), os = require('os'), path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
const k = path.join(d, 'k.pem'), c = path.join(d, 'c.pem');
execFileSync('openssl', ['req','-x509','-newkey','rsa:2048','-nodes','-keyout',k,'-out',c,'-days','2','-subj','/CN=agent1'],{stdio:'ignore'});
const cert = fs.readFileSync(c), key = fs.readFileSync(k);
const server = https.createServer({ key, cert, minVersion:'TLSv1.2', maxVersion:'TLSv1.2' }, (q, r) => r.end('ok'));
function req(port, agent, checkServerIdentity) {
  return new Promise((resolve) => {
    https.get({ host:'127.0.0.1', port, servername:'agent1', ca:[cert], agent, checkServerIdentity }, (res) => {
      res.resume(); res.on('end', () => resolve('ok'));
    }).on('error', (e) => resolve('error: ' + e.message));
  });
}
server.listen(0, async () => {
  const port = server.address().port;
  const agent = new https.Agent();
  console.log('accept:', await req(port, agent, () => {}));
  console.log('reject:', await req(port, agent, () => new Error('rejected by callback')));
  agent.destroy(); server.close();
  fs.rmSync(d, { recursive: true, force: true });
});
