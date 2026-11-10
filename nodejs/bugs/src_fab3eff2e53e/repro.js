'use strict';
const asyncHooks = require('async_hooks');
const http = require('http');
asyncHooks.createHook({ after: () => {} }).enable();
process.once('uncaughtException', (e) => {
  console.log('uncaught', e.message);
  server.close();
});
process.on('exit', (c) => console.log('exit', c));
setTimeout(() => { console.log('hung: uncaughtException never fired'); process.exit(1); }, 3000).unref();
const server = http.createServer((req, res) => { res.writeHead(200); res.end(); });
server.listen(0, () => {
  http.get({ host: 'localhost', port: server.address().port }, () => {
    throw new Error('whoah');
  });
});
