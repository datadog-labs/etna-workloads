'use strict';
const dgram = require('dgram');
const dns = require('dns');
const N = 257;
function name(d) {
  const parts = d.split('.');
  return Buffer.concat([...parts.map((p) => Buffer.concat([Buffer.from([p.length]), Buffer.from(p)])), Buffer.from([0])]);
}
const server = dgram.createSocket('udp4');
server.on('message', (msg, { address, port }) => {
  const qend = 12 + name('many-a.example.org').length + 4;
  const q = msg.subarray(12, qend);
  const hdr = Buffer.alloc(12);
  msg.copy(hdr, 0, 0, 2);
  hdr.writeUInt16BE(0x8180, 2);
  hdr.writeUInt16BE(1, 4);
  hdr.writeUInt16BE(N, 6);
  const rrs = [];
  for (let i = 0; i < N; i++) {
    const rr = Buffer.alloc(16);
    rr.writeUInt16BE(0xc00c, 0);
    rr.writeUInt16BE(1, 2);
    rr.writeUInt16BE(1, 4);
    rr.writeUInt32BE(60 + i, 6);
    rr.writeUInt16BE(4, 10);
    rr[12] = 10; rr[13] = 0; rr[14] = i >> 8; rr[15] = i & 255;
    rrs.push(rr);
  }
  server.send(Buffer.concat([hdr, q, ...rrs]), port, address);
});
server.bind(0, '127.0.0.1', () => {
  const r = new dns.Resolver({ timeout: 2000, tries: 1 });
  r.setServers([`127.0.0.1:${server.address().port}`]);
  r.resolveAny('many-a.example.org', (err, recs) => {
    console.log(err ? err.code : `count=${recs.length}`);
    if (recs) console.log(recs[256]);
    server.close();
  });
});
