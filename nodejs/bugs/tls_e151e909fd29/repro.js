const tls = require('tls');
const server = tls.createServer({});
for (const arg of [undefined, 'abc', {}, Buffer.alloc(10), Buffer.alloc(47), Buffer.alloc(49)]) {
  try { server.setTicketKeys(arg); console.log('no throw'); }
  catch (e) { console.log(e.name, e.code); }
}
server.setTicketKeys(Buffer.alloc(48));
console.log('valid ok');
