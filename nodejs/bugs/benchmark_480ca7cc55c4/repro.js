const { IncomingMessage } = require('http');
for (const f of ['CONTENT-TYPE', 'USER-AGENT', 'Set-Cookie']) {
  const dest = {};
  const m = new IncomingMessage(null);
  m._addHeaderLine(f, 'a', dest);
  m._addHeaderLine(f, 'b', dest);
  console.log(f, JSON.stringify(dest));
}
