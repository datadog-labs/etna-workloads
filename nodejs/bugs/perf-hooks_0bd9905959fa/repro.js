const { PerformanceObserver } = require('perf_hooks');
const dns = require('dns');

const a = new PerformanceObserver(() => {});
a.observe({ type: 'dns' });
a.observe({ type: 'dns' });
a.disconnect();

const b = new PerformanceObserver(() => {});
b.observe({ entryTypes: ['dns', 'dns'] });
b.disconnect();

// With no observers left, dns.lookup must not start perf tracking.
const req = dns.lookup('localhost', () => {});
console.log('perf tracking active after disconnect:',
            Object.getOwnPropertySymbols(req).length > 0);
