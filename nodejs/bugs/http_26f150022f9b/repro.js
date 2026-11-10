'use strict';
const http = require('http');
const { HTTPParser } = require('_http_common');
const kOnTimeout = HTTPParser.kOnTimeout | 0;
const out = {}; let n = 0;
function done() {
  if (++n < 2) return;
  setImmediate(() => {
    console.log('server kOnTimeout:', out.server === null ? null : typeof out.server);
    console.log('client onIncoming:', out.client === null ? null : typeof out.client);
  });
}
const server = http.createServer((req, res) => {
  const parser = req.socket.parser;
  req.socket.on('close', () => {
    out.server = parser[kOnTimeout]; done();
  });
  res.end();
  server.close();
});
server.listen(0, () => {
  const req = http.get({ port: server.address().port, headers: { Connection: 'close' } });
  let parser;
  req.on('socket', () => { parser = req.parser; });
  req.on('response', (res) => {
    res.resume();
    res.on('end', () => {
      out.client = parser.onIncoming; done();
    });
  });
});
