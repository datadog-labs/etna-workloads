if (process.argv[2] !== 'child') {
  const r = require('child_process').spawnSync(process.execPath,
    ['--expose-internals', __filename, 'child'], { encoding: 'utf8', timeout: 15000 });
  process.stdout.write(r.stdout);
  process.exit(0);
}
const net = require('net');
const StreamWrap = require('internal/js_stream_socket');
const ev = [];
const timer = setTimeout(() => { console.log(ev.join('\n')); console.log('timeout'); process.exit(0); }, 3000);
const server = net.createServer((s) => {
  s.on('error', () => {});
  s.on('end', () => ev.push('server end'));
  s.on('close', () => { ev.push('server close'); server.close(); });
});
server.listen(0, () => {
  let wrap;
  const sock = net.connect(server.address().port, () => {
    sock.on('close', () => ev.push('client socket close'));
    wrap.on('close', () => {
      ev.push('wrap close');
      setTimeout(() => { clearTimeout(timer); console.log(ev.sort().join('\n')); process.exit(0); }, 500);
    });
    // Destroy the client socket; the wrap should close too, and vice versa.
    wrap.destroy();
  });
  wrap = new StreamWrap(sock);
});
