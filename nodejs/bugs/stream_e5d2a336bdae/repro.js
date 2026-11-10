const net = require('net');
(async () => {
  let res; const p = new Promise((r) => { res = r; });
  const server = net.createServer({ allowHalfOpen: true }, res);
  await new Promise((r) => server.listen(0, '127.0.0.1', r));
  const c = net.createConnection({ port: server.address().port, host: '127.0.0.1' });
  await new Promise((r) => c.end('data', r));
  const s = await p;
  let data = '';
  for await (const chunk of s) data += chunk;
  console.log(data, 'destroyed after iteration:', s.destroyed);
  s.destroy(); c.destroy();
  await new Promise((r) => server.close(r));
})();
