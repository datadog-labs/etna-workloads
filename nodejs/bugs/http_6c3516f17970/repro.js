const http = require('http');
const agent = new http.Agent({ keepAlive: true });
const fake = { on(ev, fn) { console.log('listen', ev); } };
agent.sockets['a:1'] = [fake];
agent.freeSockets['b:2'] = [fake];
try {
  agent.on('keylog', () => {});
  console.log('ok', agent.listenerCount('keylog'));
} catch (e) {
  console.log('threw', e.constructor.name);
  console.log('count', agent.listenerCount('keylog'));
}
