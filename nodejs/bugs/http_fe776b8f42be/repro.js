'use strict';
const http = require('http');
const agent = new http.Agent({ keepAlive: true, keepAliveMsecs: 1234 });
const server = http.createServer((req, res) => res.end('ok'));
server.listen(0, () => {
  const cc = agent.createConnection;
  agent.createConnection = (options, ...args) => {
    console.log('keepAlive:', options.keepAlive);
    console.log('keepAliveInitialDelay:', options.keepAliveInitialDelay);
    return cc.call(agent, options, ...args);
  };
  http.get({ port: server.address().port, agent, path: '/' }, (res) => {
    res.resume();
    res.on('end', () => { agent.destroy(); server.close(); });
  });
});
