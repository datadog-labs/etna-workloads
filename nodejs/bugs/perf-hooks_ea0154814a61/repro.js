const { PerformanceObserver } = require('perf_hooks');
const o1 = new PerformanceObserver(() => {});
const o2 = new PerformanceObserver(() => {});
o1.observe({ type: 'gc' });
o2.observe({ type: 'gc' });
o1.disconnect();
o2.disconnect();
console.log('done');
