const http = require('http');
try {
  const r = http.request({ port: '80', path: '/', headers: { host: [] } });
  console.log('no throw');
  r.on('error', () => {});
  r.destroy();
} catch (e) {
  console.log('threw', e.code);
}
