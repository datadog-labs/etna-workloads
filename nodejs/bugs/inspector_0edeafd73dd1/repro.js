if (!process.argv.includes('--child')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--experimental-network-inspection', __filename, '--child'], { stdio: 'inherit' });
  process.exit(r.status);
}
const inspector = require('node:inspector');
const { Network } = inspector;
const session = new inspector.Session();
session.connect();
const v = 'CJK 汉字 🍱 🧑‍🧑‍🧒‍🧒';
session.post('Network.enable', () => {
  session.on('Network.requestWillBeSent', ({ params }) => {
    const h = params.request.headers.mKey;
    console.log(h === v ? 'ok' : 'mismatch', JSON.stringify(h));
    process.exit(h === v ? 0 : 1);
  });
  Network.requestWillBeSent({
    requestId: '1', timestamp: 1, wallTime: 1,
    request: { url: v, method: v, headers: { mKey: v } },
  });
});
setTimeout(() => { console.log('timeout'); process.exit(2); }, 10000);
