const dc = require('diagnostics_channel');
const http = require('http');
let got = 0;
dc.subscribe('http.client.request.created', ({ request }) => {
  got++;
  console.log('created:', request.constructor.name, request.method, request.path);
});
const server = http.createServer((req, res) => res.end('ok'));
server.listen(0, () => {
  const req = http.get({ port: server.address().port, path: '/x' }, (res) => {
    res.resume();
    res.on('end', () => {
      console.log('events:', got);
      server.close();
    });
  });
});
