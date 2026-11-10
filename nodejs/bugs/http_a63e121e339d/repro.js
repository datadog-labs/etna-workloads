const http = require('http');
const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Length': 2, 'Keep-Alive': 'timeout=50' });
  res.end('hi');
});
server.keepAliveTimeout = 12010;
server.listen(0, () => {
  const agent = new http.Agent({ keepAlive: true });
  http.get({ port: server.address().port, agent }, (res) => {
    console.log('keep-alive:', res.headers['keep-alive']);
    res.resume();
    server.close(); agent.destroy();
  });
});
