const http = require('http');
const { AsyncLocalStorage } = require('async_hooks');
const als = new AsyncLocalStorage();
const server = http.createServer((req, res) => setTimeout(() => res.end('ok'), 50));
server.listen(0, () => {
  const agent = new http.Agent({ keepAlive: true, maxSockets: 1 });
  const port = server.address().port;
  let done = 0;
  const out = [];
  for (let i = 0; i < 3; i++) {
    als.run('ctx' + i, () => {
      http.get({ port, agent }, (res) => {
        out[i] = 'response ' + i + ' store=' + als.getStore();
        res.resume();
        res.on('end', () => {
          if (++done === 3) {
            console.log(out.join('\n'));
            agent.destroy();
            server.close();
          }
        });
      });
    });
  }
});
