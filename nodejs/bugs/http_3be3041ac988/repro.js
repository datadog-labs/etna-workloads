const http = require('http');
const { PerformanceObserver } = require('perf_hooks');
const srv = http.createServer((q, s) => s.end('ok'));
const obs = new PerformanceObserver((list, o) => {
  for (const e of list.getEntries()) {
    if (e.name !== 'HttpClient') continue;
    console.log(e.detail.req.method, e.detail.req.url.replace(/:\d+/, ':PORT'));
    o.disconnect(); srv.close();
  }
});
obs.observe({ entryTypes: ['http'] });
srv.listen(0, '127.0.0.1', () => {
  http.get({ host: '127.0.0.1', port: srv.address().port, path: '/x' }, (r) => r.resume());
});
