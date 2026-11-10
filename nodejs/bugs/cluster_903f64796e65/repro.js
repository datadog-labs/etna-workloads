'use strict';
const cluster = require('cluster');
const net = require('net');
if (cluster.isPrimary) {
  const probe = net.createServer().listen(0, '127.0.0.1', () => {
    const port = probe.address().port;
    probe.close(() => {
      const env = { PORT: port };
      const w1 = cluster.fork({ ...env, ID: '1' });
      let w2;
      const timer = setTimeout(() => {
        console.log('timeout');
        process.exit(2);
      }, 20000);
      w1.on('message', (m) => {
        if (m === 'closed1') {
          w2 = cluster.fork({ ...env, ID: '2' });
          w2.on('message', (m2) => { if (m2 === 'started') w1.send('go'); });
        } else if (m.startsWith('result')) {
          console.log(m);
          clearTimeout(timer);
          w1.kill(); if (w2) w2.kill();
          process.exit(0);
        }
      });
    });
  });
} else {
  const port = +process.env.PORT;
  const mk = () => new Promise((res, rej) => {
    const s = net.createServer().on('error', rej);
    s.listen({ port, host: '127.0.0.1' }, () => res(s));
  });
  (async () => {
    const s1 = await mk();
    if (process.env.ID === '2') { process.send('started'); return; }
    let dupErr = 'no error';
    await mk().catch((e) => { dupErr = e.code; });
    console.log('duplicate listen in same worker:', dupErr);
    await new Promise((r) => s1.close(r));
    process.send('closed1');
    process.on('message', async () => {
      let r;
      try { const s2 = await mk(); await new Promise((x) => s2.close(x)); r = 'ok'; }
      catch (e) { r = 'error ' + e.code; }
      process.send('result: ' + r);
    });
  })();
}
