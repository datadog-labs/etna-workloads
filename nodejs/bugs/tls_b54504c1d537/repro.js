const tls = require('tls');
const server = tls.createServer({});
const sc = tls.createSecureContext({});
try {
  server.addContext('example.com', sc);
  console.log('ok', server._contexts.length, server._contexts[0][1] === sc.context);
} catch (e) {
  console.log('threw', e.code, e.message);
}
