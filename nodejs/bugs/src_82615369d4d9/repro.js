'use strict';
const http2 = require('http2');
const net = require('net');
const server = http2.createServer();
let sessionClosed = false, sessionErr = false;
server.on('session', (s) => {
  s.on('error', () => { sessionErr = true; });
  s.on('close', () => { sessionClosed = true; });
});
server.listen(0, () => {
  const conn = net.connect({ port: server.address().port, allowHalfOpen: true });
  conn.on('error', () => {});
  conn.write('PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n');
  const s = Buffer.alloc(9); s[3] = 4; conn.write(s);
  let buf = Buffer.alloc(0), done = false;
  conn.on('data', (c) => {
    buf = Buffer.concat([buf, c]);
    if (done || buf.length < 9) return;
    const len = buf.readUIntBE(0, 3);
    if (buf.length < 9 + len) return;
    done = true;
    const ack = Buffer.alloc(9); ack[3] = 4; ack[4] = 1; conn.write(ack);
    const w = Buffer.alloc(13);
    w.writeUIntBE(4, 0, 3); w[3] = 8; w.writeUIntBE(0x7FFFFFFF, 9, 4);
    conn.write(w);
  });
  conn.on('end', () => conn.end());
  setTimeout(() => {
    console.log('session error emitted:', sessionErr);
    console.log('session closed:', sessionClosed);
    conn.destroy(); server.close(); process.exit(0);
  }, 2000);
});
