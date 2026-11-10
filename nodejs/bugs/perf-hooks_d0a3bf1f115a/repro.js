const { performance } = require('perf_hooks');
performance.mark('A');
try {
  const m = performance.measure('one', 'A');
  console.log('ok', m.name, typeof m.duration);
} catch (e) { console.log('err', e.code || e.message); }
try {
  const m = performance.measure('none');
  console.log('ok', m.name, typeof m.duration);
} catch (e) { console.log('err', e.code || e.message); }
