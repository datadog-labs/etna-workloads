const ph = require('perf_hooks');
console.log(typeof ph.eventLoopUtilization, typeof ph.timerify);
if (typeof ph.eventLoopUtilization === 'function') {
  const e = ph.eventLoopUtilization();
  console.log(Object.keys(e).join(','));
}
