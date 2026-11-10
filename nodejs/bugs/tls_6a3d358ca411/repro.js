'use strict';
const tls = require('tls');
const net = require('net');
const server = net.createServer((c) => c.destroy());
server.listen(0, () => {
  const s = tls.connect({
    port: server.address().port,
    keepAlive: true, keepAliveInitialDelay: 1000, noDelay: true,
  });
  s.on('error', () => {});
  for (const sym of Object.getOwnPropertySymbols(s)) {
    const d = sym.description;
    if (/^kSetNoDelay|^kSetKeepAlive/.test(d)) console.log(d, s[sym]);
  }
  s.destroy(); server.close();
});
