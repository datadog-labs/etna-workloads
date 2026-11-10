const http = require('http');
const server = http.createServer((req, res) => { res.write('partial'); });
server.listen(0, () => {
  const req = http.get({ port: server.address().port, agent: false }, (res) => {
    res.on('error', () => {});
    res.resume();
    res.setTimeout(200, () => {
      console.log('response timeout emitted');
      req.destroy();
      server.close();
      clearTimeout(guard);
    });
  });
  req.on('error', () => {});
  const guard = setTimeout(() => {
    console.log('response timeout NOT emitted');
    req.destroy();
    server.close();
    process.exitCode = 1;
  }, 2000);
});
