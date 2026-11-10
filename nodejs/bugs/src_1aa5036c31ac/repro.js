if (process.argv[2] !== 'child') {
  const r = require('child_process').spawnSync(process.execPath, [__filename, 'child'], { stdio: ['ignore', 'inherit', 'ignore'] });
  process.exit(r.status);
}
const inspector = require('inspector');
const http = require('http');
inspector.open(0, '127.0.0.1');
const port = new URL(inspector.url()).port;
const hosts = ['127.0.0.1', '1.2.3.4', '01.2.3.4', '1..2.3', '1.2.3.099', '99999999999.1.1.1', '.1.2.3'];
function get(host) {
  return new Promise((res) => {
    const r = http.request({ host: '127.0.0.1', port, path: '/json/list', headers: { Host: host } }, (m) => {
      m.resume(); m.on('end', () => res(m.statusCode));
    });
    r.on('error', (e) => res('err'));
    r.end();
  });
}
(async () => {
  for (const h of hosts) console.log(h, await get(h));
  inspector.close();
  process.exit(0);
})();
