const { Worker } = require('worker_threads');
const w = new Worker('setInterval(()=>{},1000)', { eval: true });
w.on('online', () => {
  const log = [];
  const mk = (n) => w.cpuUsage()
    .then(() => log.push(n + '1'))
    .then(() => log.push(n + '2'));
  const p = [mk('A'), mk('B')];
  // Block so both native immediates are queued before the next loop drain.
  const end = Date.now() + 500;
  while (Date.now() < end);
  Promise.all(p).then(() => {
    console.log(log.join(' '));
    w.terminate();
  });
});
