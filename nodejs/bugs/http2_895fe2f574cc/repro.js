'use strict';
const h2 = require('http2');
process.on('uncaughtException', (e) => { console.log('uncaught:', e.constructor.name, e.message); process.exit(1); });
const server = h2.createServer();
server.listen(0, '127.0.0.1', () => {
  const s = h2.connect(`http://127.0.0.1:${server.address().port}`, (session) => {
    session.request({ ':method': 'POST' }).end(() => {
      session.destroy();
      server.close();
    });
  });
});
process.on('exit', () => console.log('done'));
