'use strict';
const http = require('http');
const agent = new http.Agent({ keepAlive: true });
const server = http.createServer((req, res) => res.end('x'));
process.on('uncaughtException', (e) => {
  console.log('uncaught:', e.message);
  agent.destroy(); server.close();
});
server.listen(0, '127.0.0.1', () => {
  const controller = new AbortController();
  const req = http.get({ port: server.address().port, host: '127.0.0.1', agent,
    signal: controller.signal }, async (res) => {
    for await (const chunk of res) {
      controller.abort(new Error('stop reading'));
      break;
    }
    const res2 = await new Promise((resolve, reject) => {
      http.get({ port: server.address().port, host: '127.0.0.1', agent }, resolve)
        .on('error', reject);
    });
    let body = '';
    for await (const c of res2) body += c;
    console.log('second body:', body);
    agent.destroy(); server.close();
  });
  req.on('error', () => console.log('req error'));
});
