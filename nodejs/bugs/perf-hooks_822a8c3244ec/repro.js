const { performance } = require('perf_hooks');
for (let i = 0; i < 200000; i++) performance.mark('m' + i);
try {
  console.log(performance.getEntries().length);
  console.log(performance.getEntriesByType('mark').length);
} catch (e) {
  console.log('error', e.constructor.name);
}
