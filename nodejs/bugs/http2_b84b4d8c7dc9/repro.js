const http2 = require('http2');
const server = http2.createServer({ maxSessionMemory: 1 });
server.on('stream', (s) => { s.respond(); s.end(); });
server.listen(0, () => {
  const client = http2.connect(`http://localhost:${server.address().port}`, { maxSessionMemory: 1 });
  client.on('error', (e) => { console.log('client error', e.code); server.close(); });
  let i = 0;
  const next = () => {
    if (i++ >= 1000) { console.log('done'); client.close(); server.close(); return; }
    const s = client.request({ ':method': 'POST', 'content-length': 8192 });
    s.on('error', (e) => { console.log('stream error', e.code); client.destroy(); server.close(); });
    s.on('response', () => next());
    s.resume();
    s.end('a'.repeat(8192));
  };
  next();
});
setTimeout(() => { console.log('timeout'); process.exit(2); }, 20000).unref();
