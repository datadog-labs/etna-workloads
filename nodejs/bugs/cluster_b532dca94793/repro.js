'use strict';
const cluster = require('cluster');
const net = require('net');
if (cluster.isPrimary) {
  cluster.schedulingPolicy = cluster.SCHED_RR;
  cluster.fork().on('exit', (c) => console.log('worker exit', c));
} else {
  const server = net.createServer(() => console.log('unexpected connection'));
  server.listen(0, () => net.connect(server.address().port).on('error', () => {}));
  const t = setTimeout(() => { console.log('handle.close NOT called (leak)'); process.exit(1); }, 3000);
  process.prependListener('internalMessage', (message, handle) => {
    if (message.act !== 'newconn') return;
    server.close();
    const close = handle.close;
    handle.close = () => {
      console.log('handle.close called');
      close.call(handle, () => { clearTimeout(t); process.exit(0); });
    };
  });
}
