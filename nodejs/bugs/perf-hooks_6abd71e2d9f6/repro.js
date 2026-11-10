const { performance } = require('perf_hooks');
performance.mark('a', { startTime: 30 });
performance.mark('b', { startTime: 10 });
performance.mark('c', { startTime: 20 });
console.log(performance.getEntriesByType('mark').map((e) => e.name).join(','));
console.log(performance.getEntries().map((e) => e.name).join(','));
