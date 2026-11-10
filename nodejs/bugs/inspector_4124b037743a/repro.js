const { spawn } = require('child_process');
const net = require('net');
const child = spawn(process.execPath, ['--inspect=127.0.0.1:0', '-e', 'setInterval(()=>{},1000)'],
  { stdio: ['ignore', 'ignore', 'pipe'] });
const hosts = ['127.0.0.1', '0x7f.1', '0177.0.0.1', '127.0.0.01', '[::]', '[127.0.0.1]', '0.0.0.0', '[::1]'];
function req(port, h) {
  return new Promise((res) => {
    let d = '';
    const s = net.connect(port, '127.0.0.1', () =>
      s.write(`GET /json/list HTTP/1.1\r\nHost: ${h}\r\nConnection: close\r\n\r\n`));
    s.on('data', (c) => d += c);
    s.on('close', () => res(d.split('\r\n')[0] || 'closed'));
    s.on('error', () => res('error'));
    s.setTimeout(3000, () => s.destroy());
  });
}
let buf = '';
child.stderr.on('data', async (c) => {
  buf += c;
  const m = /ws:\/\/127\.0\.0\.1:(\d+)\//.exec(buf);
  if (!m) return;
  child.stderr.removeAllListeners('data');
  for (const h of hosts) console.log(h, '=>', await req(Number(m[1]), h));
  child.kill();
  process.exit(0);
});
