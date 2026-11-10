const http = require('http');
const server = http.createServer((q, s) => s.end('hi'));
server.listen(0, () => {
  const agent = new http.Agent({ keepAlive: true });
  const req = http.get({ port: server.address().port, agent }, (res) => {
    res.resume();
    res.on('end', () => {
      console.log('end destroyed=', req.destroyed);
    });
  });
  req.on('close', () => {
    console.log('close destroyed=', req.destroyed);
    agent.destroy();
    server.close();
  });
});
