'use strict';
if (process.argv[2] !== 'child') {
  const r = require('child_process').spawnSync(process.execPath, [__filename, 'child'],
    { env: { ...process.env, NODE_DEBUG: 'http2' }, encoding: 'utf8', timeout: 20000 });
  console.log('status', r.status, 'signal', r.signal);
  console.log(/TypeError|Cannot read/.test(r.stderr) ? 'CRASH' : 'OK');
  return;
}
const http2 = require('http2');
const server = http2.createServer();
server.on('session', (session) => {
  session.on('stream', (stream) => {
    stream.on('end', function() {
      this.respond({ ':status': 200 });
      this.write('foo');
      this.destroy();
    });
    stream.resume();
  });
});
server.listen(0, () => {
  const client = http2.connect(`http://localhost:${server.address().port}`);
  const stream = client.request({ ':method': 'POST' });
  stream.on('close', () => { client.close(); server.close(); });
  stream.resume();
  stream.end();
});
