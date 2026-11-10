'use strict';
const http2 = require('http2');
const net = require('net');
const log = [];
const server = http2.createServer();
let done = false;
function finish() {
  if (done) return; done = true;
  console.log(log.join('\n'));
  process.exit(0);
}
server.on('session', (session) => {
  session.on('error', (e) => log.push('session error: ' + e.code + ' ' + e.message));
  session.on('close', () => { log.push('session close'); server.close(); });
});
server.listen(0, () => {
  const conn = net.connect({ port: server.address().port, allowHalfOpen: true });
  conn.write('PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n');
  const s = Buffer.alloc(9); s[3] = 4; conn.write(s);
  let inbuf = Buffer.alloc(0), state = 0, len;
  conn.on('data', (chunk) => {
    inbuf = Buffer.concat([inbuf, chunk]);
    if (state === 0) {
      if (inbuf.length < 9) return;
      len = inbuf.readUIntBE(0, 3); inbuf = inbuf.subarray(9); state = 1;
    }
    if (state === 1) {
      if (inbuf.length < len) return;
      state = 2;
      const ack = Buffer.alloc(9); ack[3] = 4; ack[4] = 1; conn.write(ack);
      const o = Buffer.alloc(9);
      o.writeUIntBE(16385, 0, 3); o[3] = 1; o[4] = 4; o.writeUInt32BE(1, 5);
      conn.write(o);
    }
  });
  conn.on('end', () => { log.push('client end'); conn.end(); });
  conn.on('close', () => { log.push('client close'); setTimeout(finish, 200); });
  setTimeout(() => { log.push('timeout'); finish(); }, 3000);
});
