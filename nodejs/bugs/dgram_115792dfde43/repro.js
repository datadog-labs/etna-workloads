const dgram = require('dgram');
const a = dgram.createSocket('udp4');
a.bind(0, '127.0.0.1', () => {
  const port = a.address().port;
  const b = dgram.createSocket('udp4');
  let n = 0;
  b.on('error', () => {
    if (++n < 5) return b.bind(port, '127.0.0.1', () => {});
    console.log('listening listeners:', b.listenerCount('listening'));
    b.close(); a.close();
  });
  b.bind(port, '127.0.0.1', () => {});
});
