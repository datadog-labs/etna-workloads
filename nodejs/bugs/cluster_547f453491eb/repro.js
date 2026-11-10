'use strict';
const cp = require('child_process');
if (!process.env.REPRO_CHILD) {
  const r = cp.spawnSync(process.execPath, ['--expose-internals', __filename],
                         { env: { ...process.env, REPRO_CHILD: '1' }, encoding: 'utf8', timeout: 20000 });
  console.log('exit', r.status, r.signal);
  console.log('stdout:', r.stdout.trim());
  console.log('threw:', /TypeError|Error/.test(r.stderr));
  return;
}
const net = require('net');
const cluster = require('cluster');
const rr = require('internal/cluster/round_robin_handle');
if (cluster.isPrimary) {
  const orig = rr.prototype.distribute;
  rr.prototype.distribute = function(err, handle) {
    handle.close();
    orig.call(this, -1, undefined);
  };
  cluster.schedulingPolicy = cluster.SCHED_RR;
  cluster.fork().on('exit', () => console.log('worker exited'));
} else {
  const server = net.createServer();
  server.listen(0, () => {
    const s = net.connect(server.address().port);
    s.on('close', () => server.close(() => process.disconnect()));
  });
}
