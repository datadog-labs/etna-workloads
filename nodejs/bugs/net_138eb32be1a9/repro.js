const net = require('net');
const server = net.createServer((s) => { s.end(Buffer.alloc(1024)); }).listen(0, () => {
  const socket = net.connect(server.address().port);
  socket.resume();
  socket.on('end', () => {
    console.log('end: destroyed =', socket.destroyed);
  });
  socket.end('asd');
  socket.on('close', () => { console.log('close'); server.close(); });
});
