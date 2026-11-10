const http = require('http');
const { listenerCount } = require('events');
const server = http.createServer();
server.listen(0, () => {
  const ac = new AbortController();
  const req = http.get({ port: server.address().port, signal: ac.signal });
  console.log('abort listeners:', listenerCount(ac.signal, 'abort'));
  req.on('error', (e) => {
    console.log(e.name);
    server.close();
  });
  ac.abort();
});
