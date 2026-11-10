'use strict';
const async_hooks = require('async_hooks');
const http = require('http');
const types = new Map();
const destroyed = new Set();
async_hooks.createHook({
  init(id, type) { types.set(id, type); },
  destroy(id) { destroyed.add(id); },
}).enable();

const agent = new http.Agent({ keepAlive: true, maxSockets: 1 });
const server = http.createServer((req, res) => { req.resume(); req.on('end', () => res.end('ok')); });
server.listen(0, () => {
  const port = server.address().port;
  const get = (cb) => http.get({ agent, port }, (res) => {
    res.resume();
    res.on('end', () => setImmediate(cb));
  });
  get(() => get(() => setImmediate(() => {
    const per = {};
    for (const [id, t] of types) {
      if (t !== 'TCPWRAP' && t !== 'HTTPINCOMINGMESSAGE' && t !== 'HTTPCLIENTREQUEST' && t !== 'HTTPSERVERREQUEST') continue;
      per[t] ??= { init: 0, destroyed: 0 };
      per[t].init++;
      if (destroyed.has(id)) per[t].destroyed++;
    }
    console.log(JSON.stringify(per, Object.keys(per).sort().concat(['init', 'destroyed'])));
    server.close();
    agent.destroy();
  })));
});
