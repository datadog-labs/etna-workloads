const { monitorEventLoopDelay } = require('perf_hooks');
const h = monitorEventLoopDelay({ resolution: 2 ** 32 + 1 });
h.enable();
setTimeout(() => {
  h.disable();
  console.log('sampled:', h.count > 0);
}, 300);
