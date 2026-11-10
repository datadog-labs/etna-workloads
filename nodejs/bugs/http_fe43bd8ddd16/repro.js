const http = require('http');
const net = require('net');
function createConnection() {
  const socket = new net.Socket();
  process.nextTick(() => socket.destroy(new Error('Oops')));
  return socket;
}
process.on('exit', (c) => console.log('exit', c));
const req = http.get({ createConnection });
req.on('error', (e) => console.log('error', e.message));
req.abort();
class CA extends http.Agent {}
CA.prototype.createConnection = createConnection;
const r2 = http.get({ agent: new CA() });
r2.on('error', (e) => console.log('error2', e.message));
r2.abort();
