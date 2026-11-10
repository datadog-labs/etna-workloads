const { request } = require('http');
const { Duplex } = require('stream');
let socket;
function createConnection() {
  socket = new Duplex({
    read() {},
    write(chunk, enc, cb) {
      if (chunk.toString().includes('\r\n\r\n'))
        this.push('HTTP/1.1 100 Continue\r\n\r\n');
      cb();
    },
  });
  return socket;
}
const req = request('http://localhost:8080', { createConnection });
req.on('information', ({ statusCode }) => {
  console.log('information', statusCode);
  socket.push('HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n');
  socket.push(null);
});
req.on('response', (res) => { console.log('response', res.statusCode); res.resume(); });
req.on('error', (e) => console.log('error', e.code));
req.end();
