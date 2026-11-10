const net = require('net');
const server = net.createServer(() => {});
server.listen(0, () => {
  const s = net.connect(server.address().port);
  s.on('error', () => {});
  s.write('hello', (err) => {
    console.log('write cb called', err && err.code);
    server.close();
  });
  s.destroy();
});
setTimeout(() => { console.log('timeout: cb never called'); process.exit(1); }, 3000).unref();
process.on('exit', () => console.log('exit'));
